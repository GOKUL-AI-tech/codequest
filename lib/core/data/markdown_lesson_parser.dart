// ══════════════════════════════════════════════════════════════════════════════
// MARKDOWN → LESSON CONTENT PARSER
// Converts the per-lesson markdown stored in Supabase (lessons.content)
// into the LessonContent/LessonSection model rendered by LessonScreen.
// This makes every lesson show its OWN content instead of a shared local
// fallback, which previously caused different lessons to look identical.
// ══════════════════════════════════════════════════════════════════════════════

import 'lesson_content_db.dart';

class MarkdownLessonParser {
  static const _emojis = <String, String>{
    'python': '🐍',
    'javascript': '⚡',
    'dart': '🎯',
    'java': '☕',
    'cpp': '⚙️',
    'c': '🔧',
  };

  /// Build a [LessonContent] from raw markdown.
  static LessonContent build({
    required String lessonKey,
    required String languageId,
    required String title,
    required String subtitle,
    required int xpReward,
    required int coinReward,
    required int estimatedMinutes,
    required String markdown,
  }) {
    final sections = parseSections(markdown, languageId);
    final summary = sections
        .map((s) => s.text)
        .where((t) => t.isNotEmpty)
        .take(2)
        .join(' ');
    return LessonContent(
      lessonKey: lessonKey,
      languageId: languageId,
      languageEmoji: _emojis[languageId] ?? '💻',
      title: title,
      subtitle: subtitle.isEmpty ? 'Lesson' : subtitle,
      xpReward: xpReward,
      coinReward: coinReward,
      estimatedMinutes: estimatedMinutes,
      voiceSummary: summary.isEmpty ? title : summary,
      sections: sections,
    );
  }

  /// Parse markdown into lesson sections.
  /// Supports: # / ## / ### headings, ```lang fenced code blocks,
  /// - / * bullet lists, and plain paragraphs.
  static List<LessonSection> parseSections(String markdown, String languageId) {
    final lines = markdown.replaceAll('\r\n', '\n').split('\n');
    final sections = <LessonSection>[];

    String currentTitle = 'Introduction';
    final text = StringBuffer();
    final rules = <String>[];
    String? code;
    String? codeLang;
    bool inCode = false;
    final codeBuf = StringBuffer();

    void flush() {
      final body = text.toString().trim();
      if (body.isEmpty && rules.isEmpty && code == null) return;
      sections.add(LessonSection(
        title: currentTitle,
        text: body,
        code: code,
        language: code != null ? (codeLang ?? languageId) : null,
        rules: rules.isEmpty ? null : List<String>.from(rules),
      ));
      text.clear();
      rules.clear();
      code = null;
      codeLang = null;
    }

    for (final raw in lines) {
      if (inCode) {
        if (raw.trim().startsWith('```')) {
          inCode = false;
          code = codeBuf.toString().trimRight();
        } else {
          codeBuf.writeln(raw);
        }
        continue;
      }

      final t = raw.trim();

      if (t.startsWith('```')) {
        // A second code block in the same section starts a new one so
        // no code is lost.
        if (code != null) flush();
        inCode = true;
        codeBuf.clear();
        final lang = t.substring(3).trim();
        codeLang = lang.isEmpty ? languageId : lang;
        continue;
      }

      // H1 is the lesson title — already shown in the app bar.
      if (t.startsWith('# ')) continue;

      final heading = RegExp(r'^#{2,6}\s+(.*)$').firstMatch(t);
      if (heading != null) {
        flush();
        currentTitle = _clean(heading.group(1)!);
        continue;
      }

      if (t.startsWith('- ') || t.startsWith('* ')) {
        rules.add(_clean(t.substring(2)));
        continue;
      }

      if (t.isEmpty) continue;

      if (text.isNotEmpty) text.write(' ');
      text.write(_clean(t));
    }

    // Unterminated code fence — keep whatever was collected.
    if (inCode && codeBuf.isNotEmpty) {
      code = codeBuf.toString().trimRight();
    }
    flush();

    if (sections.isEmpty) {
      sections.add(LessonSection(title: 'Lesson', text: _clean(markdown)));
    }
    return sections;
  }

  /// Strip inline markdown noise (bold markers, backticks).
  static String _clean(String s) =>
      s.replaceAll('**', '').replaceAll('`', '').trim();
}
