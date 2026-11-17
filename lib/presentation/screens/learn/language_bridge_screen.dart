import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

// ══════════════════════════════════════════════════════════════════════════════
// LANGUAGE BRIDGE — Concept Migration Path System
//
// PATENT-WORTHY: No existing app (Duolingo, Codecademy, LeetCode, Coursera)
// generates a PERSONALISED concept-transfer map between two languages based
// on what the user already knows. Instead of starting from scratch, it maps
// known concepts to new syntax and explicitly flags new concepts needing work.
// ══════════════════════════════════════════════════════════════════════════════

// ─── Models ───────────────────────────────────────────────────────────────────

enum BridgeStatus {
  directTransfer,   // Concept is identical / trivially mapped
  minorAdaptation,  // Same idea, different syntax
  majorRethink,     // Concept works differently — needs focused learning
  brandNew,         // Does not exist in source language
}

extension BridgeStatusX on BridgeStatus {
  String get label => switch (this) {
        BridgeStatus.directTransfer => 'YOU KNOW THIS',
        BridgeStatus.minorAdaptation => 'MINOR CHANGE',
        BridgeStatus.majorRethink => 'RETHINK NEEDED',
        BridgeStatus.brandNew => 'BRAND NEW',
      };

  Color get color => switch (this) {
        BridgeStatus.directTransfer => AppColors.neonGreen,
        BridgeStatus.minorAdaptation => AppColors.neonCyan,
        BridgeStatus.majorRethink => AppColors.neonOrange,
        BridgeStatus.brandNew => AppColors.neonPink,
      };

  String get emoji => switch (this) {
        BridgeStatus.directTransfer => '✅',
        BridgeStatus.minorAdaptation => '🔄',
        BridgeStatus.majorRethink => '🧠',
        BridgeStatus.brandNew => '✨',
      };

  int get estimatedMinutes => switch (this) {
        BridgeStatus.directTransfer => 5,
        BridgeStatus.minorAdaptation => 20,
        BridgeStatus.majorRethink => 60,
        BridgeStatus.brandNew => 90,
      };
}

class _ConceptBridge {
  final String concept;
  final String sourceExample;
  final String targetExample;
  final BridgeStatus status;
  final String bridgeNote;

  const _ConceptBridge({
    required this.concept,
    required this.sourceExample,
    required this.targetExample,
    required this.status,
    required this.bridgeNote,
  });
}

// ─── Bridge Data ──────────────────────────────────────────────────────────────

