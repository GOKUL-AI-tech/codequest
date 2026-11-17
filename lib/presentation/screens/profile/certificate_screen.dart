import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/pdf_certificate_service.dart';
import '../../../core/services/share_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/lessons_provider.dart';
import '../../widgets/common/cyber_snackbar.dart';
import '../../widgets/game/codequest_certificate_card.dart';

class CertificateScreen extends ConsumerStatefulWidget {
  final String languageId;
  const CertificateScreen({super.key, required this.languageId});

  @override
  ConsumerState<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends ConsumerState<CertificateScreen> {
  late String _selectedLanguageId;
  final GlobalKey _certificateKey = GlobalKey();
  bool _isGeneratingPdf = false;

  @override
  void initState() {
    super.initState();
    _selectedLanguageId = widget.languageId;
  }

  Map<String, dynamic> _getLanguageData(String id) {
    return AppConstants.languages.firstWhere(
      (l) => l['id'] == id,
      orElse: () => {
        'id': id,
        'name': id.toUpperCase(),
        'icon': '💻',
        'color': 0xFF3572A5,
      },
    );
  }

  Future<ui.Image?> _captureCertificateImage() async {
    try {
      final boundary = _certificateKey.currentContext?.findRenderObject()
          as RenderRepaintBoundary?;
      if (boundary == null) return null;
      // High-res capture for pristine 300 DPI vector-like clarity in PDF
      return await boundary.toImage(pixelRatio: 3.0);
    } catch (e) {
      return null;
    }
  }

  Future<void> _downloadPdf(String username) async {
    final progress =
        await ref.read(languageProgressProvider(_selectedLanguageId).future);
    if (progress['isComplete'] != true) {
      if (mounted) {
        CyberSnackbar.showError(
          context,
          'Finish all lessons in this language to unlock the certificate.',
        );
      }
      return;
    }
    if (_isGeneratingPdf) return;
    setState(() => _isGeneratingPdf = true);

    try {
      final image = await _captureCertificateImage();
      if (image == null) {
        if (mounted) {
          CyberSnackbar.showError(context, 'Failed to capture certificate image.');
        }
        return;
      }

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        if (mounted) {
          CyberSnackbar.showError(context, 'Failed to process certificate.');
        }
        return;
      }

      final pngBytes = byteData.buffer.asUint8List();
      final lang = _getLanguageData(_selectedLanguageId);
      final langName = lang['name'] as String;

      await PdfCertificateService.instance.downloadPdf(
        imageBytes: pngBytes,
        languageName: langName,
        username: username,
      );

      if (mounted) {
        CyberSnackbar.showSuccess(
          context,
          'Certificate downloaded! Opened in PDF Viewer / Print dialog.',
        );
      }
    } catch (e) {
      if (mounted) {
        CyberSnackbar.showError(context, 'Error generating PDF: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
      }
    }
  }

  Future<void> _sharePdf(String username) async {
    final progress =
        await ref.read(languageProgressProvider(_selectedLanguageId).future);
    if (progress['isComplete'] != true) {
      if (mounted) {
        CyberSnackbar.showError(
          context,
          'Finish all lessons in this language to unlock the certificate.',
        );
      }
      return;
    }
    if (_isGeneratingPdf) return;
    setState(() => _isGeneratingPdf = true);

    try {
      final image = await _captureCertificateImage();
      if (image == null) {
        if (mounted) {
          CyberSnackbar.showError(context, 'Failed to capture certificate image.');
        }
        return;
      }

      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;
      final pngBytes = byteData.buffer.asUint8List();
      final lang = _getLanguageData(_selectedLanguageId);
      final langName = lang['name'] as String;

      await PdfCertificateService.instance.sharePdf(
        imageBytes: pngBytes,
        languageName: langName,
        username: username,
      );
    } catch (e) {
      if (mounted) {
        CyberSnackbar.showError(context, 'Could not share certificate: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isGeneratingPdf = false);
      }
    }
  }

  void _showZoomModal(String username, int level, String rank) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.85),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(12),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: Center(
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: CodeQuestCertificateCard(
                    studentName: username,
                    level: level,
                    rank: rank,
                    languageId: _selectedLanguageId,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProfileProvider);
    final user = userAsync.value;
    final username = user?.username ?? 'CodeQuester';
    final userLevel = user?.level ?? 1;
    final userRank = user?.rank ?? 'Code Warrior';

    final lang = _getLanguageData(_selectedLanguageId);
    final langColor = Color(lang['color'] as int);
    final langName = lang['name'] as String;

    final progressAsync = ref.watch(languageProgressProvider(_selectedLanguageId));
    final progress = progressAsync.value;
    final isCertUnlocked = progress?['isComplete'] == true;
    final completedLessonCount = (progress?['completed'] as int?) ?? 0;
    final totalLessonCount = (progress?['total'] as int?) ?? 0;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'CERTIFICATE OF COMPLETION',
          style: const TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.neonCyan),
            tooltip: 'Share Certificate',
            onPressed: () => _sharePdf(username),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── LANGUAGE TRACK SELECTOR ──────────────────────────────────
            Text(
              'SELECT PROGRAMMING LANGUAGE',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: context.cqTextMuted,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: AppConstants.languages.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final l = AppConstants.languages[index];
                  final isSelected = l['id'] == _selectedLanguageId;
                  final c = Color(l['color'] as int);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedLanguageId = l['id'] as String;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isSelected ? c.withOpacity(0.2) : context.cqCard,
                        border: Border.all(
                          color: isSelected ? c : context.cqSurface,
                          width: isSelected ? 1.8 : 1.0,
                        ),
                        boxShadow: isSelected
                            ? [BoxShadow(color: c.withOpacity(0.35), blurRadius: 10)]
                            : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(l['icon'] as String, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(
                            l['name'] as String,
                            style: TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 13,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                              color: isSelected ? Colors.white : context.cqTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // ─── CERTIFICATE PREVIEW CARD ─────────────────────────────────
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xFF070F1E),
                    border: Border.all(color: const Color(0xFFC59B27).withOpacity(0.4), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFC59B27).withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: RepaintBoundary(
                        key: _certificateKey,
                        child: CodeQuestCertificateCard(
                          studentName: username,
                          level: userLevel,
                          rank: userRank,
                          languageId: _selectedLanguageId,
                        ),
                      ),
                    ),
                  ),
                ),

