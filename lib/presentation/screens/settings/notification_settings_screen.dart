import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/services/notification_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/datasources/local/hive_datasource.dart';

// ─── Notification preference model ───────────────────────────────────────────

class _NotifPref {
  final String key;
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final Future<void> Function(bool enabled) onToggle;

  const _NotifPref({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.onToggle,
  });
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final _hive = HiveDatasource();
  bool _permissionGranted = false;
  bool _loading = true;

  // Per-type preference state
  final Map<String, bool> _prefs = {};

  late final List<_NotifPref> _notifPrefs;

  @override
  void initState() {
    super.initState();

    _notifPrefs = [
      _NotifPref(
        key: 'notif_streak',
        title: 'Streak Reminder',
        subtitle: 'Daily at 8 PM — never lose your streak',
        emoji: '🔥',
        color: AppColors.neonOrange,
        onToggle: (enabled) async {
          if (enabled) {
            await NotificationService.instance
                .scheduleStreakReminder(hour: 20);
          } else {
            await NotificationService.instance.cancelStreakReminder();
          }
        },
      ),
      _NotifPref(
        key: 'notif_daily_mission',
        title: 'Daily Missions',
        subtitle: 'Daily at 9 AM — new missions are ready',
        emoji: '🎯',
        color: AppColors.neonCyan,
        onToggle: (enabled) async {
          if (enabled) {
            await NotificationService.instance
                .scheduleDailyMissionReminder(hour: 9);
          } else {
            await NotificationService.instance
                .cancel(NotifId.dailyMission);
          }
        },
      ),
      _NotifPref(
        key: 'notif_level_up',
        title: 'Level Up',
        subtitle: 'Celebrate when you reach a new level',
        emoji: '⭐',
        color: AppColors.neonYellow,
        onToggle: (_) async {},
      ),
      _NotifPref(
        key: 'notif_achievements',
        title: 'Achievements',
        subtitle: 'Get notified when you unlock a badge',
        emoji: '🏆',
        color: AppColors.neonGold,
        onToggle: (_) async {},
      ),
      _NotifPref(
        key: 'notif_battle_invite',
        title: 'Battle Invites',
        subtitle: 'When someone challenges you to a duel',
        emoji: '⚔️',
        color: AppColors.neonPink,
        onToggle: (_) async {},
      ),
      _NotifPref(
        key: 'notif_friend_request',
        title: 'Friend Requests',
        subtitle: 'When someone sends you a friend request',
        emoji: '🤝',
        color: AppColors.neonPurple,
        onToggle: (_) async {},
      ),
      _NotifPref(
        key: 'notif_lives',
        title: 'Lives Refilled',
        subtitle: 'When your hearts are fully restored',
        emoji: '❤️',
        color: AppColors.error,
        onToggle: (enabled) async {
          if (!enabled) {
            await NotificationService.instance
                .cancel(NotifId.livesRefilled);
          }
        },
      ),
      _NotifPref(
        key: 'notif_leaderboard',
        title: 'Weekly Leaderboard',
        subtitle: 'Your weekly rank results every Monday',
        emoji: '🏅',
        color: AppColors.neonGreen,
        onToggle: (_) async {},
      ),
      _NotifPref(
        key: 'notif_mentor',
        title: 'AI Mentor Replies',
        subtitle: 'When ALEX has a new answer for you',
        emoji: '🤖',
        color: const Color(0xFF00B09B),
        onToggle: (_) async {},
      ),
    ];

    _loadState();
  }

  Future<void> _loadState() async {
    _permissionGranted =
        await NotificationService.instance.isPermissionGranted;

    for (final p in _notifPrefs) {
      _prefs[p.key] = _hive.getSetting<bool>(p.key) ?? true;
    }

    if (mounted) setState(() => _loading = false);
  }

  Future<void> _toggle(String key, bool value) async {
    await _hive.setSetting(key, value);
    setState(() => _prefs[key] = value);

    final pref = _notifPrefs.firstWhere((p) => p.key == key);
    await pref.onToggle(value);
  }

