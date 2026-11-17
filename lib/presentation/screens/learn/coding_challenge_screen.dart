import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/code_execution_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/lesson_model.dart';
import '../../providers/lessons_provider.dart';
import '../../widgets/common/neon_button.dart';

class CodingChallengeScreen extends ConsumerStatefulWidget {
  final String challengeId;
  const CodingChallengeScreen({super.key, required this.challengeId});

  @override
  ConsumerState<CodingChallengeScreen> createState() =>
      _CodingChallengeScreenState();
}

class _CodingChallengeScreenState extends ConsumerState<CodingChallengeScreen> {
  final TextEditingController _codeController = TextEditingController();
  bool _isRunning = false;
  bool _isSubmitting = false;
  String? _output;
  List<Map<String, dynamic>> _testResults = [];
  int _hintsUsed = 0;
  bool _showHint = false;

  /// The challenge loaded from Supabase for THIS lesson.
  CodingChallengeModel? _challenge;
  bool _starterLoaded = false;

  static String _detectLanguage(String id) {
    final lower = id.toLowerCase();
    if (lower.startsWith('10000001') || lower.contains('python') || lower.contains('py')) return 'python';
    if (lower.startsWith('20000001') || lower.contains('javascript') || lower.contains('js')) return 'javascript';
    if (lower.startsWith('30000001') || lower.contains('dart')) return 'dart';
    if (lower.startsWith('50000001') || lower.contains('cpp') || lower.contains('c++')) return 'cpp';
    if (lower.startsWith('40000001') || lower.contains('java')) return 'java';
    if (lower.startsWith('60000001') || lower.contains('clang') || lower.contains('_c_') || lower.contains('c-lang') || lower.endsWith('-c')) return 'c';
    return 'python';
  }

  static CodingChallengeModel _getFallbackChallenge(String challengeId) {
    final lang = _detectLanguage(challengeId);
    switch (lang) {
      case 'javascript':
        return const CodingChallengeModel(
          id: 'fb_js',
          title: 'Sum Two Numbers (JavaScript)',
          description:
              'Write a function `sumTwoNumbers(a, b)` that takes two numbers and returns their sum.',
          starterCode: '''function sumTwoNumbers(a, b) {
    // Write your solution here
    return a + b;
}

// Test
console.log(sumTwoNumbers(3, 5)); // Expected: 8
''',
          solutionCode: '''function sumTwoNumbers(a, b) {
    return a + b;
}
console.log(sumTwoNumbers(3, 5));
''',
          testCases: [],
          languageId: 'javascript',
          timeLimit: 10,
          memoryLimit: 128,
          hints: [
            'Use the + operator to compute the sum.',
            'Return the sum with "return a + b;".',
          ],
        );

      case 'dart':
        return const CodingChallengeModel(
          id: 'fb_dart',
          title: 'Sum Two Numbers (Dart)',
          description:
              'Write a function `sumTwoNumbers(int a, int b)` that returns the sum of two integers.',
          starterCode: '''int sumTwoNumbers(int a, int b) {
  // Write your solution here
  return a + b;
}

void main() {
  print(sumTwoNumbers(3, 5)); // Expected: 8
}
''',
          solutionCode: '''int sumTwoNumbers(int a, int b) {
  return a + b;
}

void main() {
  print(sumTwoNumbers(3, 5));
}
''',
          testCases: [],
          languageId: 'dart',
          timeLimit: 10,
          memoryLimit: 128,
          hints: [
            'Declare the return type as int.',
            'Use "return a + b;" inside the function body.',
          ],
        );

      case 'java':
        return const CodingChallengeModel(
          id: 'fb_java',
          title: 'Sum Two Numbers (Java)',
          description:
              'Implement the static method `sum(int a, int b)` to return the sum of two integers.',
          starterCode: '''public class Main {
    public static int sum(int a, int b) {
        // Write your solution here
        return a + b;
    }

    public static void main(String[] args) {
        System.out.println(sum(3, 5)); // Expected: 8
    }
}
''',
          solutionCode: '''public class Main {
    public static int sum(int a, int b) {
        return a + b;
    }

    public static void main(String[] args) {
        System.out.println(sum(3, 5));
    }
}
''',
          testCases: [],
          languageId: 'java',
          timeLimit: 10,
          memoryLimit: 128,
          hints: [
            'Use the static modifier so the method can be called from main.',
            'Return the sum with "return a + b;".',
          ],
        );

      case 'cpp':
        return const CodingChallengeModel(
          id: 'fb_cpp',
          title: 'Sum Two Numbers (C++)',
          description:
              'Write a function `sumTwoNumbers(int a, int b)` that returns the sum of two integers.',
          starterCode: '''#include <iostream>

int sumTwoNumbers(int a, int b) {
    // Write your solution here
    return a + b;
}

int main() {
    std::cout << sumTwoNumbers(3, 5) << std::endl; // Expected: 8
    return 0;
}
''',
          solutionCode: '''#include <iostream>

int sumTwoNumbers(int a, int b) {
    return a + b;
}

int main() {
    std::cout << sumTwoNumbers(3, 5) << std::endl;
    return 0;
}
''',
          testCases: [],
          languageId: 'cpp',
          timeLimit: 10,
          memoryLimit: 128,
          hints: [
            'Use the + operator to add integers.',
            'Return a + b;',
          ],
        );

      case 'c':
        return const CodingChallengeModel(
          id: 'fb_c',
          title: 'Sum Two Numbers (C)',
          description:
              'Write a function `sum(int a, int b)` that returns the sum of two integers.',
          starterCode: '''#include <stdio.h>

int sum(int a, int b) {
    // Write your solution here
    return a + b;
}

int main() {
    printf("%d\\n", sum(3, 5)); // Expected: 8
    return 0;
}
''',
          solutionCode: '''#include <stdio.h>

int sum(int a, int b) {
    return a + b;
}

int main() {
    printf("%d\\n", sum(3, 5));
    return 0;
}
''',
          testCases: [],
          languageId: 'c',
          timeLimit: 10,
          memoryLimit: 128,
          hints: [
            'Declare the function as int sum(int a, int b).',
            'Return a + b;',
          ],
        );

      case 'python':
      default:
        return const CodingChallengeModel(
          id: 'fb_py',
          title: 'Sum Two Numbers (Python)',
          description:
              'Write a function `sum_two_numbers(a, b)` that takes two integers and returns their sum.',
          starterCode: '''def sum_two_numbers(a, b):
    # Write your solution here
    return a + b

# Test
print(sum_two_numbers(3, 5))  # Expected: 8
''',
          solutionCode: '''def sum_two_numbers(a, b):
    return a + b

print(sum_two_numbers(3, 5))
''',
          testCases: [],
          languageId: 'python',
          timeLimit: 10,
          memoryLimit: 128,
          hints: [
            'Use the + operator to add a and b.',
            'Make sure to return the result with the return keyword.',
          ],
        );
    }
  }

