import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';

/// Pixel-perfect Certificate of Completion matching the luxury navy & gold design.
class CodeQuestCertificateCard extends StatelessWidget {
  final String studentName;
  final int level;
  final String rank;
  final String languageId;
  final DateTime? completionDate;

  const CodeQuestCertificateCard({
    super.key,
    required this.studentName,
    required this.level,
    required this.rank,
    required this.languageId,
    this.completionDate,
  });

  @override
  Widget build(BuildContext context) {
    final lang = AppConstants.languages.firstWhere(
      (l) => l['id'] == languageId,
      orElse: () => {
        'id': languageId,
        'name': languageId.toUpperCase(),
        'icon': '💻',
        'color': 0xFF3572A5,
      },
    );
    final String languageName = lang['name'] as String;
    final String languageIcon = lang['icon'] as String;
    final int langColorHex = (lang['color'] as int?) ?? 0xFF3572A5;
    final Color langAccent = Color(langColorHex);

    final date = completionDate ?? DateTime.now();
    final formattedDate = _formatDate(date);

    return Container(
      width: 850,
      height: 600,
      decoration: BoxDecoration(
        color: const Color(0xFFFDFCFA), // Luxury warm ivory parchment
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: CustomPaint(
        painter: CertificateFramePainter(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ─── TOP BAR: Logo & Motto ──────────────────────────────────
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 80), // Balance top-right motto width
                  // Center: CodeQuest Logo
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const _CodeQuestInfinityLogo(),
                      const SizedBox(height: 2),
                      const Text(
                        'codequest',
                        style: TextStyle(
                          fontFamily: 'Orbitron',
                          fontSize: 19,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF071426),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Text(
                        'TURNING GAMES WITH CODING',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 7.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF071426),
                          letterSpacing: 2.2,
                        ),
                      ),
                    ],
                  ),
                  // Right: Motto
                  Padding(
                    padding: const EdgeInsets.only(top: 4, right: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('PLAY', style: _mottoStyle),
                        Text('LEARN', style: _mottoStyle),
                        Text('PRACTICE', style: _mottoStyle),
                        Text('PROGRESS', style: _mottoStyle),
                        Text('A BRIGHTER', style: _mottoStyle),
                        Text('TOMORROW', style: _mottoStyle),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ─── CERTIFICATE HEADER ─────────────────────────────────────
              Text(
                'CERTIFICATE',
                style: GoogleFonts.cinzel(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF071426),
                  letterSpacing: 5.0,
                ),
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(width: 60, height: 1.2, color: const Color(0xFFC59B27)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'OF COMPLETION',
                      style: GoogleFonts.cinzel(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF071426),
                        letterSpacing: 4.0,
                      ),
                    ),
                  ),
                  Container(width: 60, height: 1.2, color: const Color(0xFFC59B27)),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'THIS IS TO CERTIFY THAT',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF071426),
                  letterSpacing: 3.5,
                ),
              ),

              const SizedBox(height: 10),

              // ─── RECIPIENT NAME & LEVEL ─────────────────────────────────
              SizedBox(
                width: 520,
                child: Column(
                  children: [
                    Text(
                      studentName.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cinzel(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF071426),
                        letterSpacing: 2.0,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 420,
                      height: 1.4,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color(0xFFC59B27),
                            Color(0xFFD4AF37),
                            Color(0xFFC59B27),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LEVEL $level  •  ${rank.toUpperCase()}',
                      style: const TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFC59B27),
                        letterSpacing: 2.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ─── BODY DESCRIPTION & GOLD MEDAL SEAL ─────────────────────
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(width: 20),
                    // Left: Certificate statement
                    Expanded(
                      flex: 7,
                      child: Center(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: SizedBox(
                            width: 480,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontFamily: 'Rajdhani',
                                      fontSize: 16,
                                      color: Color(0xFF1E293B),
                                      fontWeight: FontWeight.w600,
                                    ),
                                    children: [
                                      const TextSpan(
                                          text: 'has successfully completed the '),
                                      const TextSpan(
                                        text: 'CodeQuest',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF071426),
                                        ),
                                      ),
                                      const TextSpan(
                                          text:
                                              ' Interactive Learning Program for '),
                                      TextSpan(
                                        text: languageName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Color(0xFF071426),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 14),
                                  child: Text(
                                    'This certification acknowledges the successful completion of an engaging, '
                                    'game-based learning journey in $languageName programming, covering '
                                    'fundamental concepts, problem-solving, and hands-on coding challenges '
                                    'through the CodeQuest platform.',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontFamily: 'Rajdhani',
                                      fontSize: 11.5,
                                      color: Color(0xFF475569),
                                      height: 1.4,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Right: Scalloped Gold Seal Medal
                    Expanded(
                      flex: 3,
                      child: Center(
                        child: _CertificateSeal(
                          languageName: languageName,
                          languageIcon: languageIcon,
                          accentColor: langAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ─── FOOTER METADATA: Date, Mode, Signature ─────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Column 1: Date of Completion
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'DATE OF COMPLETION',
                          style: _footerHeaderStyle,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formattedDate,
                          style: const TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(width: 130, height: 1.0, color: const Color(0xFFC59B27)),
                      ],
                    ),

                    // Column 2: Learning Mode
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'LEARNING MODE',
                          style: _footerHeaderStyle,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Game-Based Learning',
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(width: 140, height: 1.0, color: const Color(0xFFC59B27)),
                      ],
                    ),

                    // Column 3: Authorized Signature
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'AUTHORIZED SIGNATURE',
                          style: _footerHeaderStyle,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Gokul',
                          style: GoogleFonts.greatVibes(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF071426),
                          ),
                        ),
                        Container(width: 140, height: 1.0, color: const Color(0xFF071426)),
                        const SizedBox(height: 4),
                        const Text(
                          'GOKUL',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 8.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF071426),
                            letterSpacing: 1.5,
                          ),
                        ),
                        const Text(
                          'Project Developer',
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const Text(
                          'CodeQuest',
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 8.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF475569),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ─── BOTTOM-MOST FOOTER SLOGANS ─────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Flexible(
                      child: Text(
                        'CODEQUEST  •  SKILLS TODAY. BIGGER TOMORROW.',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 7.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                          letterSpacing: 1.0,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'EXPLORE  |  LEARN  |  PLAY  |  CODE  |  ACHIEVE',
                        style: TextStyle(
                          fontFamily: 'Rajdhani',
                          fontSize: 7.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF64748B),
                          letterSpacing: 1.0,
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _mottoStyle = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 7.5,
    fontWeight: FontWeight.w700,
    color: Color(0xFF071426),
    letterSpacing: 1.2,
    height: 1.35,
  );

  static const _footerHeaderStyle = TextStyle(
    fontFamily: 'Orbitron',
    fontSize: 8.0,
    fontWeight: FontWeight.bold,
    color: Color(0xFF071426),
    letterSpacing: 1.5,
  );

  static String _formatDate(DateTime dt) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}

// ─── CodeQuest Infinity Logo ──────────────────────────────────────────────────

class _CodeQuestInfinityLogo extends StatelessWidget {
  const _CodeQuestInfinityLogo();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 28,
      child: CustomPaint(
        painter: _InfinitySwirlPainter(),
      ),
    );
  }
}

