import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/lesson_model.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

// ─── CHAPTERS ─────────────────────────────────────────────────────────────────

final chaptersProvider =
    FutureProvider.family<List<ChapterModel>, String>((ref, languageId) async {
  final repo = ref.read(lessonRepositoryProvider);
  final chapters = await repo.getChapters(languageId);
  return chapters.cast<ChapterModel>();
});

// ─── LESSONS ──────────────────────────────────────────────────────────────────

final lessonsProvider =
    FutureProvider.family<List<LessonModel>, String>((ref, chapterId) async {
  final repo = ref.read(lessonRepositoryProvider);
  final lessons = await repo.getLessons(chapterId);
  return lessons.cast<LessonModel>();
});

/// Aggregate completion state for a whole language: whether every chapter
/// has been fully completed, plus completed/total lesson counts. Used to
/// gate actions that should only be available once a language is 100%
/// finished (e.g. claiming its certificate).
final languageProgressProvider =
    FutureProvider.family<Map<String, dynamic>, String>((ref, languageId) async {
  final chapters = await ref.watch(chaptersProvider(languageId).future);
  final withLessons = chapters.where((c) => c.totalLessons > 0).toList();

  final total = withLessons.fold<int>(0, (sum, c) => sum + c.totalLessons);
  final completed = withLessons.fold<int>(0, (sum, c) {
    final done = c.completedLessons > c.totalLessons ? c.totalLessons : c.completedLessons;
    return sum + done;
  });
  final isComplete = withLessons.isNotEmpty &&
      withLessons.every((c) => c.completedLessons >= c.totalLessons);

  return {
    'completed': completed,
    'total': total,
    'isComplete': isComplete,
  };
});

final lessonDetailProvider =
    FutureProvider.family<LessonModel?, String>((ref, lessonId) async {
  final repo = ref.read(lessonRepositoryProvider);
  return await repo.getLesson(lessonId) as LessonModel?;
});

final quizQuestionsProvider =
    FutureProvider.family<List<QuizQuestionModel>, String>(
        (ref, lessonId) async {
  final ds = ref.read(supabaseDatasourceProvider);
  final qs = await ds.getQuizQuestions(lessonId);
  return qs;
});

final codingChallengeProvider =
    FutureProvider.family<CodingChallengeModel?, String>(
        (ref, lessonId) async {
  final ds = ref.read(supabaseDatasourceProvider);
  return ds.getCodingChallenge(lessonId);
});

final arenaChallengesProvider =
    FutureProvider.family<List<CodingChallengeModel>, String?>(
        (ref, languageId) async {
  final ds = ref.read(supabaseDatasourceProvider);
  return ds.getArenaChallenges(languageId: languageId);
});

// ─── LESSON COMPLETION ────────────────────────────────────────────────────────

class LessonCompletionNotifier extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<Map<String, dynamic>> completeLesson({
    required String lessonId,
    required int xpReward,
    required int coinReward,
    /// Pass the lesson's language ID so the specialty bonus can be applied.
    String? languageId,
    int? score,
    int timeSpentSeconds = 0,
  }) async {
    state = const AsyncLoading();
    try {
      final userId = ref.read(currentUserProvider)?.id;
      if (userId == null) throw Exception('Not authenticated');

      // ── Specialty bonus (+25% XP) ──────────────────────────────────────────
      bool specialtyBonus = false;
      int finalXp = xpReward;

      if (languageId != null) {
        final prefs = await SharedPreferences.getInstance();
        final charId = prefs.getString(AppConstants.kSelectedCharacter);
        if (charId != null) {
          const nameToId = <String, String>{
            'Python': 'python',
            'JavaScript': 'javascript',
            'Dart': 'dart',
            'Java': 'java',
            'C++': 'cpp',
            'C': 'c',
          };
          final char = AppConstants.characters.cast<Map<String, String>?>()
              .firstWhere((c) => c!['id'] == charId, orElse: () => null);
          if (char != null) {
            final specialtyId = nameToId[char['specialty']];
            if (specialtyId == languageId) {
              finalXp = (xpReward * 1.25).round();
              specialtyBonus = true;
            }
          }
        }
      }
      // ──────────────────────────────────────────────────────────────────────

      final repo = ref.read(lessonRepositoryProvider);
      await repo.markLessonComplete(
        userId: userId,
        lessonId: lessonId,
        xpEarned: finalXp,
        coinsEarned: coinReward,
        score: score,
        timeSpentSeconds: timeSpentSeconds,
      );

      // Award XP
      final ds = ref.read(supabaseDatasourceProvider);
      final result = await ds.awardXp(
        userId: userId,
        xp: finalXp,
        coins: coinReward,
        type: 'earn_xp',
        description: specialtyBonus
            ? 'Completed lesson (+25% specialty bonus)'
            : 'Completed lesson',
        referenceId: lessonId,
      );

      // Update streak
      await ds.updateStreak(userId);

      state = const AsyncData(null);
      // Callers can check result['specialtyBonus'] == true to show the toast
      return {
        ...result,
        'specialtyBonus': specialtyBonus,
        'finalXp': finalXp,
      };
    } catch (e, s) {
      state = AsyncError(e, s);
      rethrow;
    }
  }
}

final lessonCompletionProvider =
    NotifierProvider<LessonCompletionNotifier, AsyncValue<void>>(
  () => LessonCompletionNotifier(),
);
