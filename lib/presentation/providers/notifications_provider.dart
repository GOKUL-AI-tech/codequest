import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/notification_model.dart';
import 'app_providers.dart';
import 'auth_provider.dart';

// ─── REALTIME NOTIFICATIONS STREAM ────────────────────────────────────────────

final notificationsStreamProvider =
    StreamProvider<List<NotificationModel>>((ref) {
  final userId = ref.watch(currentUserProvider)?.id;
  if (userId == null) return Stream.value([]);
  final ds = ref.read(supabaseDatasourceProvider);
  return ds.notificationsStream(userId);
});

final unreadCountProvider = Provider<int>((ref) {
  return ref
      .watch(notificationsStreamProvider)
      .maybeWhen(
        data: (notifications) =>
            notifications.where((n) => !n.isRead).length,
        orElse: () => 0,
      );
});

// ─── NOTIFICATION ACTIONS ─────────────────────────────────────────────────────

class NotificationsNotifier
    extends AsyncNotifier<List<NotificationModel>> {
  @override
  Future<List<NotificationModel>> build() async {
    final userId = ref.watch(currentUserProvider)?.id;
    if (userId == null) return [];
    final ds = ref.read(supabaseDatasourceProvider);
    return ds.getNotifications(userId);
  }

  Future<void> markRead(String id) async {
    final ds = ref.read(supabaseDatasourceProvider);
    await ds.markNotificationRead(id);
    state = state.whenData(
      (list) => list.map((n) => n.id == id ? _markAsRead(n) : n).toList(),
    );
  }

  Future<void> markAllRead() async {
    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;
    final ds = ref.read(supabaseDatasourceProvider);
    await ds.markAllNotificationsRead(userId);
    state = state.whenData(
      (list) => list.map((n) => _markAsRead(n)).toList(),
    );
  }

  NotificationModel _markAsRead(NotificationModel n) {
    return NotificationModel(
      id: n.id,
      userId: n.userId,
      type: n.type,
      title: n.title,
      body: n.body,
      metadata: n.metadata,
      isRead: true,
      createdAt: n.createdAt,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final userId = ref.read(currentUserProvider)?.id;
      if (userId == null) return <NotificationModel>[];
      final ds = ref.read(supabaseDatasourceProvider);
      return ds.getNotifications(userId);
    });
  }
}

final notificationsProvider = AsyncNotifierProvider<NotificationsNotifier,
    List<NotificationModel>>(
  NotificationsNotifier.new,
);
