import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class _RoadmapPath {
  final String title;
  final String emoji;
  final String description;
  final Color color;
  final List<_RoadmapStep> steps;

  const _RoadmapPath({
    required this.title,
    required this.emoji,
    required this.description,
    required this.color,
    required this.steps,
  });
}

class _RoadmapStep {
  final String title;
  final String description;
  final String icon;
  final List<String> languages;
  final bool isOptional;

  const _RoadmapStep({
    required this.title,
    required this.description,
    required this.icon,
    required this.languages,
    this.isOptional = false,
  });
}

const _paths = [
  _RoadmapPath(
    title: 'Frontend Developer',
    emoji: '🎨',
    description: 'Build beautiful web interfaces',
    color: Color(0xFFF7DF1E),
    steps: [
      _RoadmapStep(title: 'HTML Fundamentals', description: 'Structure of web pages', icon: '📄', languages: ['html']),
      _RoadmapStep(title: 'CSS Styling', description: 'Design and layout', icon: '🎨', languages: ['css']),
      _RoadmapStep(title: 'JavaScript Core', description: 'Interactivity and logic', icon: '⚡', languages: ['javascript']),
      _RoadmapStep(title: 'DOM Manipulation', description: 'Control webpage elements', icon: '🔧', languages: ['javascript']),
      _RoadmapStep(title: 'TypeScript', description: 'Type-safe JavaScript', icon: '🔷', languages: ['typescript'], isOptional: true),
      _RoadmapStep(title: 'React / Vue / Angular', description: 'UI frameworks', icon: '⚛️', languages: ['javascript', 'typescript'], isOptional: true),
    ],
  ),
  _RoadmapPath(
    title: 'Backend Developer',
    emoji: '⚙️',
    description: 'Build APIs and server logic',
    color: Color(0xFF3572A5),
    steps: [
      _RoadmapStep(title: 'Programming Fundamentals', description: 'Variables, loops, functions', icon: '🏗️', languages: ['python', 'javascript']),
      _RoadmapStep(title: 'Data Structures', description: 'Arrays, lists, maps', icon: '📚', languages: ['python', 'java']),
      _RoadmapStep(title: 'Algorithms', description: 'Sorting, searching, recursion', icon: '🧩', languages: ['python', 'cpp']),
      _RoadmapStep(title: 'SQL & Databases', description: 'Storing and querying data', icon: '🗄️', languages: ['sql']),
      _RoadmapStep(title: 'APIs & REST', description: 'HTTP and server communication', icon: '🌐', languages: ['python', 'javascript']),
      _RoadmapStep(title: 'System Design', description: 'Architecture patterns', icon: '🏛️', languages: ['java', 'python'], isOptional: true),
    ],
  ),
  _RoadmapPath(
    title: 'Mobile Developer',
    emoji: '📱',
    description: 'Build iOS & Android apps',
    color: Color(0xFF00B4AB),
    steps: [
      _RoadmapStep(title: 'Dart Basics', description: 'Flutter\'s language', icon: '🎯', languages: ['dart']),
      _RoadmapStep(title: 'Flutter Widgets', description: 'UI building blocks', icon: '🧩', languages: ['dart']),
      _RoadmapStep(title: 'State Management', description: 'Riverpod, Provider, BLoC', icon: '⚡', languages: ['dart']),
      _RoadmapStep(title: 'Networking & APIs', description: 'HTTP, REST in Flutter', icon: '🌐', languages: ['dart']),
      _RoadmapStep(title: 'Local Storage', description: 'Hive, SQLite, SharedPrefs', icon: '💾', languages: ['dart']),
      _RoadmapStep(title: 'App Publishing', description: 'Deploy to Play Store / App Store', icon: '🚀', languages: ['dart'], isOptional: true),
    ],
  ),
  _RoadmapPath(
    title: 'Data Science & AI',
    emoji: '🤖',
    description: 'Analyse data and build AI models',
    color: Color(0xFF9C27B0),
    steps: [
      _RoadmapStep(title: 'Python Fundamentals', description: 'Core Python skills', icon: '🐍', languages: ['python']),
      _RoadmapStep(title: 'Statistics & Math', description: 'Probability, linear algebra', icon: '📊', languages: ['python']),
      _RoadmapStep(title: 'Data Analysis', description: 'Pandas, NumPy', icon: '📈', languages: ['python']),
      _RoadmapStep(title: 'SQL for Data', description: 'Query and aggregate data', icon: '🗄️', languages: ['sql']),
      _RoadmapStep(title: 'Machine Learning', description: 'scikit-learn, models', icon: '🧠', languages: ['python']),
      _RoadmapStep(title: 'Deep Learning', description: 'TensorFlow, PyTorch', icon: '🤖', languages: ['python'], isOptional: true),
    ],
  ),
  _RoadmapPath(
    title: 'Systems Programmer',
    emoji: '⚙️',
    description: 'Low-level systems and performance',
    color: Color(0xFFF34B7D),
    steps: [
      _RoadmapStep(title: 'C Fundamentals', description: 'Pointers, memory, I/O', icon: '🔧', languages: ['c']),
      _RoadmapStep(title: 'C++ Core', description: 'OOP and STL', icon: '⚙️', languages: ['cpp']),
      _RoadmapStep(title: 'Memory Management', description: 'Heap, stack, smart pointers', icon: '💾', languages: ['cpp', 'c']),
      _RoadmapStep(title: 'Data Structures in C++', description: 'Linked lists, trees, graphs', icon: '🌳', languages: ['cpp']),
      _RoadmapStep(title: 'Algorithms & Complexity', description: 'Big-O, optimisation', icon: '⚡', languages: ['cpp']),
      _RoadmapStep(title: 'Concurrency', description: 'Threads, mutex, async', icon: '🔄', languages: ['cpp'], isOptional: true),
    ],
  ),
];

