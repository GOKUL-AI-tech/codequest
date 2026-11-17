import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/theme/app_theme.dart';

// ─── Card model ───────────────────────────────────────────────────────────────

class _Flashcard {
  final String id;
  final String category;
  final String front;
  final String back;
  final String? codeExample;

  const _Flashcard({
    required this.id,
    required this.category,
    required this.front,
    required this.back,
    this.codeExample,
  });
}

// ─── SM-2 state ───────────────────────────────────────────────────────────────

class _CardState {
  int interval;      // days until next review
  double easeFactor; // >= 1.3
  int repetitions;
  DateTime nextReview;

  _CardState()
      : interval = 0,
        easeFactor = 2.5,
        repetitions = 0,
        nextReview = DateTime.now();

  _CardState.fromMap(Map m)
      : interval = m['interval'] ?? 0,
        easeFactor = (m['easeFactor'] ?? 2.5).toDouble(),
        repetitions = m['repetitions'] ?? 0,
        nextReview = DateTime.parse(m['nextReview'] ?? DateTime.now().toIso8601String());

  Map<String, dynamic> toMap() => {
    'interval': interval,
    'easeFactor': easeFactor,
    'repetitions': repetitions,
    'nextReview': nextReview.toIso8601String(),
  };

  // quality: 0=Hard, 1=Good, 2=Easy
  void review(int quality) {
    if (quality == 0) {
      repetitions = 0;
      interval = 1;
    } else {
      repetitions++;
      if (repetitions == 1) {
        interval = 1;
      } else if (repetitions == 2) {
        interval = 6;
      } else {
        interval = (interval * easeFactor).round();
      }
    }
    easeFactor = (easeFactor + 0.1 - (2 - quality) * (0.08 + (2 - quality) * 0.02)).clamp(1.3, 3.0);
    nextReview = DateTime.now().add(Duration(days: interval));
  }

  bool get isDue => DateTime.now().isAfter(nextReview);
}

// ─── Flashcard data ───────────────────────────────────────────────────────────

