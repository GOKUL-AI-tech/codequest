import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/theme/app_theme.dart';
import '../../providers/app_providers.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/loading_skeleton.dart';

// ─── PROVIDER ─────────────────────────────────────────────────────────────────

final chatRoomsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return [];
  final ds = ref.read(supabaseDatasourceProvider);
  return ds.getUserChatRooms(userId);
});

// ─── SCREEN ───────────────────────────────────────────────────────────────────

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(chatRoomsProvider);

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.cyberpunkGradient.createShader(bounds),
          child: const Text(
            'MESSAGES',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add_alt_1, color: AppColors.neonCyan),
            onPressed: () => _showNewChatDialog(context, ref),
          ),
        ],
      ),
      body: roomsAsync.when(
        loading: () => ListView.builder(
          itemCount: 8,
          itemBuilder: (_, __) => const SkeletonListTile(),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('😵', style: TextStyle(fontSize: 48)),
              SizedBox(height: 12),
              Text(
                'Could not load chats',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 16,
                  color: context.cqTextSecondary,
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => ref.refresh(chatRoomsProvider),
                child: Text('Retry',
                    style: TextStyle(color: AppColors.neonCyan)),
              ),
            ],
          ),
        ),
        data: (rooms) => rooms.isEmpty
            ? _EmptyState(onStartChat: () => _showNewChatDialog(context, ref))
            : RefreshIndicator(
                color: AppColors.neonCyan,
                backgroundColor: context.cqCard,
                onRefresh: () async => ref.refresh(chatRoomsProvider),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: rooms.length,
                  separatorBuilder: (_, __) => Divider(
                    color: context.cqSurface,
                    height: 1,
                    indent: 80,
                  ),
                  itemBuilder: (context, i) {
                    final room = rooms[i];
                    return _ChatRoomTile(
                      room: room,
                      onTap: () => context.push(
                        '/chat/${room['id']}',
                        extra: {
                          'roomId': room['id'],
                          'name': room['other_username'] ?? 'Chat',
                          'avatar': room['other_avatar'],
                        },
                      ),
                    ).animate(delay: Duration(milliseconds: i * 40))
                        .fadeIn()
                        .slideX(begin: 0.08);
                  },
                ),
              ),
      ),
    );
  }

  void _showNewChatDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.cqSurface,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'NEW MESSAGE',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.neonCyan,
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 15,
                color: context.cqTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Enter username...',
                hintStyle: TextStyle(color: context.cqTextMuted),
                prefixIcon: Icon(Icons.search, color: context.cqTextMuted),
                filled: true,
                fillColor: context.cqCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.neonCyan, width: 1),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  // TODO: implement user search + DM room creation
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.neonCyan,
                  foregroundColor: AppColors.bgDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'START CHAT',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── CHAT ROOM TILE ───────────────────────────────────────────────────────────

class _ChatRoomTile extends StatelessWidget {
  final Map<String, dynamic> room;
  final VoidCallback onTap;

  const _ChatRoomTile({required this.room, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final unreadCount = (room['unread_count'] ?? 0) as int;
    final lastMessage = room['last_message'] as String? ?? '';
    final lastMessageAt = room['last_message_at'];
    final otherUsername = room['other_username'] ?? 'User';
    final otherAvatar = room['other_avatar'] as String?;
    final isOnline = room['is_online'] as bool? ?? false;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppColors.neonPurple, AppColors.neonCyan],
                    ),
                    border: unreadCount > 0
                        ? Border.all(color: AppColors.neonCyan, width: 2)
                        : null,
                  ),
                  child: otherAvatar != null
                      ? ClipOval(
                          child: Image.network(
                            otherAvatar,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _AvatarFallback(username: otherUsername),
                          ),
                        )
                      : _AvatarFallback(username: otherUsername),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 2,
                    right: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.neonGreen,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: context.cqBg, width: 2),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 14),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          otherUsername,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 15,
                            fontWeight: unreadCount > 0
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: unreadCount > 0
                                ? context.cqTextPrimary
                                : context.cqTextSecondary,
                          ),
                        ),
                      ),
                      if (lastMessageAt != null)
                        Text(
                          timeago.format(
                            lastMessageAt is DateTime
                                ? lastMessageAt
                                : DateTime.parse(lastMessageAt.toString()),
                          ),
                          style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 10,
                            color: unreadCount > 0
                                ? AppColors.neonCyan
                                : context.cqTextMuted,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage.isEmpty ? 'Start a conversation' : lastMessage,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 13,
                            color: unreadCount > 0
                                ? context.cqTextSecondary
                                : context.cqTextMuted,
                            fontStyle: lastMessage.isEmpty
                                ? FontStyle.italic
                                : FontStyle.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.neonCyan,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              fontFamily: 'Rajdhani',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  final String username;
  const _AvatarFallback({required this.username});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        username.isNotEmpty ? username[0].toUpperCase() : '?',
        style: const TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ─── EMPTY STATE ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final VoidCallback onStartChat;
  const _EmptyState({required this.onStartChat});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💬', style: TextStyle(fontSize: 64))
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text(
            'NO MESSAGES YET',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.cqTextSecondary,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Connect with friends and start chatting!',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 14,
              color: context.cqTextMuted,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onStartChat,
            icon: const Icon(Icons.add_comment_outlined, size: 18),
            label: const Text(
              'START A CHAT',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 1,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonCyan,
              foregroundColor: AppColors.bgDark,
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