  Future<void> _requestPermission() async {
    final granted =
        await NotificationService.instance.requestPermission();
    setState(() => _permissionGranted = granted);

    if (granted) {
      // Re-schedule any enabled reminders after permission is granted
      for (final p in _notifPrefs) {
        final enabled = _prefs[p.key] ?? true;
        if (enabled) await p.onToggle(true);
      }
    }
  }

  Future<void> _testNotification() async {
    await NotificationService.instance.showXpReward(
      50,
      reason: 'Test notification — push notifications are working! 🎉',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new,
              color: AppColors.neonCyan, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'NOTIFICATIONS',
          style: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(
                  color: AppColors.neonCyan))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // ── Permission Banner ──────────────────────────────────
                if (!_permissionGranted)
                  _PermissionBanner(onAllow: _requestPermission)
                      .animate()
                      .fadeIn()
                      .slideY(begin: -0.1),

                if (_permissionGranted)
                  _PermissionGrantedBanner()
                      .animate()
                      .fadeIn(),

                const SizedBox(height: 20),

                // ── Master Toggle ──────────────────────────────────────
                _SectionHeader(
                  title: 'MASTER CONTROL',
                  subtitle: 'Disable all notifications at once',
                ),
                const SizedBox(height: 8),
                _MasterToggle(
                  enabled: _permissionGranted &&
                      (_prefs.values.any((v) => v)),
                  onToggle: (v) async {
                    for (final p in _notifPrefs) {
                      await _toggle(p.key, v);
                    }
                    if (!v) {
                      await NotificationService.instance
                          .cancelAll();
                    }
                  },
                ).animate(delay: 100.ms).fadeIn(),

                const SizedBox(height: 28),

                // ── Reminders ─────────────────────────────────────────
                _SectionHeader(
                  title: 'REMINDERS',
                  subtitle: 'Scheduled daily alerts',
                ),
                const SizedBox(height: 8),
                ..._notifPrefs
                    .where((p) =>
                        p.key == 'notif_streak' ||
                        p.key == 'notif_daily_mission')
                    .toList()
                    .asMap()
                    .entries
                    .map((e) => _NotifTile(
                          pref: e.value,
                          enabled: _permissionGranted &&
                              (_prefs[e.value.key] ?? true),
                          onToggle: !_permissionGranted
                              ? null
                              : (v) => _toggle(e.value.key, v),
                        )
                            .animate(
                                delay: Duration(
                                    milliseconds: 150 + e.key * 60))
                            .fadeIn()
                            .slideX(begin: 0.05)),

                const SizedBox(height: 28),

                // ── Game Events ───────────────────────────────────────
                _SectionHeader(
                  title: 'GAME EVENTS',
                  subtitle: 'XP, levels, lives, and rankings',
                ),
                const SizedBox(height: 8),
                ..._notifPrefs
                    .where((p) => [
                          'notif_level_up',
                          'notif_achievements',
                          'notif_lives',
                          'notif_leaderboard',
                        ].contains(p.key))
                    .toList()
                    .asMap()
                    .entries
                    .map((e) => _NotifTile(
                          pref: e.value,
                          enabled: _permissionGranted &&
                              (_prefs[e.value.key] ?? true),
                          onToggle: !_permissionGranted
                              ? null
                              : (v) => _toggle(e.value.key, v),
                        )
                            .animate(
                                delay: Duration(
                                    milliseconds: 300 + e.key * 60))
                            .fadeIn()
                            .slideX(begin: 0.05)),

                const SizedBox(height: 28),

                // ── Social ────────────────────────────────────────────
                _SectionHeader(
                  title: 'SOCIAL',
                  subtitle: 'Battles, friends, and mentor',
                ),
                const SizedBox(height: 8),
                ..._notifPrefs
                    .where((p) => [
                          'notif_battle_invite',
                          'notif_friend_request',
                          'notif_mentor',
                        ].contains(p.key))
                    .toList()
                    .asMap()
                    .entries
                    .map((e) => _NotifTile(
                          pref: e.value,
                          enabled: _permissionGranted &&
                              (_prefs[e.value.key] ?? true),
                          onToggle: !_permissionGranted
                              ? null
                              : (v) => _toggle(e.value.key, v),
                        )
                            .animate(
                                delay: Duration(
                                    milliseconds: 500 + e.key * 60))
                            .fadeIn()
                            .slideX(begin: 0.05)),

                const SizedBox(height: 28),

                // ── Test button ────────────────────────────────────────
                if (_permissionGranted)
                  GestureDetector(
                    onTap: _testNotification,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color:
                                AppColors.neonCyan.withOpacity(0.4)),
                        color:
                            AppColors.neonCyan.withOpacity(0.05),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.notifications_active_outlined,
                              color: AppColors.neonCyan, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'SEND TEST NOTIFICATION',
                            style: TextStyle(
                              fontFamily: 'Orbitron',
                              fontSize: 12,
                              color: AppColors.neonCyan,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate(delay: 700.ms).fadeIn(),

                const SizedBox(height: 60),
              ],
            ),
    );
  }
}

