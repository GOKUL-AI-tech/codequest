import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/achievement_entity.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

final dailyMissionsProvider = FutureProvider<List<DailyMission>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return <DailyMission>[];

  final client = ref.read(supabaseClientProvider);
  final today = DateTime.now();
  final tomorrow = DateTime(today.year, today.month, today.day + 1);

  final response = await client
      .from('user_daily_missions')
      .select('*, mission:daily_missions(*)')
      .eq('user_id', user.id)
      .gte('expires_at', today.toIso8601String())
      .lt('expires_at', tomorrow.toIso8601String());

  final list = response as List;
  if (list.isEmpty) {
    // Assign daily missions for today then re-fetch
    await _assignDailyMissions(client, user.id, tomorrow);
    final retry = await client
        .from('user_daily_missions')
        .select('*, mission:daily_missions(*)')
        .eq('user_id', user.id)
        .gte('expires_at', today.toIso8601String())
        .lt('expires_at', tomorrow.toIso8601String());
    return _mapMissions(retry as List);
  }

  return _mapMissions(list);
});

List<DailyMission> _mapMissions(List data) {
  return data.map((m) => DailyMission(
    id: m['id'] as String,
    title: m['mission']['title'] as String,
    description: m['mission']['description'] as String,
    iconEmoji: m['mission']['icon_emoji'] as String,
    xpReward: (m['mission']['xp_reward'] as num).toInt(),
    coinReward: (m['mission']['coin_reward'] as num).toInt(),
    requiredCount: (m['mission']['required_count'] as num).toInt(),
    currentCount: (m['current_count'] as num).toInt(),
    isCompleted: m['is_completed'] as bool,
    expiresAt: DateTime.parse(m['expires_at'] as String),
  )).toList();
}

Future<void> _assignDailyMissions(
  SupabaseClient client,
  String userId,
  DateTime expires,
) async {
  final missions = await client
      .from('daily_missions')
      .select()
      .eq('is_active', true)
      .limit(3);

  for (final m in missions as List) {
    await client.from('user_daily_missions').upsert({
      'user_id': userId,
      'mission_id': m['id'],
      'current_count': 0,
      'is_completed': false,
      'expires_at': expires.toIso8601String(),
    });
  }
}

final achievementsProvider = FutureProvider<List<AchievementEntity>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return <AchievementEntity>[];

  final client = ref.read(supabaseClientProvider);
  final response = await client
      .from('user_achievements')
      .select('*, achievement:achievements(*)')
      .eq('user_id', user.id);

  return (response as List).map((a) => AchievementEntity(
    id: a['achievement_id'] as String,
    title: a['achievement']['title'] as String,
    description: a['achievement']['description'] as String,
    iconEmoji: a['achievement']['icon_emoji'] as String,
    category: AchievementCategory.values.firstWhere(
      (c) => c.name == a['achievement']['category'],
      orElse: () => AchievementCategory.special,
    ),
    xpReward: (a['achievement']['xp_reward'] as num).toInt(),
    coinReward: (a['achievement']['coin_reward'] as num).toInt(),
    isUnlocked: true,
    unlockedAt: a['unlocked_at'] != null ? DateTime.parse(a['unlocked_at']) : null,
    progress: 1.0,
    requiredCount: (a['achievement']['required_count'] as num? ?? 1).toInt(),
    currentCount: (a['achievement']['required_count'] as num? ?? 1).toInt(),
    isRare: a['achievement']['is_rare'] as bool? ?? false,
  )).toList();
});
