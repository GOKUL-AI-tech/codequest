import 'package:equatable/equatable.dart';

enum AchievementCategory { learning, streak, social, battle, collection, special }

class AchievementEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final AchievementCategory category;
  final int xpReward;
  final int coinReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final double progress; // 0.0 to 1.0
  final int requiredCount;
  final int currentCount;
  final bool isRare;

  const AchievementEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.category,
    required this.xpReward,
    required this.coinReward,
    required this.isUnlocked,
    this.unlockedAt,
    required this.progress,
    required this.requiredCount,
    required this.currentCount,
    required this.isRare,
  });

  @override
  List<Object?> get props => [id, title, isUnlocked];
}

class LeaderboardEntry extends Equatable {
  final int rank;
  final String userId;
  final String username;
  final String? avatarUrl;
  final String characterId;
  final int xp;
  final int level;
  final String rankTitle;
  final int streak;
  final bool isCurrentUser;

  const LeaderboardEntry({
    required this.rank,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.characterId,
    required this.xp,
    required this.level,
    required this.rankTitle,
    required this.streak,
    required this.isCurrentUser,
  });

  @override
  List<Object?> get props => [rank, userId, xp];
}

class DailyMission extends Equatable {
  final String id;
  final String title;
  final String description;
  final String iconEmoji;
  final int xpReward;
  final int coinReward;
  final int requiredCount;
  final int currentCount;
  final bool isCompleted;
  final DateTime expiresAt;

  const DailyMission({
    required this.id,
    required this.title,
    required this.description,
    required this.iconEmoji,
    required this.xpReward,
    required this.coinReward,
    required this.requiredCount,
    required this.currentCount,
    required this.isCompleted,
    required this.expiresAt,
  });

  double get progressPercent =>
      requiredCount > 0 ? (currentCount / requiredCount).clamp(0.0, 1.0) : 0;

  @override
  List<Object?> get props => [id, title, isCompleted];
}
