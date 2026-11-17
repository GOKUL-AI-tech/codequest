import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

/// A "gaming HUD" style icon badge: the icon sits inside a glowing circular
/// (or hexagon-cut) frame instead of floating bare, matching the app's
/// neon-cyberpunk look. Used wherever a plain Material icon used to sit on
/// its own (settings rows, quick actions, nav bars, list tiles).
///
/// [active] gives the badge a solid glowing fill (selected/current state);
/// otherwise it renders as a subtle outlined ring so it still reads as
/// "gaming UI" without competing with the active state.
class GameIconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final double iconScale;
  final bool active;
  final bool hex;

  const GameIconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 38,
    this.iconScale = 0.52,
    this.active = false,
    this.hex = false,
  });

  @override
  Widget build(BuildContext context) {
    final shapeBorder = hex
        ? _HexBorder(color: color, active: active)
        : CircleBorder(
            side: BorderSide(
              color: color.withOpacity(active ? 0 : 0.4),
              width: 1.4,
            ),
          );

    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
        shape: shapeBorder,
        gradient: active
            ? LinearGradient(
                colors: [color, color.withOpacity(0.55)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: active ? null : color.withOpacity(0.12),
        shadows: active
            ? [
                BoxShadow(
                  color: color.withOpacity(0.55),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ]
            : const [],
      ),
      child: Icon(
        icon,
        color: active ? Colors.white : color,
        size: size * iconScale,
      ),
    );
  }
}

class _HexBorder extends ShapeBorder {
  final Color color;
  final bool active;
  const _HexBorder({required this.color, required this.active});

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  Path _hexPath(Rect rect) {
    final w = rect.width, h = rect.height;
    final path = Path();
    final pts = [
      Offset(w * 0.25, 0),
      Offset(w * 0.75, 0),
      Offset(w, h * 0.5),
      Offset(w * 0.75, h),
      Offset(w * 0.25, h),
      Offset(0, h * 0.5),
    ];
    path.addPolygon(
      pts.map((p) => Offset(rect.left + p.dx, rect.top + p.dy)).toList(),
      true,
    );
    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) => _hexPath(rect);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _hexPath(rect);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (active) return;
    final paint = Paint()
      ..color = color.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawPath(_hexPath(rect), paint);
  }

  @override
  ShapeBorder scale(double t) => this;
}
