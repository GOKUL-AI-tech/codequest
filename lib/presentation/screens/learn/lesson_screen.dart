import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:go_router/go_router.dart';

import '../../../core/data/lesson_content_db.dart';
import '../../../core/data/markdown_lesson_parser.dart';
import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/lessons_provider.dart';
import '../../widgets/common/neon_button.dart';
import '../../widgets/game/xp_roulette.dart';

// ─── TTS State ────────────────────────────────────────────────────────────────

enum TtsState { stopped, playing, paused }

// ─── Screen ───────────────────────────────────────────────────────────────────

class LessonScreen extends ConsumerStatefulWidget {
  final String lessonId;
  final String? languageId;  // passed as query param ?lang=python
  final int? orderIndex;     // passed as query param ?order=2
  const LessonScreen({
    super.key,
    required this.lessonId,
    this.languageId,
    this.orderIndex,
  });

  @override
  ConsumerState<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends ConsumerState<LessonScreen> {
  final ScrollController _scrollController = ScrollController();
  final FlutterTts _tts = FlutterTts();

  double _readProgress = 0;
  TtsState _ttsState = TtsState.stopped;
  String _ttsLabel = '';

  /// Content parsed from the lesson's own markdown in Supabase.
  /// This is the primary source — it is unique per lesson, so lesson 1
  /// and lesson 2 always show different content.
  LessonContent? _remoteContent;

  static final _uuidRe = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
  bool get _isRemoteLesson => _uuidRe.hasMatch(widget.lessonId);

  // Determine which content to show.
  // Priority:
  //   1. The lesson's own markdown content fetched from Supabase (unique per lesson)
  //   2. Direct local key match ('python_0', 'javascript_2', etc.)
  //   3. languageId + orderIndex passed as query params (local fallback)
  //   4. Decode language from known Supabase UUID prefix patterns
  //   5. Final fallback: python_0
  LessonContent? get _content {
    // 1. Unique remote content (parsed in build)
    if (_remoteContent != null) return _remoteContent;

    // 2. Direct key match
    final direct = LessonContentDb.getByKey(widget.lessonId);
    if (direct != null) return direct;

    // 3. Use query-param languageId + orderIndex (passed from LessonsListScreen)
    final lang = widget.languageId;
    final order = widget.orderIndex;
    if (lang != null && lang.isNotEmpty) {
      final lessons = LessonContentDb.forLanguage(lang);
      if (lessons.isNotEmpty) {
        if (order != null && order > 0) {
          // order is 1-based from Supabase order_index
          final idx = (order - 1).clamp(0, lessons.length - 1);
          return lessons[idx];
        }
        return lessons.first;
      }
    }

    // 4. Decode from known Supabase UUID prefix (seed data pattern)
    const prefixToLang = {
      '10000001': 'python',
      '20000001': 'javascript',
      '30000001': 'dart',
      '40000001': 'java',
      '50000001': 'cpp',
      '60000001': 'c',
    };
    final prefix = widget.lessonId.length >= 8 ? widget.lessonId.substring(0, 8) : '';
    final prefixLang = prefixToLang[prefix];
    if (prefixLang != null) {
      final lastSegment = widget.lessonId.split('-').last;
      final orderIndex = int.tryParse(lastSegment) ?? 1;
      final lessons = LessonContentDb.forLanguage(prefixLang);
      if (lessons.isNotEmpty) {
        final idx = (orderIndex - 1).clamp(0, lessons.length - 1);
        return lessons[idx];
      }
    }

    // 5. Language-aware fallback using LessonContentDb.getOrGenerate
    final fallbackLang = widget.languageId ?? prefixLang ?? 'python';
    return LessonContentDb.getOrGenerate(
      lessonId: widget.lessonId,
      languageId: fallbackLang,
      orderIndex: widget.orderIndex,
    );
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _initTts();
  }

  Future<void> _initTts() async {
    if (kIsWeb) return; // TTS not supported on web
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);

    _tts.setStartHandler(() => setState(() => _ttsState = TtsState.playing));
    _tts.setCompletionHandler(() => setState(() => _ttsState = TtsState.stopped));
    _tts.setCancelHandler(() => setState(() => _ttsState = TtsState.stopped));
    _tts.setPauseHandler(() => setState(() => _ttsState = TtsState.paused));
    _tts.setContinueHandler(() => setState(() => _ttsState = TtsState.playing));
  }

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent > 0) {
      setState(() => _readProgress =
          (_scrollController.offset /
                  _scrollController.position.maxScrollExtent)
              .clamp(0.0, 1.0));
    }
  }

  // ── TTS Actions ─────────────────────────────────────────────────────────────

  Future<void> _readLesson() async {
    if (kIsWeb) return;
    final c = _content;
    if (c == null) return;
    await _stopTts();
    setState(() => _ttsLabel = 'Reading lesson...');
    final allText = c.sections
        .map((s) => '${s.title}. ${s.text} ${s.rules?.join('. ') ?? ''} ${s.tipBody ?? ''}')
        .join(' ');
    await _tts.speak(allText);
  }

  Future<void> _explainSection(LessonSection section) async {
    if (kIsWeb) return;
    await _stopTts();
    setState(() => _ttsLabel = 'Explaining ${section.title}...');
    final text =
        '${section.title}. ${section.text} ${section.rules?.join('. ') ?? ''} ${section.tipTitle != null ? '${section.tipTitle}. ${section.tipBody}' : ''}';
    await _tts.speak(text);
  }

  Future<void> _stopTts() async {
    if (kIsWeb) return;
    await _tts.stop();
    setState(() {
      _ttsState = TtsState.stopped;
      _ttsLabel = '';
    });
  }

  Future<void> _togglePause() async {
    if (kIsWeb) return;
    if (_ttsState == TtsState.playing) {
      await _tts.pause();
    } else if (_ttsState == TtsState.paused) {
      await _tts.speak('');
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _tts.stop();
    super.dispose();
  }

  // ── Lesson Complete ──────────────────────────────────────────────────────────

  Future<void> _completeLesson(BuildContext context) async {
    final c = _content;
    final int baseXp = c?.xpReward ?? 50;
    final int coins = c?.coinReward ?? 10;

    final result = await ref
        .read(lessonCompletionProvider.notifier)
        .completeLesson(
          lessonId: widget.lessonId,
          xpReward: baseXp,
          coinReward: coins,
          // Needed for the +25% specialty bonus — was never passed before.
          languageId: widget.languageId ?? c?.languageId,
        )
        // Same safety net as quiz/coding-challenge/boss-battle screens:
        // don't let a network/auth hiccup throw an uncaught error when the
        // user finishes a lesson — fall back to an empty result instead.
        .catchError((_) => <String, dynamic>{});

    if (!mounted) return;

    final gotBonus = result['specialtyBonus'] == true;
    final finalXp = (result['finalXp'] as int?) ?? baseXp;

    await NotificationService.instance.showXpReward(
      finalXp,
      reason: gotBonus
          ? 'Specialty bonus! +25% XP for your main language.'
          : 'Lesson complete! Keep the streak going.',
    );
    if (result['level_up'] == true) {
      await NotificationService.instance
          .showLevelUp(result['new_level'] as int? ?? 1);
    }

    if (!mounted) return;
    if (gotBonus) {
      _showSpecialtyBonusToast(context, finalXp);
      await Future.delayed(const Duration(milliseconds: 1200));
    }

    if (!mounted) return;

    // 🎰 XP Roulette spin — show before the completion sheet
    final bonus = await XpRouletteDialog.show(
      context,
      baseXp: finalXp,
      baseCoins: coins,
    );
    final totalXp = finalXp + (bonus?.xpBonus ?? 0);
    final totalCoins = coins + (bonus?.coinBonus ?? 0);

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _LessonCompleteSheet(
        xp: totalXp,
        coins: totalCoins,
        specialtyBonus: gotBonus,
        onContinue: () {
          Navigator.pop(context);
          context.pop();
        },
        onQuiz: () {
          Navigator.pop(context);
          context.push('/quiz/${widget.lessonId}');
        },
        onViewCertificate: () {
          Navigator.pop(context);
          final lang = widget.languageId ?? c?.languageId ?? 'python';
          context.push('/certificate/$lang');
        },
      ),
    );
  }

  void _showSpecialtyBonusToast(BuildContext context, int xp) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (_) => Positioned(
        top: MediaQuery.of(context).padding.top + 80,
        left: 24, right: 24,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFFBF00FF), Color(0xFF00F5FF)],
              ),
              boxShadow: [BoxShadow(color: const Color(0xFFBF00FF).withOpacity(0.5), blurRadius: 20)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('⚡', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('SPECIALTY BONUS!',
                        style: TextStyle(fontFamily: 'Orbitron', fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5)),
                    Text('+25% XP  →  $xp XP earned',
                        style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13, color: Colors.white.withOpacity(0.9))),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.3).then(delay: 1500.ms).fadeOut(duration: 400.ms),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 2400), entry.remove);
  }

  // ── Build ────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    // Fetch this lesson's own content from Supabase (unique per lesson).
    if (_isRemoteLesson && LessonContentDb.getByKey(widget.lessonId) == null) {
      final remote = ref.watch(lessonDetailProvider(widget.lessonId));
      final lesson = remote.value;
      final md = lesson?.content;
      if (lesson != null && md != null && md.trim().isNotEmpty) {
        _remoteContent = MarkdownLessonParser.build(
          lessonKey: widget.lessonId,
          languageId: lesson.languageId,
          title: lesson.title,
          subtitle: lesson.description,
          xpReward: lesson.xpReward,
          coinReward: lesson.coinReward,
          estimatedMinutes: lesson.estimatedTime?.inMinutes ?? 10,
          markdown: md,
        );
      } else if (remote.isLoading) {
        return const Scaffold(
          body: Center(
              child: CircularProgressIndicator(color: AppColors.neonCyan)),
        );
      }
      // On error or missing content, fall through to the local fallback.
    }

    final c = _content;
    if (c == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.neonCyan)),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // ── App Bar ──────────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 190,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () => context.pop(),
            ),
            actions: [
              // TTS controls
              if (_ttsState == TtsState.playing || _ttsState == TtsState.paused)
                IconButton(
                  icon: Icon(
                    _ttsState == TtsState.playing ? Icons.pause_circle_outline : Icons.play_circle_outline,
                    color: AppColors.neonCyan,
                  ),
                  onPressed: _togglePause,
                ),
              if (_ttsState != TtsState.stopped)
                IconButton(
                  icon: const Icon(Icons.stop_circle_outlined, color: AppColors.neonPink),
                  onPressed: _stopTts,
                ),
              // Read all button
              IconButton(
                icon: Icon(Icons.volume_up_outlined, color: context.cqTextSecondary),
                tooltip: 'Read lesson aloud',
                onPressed: _ttsState == TtsState.stopped ? _readLesson : _stopTts,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: Text(c.subtitle,
                                  style: const TextStyle(fontFamily: 'Share Tech Mono', fontSize: 10, color: Colors.white, letterSpacing: 1.5)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.white.withOpacity(0.2),
                              ),
                              child: Text('${c.languageEmoji} ${c.languageId.toUpperCase()}',
                                  style: const TextStyle(fontFamily: 'Rajdhani', fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(c.title,
                            style: const TextStyle(fontFamily: 'Orbitron', fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.timer_outlined, color: Colors.white70, size: 14),
                            const SizedBox(width: 4),
                            Text('${c.estimatedMinutes} min', style: const TextStyle(color: Colors.white70, fontFamily: 'Rajdhani', fontSize: 13)),
                            const SizedBox(width: 16),
                            Text('⭐ +${c.xpReward} XP', style: const TextStyle(color: Colors.white70, fontFamily: 'Rajdhani', fontSize: 13)),
                            const SizedBox(width: 8),
                            Text('🪙 +${c.coinReward}', style: const TextStyle(color: Colors.white70, fontFamily: 'Rajdhani', fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Progress Bar ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: LinearProgressIndicator(
              value: _readProgress,
              backgroundColor: context.cqCardSecondary,
              valueColor: const AlwaysStoppedAnimation(AppColors.neonCyan),
              minHeight: 3,
            ),
          ),

          // ── TTS Playing Banner ────────────────────────────────────────
          if (_ttsState != TtsState.stopped)
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: AppColors.neonCyan.withOpacity(0.08),
                child: Row(
                  children: [
                    Icon(
                      _ttsState == TtsState.playing ? Icons.graphic_eq : Icons.pause,
                      color: AppColors.neonCyan, size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _ttsLabel.isEmpty ? 'Reading...' : _ttsLabel,
                        style: const TextStyle(fontFamily: 'Rajdhani', fontSize: 13, color: AppColors.neonCyan),
                      ),
                    ),
                    GestureDetector(
                      onTap: _stopTts,
                      child: Icon(Icons.close, color: context.cqTextMuted, size: 16),
                    ),
                  ],
                ),
              ).animate(onPlay: (c) => c.repeat(reverse: true))
                  .shimmer(duration: 1200.ms, color: AppColors.neonCyan.withOpacity(0.2)),
            ),

          // ── Lesson Sections ───────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _SectionWidget(
                  section: c.sections[i],
                  index: i,
                  onExplain: () => _explainSection(c.sections[i]),
                  isReading: _ttsState != TtsState.stopped,
                ).animate(delay: Duration(milliseconds: i * 80)).fadeIn().slideY(begin: 0.1),
                childCount: c.sections.length,
              ),
            ),
          ),

          // ── Voice Summary ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: _readLesson,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: AppColors.neonPurple.withOpacity(0.08),
                    border: Border.all(color: AppColors.neonPurple.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44, height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.neonPurple.withOpacity(0.15),
                        ),
                        child: Icon(
                          _ttsState == TtsState.playing ? Icons.stop : Icons.play_arrow,
                          color: AppColors.neonPurple, size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _ttsState == TtsState.playing ? 'TAP TO STOP' : '🎙️ READ THIS LESSON ALOUD',
                              style: TextStyle(
                                fontFamily: 'Orbitron', fontSize: 11,
                                color: AppColors.neonPurple, letterSpacing: 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Let ALEX narrate the entire lesson for you',
                              style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13, color: context.cqTextSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Complete Button ───────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              child: NeonButton(
                label: 'COMPLETE LESSON  →',
                onTap: () => _completeLesson(context),
                gradient: AppColors.greenGradient,
                glowColor: AppColors.neonGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Widget ───────────────────────────────────────────────────────────

class _SectionWidget extends StatelessWidget {
  final LessonSection section;
  final int index;
  final VoidCallback onExplain;
  final bool isReading;

  const _SectionWidget({
    required this.section,
    required this.index,
    required this.onExplain,
    required this.isReading,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Section header with explain button
        Row(
          children: [
            Container(
              width: 4, height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: AppColors.cyberpunkGradient,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                section.title,
                style: TextStyle(
                  fontFamily: 'Orbitron', fontSize: 15,
                  fontWeight: FontWeight.bold, color: context.cqTextPrimary,
                ),
              ),
            ),
            // Explain this section button
            GestureDetector(
              onTap: onExplain,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.neonCyan.withOpacity(0.1),
                  border: Border.all(color: AppColors.neonCyan.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.volume_up, color: AppColors.neonCyan, size: 13),
                    const SizedBox(width: 4),
                    const Text('EXPLAIN', style: TextStyle(fontFamily: 'Orbitron', fontSize: 8, color: AppColors.neonCyan, letterSpacing: 1)),
                  ],
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Body text
        if (section.text.isNotEmpty)
          Text(
            section.text,
            style: TextStyle(fontFamily: 'Rajdhani', fontSize: 15, color: context.cqTextSecondary, height: 1.6),
          ),

        // Code block
        if (section.code != null) ...[
          const SizedBox(height: 12),
          _CodeBlock(code: section.code!, language: section.language ?? 'python'),
        ],

        // Type grid
        if (section.typeGrid != null) ...[
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 1.4,
            ),
            itemCount: section.typeGrid!.length,
            itemBuilder: (context, i) {
              final t = section.typeGrid![i];
              final color = Color(t['colorHex'] as int);
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color.withOpacity(0.08),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(t['type'] as String, style: TextStyle(fontFamily: 'Orbitron', fontSize: 12, fontWeight: FontWeight.bold, color: color)),
                    Text(t['example'] as String, style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 11, color: context.cqTextMuted)),
                  ],
                ),
              );
            },
          ),
        ],

        // Rules list
        if (section.rules != null) ...[
          const SizedBox(height: 8),
          ...section.rules!.map((rule) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('▹ ', style: TextStyle(color: AppColors.neonCyan, fontSize: 16)),
                Expanded(
                  child: Text(rule, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, color: context.cqTextSecondary, height: 1.4)),
                ),
              ],
            ),
          )),
        ],

        // Tip box
        if (section.tipTitle != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.neonCyan.withOpacity(0.05),
              border: Border.all(color: AppColors.neonCyan.withOpacity(0.25)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(section.tipTitle!, style: const TextStyle(fontFamily: 'Orbitron', fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.neonCyan)),
                      const SizedBox(height: 4),
                      Text(section.tipBody ?? '', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14, color: context.cqTextSecondary, height: 1.5)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 20),
      ],
    );
  }
}

