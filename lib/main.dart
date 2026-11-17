import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local/hive_datasource.dart';
import 'l10n/app_localizations.dart';
import 'presentation/providers/app_providers.dart';
import 'presentation/providers/locale_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow all orientations on tablet/web; portrait-only on phone
  // Orientation handled responsively by the UI instead of locking here.

  // Immersive UI
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.bgDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize Hive + open boxes
  await Hive.initFlutter();
  await HiveDatasource.init();

  // Initialize notification service
  await NotificationService.instance.init();

  // Initialize Supabase
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
    realtimeClientOptions: const RealtimeClientOptions(
      logLevel: RealtimeLogLevel.info,
    ),
  );

  runApp(
    const ProviderScope(
      child: CodeQuestApp(),
    ),
  );
}

class CodeQuestApp extends ConsumerStatefulWidget {
  const CodeQuestApp({super.key});

  @override
  ConsumerState<CodeQuestApp> createState() => _CodeQuestAppState();
}

class _CodeQuestAppState extends ConsumerState<CodeQuestApp> {
  @override
  void initState() {
    super.initState();
    // Route notification taps to the correct screen
    NotificationService.instance.onNotificationTap = (payload) {
      if (payload == null) return;
      if (payload.startsWith('route:')) {
        final route = payload.replaceFirst('route:', '');
        // Delay until the navigator is ready
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(appRouterProvider).go(route);
        });
      }
    };

    // Request permission then schedule reminders
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    // Ask for POST_NOTIFICATIONS permission on Android 13+ at startup.
    // Only prompts once — if already granted/denied, resolves immediately.
    final granted = await NotificationService.instance.requestPermission();
    if (!granted) return;

    await _scheduleDefaultReminders();
  }

  Future<void> _scheduleDefaultReminders() async {
    final hive = HiveDatasource();
    final streakEnabled = hive.getSetting<bool>('notif_streak') ?? true;
    final missionEnabled = hive.getSetting<bool>('notif_daily_mission') ?? true;

    if (streakEnabled) {
      await NotificationService.instance
          .scheduleStreakReminder(hour: 20, minute: 0);
    }
    if (missionEnabled) {
      await NotificationService.instance
          .scheduleDailyMissionReminder(hour: 9, minute: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      // ── Localization ──────────────────────────────────────────────────────
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (deviceLocale, supported) {
        if (deviceLocale != null) {
          for (final l in supported) {
            if (l.languageCode == deviceLocale.languageCode) return l;
          }
        }
        return const Locale('en');
      },
    );
  }
}
