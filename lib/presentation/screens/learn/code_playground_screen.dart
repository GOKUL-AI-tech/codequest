import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/code_execution_service.dart';
import '../../../core/theme/app_theme.dart';

// ─── Starter templates ────────────────────────────────────────────────────────

const _templates = <String, String>{
  'python': '''# Python Playground
def greet(name):
    return f"Hello, {name}!"

print(greet("CodeQuest"))

# Try printing numbers
for i in range(1, 6):
    print(f"Number: {i}")
''',
  'javascript': r'''// JavaScript Playground
function greet(name) {
  return `Hello, ${name}!`;
}

console.log(greet("CodeQuest"));

// Array operations
const nums = [1, 2, 3, 4, 5];
const doubled = nums.map(n => n * 2);
console.log(doubled);
''',
  'java': '''// Java Playground
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, CodeQuest!");

        for (int i = 1; i <= 5; i++) {
            System.out.println("Count: " + i);
        }
    }
}
''',
  'cpp': '''// C++ Playground
#include <iostream>
using namespace std;

int main() {
    cout << "Hello, CodeQuest!" << endl;

    for (int i = 1; i <= 5; i++) {
        cout << "Number: " << i << endl;
    }
    return 0;
}
''',
  'c': '''// C Playground
#include <stdio.h>

int main() {
    printf("Hello, CodeQuest!\\n");

    for (int i = 1; i <= 5; i++) {
        printf("Number: %d\\n", i);
    }
    return 0;
}
''',
  'dart': '''// Dart Playground
void main() {
  print("Hello, CodeQuest!");

  final nums = [1, 2, 3, 4, 5];
  for (final n in nums) {
    print("Number: \$n");
  }
}
''',
  'typescript': '''// TypeScript Playground
function greet(name: string): string {
  return `Hello, \${name}!`;
}

console.log(greet("CodeQuest"));

const nums: number[] = [1, 2, 3, 4, 5];
nums.forEach(n => console.log(`Number: \${n}`));
''',
};

// ─── Screen ───────────────────────────────────────────────────────────────────

class CodePlaygroundScreen extends StatefulWidget {
  final String? initialLanguageId;
  final String? initialCode;

  const CodePlaygroundScreen({
    super.key,
    this.initialLanguageId,
    this.initialCode,
  });

  @override
  State<CodePlaygroundScreen> createState() => _CodePlaygroundScreenState();
}

