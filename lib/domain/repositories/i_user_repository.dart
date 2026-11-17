import '../entities/user_entity.dart';

abstract class IUserRepository {
  Future<UserEntity?> getProfile(String userId);
  Stream<UserEntity?> profileStream(String userId);
  Future<void> updateProfile(String userId, Map<String, dynamic> data);
  Future<void> updateStreak(String userId);
  Future<Map<String, dynamic>> awardXp({
    required String userId,
    required int xp,
    required int coins,
    required String type,
    String? description,
    String? referenceId,
  });
}

abstract class ILessonRepository {
  Future<List> getChapters(String languageId);
  Future<List> getLessons(String chapterId);
  Future<dynamic> getLesson(String lessonId);
  Future<List> getQuizQuestions(String lessonId);
  Future<void> markLessonComplete({
    required String userId,
    required String lessonId,
    required int xpEarned,
    required int coinsEarned,
    int? score,
    int timeSpentSeconds = 0,
  });
}

abstract class ILeaderboardRepository {
  Future<List> getGlobalLeaderboard({int limit = 50, int offset = 0});
  Future<List> getWeeklyLeaderboard({int limit = 50});
  Future<List> getFriendsLeaderboard(String userId);
}