                // Tap to Zoom / Fullscreen button overlay
                Positioned(
                  bottom: 14,
                  right: 14,
                  child: GestureDetector(
                    onTap: () => _showZoomModal(username, userLevel, userRank),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF071426).withOpacity(0.85),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFC59B27), width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.zoom_in, color: Color(0xFFFFD54F), size: 16),
                          SizedBox(width: 4),
                          Text(
                            'ZOOM / EXPAND',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFD54F),
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.97, 0.97)),

            const SizedBox(height: 22),

            // ─── CERTIFICATE LOCK STATUS ───────────────────────────────────
            if (!isCertUnlocked)
              Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.error.withOpacity(0.08),
                  border: Border.all(color: AppColors.error.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.lock_outline, color: AppColors.error, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'CERTIFICATE LOCKED',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.error,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            totalLessonCount > 0
                                ? 'Finish all $langName lessons to unlock ($completedLessonCount/$totalLessonCount done)'
                                : 'Finish all $langName lessons to unlock this certificate',
                            style: TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 12,
                              color: context.cqTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            // ─── ACTION BUTTONS: Download PDF & Share ─────────────────────
            Row(
              children: [
                // 1. Download PDF Button
                Expanded(
                  flex: 6,
                  child: GestureDetector(
                    onTap: _isGeneratingPdf ? null : () => _downloadPdf(username),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFFB300), Color(0xFFFF6F00)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFFB300).withOpacity(0.4),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_isGeneratingPdf)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          else
                            const Icon(Icons.picture_as_pdf, color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _isGeneratingPdf ? 'PREPARING PDF…' : 'DOWNLOAD PDF',
                            style: const TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // 2. Share PDF Button
                Expanded(
                  flex: 4,
                  child: GestureDetector(
                    onTap: _isGeneratingPdf ? null : () => _sharePdf(username),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: context.cqCard,
                        border: Border.all(color: AppColors.neonCyan.withOpacity(0.5)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.share, color: AppColors.neonCyan, size: 18),
                          SizedBox(width: 6),
                          Text(
                            'SHARE',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.neonCyan,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ─── SKILLS EARNED SECTION ────────────────────────────────────
            _buildSkillsSection(context, lang, langColor),

            const SizedBox(height: 16),

            // ─── INFO CARD ────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: context.cqCard,
                border: Border.all(color: context.cqSurface),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFC59B27).withOpacity(0.15),
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: Color(0xFFFFD54F),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'OFFICIAL CODEQUEST CREDENTIAL',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD54F),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Issued for completing the $langName interactive learning curriculum. Download as a print-ready landscape PDF or share with recruiters and social networks.',
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 12,
                            color: context.cqTextSecondary,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsSection(
    BuildContext context,
    Map<String, dynamic> lang,
    Color color,
  ) {
    final skills = _langSkills[lang['id']] ??
        ['Programming fundamentals', 'Problem solving', 'Hands-on Projects'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: context.cqCard,
        border: Border.all(color: context.cqSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SKILLS CERTIFIED • ${lang['name']}',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 11,
                  color: context.cqTextMuted,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              Text(
                '${skills.length} Competencies',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: skills
                .map(
                  (s) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: color.withOpacity(0.08),
                      border: Border.all(color: color.withOpacity(0.25)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_rounded, color: color, size: 13),
                        const SizedBox(width: 5),
                        Text(
                          s,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 12,
                            color: color,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  static const _langSkills = <String, List<String>>{
    'python': [
      'Python Syntax & Data Types',
      'Lists, Tuples & Dictionaries',
      'OOP & Encapsulation',
      'Exception Handling',
      'File I/O & Modules',
      'Algorithms & Problem Solving',
    ],
    'javascript': [
      'Modern ES6+ Syntax',
      'DOM & Event Handling',
      'Async/Await & Promises',
      'Closures & Scope',
      'Fetch API & JSON',
      'Functional Programming',
    ],
    'dart': [
      'Dart 3.x Sound Null Safety',
      'Flutter Widget Architecture',
      'State Management Concepts',
      'Asynchronous Streams & Futures',
      'OOP & Mixins',
    ],
    'java': [
      'Java Class & Object Design',
      'Inheritance & Polymorphism',
      'Collections Framework',
      'Generics & Lambda Streams',
      'Multithreading Basics',
    ],
    'cpp': [
      'C++ Core Syntax',
      'Pointers & References',
      'Standard Template Library (STL)',
      'Memory Management & RAII',
      'Template Metaprogramming',
    ],
    'c': [
      'C Syntax & Data Types',
      'Pointers & Memory Addresses',
      'Dynamic Memory (malloc/free)',
      'Structs & Typedefs',
      'Low-Level File I/O',
    ],
    'html': [
      'Semantic HTML5 Elements',
      'Forms & Input Validation',
      'Accessibility (a11y) & ARIA',
      'SEO Best Practices',
      'Media & Audio/Video Embedding',
    ],
    'css': [
      'CSS Flexbox & Grid Systems',
      'Transitions & Animations',
      'Responsive Web Design',
      'CSS Variables & Modern Selectors',
      'Box Model & Positioning',
    ],
    'sql': [
      'SELECT, WHERE & ORDER BY',
      'INNER, LEFT & RIGHT JOINs',
      'GROUP BY & Aggregations',
      'Database Normalization',
      'Indexes & Transactions',
    ],
    'typescript': [
      'Static Typing & Interfaces',
      'Type Aliases & Union Types',
      'Generics & Constraints',
      'Decorators & Modules',
      'Strict Null Checking',
    ],
  };
}