class _InfinitySwirlPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final midX = w / 2;
    final midY = h / 2;

    final paint1 = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00E5FF), Color(0xFF4455EE), Color(0xFFB000FF)],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // Smooth lemniscate/infinity curve
    path.moveTo(midX, midY);
    path.cubicTo(midX + 16, midY - 14, w, midY - 14, w - 6, midY);
    path.cubicTo(w, midY + 14, midX + 16, midY + 14, midX, midY);
    path.cubicTo(midX - 16, midY - 14, 0, midY - 14, 6, midY);
    path.cubicTo(0, midY + 14, midX - 16, midY + 14, midX, midY);

    canvas.drawPath(path, paint1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Frame Painter (Geometric Navy/Gold Corners & Laurel Watermark) ───────────

class CertificateFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Watermark: faint laurel wreath in center
    _drawWatermark(canvas, size);

    // 2. Double border lines
    final goldBorder1 = Paint()
      ..color = const Color(0xFFC59B27)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final goldBorder2 = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.drawRect(Rect.fromLTWH(14, 14, w - 28, h - 28), goldBorder1);
    canvas.drawRect(Rect.fromLTWH(18, 18, w - 36, h - 36), goldBorder2);

    // 3. Corner geometric decorations
    final navyPaint = Paint()
      ..color = const Color(0xFF071426)
      ..style = PaintingStyle.fill;

    final goldPaint = Paint()
      ..color = const Color(0xFFC59B27)
      ..style = PaintingStyle.fill;

    const cornerSize = 75.0;

    // ── TOP-LEFT CORNER ──
    final tlNavy = Path()
      ..moveTo(0, 0)
      ..lineTo(cornerSize, 0)
      ..lineTo(0, cornerSize)
      ..close();
    canvas.drawPath(tlNavy, navyPaint);

    final tlGold = Path()
      ..moveTo(cornerSize + 2, 0)
      ..lineTo(cornerSize + 8, 0)
      ..lineTo(0, cornerSize + 8)
      ..lineTo(0, cornerSize + 2)
      ..close();
    canvas.drawPath(tlGold, goldPaint);

    // ── TOP-RIGHT CORNER ──
    final trNavy = Path()
      ..moveTo(w, 0)
      ..lineTo(w - cornerSize, 0)
      ..lineTo(w, cornerSize)
      ..close();
    canvas.drawPath(trNavy, navyPaint);

    final trGold = Path()
      ..moveTo(w - cornerSize - 2, 0)
      ..lineTo(w - cornerSize - 8, 0)
      ..lineTo(w, cornerSize + 8)
      ..lineTo(w, cornerSize + 2)
      ..close();
    canvas.drawPath(trGold, goldPaint);

    // ── BOTTOM-LEFT CORNER ──
    final blNavy = Path()
      ..moveTo(0, h)
      ..lineTo(cornerSize, h)
      ..lineTo(0, h - cornerSize)
      ..close();
    canvas.drawPath(blNavy, navyPaint);

    final blGold = Path()
      ..moveTo(cornerSize + 2, h)
      ..lineTo(cornerSize + 8, h)
      ..lineTo(0, h - cornerSize - 8)
      ..lineTo(0, h - cornerSize - 2)
      ..close();
    canvas.drawPath(blGold, goldPaint);

    // ── BOTTOM-RIGHT CORNER ──
    final brNavy = Path()
      ..moveTo(w, h)
      ..lineTo(w - cornerSize, h)
      ..lineTo(w, h - cornerSize)
      ..close();
    canvas.drawPath(brNavy, navyPaint);

    final brGold = Path()
      ..moveTo(w - cornerSize - 2, h)
      ..lineTo(w - cornerSize - 8, h)
      ..lineTo(w, h - cornerSize - 8)
      ..lineTo(w, h - cornerSize - 2)
      ..close();
    canvas.drawPath(brGold, goldPaint);
  }

  void _drawWatermark(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2 + 10;
    final paint = Paint()
      ..color = const Color(0xFFC59B27).withOpacity(0.045)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // Circular laurel outline
    canvas.drawCircle(Offset(cx, cy), 130, paint);

    final leafPaint = Paint()
      ..color = const Color(0xFFC59B27).withOpacity(0.035)
      ..style = PaintingStyle.fill;

    // Faint wreath leaves
    for (int i = 0; i < 20; i++) {
      final angle = (i * math.pi / 10) - (math.pi / 2);
      final lx = cx + 130 * math.cos(angle);
      final ly = cy + 130 * math.sin(angle);
      canvas.save();
      canvas.translate(lx, ly);
      canvas.rotate(angle);
      canvas.drawOval(
        const Rect.fromLTWH(-8, -16, 16, 32),
        leafPaint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── Scalloped Gold Medal Seal with Blue Ribbon Streamers ─────────────────────

class _CertificateSeal extends StatelessWidget {
  final String languageName;
  final String languageIcon;
  final Color accentColor;

  const _CertificateSeal({
    required this.languageName,
    required this.languageIcon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      height: 160,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          // 1. Ribbon Streamers (Navy with Gold borders)
          Positioned(
            top: 72,
            child: SizedBox(
              width: 110,
              height: 75,
              child: CustomPaint(
                painter: _RibbonStreamersPainter(),
              ),
            ),
          ),

          // 2. Scalloped 3D Gold Medal
          Positioned(
            top: 0,
            child: Container(
              width: 116,
              height: 116,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC59B27).withOpacity(0.4),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: CustomPaint(
                painter: _ScallopedGoldMedalPainter(),
                child: Center(
                  // Inner Dark Blue Disc
                  child: Container(
                    width: 86,
                    height: 86,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF071426),
                      border: Border.all(
                        color: const Color(0xFFFFD54F),
                        width: 2.0,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'CODEQUEST',
                          style: TextStyle(
                            fontFamily: 'Orbitron',
                            fontSize: 7.5,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFFD54F),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          languageIcon,
                          style: const TextStyle(fontSize: 22),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          languageName.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFFD54F),
                            letterSpacing: 1.2,
                          ),
                        ),
                        const Text(
                          '★',
                          style: TextStyle(
                            fontSize: 8.5,
                            color: Color(0xFFFFD54F),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RibbonStreamersPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final navyFill = Paint()
      ..color = const Color(0xFF071426)
      ..style = PaintingStyle.fill;

    final goldStroke = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    // Left ribbon tail
    final leftPath = Path()
      ..moveTo(30, 0)
      ..lineTo(14, size.height)
      ..lineTo(32, size.height - 14)
      ..lineTo(50, size.height)
      ..lineTo(44, 0)
      ..close();

    canvas.drawPath(leftPath, navyFill);
    canvas.drawPath(leftPath, goldStroke);

    // Right ribbon tail
    final rightPath = Path()
      ..moveTo(66, 0)
      ..lineTo(60, size.height)
      ..lineTo(78, size.height - 14)
      ..lineTo(96, size.height)
      ..lineTo(80, 0)
      ..close();

    canvas.drawPath(rightPath, navyFill);
    canvas.drawPath(rightPath, goldStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ScallopedGoldMedalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final rBase = size.width / 2 - 2;

    const numPoints = 28;
    final path = Path();
    for (int i = 0; i < numPoints; i++) {
      final a1 = (i * 2 * math.pi) / numPoints;
      final a2 = ((i + 0.5) * 2 * math.pi) / numPoints;
      final x1 = cx + rBase * math.cos(a1);
      final y1 = cy + rBase * math.sin(a1);
      final x2 = cx + (rBase - 4) * math.cos(a2);
      final y2 = cy + (rBase - 4) * math.sin(a2);

      if (i == 0) {
        path.moveTo(x1, y1);
      } else {
        path.lineTo(x1, y1);
      }
      path.lineTo(x2, y2);
    }
    path.close();

    final goldGradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFFFEE93),
        Color(0xFFFFD54F),
        Color(0xFFC59B27),
        Color(0xFF997A15),
        Color(0xFFFFD54F),
        Color(0xFFFFEE93),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint = Paint()
      ..shader = goldGradient
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    // Bevel ring
    final bevelPaint = Paint()
      ..color = const Color(0xFFD4AF37)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(Offset(cx, cy), rBase - 7, bevelPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
