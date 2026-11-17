import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;

// ─── IDs ──────────────────────────────────────────────────────────────────────

class NotifId {
  static const int streakReminder    = 1;
  static const int dailyMission      = 2;
  static const int levelUp           = 3;
  static const int achievement       = 4;
  static const int battleInvite      = 5;
  static const int friendRequest     = 6;
  static const int livesRefilled     = 7;
  static const int xpReward          = 8;
  static const int weeklyLeaderboard = 9;
  static const int mentorReply       = 10;
}

// ─── Payload routes ───────────────────────────────────────────────────────────

class NotifPayload {
  static const String home         = 'route:/home';
  static const String arena        = 'route:/arena';
  static const String leaderboard  = 'route:/leaderboard';
  static const String profile      = 'route:/profile';
  static const String achievements = 'route:/achievements';
  static const String mentor       = 'route:/mentor';
}

// ─── Channel IDs ─────────────────────────────────────────────────────────────

const _chGame         = 'codequest_game';
const _chSocial       = 'codequest_social';
const _chReminders    = 'codequest_reminders';
const _chAchievements = 'codequest_achievements';

// ─── Service ──────────────────────────────────────────────────────────────────

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _plugin = FlutterLocalNotificationsPlugin();

  /// Called when the user taps a notification — set in main.dart.
  void Function(String? payload)? onNotificationTap;

  // ── init ────────────────────────────────────────────────────────────────────

  Future<void> init() async {
    if (kIsWeb) return; // Notifications not supported on web

    tz_data.initializeTimeZones();
    // Set device's actual local timezone so scheduled notifications
    // fire at the correct local time instead of UTC.
    try {
      final String deviceTz = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(deviceTz));
    } catch (_) {
      // Fallback: use UTC offset from Dart to find the closest location
      final offset = DateTime.now().timeZoneOffset;
      final match = tz.timeZoneDatabase.locations.values.firstWhere(
        (loc) => loc.currentTimeZone.offset == offset.inMilliseconds,
        orElse: () => tz.UTC,
      );
      tz.setLocalLocation(match);
    }

    // v18 stable API: InitializationSettings is positional,
    // callbacks are named optional params.
    await _plugin.initialize(
      const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
      onDidReceiveNotificationResponse: (NotificationResponse r) =>
          onNotificationTap?.call(r.payload),
      onDidReceiveBackgroundNotificationResponse: _bgHandler,
    );

    await _createChannels();
  }

  Future<void> _createChannels() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    for (final ch in [
      const AndroidNotificationChannel(
        _chGame, 'Game Updates',
        description: 'Level ups, XP rewards, lives refilled',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      ),
      const AndroidNotificationChannel(
        _chSocial, 'Social',
        description: 'Friends, battles, mentor replies',
        importance: Importance.high,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        _chReminders, 'Reminders',
        description: 'Streak and daily mission alerts',
        importance: Importance.defaultImportance,
        playSound: true,
      ),
      const AndroidNotificationChannel(
        _chAchievements, 'Achievements',
        description: 'Badge and achievement unlocks',
        importance: Importance.high,
        playSound: true,
        enableLights: true,
        ledColor: Color(0xFF00F5FF),
      ),
    ]) {
      await android.createNotificationChannel(ch);
    }
  }

  // ── permissions ─────────────────────────────────────────────────────────────

  Future<bool> requestPermission() async {
    if (kIsWeb) return false;
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
              alert: true, badge: true, sound: true) ??
          false;
    }
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return android != null
        ? await android.requestNotificationsPermission() ?? false
        : true;
  }

  Future<bool> get isPermissionGranted async {
    if (kIsWeb) return false;
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return android != null
        ? await android.areNotificationsEnabled() ?? false
        : true;
  }

  // ── immediate notifications ──────────────────────────────────────────────────

  Future<void> showLevelUp(int level) => _show(
        NotifId.levelUp, _chGame,
        '🎉 LEVEL UP! You\'re now Level $level!',
        'New challenges unlocked. Keep going!',
        payload: NotifPayload.profile,
      );

  Future<void> showXpReward(int xp, {String? reason}) => _show(
        NotifId.xpReward, _chGame,
        '⭐ +$xp XP earned!',
        reason ?? 'Keep completing lessons to level up faster.',
        payload: NotifPayload.home,
      );

  Future<void> showAchievementUnlocked(String title, String emoji) =>
      _show(
        NotifId.achievement, _chAchievements,
        '$emoji Achievement Unlocked!',
        '"$title" — tap to view your badges.',
        payload: NotifPayload.achievements,
      );

  Future<void> showBattleInvite(String username) => _show(
        NotifId.battleInvite, _chSocial,
        '⚔️ Battle Request!',
        '$username challenges you to a coding duel. Accept now!',
        payload: NotifPayload.arena,
      );

  Future<void> showFriendRequest(String username) => _show(
        NotifId.friendRequest, _chSocial,
        '🤝 Friend Request',
        '$username wants to connect.',
        payload: NotifPayload.profile,
      );

  Future<void> showLivesRefilled() => _show(
        NotifId.livesRefilled, _chGame,
        '❤️ Lives Refilled!',
        'Your 5 lives are back. Time to conquer more challenges!',
        payload: NotifPayload.home,
      );

  Future<void> showWeeklyLeaderboard(int rank) => _show(
        NotifId.weeklyLeaderboard, _chGame,
        '🏆 Weekly Results Are In!',
        rank <= 10
            ? 'You finished #$rank this week. Legend!'
            : 'You finished #$rank — go further next week!',
        payload: NotifPayload.leaderboard,
      );

  Future<void> showMentorReply() => _show(
        NotifId.mentorReply, _chSocial,
        '🤖 ALEX replied',
        'Your AI Mentor has a new answer waiting.',
        payload: NotifPayload.mentor,
      );

  // ── scheduled notifications ──────────────────────────────────────────────────

  Future<void> scheduleStreakReminder({int hour = 20, int minute = 0}) async {
    if (kIsWeb) return;
    await cancelStreakReminder();
    await _plugin.zonedSchedule(
      NotifId.streakReminder,
      '🔥 Don\'t break your streak!',
      'You haven\'t coded today. 5 minutes keeps your streak alive.',
      _nextTime(hour, minute),
      _details(_chReminders, 'Reminders'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: NotifPayload.home,
    );
  }

  Future<void> cancelStreakReminder() => _plugin.cancel(NotifId.streakReminder);

  Future<void> scheduleDailyMissionReminder(
      {int hour = 9, int minute = 0}) async {
    await _plugin.cancel(NotifId.dailyMission);
    await _plugin.zonedSchedule(
      NotifId.dailyMission,
      '🎯 Daily Missions Are Live!',
      'New missions dropped. Complete them for bonus XP and coins.',
      _nextTime(hour, minute),
      _details(_chReminders, 'Daily Missions'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: NotifPayload.home,
    );
  }

  Future<void> scheduleLivesRefill(int minutes) async {
    final when =
        tz.TZDateTime.now(tz.local).add(Duration(minutes: minutes));
    await _plugin.zonedSchedule(
      NotifId.livesRefilled,
      '❤️ Lives Refilled!',
      'Your 5 lives are back. Time to conquer more challenges!',
      when,
      _details(_chGame, 'Game Updates'),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: NotifPayload.home,
    );
  }

  Future<void> cancelAll() async { if (!kIsWeb) await _plugin.cancelAll(); }
  Future<void> cancel(int id) async { if (!kIsWeb) await _plugin.cancel(id); }

  // ── helpers ──────────────────────────────────────────────────────────────────

  tz.TZDateTime _nextTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var t = tz.TZDateTime(
        tz.local, now.year, now.month, now.day, hour, minute);
    if (t.isBefore(now)) t = t.add(const Duration(days: 1));
    return t;
  }

  Future<void> _show(
    int id,
    String channelId,
    String title,
    String body, {
    String? payload,
  }) async {
    if (kIsWeb) return;
    await _plugin.show(
      id,
      title,
      body,
      _details(channelId, channelId),
      payload: payload,
    );
  }

  NotificationDetails _details(String channelId, String channelName) =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          color: const Color(0xFF00F5FF),
          enableLights: true,
          ledColor: const Color(0xFF00F5FF),
          ledOnMs: 500,
          ledOffMs: 500,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
}

@pragma('vm:entry-point')
void _bgHandler(NotificationResponse _) {}