// ─── Code Block ───────────────────────────────────────────────────────────────

class _CodeBlock extends StatelessWidget {
  final String code;
  final String language;
  const _CodeBlock({required this.code, required this.language});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.cqSurface),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              color: context.cqCardSecondary,
              child: Row(
                children: [
                  for (final c in [Colors.red, Colors.orange, Colors.green])
                    Container(width: 10, height: 10, margin: const EdgeInsets.only(right: 6),
                        decoration: BoxDecoration(color: c, shape: BoxShape.circle)),
                  SizedBox(width: 8),
                  Text(language, style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 11, color: context.cqTextMuted)),
                ],
              ),
            ),
            HighlightView(
              code,
              language: language == 'cpp' ? 'cpp' : language == 'c' ? 'c' : language,
              theme: atomOneDarkTheme,
              padding: const EdgeInsets.all(14),
              textStyle: const TextStyle(fontFamily: 'Share Tech Mono', fontSize: 12, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Complete Sheet ───────────────────────────────────────────────────────────

class _LessonCompleteSheet extends StatelessWidget {
  final int xp;
  final int coins;
  final bool specialtyBonus;
  final VoidCallback onContinue;
  final VoidCallback onQuiz;
  final VoidCallback onViewCertificate;

  const _LessonCompleteSheet({
    required this.xp,
    required this.coins,
    required this.onContinue,
    required this.onQuiz,
    required this.onViewCertificate,
    this.specialtyBonus = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = specialtyBonus ? const Color(0xFFBF00FF) : AppColors.neonGreen;
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: context.cqCard,
        border: Border.all(color: color.withOpacity(0.4)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 30)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(specialtyBonus ? '⚡' : '🎉', style: const TextStyle(fontSize: 56))
              .animate().scale(duration: 500.ms, curve: Curves.elasticOut),
          const SizedBox(height: 14),
          Text(
            specialtyBonus ? 'SPECIALTY BONUS!' : 'LESSON COMPLETE!',
            style: TextStyle(fontFamily: 'Orbitron', fontSize: 20, fontWeight: FontWeight.bold, color: color, letterSpacing: 2),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Chip(label: '+$xp XP', color: AppColors.neonYellow),
              const SizedBox(width: 14),
              _Chip(label: '+$coins 🪙', color: AppColors.neonOrange),
            ],
          ),
          const SizedBox(height: 22),
          NeonButton(
            label: 'TAKE QUIZ FOR BONUS',
            onTap: onQuiz,
            gradient: const LinearGradient(colors: [Color(0xFFFF6B00), Color(0xFFFF006E)]),
            glowColor: AppColors.neonPink,
          ),
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
          const SizedBox(height: 8),
          TextButton(
            onPressed: onContinue,
            child: Text('Skip quiz, continue', style: TextStyle(color: context.cqTextSecondary, fontFamily: 'Rajdhani', fontSize: 15)),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: color.withOpacity(0.1),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(label, style: TextStyle(fontFamily: 'Orbitron', fontSize: 14, fontWeight: FontWeight.bold, color: color)),
    );
  }
}
