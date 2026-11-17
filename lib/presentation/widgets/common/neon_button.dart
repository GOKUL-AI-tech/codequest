import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class NeonButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isLoading;
  final LinearGradient? gradient;
  final Color? glowColor;
  final double height;
  final IconData? icon;

  const NeonButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isLoading = false,
    this.gradient,
    this.glowColor,
    this.height = 56,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final grad = gradient ?? AppColors.cyberpunkGradient;
    final glow = glowColor ?? AppColors.neonCyan;

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: isLoading ? null : grad,
          color: isLoading ? context.cqCardSecondary : null,
          boxShadow: isLoading
              ? []
              : [
                  BoxShadow(
                    color: glow.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation(AppColors.neonCyan),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: AppColors.bgDark, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.bgDark,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class NeonOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color? color;
  final double height;
  final IconData? icon;

  const NeonOutlinedButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color,
    this.height = 52,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.neonCyan;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: c, width: 1.5),
          color: c.withOpacity(0.05),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: c, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: c,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