class RoadmapScreen extends StatefulWidget {
  const RoadmapScreen({super.key});

  @override
  State<RoadmapScreen> createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  int? _expanded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('LEARNING ROADMAPS'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.neonCyan.withOpacity(0.07),
              border: Border.all(color: AppColors.neonCyan.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.map_outlined, color: AppColors.neonCyan, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Choose a career path and follow the step-by-step language roadmap.',
                    style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, color: context.cqTextSecondary),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          ..._paths.asMap().entries.map((e) {
            final i = e.key;
            final path = e.value;
            final isOpen = _expanded == i;

            return GestureDetector(
              onTap: () => setState(() => _expanded = isOpen ? null : i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: context.cqCard,
                  border: Border.all(
                    color: isOpen ? path.color.withOpacity(0.6) : context.cqSurface,
                    width: isOpen ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: path.color.withOpacity(0.12),
                            ),
                            child: Center(child: Text(path.emoji, style: const TextStyle(fontSize: 24))),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(path.title,
                                    style: TextStyle(
                                        fontFamily: 'Orbitron',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: context.cqTextPrimary)),
                                const SizedBox(height: 2),
                                Text(path.description,
                                    style: TextStyle(
                                        fontFamily: 'Rajdhani',
                                        fontSize: 13,
                                        color: context.cqTextMuted)),
                                const SizedBox(height: 4),
                                Text('${path.steps.length} steps',
                                    style: TextStyle(
                                        fontFamily: 'Share Tech Mono',
                                        fontSize: 10,
                                        color: path.color)),
                              ],
                            ),
                          ),
                          AnimatedRotation(
                            turns: isOpen ? 0.5 : 0,
                            duration: Duration(milliseconds: 200),
                            child: Icon(Icons.keyboard_arrow_down,
                                color: isOpen ? path.color : context.cqTextMuted),
                          ),
                        ],
                      ),
                    ),

                    // Steps
                    if (isOpen) _buildSteps(path),
                  ],
                ),
              ),
            ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().slideY(begin: 0.1);
          }),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildSteps(_RoadmapPath path) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: path.steps.asMap().entries.map((e) {
          final i = e.key;
          final step = e.value;
          final isLast = i == path.steps.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline
              Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: path.color.withOpacity(0.15),
                      border: Border.all(color: path.color.withOpacity(0.5)),
                    ),
                    child: Center(child: Text(step.icon, style: const TextStyle(fontSize: 14))),
                  ),
                  if (!isLast)
                    Container(width: 2, height: 40, color: path.color.withOpacity(0.2)),
                ],
              ),
              const SizedBox(width: 12),

              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8, top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(step.title,
                              style: TextStyle(
                                  fontFamily: 'Rajdhani',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: context.cqTextPrimary)),
                          if (step.isOptional) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: context.cqTextMuted.withOpacity(0.1),
                              ),
                              child: Text('optional',
                                  style: TextStyle(
                                      fontFamily: 'Share Tech Mono',
                                      fontSize: 9,
                                      color: context.cqTextMuted)),
                            ),
                          ],
                        ],
                      ),
                      Text(step.description,
                          style: TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 12,
                              color: context.cqTextMuted)),
                      const SizedBox(height: 4),
                      // Language chips
                      Wrap(
                        spacing: 4,
                        children: step.languages.map((lang) => GestureDetector(
                          onTap: () => context.push('/worlds/$lang'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: path.color.withOpacity(0.1),
                              border: Border.all(color: path.color.withOpacity(0.3)),
                            ),
                            child: Text(lang,
                                style: TextStyle(
                                    fontFamily: 'Share Tech Mono',
                                    fontSize: 9,
                                    color: path.color)),
                          ),
                        )).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
