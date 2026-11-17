import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../providers/lessons_provider.dart';
import '../../widgets/common/neon_button.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String quizId;
  const QuizScreen({super.key, required this.quizId});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> with TickerProviderStateMixin {
  int _currentQuestion = 0;
  int? _selectedOption;
  bool _hasAnswered = false;
  int _correctAnswers = 0;
  int _lives = 3;

  late AnimationController _progressController;
  late AnimationController _timerController;

  /// Questions for THIS quiz, loaded from Supabase in build().
  /// Falls back to the local sample set only if the quiz has no
  /// questions in the database.
  List<Map<String, dynamic>>? _questions;

  // Local fallback questions mapped by language
  static List<Map<String, dynamic>> _getFallbackQuestions(String quizId, [String? langId]) {
    String lang = langId ?? 'python';
    if (quizId.startsWith('10000001') || quizId.contains('py')) {
      lang = 'python';
    } else if (quizId.startsWith('20000001') || quizId.contains('js')) {
      lang = 'javascript';
    } else if (quizId.startsWith('30000001') || quizId.contains('dart')) {
      lang = 'dart';
    } else if (quizId.startsWith('40000001') || quizId.contains('java')) {
      lang = 'java';
    } else if (quizId.startsWith('50000001') || quizId.contains('cpp')) {
      lang = 'cpp';
    } else if (quizId.startsWith('60000001') || quizId.contains('c')) {
      lang = 'c';
    }

    switch (lang) {
      case 'javascript':
        return [
          {
            'question': 'Which keyword declares a block-scoped, reassignable variable in modern JS?',
            'code': null,
            'options': ['var', 'let', 'const', 'function'],
            'correct': 1,
            'explanation': '`let` is block-scoped and reassignable. `const` cannot be reassigned, while `var` is function-scoped.',
          },
          {
            'question': 'What does `typeof NaN` evaluate to in JavaScript?',
            'code': 'console.log(typeof NaN);',
            'options': ['"nan"', '"undefined"', '"number"', '"object"'],
            'correct': 2,
            'explanation': 'In JavaScript, NaN (Not a Number) is a numeric value with type "number".',
          },
          {
            'question': 'Which array method returns a new array with transformed elements?',
            'code': null,
            'options': ['forEach', 'map', 'filter', 'push'],
            'correct': 1,
            'explanation': '`map()` produces a new array by applying a function to each item in the original array.',
          },
          {
            'question': 'What is the result of `3 === "3"` in JavaScript?',
            'code': null,
            'options': ['true', 'false', 'undefined', 'TypeError'],
            'correct': 1,
            'explanation': 'Strict equality `===` verifies both value and type without type coercion, so number 3 does not equal string "3".',
          },
        ];
      case 'dart':
        return [
          {
            'question': 'What does `String? name;` indicate in Dart null safety?',
            'code': null,
            'options': ['name is non-nullable', 'name can hold a String or null', 'name is a pointer', 'name is constant'],
            'correct': 1,
            'explanation': 'The ? symbol denotes a nullable type in Dart sound null safety.',
          },
          {
            'question': 'What does the null-coalescing operator `??` do in Dart?',
            'code': 'String? nick;\nprint(nick ?? "Guest");',
            'options': ['Forces non-null cast', 'Returns right operand if left is null', 'Throws an exception', 'Checks null equality'],
            'correct': 1,
            'explanation': '`a ?? b` returns `a` if it is not null; otherwise it returns fallback value `b`.',
          },
          {
            'question': 'Which keyword is used to reuse class code as a mixin in Dart?',
            'code': null,
            'options': ['extends', 'implements', 'with', 'mixin'],
            'correct': 2,
            'explanation': 'Classes apply mixins using the `with` keyword: `class Hero extends Character with Swimmer`.',
          },
          {
            'question': 'What is the return type of a Dart function that performs an action without returning data?',
            'code': null,
            'options': ['null', 'void', 'dynamic', 'Nothing'],
            'correct': 1,
            'explanation': '`void` indicates that a function does not return any value to its caller.',
          },
        ];
      case 'java':
        return [
          {
            'question': 'What is the memory size of an int primitive in Java?',
            'code': null,
            'options': ['2 bytes', '4 bytes (32-bit)', '8 bytes', 'Platform dependent'],
            'correct': 1,
            'explanation': 'Java standardizes `int` as a signed 32-bit (4 bytes) integer on all systems.',
          },
          {
            'question': 'Which keyword enables inheritance between classes in Java?',
            'code': null,
            'options': ['inherits', 'implements', 'extends', 'super'],
            'correct': 2,
            'explanation': 'Java uses `extends` for class inheritance and `implements` for interfaces.',
          },
          {
            'question': 'Which collection type prevents duplicate elements in Java?',
            'code': null,
            'options': ['ArrayList', 'LinkedList', 'HashSet', 'Vector'],
            'correct': 2,
            'explanation': '`Set` implementations like `HashSet` enforce uniqueness and disallow duplicate elements.',
          },
          {
            'question': 'How should you compare text equality between two String objects in Java?',
            'code': 'String s1 = "hello";\nString s2 = "hello";',
            'options': ['s1 == s2', 's1.equals(s2)', 's1.compare(s2)', 's1.is(s2)'],
            'correct': 1,
            'explanation': '`==` compares memory references, while `.equals()` compares the actual character sequence.',
          },
        ];
      case 'cpp':
        return [
          {
            'question': 'Which operator returns the memory address of a variable in C++?',
            'code': 'int x = 42;',
            'options': ['*', '&', '->', '@'],
            'correct': 1,
            'explanation': '`&x` is the address-of operator that retrieves the memory address of variable `x`.',
          },
          {
            'question': 'What does `*ptr` do when `ptr` is a pointer in C++?',
            'code': null,
            'options': ['Multiplies by ptr', 'Dereferences to access the value at the address', 'Declares a pointer', 'Deallocates memory'],
            'correct': 1,
            'explanation': 'Dereferencing a pointer with `*` reads or writes the value stored at that memory location.',
          },
          {
            'question': 'Which header is required for using `std::vector` in C++?',
            'code': null,
            'options': ['<array>', '<vector>', '<stl>', '<list>'],
            'correct': 1,
            'explanation': '`#include <vector>` provides the standard dynamically-resizable vector container.',
          },
          {
            'question': 'Which smart pointer provides unique, exclusive resource ownership in C++11?',
            'code': null,
            'options': ['std::shared_ptr', 'std::unique_ptr', 'std::weak_ptr', 'std::auto_ptr'],
            'correct': 1,
            'explanation': '`std::unique_ptr` guarantees single ownership and automatically deletes the heap resource upon destruction.',
          },
        ];
      case 'c':
        return [
          {
            'question': 'Which character terminates all valid strings in C?',
            'code': null,
            'options': ['"\\n"', "'\\0' (null character)", "EOF", "' ' (space)"],
            'correct': 1,
            'explanation': 'C strings are null-terminated character sequences ending with byte 0 (`\\0`).',
          },
          {
            'question': 'What does `sizeof(char)` always equal in standard C?',
            'code': null,
            'options': ['1 byte', '2 bytes', '4 bytes', 'Platform dependent'],
            'correct': 0,
            'explanation': 'The C standard defines `sizeof(char)` as exactly 1 byte by specification.',
          },
          {
            'question': 'Which function allocates heap memory in C without initializing it to zero?',
            'code': null,
            'options': ['calloc()', 'malloc()', 'realloc()', 'new()'],
            'correct': 1,
            'explanation': '`malloc(size)` allocates memory on the heap. `calloc` zeros the memory, and `new` is C++ only.',
          },
          {
            'question': 'Which function is used to compare two strings in C?',
            'code': null,
            'options': ['strcmp()', 'str_equals()', 'memcmp()', 'strlen()'],
            'correct': 0,
            'explanation': '`strcmp(s1, s2)` from `<string.h>` returns 0 if both strings contain identical characters.',
          },
        ];
      default: // python
        return [
          {
            'question': 'What is the correct way to declare a variable in Python?',
            'code': null,
            'options': ['var x = 5', 'x = 5', 'int x = 5', 'declare x = 5'],
            'correct': 1,
            'explanation': 'Python uses dynamic typing — you simply assign a value without declaring a type.',
          },
          {
            'question': 'What type is the value `3.14` in Python?',
            'code': 'x = 3.14\nprint(type(x))',
            'options': ['int', 'double', 'float', 'decimal'],
            'correct': 2,
            'explanation': 'Decimal numbers in Python are of type `float` (floating point).',
          },
          {
            'question': 'Which keyword stops a loop immediately in Python?',
            'code': null,
            'options': ['stop', 'exit', 'break', 'continue'],
            'correct': 2,
            'explanation': 'The `break` statement immediately terminates the loop execution.',
          },
          {
            'question': 'What does `len("CodeQuest")` return in Python?',
            'code': null,
            'options': ['8', '9', '10', 'Error'],
            'correct': 1,
            'explanation': '`len()` counts the number of characters in the string: "CodeQuest" has 9 characters.',
          },
        ];
    }
  }

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) _timeUp();
      });
    _timerController = AnimationController(vsync: this);
    _startTimer();
  }

  void _startTimer() {
    _progressController.forward(from: 0);
  }

  void _timeUp() {
    if (!_hasAnswered) {
      setState(() {
        _hasAnswered = true;
        _lives--;
      });
      if (_lives <= 0) _showResults();
    }
  }

  void _selectOption(int index) {
    if (_hasAnswered) return;
    _progressController.stop();

    setState(() {
      _selectedOption = index;
      _hasAnswered = true;
      if (index == _questions![_currentQuestion]['correct']) {
        _correctAnswers++;
      } else {
        _lives--;
      }
    });
    if (_lives <= 0) _showResults();
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions!.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedOption = null;
        _hasAnswered = false;
      });
      _startTimer();
    } else {
      _showResults();
    }
  }

  void _showResults() {
    final total = _questions!.length;
    final xpEarned = _correctAnswers * 15;
    final passed = total > 0 && _correctAnswers / total >= 0.6;

    // Persist progress & award XP for passed quizzes (was previously
    // display-only and never saved).
    if (passed) {
      ref
          .read(lessonCompletionProvider.notifier)
          .completeLesson(
            lessonId: widget.quizId,
            xpReward: xpEarned,
            coinReward: _correctAnswers * 2,
            score: ((_correctAnswers / total) * 100).round(),
          )
          .catchError((_) => <String, dynamic>{});
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => _QuizResultSheet(
        correct: _correctAnswers,
        total: total,
        xpEarned: xpEarned,
        onFinish: () {
          Navigator.pop(context);
          context.pop();
        },
      ),
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Load this quiz's own questions from Supabase (unique per quiz).
    if (_questions == null) {
      final qsAsync = ref.watch(quizQuestionsProvider(widget.quizId));
      if (qsAsync.isLoading) {
        return const Scaffold(
          body: Center(
              child: CircularProgressIndicator(color: AppColors.neonCyan)),
        );
      }
      final loaded = qsAsync.value ?? [];
      _questions = loaded.isNotEmpty
          ? loaded
              .map((m) => <String, dynamic>{
                    'question': m.question,
                    'code': m.codeSnippet,
                    'options': m.options,
                    'correct': m.correctOptionIndex,
                    'explanation': m.explanation ?? '',
                  })
              .toList()
          : _getFallbackQuestions(widget.quizId);
      // Restart the timer now that the first question is visible.
      _progressController.forward(from: 0);
    }

    final questions = _questions!;
    final q = questions[_currentQuestion];
    final correct = q['correct'] as int;
    final options = q['options'] as List;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: context.cqCardSecondary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.close, color: context.cqTextSecondary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question count
                        Text(
                          'QUESTION ${_currentQuestion + 1} of ${questions.length}',
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 11,
                            color: context.cqTextMuted,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: LinearProgressIndicator(
                            value: (_currentQuestion + 1) / questions.length,
                            backgroundColor: context.cqCardSecondary,
                            valueColor: const AlwaysStoppedAnimation(AppColors.neonCyan),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Lives
                  Row(
                    children: List.generate(3, (i) => Text(
                      i < _lives ? '❤️' : '🖤',
                      style: const TextStyle(fontSize: 16),
                    )),
                  ),
                ],
              ),
            ),

            // Timer bar
            AnimatedBuilder(
              animation: _progressController,
              builder: (context, _) {
                final remaining = 1 - _progressController.value;
                return LinearProgressIndicator(
                  value: remaining,
                  backgroundColor: context.cqCardSecondary,
                  valueColor: AlwaysStoppedAnimation(
                    remaining > 0.4 ? AppColors.neonGreen
                        : remaining > 0.2 ? AppColors.neonOrange
                        : AppColors.error,
                  ),
                  minHeight: 3,
                );
              },
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Question
                    Text(
                      q['question'] as String,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: context.cqTextPrimary,
                        height: 1.5,
                      ),
                    ).animate().fadeIn().slideY(begin: 0.2),

                    // Code snippet if any
                    if (q['code'] != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: context.cqCardSecondary,
                          border: Border.all(color: context.cqSurface),
                        ),
                        child: Text(
                          q['code'] as String,
                          style: const TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 13,
                            color: AppColors.neonGreen,
                            height: 1.6,
                          ),
                        ),
                      ).animate(delay: 100.ms).fadeIn(),
                    ],

                    const SizedBox(height: 28),

                    // Options
                    ...List.generate(options.length, (i) {
                      Color? borderColor;
                      Color? bgColor;
                      IconData? trailingIcon;

                      if (_hasAnswered) {
                        if (i == correct) {
                          borderColor = AppColors.neonGreen;
                          bgColor = AppColors.neonGreen.withOpacity(0.1);
                          trailingIcon = Icons.check_circle;
                        } else if (i == _selectedOption) {
                          borderColor = AppColors.error;
                          bgColor = AppColors.error.withOpacity(0.1);
                          trailingIcon = Icons.cancel;
                        }
                      } else if (i == _selectedOption) {
                        borderColor = AppColors.neonCyan;
                        bgColor = AppColors.neonCyan.withOpacity(0.08);
                      }

                      return GestureDetector(
                        onTap: () => _selectOption(i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: bgColor ?? context.cqCard,
                            border: Border.all(
                              color: borderColor ?? context.cqSurface,
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              // Option letter
                              Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: borderColor?.withOpacity(0.15) ?? context.cqCardSecondary,
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + i),
                                    style: TextStyle(
                                      fontFamily: 'Orbitron',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: borderColor ?? context.cqTextSecondary,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(
                                  options[i] as String,
                                  style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: borderColor != null ? context.cqTextPrimary : context.cqTextSecondary,
                                  ),
                                ),
                              ),
                              if (trailingIcon != null)
                                Icon(trailingIcon, color: borderColor, size: 20),
                            ],
                          ),
                        ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().slideX(begin: 0.15),
                      );
                    }),

                    // Explanation (shown after answering)
                    if (_hasAnswered) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColors.neonCyan.withOpacity(0.05),
                          border: Border.all(color: AppColors.neonCyan.withOpacity(0.2)),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('💡', style: TextStyle(fontSize: 20)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                q['explanation'] as String,
                                style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 14,
                                  color: context.cqTextSecondary,
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(),
                      const SizedBox(height: 20),
                      NeonButton(
                        label: _currentQuestion < questions.length - 1
                            ? 'NEXT QUESTION →'
                            : 'VIEW RESULTS 🏆',
                        onTap: _nextQuestion,
                        gradient: AppColors.cyberpunkGradient,
                        glowColor: AppColors.neonCyan,
                      ).animate().fadeIn().slideY(begin: 0.2),
                    ],

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizResultSheet extends StatelessWidget {
  final int correct;
  final int total;
  final int xpEarned;
  final VoidCallback onFinish;

  const _QuizResultSheet({
    required this.correct,
    required this.total,
    required this.xpEarned,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final percent = correct / total;
    final isPerfect = correct == total;
    final isPass = percent >= 0.6;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: context.cqCard,
        border: Border.all(
          color: isPerfect ? AppColors.neonYellow.withOpacity(0.5)
              : isPass ? AppColors.neonGreen.withOpacity(0.4)
              : AppColors.error.withOpacity(0.3),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isPerfect ? '🏆' : isPass ? '🎯' : '😵',
            style: const TextStyle(fontSize: 60),
          ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 16),
          Text(
            isPerfect ? 'PERFECT SCORE!' : isPass ? 'QUIZ PASSED!' : 'QUIZ FAILED',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isPerfect ? AppColors.neonYellow : isPass ? AppColors.neonGreen : AppColors.error,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '$correct / $total Correct',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: context.cqTextPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.neonYellow.withOpacity(0.1),
              border: Border.all(color: AppColors.neonYellow.withOpacity(0.3)),
            ),
            child: Text(
              '+$xpEarned XP EARNED',
              style: const TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.neonYellow,
              ),
            ),
          ),
          const SizedBox(height: 24),
          NeonButton(
            label: 'CONTINUE',
            onTap: onFinish,
            gradient: AppColors.cyberpunkGradient,
            glowColor: AppColors.neonCyan,
          ),
        ],
      ),
    );
  }
}
