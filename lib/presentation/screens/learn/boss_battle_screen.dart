import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/lessons_provider.dart';
import '../../widgets/common/neon_button.dart';

class BossBattleScreen extends ConsumerStatefulWidget {
  final String bossId;
  const BossBattleScreen({super.key, required this.bossId});

  @override
  ConsumerState<BossBattleScreen> createState() => _BossBattleScreenState();
}

class _BossBattleScreenState extends ConsumerState<BossBattleScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _bossController;
  int _bossHp = 100;
  int _playerHp = 100;
  int _currentQuestion = 0;
  bool _answered = false;
  int? _selected;
  bool _battleOver = false;

  /// Questions for THIS boss, loaded from Supabase in build().
  /// Previously the screen showed one hardcoded question and had
  /// no win/lose handling at all.
  List<Map<String, dynamic>>? _questions;

  static List<Map<String, dynamic>> _getBossFallbackQuestions(String bossId, [String? bossTitle]) {
    final title = (bossTitle ?? '').toLowerCase();
    String lang = 'python';
    if (bossId.startsWith('10000001') || bossId.contains('py')) {
      lang = 'python';
    } else if (bossId.startsWith('20000001') || bossId.contains('js')) {
      lang = 'javascript';
    } else if (bossId.startsWith('30000001') || bossId.contains('dart')) {
      lang = 'dart';
    } else if (bossId.startsWith('40000001') || bossId.contains('java')) {
      lang = 'java';
    } else if (bossId.startsWith('50000001') || bossId.contains('cpp')) {
      lang = 'cpp';
    } else if (bossId.startsWith('60000001') || bossId.contains('c')) {
      lang = 'c';
    }

    if (lang == 'javascript') {
      if (title.contains('dom')) {
        return [
          {
            'question': 'Which method attaches an event listener without overwriting existing ones?',
            'options': ['element.onclick = fn', 'element.addEventListener()', 'element.attach()', 'element.listen()'],
            'correct': 1,
          },
          {
            'question': 'What does event.preventDefault() do?',
            'options': ['Stops event bubbling', 'Prevents default browser action (e.g. form submit)', 'Removes the element', 'Disables JS'],
            'correct': 1,
          },
          {
            'question': 'Which selector selects an element with id "hero"?',
            'options': ['querySelector(".hero")', 'querySelector("#hero")', 'querySelector(r"\$hero")', 'querySelector("@hero")'],
            'correct': 1,
          },
          {
            'question': 'What is event delegation in JavaScript?',
            'options': ['Adding listeners to every child node', 'Handling events on a parent using bubbling', 'Stopping all events', 'Using Web Workers'],
            'correct': 1,
          },
        ];
      } else if (title.contains('async') || title.contains('ninja')) {
        return [
          {
            'question': 'What are the three states of a JavaScript Promise?',
            'options': ['pending, fulfilled, rejected', 'waiting, running, done', 'open, resolved, closed', 'start, working, finish'],
            'correct': 0,
          },
          {
            'question': 'What does the await keyword do?',
            'options': ['Blocks the entire OS thread', 'Pauses async function execution until Promise settles', 'Spawns a worker', 'Retries failed requests'],
            'correct': 1,
          },
          {
            'question': 'What will Promise.all([p1, p2]) do if p1 rejects?',
            'options': ['Ignores p1 and returns p2', 'Immediately rejects with p1 error', 'Retries p1', 'Returns [null, p2]'],
            'correct': 1,
          },
          {
            'question': 'Which task queue has higher priority: Promise microtasks or setTimeout macrotasks?',
            'options': ['setTimeout runs first', 'Promise microtasks run first', 'Random order', 'Simultaneously'],
            'correct': 1,
          },
        ];
      }
      return [
        {
          'question': 'What does typeof NaN return in JavaScript?',
          'options': ['"nan"', '"undefined"', '"number"', '"object"'],
          'correct': 2,
        },
        {
          'question': 'What is the key difference between == and ===?',
          'options': ['== checks types, === does not', '=== checks value and type without coercion', 'They are identical in ES6', '=== is for objects only'],
          'correct': 1,
        },
        {
          'question': 'What does Boolean([]) evaluate to in JavaScript?',
          'options': ['false', 'true', 'undefined', 'TypeError'],
          'correct': 1,
        },
        {
          'question': 'What will console.log(1 + "2" + 3) output?',
          'options': ['"6"', '"123"', '"33"', 'NaN'],
          'correct': 1,
        },
      ];
    } else if (lang == 'dart') {
      if (title.contains('oop') || title.contains('titan')) {
        return [
          {
            'question': 'Which keyword allows code reuse across multiple hierarchies in Dart?',
            'options': ['implements', 'extends', 'with (mixin)', 'abstract'],
            'correct': 2,
          },
          {
            'question': 'What is a factory constructor in Dart used for?',
            'options': ['Creating compile-time constants', 'Returning cached instances or subtypes', 'Allocating raw memory', 'Deleting objects'],
            'correct': 1,
          },
          {
            'question': 'What keyword makes a class implement an interface contract in Dart?',
            'options': ['interface', 'implements', 'inherits', 'conforms'],
            'correct': 1,
          },
          {
            'question': 'What does the cascade operator (..) do in Dart?',
            'options': ['Null check', 'Performs a sequence of operations on the same target', 'Deep copies an object', 'Bitwise shift'],
            'correct': 1,
          },
        ];
      } else if (title.contains('stream')) {
        return [
          {
            'question': 'What is the difference between a Future and a Stream in Dart?',
            'options': ['Future delivers multiple values, Stream delivers one', 'Future delivers one value, Stream delivers multiple events over time', 'They are identical', 'Stream is synchronous'],
            'correct': 1,
          },
          {
            'question': 'Which keyword emits values from an async* generator in Dart?',
            'options': ['return', 'emit', 'yield', 'send'],
            'correct': 2,
          },
          {
            'question': 'What type of Stream allows multiple listeners simultaneously?',
            'options': ['Single-subscription stream', 'BroadcastStream', 'BufferedStream', 'IsolateStream'],
            'correct': 1,
          },
          {
            'question': 'Which function transforms stream events asynchronously in Dart?',
            'options': ['stream.filter()', 'stream.asyncMap()', 'stream.forEach()', 'stream.combine()'],
            'correct': 1,
          },
        ];
      }
      return [
        {
          'question': 'What does String? name signify in Dart sound null safety?',
          'options': ['name can never be null', 'name can hold a String or null', 'name is a pointer', 'name is constant'],
          'correct': 1,
        },
        {
          'question': 'What does the null-coalescing operator ?? return in a ?? b?',
          'options': ['Throws exception if null', 'Returns a if not null, otherwise returns b', 'Forces non-null cast', 'Checks equality'],
          'correct': 1,
        },
        {
          'question': 'What is the difference between final and const in Dart?',
          'options': ['final is compile-time, const is runtime', 'const is compile-time constant, final is runtime single-assignment', 'They are identical', 'const is reassignable'],
          'correct': 1,
        },
        {
          'question': 'Which operator safely accesses a property on a nullable variable in Dart?',
          'options': ['name!.length', 'name?.length', 'name??.length', 'name->length'],
          'correct': 1,
        },
      ];
    } else if (lang == 'java') {
      if (title.contains('stream')) {
        return [
          {
            'question': 'Are intermediate operations like filter() and map() on Java Streams lazy or eager?',
            'options': ['Eager (execute immediately)', 'Lazy (execute only upon terminal operation)', 'Depends on JVM flags', 'Synchronous only'],
            'correct': 1,
          },
          {
            'question': 'Which of these is a terminal operation on a Java Stream?',
            'options': ['map()', 'filter()', 'sorted()', 'collect()'],
            'correct': 3,
          },
          {
            'question': 'What does Optional<T> protect against in Java?',
            'options': ['OutOfMemoryError', 'NullPointerException', 'StackOverflowError', 'ClassCastException'],
            'correct': 1,
          },
          {
            'question': 'What does parallelStream() use internally for execution?',
            'options': ['GPU shaders', 'ForkJoinPool.commonPool()', 'Single daemon thread', 'Disk swap'],
            'correct': 1,
          },
        ];
      }
      return [
        {
          'question': 'What is the size of a long primitive in Java?',
          'options': ['32 bits', '64 bits (8 bytes)', '128 bits', 'Platform dependent'],
          'correct': 1,
        },
        {
          'question': 'Where are objects created with "new" allocated in Java?',
          'options': ['Stack', 'Heap memory', 'CPU registers', 'Code segment'],
          'correct': 1,
        },
        {
          'question': 'What does == compare when used on two non-primitive Object references in Java?',
          'options': ['Field values', 'Memory addresses (reference identity)', 'Hash codes', 'String characters'],
          'correct': 1,
        },
        {
          'question': 'Which access modifier allows access within the package and by subclasses anywhere?',
          'options': ['private', 'default (package-private)', 'protected', 'public'],
          'correct': 2,
        },
      ];
    } else if (lang == 'cpp') {
      if (title.contains('vtable') || title.contains('vampire')) {
        return [
          {
            'question': 'Why should base class destructors be marked virtual in C++?',
            'options': ['To prevent heap allocation', 'To ensure derived class destructor runs on deletion via base pointer', 'To make class abstract', 'To inline destruction'],
            'correct': 1,
          },
          {
            'question': 'What defines a pure virtual function in C++?',
            'options': ['virtual void f() = 0;', 'virtual void f() {}', 'void f() pure;', 'inline virtual void f();'],
            'correct': 0,
          },
          {
            'question': 'What is the Vtable in C++ polymorphism?',
            'options': ['Local variable storage', 'Table of function pointers for runtime method dispatch', 'Array of strings', 'Compiler symbol table'],
            'correct': 1,
          },
          {
            'question': 'What does dynamic_cast do in C++?',
            'options': ['Compile-time bit cast', 'Safely downcasts polymorphic pointers with runtime check', 'Reinterprets raw memory', 'Casts away const'],
            'correct': 1,
          },
        ];
      } else if (title.contains('stl') || title.contains('sorcerer')) {
        return [
          {
            'question': 'What is the average time complexity of lookup in std::unordered_map in C++?',
            'options': ['O(1)', 'O(log n)', 'O(n)', 'O(n log n)'],
            'correct': 0,
          },
          {
            'question': 'Which header provides std::sort in C++?',
            'options': ['<sort>', '<vector>', '<algorithm>', '<utility>'],
            'correct': 2,
          },
          {
            'question': 'What does std::move do in modern C++?',
            'options': ['Copies data in background', 'Unconditionally casts to rvalue reference', 'Frees source heap', 'Creates shared pointer'],
            'correct': 1,
          },
          {
            'question': 'Which smart pointer ensures exclusive unique ownership in C++11?',
            'options': ['std::shared_ptr', 'std::unique_ptr', 'std::weak_ptr', 'std::auto_ptr'],
            'correct': 1,
          },
        ];
      }
      return [
        {
          'question': 'Which operator retrieves the memory address of a variable in C++?',
          'options': ['*', '&', '->', '@'],
          'correct': 1,
        },
        {
          'question': 'What happens if you allocate heap memory with new and never call delete in C++?',
          'options': ['Garbage collector cleans it', 'Memory leak', 'Instant segmentation fault', 'Compilation error'],
          'correct': 1,
        },
        {
          'question': 'What is a dangling pointer in C++?',
          'options': ['A pointer to nullptr', 'A pointer holding the address of already freed memory', 'An uninitialized pointer', 'A void pointer'],
          'correct': 1,
        },
        {
          'question': 'What does & signify in a function parameter: void foo(int& x)?',
          'options': ['Pass by value', 'Pass by reference (alias to original variable)', 'Address calculation', 'Bitwise AND'],
          'correct': 1,
        },
      ];
    } else if (lang == 'c') {
      if (title.contains('array')) {
        return [
          {
            'question': 'What happens when an array name is passed to a function in C?',
            'options': ['A full copy is created', 'It decays to a pointer to its first element', 'Compile error', 'Converted to a struct'],
            'correct': 1,
          },
          {
            'question': 'What is *(arr + 3) equivalent to in C?',
            'options': ['arr[3]', 'arr + 3', '&arr[3]', 'arr[0] + 3'],
            'correct': 0,
          },
          {
            'question': 'Which function compares two C strings lexicographically?',
            'options': ['string_cmp()', 'strcmp()', 'memcmp()', 'equals()'],
            'correct': 1,
          },
          {
            'question': 'What is the size in bytes of int arr[5] when sizeof(int) is 4?',
            'options': ['5 bytes', '20 bytes', '4 bytes', '40 bytes'],
            'correct': 1,
          },
        ];
      } else if (title.contains('memory') || title.contains('allocator')) {
        return [
          {
            'question': 'What does malloc return if memory allocation fails in C?',
            'options': ['Throws an exception', 'NULL', 'Terminates program', 'Returns empty buffer'],
            'correct': 1,
          },
          {
            'question': 'What is the key difference between malloc and calloc in C?',
            'options': ['calloc is on stack', 'calloc initializes allocated memory bytes to zero', 'calloc cannot be freed', 'malloc takes 2 params'],
            'correct': 1,
          },
          {
            'question': 'What is a double-free bug in C?',
            'options': ['Allocating memory twice', 'Calling free() twice on the same memory pointer', 'Doubling heap buffer', 'Freeing NULL pointer'],
            'correct': 1,
          },
          {
            'question': 'What should a pointer be set to immediately after calling free(p)?',
            'options': ['1', 'NULL', 'EOF', 'Leave it unchanged'],
            'correct': 1,
          },
        ];
      }
      return [
        {
          'question': 'What character terminates every valid string in C?',
          'options': ['"\\n"', "'\\0' (null character)", "EOF", "' ' (space)"],
          'correct': 1,
        },
        {
          'question': 'What does sizeof(char) equal according to the C standard?',
          'options': ['1 byte always', '4 bytes', '2 bytes', 'Platform dependent'],
          'correct': 0,
        },
        {
          'question': 'What is undefined behavior in C?',
          'options': ['A syntax error', 'Execution where the C standard imposes no requirements', 'A compiler warning', 'A safe exception'],
          'correct': 1,
        },
        {
          'question': 'Why is scanf("%s", buf) considered unsafe in C?',
          'options': ['Does not support numbers', 'Does not limit input length, risking buffer overflow', 'Requires root permissions', 'Deprecated in C99'],
          'correct': 1,
        },
      ];
    }

    // Default Python Boss
    if (title.contains('loop')) {
      return [
        {
          'question': 'How many times does for i in range(1, 10, 2) iterate?',
          'options': ['4 times', '5 times (1, 3, 5, 7, 9)', '9 times', '10 times'],
          'correct': 1,
        },
        {
          'question': 'Which keyword terminates a loop immediately in Python?',
          'options': ['continue', 'pass', 'break', 'return'],
          'correct': 2,
        },
        {
          'question': 'What is the output of [x for x in range(6) if x % 2 == 0]?',
          'options': ['[1, 3, 5]', '[0, 2, 4]', '[2, 4, 6]', '[0, 2, 4, 6]'],
          'correct': 1,
        },
        {
          'question': 'What does a while False: loop body do in Python?',
          'options': ['Runs once', 'Runs infinitely', 'Never executes', 'Throws syntax error'],
          'correct': 2,
        },
      ];
    } else if (title.contains('function')) {
      return [
        {
          'question': 'What does a Python function return if it has no return statement?',
          'options': ['0', 'False', 'None', 'undefined'],
          'correct': 2,
        },
        {
          'question': 'What does *args in a function definition collect?',
          'options': ['Keyword args as dict', 'Extra positional args as a tuple', 'List of strings', 'Global variables'],
          'correct': 1,
        },
        {
          'question': 'What is the result of (lambda a, b: a * b + 2)(3, 4)?',
          'options': ['14', '18', '24', '12'],
          'correct': 0,
        },
        {
          'question': 'Can a Python function modify a global variable without the "global" keyword?',
          'options': ['Yes, anytime', 'No, assigning to it creates a local variable instead', 'Only for integers', 'Only in Python 2'],
          'correct': 1,
        },
      ];
    }

    return [
      {
        'question': 'What happens when you run float("3.1415") in Python?',
        'options': ['Returns integer 3', 'Returns float 3.1415', 'Throws ValueError', 'Returns string'],
        'correct': 1,
      },
      {
        'question': 'Which of these variable names is INVALID in Python?',
        'options': ['_secret', 'data_2026', '2_fast', 'userScore'],
        'correct': 2,
      },
      {
        'question': 'What is the data type of the value True in Python?',
        'options': ['<class "bool">', '<class "int">', '<class "boolean">', '<class "str">'],
        'correct': 0,
      },
      {
        'question': 'What does x = 5; x += 3 * 2 evaluate to for x in Python?',
        'options': ['16', '11', '13', '10'],
        'correct': 1,
      },
    ];
  }

  @override
  void initState() {
    super.initState();
    _bossController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _bossController.dispose();
    super.dispose();
  }

  void _answer(int index) {
    if (_answered || _battleOver) return;
    final correct = _questions![_currentQuestion]['correct'] as int;
    setState(() {
      _answered = true;
      _selected = index;
      if (index == correct) {
        _bossHp = (_bossHp - 25).clamp(0, 100);
      } else {
        _playerHp = (_playerHp - 20).clamp(0, 100);
      }
    });

    Future.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      if (_bossHp <= 0) {
        _endBattle(victory: true);
      } else if (_playerHp <= 0) {
        _endBattle(victory: false);
      } else {
        setState(() {
          _answered = false;
          _selected = null;
          _currentQuestion = (_currentQuestion + 1) % _questions!.length;
        });
      }
    });
  }

  void _endBattle({required bool victory}) {
    setState(() => _battleOver = true);

    const xp = 150;
    const coins = 40;
    if (victory) {
      // Persist progress & award XP for defeating the boss.
      ref
          .read(lessonCompletionProvider.notifier)
          .completeLesson(
            lessonId: widget.bossId,
            xpReward: xp,
            coinReward: coins,
            score: _playerHp,
          )
          .catchError((_) => <String, dynamic>{});
    }

    final lang = _getBossLanguage(widget.bossId);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => _BattleResultSheet(
        victory: victory,
        xp: victory ? xp : 0,
        coins: victory ? coins : 0,
        onFinish: () {
          Navigator.pop(context);
          context.pop();
        },
        onViewCertificate: () {
          Navigator.pop(context);
          context.push('/certificate/$lang');
        },
      ),
    );
  }

  static String _getBossLanguage(String bossId, [String? bossTitle]) {
    final title = (bossTitle ?? '').toLowerCase();
    if (bossId.startsWith('10000001') || bossId.contains('py') || title.contains('python')) {
      return 'python';
    } else if (bossId.startsWith('20000001') || bossId.contains('js') || title.contains('javascript')) {
      return 'javascript';
    } else if (bossId.startsWith('30000001') || bossId.contains('dart') || title.contains('dart')) {
      return 'dart';
    } else if (bossId.startsWith('40000001') || bossId.contains('java') || title.contains('java')) {
      return 'java';
    } else if (bossId.startsWith('50000001') || bossId.contains('cpp') || title.contains('c++')) {
      return 'cpp';
    } else if (bossId.startsWith('60000001') || bossId.contains('c') || title.contains(' c ')) {
      return 'c';
    }
    return 'python';
  }

  @override
  Widget build(BuildContext context) {
    // Boss name from the lesson title (falls back to a generic name).
    final lessonAsync = ref.watch(lessonDetailProvider(widget.bossId));
    final bossName = (lessonAsync.value?.title ?? 'CODE BOSS').toUpperCase();

    // Load this boss lesson's own questions from Supabase.
    if (_questions == null) {
      final qsAsync = ref.watch(quizQuestionsProvider(widget.bossId));
      if (qsAsync.isLoading) {
        return const Scaffold(
          backgroundColor: Color(0xFF0A0A1A),
          body: Center(
              child: CircularProgressIndicator(color: AppColors.neonPink)),
        );
      }
      final loaded = qsAsync.value ?? [];
      _questions = loaded.isNotEmpty
          ? loaded
              .map((m) => <String, dynamic>{
                    'question': m.question,
                    'options': m.options,
                    'correct': m.correctOptionIndex,
                  })
              .toList()
          : _getBossFallbackQuestions(widget.bossId, bossName);
    }

    final q = _questions![_currentQuestion];
    final options = (q['options'] as List).cast<String>();
    final correct = q['correct'] as int;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: Stack(
        children: [
          // Dramatic background
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.3),
                radius: 1.5,
                colors: [Color(0xFF2D0A4E), Color(0xFF0A0A1A)],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // HP bars
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _HpBar(
                          label: 'YOU',
                          hp: _playerHp,
                          maxHp: 100,
                          color: AppColors.neonGreen,
                          icon: '🥷'),
                      const SizedBox(height: 12),
                      _HpBar(
                          label: bossName,
                          hp: _bossHp,
                          maxHp: 100,
                          color: AppColors.neonPink,
                          icon: '🐲',
                          isEnemy: true),
                    ],
                  ),
                ),

                // Boss sprite
                Expanded(
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _bossController,
                      builder: (_, __) => Transform.translate(
                        offset: Offset(0, -8 * _bossController.value),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('🐲', style: TextStyle(fontSize: 120))
                                .animate()
                                .scale(
                                    duration: 800.ms,
                                    curve: Curves.elasticOut),
                            const SizedBox(height: 8),
                            Text(bossName,
                                style: const TextStyle(
                                    fontFamily: 'Orbitron',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.neonPink,
                                    letterSpacing: 2)),
                            const SizedBox(height: 4),
                            Text(
                                'Question ${_currentQuestion + 1} of ${_questions!.length}',
                                style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 14,
                                    color: AppColors.textSecondary)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Challenge area
                Container(
                  margin: const EdgeInsets.all(20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.bgCard,
                    border: Border.all(
                        color: AppColors.neonPurple.withOpacity(0.4)),
                  ),
                  child: Column(
                    children: [
                      const Text('⚔️ BOSS CHALLENGE',
                          style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neonPurple,
                              letterSpacing: 2)),
                      const SizedBox(height: 12),
                      Text(
                        q['question'] as String,
                        style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 16,
                            color: AppColors.textPrimary,
                            height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      ...options.asMap().entries.map((e) {
                        Color border = AppColors.bgSurface;
                        Color bg = AppColors.bgCardSecondary;
                        if (_answered) {
                          if (e.key == correct) {
                            border = AppColors.neonGreen;
                            bg = AppColors.neonGreen.withOpacity(0.12);
                          } else if (e.key == _selected) {
                            border = AppColors.error;
                            bg = AppColors.error.withOpacity(0.12);
                          }
                        }
                        return GestureDetector(
                          onTap: () => _answer(e.key),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: double.infinity,
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: bg,
                              border: Border.all(color: border),
                            ),
                            child: Text(e.value,
                                style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 15,
                                    color: AppColors.textPrimary),
                                textAlign: TextAlign.center),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BattleResultSheet extends StatelessWidget {
  final bool victory;
  final int xp;
  final int coins;
  final VoidCallback onFinish;
  final VoidCallback? onViewCertificate;

  const _BattleResultSheet({
    required this.victory,
    required this.xp,
    required this.coins,
    required this.onFinish,
    this.onViewCertificate,
  });

  @override
  Widget build(BuildContext context) {
    final color = victory ? AppColors.neonGreen : AppColors.error;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: AppColors.bgCard,
        border: Border.all(color: color.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 30)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(victory ? '🏆' : '💀', style: const TextStyle(fontSize: 60))
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 16),
          Text(
            victory ? 'BOSS DEFEATED!' : 'YOU WERE DEFEATED',
            style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
                letterSpacing: 2),
          ),
          const SizedBox(height: 20),
          if (victory)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.neonYellow.withOpacity(0.1),
                      border: Border.all(
                          color: AppColors.neonYellow.withOpacity(0.4))),
                  child: Text('+$xp XP',
                      style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neonYellow)),
                ),
                const SizedBox(width: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: AppColors.neonOrange.withOpacity(0.1),
                      border: Border.all(
                          color: AppColors.neonOrange.withOpacity(0.4))),
                  child: Text('+$coins 🪙',
                      style: const TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.neonOrange)),
                ),
              ],
            )
          else
            Text('Train harder and challenge the boss again!',
                style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 15,
                    color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          NeonButton(
              label: victory ? 'CLAIM REWARDS' : 'RETREAT',
              onTap: onFinish,
              gradient: AppColors.cyberpunkGradient,
              glowColor: AppColors.neonCyan),
          if (victory && onViewCertificate != null) ...[
            const SizedBox(height: 10),
            GestureDetector(
              onTap: onViewCertificate,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFFC59B27).withOpacity(0.12),
                  border: Border.all(color: const Color(0xFFC59B27).withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.workspace_premium, color: Color(0xFFFFD54F), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'VIEW CERTIFICATE',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD54F),
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _HpBar extends StatelessWidget {
  final String label;
  final int hp;
  final int maxHp;
  final Color color;
  final String icon;
  final bool isEnemy;

  const _HpBar(
      {required this.label,
      required this.hp,
      required this.maxHp,
      required this.color,
      required this.icon,
      this.isEnemy = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (!isEnemy) Text(icon, style: const TextStyle(fontSize: 24)),
        if (!isEnemy) const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment:
                isEnemy ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 11,
                      color: color,
                      letterSpacing: 1.5)),
              SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: hp / maxHp,
                  backgroundColor: AppColors.bgSurface,
                  valueColor: AlwaysStoppedAnimation(color),
                  minHeight: 10,
                ),
              ),
              Text('$hp / $maxHp',
                  style: TextStyle(
                      fontFamily: 'Share Tech Mono',
                      fontSize: 10,
                      color: AppColors.textMuted)),
            ],
          ),
        ),
        if (isEnemy) const SizedBox(width: 8),
        if (isEnemy) Text(icon, style: const TextStyle(fontSize: 24)),
      ],
    );
  }
}
