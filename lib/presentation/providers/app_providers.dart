import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_constants.dart';
import '../../data/datasources/remote/supabase_datasource.dart';
import '../../data/datasources/local/hive_datasource.dart';
import '../../data/repositories/user_repository.dart';

// Re-export repository types from user_repository.dart so providers below compile.
export '../../data/repositories/user_repository.dart'
    show LessonRepository, LeaderboardRepository;

// ─── CORE PROVIDERS ───────────────────────────────────────────────────────────

final supabaseClientProvider = Provider<SupabaseClient>((_) {
  return Supabase.instance.client;
});

final supabaseDatasourceProvider = Provider<SupabaseDatasource>((ref) {
  return SupabaseDatasource(ref.read(supabaseClientProvider));
});

final hiveDatasourceProvider = Provider<HiveDatasource>((_) {
  return HiveDatasource();
});

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(
    ref.read(supabaseDatasourceProvider),
    ref.read(hiveDatasourceProvider),
  );
});

final lessonRepositoryProvider = Provider<LessonRepository>((ref) {
  return LessonRepository(ref.read(supabaseDatasourceProvider));
});

final leaderboardRepositoryProvider =
    Provider<LeaderboardRepository>((ref) {
  return LeaderboardRepository(ref.read(supabaseDatasourceProvider));
});

// ─── THEME ───────────────────────────────────────────────────────────────────

class ThemeNotifier extends Notifier<ThemeMode> {
  static const _key = 'theme_mode';

  @override
  ThemeMode build() {
    _load();
    return ThemeMode.dark; // default until loaded
  }

  Future<void> _load() async {
    final hive = HiveDatasource();
    final saved = hive.getSetting<String>(_key);
    if (saved == 'light') state = ThemeMode.light;
    if (saved == 'dark') state = ThemeMode.dark;
  }

  Future<void> toggle() async {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = next;
    final hive = HiveDatasource();
    await hive.setSetting(_key, next == ThemeMode.light ? 'light' : 'dark');
  }

  bool get isDark => state == ThemeMode.dark;
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  () => ThemeNotifier(),
);

// ─── SPECIALTY ────────────────────────────────────────────────────────────────
// Maps the selected character's specialty name → language ID used throughout
// the app (e.g. 'Python' → 'python', 'C++' → 'cpp').
// Returns null when no character has been chosen yet.

const _specialtyNameToId = <String, String>{
  'Python': 'python',
  'JavaScript': 'javascript',
  'Dart': 'dart',
  'Java': 'java',
  'C++': 'cpp',
  'C': 'c',
};

/// The language ID for the current user's selected character specialty.
/// e.g. 'python', 'cpp', 'javascript' … or null if not set yet.
final specialtyLanguageProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  final charId = prefs.getString(AppConstants.kSelectedCharacter);
  if (charId == null) return null;

  final chars = AppConstants.characters;
  final match = chars.cast<Map<String, String>?>().firstWhere(
        (c) => c!['id'] == charId,
        orElse: () => null,
      );
  if (match == null) return null;

  final specialty = match['specialty'];
  return specialty != null ? _specialtyNameToId[specialty] : null;
});