class _CodePlaygroundScreenState extends State<CodePlaygroundScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _codeCtrl;
  late TextEditingController _stdinCtrl;
  late TabController _tabCtrl;

  String _selectedLang = 'python';
  ExecutionResult? _result;
  bool _running = false;
  bool _showStdin = false;

  static const _supportedLangs = [
    'python', 'javascript', 'java', 'cpp', 'c', 'dart', 'typescript'
  ];

  @override
  void initState() {
    super.initState();
    _selectedLang = widget.initialLanguageId != null &&
            _supportedLangs.contains(widget.initialLanguageId)
        ? widget.initialLanguageId!
        : 'python';
    _codeCtrl = TextEditingController(
        text: widget.initialCode ?? _templates[_selectedLang] ?? '');
    _stdinCtrl = TextEditingController();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _stdinCtrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  void _onLangChanged(String lang) {
    setState(() {
      _selectedLang = lang;
      _codeCtrl.text = _templates[lang] ?? '';
      _result = null;
    });
  }

  Future<void> _run() async {
    if (_running) return;
    FocusScope.of(context).unfocus();
    setState(() {
      _running = true;
      _result = null;
    });

    final result = await CodeExecutionService.instance.execute(
      languageId: _selectedLang,
      code: _codeCtrl.text,
      stdin: _stdinCtrl.text,
    );

    if (mounted) {
      setState(() {
        _running = false;
        _result = result;
      });
      // Auto-switch to output tab
      _tabCtrl.animateTo(1);
    }
  }

  void _copyCode() {
    Clipboard.setData(ClipboardData(text: _codeCtrl.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Code copied!'),
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _clearOutput() => setState(() => _result = null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('CODE PLAYGROUND'),
        actions: [
          // Copy button
          IconButton(
            icon: Icon(Icons.copy_outlined, color: context.cqTextMuted, size: 20),
            onPressed: _copyCode,
            tooltip: 'Copy code',
          ),
          // Stdin toggle
          IconButton(
            icon: Icon(
              Icons.input_outlined,
              color: _showStdin ? AppColors.neonCyan : context.cqTextMuted,
              size: 20,
            ),
            onPressed: () => setState(() => _showStdin = !_showStdin),
            tooltip: 'Toggle stdin input',
          ),
          // Run button
          GestureDetector(
            onTap: _running ? null : _run,
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: _running ? null : AppColors.cyberpunkGradient,
                color: _running ? context.cqCard : null,
              ),
              child: _running
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.neonCyan),
                    )
                  : const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.play_arrow, color: Colors.white, size: 18),
                        SizedBox(width: 4),
                        Text('RUN',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1,
                            )),
                      ],
                    ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppColors.neonCyan,
          unselectedLabelColor: context.cqTextMuted,
          indicatorColor: AppColors.neonCyan,
          labelStyle: const TextStyle(fontFamily: 'Orbitron', fontSize: 11),
          tabs: [
            const Tab(text: 'EDITOR'),
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('OUTPUT'),
                  if (_result != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _result!.success
                            ? AppColors.neonGreen
                            : AppColors.error,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Language selector
          _buildLanguageBar(),

          // Stdin panel (collapsible)
          if (_showStdin) _buildStdinPanel(),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _buildEditor(),
                _buildOutput(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageBar() {
    return Container(
      height: 44,
      color: context.cqBgSecondary,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        children: _supportedLangs.map((id) {
          final isSelected = id == _selectedLang;
          final lang = AppConstants.languages.firstWhere(
            (l) => l['id'] == id,
            orElse: () => {'name': id, 'icon': '💻', 'color': 0xFF4A5568},
          );
          return GestureDetector(
            onTap: () => _onLangChanged(id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected
                    ? Color(lang['color'] as int).withOpacity(0.2)
                    : Colors.transparent,
                border: Border.all(
                  color: isSelected
                      ? Color(lang['color'] as int)
                      : context.cqSurface,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(lang['icon'] as String,
                      style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Text(
                    lang['name'] as String,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Color(lang['color'] as int)
                          : context.cqTextMuted,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStdinPanel() {
    return Container(
      color: context.cqCardSecondary,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('STDIN INPUT',
              style: TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 10,
                  color: context.cqTextMuted,
                  letterSpacing: 1.5)),
          const SizedBox(height: 6),
          TextField(
            controller: _stdinCtrl,
            maxLines: 2,
            style: TextStyle(
                fontFamily: 'Courier New',
                fontSize: 13,
                color: context.cqTextPrimary),
            decoration: InputDecoration(
              hintText: 'Enter program input (one value per line)...',
              hintStyle: TextStyle(
                  color: context.cqTextMuted, fontFamily: 'Rajdhani'),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              isDense: true,
              filled: true,
              fillColor: context.cqCard,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2A3550))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF2A3550))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: AppColors.neonCyan, width: 1.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditor() {
    return Container(
      color: const Color(0xFF0D1117),
      child: Column(
        children: [
          // Line numbers + code area
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Line numbers
                Container(
                  width: 40,
                  color: const Color(0xFF0D1117),
                  padding: const EdgeInsets.fromLTRB(0, 12, 8, 12),
                  child: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _codeCtrl,
                    builder: (_, value, __) {
                      final lines = value.text.split('\n').length;
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: lines,
                        itemBuilder: (_, i) => SizedBox(
                          height: 21,
                          child: Text(
                            '${i + 1}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              fontFamily: 'Courier New',
                              fontSize: 13,
                              color: Color(0xFF6E7681),
                              height: 1.6,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Divider
                Container(width: 1, color: const Color(0xFF21262D)),
                // Code input
                Expanded(
                  child: TextField(
                    controller: _codeCtrl,
                    maxLines: null,
                    expands: true,
                    keyboardType: TextInputType.multiline,
                    autocorrect: false,
                    enableSuggestions: false,
                    style: const TextStyle(
                      fontFamily: 'Courier New',
                      fontSize: 13,
                      color: Color(0xFFE6EDF3),
                      height: 1.6,
                    ),
                    decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutput() {
    if (_running) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.neonCyan),
            const SizedBox(height: 16),
            Text('Executing code...',
                style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 13,
                    color: context.cqTextMuted)),
          ],
        ).animate().fadeIn(),
      );
    }

    if (_result == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('▶', style: TextStyle(fontSize: 48, color: context.cqSurface)),
            const SizedBox(height: 12),
            Text('Press RUN to execute your code',
                style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 15,
                    color: context.cqTextMuted)),
            const SizedBox(height: 4),
            Text('Powered by Piston API',
                style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 11,
                    color: context.cqTextMuted)),
          ],
        ),
      );
    }

    final r = _result!;
    return Container(
      color: const Color(0xFF0D1117),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFF161B22),
            child: Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: r.success ? AppColors.neonGreen : AppColors.error,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  r.success ? 'Executed successfully' : 'Runtime error',
                  style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 12,
                    color: r.success ? AppColors.neonGreen : AppColors.error,
                  ),
                ),
                const Spacer(),
                Text(
                  'exit code ${r.exitCode}',
                  style: TextStyle(
                      fontFamily: 'Share Tech Mono',
                      fontSize: 11,
                      color: context.cqTextMuted),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _clearOutput,
                  child: Icon(Icons.close,
                      color: context.cqTextMuted, size: 16),
                ),
              ],
            ),
          ),

          // Output text
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (r.stdout.isNotEmpty) ...[
                    const Text('STDOUT',
                        style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 10,
                            color: AppColors.neonGreen,
                            letterSpacing: 1.5)),
                    const SizedBox(height: 6),
                    SelectableText(
                      r.stdout,
                      style: const TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 13,
                        color: Color(0xFFE6EDF3),
                        height: 1.6,
                      ),
                    ),
                  ],
                  if (r.stderr.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    const Text('STDERR',
                        style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 10,
                            color: AppColors.error,
                            letterSpacing: 1.5)),
                    const SizedBox(height: 6),
                    SelectableText(
                      r.stderr,
                      style: const TextStyle(
                        fontFamily: 'Courier New',
                        fontSize: 13,
                        color: Color(0xFFFF7B72),
                        height: 1.6,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Copy output button
          if (r.output.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: const Color(0xFF161B22),
              child: GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: r.output));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Output copied!'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.copy_outlined,
                        color: context.cqTextMuted, size: 14),
                    SizedBox(width: 6),
                    Text('Copy output',
                        style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 13,
                            color: context.cqTextMuted)),
                  ],
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn();
  }
}
