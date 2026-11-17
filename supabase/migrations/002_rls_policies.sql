-- ============================================================
-- CodeQuest - Row Level Security (RLS) Policies
-- Migration: 002_rls_policies.sql
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_daily_missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE xp_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE friendships ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_rooms ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE battle_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE tournament_participants ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE ai_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE guild_members ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- PROFILES POLICIES
-- ============================================================
-- Users can view all profiles (for leaderboard/social)
CREATE POLICY "profiles_select_all" ON profiles
    FOR SELECT USING (TRUE);

-- Users can only update their own profile
CREATE POLICY "profiles_update_own" ON profiles
    FOR UPDATE USING (auth.uid() = id);

-- Users can only insert their own profile (handled by trigger)
CREATE POLICY "profiles_insert_own" ON profiles
    FOR INSERT WITH CHECK (auth.uid() = id);

-- ============================================================
-- LANGUAGES + CHAPTERS + LESSONS (public read)
-- ============================================================
CREATE POLICY "languages_select_all" ON languages FOR SELECT USING (is_active = TRUE);
CREATE POLICY "chapters_select_all" ON chapters FOR SELECT USING (is_active = TRUE);
CREATE POLICY "lessons_select_all" ON lessons FOR SELECT USING (is_active = TRUE);
CREATE POLICY "quiz_questions_select_all" ON quiz_questions FOR SELECT USING (TRUE);
CREATE POLICY "coding_challenges_select_all" ON coding_challenges FOR SELECT USING (is_active = TRUE);
CREATE POLICY "test_cases_select_visible" ON test_cases FOR SELECT USING (is_hidden = FALSE);
CREATE POLICY "achievements_select_all" ON achievements FOR SELECT USING (is_active = TRUE);
CREATE POLICY "daily_missions_select_all" ON daily_missions FOR SELECT USING (is_active = TRUE);
CREATE POLICY "shop_items_select_all" ON shop_items FOR SELECT USING (is_active = TRUE);
CREATE POLICY "tournaments_select_all" ON tournaments FOR SELECT USING (TRUE);

-- ============================================================
-- USER PROGRESS POLICIES
-- ============================================================
CREATE POLICY "user_progress_select_own" ON user_progress
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "user_progress_insert_own" ON user_progress
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_progress_update_own" ON user_progress
    FOR UPDATE USING (auth.uid() = user_id);

-- ============================================================
-- USER ACHIEVEMENTS POLICIES
-- ============================================================
CREATE POLICY "user_achievements_select_own" ON user_achievements
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "user_achievements_insert_own" ON user_achievements
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_achievements_update_own" ON user_achievements
    FOR UPDATE USING (auth.uid() = user_id);

-- ============================================================
-- DAILY MISSIONS POLICIES
-- ============================================================
CREATE POLICY "user_daily_missions_select_own" ON user_daily_missions
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "user_daily_missions_upsert_own" ON user_daily_missions
    FOR ALL USING (auth.uid() = user_id);

-- ============================================================
-- XP LOGS POLICIES
-- ============================================================
CREATE POLICY "xp_logs_select_own" ON xp_logs
    FOR SELECT USING (auth.uid() = user_id);

-- ============================================================
-- LEADERBOARD (public read)
-- ============================================================
ALTER TABLE leaderboard_snapshots ENABLE ROW LEVEL SECURITY;
CREATE POLICY "leaderboard_select_all" ON leaderboard_snapshots
    FOR SELECT USING (TRUE);

-- ============================================================
-- FRIENDSHIPS POLICIES
-- ============================================================
CREATE POLICY "friendships_select_involved" ON friendships
    FOR SELECT USING (auth.uid() = requester_id OR auth.uid() = addressee_id);

CREATE POLICY "friendships_insert_own" ON friendships
    FOR INSERT WITH CHECK (auth.uid() = requester_id);

CREATE POLICY "friendships_update_addressee" ON friendships
    FOR UPDATE USING (auth.uid() = addressee_id OR auth.uid() = requester_id);

CREATE POLICY "friendships_delete_involved" ON friendships
    FOR DELETE USING (auth.uid() = requester_id OR auth.uid() = addressee_id);

-- ============================================================
-- CHAT POLICIES
-- ============================================================
CREATE POLICY "chat_rooms_select_participant" ON chat_rooms
    FOR SELECT USING (
        id IN (SELECT room_id FROM chat_participants WHERE user_id = auth.uid())
    );

CREATE POLICY "chat_participants_select_own" ON chat_participants
    FOR SELECT USING (user_id = auth.uid());

CREATE POLICY "chat_messages_select_participant" ON chat_messages
    FOR SELECT USING (
        room_id IN (SELECT room_id FROM chat_participants WHERE user_id = auth.uid())
    );

CREATE POLICY "chat_messages_insert_participant" ON chat_messages
    FOR INSERT WITH CHECK (
        auth.uid() = sender_id AND
        room_id IN (SELECT room_id FROM chat_participants WHERE user_id = auth.uid())
    );

-- ============================================================
-- NOTIFICATIONS POLICIES
-- ============================================================
CREATE POLICY "notifications_select_own" ON notifications
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "notifications_update_own" ON notifications
    FOR UPDATE USING (auth.uid() = user_id);

-- ============================================================
-- BATTLE POLICIES
-- ============================================================
ALTER TABLE coding_battles ENABLE ROW LEVEL SECURITY;
CREATE POLICY "coding_battles_select_all" ON coding_battles
    FOR SELECT USING (TRUE);

CREATE POLICY "coding_battles_insert_auth" ON coding_battles
    FOR INSERT WITH CHECK (auth.uid() = created_by);

CREATE POLICY "battle_participants_select_all" ON battle_participants
    FOR SELECT USING (TRUE);

CREATE POLICY "battle_participants_insert_own" ON battle_participants
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "battle_participants_update_own" ON battle_participants
    FOR UPDATE USING (auth.uid() = user_id);

-- ============================================================
-- TOURNAMENT POLICIES
-- ============================================================
CREATE POLICY "tournament_participants_select_all" ON tournament_participants
    FOR SELECT USING (TRUE);

CREATE POLICY "tournament_participants_insert_own" ON tournament_participants
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- ============================================================
-- INVENTORY POLICIES
-- ============================================================
CREATE POLICY "user_inventory_select_own" ON user_inventory
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "user_inventory_insert_own" ON user_inventory
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_inventory_update_own" ON user_inventory
    FOR UPDATE USING (auth.uid() = user_id);

-- ============================================================
-- AI MENTOR POLICIES
-- ============================================================
CREATE POLICY "ai_conversations_own" ON ai_conversations
    FOR ALL USING (auth.uid() = user_id);

CREATE POLICY "ai_messages_own" ON ai_messages
    FOR ALL USING (
        conversation_id IN (SELECT id FROM ai_conversations WHERE user_id = auth.uid())
    );

-- ============================================================
-- GUILD POLICIES
-- ============================================================
ALTER TABLE guilds ENABLE ROW LEVEL SECURITY;
CREATE POLICY "guilds_select_all" ON guilds FOR SELECT USING (TRUE);
CREATE POLICY "guilds_insert_auth" ON guilds FOR INSERT WITH CHECK (auth.uid() = leader_id);
CREATE POLICY "guilds_update_leader" ON guilds FOR UPDATE USING (auth.uid() = leader_id);

CREATE POLICY "guild_members_select_all" ON guild_members FOR SELECT USING (TRUE);
CREATE POLICY "guild_members_insert_own" ON guild_members FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "guild_members_delete_own" ON guild_members FOR DELETE USING (auth.uid() = user_id);
