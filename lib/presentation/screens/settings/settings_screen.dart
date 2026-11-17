import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/game_icon_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/app_providers.dart';
import '../../providers/locale_provider.dart';
import '../../../core/router/app_router.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLang = ref.watch(localeProvider).languageCode;
    final langName = languageDisplayNames[currentLang] ?? 'English';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings.toUpperCase())),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SettingsSection(title: l10n.account.toUpperCase(), children: [
            _SettingsTile(icon: Icons.person_outline, title: l10n.editProfile, onTap: () {}),
            _SettingsTile(icon: Icons.lock_outline, title: l10n.changePassword, onTap: () {}),
            _SettingsTile(icon: Icons.email_outlined, title: 'Email Preferences', onTap: () {}),
          ]),
          _SettingsSection(title: l10n.notifications.toUpperCase(), children: [
            _SettingsTile(
              icon: Icons.notifications_active_outlined,
              title: l10n.notificationSettings,
              color: AppColors.neonCyan,
              onTap: () => context.push(AppRoutes.notificationSettings),
            ),
          ]),
          _SettingsSection(title: l10n.appearance.toUpperCase(), children: [
            Consumer(builder: (context, ref, _) {
              final isDark = ref.watch(themeProvider) == ThemeMode.dark;
              return _SettingsTile(
                icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
                title: isDark ? l10n.darkMode : l10n.lightMode,
                color: isDark ? AppColors.neonPurple : AppColors.neonYellow,
                trailing: Switch(
                  value: isDark,
                  onChanged: (_) => ref.read(themeProvider.notifier).toggle(),
                  activeColor: AppColors.neonCyan,
                ),
              );
            }),
            _SettingsTile(
              icon: Icons.translate_outlined,
              title: l10n.language,
              sublabel: langName,
              color: AppColors.neonGreen,
              onTap: () => context.push(AppRoutes.languagePicker),
            ),
          ]),
          _SettingsSection(title: 'GAME', children: [
            _SettingsTile(icon: Icons.volume_up_outlined, title: l10n.soundEffects, trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppColors.neonCyan)),
            _SettingsTile(icon: Icons.vibration, title: l10n.hapticFeedback, trailing: Switch(value: true, onChanged: (_) {}, activeColor: AppColors.neonCyan)),
          ]),
          _SettingsSection(title: l10n.subscription.toUpperCase(), children: [
            _SettingsTile(icon: Icons.star_outline, title: l10n.goPremium, onTap: () => context.push(AppRoutes.premium), color: AppColors.neonYellow),
          ]),
          _SettingsSection(title: l10n.support.toUpperCase(), children: [
            _SettingsTile(icon: Icons.help_outline, title: l10n.helpFaq, onTap: () => context.push(AppRoutes.faq)),
            _SettingsTile(icon: Icons.bug_report_outlined, title: l10n.reportBug, onTap: () => context.push(AppRoutes.reportBug)),
            _SettingsTile(icon: Icons.privacy_tip_outlined, title: l10n.privacyPolicy, onTap: () => context.push(AppRoutes.privacyPolicy)),
          ]),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              await ref.read(authProvider.notifier).signOut();
              if (context.mounted) context.go(AppRoutes.login);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: AppColors.error.withOpacity(0.1), border: Border.all(color: AppColors.error.withOpacity(0.3))),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.logout, color: AppColors.error, size: 20),
                const SizedBox(width: 8),
                Text(l10n.signOut.toUpperCase(), style: const TextStyle(fontFamily: 'Orbitron', fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.error, letterSpacing: 1.5)),
              ]),
            ),
          ),
          SizedBox(height: 40),
          Center(child: Text('CodeQuest v1.0.0', style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 12, color: context.cqTextMuted))),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 24),
        Text(title, style: TextStyle(fontFamily: 'Share Tech Mono', fontSize: 11, color: context.cqTextMuted, letterSpacing: 2)),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: context.cqCard, border: Border.all(color: context.cqSurface)),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? sublabel;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Color? color;

  const _SettingsTile({required this.icon, required this.title, this.sublabel, this.onTap, this.trailing, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? context.cqTextSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            GameIconBadge(icon: icon, color: c, size: 34),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 15, fontWeight: FontWeight.w600, color: color != null ? c : context.cqTextPrimary)),
                  if (sublabel != null)
                    Text(sublabel!, style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12, color: context.cqTextMuted)),
                ],
              ),
            ),
            trailing ?? (onTap != null ? Icon(Icons.arrow_forward_ios, color: context.cqTextMuted, size: 14) : const SizedBox()),
          ],
        ),
      ),
    );
  }
}
