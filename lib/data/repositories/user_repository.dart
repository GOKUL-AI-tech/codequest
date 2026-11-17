import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../datasources/remote/supabase_datasource.dart';
import '../datasources/local/hive_datasource.dart';
import '../models/user_model.dart';

class UserRepository implements IUserRepository {
  final SupabaseDatasource _remote;
  final HiveDatasource _local;

  UserRepository(this._remote, this._local);

  @override
  Future<UserEntity?> getProfile(String userId) async {
    try {
      final profile = await _remote.getProfile(userId);
      if (profile != null) {
        await _local.cacheProfile(userId, profile.toMap());
      }
      return profile;
    } catch (_) {
      // Fallback to cache
      final cached = await _local.getCachedProfile(userId);
      if (cached == null) return null;
      return UserModel.fromMap(cached);
    }
  }

  @override
  Stream<UserEntity?> profileStream(String userId) {
    return _remote.profileStream(userId);
  }

  @override
  Future<void> updateProfile(
      String userId, Map<String, dynamic> data) async {
    await _remote.updateProfile(userId, data);
  }

  @override
  Future<void> updateStreak(String userId) async {
    await _remote.updateStreak(userId);
  }

  @override
  Future<Map<String, dynamic>> awardXp({
    required String userId,
    required int xp,
    required int coins,
    required String type,
    String? description,
    String? referenceId,
  }) async {
    return _remote.awardXp(
      userId: userId,
      xp: xp,
      coins: coins,
      type: type,
      description: description,
      referenceId: referenceId,
    );
  }
}

class LessonRepository implements ILessonRepository {
  final SupabaseDatasource _remote;
  LessonRepository(this._remote);

  @override
  Future<List> getChapters(String languageId) =>
      _remote.getChapters(languageId);

  @override
  Future<List> getLessons(String chapterId) =>
      _remote.getLessons(chapterId);

  @override
  Future<dynamic> getLesson(String lessonId) =>
      _remote.getLesson(lessonId);

  @override
  Future<List> getQuizQuestions(String lessonId) =>
      _remote.getQuizQuestions(lessonId);

  @override
  Future<void> markLessonComplete({
    required String userId,
    required String lessonId,
    required int xpEarned,
    required int coinsEarned,
    int? score,
    int timeSpentSeconds = 0,
  }) async {
    await _remote.markLessonComplete(
      userId: userId,
      lessonId: lessonId,
      xpEarned: xpEarned,
      coinsEarned: coinsEarned,
      score: score,
      timeSpentSeconds: timeSpentSeconds,
    );
  }
}

class LeaderboardRepository implements ILeaderboardRepository {
  final SupabaseDatasource _remote;
  LeaderboardRepository(this._remote);

  @override
  Future<List> getGlobalLeaderboard(
          {int limit = 50, int offset = 0}) =>
      _remote.getGlobalLeaderboard(limit: limit, offset: offset);

  @override
  Future<List> getWeeklyLeaderboard({int limit = 50}) =>
      _remote.getWeeklyLeaderboard(limit: limit);

  @override
  Future<List> getFriendsLeaderboard(String userId) =>
      _remote.getFriendsLeaderboard(userId);
}
