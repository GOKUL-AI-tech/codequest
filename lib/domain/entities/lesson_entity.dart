import 'package:equatable/equatable.dart';

enum LessonType { theory, quiz, coding, bossBattle }
enum DifficultyLevel { beginner, intermediate, advanced, expert }

class LessonEntity extends Equatable {
  final String id;
  final String chapterId;
  final String title;
  final String description;
  final String languageId;
  final LessonType type;
  final DifficultyLevel difficulty;
  final int order;
  final int xpReward;
  final int coinReward;
  final bool isLocked;
  final bool isCompleted;
  final int? userScore;
  final String? content; // Markdown content
  final List<QuizQuestion> questions;
  final CodingChallenge? challenge;
  final Duration? estimatedTime;
  final List<String> tags;

  const LessonEntity({
    required this.id,
    required this.chapterId,
    required this.title,
    required this.description,
    required this.languageId,
    required this.type,
    required this.difficulty,
    required this.order,
    required this.xpReward,
    required this.coinReward,
    required this.isLocked,
    required this.isCompleted,
    this.userScore,
    this.content,
    required this.questions,
    this.challenge,
    this.estimatedTime,
    required this.tags,
  });

  @override
  List<Object?> get props => [id, chapterId, title, isCompleted];
}

class QuizQuestion extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;
  final String? explanation;
  final String? codeSnippet;

  const QuizQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
    this.explanation,
    this.codeSnippet,
  });

  @override
  List<Object?> get props => [id, question];
}

class CodingChallenge extends Equatable {
  final String id;
  final String title;
  final String description;
  final String starterCode;
  final String solutionCode;
  final List<TestCase> testCases;
  final String languageId;
  final int timeLimit; // seconds
  final int memoryLimit; // MB
  final List<String> hints;

  const CodingChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.starterCode,
    required this.solutionCode,
    required this.testCases,
    required this.languageId,
    required this.timeLimit,
    required this.memoryLimit,
    required this.hints,
  });

  @override
  List<Object?> get props => [id, title];
}

class TestCase extends Equatable {
  final String id;
  final String input;
  final String expectedOutput;
  final bool isHidden;

  const TestCase({
    required this.id,
    required this.input,
    required this.expectedOutput,
    required this.isHidden,
  });

  @override
  List<Object?> get props => [id];
}

class ChapterEntity extends Equatable {
  final String id;
  final String languageId;
  final String title;
  final String description;
  final int order;
  final String iconEmoji;
  final int totalLessons;
  final int completedLessons;
  final bool isLocked;
  /// 0 = Level 1 (Beginner), 1 = Level 2 (Intermediate), 2 = Level 3 (Expert)
  final int unlockRequirement;

  const ChapterEntity({
    required this.id,
    required this.languageId,
    required this.title,
    required this.description,
    required this.order,
    required this.iconEmoji,
    required this.totalLessons,
    required this.completedLessons,
    required this.isLocked,
    this.unlockRequirement = 0,
  });

  /// 1, 2, or 3
  int get level => unlockRequirement + 1;

  double get completionPercentage =>
      totalLessons > 0 ? completedLessons / totalLessons : 0;

  bool get isFullyCompleted => totalLessons > 0 && completedLessons >= totalLessons;

  @override
  List<Object?> get props => [id, languageId, title];
}