const _cards = [
  // Python
  _Flashcard(id: 'py_001', category: 'Python', front: 'What is a list comprehension in Python?',
    back: 'A concise way to create lists. Syntax:\n[expression for item in iterable if condition]',
    codeExample: '[x**2 for x in range(10) if x % 2 == 0]\n# → [0, 4, 16, 36, 64]'),
  _Flashcard(id: 'py_002', category: 'Python', front: 'What is a decorator in Python?',
    back: 'A function that wraps another function to extend its behaviour without modifying it. Uses the @syntax.',
    codeExample: '@timer\ndef slow_function():\n    time.sleep(1)'),
  _Flashcard(id: 'py_003', category: 'Python', front: 'What is the difference between `is` and `==` in Python?',
    back: '`==` checks value equality.\n`is` checks identity — whether both variables point to the same object in memory.'),
  _Flashcard(id: 'py_004', category: 'Python', front: 'What is a generator in Python?',
    back: 'A function using `yield` that returns an iterator. Values are produced lazily (one at a time) — saves memory.',
    codeExample: 'def squares(n):\n    for i in range(n):\n        yield i**2'),
  _Flashcard(id: 'py_005', category: 'Python', front: 'What does `*args` and `**kwargs` do?',
    back: '`*args` collects extra positional arguments into a tuple.\n`**kwargs` collects extra keyword arguments into a dict.'),

  // JavaScript
  _Flashcard(id: 'js_001', category: 'JavaScript', front: 'What is event bubbling in JavaScript?',
    back: 'When an event fires on a child element, it propagates up through its parent elements. Use event.stopPropagation() to stop it.'),
  _Flashcard(id: 'js_002', category: 'JavaScript', front: 'What is a closure?',
    back: 'A closure is a function that retains access to its outer scope even after the outer function has returned.',
    codeExample: 'function counter() {\n  let count = 0;\n  return () => ++count;\n}'),
  _Flashcard(id: 'js_003', category: 'JavaScript', front: 'What is the difference between `let`, `const`, and `var`?',
    back: '`var`: function-scoped, hoisted.\n`let`: block-scoped, not hoisted.\n`const`: block-scoped, can\'t be reassigned (but object contents can change).'),
  _Flashcard(id: 'js_004', category: 'JavaScript', front: 'What is Promise.all()?',
    back: 'Runs multiple promises in parallel and resolves when ALL resolve, or rejects as soon as ONE rejects.',
    codeExample: 'const [a, b] = await Promise.all([fetchA(), fetchB()]);'),
  _Flashcard(id: 'js_005', category: 'JavaScript', front: 'What is the prototype chain?',
    back: 'When you access a property on an object, JavaScript looks up the prototype chain until it finds it or reaches null. Basis of JS inheritance.'),

  // Data Structures
  _Flashcard(id: 'ds_001', category: 'Data Structures', front: 'What is the time complexity of HashMap lookup?',
    back: 'Average: O(1)\nWorst case (all keys hash to same bucket): O(n)\nIn practice, good hash functions ensure O(1).'),
  _Flashcard(id: 'ds_002', category: 'Data Structures', front: 'What is the difference between a stack and a queue?',
    back: 'Stack: LIFO (Last In First Out) — push/pop from the same end.\nQueue: FIFO (First In First Out) — enqueue at back, dequeue from front.'),
  _Flashcard(id: 'ds_003', category: 'Data Structures', front: 'What is a balanced binary search tree?',
    back: 'A BST where the height difference between left and right subtrees is ≤ 1 for every node. Guarantees O(log n) operations. Examples: AVL tree, Red-Black tree.'),
  _Flashcard(id: 'ds_004', category: 'Data Structures', front: 'What is a heap data structure?',
    back: 'A complete binary tree satisfying the heap property:\nMax-heap: parent ≥ children\nMin-heap: parent ≤ children\nInsert/delete: O(log n). Peek: O(1).'),
  _Flashcard(id: 'ds_005', category: 'Data Structures', front: 'When would you use a linked list over an array?',
    back: 'Linked list when:\n• Frequent insertions/deletions at known positions\n• Size changes dynamically\n\nArray when:\n• Random access needed\n• Better cache performance required'),

  // Algorithms
  _Flashcard(id: 'al_001', category: 'Algorithms', front: 'What is Big O notation?',
    back: 'Describes the upper bound of algorithm time/space complexity as input size grows. Ignores constants and lower-order terms.\nO(1) < O(log n) < O(n) < O(n log n) < O(n²) < O(2ⁿ)'),
  _Flashcard(id: 'al_002', category: 'Algorithms', front: 'What makes an algorithm "stable" when sorting?',
    back: 'A stable sort preserves the relative order of elements with equal keys. Merge sort and insertion sort are stable. Quick sort is NOT stable by default.'),
  _Flashcard(id: 'al_003', category: 'Algorithms', front: 'What is memoization?',
    back: 'An optimisation technique that caches the results of expensive function calls and returns the cached result when the same inputs occur again. Top-down dynamic programming.',
    codeExample: 'memo = {}\ndef fib(n):\n    if n in memo: return memo[n]\n    memo[n] = fib(n-1) + fib(n-2)\n    return memo[n]'),
  _Flashcard(id: 'al_004', category: 'Algorithms', front: 'What is the difference between DFS and BFS?',
    back: 'DFS: goes deep first (stack/recursion), O(V+E) space, good for cycle detection, topological sort.\nBFS: goes wide first (queue), finds shortest path in unweighted graphs, O(V) space.'),
  _Flashcard(id: 'al_005', category: 'Algorithms', front: 'What is divide and conquer?',
    back: 'Strategy: split problem into smaller subproblems, solve recursively, combine solutions.\nExamples: merge sort, quicksort, binary search.\nUsually leads to O(n log n) complexity.'),

  // OOP
  _Flashcard(id: 'oop_001', category: 'OOP', front: 'What is polymorphism?',
    back: 'Same interface, different behaviour. Two types:\n1. Compile-time (method overloading)\n2. Runtime (method overriding via inheritance)\nAllows writing code that works with the base type but executes subclass behaviour.'),
  _Flashcard(id: 'oop_002', category: 'OOP', front: 'What is the Liskov Substitution Principle?',
    back: 'Subtypes must be substitutable for their base type without breaking the program. If class B extends A, anywhere A is used, B should work correctly.'),
  _Flashcard(id: 'oop_003', category: 'OOP', front: 'What is composition over inheritance?',
    back: 'Prefer building complex objects by combining simpler ones (HAS-A) rather than extending (IS-A). More flexible, avoids deep inheritance hierarchies and the fragile base class problem.'),
  _Flashcard(id: 'oop_004', category: 'OOP', front: 'What is the Singleton pattern?',
    back: 'Ensures a class has only one instance and provides a global access point to it. Useful for: config managers, logging, connection pools. Often considered an anti-pattern if overused.'),
  _Flashcard(id: 'oop_005', category: 'OOP', front: 'What is dependency injection?',
    back: 'Passing dependencies into a class rather than creating them inside. Decouples construction from use, makes code testable. Used by Flutter\'s Riverpod, Angular DI, Spring.'),

  // System Design
  _Flashcard(id: 'sd_001', category: 'System Design', front: 'What is a load balancer?',
    back: 'Distributes incoming requests across multiple servers to prevent any single server from being overwhelmed. Types: round-robin, least connections, IP hash. Improves availability and throughput.'),
  _Flashcard(id: 'sd_002', category: 'System Design', front: 'What is database sharding?',
    back: 'Splitting a database horizontally into smaller pieces (shards), each holding a subset of data. Each shard runs on a separate server. Enables horizontal scaling but adds complexity.'),
  _Flashcard(id: 'sd_003', category: 'System Design', front: 'What is a CDN?',
    back: 'Content Delivery Network: a distributed network of servers that caches static assets (images, JS, CSS) geographically close to users, reducing latency. Examples: Cloudflare, AWS CloudFront.'),
  _Flashcard(id: 'sd_004', category: 'System Design', front: 'What is eventual consistency?',
    back: 'In distributed systems, all replicas will eventually converge to the same value, but may temporarily be inconsistent. Used in AP systems (availability + partition tolerance). Example: DNS, social media feeds.'),
  _Flashcard(id: 'sd_005', category: 'System Design', front: 'What is a message queue and why use it?',
    back: 'Asynchronous communication between services. Producer puts messages in queue; consumer reads at its own pace. Benefits: decoupling, load levelling, fault tolerance. Examples: Kafka, RabbitMQ, SQS.'),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class FlashcardScreen extends StatefulWidget {
  const FlashcardScreen({super.key});

  @override
  State<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen>
    with SingleTickerProviderStateMixin {
  late Box _box;
  bool _boxReady = false;
  String _selectedCategory = 'All';
  bool _showDueOnly = false;

  List<_Flashcard> _deck = [];
  int _deckIndex = 0;
  bool _flipped = false;
  late AnimationController _flipCtrl;
  late Animation<double> _flipAnim;

  Map<String, _CardState> _states = {};
  int _reviewedToday = 0;

  static const _categories = ['All', 'Python', 'JavaScript', 'Data Structures', 'Algorithms', 'OOP', 'System Design'];

  @override
  void initState() {
    super.initState();
    _flipCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _flipAnim = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _flipCtrl, curve: Curves.easeInOut));
    _loadStates();
  }

  Future<void> _loadStates() async {
    _box = await Hive.openBox('flashcard_states');
    for (final card in _cards) {
      final raw = _box.get(card.id);
      _states[card.id] = raw != null ? _CardState.fromMap(Map<String, dynamic>.from(raw)) : _CardState();
    }
    _buildDeck();
    setState(() => _boxReady = true);
  }

  void _buildDeck() {
    var filtered = _cards.where((c) {
      final catOk = _selectedCategory == 'All' || c.category == _selectedCategory;
      final dueOk = !_showDueOnly || _states[c.id]!.isDue;
      return catOk && dueOk;
    }).toList()..shuffle();

    _deck = filtered;
    _deckIndex = 0;
    _flipped = false;
    _flipCtrl.reset();
  }

  Future<void> _rate(int quality) async {
    final card = _deck[_deckIndex];
    _states[card.id]!.review(quality);
    await _box.put(card.id, _states[card.id]!.toMap());
    _reviewedToday++;

    setState(() {
      _flipped = false;
      _flipCtrl.reset();
      if (_deckIndex < _deck.length - 1) {
        _deckIndex++;
      } else {
        _buildDeck();
      }
    });
  }

  void _flip() {
    setState(() => _flipped = !_flipped);
    if (_flipped) _flipCtrl.forward(); else _flipCtrl.reverse();
  }

  int get _dueCount => _states.values.where((s) => s.isDue).length;

  @override
  void dispose() {
    _flipCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_boxReady) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: AppColors.neonCyan)));
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('FLASHCARDS'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.neonOrange.withOpacity(0.12),
                ),
                child: Text('$_dueCount due',
                    style: const TextStyle(fontFamily: 'Share Tech Mono', fontSize: 11, color: AppColors.neonOrange)),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Category filter
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: _categories.map((c) {
                final sel = c == _selectedCategory;
                return GestureDetector(
                  onTap: () { setState(() => _selectedCategory = c); _buildDeck(); },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: sel ? AppColors.neonCyan.withOpacity(0.12) : context.cqCard,
                      border: Border.all(color: sel ? AppColors.neonCyan : context.cqSurface, width: sel ? 1.5 : 1),
                    ),
                    child: Center(child: Text(c, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, fontWeight: FontWeight.w600, color: sel ? AppColors.neonCyan : context.cqTextMuted))),
                  ),
                );
              }).toList(),
            ),
          ),

          // Stats row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              children: [
                _StatPill(label: 'Deck', value: '${_deck.length}', color: AppColors.neonCyan),
                const SizedBox(width: 8),
                _StatPill(label: 'Today', value: '$_reviewedToday', color: AppColors.neonGreen),
                SizedBox(width: 8),
                _StatPill(label: 'Total', value: '${_cards.length}', color: context.cqTextMuted),
                const Spacer(),
                Row(
                  children: [
                    Text('Due only', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: context.cqTextMuted)),
                    const SizedBox(width: 6),
                    Switch(
                      value: _showDueOnly,
                      onChanged: (v) { setState(() => _showDueOnly = v); _buildDeck(); },
                      activeColor: AppColors.neonOrange,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Card
          Expanded(
            child: _deck.isEmpty
                ? _buildEmptyState()
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: _flip,
                      child: AnimatedBuilder(
                        animation: _flipAnim,
                        builder: (_, __) {
                          final angle = _flipAnim.value * math.pi;
                          final showBack = angle > math.pi / 2;
                          return Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..setEntry(3, 2, 0.001)
                              ..rotateY(angle),
                            child: showBack
                                ? Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()..rotateY(math.pi),
                                    child: _buildCardBack(_deck[_deckIndex]),
                                  )
                                : _buildCardFront(_deck[_deckIndex]),
                          );
                        },
                      ),
                    ),
                  ),
          ),

          // Rating buttons (shown when flipped)
          if (_deck.isNotEmpty && _flipped)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
              child: Row(
                children: [
                  Expanded(child: _RateBtn(label: '😓 Hard', color: AppColors.error, onTap: () => _rate(0))),
                  const SizedBox(width: 10),
                  Expanded(child: _RateBtn(label: '🙂 Good', color: AppColors.neonYellow, onTap: () => _rate(1))),
                  const SizedBox(width: 10),
                  Expanded(child: _RateBtn(label: '😊 Easy', color: AppColors.neonGreen, onTap: () => _rate(2))),
                ],
              ),
            ).animate().slideY(begin: 0.3).fadeIn(),

          if (_deck.isNotEmpty && !_flipped)
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Text(
                'Tap card to reveal answer',
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13, color: context.cqTextMuted),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardFront(_Flashcard card) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF0A1628), Color(0xFF141B2D)]),
        border: Border.all(color: AppColors.neonCyan.withOpacity(0.4), width: 1.5),
        boxShadow: [BoxShadow(color: AppColors.neonCyan.withOpacity(0.1), blurRadius: 20)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: AppColors.neonCyan.withOpacity(0.12)),
              child: Text(card.category, style: const TextStyle(fontFamily: 'Share Tech Mono', fontSize: 11, color: AppColors.neonCyan, letterSpacing: 1)),
            ),
            const SizedBox(height: 24),
            Text(
              card.front,
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Rajdhani', fontSize: 20, fontWeight: FontWeight.bold, color: context.cqTextPrimary, height: 1.5),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.touch_app_outlined, color: context.cqTextMuted, size: 16),
                const SizedBox(width: 6),
                Text('${_deckIndex + 1} / ${_deck.length}',
                    style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 11, color: context.cqTextMuted)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack(_Flashcard card) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF0A1A10), Color(0xFF141B2D)]),
        border: Border.all(color: AppColors.neonGreen.withOpacity(0.4), width: 1.5),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ANSWER', style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 10, color: AppColors.neonGreen, letterSpacing: 2)),
            const SizedBox(height: 14),
            Text(card.back, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 16, color: context.cqTextPrimary, height: 1.7)),
            if (card.codeExample != null) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFF0D1117),
                  border: Border.all(color: const Color(0xFF30363D)),
                ),
                child: Text(card.codeExample!, style: const TextStyle(fontFamily: 'Courier New', fontSize: 13, color: Color(0xFFE6EDF3), height: 1.6)),
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: Text('How well did you know this?',
                  style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13, color: context.cqTextMuted)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text('All caught up!', style: TextStyle(fontFamily: 'Orbitron', fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.neonGreen)),
          const SizedBox(height: 8),
          Text('No cards due for review right now.', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 15, color: context.cqTextMuted)),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () { setState(() => _showDueOnly = false); _buildDeck(); },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.neonCyan)),
              child: const Text('Review all cards', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.neonCyan)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String label; final String value; final Color color;
  const _StatPill({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: color.withOpacity(0.08), border: Border.all(color: color.withOpacity(0.2))),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: TextStyle(fontFamily: 'Orbitron', fontSize: 13, fontWeight: FontWeight.bold, color: color)),
      const SizedBox(width: 4),
      Text(label, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11, color: context.cqTextMuted)),
    ]),
  );
}

class _RateBtn extends StatelessWidget {
  final String label; final Color color; final VoidCallback onTap;
  const _RateBtn({required this.label, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Center(child: Text(label, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, fontWeight: FontWeight.bold, color: color))),
    ),
  );
}