  @override
  void initState() {
    super.initState();
    final fallback = _getFallbackChallenge(widget.challengeId);
    _challenge = fallback;
    _codeController.text = fallback.starterCode;
  }

  String get _languageId => _challenge?.languageId ?? _detectLanguage(widget.challengeId);

  String get _fileName {
    switch (_languageId) {
      case 'javascript': return 'main.js';
      case 'dart': return 'main.dart';
      case 'java': return 'Main.java';
      case 'cpp': return 'main.cpp';
      case 'c': return 'main.c';
      default: return 'main.py';
    }
  }

  String get _currentHint {
    final hints = _challenge?.hints ?? const <String>[];
    if (hints.isEmpty) {
      return 'Break the problem into small steps and test as you go.';
    }
    final idx = (_hintsUsed - 1).clamp(0, hints.length - 1);
    return hints[idx];
  }

  Future<void> _runCode() async {
    setState(() {
      _isRunning = true;
      _output = null;
      _testResults = [];
    });
    final result = await CodeExecutionService.instance.execute(
      languageId: _languageId,
      code: _codeController.text,
    );
    if (!mounted) return;
    setState(() {
      _isRunning = false;
      _output = result.output.isEmpty ? '(no output)' : result.output;
    });
  }

  Future<void> _submitCode() async {
    setState(() {
      _isSubmitting = true;
      _testResults = [];
      _output = null;
    });

    final userRun = await CodeExecutionService.instance.execute(
      languageId: _languageId,
      code: _codeController.text,
    );

    // Judge by comparing against the reference solution's output.
    String expected = '';
    final solution = _challenge?.solutionCode ?? '';
    if (solution.trim().isNotEmpty) {
      final solutionRun = await CodeExecutionService.instance.execute(
        languageId: _languageId,
        code: solution,
      );
      expected = solutionRun.stdout.trim();
    }

    if (!mounted) return;

    final got = userRun.stdout.trim();
    final passed = userRun.success &&
        got.isNotEmpty &&
        (expected.isEmpty || got == expected);

    setState(() {
      _isSubmitting = false;
      _testResults = [
        {
          'input': 'program',
          'expected': expected.isEmpty ? '(runs without errors)' : expected,
          'output': userRun.success ? got : userRun.stderr.trim(),
          'passed': passed,
        },
      ];
    });

    if (passed) _showSuccessSheet();
  }

