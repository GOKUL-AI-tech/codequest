-- ============================================================
-- CodeQuest - Supabase PostgreSQL Schema
-- Migration: 001_initial_schema.sql
-- ============================================================

-- Enable required extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "pg_trgm"; -- For full-text search

-- ============================================================
-- ENUMS
-- ============================================================
CREATE TYPE language_type AS ENUM ('python', 'javascript', 'dart', 'java', 'cpp', 'c');
CREATE TYPE lesson_type AS ENUM ('theory', 'quiz', 'coding', 'boss_battle');
CREATE TYPE difficulty_level AS ENUM ('beginner', 'intermediate', 'advanced', 'expert');
CREATE TYPE achievement_category AS ENUM ('learning', 'streak', 'social', 'battle', 'collection', 'special');
CREATE TYPE battle_status AS ENUM ('waiting', 'in_progress', 'completed', 'cancelled');
CREATE TYPE tournament_status AS ENUM ('upcoming', 'active', 'completed', 'cancelled');
CREATE TYPE notification_type AS ENUM ('streak', 'achievement', 'friend_request', 'battle_invite', 'tournament', 'xp_reward', 'daily_mission', 'announcement');
CREATE TYPE transaction_type AS ENUM ('earn_xp', 'earn_coins', 'spend_coins', 'level_up', 'achievement', 'purchase');
CREATE TYPE subscription_tier AS ENUM ('free', 'premium', 'elite');

-- ============================================================
-- PROFILES TABLE (extends Supabase auth.users)
-- ============================================================
CREATE TABLE profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    username TEXT UNIQUE NOT NULL,
    display_name TEXT,
    avatar_url TEXT,
    bio TEXT,
    character_id TEXT NOT NULL DEFAULT 'cyber_ninja',
    favorite_language language_type NOT NULL DEFAULT 'python',

    -- Game Stats
    level INTEGER NOT NULL DEFAULT 1,
    xp INTEGER NOT NULL DEFAULT 0,
    coins INTEGER NOT NULL DEFAULT 100,
    streak INTEGER NOT NULL DEFAULT 0,
    max_streak INTEGER NOT NULL DEFAULT 0,
    lives INTEGER NOT NULL DEFAULT 5,
    last_life_refill TIMESTAMPTZ DEFAULT NOW(),
    last_streak_date DATE,
    rank_title TEXT NOT NULL DEFAULT 'Script Kiddie',

    -- Progress
    total_lessons_completed INTEGER NOT NULL DEFAULT 0,
    total_challenges_completed INTEGER NOT NULL DEFAULT 0,
    total_battles_won INTEGER NOT NULL DEFAULT 0,
    total_xp_earned INTEGER NOT NULL DEFAULT 0,

    -- Subscription
    subscription_tier subscription_tier NOT NULL DEFAULT 'free',
    subscription_expires_at TIMESTAMPTZ,

    -- Settings
    notifications_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    sound_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    haptics_enabled BOOLEAN NOT NULL DEFAULT TRUE,

    -- Timestamps
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_active_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_profiles_username ON profiles USING gin(username gin_trgm_ops);
CREATE INDEX idx_profiles_xp ON profiles(xp DESC);
CREATE INDEX idx_profiles_level ON profiles(level DESC);
CREATE INDEX idx_profiles_streak ON profiles(streak DESC);

