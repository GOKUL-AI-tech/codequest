import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.avatarUrl,
    required super.characterId,
    required super.level,
    required super.xp,
    required super.coins,
    required super.streak,
    required super.lives,
    super.lastLifeRefill,
    required super.rank,
    super.bio,
    required super.favoriteLanguage,
    required super.totalChallengesCompleted,
    required super.totalLessonsCompleted,
    required super.isPremium,
    required super.createdAt,
    super.lastActiveAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> map, {String email = ''}) {
    return UserModel(
      id: map['id'] as String,
      email: email,
      username: map['username'] as String? ?? 'player',
      avatarUrl: map['avatar_url'] as String?,
      characterId: map['character_id'] as String? ?? 'cyber_ninja',
      level: (map['level'] as num?)?.toInt() ?? 1,
      xp: (map['xp'] as num?)?.toInt() ?? 0,
      coins: (map['coins'] as num?)?.toInt() ?? 100,
      streak: (map['streak'] as num?)?.toInt() ?? 0,
      lives: (map['lives'] as num?)?.toInt() ?? 5,
      lastLifeRefill: map['last_life_refill'] != null
          ? DateTime.tryParse(map['last_life_refill'] as String)
          : null,
      rank: map['rank_title'] as String? ?? 'Script Kiddie',
      bio: map['bio'] as String?,
      favoriteLanguage: map['favorite_language'] as String? ?? 'python',
      totalChallengesCompleted:
          (map['total_challenges_completed'] as num?)?.toInt() ?? 0,
      totalLessonsCompleted:
          (map['total_lessons_completed'] as num?)?.toInt() ?? 0,
      isPremium: map['subscription_tier'] != null &&
          map['subscription_tier'] != 'free',
      createdAt: map['created_at'] != null
          ? DateTime.parse(map['created_at'] as String)
          : DateTime.now(),
      lastActiveAt: map['last_active_at'] != null
          ? DateTime.tryParse(map['last_active_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'avatar_url': avatarUrl,
      'character_id': characterId,
      'level': level,
      'xp': xp,
      'coins': coins,
      'streak': streak,
      'lives': lives,
      'rank_title': rank,
      'bio': bio,
      'favorite_language': favoriteLanguage,
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      username: entity.username,
      avatarUrl: entity.avatarUrl,
      characterId: entity.characterId,
      level: entity.level,
      xp: entity.xp,
      coins: entity.coins,
      streak: entity.streak,
      lives: entity.lives,
      lastLifeRefill: entity.lastLifeRefill,
      rank: entity.rank,
      bio: entity.bio,
      favoriteLanguage: entity.favoriteLanguage,
      totalChallengesCompleted: entity.totalChallengesCompleted,
      totalLessonsCompleted: entity.totalLessonsCompleted,
      isPremium: entity.isPremium,
      createdAt: entity.createdAt,
      lastActiveAt: entity.lastActiveAt,
    );
  }
}