// ─── Sub-Widgets ──────────────────────────────────────────────────────────────

class _PermissionBanner extends StatelessWidget {
  final VoidCallback onAllow;
  const _PermissionBanner({required this.onAllow});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppColors.neonOrange.withOpacity(0.2),
            AppColors.neonPink.withOpacity(0.1),
          ],
        ),
        border: Border.all(
            color: AppColors.neonOrange.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('🔔', style: TextStyle(fontSize: 22)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Notifications are disabled',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.neonOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Enable notifications to get streak reminders, XP rewards, battle invites, and daily mission alerts.',
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 14,
              color: context.cqTextSecondary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: onAllow,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: AppColors.fireGradient,
              ),
              child: const Text(
                'ALLOW NOTIFICATIONS',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionGrantedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.neonGreen.withOpacity(0.08),
        border: Border.all(
            color: AppColors.neonGreen.withOpacity(0.3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.check_circle_rounded,
              color: AppColors.neonGreen, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Notifications enabled — you\'re all set',
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 14,
                color: AppColors.neonGreen,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _SectionHeader(
      {required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: context.cqTextMuted,
              letterSpacing: 2,
            )),
        const SizedBox(height: 2),
        Text(subtitle,
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 12,
              color: context.cqTextMuted,
            )),
      ],
    );
  }
}

class _MasterToggle extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onToggle;
  const _MasterToggle(
      {required this.enabled, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: context.cqCard,
        border: Border.all(
          color: enabled
              ? AppColors.neonCyan.withOpacity(0.3)
              : context.cqSurface,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: enabled
                  ? AppColors.neonCyan.withOpacity(0.12)
                  : context.cqCardSecondary,
            ),
            child: Center(
              child: Icon(
                enabled
                    ? Icons.notifications_active
                    : Icons.notifications_off_outlined,
                color: enabled
                    ? AppColors.neonCyan
                    : context.cqTextMuted,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  enabled
                      ? 'All Notifications On'
                      : 'All Notifications Off',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: enabled
                        ? context.cqTextPrimary
                        : context.cqTextMuted,
                  ),
                ),
                Text(
                  enabled
                      ? 'You\'ll receive all enabled alerts'
                      : 'Tap to re-enable notifications',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 12,
                    color: context.cqTextMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: onToggle,
            activeColor: AppColors.neonCyan,
            inactiveTrackColor: context.cqSurface,
          ),
        ],
      ),
    );
  }
}

class _NotifTile extends StatelessWidget {
  final _NotifPref pref;
  final bool enabled;
  final ValueChanged<bool>? onToggle;

  const _NotifTile({
    required this.pref,
    required this.enabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onToggle == null;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(
          horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.cqCard,
        border: Border.all(
          color: enabled
              ? pref.color.withOpacity(0.2)
              : context.cqSurface,
        ),
      ),
      child: Row(
        children: [
          Text(pref.emoji,
              style: TextStyle(
                  fontSize: 20,
                  color:
                      disabled ? null : Colors.white)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pref.title,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: disabled || !enabled
                          ? context.cqTextMuted
                          : context.cqTextPrimary,
                    )),
                Text(pref.subtitle,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 11,
                      color: context.cqTextMuted,
                    )),
              ],
            ),
          ),
          Switch(
            value: enabled,
            onChanged: disabled ? null : onToggle,
            activeColor: pref.color,
            inactiveTrackColor: context.cqSurface,
          ),
        ],
      ),
    );
  }
}
