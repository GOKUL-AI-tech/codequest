import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  final String? avatarUrl;
  final String characterId;
  final int level;
  final int xp;
  final int coins;
  final int streak;
  final int lives;
  final DateTime? lastLifeRefill;
  final String rank;
  final String? bio;
  final String favoriteLanguage;
  final int totalChallengesCompleted;
  final int totalLessonsCompleted;
  final bool isPremium;
  final DateTime createdAt;
  final DateTime? lastActiveAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    this.avatarUrl,
    required this.characterId,
    required this.level,
    required this.xp,
    required this.coins,
    required this.streak,
    required this.lives,
    this.lastLifeRefill,
    required this.rank,
    this.bio,
    required this.favoriteLanguage,
    required this.totalChallengesCompleted,
    required this.totalLessonsCompleted,
    required this.isPremium,
    required this.createdAt,
    this.lastActiveAt,
  });

  int get xpToNextLevel {
    if (level >= 20) return 0;
    return _xpThresholds[level] - xp;
  }

  double get levelProgress {
    if (level >= 20) return 1.0;
    final currentLevelXp = level > 0 ? _xpThresholds[level - 1] : 0;
    final nextLevelXp = _xpThresholds[level];
    final progressXp = xp - currentLevelXp;
    final totalXp = nextLevelXp - currentLevelXp;
    return (progressXp / totalXp).clamp(0.0, 1.0);
  }

  static const List<int> _xpThresholds = [
    100, 250, 500, 900, 1400, 2100, 3000, 4200, 5700, 7500,
    9800, 12600, 16000, 20100, 25000, 31000, 38200, 46800, 57000, 70000,
  ];

  @override
  List<Object?> get props => [id, email, username, level, xp, coins, streak];

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? avatarUrl,
    String? characterId,
    int? level,
    int? xp,
    int? coins,
    int? streak,
    int? lives,
    DateTime? lastLifeRefill,
    String? rank,
    String? bio,
    String? favoriteLanguage,
    int? totalChallengesCompleted,
    int? totalLessonsCompleted,
    bool? isPremium,
    DateTime? createdAt,
    DateTime? lastActiveAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      characterId: characterId ?? this.characterId,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      coins: coins ?? this.coins,
      streak: streak ?? this.streak,
      lives: lives ?? this.lives,
      lastLifeRefill: lastLifeRefill ?? this.lastLifeRefill,
      rank: rank ?? this.rank,
      bio: bio ?? this.bio,
      favoriteLanguage: favoriteLanguage ?? this.favoriteLanguage,
      totalChallengesCompleted: totalChallengesCompleted ?? this.totalChallengesCompleted,
      totalLessonsCompleted: totalLessonsCompleted ?? this.totalLessonsCompleted,
      isPremium: isPremium ?? this.isPremium,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
}