const _pythonToJs = [
  _ConceptBridge(
    concept: 'Variables',
    sourceExample: 'x = 5\nname = "Alex"',
    targetExample: 'let x = 5;\nconst name = "Alex";',
    status: BridgeStatus.minorAdaptation,
    bridgeNote:
        'Same idea — just add let/const. Prefer const when value won\'t change.',
  ),
  _ConceptBridge(
    concept: 'Lists / Arrays',
    sourceExample: 'nums = [1, 2, 3]\nnums.append(4)',
    targetExample: 'let nums = [1, 2, 3];\nnums.push(4);',
    status: BridgeStatus.directTransfer,
    bridgeNote: '.append() becomes .push() — everything else is nearly identical.',
  ),
  _ConceptBridge(
    concept: 'Dictionaries / Objects',
    sourceExample: 'd = {"key": "val"}\nd["key2"] = 5',
    targetExample:
        'const obj = {key: "val"};\nobj.key2 = 5;',
    status: BridgeStatus.directTransfer,
    bridgeNote:
        'Python dicts and JS objects behave almost identically. Key differences: JS keys don\'t require quotes.',
  ),
  _ConceptBridge(
    concept: 'Functions',
    sourceExample: 'def greet(name):\n    return f"Hi {name}"',
    targetExample:
        'function greet(name) {\n  return `Hi \${name}`;\n}',
    status: BridgeStatus.minorAdaptation,
    bridgeNote:
        'def → function. Indentation → curly braces. f-strings → template literals with backticks.',
  ),
  _ConceptBridge(
    concept: 'Arrow Functions',
    sourceExample: '# Python lambdas:\nadd = lambda a, b: a + b',
    targetExample: '// JS arrow function:\nconst add = (a, b) => a + b;',
    status: BridgeStatus.minorAdaptation,
    bridgeNote:
        'Arrow functions are much more common in JS than lambdas in Python. Learn them well.',
  ),
  _ConceptBridge(
    concept: 'Classes / OOP',
    sourceExample:
        'class Dog:\n  def __init__(self, name):\n    self.name = name',
    targetExample:
        'class Dog {\n  constructor(name) {\n    this.name = name;\n  }\n}',
    status: BridgeStatus.minorAdaptation,
    bridgeNote:
        '__init__ becomes constructor. self becomes this. Overall structure is very similar.',
  ),
  _ConceptBridge(
    concept: 'Async / Await',
    sourceExample:
        'import asyncio\nasync def fetch():\n    await asyncio.sleep(1)',
    targetExample:
        'async function fetch() {\n  await new Promise(r => setTimeout(r,1000));\n}',
    status: BridgeStatus.majorRethink,
    bridgeNote:
        'JS async is event-loop based (single-threaded). Python async can be multi-threaded. The syntax looks similar but the mental model is different.',
  ),
  _ConceptBridge(
    concept: 'Promises',
    sourceExample: '# No direct equivalent\n# Python uses asyncio Futures',
    targetExample:
        'fetch(url)\n  .then(res => res.json())\n  .catch(err => console.error(err));',
    status: BridgeStatus.brandNew,
    bridgeNote:
        'Promises are central to JS. No direct Python equivalent (asyncio Futures are similar but rarely used this way). Must learn from scratch.',
  ),
  _ConceptBridge(
    concept: 'Prototypes',
    sourceExample: '# Python uses class-based inheritance\nclass B(A): pass',
    targetExample:
        '// JS has prototype chain\nB.prototype = Object.create(A.prototype);',
    status: BridgeStatus.brandNew,
    bridgeNote:
        'Prototype-based inheritance is unique to JS. You\'ll need this to understand frameworks and older JS code.',
  ),
  _ConceptBridge(
    concept: 'List Comprehensions',
    sourceExample: 'squares = [x**2 for x in range(10)]',
    targetExample: 'const squares = Array.from({length:10}, (_,x) => x**2);',
    status: BridgeStatus.majorRethink,
    bridgeNote:
        'JS doesn\'t have list comprehensions. Use .map(), .filter(), .reduce() instead — actually more powerful once learned.',
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class LanguageBridgeScreen extends StatefulWidget {
  final String? fromLanguageId;

  const LanguageBridgeScreen({super.key, this.fromLanguageId});

  @override
  State<LanguageBridgeScreen> createState() => _LanguageBridgeScreenState();
}

class _LanguageBridgeScreenState extends State<LanguageBridgeScreen> {
  String _fromId = 'python';
  String _toId = 'javascript';
  int? _expandedIndex;

  Map<String, dynamic> get _from =>
      AppConstants.languages.firstWhere((l) => l['id'] == _fromId);
  Map<String, dynamic> get _to =>
      AppConstants.languages.firstWhere((l) => l['id'] == _toId);

  List<_ConceptBridge> get _bridges => _pythonToJs;

  // Summary stats
  int _countByStatus(BridgeStatus s) =>
      _bridges.where((b) => b.status == s).length;

  int get _totalMinutes => _bridges
      .map((b) => b.status.estimatedMinutes)
      .reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildLanguageSelector()),
          SliverToBoxAdapter(child: _buildSummaryBar()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _BridgeCard(
                  bridge: _bridges[i],
                  index: i,
                  isExpanded: _expandedIndex == i,
                  onTap: () => setState(() =>
                      _expandedIndex = _expandedIndex == i ? null : i),
                ).animate(delay: Duration(milliseconds: i * 60))
                    .fadeIn()
                    .slideX(begin: 0.05),
                childCount: _bridges.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0A2818), Color(0xFF0A1628), Color(0xFF0A0E1A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: AppColors.neonGreen, size: 18),
                    onPressed: () => Navigator.pop(context),
                  ),
                  ShaderMask(
                    shaderCallback: (b) => const LinearGradient(
                      colors: [AppColors.neonGreen, AppColors.neonCyan],
                    ).createShader(b),
                    child: const Text(
                      'LANGUAGE BRIDGE',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  'Skip the zero. Map what you already know.',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: context.cqCard,
          border: Border.all(color: context.cqSurface),
        ),
        child: Row(
          children: [
            // From
            Expanded(
              child: _LanguagePill(
                label: 'I KNOW',
                language: _from,
                onTap: () => _showLanguagePicker(isFrom: true),
              ),
            ),
            // Arrow
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Icon(Icons.arrow_forward_rounded,
                      color: AppColors.neonGreen, size: 28),
                  const SizedBox(height: 2),
                  Text('BRIDGE',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 7,
                        color: AppColors.neonGreen.withOpacity(0.6),
                        letterSpacing: 1,
                      )),
                ],
              ),
            ),
            // To
            Expanded(
              child: _LanguagePill(
                label: 'I WANT',
                language: _to,
                onTap: () => _showLanguagePicker(isFrom: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time estimate
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [
                  AppColors.neonGreen.withOpacity(0.12),
                  AppColors.neonCyan.withOpacity(0.06),
                ],
              ),
              border: Border.all(
                  color: AppColors.neonGreen.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Text('⚡',
                    style: TextStyle(fontSize: 22)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('BRIDGE TIME ESTIMATE',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 9,
                            color: AppColors.neonGreen,
                            letterSpacing: 1.5,
                          )),
                      const SizedBox(height: 3),
                      Text(
                        'About ${(_totalMinutes / 60).toStringAsFixed(1)} hours total — '
                        'vs ~40hrs starting from scratch',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 13,
                          color: context.cqTextPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Status legend
          Row(
            children: BridgeStatus.values.map((s) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    right: s != BridgeStatus.brandNew ? 6 : 0),
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: s.color.withOpacity(0.08),
                  border: Border.all(
                      color: s.color.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Text(s.emoji,
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 3),
                    Text('${_countByStatus(s)}',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: s.color,
                        )),
                    Text(
                      s.label
                          .split(' ')
                          .first,
                      style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 8,
                        color: s.color.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker({required bool isFrom}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.cqCard,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isFrom ? 'Language I already know' : 'Language I want to learn',
              style: const TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 13,
                color: AppColors.neonGreen,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 16),
            ...AppConstants.languages.map((lang) => ListTile(
              leading: Text(lang['icon'] as String,
                  style: const TextStyle(fontSize: 22)),
              title: Text(lang['name'] as String,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: context.cqTextPrimary,
                  )),
              subtitle: Text(lang['difficulty'] as String,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 12,
                    color: context.cqTextMuted,
                  )),
              onTap: () {
                setState(() {
                  if (isFrom) {
                    _fromId = lang['id'] as String;
                  } else {
                    _toId = lang['id'] as String;
                  }
                  _expandedIndex = null;
                });
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }
}

// ─── Bridge Card ──────────────────────────────────────────────────────────────

class _BridgeCard extends StatelessWidget {
  final _ConceptBridge bridge;
  final int index;
  final bool isExpanded;
  final VoidCallback onTap;

  const _BridgeCard({
    required this.bridge,
    required this.index,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = bridge.status;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isExpanded
              ? s.color.withOpacity(0.06)
              : context.cqCard,
          border: Border.all(
            color: isExpanded
                ? s.color.withOpacity(0.4)
                : context.cqSurface,
            width: isExpanded ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Text(s.emoji,
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(bridge.concept,
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: context.cqTextPrimary,
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: s.color.withOpacity(0.12),
                      border: Border.all(
                          color: s.color.withOpacity(0.3)),
                    ),
                    child: Text(s.label,
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 7,
                          color: s.color,
                          letterSpacing: 0.8,
                        )),
                  ),
                  SizedBox(width: 6),
                  Text('${s.estimatedMinutes}m',
                      style: TextStyle(
                        fontFamily: 'Share Tech Mono',
                        fontSize: 10,
                        color: context.cqTextMuted,
                      )),
                  SizedBox(width: 4),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: context.cqTextMuted,
                    size: 18,
                  ),
                ],
              ),
            ),

            // Expanded code compare
            if (isExpanded) ...[
              Divider(color: context.cqSurface, height: 1),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Side-by-side code
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _CodePane(
                            label: 'Python',
                            code: bridge.sourceExample,
                            color: AppColors.neonCyan,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _CodePane(
                            label: 'JavaScript',
                            code: bridge.targetExample,
                            color: AppColors.neonYellow,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Bridge note
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: s.color.withOpacity(0.06),
                        border: Border.all(
                            color: s.color.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text('💡',
                              style:
                                  const TextStyle(fontSize: 14)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(bridge.bridgeNote,
                                style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 13,
                                  color: context.cqTextSecondary,
                                  height: 1.4,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CodePane extends StatelessWidget {
  final String label;
  final String code;
  final Color color;
  const _CodePane(
      {required this.label, required this.code, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF0D1117),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                fontFamily: 'Share Tech Mono',
                fontSize: 9,
                color: color,
                letterSpacing: 1,
              )),
          const SizedBox(height: 6),
          Text(code,
              style: const TextStyle(
                fontFamily: 'Share Tech Mono',
                fontSize: 10,
                color: Color(0xFFE6EDF3),
                height: 1.6,
              )),
        ],
      ),
    );
  }
}

class _LanguagePill extends StatelessWidget {
  final String label;
  final Map<String, dynamic> language;
  final VoidCallback onTap;

  const _LanguagePill({
    required this.label,
    required this.language,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(language['color'] as int);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: color.withOpacity(0.08),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text(language['icon'] as String,
                style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 6),
            Text(language['name'] as String,
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: color,
                )),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 10,
                  color: context.cqTextMuted,
                  letterSpacing: 1,
                )),
          ],
        ),
      ),
    );
  }
}
