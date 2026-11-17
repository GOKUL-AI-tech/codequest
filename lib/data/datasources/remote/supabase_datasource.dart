import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/user_model.dart';
import '../../models/lesson_model.dart';
import '../../models/notification_model.dart';

class SupabaseDatasource {
  final SupabaseClient _client;
  SupabaseDatasource(this._client);

  // ─── PROFILE ──────────────────────────────────────────────────────────────
  Future<UserModel?> getProfile(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (data == null) return null;
    final email =
        _client.auth.currentUser?.email ?? '';
    return UserModel.fromMap(data, email: email);
  }

  Stream<UserModel?> profileStream(String userId) {
    final email = _client.auth.currentUser?.email ?? '';
    return _client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((rows) =>
            rows.isEmpty ? null : UserModel.fromMap(rows.first, email: email));
  }

  Future<void> updateProfile(
      String userId, Map<String, dynamic> data) async {
    await _client.from('profiles').update(data).eq('id', userId);
  }

  Future<UserModel?> getProfileByUsername(String username) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('username', username)
        .maybeSingle();
    if (data == null) return null;
    return UserModel.fromMap(data);
  }

  // ─── XP / COINS ───────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> awardXp({
    required String userId,
    required int xp,
    required int coins,
    required String type,
    String? description,
    String? referenceId,
  }) async {
    final result = await _client.rpc('award_xp', params: {
      'p_user_id': userId,
      'p_xp_amount': xp,
      'p_coins_amount': coins,
      'p_transaction_type': type,
      'p_description': description,
      'p_reference_id': referenceId,
    });
    return Map<String, dynamic>.from(result as Map);
  }

  Future<int> updateStreak(String userId) async {
    final result = await _client
        .rpc('update_streak', params: {'p_user_id': userId});
    return (result as num).toInt();
  }

  // ─── CHAPTERS & LESSONS ───────────────────────────────────────────────────
  Future<List<ChapterModel>> getChapters(String languageId) async {
    final data = await _client
        .from('chapters')
        .select()
        .eq('language_id', languageId)
        .eq('is_active', true)
        .order('order_index');

    // Fetch completed lesson counts per chapter
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return (data as List).map((m) {
        final req = (m['unlock_requirement'] as num?)?.toInt() ?? 0;
        return ChapterModel.fromMap(m, isLocked: req > 0);
      }).toList();
    }

    final progress = await _client
        .from('user_progress')
        .select('lesson_id, lessons!inner(chapter_id)')
        .eq('user_id', userId)
        .eq('is_completed', true);

    // Count completed per chapter
    final Map<String, int> completedMap = {};
    for (final p in progress as List) {
      final chId = (p['lessons'] as Map)['chapter_id'] as String;
      completedMap[chId] = (completedMap[chId] ?? 0) + 1;
    }

    // Build chapters with completion info
    final chapters = (data as List).map((m) => ChapterModel.fromMap(
          m,
          completedLessons: completedMap[m['id']] ?? 0,
          isLocked: false, // compute below
        )).toList();

    // Dynamic lock status:
    // Level 1 (req=0) → always unlocked
    // Level 2 (req=1) → locked unless ALL Level 1 chapters are fully completed
    // Level 3 (req=2) → locked unless ALL Level 2 chapters are also fully completed
    final level1Done = chapters
        .where((c) => c.unlockRequirement == 0)
        .every((c) => c.totalLessons == 0 || c.completedLessons >= c.totalLessons);
    final level2Done = chapters
        .where((c) => c.unlockRequirement == 1)
        .every((c) => c.totalLessons == 0 || c.completedLessons >= c.totalLessons);

    return chapters.map((c) {
      final locked = switch (c.unlockRequirement) {
        1 => !level1Done,
        2 => !level1Done || !level2Done,
        _ => false,
      };
      return ChapterModel(
        id: c.id,
        languageId: c.languageId,
        title: c.title,
        description: c.description,
        order: c.order,
        iconEmoji: c.iconEmoji,
        totalLessons: c.totalLessons,
        completedLessons: c.completedLessons,
        unlockRequirement: c.unlockRequirement,
        isLocked: locked,
      );
    }).toList();
  }

  Future<List<LessonModel>> getLessons(String chapterId) async {
    List<dynamic> data = [];
    try {
      final res = await _client
          .from('lessons')
          .select()
          .eq('chapter_id', chapterId)
          .eq('is_active', true)
          .order('order_index');
      data = res as List;
    } catch (_) {}

    if (data.isEmpty) {
      // In case Supabase doesn't have lessons yet for this chapter,
      // generate fallback lessons so the user can immediately learn and play.
      String chTitle = 'Chapter';
      try {
        final ch = await _client
            .from('chapters')
            .select('title')
            .eq('id', chapterId)
            .maybeSingle();
        if (ch != null && ch['title'] != null) {
          chTitle = ch['title'] as String;
        }
      } catch (_) {}

      return [
        LessonModel.fromMap({
          'id': '${chapterId}_l1',
          'chapter_id': chapterId,
          'title': '$chTitle: Fundamentals',
          'description': 'Master the core syntax and fundamental rules of $chTitle.',
          'type': 'theory',
          'order_index': 1,
          'xp_reward': 50,
          'coin_reward': 10,
          'language_id': 'python',
        }),
        LessonModel.fromMap({
          'id': '${chapterId}_l2',
          'chapter_id': chapterId,
          'title': '$chTitle: Practical Patterns',
          'description': 'Learn real-world best practices, conventions, and idioms in $chTitle.',
          'type': 'theory',
          'order_index': 2,
          'xp_reward': 50,
          'coin_reward': 10,
          'language_id': 'python',
        }),
        LessonModel.fromMap({
          'id': '${chapterId}_l3',
          'chapter_id': chapterId,
          'title': '$chTitle: Knowledge Quiz',
          'description': 'Put your comprehension to the test with an interactive quiz.',
          'type': 'quiz',
          'order_index': 3,
          'xp_reward': 75,
          'coin_reward': 15,
          'language_id': 'python',
        }),
        LessonModel.fromMap({
          'id': '${chapterId}_l4',
          'chapter_id': chapterId,
          'title': '$chTitle: Hands-on Challenge',
          'description': 'Write, run, and verify code to solve the challenge.',
          'type': 'coding',
          'order_index': 4,
          'xp_reward': 100,
          'coin_reward': 25,
          'language_id': 'python',
        }),
      ];
    }

    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      return data.map((m) => LessonModel.fromMap(m)).toList();
    }

    final lessonIds =
        data.map((m) => m['id'] as String).toList();
    final progress = await _client
        .from('user_progress')
        .select('lesson_id, is_completed, score')
        .eq('user_id', userId)
        .inFilter('lesson_id', lessonIds);

    final Map<String, Map<String, dynamic>> progressMap = {
      for (final p in progress as List)
        p['lesson_id'] as String: p as Map<String, dynamic>
    };

    return data.map((m) {
      final p = progressMap[m['id']];
      return LessonModel.fromMap(
        m,
        isCompleted: p?['is_completed'] as bool? ?? false,
        userScore: p?['score'] as int?,
      );
    }).toList();
  }

  Future<LessonModel?> getLesson(String lessonId) async {
    try {
      final data = await _client
          .from('lessons')
          .select()
          .eq('id', lessonId)
          .maybeSingle();
      if (data != null) return LessonModel.fromMap(data);
    } catch (_) {}

    // Fallback for dynamically generated lesson IDs
    if (lessonId.contains('_l')) {
      final parts = lessonId.split('_l');
      final chapterId = parts[0];
      final lessonNum = int.tryParse(parts.length > 1 ? parts[1] : '1') ?? 1;
      final type = switch (lessonNum) {
        3 => 'quiz',
        4 => 'coding',
        _ => 'theory',
      };
      return LessonModel.fromMap({
        'id': lessonId,
        'chapter_id': chapterId,
        'title': 'Lesson $lessonNum',
        'description': 'Comprehensive interactive lesson.',
        'type': type,
        'order_index': lessonNum,
        'xp_reward': 50 * lessonNum,
        'coin_reward': 10 * lessonNum,
        'language_id': 'python',
      });
    }
    return null;
  }

  Future<List<QuizQuestionModel>> getQuizQuestions(
      String lessonId) async {
    final data = await _client
        .from('quiz_questions')
        .select()
        .eq('lesson_id', lessonId)
        .order('order_index');
    return (data as List)
        .map((m) => QuizQuestionModel.fromMap(m))
        .toList();
  }

  Future<CodingChallengeModel?> getCodingChallenge(
      String lessonId) async {
    final data = await _client
        .from('coding_challenges')
        .select()
        .eq('lesson_id', lessonId)
        .eq('is_active', true)
        .maybeSingle();
    if (data == null) return null;
    return CodingChallengeModel.fromMap(data);
  }

  Future<List<CodingChallengeModel>> getArenaChallenges(
      {String? languageId}) async {
    var query = _client
        .from('coding_challenges')
        .select()
        .eq('is_arena_challenge', true)
        .eq('is_active', true);
    if (languageId != null) {
      query = query.eq('language_id', languageId);
    }
    final data = await query.order('difficulty');
    return (data as List)
        .map((m) => CodingChallengeModel.fromMap(m))
        .toList();
  }

  // ─── PROGRESS ─────────────────────────────────────────────────────────────
  Future<void> markLessonComplete({
    required String userId,
    required String lessonId,
    required int xpEarned,
    required int coinsEarned,
    int? score,
    int timeSpentSeconds = 0,
  }) async {
    await _client.from('user_progress').upsert({
      'user_id': userId,
      'lesson_id': lessonId,
      'is_completed': true,
      'xp_earned': xpEarned,
      'coins_earned': coinsEarned,
      'score': score,
      'time_spent_seconds': timeSpentSeconds,
      'completed_at': DateTime.now().toIso8601String(),
    });
    // total_lessons_completed is incremented by a DB trigger on user_progress insert.
  }

  // ─── LEADERBOARD ──────────────────────────────────────────────────────────
  Future<List<LeaderboardEntryModel>> getGlobalLeaderboard(
      {int limit = 50, int offset = 0}) async {
    final data = await _client
        .from('leaderboard_snapshots')
        .select()
        .eq('snapshot_type', 'global')
        .order('xp', ascending: false)
        .range(offset, offset + limit - 1);
    return (data as List)
        .asMap()
        .entries
        .map((e) => LeaderboardEntryModel.fromMap(e.value, e.key + 1 + offset))
        .toList();
  }

  Future<List<LeaderboardEntryModel>> getWeeklyLeaderboard(
      {int limit = 50}) async {
    final data = await _client
        .from('leaderboard_snapshots')
        .select()
        .eq('snapshot_type', 'weekly')
        .order('week_xp', ascending: false)
        .limit(limit);
    return (data as List)
        .asMap()
        .entries
        .map((e) => LeaderboardEntryModel.fromMap(e.value, e.key + 1))
        .toList();
  }

  Future<List<LeaderboardEntryModel>> getFriendsLeaderboard(
      String userId) async {
    final friends = await _client
        .from('friendships')
        .select('requester_id, addressee_id')
        .or('requester_id.eq.$userId,addressee_id.eq.$userId')
        .eq('is_accepted', true);

    final friendIds = (friends as List)
        .map((f) => f['requester_id'] == userId
            ? f['addressee_id'] as String
            : f['requester_id'] as String)
        .toList()
      ..add(userId);

    final data = await _client
        .from('leaderboard_snapshots')
        .select()
        .eq('snapshot_type', 'global')
        .inFilter('user_id', friendIds)
        .order('xp', ascending: false);

    return (data as List)
        .asMap()
        .entries
        .map((e) => LeaderboardEntryModel.fromMap(e.value, e.key + 1))
        .toList();
  }

  // ─── NOTIFICATIONS ────────────────────────────────────────────────────────
  Future<List<NotificationModel>> getNotifications(String userId,
      {int limit = 30}) async {
    final data = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    return (data as List)
        .map((m) => NotificationModel.fromMap(m))
        .toList();
  }

  Stream<List<NotificationModel>> notificationsStream(String userId) {
    return _client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(20)
        .map((rows) =>
            rows.map((m) => NotificationModel.fromMap(m)).toList());
  }

  Future<void> markNotificationRead(String notificationId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('id', notificationId);
  }

  Future<void> markAllNotificationsRead(String userId) async {
    await _client
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId)
        .eq('is_read', false);
  }

  // ─── CHAT ─────────────────────────────────────────────────────────────────
  Stream<List<ChatMessageModel>> chatStream(String roomId) {
    return _client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('room_id', roomId)
        .order('created_at')
        .limit(100)
        .asyncMap((rows) async {
          // Enrich with sender profile
          final enriched = await Future.wait(rows.map((r) async {
            final sender = await _client
                .from('profiles')
                .select('username, avatar_url')
                .eq('id', r['sender_id'])
                .maybeSingle();
            return {...r, 'sender': sender ?? {}};
          }));
          return enriched.map((m) => ChatMessageModel.fromMap(m)).toList();
        });
  }

  Future<void> sendMessage({
    required String roomId,
    required String senderId,
    required String content,
    String messageType = 'text',
  }) async {
    await _client.from('chat_messages').insert({
      'room_id': roomId,
      'sender_id': senderId,
      'content': content,
      'message_type': messageType,
    });
  }

  Future<String> getOrCreateDmRoom(
      String userId, String otherUserId) async {
    // Check existing DM room
    final existing = await _client
        .from('chat_participants')
        .select('room_id')
        .eq('user_id', userId);

    final myRoomIds =
        (existing as List).map((r) => r['room_id'] as String).toList();

    if (myRoomIds.isNotEmpty) {
      final shared = await _client
          .from('chat_participants')
          .select('room_id')
          .eq('user_id', otherUserId)
          .inFilter('room_id', myRoomIds);
      if ((shared as List).isNotEmpty) {
        return shared.first['room_id'] as String;
      }
    }

    // Create new DM room
    final room = await _client
        .from('chat_rooms')
        .insert({'is_direct_message': true})
        .select()
        .single();
    final roomId = room['id'] as String;
    await _client.from('chat_participants').insert([
      {'room_id': roomId, 'user_id': userId},
      {'room_id': roomId, 'user_id': otherUserId},
    ]);
    return roomId;
  }

  // ─── FRIENDS ──────────────────────────────────────────────────────────────
  Future<List<UserModel>> getFriends(String userId) async {
    final data = await _client
        .from('friendships')
        .select('requester_id, addressee_id')
        .or('requester_id.eq.$userId,addressee_id.eq.$userId')
        .eq('is_accepted', true);

    final friendIds = (data as List).map((f) {
      return f['requester_id'] == userId
          ? f['addressee_id'] as String
          : f['requester_id'] as String;
    }).toList();

    if (friendIds.isEmpty) return [];

    final profiles = await _client
        .from('profiles')
        .select()
        .inFilter('id', friendIds);
    return (profiles as List).map((m) => UserModel.fromMap(m)).toList();
  }

  Future<void> sendFriendRequest(
      String requesterId, String addresseeId) async {
    await _client.from('friendships').insert({
      'requester_id': requesterId,
      'addressee_id': addresseeId,
    });
  }

  Future<void> acceptFriendRequest(String requesterId,
      String addresseeId) async {
    await _client
        .from('friendships')
        .update({'is_accepted': true, 'accepted_at': DateTime.now().toIso8601String()})
        .eq('requester_id', requesterId)
        .eq('addressee_id', addresseeId);
  }

  // ─── GUILDS ───────────────────────────────────────────────────────────────
  Future<List<GuildModel>> getPublicGuilds({int limit = 20}) async {
    final data = await _client
        .from('guilds')
        .select()
        .eq('is_public', true)
        .order('total_xp', ascending: false)
        .limit(limit);
    return (data as List).map((m) => GuildModel.fromMap(m)).toList();
  }

  Future<GuildModel?> getUserGuild(String userId) async {
    final member = await _client
        .from('guild_members')
        .select('guild_id')
        .eq('user_id', userId)
        .maybeSingle();
    if (member == null) return null;
    final guild = await _client
        .from('guilds')
        .select()
        .eq('id', member['guild_id'])
        .maybeSingle();
    if (guild == null) return null;
    return GuildModel.fromMap(guild);
  }

  Future<void> joinGuild(String userId, String guildId) async {
    await _client.from('guild_members').insert({
      'guild_id': guildId,
      'user_id': userId,
    });
  }

  Future<GuildModel> createGuild({
    required String leaderId,
    required String name,
    required String description,
    required String emblemEmoji,
  }) async {
    final data = await _client
        .from('guilds')
        .insert({
          'leader_id': leaderId,
          'name': name,
          'description': description,
          'emblem_emoji': emblemEmoji,
        })
        .select()
        .single();
    await _client.from('guild_members').insert({
      'guild_id': data['id'],
      'user_id': leaderId,
      'role': 'leader',
    });
    return GuildModel.fromMap(data);
  }

  // ─── BATTLES ──────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> createBattle({
    required String userId,
    required String challengeId,
  }) async {
    final battle = await _client
        .from('coding_battles')
        .insert({
          'challenge_id': challengeId,
          'created_by': userId,
          'status': 'waiting',
        })
        .select()
        .single();

    await _client.from('battle_participants').insert({
      'battle_id': battle['id'],
      'user_id': userId,
    });

    return battle as Map<String, dynamic>;
  }

  Future<void> joinBattle(String battleId, String userId) async {
    await _client.from('battle_participants').insert({
      'battle_id': battleId,
      'user_id': userId,
    });
    await _client
        .from('coding_battles')
        .update({'status': 'in_progress', 'started_at': DateTime.now().toIso8601String()})
        .eq('id', battleId);
  }

  Stream<Map<String, dynamic>> battleStream(String battleId) {
    return _client
        .from('coding_battles')
        .stream(primaryKey: ['id'])
        .eq('id', battleId)
        .map((rows) =>
            rows.isEmpty ? {} : rows.first as Map<String, dynamic>);
  }

  Future<void> submitBattleSolution({
    required String battleId,
    required String userId,
    required String code,
    required int score,
    required int testsPassed,
  }) async {
    await _client
        .from('battle_participants')
        .update({
          'submission_code': code,
          'submission_time': DateTime.now().toIso8601String(),
          'score': score,
          'tests_passed': testsPassed,
        })
        .eq('battle_id', battleId)
        .eq('user_id', userId);
  }

  // ─── AI MENTOR ────────────────────────────────────────────────────────────
  Future<String> createConversation(
      String userId, String? languageId) async {
    final data = await _client
        .from('ai_conversations')
        .insert({
          'user_id': userId,
          'language_id': languageId,
        })
        .select()
        .single();
    return data['id'] as String;
  }

  Future<void> saveAiMessage({
    required String conversationId,
    required String role,
    required String content,
    int tokensUsed = 0,
  }) async {
    await _client.from('ai_messages').insert({
      'conversation_id': conversationId,
      'role': role,
      'content': content,
      'tokens_used': tokensUsed,
    });
  }

  Future<List<Map<String, dynamic>>> getConversationHistory(
      String conversationId) async {
    final data = await _client
        .from('ai_messages')
        .select('role, content')
        .eq('conversation_id', conversationId)
        .order('created_at')
        .limit(20);
    return (data as List).cast<Map<String, dynamic>>();
  }

  // ─── CHAT ROOMS LIST ──────────────────────────────────────────────────────

  /// Returns the user's chat rooms with last-message preview and other user info.
  Future<List<Map<String, dynamic>>> getUserChatRooms(String userId) async {
    // Get room IDs this user participates in
    final participantData = await _client
        .from('chat_participants')
        .select('room_id')
        .eq('user_id', userId);

    final roomIds = (participantData as List)
        .map((r) => r['room_id'] as String)
        .toList();

    if (roomIds.isEmpty) return [];

    // For each room, get the other participant's profile and last message
    final results = <Map<String, dynamic>>[];

    for (final roomId in roomIds) {
      // Other participant
      final others = await _client
          .from('chat_participants')
          .select('user_id, profiles(username, avatar_url)')
          .eq('room_id', roomId)
          .neq('user_id', userId)
          .limit(1);

      if ((others as List).isEmpty) continue;
      final otherProfile = others.first['profiles'] as Map<String, dynamic>?;

      // Last message
      final lastMsgData = await _client
          .from('chat_messages')
          .select('content, created_at')
          .eq('room_id', roomId)
          .order('created_at', ascending: false)
          .limit(1);

      final lastMsg = (lastMsgData as List).isNotEmpty
          ? lastMsgData.first
          : null;

      // Unread count
      final unreadData = await _client
          .from('chat_messages')
          .select('id')
          .eq('room_id', roomId)
          .neq('sender_id', userId)
          .eq('is_read', false);

      results.add({
        'id': roomId,
        'other_username': otherProfile?['username'] ?? 'User',
        'other_avatar': otherProfile?['avatar_url'],
        'last_message': lastMsg?['content'] ?? '',
        'last_message_at': lastMsg?['created_at'],
        'unread_count': (unreadData as List).length,
        'is_online': false, // implement with presence in production
      });
    }

    // Sort by last message time descending
    results.sort((a, b) {
      final aTime = a['last_message_at'] as String?;
      final bTime = b['last_message_at'] as String?;
      if (aTime == null && bTime == null) return 0;
      if (aTime == null) return 1;
      if (bTime == null) return -1;
      return bTime.compareTo(aTime);
    });

    return results;
  }
}
