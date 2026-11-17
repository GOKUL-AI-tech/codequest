import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/app_localizations.dart';
import '../../providers/locale_provider.dart';

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  static const _languages = [
    ('en', 'English',   'English',    '🇬🇧'),
    ('hi', 'हिन्दी',      'Hindi',      '🇮🇳'),
    ('ta', 'தமிழ்',      'Tamil',      '🇮🇳'),
    ('es', 'Español',   'Spanish',    '🇪🇸'),
    ('fr', 'Français',  'French',     '🇫🇷'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.neonCyan),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.language.toUpperCase()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Info banner
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.neonCyan.withOpacity(0.07),
              border: Border.all(color: AppColors.neonCyan.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.translate, color: AppColors.neonCyan, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Choose your preferred language. The app interface will update immediately.',
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 13,
                      color: context.cqTextSecondary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(),

          // Language options
          ..._languages.asMap().entries.map((e) {
            final (code, nativeName, englishName, flag) = e.value;
            final isSelected = currentLocale.languageCode == code;

            return GestureDetector(
              onTap: () async {
                await ref.read(localeProvider.notifier)
                    .setLocale(Locale(code));
                if (context.mounted) Navigator.of(context).pop();
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: isSelected
                      ? AppColors.neonCyan.withOpacity(0.08)
                      : context.cqCard,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.neonCyan
                        : context.cqSurface,
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    // Flag
                    Text(flag, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 16),

                    // Names
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nativeName,
                            style: TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? AppColors.neonCyan
                                  : context.cqTextPrimary,
                            ),
                          ),
                          Text(
                            englishName,
                            style: TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 13,
                              color: context.cqTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Selected indicator
                    if (isSelected)
                      const Icon(Icons.check_circle,
                          color: AppColors.neonCyan, size: 22)
                    else
                      Icon(Icons.radio_button_unchecked,
                          color: context.cqTextMuted, size: 22),
                  ],
                ),
              ),
            ).animate(delay: Duration(milliseconds: e.key * 60)).fadeIn().slideX(begin: 0.05);
          }),

          SizedBox(height: 20),

          // Translation note
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: context.cqCard,
              border: Border.all(color: context.cqSurface),
            ),
            child: Text(
              '💡 Lesson content and code snippets remain in English as programming is universal. Only the app interface is translated.',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13,
                color: context.cqTextMuted,
                height: 1.6,
              ),
            ),
          ).animate(delay: 350.ms).fadeIn(),
        ],
      ),
    );
  }
}
