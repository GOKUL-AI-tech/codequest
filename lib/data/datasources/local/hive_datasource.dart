import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

class HiveDatasource {
  static const String _profileBox = 'profile_cache';
  static const String _progressBox = 'progress_cache';
  static const String _settingsBox = 'settings';
  static const String _offlineBox = 'offline_queue';

  // ─── INIT ─────────────────────────────────────────────────────────────────
  static Future<void> init() async {
    await Hive.openBox(_profileBox);
    await Hive.openBox(_progressBox);
    await Hive.openBox(_settingsBox);
    await Hive.openBox(_offlineBox);
  }

  // ─── PROFILE ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getCachedProfile(String userId) async {
    final box = Hive.box(_profileBox);
    final raw = box.get(userId);
    if (raw == null) return null;
    return Map<String, dynamic>.from(json.decode(raw as String) as Map);
  }

  Future<void> cacheProfile(
      String userId, Map<String, dynamic> data) async {
    final box = Hive.box(_profileBox);
    await box.put(userId, json.encode(data));
  }

  Future<void> clearProfile(String userId) async {
    final box = Hive.box(_profileBox);
    await box.delete(userId);
  }

  // ─── PROGRESS ─────────────────────────────────────────────────────────────
  Future<void> saveProgress(
      String lessonId, Map<String, dynamic> progress) async {
    final box = Hive.box(_progressBox);
    await box.put(lessonId, json.encode(progress));
  }

  Future<Map<String, dynamic>?> getProgress(String lessonId) async {
    final box = Hive.box(_progressBox);
    final raw = box.get(lessonId);
    if (raw == null) return null;
    return Map<String, dynamic>.from(json.decode(raw as String) as Map);
  }

  Future<void> clearAllProgress() async {
    final box = Hive.box(_progressBox);
    await box.clear();
  }

  // ─── SETTINGS ─────────────────────────────────────────────────────────────
  T? getSetting<T>(String key) {
    final box = Hive.box(_settingsBox);
    return box.get(key) as T?;
  }

  Future<void> setSetting<T>(String key, T value) async {
    final box = Hive.box(_settingsBox);
    await box.put(key, value);
  }

  bool getOnboardingDone() =>
      getSetting<bool>('onboarding_done') ?? false;
  Future<void> setOnboardingDone() =>
      setSetting('onboarding_done', true);

  String? getSelectedCharacter() =>
      getSetting<String>('selected_character');
  Future<void> setSelectedCharacter(String id) =>
      setSetting('selected_character', id);

  String? getLastStreakDate() =>
      getSetting<String>('last_streak_date');
  Future<void> setLastStreakDate(String date) =>
      setSetting('last_streak_date', date);

  bool getSoundEnabled() => getSetting<bool>('sound_enabled') ?? true;
  Future<void> setSoundEnabled(bool v) => setSetting('sound_enabled', v);

  bool getHapticsEnabled() =>
      getSetting<bool>('haptics_enabled') ?? true;
  Future<void> setHapticsEnabled(bool v) =>
      setSetting('haptics_enabled', v);

  // ─── OFFLINE QUEUE ────────────────────────────────────────────────────────
  Future<void> queueOfflineAction(Map<String, dynamic> action) async {
    final box = Hive.box(_offlineBox);
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await box.put(key, json.encode(action));
  }

  List<Map<String, dynamic>> getOfflineQueue() {
    final box = Hive.box(_offlineBox);
    return box.values
        .map((v) =>
            Map<String, dynamic>.from(json.decode(v as String) as Map))
        .toList();
  }

  Future<void> clearOfflineQueue() async {
    final box = Hive.box(_offlineBox);
    await box.clear();
  }
}
