import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class CyberSnackbar {
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, AppColors.neonGreen, Icons.check_circle_outline);
  }

  static void showError(BuildContext context, String message) {
    _show(context, message, AppColors.error, Icons.error_outline);
  }

  static void showInfo(BuildContext context, String message) {
    _show(context, message, AppColors.neonCyan, Icons.info_outline);
  }

  static void showXpGained(BuildContext context, int xp, {int? coins}) {
    final msg = coins != null ? '+$xp XP  +$coins Coins' : '+$xp XP';
    _show(context, msg, AppColors.neonYellow, Icons.star_outline);
  }

  static void _show(BuildContext context, String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: context.cqTextPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: context.cqCard,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3), width: 1),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
