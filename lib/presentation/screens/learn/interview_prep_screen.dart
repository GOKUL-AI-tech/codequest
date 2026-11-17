import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';

// ─── Data ─────────────────────────────────────────────────────────────────────

class _Question {
  final String question;
  final String answer;
  final String category;
  final String difficulty; // Easy / Medium / Hard
  final String tag;

  const _Question({
    required this.question,
    required this.answer,
    required this.category,
    required this.difficulty,
    required this.tag,
  });
}

const _questions = [
  // ── Data Structures ────────────────────────────────────────────────────────
  _Question(
    question: 'What is the time complexity of binary search?',
    answer: 'O(log n). Binary search halves the search space each step, so it takes at most log₂(n) comparisons to find the target in a sorted array.',
    category: 'Data Structures',
    difficulty: 'Easy',
    tag: '🔍',
  ),
  _Question(
    question: 'What is the difference between a stack and a queue?',
    answer: 'A stack is LIFO (Last In, First Out) — the last element added is the first removed. A queue is FIFO (First In, First Out) — the first element added is the first removed.\n\nStack uses push/pop; Queue uses enqueue/dequeue.',
    category: 'Data Structures',
    difficulty: 'Easy',
    tag: '📚',
  ),
  _Question(
    question: 'When would you use a HashSet over a List?',
    answer: 'Use HashSet when:\n• You need O(1) average lookup/insertion/deletion\n• Duplicate values must be prevented\n• Order doesn\'t matter\n\nUse List when order matters or indexed access is needed.',
    category: 'Data Structures',
    difficulty: 'Easy',
    tag: '🗂️',
  ),
  _Question(
    question: 'Explain the difference between a linked list and an array.',
    answer: 'Array: contiguous memory, O(1) indexed access, O(n) insert/delete at middle.\n\nLinked List: non-contiguous nodes with pointers, O(n) access by index, O(1) insert/delete at known position.\n\nUse arrays for random access; linked lists for frequent insertions/deletions.',
    category: 'Data Structures',
    difficulty: 'Medium',
    tag: '🔗',
  ),
  _Question(
    question: 'What is a balanced binary tree and why does it matter?',
    answer: 'A balanced binary tree keeps the height difference between left and right subtrees ≤ 1 at every node (e.g. AVL tree, Red-Black tree).\n\nIt matters because BST operations (search, insert, delete) are O(h) where h = height. A balanced tree guarantees O(log n); an unbalanced tree degrades to O(n) in the worst case.',
    category: 'Data Structures',
    difficulty: 'Medium',
    tag: '🌳',
  ),

  // ── Algorithms ─────────────────────────────────────────────────────────────
  _Question(
    question: 'What is the difference between BFS and DFS?',
    answer: 'BFS (Breadth-First Search): explores nodes level by level, uses a Queue. Best for shortest path in unweighted graphs. Time/Space: O(V + E).\n\nDFS (Depth-First Search): explores as deep as possible before backtracking, uses a Stack (or recursion). Best for cycle detection, topological sort. Time: O(V + E), Space: O(h) where h = max depth.',
    category: 'Algorithms',
    difficulty: 'Medium',
    tag: '🗺️',
  ),
  _Question(
    question: 'Explain Dynamic Programming in simple terms.',
    answer: 'DP solves complex problems by breaking them into overlapping subproblems and storing results to avoid recomputation (memoization = top-down, tabulation = bottom-up).\n\nClassic example: Fibonacci. fib(5) = fib(4) + fib(3). Without DP: O(2ⁿ). With DP: O(n).\n\nKey insight: if a problem has "optimal substructure" and "overlapping subproblems", DP applies.',
    category: 'Algorithms',
    difficulty: 'Hard',
    tag: '⚡',
  ),
  _Question(
    question: 'What is the time complexity of quicksort? When is it O(n²)?',
    answer: 'Average: O(n log n). Worst case: O(n²) when the pivot is always the smallest or largest element (e.g. sorted input with first-element pivot).\n\nFix: use random pivot or median-of-three selection. In practice, quicksort is faster than mergesort due to cache locality.',
    category: 'Algorithms',
    difficulty: 'Medium',
    tag: '⚙️',
  ),
  _Question(
    question: 'What is a greedy algorithm? Give an example.',
    answer: 'A greedy algorithm makes the locally optimal choice at each step, hoping to find the global optimum. It doesn\'t backtrack.\n\nExample: Coin change (with standard denominations). To make \$0.41 change: take the largest coin ≤ remaining amount each time → 25¢, 10¢, 5¢, 1¢.\n\nGreedy works when the problem has the greedy-choice property. It fails for coin change with arbitrary denominations.',
    category: 'Algorithms',
    difficulty: 'Medium',
    tag: '🎯',
  ),

  // ── OOP ───────────────────────────────────────────────────────────────────
  _Question(
    question: 'What are the four pillars of OOP?',
    answer: '1. Encapsulation — bundling data + methods, hiding internals via access modifiers\n2. Abstraction — exposing only what\'s necessary (interfaces, abstract classes)\n3. Inheritance — a class inherits properties/methods from a parent class\n4. Polymorphism — same interface, different behavior (method overriding, interfaces)',
    category: 'OOP',
    difficulty: 'Easy',
    tag: '🏛️',
  ),
  _Question(
    question: 'What is the difference between an interface and an abstract class?',
    answer: 'Abstract class:\n• Can have concrete methods and state\n• Single inheritance only (most languages)\n• Use when classes share implementation\n\nInterface:\n• Only method signatures (pure contract)\n• A class can implement multiple interfaces\n• Use when unrelated classes share a capability\n\nRule of thumb: "is-a" → abstract class. "can-do" → interface.',
    category: 'OOP',
    difficulty: 'Medium',
    tag: '🔌',
  ),
  _Question(
    question: 'What is the SOLID principle?',
    answer: 'S — Single Responsibility: one class, one reason to change\nO — Open/Closed: open for extension, closed for modification\nL — Liskov Substitution: subclasses must be substitutable for their base class\nI — Interface Segregation: prefer small specific interfaces over large general ones\nD — Dependency Inversion: depend on abstractions, not concretions',
    category: 'OOP',
    difficulty: 'Hard',
    tag: '🧱',
  ),

  // ── System Design ──────────────────────────────────────────────────────────
  _Question(
    question: 'What is the difference between horizontal and vertical scaling?',
    answer: 'Vertical scaling (scale up): add more resources to a single machine (more RAM, faster CPU). Simple but has a hard upper limit.\n\nHorizontal scaling (scale out): add more machines to distribute load. More complex (needs load balancing, distributed state) but theoretically unlimited.\n\nMost modern systems prefer horizontal scaling for availability and fault tolerance.',
    category: 'System Design',
    difficulty: 'Medium',
    tag: '🖥️',
  ),
  _Question(
    question: 'What is a REST API? What makes it RESTful?',
    answer: 'REST (Representational State Transfer) is an architectural style for APIs. A RESTful API:\n• Uses HTTP methods semantically (GET=read, POST=create, PUT=replace, PATCH=update, DELETE=remove)\n• Is stateless — each request contains all info needed\n• Has uniform resource URLs (/users/42 not /getUser?id=42)\n• Returns standard status codes (200, 201, 404, 500)\n• Can return any format (usually JSON)',
    category: 'System Design',
    difficulty: 'Easy',
    tag: '🌐',
  ),
  _Question(
    question: 'Explain the CAP theorem.',
    answer: 'In a distributed system, you can only guarantee 2 of 3:\n\nC — Consistency: all nodes see the same data at the same time\nA — Availability: every request gets a response (not necessarily up-to-date)\nP — Partition tolerance: system works despite network partitions\n\nSince P is unavoidable in real networks, you choose CP (banks: strong consistency) or AP (social feeds: eventual consistency).',
    category: 'System Design',
    difficulty: 'Hard',
    tag: '⚖️',
  ),

  // ── Concurrency ────────────────────────────────────────────────────────────
  _Question(
    question: 'What is a deadlock and how do you prevent it?',
    answer: 'A deadlock occurs when two or more threads each hold a resource and wait for the other\'s resource — circular dependency.\n\nPrevention strategies:\n• Lock ordering: always acquire locks in the same order\n• Lock timeout: give up if a lock can\'t be acquired within a time limit\n• Deadlock detection: detect and recover by killing a thread\n• Avoid nested locks where possible',
    category: 'Concurrency',
    difficulty: 'Hard',
    tag: '🔐',
  ),
  _Question(
    question: 'What is the difference between a process and a thread?',
    answer: 'Process: an independent program with its own memory space. Processes are isolated — a crash in one doesn\'t affect others. IPC needed to communicate.\n\nThread: a lightweight unit within a process, sharing memory. Threads communicate easily but must synchronise access to shared data.\n\nUse threads for parallelism within a task; processes for isolation between tasks.',
    category: 'Concurrency',
    difficulty: 'Medium',
    tag: '⚙️',
  ),

  // ── Databases ─────────────────────────────────────────────────────────────
  _Question(
    question: 'What is database indexing and when should you use it?',
    answer: 'An index is a data structure (usually a B-tree) that speeds up lookups on a column at the cost of slower writes and extra storage.\n\nUse indexes on:\n• Columns used in WHERE, JOIN, ORDER BY clauses\n• Primary and foreign keys (auto-indexed)\n\nAvoid on:\n• Columns with few distinct values (low cardinality)\n• Tables with very frequent writes and rare reads',
    category: 'Databases',
    difficulty: 'Medium',
    tag: '🗄️',
  ),
  _Question(
    question: 'What is the difference between SQL and NoSQL databases?',
    answer: 'SQL (Relational): structured tables, fixed schema, ACID transactions, vertical scaling. Best for: financial data, complex joins.\n\nNoSQL: flexible schema (document, key-value, graph, column-store), horizontal scaling, eventual consistency. Best for: large-scale data, variable structure, high write throughput.\n\nExamples: PostgreSQL (SQL), MongoDB/Supabase (NoSQL-ish/hybrid).',
    category: 'Databases',
    difficulty: 'Easy',
    tag: '💾',
  ),
];

