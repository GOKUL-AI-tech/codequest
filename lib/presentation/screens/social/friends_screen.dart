import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_theme.dart';
import '../../providers/leaderboard_provider.dart';
import '../../widgets/common/loading_skeleton.dart';
import '../../widgets/common/neon_button.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final friendsAsync = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.cyberpunkGradient.createShader(bounds),
          child: const Text(
            'FRIENDS',
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
            icon: Icon(Icons.person_search, color: AppColors.neonCyan),
            onPressed: () => _showAddFriendDialog(context, ref),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.neonCyan,
          labelColor: AppColors.neonCyan,
          unselectedLabelColor: context.cqTextMuted,
          labelStyle: const TextStyle(
            fontFamily: 'Rajdhani',
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          tabs: const [
            Tab(text: 'FRIENDS'),
            Tab(text: 'REQUESTS'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // ── Friends List
          friendsAsync.when(
            loading: () => ListView.builder(
              itemCount: 6,
              itemBuilder: (_, __) => SkeletonListTile(),
            ),
            error: (_, __) => Center(
              child: Text(
                'Could not load friends',
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  color: context.cqTextMuted,
                ),
              ),
            ),
            data: (friends) => friends.isEmpty
                ? _EmptyFriends(
                    onAddFriend: () => _showAddFriendDialog(context, ref),
                  )
                : RefreshIndicator(
                    color: AppColors.neonCyan,
                    backgroundColor: context.cqCard,
                    onRefresh: () async => ref.refresh(friendsProvider),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: friends.length,
                      itemBuilder: (context, i) {
                        final friend = friends[i] as Map<String, dynamic>;
                        return _FriendTile(
                          friend: friend,
                          onChallenge: () {},
                          onMessage: () {},
                        )
                            .animate(delay: Duration(milliseconds: i * 40))
                            .fadeIn()
                            .slideX(begin: 0.08);
                      },
                    ),
                  ),
          ),

          // ── Friend Requests
          _FriendRequestsTab(),
        ],
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: AppColors.neonCyan.withOpacity(0.3)),
        ),
        title: Text(
          'ADD FRIEND',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 14,
            color: AppColors.neonCyan,
            letterSpacing: 2,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Search by username to send a friend request.',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13,
                color: context.cqTextMuted,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: controller,
              autofocus: true,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 14,
                color: context.cqTextPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Username...',
                hintStyle: TextStyle(color: context.cqTextMuted),
                prefixIcon:
                    Icon(Icons.search, color: context.cqTextMuted),
                filled: true,
                fillColor: context.cqCard,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColors.neonCyan, width: 1),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                color: context.cqTextMuted,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              // TODO: send friend request
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.neonCyan,
              foregroundColor: AppColors.bgDark,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'SEND REQUEST',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── FRIEND TILE ──────────────────────────────────────────────────────────────

class _FriendTile extends StatelessWidget {
  final Map<String, dynamic> friend;
  final VoidCallback onChallenge;
  final VoidCallback onMessage;

  const _FriendTile({
    required this.friend,
    required this.onChallenge,
    required this.onMessage,
  });

  @override
  Widget build(BuildContext context) {
    final username = friend['username'] ?? 'Unknown';
    final avatarUrl = friend['avatar_url'] as String?;
    final level = friend['level'] ?? 1;
    final xp = friend['xp'] ?? 0;
    final isOnline = friend['is_online'] as bool? ?? false;
    final streak = friend['streak'] ?? 0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.cqCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: context.cqSurface, width: 1),
      ),
      child: Row(
        children: [
          // Avatar + online dot
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [AppColors.neonPurple, AppColors.neonCyan],
                  ),
                ),
                child: avatarUrl != null
                    ? ClipOval(
                        child: Image.network(
                          avatarUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _AvatarInitial(username: username),
                        ),
                      )
                    : _AvatarInitial(username: username),
              ),
              if (isOnline)
                Positioned(
                  bottom: 1,
                  right: 1,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppColors.neonGreen,
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: context.cqCard, width: 2),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 12),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: const TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'LVL $level',
                      style: TextStyle(
                        fontFamily: 'Share Tech Mono',
                        fontSize: 10,
                        color: AppColors.neonCyan,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      '🔥 $streak day streak',
                      style: TextStyle(
                        fontFamily: 'Share Tech Mono',
                        fontSize: 10,
                        color: context.cqTextMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action buttons
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ActionIconButton(
                icon: Icons.chat_bubble_outline,
                color: AppColors.neonCyan,
                onTap: onMessage,
              ),
              const SizedBox(width: 6),
              _ActionIconButton(
                icon: Icons.sports_esports_outlined,
                color: AppColors.neonPurple,
                onTap: onChallenge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ─── FRIEND REQUESTS TAB ─────────────────────────────────────────────────────

class _FriendRequestsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder — would use a real FutureProvider in production
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('👋', style: TextStyle(fontSize: 56))
              .animate()
              .scale(duration: 500.ms, curve: Curves.elasticOut),
          SizedBox(height: 16),
          Text(
            'NO PENDING REQUESTS',
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 13,
              color: context.cqTextSecondary,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Friend requests will appear here.',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 13,
              color: context.cqTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── EMPTY STATE ─────────────────────────────────────────────────────────────

class _EmptyFriends extends StatelessWidget {
  final VoidCallback onAddFriend;
  const _EmptyFriends({required this.onAddFriend});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🤝', style: TextStyle(fontSize: 64))
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text(
            'NO FRIENDS YET',
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
            'Find coding partners and compete together!',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 13,
              color: context.cqTextMuted,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAddFriend,
            icon: const Icon(Icons.person_add, size: 18),
            label: const Text(
              'ADD FRIEND',
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

class _AvatarInitial extends StatelessWidget {
  final String username;
  const _AvatarInitial({required this.username});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        username.isNotEmpty ? username[0].toUpperCase() : '?',
        style: const TextStyle(
          fontFamily: 'Orbitron',
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