-- ============================================================
-- LANGUAGES TABLE
-- ============================================================
CREATE TABLE languages (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    icon TEXT NOT NULL,
    color_hex TEXT NOT NULL,
    difficulty difficulty_level NOT NULL,
    description TEXT,
    total_levels INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    order_index INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- CHAPTERS TABLE
-- ============================================================
CREATE TABLE chapters (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    language_id TEXT NOT NULL REFERENCES languages(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    icon_emoji TEXT NOT NULL DEFAULT '📚',
    order_index INTEGER NOT NULL DEFAULT 0,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    xp_reward INTEGER NOT NULL DEFAULT 0,
    unlock_requirement INTEGER NOT NULL DEFAULT 0, -- min level to unlock
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_chapters_language ON chapters(language_id, order_index);

-- ============================================================
-- LESSONS TABLE
-- ============================================================
CREATE TABLE lessons (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    chapter_id UUID NOT NULL REFERENCES chapters(id) ON DELETE CASCADE,
    language_id TEXT NOT NULL REFERENCES languages(id),
    title TEXT NOT NULL,
    description TEXT,
    type lesson_type NOT NULL DEFAULT 'theory',
    difficulty difficulty_level NOT NULL DEFAULT 'beginner',
    order_index INTEGER NOT NULL DEFAULT 0,
    content TEXT, -- Markdown/rich text
    xp_reward INTEGER NOT NULL DEFAULT 50,
    coin_reward INTEGER NOT NULL DEFAULT 10,
    estimated_minutes INTEGER NOT NULL DEFAULT 10,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    tags TEXT[] DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_lessons_chapter ON lessons(chapter_id, order_index);
CREATE INDEX idx_lessons_language ON lessons(language_id);

-- ============================================================
-- QUIZ QUESTIONS TABLE
-- ============================================================
CREATE TABLE quiz_questions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    options JSONB NOT NULL, -- ["option1", "option2", "option3", "option4"]
    correct_option_index INTEGER NOT NULL,
    explanation TEXT,
    code_snippet TEXT,
    order_index INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_quiz_questions_lesson ON quiz_questions(lesson_id, order_index);

-- ============================================================
-- CODING CHALLENGES TABLE
-- ============================================================
CREATE TABLE coding_challenges (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    lesson_id UUID REFERENCES lessons(id) ON DELETE SET NULL,
    language_id TEXT NOT NULL REFERENCES languages(id),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    starter_code TEXT NOT NULL,
    solution_code TEXT NOT NULL,
    time_limit_seconds INTEGER NOT NULL DEFAULT 30,
    memory_limit_mb INTEGER NOT NULL DEFAULT 256,
    hints JSONB DEFAULT '[]',
    difficulty difficulty_level NOT NULL DEFAULT 'beginner',
    xp_reward INTEGER NOT NULL DEFAULT 100,
    coin_reward INTEGER NOT NULL DEFAULT 25,
    is_arena_challenge BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- TEST CASES TABLE
-- ============================================================
CREATE TABLE test_cases (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    challenge_id UUID NOT NULL REFERENCES coding_challenges(id) ON DELETE CASCADE,
    input TEXT NOT NULL,
    expected_output TEXT NOT NULL,
    is_hidden BOOLEAN NOT NULL DEFAULT FALSE,
    order_index INTEGER NOT NULL DEFAULT 0
);

CREATE INDEX idx_test_cases_challenge ON test_cases(challenge_id);

-- ============================================================
-- USER PROGRESS TABLE
-- ============================================================
CREATE TABLE user_progress (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    score INTEGER,
    xp_earned INTEGER NOT NULL DEFAULT 0,
    coins_earned INTEGER NOT NULL DEFAULT 0,
    attempts INTEGER NOT NULL DEFAULT 0,
    time_spent_seconds INTEGER NOT NULL DEFAULT 0,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, lesson_id)
);

CREATE INDEX idx_user_progress_user ON user_progress(user_id);
CREATE INDEX idx_user_progress_lesson ON user_progress(lesson_id);
CREATE INDEX idx_user_progress_completed ON user_progress(user_id, is_completed);

-- ============================================================
-- ACHIEVEMENTS TABLE
-- ============================================================
CREATE TABLE achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    icon_emoji TEXT NOT NULL DEFAULT '🏆',
    category achievement_category NOT NULL,
    xp_reward INTEGER NOT NULL DEFAULT 50,
    coin_reward INTEGER NOT NULL DEFAULT 20,
    required_count INTEGER NOT NULL DEFAULT 1,
    is_rare BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- USER ACHIEVEMENTS TABLE
-- ============================================================
CREATE TABLE user_achievements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    achievement_id UUID NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
    current_count INTEGER NOT NULL DEFAULT 0,
    is_unlocked BOOLEAN NOT NULL DEFAULT FALSE,
    unlocked_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, achievement_id)
);

CREATE INDEX idx_user_achievements_user ON user_achievements(user_id);
CREATE INDEX idx_user_achievements_unlocked ON user_achievements(user_id, is_unlocked);

-- ============================================================
-- DAILY MISSIONS TABLE
-- ============================================================
CREATE TABLE daily_missions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT NOT NULL,
    icon_emoji TEXT NOT NULL DEFAULT '🎯',
    xp_reward INTEGER NOT NULL DEFAULT 150,
    coin_reward INTEGER NOT NULL DEFAULT 50,
    required_count INTEGER NOT NULL DEFAULT 1,
    mission_type TEXT NOT NULL, -- 'complete_lessons', 'solve_challenges', 'win_battles', etc.
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- ============================================================
-- USER DAILY MISSIONS TABLE
-- ============================================================
CREATE TABLE user_daily_missions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    mission_id UUID NOT NULL REFERENCES daily_missions(id) ON DELETE CASCADE,
    current_count INTEGER NOT NULL DEFAULT 0,
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    expires_at TIMESTAMPTZ NOT NULL,
    completed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, mission_id, expires_at)
);