const _categories = [
  'All',
  'Data Structures',
  'Algorithms',
  'OOP',
  'System Design',
  'Concurrency',
  'Databases',
];

const _difficulties = ['All', 'Easy', 'Medium', 'Hard'];

// ─── Screen ───────────────────────────────────────────────────────────────────

class InterviewPrepScreen extends StatefulWidget {
  const InterviewPrepScreen({super.key});

  @override
  State<InterviewPrepScreen> createState() => _InterviewPrepScreenState();
}

class _InterviewPrepScreenState extends State<InterviewPrepScreen> {
  String _category = 'All';
  String _difficulty = 'All';
  int _solved = 0;

  List<_Question> get _filtered => _questions.where((q) {
        final catOk = _category == 'All' || q.category == _category;
        final difOk = _difficulty == 'All' || q.difficulty == _difficulty;
        return catOk && difOk;
      }).toList();

  Color _diffColor(String d) {
    switch (d) {
      case 'Easy': return AppColors.neonGreen;
      case 'Medium': return AppColors.neonYellow;
      case 'Hard': return AppColors.neonPink;
      default: return context.cqTextMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _filtered;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('INTERVIEW PREP'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '$_solved solved',
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
      body: Column(
        children: [
          // Stats banner
          _buildStatsBanner(list),

          // Filters
          _buildFilters(),

          // Question list
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Text('No questions match filters.',
                        style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 15,
                            color: context.cqTextMuted)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: list.length,
                    itemBuilder: (context, i) => _QuestionCard(
                      question: list[i],
                      index: i,
                      diffColor: _diffColor(list[i].difficulty),
                      onSolved: () => setState(() => _solved++),
                    ).animate(delay: Duration(milliseconds: i * 40)).fadeIn().slideY(begin: 0.05),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBanner(List<_Question> list) {
    final easy = list.where((q) => q.difficulty == 'Easy').length;
    final medium = list.where((q) => q.difficulty == 'Medium').length;
    final hard = list.where((q) => q.difficulty == 'Hard').length;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: context.cqBgSecondary,
      child: Row(
        children: [
          _MiniStat(label: 'Easy', count: easy, color: AppColors.neonGreen),
          const SizedBox(width: 12),
          _MiniStat(label: 'Medium', count: medium, color: AppColors.neonYellow),
          const SizedBox(width: 12),
          _MiniStat(label: 'Hard', count: hard, color: AppColors.neonPink),
          const Spacer(),
          Text(
            '${list.length} questions',
            style: TextStyle(
              fontFamily: 'Share Tech Mono',
              fontSize: 11,
              color: context.cqTextMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Column(
      children: [
        // Category chips
        SizedBox(
          height: 44,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: _categories.map((c) {
              final sel = c == _category;
              return GestureDetector(
                onTap: () => setState(() => _category = c),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 8),
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: sel ? AppColors.neonCyan.withOpacity(0.15) : context.cqCard,
                    border: Border.all(
                      color: sel ? AppColors.neonCyan : context.cqSurface,
                      width: sel ? 1.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: Text(c,
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: sel ? AppColors.neonCyan : context.cqTextMuted,
                        )),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Difficulty row
        SizedBox(
          height: 38,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            children: _difficulties.map((d) {
              final sel = d == _difficulty;
              final color = d == 'All' ? context.cqTextMuted : _diffColor(d);
              return GestureDetector(
                onTap: () => setState(() => _difficulty = d),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: sel ? color.withOpacity(0.12) : Colors.transparent,
                    border: Border.all(
                      color: sel ? color : context.cqSurface,
                    ),
                  ),
                  child: Center(
                    child: Text(d,
                        style: TextStyle(
                          fontFamily: 'Share Tech Mono',
                          fontSize: 11,
                          color: sel ? color : context.cqTextMuted,
                        )),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  const _MiniStat({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 8, height: 8,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text('$count $label',
            style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: color)),
      ],
    );
  }
}

// ─── Question card ────────────────────────────────────────────────────────────

class _QuestionCard extends StatefulWidget {
  final _Question question;
  final int index;
  final Color diffColor;
  final VoidCallback onSolved;

  const _QuestionCard({
    required this.question,
    required this.index,
    required this.diffColor,
    required this.onSolved,
  });

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  bool _expanded = false;
  bool _solved = false;

  @override
  Widget build(BuildContext context) {
    final q = widget.question;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: context.cqCard,
        border: Border.all(
          color: _solved
              ? AppColors.neonGreen.withOpacity(0.4)
              : widget.diffColor.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          // Question header
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Text(q.tag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q.question,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _solved ? AppColors.neonGreen : context.cqTextPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: widget.diffColor.withOpacity(0.1),
                              ),
                              child: Text(q.difficulty,
                                  style: TextStyle(
                                      fontFamily: 'Share Tech Mono',
                                      fontSize: 9,
                                      color: widget.diffColor)),
                            ),
                            const SizedBox(width: 6),
                            Text(q.category,
                                style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 11,
                                    color: context.cqTextMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_solved)
                    const Icon(Icons.check_circle, color: AppColors.neonGreen, size: 20)
                  else
                    AnimatedRotation(
                      turns: _expanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(Icons.keyboard_arrow_down,
                          color: context.cqTextMuted, size: 20),
                    ),
                ],
              ),
            ),
          ),

          // Answer
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Color(0xFF2A3550), height: 1),
                  const SizedBox(height: 12),
                  Text(
                    q.answer,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      color: context.cqTextSecondary,
                      height: 1.7,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (!_solved)
                    GestureDetector(
                      onTap: () {
                        setState(() => _solved = true);
                        widget.onSolved();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColors.neonGreen.withOpacity(0.1),
                          border: Border.all(
                              color: AppColors.neonGreen.withOpacity(0.4)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check, color: AppColors.neonGreen, size: 16),
                            SizedBox(width: 6),
                            Text('Mark as solved',
                                style: TextStyle(
                                    fontFamily: 'Rajdhani',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.neonGreen)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}
