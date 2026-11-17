import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

final currentUserProfileProvider = FutureProvider<UserEntity?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final client = ref.read(supabaseClientProvider);
  final rows = await client
      .from('profiles')
      .select()
      .eq('id', user.id)
      .limit(1);

  final list = rows as List;
  // If no profile row exists yet (e.g. OAuth user), create a default one
  if (list.isEmpty) {
    final username = user.userMetadata?['username'] as String? ??
        user.email?.split('@').first ?? 'player';
    await client.from('profiles').upsert({
      'id': user.id,
      'username': username,
      'character_id': 'cyber_ninja',
      'level': 1,
      'xp': 0,
      'coins': 100,
      'streak': 0,
      'lives': 5,
      'rank_title': 'Script Kiddie',
      'favorite_language': 'python',
      'subscription_tier': 'free',
      'total_lessons_completed': 0,
      'total_challenges_completed': 0,
      'created_at': DateTime.now().toIso8601String(),
    });
    final retry = await client.from('profiles').select().eq('id', user.id).limit(1);
    final retryList = retry as List;
    if (retryList.isEmpty) return null;
    return _profileFromMap(retryList.first as Map<String, dynamic>);
  }
  return _profileFromMap(list.first as Map<String, dynamic>);
});

UserEntity _profileFromMap(Map<String, dynamic> map) {
  return UserEntity(
    id: map['id'],
    email: '',
    username: map['username'] ?? '',
    avatarUrl: map['avatar_url'],
    characterId: map['character_id'] ?? 'cyber_ninja',
    level: map['level'] ?? 1,
    xp: map['xp'] ?? 0,
    coins: map['coins'] ?? 0,
    streak: map['streak'] ?? 0,
    lives: map['lives'] ?? 5,
    rank: map['rank_title'] ?? 'Script Kiddie',
    favoriteLanguage: map['favorite_language'] ?? 'python',
    totalChallengesCompleted: map['total_challenges_completed'] ?? 0,
    totalLessonsCompleted: map['total_lessons_completed'] ?? 0,
    isPremium: map['subscription_tier'] != 'free',
    createdAt: DateTime.parse(map['created_at'] ?? DateTime.now().toIso8601String()),
  );
}

final updateProfileProvider = Provider<Future<void> Function(Map<String, dynamic>)>((ref) {
  final client = ref.read(supabaseClientProvider);
  final user = ref.read(currentUserProvider);
  return (data) async {
    if (user == null) return;
    await client.from('profiles').update(data).eq('id', user.id);
  };
});
