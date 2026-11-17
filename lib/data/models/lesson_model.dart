import '../../domain/entities/lesson_entity.dart';

class ChapterModel extends ChapterEntity {
  const ChapterModel({
    required super.id,
    required super.languageId,
    required super.title,
    required super.description,
    required super.order,
    required super.iconEmoji,
    required super.totalLessons,
    required super.completedLessons,
    required super.isLocked,
    required super.unlockRequirement,
  });

  factory ChapterModel.fromMap(
    Map<String, dynamic> map, {
    int completedLessons = 0,
    bool isLocked = false,
  }) {
    final req = (map['unlock_requirement'] as num?)?.toInt() ?? 0;
    return ChapterModel(
      id: map['id'] as String,
      languageId: map['language_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      order: (map['order_index'] as num?)?.toInt() ?? 0,
      iconEmoji: map['icon_emoji'] as String? ?? '📚',
      totalLessons: (map['total_lessons'] as num?)?.toInt() ?? 0,
      completedLessons: completedLessons,
      unlockRequirement: req,
      isLocked: isLocked,
    );
  }
}

class LessonModel extends LessonEntity {
  const LessonModel({
    required super.id,
    required super.chapterId,
    required super.title,
    required super.description,
    required super.languageId,
    required super.type,
    required super.difficulty,
    required super.order,
    required super.xpReward,
    required super.coinReward,
    required super.isLocked,
    required super.isCompleted,
    super.userScore,
    super.content,
    required super.questions,
    super.challenge,
    super.estimatedTime,
    required super.tags,
  });

  factory LessonModel.fromMap(Map<String, dynamic> map,
      {bool isCompleted = false, int? userScore}) {
    return LessonModel(
      id: map['id'] as String,
      chapterId: map['chapter_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      languageId: map['language_id'] as String,
      type: _parseType(map['type'] as String?),
      difficulty: _parseDifficulty(map['difficulty'] as String?),
      order: (map['order_index'] as num?)?.toInt() ?? 0,
      xpReward: (map['xp_reward'] as num?)?.toInt() ?? 50,
      coinReward: (map['coin_reward'] as num?)?.toInt() ?? 10,
      isLocked: false,
      isCompleted: isCompleted,
      userScore: userScore,
      content: map['content'] as String?,
      questions: [],
      tags: (map['tags'] as List?)?.cast<String>() ?? [],
      estimatedTime: Duration(
          minutes: (map['estimated_minutes'] as num?)?.toInt() ?? 10),
    );
  }

  static LessonType _parseType(String? type) {
    return switch (type) {
      'quiz' => LessonType.quiz,
      'coding' => LessonType.coding,
      'boss_battle' => LessonType.bossBattle,
      _ => LessonType.theory,
    };
  }

  static DifficultyLevel _parseDifficulty(String? d) {
    return switch (d) {
      'intermediate' => DifficultyLevel.intermediate,
      'advanced' => DifficultyLevel.advanced,
      'expert' => DifficultyLevel.expert,
      _ => DifficultyLevel.beginner,
    };
  }
}

class QuizQuestionModel extends QuizQuestion {
  const QuizQuestionModel({
    required super.id,
    required super.question,
    required super.options,
    required super.correctOptionIndex,
    super.explanation,
    super.codeSnippet,
  });

  factory QuizQuestionModel.fromMap(Map<String, dynamic> map) {
    final optionsRaw = map['options'];
    final List<String> options = optionsRaw is List
        ? optionsRaw.cast<String>()
        : List<String>.from(optionsRaw as Iterable);
    return QuizQuestionModel(
      id: map['id'] as String,
      question: map['question'] as String,
      options: options,
      correctOptionIndex:
          (map['correct_option_index'] as num?)?.toInt() ?? 0,
      explanation: map['explanation'] as String?,
      codeSnippet: map['code_snippet'] as String?,
    );
  }
}

class CodingChallengeModel extends CodingChallenge {
  const CodingChallengeModel({
    required super.id,
    required super.title,
    required super.description,
    required super.starterCode,
    required super.solutionCode,
    required super.testCases,
    required super.languageId,
    required super.timeLimit,
    required super.memoryLimit,
    required super.hints,
  });

  factory CodingChallengeModel.fromMap(Map<String, dynamic> map) {
    final hintsRaw = map['hints'];
    final List<String> hints = hintsRaw is List
        ? hintsRaw.cast<String>()
        : [];
    return CodingChallengeModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String,
      starterCode: map['starter_code'] as String,
      solutionCode: map['solution_code'] as String? ?? '',
      testCases: [],
      languageId: map['language_id'] as String,
      timeLimit: (map['time_limit_seconds'] as num?)?.toInt() ?? 30,
      memoryLimit: (map['memory_limit_mb'] as num?)?.toInt() ?? 256,
      hints: hints,
    );
  }
}
