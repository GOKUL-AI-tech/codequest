import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../core/theme/app_theme.dart';
import '../../providers/notifications_provider.dart';
import '../../widgets/common/loading_skeleton.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NOTIFICATIONS'),
        actions: [
          TextButton(
            onPressed: () =>
                ref.read(notificationsProvider.notifier).markAllRead(),
            child: Text(
              'MARK ALL READ',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13,
                color: AppColors.neonCyan,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.neonCyan,
        backgroundColor: context.cqCard,
        onRefresh: () =>
            ref.read(notificationsProvider.notifier).refresh(),
        child: notificationsAsync.when(
          loading: () => _SkeletonList(),
          error: (e, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('😵', style: TextStyle(fontSize: 48)),
                SizedBox(height: 12),
                Text('Failed to load notifications',
                    style: TextStyle(
                        fontFamily: 'Rajdhani',
                        fontSize: 16,
                        color: context.cqTextSecondary)),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      ref.read(notificationsProvider.notifier).refresh(),
                  child: Text('Retry',
                      style:
                          TextStyle(color: AppColors.neonCyan)),
                )
              ],
            ),
          ),
          data: (notifications) => notifications.isEmpty
              ? _EmptyState()
              : ListView.separated(
                  padding: EdgeInsets.symmetric(
                      vertical: 12),
                  itemCount: notifications.length,
                  separatorBuilder: (_, __) => Divider(
                    color: context.cqSurface,
                    height: 1,
                    indent: 72,
                  ),
                  itemBuilder: (context, i) {
                    final n = notifications[i];
                    return _NotificationTile(
                      notification: n,
                      onTap: () => ref
                          .read(notificationsProvider.notifier)
                          .markRead(n.id),
                    ).animate(delay: Duration(milliseconds: i * 40))
                        .fadeIn()
                        .slideX(begin: 0.1);
                  },
                ),
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final dynamic notification;
  final VoidCallback onTap;

  const _NotificationTile(
      {required this.notification, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isUnread = !notification.isRead;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        color: isUnread
            ? AppColors.neonCyan.withOpacity(0.04)
            : Colors.transparent,
        padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Stack(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: context.cqCard,
                    border: Border.all(color: context.cqSurface),
                  ),
                  child: Center(
                    child: Text(notification.iconEmoji,
                        style: const TextStyle(fontSize: 22)),
                  ),
                ),
                if (isUnread)
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.neonCyan,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: context.cqBg, width: 2),
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
                  Text(
                    notification.title,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isUnread
                          ? context.cqTextPrimary
                          : context.cqTextSecondary,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    notification.body,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 13,
                      color: context.cqTextMuted,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    timeago.format(notification.createdAt),
                    style: TextStyle(
                      fontFamily: 'Share Tech Mono',
                      fontSize: 10,
                      color: context.cqTextMuted,
                    ),
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔔', style: TextStyle(fontSize: 64))
              .animate()
              .scale(duration: 600.ms, curve: Curves.elasticOut),
          const SizedBox(height: 20),
          Text(
            'NO NOTIFICATIONS YET',
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
            'Complete lessons, win battles and level up\nto unlock notifications.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 14,
              color: context.cqTextMuted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 8,
      itemBuilder: (_, i) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            LoadingSkeleton(width: 46, height: 46, radius: 14),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LoadingSkeleton(width: double.infinity, height: 14),
                  const SizedBox(height: 6),
                  LoadingSkeleton(width: 200, height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