CREATE INDEX idx_user_daily_missions_user ON user_daily_missions(user_id, expires_at);

-- ============================================================
-- XP / COIN TRANSACTION LOGS
-- ============================================================
CREATE TABLE xp_logs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    amount INTEGER NOT NULL,
    transaction_type transaction_type NOT NULL,
    description TEXT,
    reference_id UUID, -- lesson_id, challenge_id, etc.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_xp_logs_user ON xp_logs(user_id, created_at DESC);

-- ============================================================
-- LEADERBOARD (Materialized View refreshed periodically)
-- ============================================================
CREATE TABLE leaderboard_snapshots (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    username TEXT NOT NULL,
    avatar_url TEXT,
    character_id TEXT NOT NULL,
    xp INTEGER NOT NULL,
    level INTEGER NOT NULL,
    rank_title TEXT NOT NULL,
    streak INTEGER NOT NULL,
    week_xp INTEGER NOT NULL DEFAULT 0,
    snapshot_type TEXT NOT NULL DEFAULT 'global', -- 'global', 'weekly', 'language'
    language_id TEXT,
    rank_position INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_leaderboard_global ON leaderboard_snapshots(snapshot_type, xp DESC);
CREATE INDEX idx_leaderboard_weekly ON leaderboard_snapshots(snapshot_type, week_xp DESC);

-- ============================================================
-- FRIENDS TABLE
-- ============================================================
CREATE TABLE friendships (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    requester_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    addressee_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    is_accepted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    accepted_at TIMESTAMPTZ,
    UNIQUE(requester_id, addressee_id),
    CHECK(requester_id != addressee_id)
);

CREATE INDEX idx_friendships_requester ON friendships(requester_id, is_accepted);
CREATE INDEX idx_friendships_addressee ON friendships(addressee_id, is_accepted);

-- ============================================================
-- CHATS TABLE
-- ============================================================
CREATE TABLE chat_rooms (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT,
    is_direct_message BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE chat_participants (
    room_id UUID NOT NULL REFERENCES chat_rooms(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    last_read_at TIMESTAMPTZ,
    PRIMARY KEY(room_id, user_id)
);

CREATE TABLE chat_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    room_id UUID NOT NULL REFERENCES chat_rooms(id) ON DELETE CASCADE,
    sender_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    message_type TEXT NOT NULL DEFAULT 'text', -- 'text', 'code', 'achievement', 'system'
    metadata JSONB DEFAULT '{}',
    is_deleted BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_chat_messages_room ON chat_messages(room_id, created_at DESC);

-- ============================================================
-- NOTIFICATIONS TABLE
-- ============================================================
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    type notification_type NOT NULL,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    metadata JSONB DEFAULT '{}',
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_notifications_user ON notifications(user_id, is_read, created_at DESC);

-- ============================================================
-- CODING BATTLES TABLE
-- ============================================================
CREATE TABLE coding_battles (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    challenge_id UUID NOT NULL REFERENCES coding_challenges(id),
    status battle_status NOT NULL DEFAULT 'waiting',
    max_players INTEGER NOT NULL DEFAULT 2,
    time_limit_seconds INTEGER NOT NULL DEFAULT 300,
    xp_reward INTEGER NOT NULL DEFAULT 200,
    coin_reward INTEGER NOT NULL DEFAULT 100,
    created_by UUID NOT NULL REFERENCES profiles(id),
    started_at TIMESTAMPTZ,
    ended_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE battle_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    battle_id UUID NOT NULL REFERENCES coding_battles(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    submission_code TEXT,
    submission_time TIMESTAMPTZ,
    score INTEGER NOT NULL DEFAULT 0,
    tests_passed INTEGER NOT NULL DEFAULT 0,
    is_winner BOOLEAN NOT NULL DEFAULT FALSE,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(battle_id, user_id)
);

CREATE INDEX idx_battle_participants_battle ON battle_participants(battle_id);
CREATE INDEX idx_battle_participants_user ON battle_participants(user_id);

-- ============================================================
-- TOURNAMENTS TABLE
-- ============================================================
CREATE TABLE tournaments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title TEXT NOT NULL,
    description TEXT,
    language_id TEXT REFERENCES languages(id),
    status tournament_status NOT NULL DEFAULT 'upcoming',
    max_participants INTEGER NOT NULL DEFAULT 100,
    entry_fee_coins INTEGER NOT NULL DEFAULT 0,
    prize_pool_xp INTEGER NOT NULL DEFAULT 1000,
    prize_pool_coins INTEGER NOT NULL DEFAULT 500,
    starts_at TIMESTAMPTZ NOT NULL,
    ends_at TIMESTAMPTZ NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE tournament_participants (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tournament_id UUID NOT NULL REFERENCES tournaments(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    score INTEGER NOT NULL DEFAULT 0,
    rank_position INTEGER,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(tournament_id, user_id)
);

-- ============================================================
-- SHOP ITEMS TABLE
-- ============================================================
CREATE TABLE shop_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    description TEXT,
    item_type TEXT NOT NULL, -- 'character', 'theme', 'badge', 'powerup', 'lootbox'
    icon_url TEXT,
    price_coins INTEGER,
    price_real DECIMAL(10,2),
    is_premium BOOLEAN NOT NULL DEFAULT FALSE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE user_inventory (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    item_id UUID NOT NULL REFERENCES shop_items(id) ON DELETE CASCADE,
    is_equipped BOOLEAN NOT NULL DEFAULT FALSE,
    purchased_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, item_id)
);

-- ============================================================
-- AI MENTOR CONVERSATIONS TABLE
-- ============================================================
CREATE TABLE ai_conversations (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    title TEXT,
    language_id TEXT REFERENCES languages(id),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE ai_messages (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    conversation_id UUID NOT NULL REFERENCES ai_conversations(id) ON DELETE CASCADE,
    role TEXT NOT NULL, -- 'user' | 'assistant'
    content TEXT NOT NULL,
    tokens_used INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_ai_messages_conversation ON ai_messages(conversation_id, created_at);

-- ============================================================
-- GUILDS TABLE
-- ============================================================
CREATE TABLE guilds (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    emblem_emoji TEXT NOT NULL DEFAULT '🏰',
    leader_id UUID NOT NULL REFERENCES profiles(id),
    max_members INTEGER NOT NULL DEFAULT 50,
    total_xp INTEGER NOT NULL DEFAULT 0,
    is_public BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE guild_members (
    guild_id UUID NOT NULL REFERENCES guilds(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
    role TEXT NOT NULL DEFAULT 'member', -- 'leader', 'officer', 'member'
    contribution_xp INTEGER NOT NULL DEFAULT 0,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(guild_id, user_id)
);

-- ============================================================
-- UPDATED_AT TRIGGER
-- ============================================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_profiles_updated_at BEFORE UPDATE ON profiles
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_chapters_updated_at BEFORE UPDATE ON chapters
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_lessons_updated_at BEFORE UPDATE ON lessons
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_user_progress_updated_at BEFORE UPDATE ON user_progress
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ============================================================
-- AUTO-CREATE PROFILE ON SIGNUP
-- ============================================================
CREATE OR REPLACE FUNCTION handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profiles (id, username, display_name, avatar_url)
    VALUES (
        NEW.id,
        COALESCE(
            NEW.raw_user_meta_data->>'username',
            'player_' || substr(NEW.id::text, 1, 8)
        ),
        COALESCE(NEW.raw_user_meta_data->>'full_name', 'New Player'),
        NEW.raw_user_meta_data->>'avatar_url'
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION handle_new_user();

-- ============================================================
-- XP GAIN FUNCTION
-- ============================================================
CREATE OR REPLACE FUNCTION award_xp(
    p_user_id UUID,
    p_xp_amount INTEGER,
    p_coins_amount INTEGER,
    p_transaction_type transaction_type,
    p_description TEXT DEFAULT NULL,
    p_reference_id UUID DEFAULT NULL
)
RETURNS JSONB AS $$
DECLARE
    v_current_xp INTEGER;
    v_current_level INTEGER;
    v_new_xp INTEGER;
    v_new_level INTEGER;
    v_level_up BOOLEAN := FALSE;
    v_xp_thresholds INTEGER[] := ARRAY[100,250,500,900,1400,2100,3000,4200,5700,7500,9800,12600,16000,20100,25000,31000,38200,46800,57000,70000];
BEGIN
    SELECT xp, level INTO v_current_xp, v_current_level FROM profiles WHERE id = p_user_id;

    v_new_xp := v_current_xp + p_xp_amount;
    v_new_level := v_current_level;

    -- Check for level up
    WHILE v_new_level < 20 AND v_new_xp >= v_xp_thresholds[v_new_level] LOOP
        v_new_level := v_new_level + 1;
        v_level_up := TRUE;
    END LOOP;

    -- Update rank title
    DECLARE
        v_rank_title TEXT;
    BEGIN
        v_rank_title := CASE
            WHEN v_new_xp >= 150000 THEN 'Grand Architect'
            WHEN v_new_xp >= 75000 THEN 'Code Legend'
            WHEN v_new_xp >= 30000 THEN 'Cyber Warrior'
            WHEN v_new_xp >= 12000 THEN 'Syntax Samurai'
            WHEN v_new_xp >= 5000 THEN 'Algorithm Adept'
            WHEN v_new_xp >= 2000 THEN 'Bug Hunter'
            WHEN v_new_xp >= 500 THEN 'Code Apprentice'
            ELSE 'Script Kiddie'
        END;

        UPDATE profiles SET
            xp = v_new_xp,
            level = v_new_level,
            coins = coins + p_coins_amount,
            total_xp_earned = total_xp_earned + p_xp_amount,
            rank_title = v_rank_title,
            last_active_at = NOW()
        WHERE id = p_user_id;
    END;

    -- Log transaction
    INSERT INTO xp_logs (user_id, amount, transaction_type, description, reference_id)
    VALUES (p_user_id, p_xp_amount, p_transaction_type, p_description, p_reference_id);

    RETURN jsonb_build_object(
        'xp_gained', p_xp_amount,
        'new_xp', v_new_xp,
        'new_level', v_new_level,
        'level_up', v_level_up,
        'old_level', v_current_level
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- ============================================================
-- STREAK UPDATE FUNCTION
-- ============================================================
CREATE OR REPLACE FUNCTION update_streak(p_user_id UUID)
RETURNS INTEGER AS $$
DECLARE
    v_last_streak_date DATE;
    v_current_streak INTEGER;
    v_today DATE := CURRENT_DATE;
BEGIN
    SELECT last_streak_date, streak INTO v_last_streak_date, v_current_streak
    FROM profiles WHERE id = p_user_id;

    IF v_last_streak_date = v_today - 1 THEN
        -- Continue streak
        v_current_streak := v_current_streak + 1;
    ELSIF v_last_streak_date = v_today THEN
        -- Already counted today
        RETURN v_current_streak;
    ELSE
        -- Reset streak
        v_current_streak := 1;
    END IF;

    UPDATE profiles SET
        streak = v_current_streak,
        max_streak = GREATEST(max_streak, v_current_streak),
        last_streak_date = v_today
    WHERE id = p_user_id;

    RETURN v_current_streak;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;
