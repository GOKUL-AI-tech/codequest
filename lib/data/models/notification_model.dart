class NotificationModel {
  final String id;
  final String userId;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic> metadata;
  final bool isRead;
  final DateTime createdAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.body,
    required this.metadata,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      type: map['type'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      metadata: (map['metadata'] as Map<String, dynamic>?) ?? {},
      isRead: map['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }

  String get iconEmoji {
    return switch (type) {
      'streak' => '🔥',
      'achievement' => '🏆',
      'friend_request' => '🤝',
      'battle_invite' => '⚔️',
      'tournament' => '🏅',
      'xp_reward' => '⭐',
      'daily_mission' => '🎯',
      'announcement' => '📢',
      _ => '🔔',
    };
  }
}

class ChatMessageModel {
  final String id;
  final String roomId;
  final String senderId;
  final String senderUsername;
  final String? senderAvatar;
  final String content;
  final String messageType;
  final bool isDeleted;
  final DateTime createdAt;

  const ChatMessageModel({
    required this.id,
    required this.roomId,
    required this.senderId,
    required this.senderUsername,
    this.senderAvatar,
    required this.content,
    required this.messageType,
    required this.isDeleted,
    required this.createdAt,
  });

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    final sender = map['sender'] as Map<String, dynamic>? ?? {};
    return ChatMessageModel(
      id: map['id'] as String,
      roomId: map['room_id'] as String,
      senderId: map['sender_id'] as String,
      senderUsername: sender['username'] as String? ?? 'Unknown',
      senderAvatar: sender['avatar_url'] as String?,
      content: map['content'] as String,
      messageType: map['message_type'] as String? ?? 'text',
      isDeleted: map['is_deleted'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

class GuildModel {
  final String id;
  final String name;
  final String? description;
  final String emblemEmoji;
  final String? tag;
  final String leaderId;
  final int maxMembers;
  final int memberCount;
  final int totalXp;
  final bool isPublic;
  final bool isMember;
  final DateTime createdAt;

  const GuildModel({
    required this.id,
    required this.name,
    this.description,
    required this.emblemEmoji,
    this.tag,
    required this.leaderId,
    required this.maxMembers,
    required this.memberCount,
    required this.totalXp,
    required this.isPublic,
    this.isMember = false,
    required this.createdAt,
  });

  /// Alias for emblemEmoji — used by UI widgets
  String? get emblem => emblemEmoji;

  factory GuildModel.fromMap(Map<String, dynamic> map) {
    return GuildModel(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String?,
      emblemEmoji: map['emblem_emoji'] as String? ?? '🏰',
      tag: map['tag'] as String?,
      leaderId: map['leader_id'] as String,
      maxMembers: (map['max_members'] as num?)?.toInt() ?? 50,
      memberCount: (map['member_count'] as num?)?.toInt() ?? 0,
      totalXp: (map['total_xp'] as num?)?.toInt() ?? 0,
      isPublic: map['is_public'] as bool? ?? true,
      isMember: map['is_member'] as bool? ?? false,
      createdAt: DateTime.parse(map['created_at'] as String),
    );
  }
}

class LeaderboardEntryModel {
  final int rank;
  final String userId;
  final String username;
  final String? avatarUrl;
  final String characterId;
  final int xp;
  final int level;
  final String rankTitle;
  final int streak;
  final int weekXp;

  const LeaderboardEntryModel({
    required this.rank,
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.characterId,
    required this.xp,
    required this.level,
    required this.rankTitle,
    required this.streak,
    required this.weekXp,
  });

  factory LeaderboardEntryModel.fromMap(Map<String, dynamic> map, int rank) {
    return LeaderboardEntryModel(
      rank: (map['rank_position'] as num?)?.toInt() ?? rank,
      userId: map['user_id'] as String,
      username: map['username'] as String,
      avatarUrl: map['avatar_url'] as String?,
      characterId: map['character_id'] as String? ?? 'cyber_ninja',
      xp: (map['xp'] as num?)?.toInt() ?? 0,
      level: (map['level'] as num?)?.toInt() ?? 1,
      rankTitle: map['rank_title'] as String? ?? 'Script Kiddie',
      streak: (map['streak'] as num?)?.toInt() ?? 0,
      weekXp: (map['week_xp'] as num?)?.toInt() ?? 0,
    );
  }
}