  void _showSuccessSheet() {
    final xp = (100 - (_hintsUsed * 20)).clamp(20, 100);
    const coins = 25;

    // Persist progress & award XP (previously display-only).
    ref
        .read(lessonCompletionProvider.notifier)
        .completeLesson(
          lessonId: widget.challengeId,
          xpReward: xp,
          coinReward: coins,
          languageId: _challenge?.languageId,
        )
        .catchError((_) => <String, dynamic>{});

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChallengeSuccessSheet(
        xp: xp,
        coins: coins,
        onFinish: () {
          Navigator.pop(context);
          context.pop();
        },
      ),
    );
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Load this lesson's own challenge from Supabase.
    final challengeAsync =
        ref.watch(codingChallengeProvider(widget.challengeId));
    if (challengeAsync.hasValue && challengeAsync.value != null && !_starterLoaded) {
      _starterLoaded = true;
      _challenge = challengeAsync.value;
      if (_challenge!.starterCode.trim().isNotEmpty) {
        _codeController.text = _challenge!.starterCode;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CODING CHALLENGE', style: TextStyle(fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
        actions: [
          // Hint button
          TextButton.icon(
            onPressed: () {
              setState(() {
                if (!_showHint && _hintsUsed < 3) _hintsUsed++;
                _showHint = !_showHint;
              });
            },
            icon: const Text('💡', style: TextStyle(fontSize: 16)),
            label: Text(
              'HINT (${(3 - _hintsUsed).clamp(0, 3)} left)',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13,
                color: AppColors.neonYellow,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Problem description
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Problem header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: AppColors.neonGreen.withOpacity(0.15),
                          border: Border.all(color: AppColors.neonGreen.withOpacity(0.3)),
                        ),
                        child: Text(
                          'EASY',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 10,
                            color: AppColors.neonGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text('⭐ 100 XP', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, color: context.cqTextSecondary)),
                      SizedBox(width: 8),
                      Text('🪙 25', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, color: context.cqTextSecondary)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _challenge?.title ?? 'Coding Challenge',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: context.cqTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _challenge?.description ??
                        'Write a function that solves the problem and returns the correct result.',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 15,
                      color: context.cqTextSecondary,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_challenge == null || _challenge!.id.startsWith('fb_'))
                    const _ExampleBox(
                      input: '3, 5',
                      output: '8',
                      explanation: '3 + 5 = 8',
                    ),

                  if (_showHint) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.neonYellow.withOpacity(0.08),
                        border: Border.all(color: AppColors.neonYellow.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 18)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              _currentHint,
                              style: const TextStyle(
                                fontFamily: 'Rajdhani',
                                fontSize: 14,
                                color: AppColors.neonYellow,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(),
                  ],
                ],
              ),
            ),
          ),

          // Divider
          Container(height: 1, color: context.cqSurface),

          // Code editor
          Expanded(
            flex: 3,
            child: Container(
              color: context.cqCardSecondary,
              child: Column(
                children: [
                  // Editor toolbar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: context.cqBgSecondary,
                      border: Border(bottom: BorderSide(color: context.cqSurface)),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _fileName,
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 13,
                            color: AppColors.neonCyan,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: _isRunning ? null : _runCode,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: AppColors.neonGreen.withOpacity(0.15),
                              border: Border.all(color: AppColors.neonGreen.withOpacity(0.4)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _isRunning
                                    ? SizedBox(
                                        width: 14,
                                        height: 14,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor: AlwaysStoppedAnimation(AppColors.neonGreen),
                                        ),
                                      )
                                    : const Icon(Icons.play_arrow, color: AppColors.neonGreen, size: 18),
                                const SizedBox(width: 6),
                                Text(
                                  _isRunning ? 'RUNNING...' : 'RUN',
                                  style: TextStyle(
                                    fontFamily: 'Orbitron',
                                    fontSize: 11,
                                    color: AppColors.neonGreen,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Code text area
                  Expanded(
                    child: TextField(
                      controller: _codeController,
                      maxLines: null,
                      expands: true,
                      style: const TextStyle(
                        fontFamily: 'Share Tech Mono',
                        fontSize: 13,
                        color: AppColors.neonGreen,
                        height: 1.6,
                      ),
                      decoration: const InputDecoration(
                        filled: false,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                      ),
                      keyboardType: TextInputType.multiline,
                    ),
                  ),

                  // Output section
                  if (_output != null || _testResults.isNotEmpty)
                    Container(
                      constraints: BoxConstraints(maxHeight: 160),
                      decoration: BoxDecoration(
                        color: context.cqBg,
                        border: Border(top: BorderSide(color: context.cqSurface)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                            child: Text(
                              _testResults.isNotEmpty ? 'TEST RESULTS' : 'OUTPUT',
                              style: TextStyle(
                                fontFamily: 'Share Tech Mono',
                                fontSize: 10,
                                color: context.cqTextMuted,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                              child: _testResults.isNotEmpty
                                  ? Column(
                                      children: _testResults.map((t) => Row(
                                        children: [
                                          Icon(
                                            t['passed'] ? Icons.check_circle : Icons.cancel,
                                            color: t['passed'] ? AppColors.neonGreen : AppColors.error,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            'Input: ${t['input']}  → Expected: ${t['expected']}  Got: ${t['output']}',
                                            style: TextStyle(
                                              fontFamily: 'Share Tech Mono',
                                              fontSize: 11,
                                              color: t['passed'] ? AppColors.neonGreen : AppColors.error,
                                            ),
                                          ),
                                        ],
                                      )).toList(),
                                    )
                                  : Text(
                                      _output ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Share Tech Mono',
                                        fontSize: 12,
                                        color: AppColors.neonGreen,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Submit button
          Container(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: BoxDecoration(
              color: context.cqBgSecondary,
              border: Border(top: BorderSide(color: context.cqSurface)),
            ),
            child: NeonButton(
              label: 'SUBMIT SOLUTION',
              onTap: _submitCode,
              isLoading: _isSubmitting,
              gradient: AppColors.cyberpunkGradient,
              glowColor: AppColors.neonCyan,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleBox extends StatelessWidget {
  final String input;
  final String output;
  final String? explanation;

  const _ExampleBox({required this.input, required this.output, this.explanation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cqCardSecondary,
        border: Border.all(color: context.cqSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Example:', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: context.cqTextMuted)),
          SizedBox(height: 6),
          Row(children: [
            Text('Input: ', style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 12, color: context.cqTextSecondary)),
            Text(input, style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 12, color: AppColors.neonCyan)),
          ]),
          Row(children: [
            Text('Output: ', style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 12, color: context.cqTextSecondary)),
            Text(output, style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 12, color: AppColors.neonGreen)),
          ]),
          if (explanation != null) ...[
            SizedBox(height: 4),
            Text(explanation!, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: context.cqTextMuted)),
          ],
        ],
      ),
    );
  }
}

class _ChallengeSuccessSheet extends StatelessWidget {
  final int xp;
  final int coins;
  final VoidCallback onFinish;

  const _ChallengeSuccessSheet({required this.xp, required this.coins, required this.onFinish});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: context.cqCard,
        border: Border.all(color: AppColors.neonGreen.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: AppColors.neonGreen.withOpacity(0.15), blurRadius: 30)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💻', style: TextStyle(fontSize: 60)).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 16),
          const Text('CHALLENGE SOLVED!', style: TextStyle(fontFamily: 'Orbitron', fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.neonGreen, letterSpacing: 2)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.neonYellow.withOpacity(0.1), border: Border.all(color: AppColors.neonYellow.withOpacity(0.4))),
                child: Text('+$xp XP', style: const TextStyle(fontFamily: 'Orbitron', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.neonYellow)),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: AppColors.neonOrange.withOpacity(0.1), border: Border.all(color: AppColors.neonOrange.withOpacity(0.4))),
                child: Text('+$coins 🪙', style: const TextStyle(fontFamily: 'Orbitron', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.neonOrange)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          NeonButton(label: 'CONTINUE', onTap: onFinish, gradient: AppColors.cyberpunkGradient, glowColor: AppColors.neonCyan),
        ],
      ),
    );
  }
}
