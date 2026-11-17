import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/local/hive_datasource.dart';
import '../../l10n/app_localizations.dart';

class LocaleNotifier extends Notifier<Locale> {
  static const _key = 'app_locale';

  @override
  Locale build() {
    _load();
    return const Locale('en');
  }

  Future<void> _load() async {
    final hive = HiveDatasource();
    final saved = hive.getSetting<String>(_key);
    if (saved != null) {
      final locale = Locale(saved);
      if (AppLocalizations.supportedLocales.contains(locale)) {
        state = locale;
      }
    }
  }

  Future<void> setLocale(Locale locale) async {
    state = locale;
    final hive = HiveDatasource();
    await hive.setSetting(_key, locale.languageCode);
  }

  String get currentLanguageName => _languageNames[state.languageCode] ?? 'English';
}

const _languageNames = {
  'en': 'English',
  'hi': 'हिन्दी',
  'ta': 'தமிழ்',
  'es': 'Español',
  'fr': 'Français',
};

const languageDisplayNames = _languageNames;

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(
  () => LocaleNotifier(),
);
