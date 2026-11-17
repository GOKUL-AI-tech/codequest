-- ============================================================
-- CodeQuest - Seed Data
-- Migration: 003_seed_data.sql
-- ============================================================

-- ============================================================
-- LANGUAGES
-- ============================================================
INSERT INTO languages (id, name, icon, color_hex, difficulty, description, total_levels, order_index) VALUES
('python', 'Python', '🐍', '#3572A5', 'beginner', 'The most beginner-friendly language. Great for AI, data science, and automation.', 12, 1),
('javascript', 'JavaScript', '⚡', '#F7DF1E', 'beginner', 'The language of the web. Build interactive websites and apps.', 14, 2),
('dart', 'Dart', '🎯', '#00B4AB', 'intermediate', 'Google''s language for Flutter mobile apps. Fast and modern.', 10, 3),
('java', 'Java', '☕', '#B07219', 'intermediate', 'Write once, run anywhere. Industry-standard for backend and Android.', 15, 4),
('cpp', 'C++', '⚙️', '#F34B7D', 'advanced', 'High-performance systems programming. For game dev and OS.', 12, 5),
('c', 'C', '🔧', '#555555', 'advanced', 'The mother of all languages. Close to the metal performance.', 10, 6);

-- ============================================================
-- CHAPTERS - Python
-- ============================================================
INSERT INTO chapters (id, language_id, title, description, icon_emoji, order_index, xp_reward, unlock_requirement) VALUES
(uuid_generate_v4(), 'python', 'Python Basics', 'Variables, data types, print statements', '🌱', 1, 100, 0),
(uuid_generate_v4(), 'python', 'Control Flow', 'If/else, loops, conditions', '🔀', 2, 150, 1),
(uuid_generate_v4(), 'python', 'Functions & Scope', 'Defining and calling functions', '⚡', 3, 200, 2),
(uuid_generate_v4(), 'python', 'Data Structures', 'Lists, dicts, tuples, sets', '📦', 4, 250, 3),
(uuid_generate_v4(), 'python', 'OOP', 'Classes, objects, inheritance', '🏗️', 5, 300, 5),
(uuid_generate_v4(), 'python', 'File I/O & Exceptions', 'Reading files, error handling', '📂', 6, 350, 7),
(uuid_generate_v4(), 'python', 'Algorithms', 'Sorting, searching, complexity', '🧠', 7, 500, 10),
(uuid_generate_v4(), 'python', 'Python Boss Battle', 'Ultimate Python challenge — prove your mastery!', '💀', 8, 1000, 12);

-- ============================================================
-- ACHIEVEMENTS
-- ============================================================
INSERT INTO achievements (title, description, icon_emoji, category, xp_reward, coin_reward, required_count, is_rare) VALUES
-- Learning
('First Step', 'Complete your first lesson', '👶', 'learning', 50, 20, 1, FALSE),
('Bookworm', 'Complete 10 lessons', '📚', 'learning', 150, 50, 10, FALSE),
('Scholar', 'Complete 50 lessons', '🎓', 'learning', 500, 200, 50, FALSE),
('Code Master', 'Complete 100 lessons', '🏆', 'learning', 1000, 500, 100, TRUE),
('Polyglot', 'Learn 3 programming languages', '🌐', 'learning', 300, 100, 3, FALSE),
('Full Stack', 'Complete all languages', '🚀', 'learning', 2000, 1000, 6, TRUE),

-- Streak
('On Fire', 'Maintain a 3-day streak', '🔥', 'streak', 100, 30, 3, FALSE),
('Week Warrior', 'Maintain a 7-day streak', '⚔️', 'streak', 250, 100, 7, FALSE),
('Month Master', 'Maintain a 30-day streak', '🏅', 'streak', 1000, 500, 30, TRUE),
('Legend''s Path', 'Maintain a 100-day streak', '👑', 'streak', 5000, 2000, 100, TRUE),

-- Battle
('First Blood', 'Win your first battle', '💥', 'battle', 100, 50, 1, FALSE),
('Gladiator', 'Win 10 battles', '🥊', 'battle', 300, 150, 10, FALSE),
('Arena Champion', 'Win 50 battles', '🏆', 'battle', 1000, 500, 50, TRUE),
('Undefeated', 'Win 10 battles in a row', '🌟', 'battle', 500, 250, 10, TRUE),

-- Social
('First Friend', 'Add your first friend', '🤝', 'social', 50, 20, 1, FALSE),
('Social Butterfly', 'Have 10 friends', '🦋', 'social', 200, 80, 10, FALSE),
('Guild Master', 'Create a guild', '🏰', 'social', 300, 100, 1, FALSE),

-- Special
('Speed Demon', 'Complete a challenge in under 60 seconds', '⚡', 'special', 200, 100, 1, FALSE),
('Perfect Score', 'Complete a quiz with 100% score', '💯', 'special', 150, 75, 1, FALSE),
('Night Owl', 'Code after midnight', '🦉', 'special', 100, 50, 1, FALSE),
('Early Bird', 'Code before 7am', '🐦', 'special', 100, 50, 1, FALSE);

-- ============================================================
-- DAILY MISSIONS
-- ============================================================
INSERT INTO daily_missions (title, description, icon_emoji, xp_reward, coin_reward, required_count, mission_type) VALUES
('Daily Learner', 'Complete 3 lessons today', '📖', 150, 50, 3, 'complete_lessons'),
('Code Crusher', 'Solve 2 coding challenges', '💻', 200, 75, 2, 'solve_challenges'),
('Battle Ready', 'Win 1 coding battle', '⚔️', 300, 100, 1, 'win_battles'),
('Quiz Wizard', 'Answer 10 quiz questions', '🧙', 100, 40, 10, 'answer_questions'),
('XP Hunter', 'Earn 200 XP today', '⭐', 250, 80, 200, 'earn_xp'),
('Social Coder', 'Send 5 messages in chat', '💬', 75, 30, 5, 'send_messages');

-- ============================================================
-- SAMPLE SHOP ITEMS
-- ============================================================
INSERT INTO shop_items (name, description, item_type, price_coins, is_premium, metadata) VALUES
('Neon Purple Theme', 'Change your app theme to neon purple', 'theme', 500, FALSE, '{"theme_id": "neon_purple"}'),
('Golden Theme', 'Exclusive golden cyberpunk theme', 'theme', 0, TRUE, '{"theme_id": "golden"}'),
('XP Boost (2x)', 'Double your XP for 1 hour', 'powerup', 200, FALSE, '{"duration_hours": 1, "multiplier": 2}'),
('Life Refill', 'Instantly refill all lives', 'powerup', 50, FALSE, '{"lives": 5}'),
('Mystery Loot Box', 'Contains random rewards!', 'lootbox', 300, FALSE, '{"contains": ["xp", "coins", "badge", "powerup"]}'),
('Premium Loot Box', 'Contains guaranteed rare items', 'lootbox', 0, TRUE, '{"contains": ["rare_badge", "character_skin", "premium_powerup"]}'),
('Dev Phantom Skin', 'Exclusive phantom warrior skin', 'character', 1000, FALSE, '{"character_id": "dev_phantom_gold"}'),
('Streak Shield', 'Protect your streak for 1 day', 'powerup', 150, FALSE, '{"duration_days": 1}');
