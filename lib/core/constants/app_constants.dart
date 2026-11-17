class AppConstants {
  // App Info
  static const String appName = 'CodeQuest';
  static const String appVersion = '1.0.0';
  static const String appTagline = 'Code. Level Up. Conquer.';

  // Supabase
  static const String supabaseUrl = 'https://YOUR-PROJECT.supabase.co';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';

  // AI Mentor
  static const String aiMentorApiKey = 'YOUR_OPENAI_OR_GEMINI_KEY';
  static const String aiMentorBaseUrl = 'https://api.openai.com/v1';
  static const String aiMentorModel = 'gpt-4o-mini';

  // Game Mechanics
  static const int xpPerLesson = 50;
  static const int xpPerQuiz = 30;
  static const int xpPerChallenge = 100;
  static const int xpPerBossBattle = 250;
  static const int coinsPerLesson = 10;
  static const int coinsPerChallenge = 25;
  static const int streakBonusMultiplier = 2;
  static const int dailyMissionXp = 150;
  static const int maxLives = 5;
  static const int livesRefillMinutes = 30;

  // Levels
  static const List<int> xpThresholds = [
    0, 100, 250, 500, 900, 1400, 2100, 3000, 4200, 5700,
    7500, 9800, 12600, 16000, 20100, 25000, 31000, 38200, 46800, 57000,
  ];

  // Pagination
  static const int defaultPageSize = 20;
  static const int leaderboardPageSize = 50;

  // Storage Keys
  static const String kAuthToken = 'auth_token';
  static const String kUserProfile = 'user_profile';
  static const String kThemeMode = 'theme_mode';
  static const String kOnboardingDone = 'onboarding_done';
  static const String kSelectedCharacter = 'selected_character';
  static const String kLastStreakDate = 'last_streak_date';
  static const String kOfflineProgress = 'offline_progress';
  static const String kSkillLevel = 'skill_level';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration animationFast = Duration(milliseconds: 200);
  static const Duration animationMedium = Duration(milliseconds: 400);
  static const Duration animationSlow = Duration(milliseconds: 800);

  // Characters
  static const List<Map<String, String>> characters = [
    {'id': 'cyber_ninja', 'name': 'Cyber Ninja', 'asset': 'assets/images/char_cyber_ninja.png', 'specialty': 'Python'},
    {'id': 'code_warrior', 'name': 'Code Warrior', 'asset': 'assets/images/char_code_warrior.png', 'specialty': 'C++'},
    {'id': 'data_mage', 'name': 'Data Mage', 'asset': 'assets/images/char_data_mage.png', 'specialty': 'JavaScript'},
    {'id': 'algo_hunter', 'name': 'Algo Hunter', 'asset': 'assets/images/char_algo_hunter.png', 'specialty': 'Java'},
    {'id': 'dev_phantom', 'name': 'Dev Phantom', 'asset': 'assets/images/char_dev_phantom.png', 'specialty': 'Dart'},
    {'id': 'bug_slayer', 'name': 'Bug Slayer', 'asset': 'assets/images/char_bug_slayer.png', 'specialty': 'C'},
  ];

  // Streak Freeze
  static const String kStreakFreezeCount = 'streak_freeze_count';
  static const int streakFreezeCost = 200; // coins

  // Programming Languages
  static const List<Map<String, dynamic>> languages = [
    // Beginner
    {'id': 'html',       'name': 'HTML',       'icon': '🌐', 'color': 0xFFE34C26, 'difficulty': 'Beginner',     'levels': 8},
    {'id': 'css',        'name': 'CSS',         'icon': '🎨', 'color': 0xFF264DE4, 'difficulty': 'Beginner',     'levels': 8},
    {'id': 'python',     'name': 'Python',      'icon': '🐍', 'color': 0xFF3572A5, 'difficulty': 'Beginner',     'levels': 12},
    {'id': 'javascript', 'name': 'JavaScript',  'icon': '⚡', 'color': 0xFFF7DF1E, 'difficulty': 'Beginner',     'levels': 14},
    // Intermediate
    {'id': 'sql',        'name': 'SQL',         'icon': '🗄️', 'color': 0xFF336791, 'difficulty': 'Intermediate', 'levels': 10},
    {'id': 'typescript', 'name': 'TypeScript',  'icon': '🔷', 'color': 0xFF3178C6, 'difficulty': 'Intermediate', 'levels': 10},
    {'id': 'dart',       'name': 'Dart',        'icon': '🎯', 'color': 0xFF00B4AB, 'difficulty': 'Intermediate', 'levels': 10},
    {'id': 'java',       'name': 'Java',        'icon': '☕', 'color': 0xFFB07219, 'difficulty': 'Intermediate', 'levels': 15},
    // Advanced
    {'id': 'cpp',        'name': 'C++',         'icon': '⚙️', 'color': 0xFFF34B7D, 'difficulty': 'Advanced',    'levels': 12},
    {'id': 'c',          'name': 'C',           'icon': '🔧', 'color': 0xFF555555, 'difficulty': 'Advanced',    'levels': 10},
  ];

  // Ranks
  static const List<Map<String, dynamic>> ranks = [
    {'title': 'Script Kiddie', 'minXp': 0, 'color': 0xFF9E9E9E, 'icon': '👾'},
    {'title': 'Code Apprentice', 'minXp': 500, 'color': 0xFF4CAF50, 'icon': '🌱'},
    {'title': 'Bug Hunter', 'minXp': 2000, 'color': 0xFF2196F3, 'icon': '🐛'},
    {'title': 'Algorithm Adept', 'minXp': 5000, 'color': 0xFF9C27B0, 'icon': '🧩'},
    {'title': 'Syntax Samurai', 'minXp': 12000, 'color': 0xFFFF9800, 'icon': '⚔️'},
    {'title': 'Cyber Warrior', 'minXp': 30000, 'color': 0xFFFF5722, 'icon': '🥷'},
    {'title': 'Code Legend', 'minXp': 75000, 'color': 0xFFFFD700, 'icon': '👑'},
    {'title': 'Grand Architect', 'minXp': 150000, 'color': 0xFFE040FB, 'icon': '🏛️'},
  ];
}
