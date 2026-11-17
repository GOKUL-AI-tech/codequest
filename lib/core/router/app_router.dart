import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/onboarding/character_selection_screen.dart';
import '../../presentation/screens/onboarding/skill_level_screen.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/auth/forgot_password_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/home/main_shell.dart';
import '../../presentation/screens/learn/worlds_screen.dart';
import '../../presentation/screens/learn/chapters_screen.dart';
import '../../presentation/screens/learn/lessons_list_screen.dart';
import '../../presentation/screens/learn/lesson_screen.dart';
import '../../presentation/screens/learn/quiz_screen.dart';
import '../../presentation/screens/learn/coding_challenge_screen.dart';
import '../../presentation/screens/learn/boss_battle_screen.dart';
import '../../presentation/screens/arena/arena_screen.dart';
import '../../presentation/screens/arena/battle_screen.dart';
import '../../presentation/screens/leaderboard/leaderboard_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/achievements_screen.dart';
import '../../presentation/screens/mentor/ai_mentor_screen.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../../presentation/screens/shop/shop_screen.dart';
import '../../presentation/screens/chat/chat_screen.dart';
import '../../presentation/screens/arena/opportunities_screen.dart';
import '../../presentation/screens/arena/mentor_referee_screen.dart';
import '../../presentation/screens/arena/team_ladder_screen.dart';
import '../../presentation/screens/profile/code_dna_screen.dart';
import '../../presentation/screens/settings/notification_settings_screen.dart';
import '../../presentation/screens/learn/language_bridge_screen.dart';
import '../../presentation/screens/learn/bug_hunt_screen.dart';
import '../../presentation/screens/settings/premium_screen.dart';
import '../../presentation/screens/settings/faq_screen.dart';
import '../../presentation/screens/settings/report_bug_screen.dart';
import '../../presentation/screens/settings/privacy_policy_screen.dart';
import '../../presentation/screens/learn/daily_drop_screen.dart';
import '../../presentation/screens/learn/typing_race_screen.dart';
import '../../presentation/screens/learn/code_playground_screen.dart';
import '../../presentation/screens/settings/language_screen.dart';
import '../../presentation/screens/learn/interview_prep_screen.dart';
import '../../presentation/screens/learn/roadmap_screen.dart';
import '../../presentation/screens/profile/certificate_screen.dart';

// Route Names
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String characterSelect = '/character-select';
  static const String skillLevel = '/skill-level';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';
  static const String worlds = '/worlds';
  static const String chapters = '/worlds/:languageId';
  static const String lesson = '/lesson/:id';
  static const String quiz = '/quiz/:id';
  static const String challenge = '/challenge/:id';
  static const String bossBattle = '/boss-battle/:id';
  static const String arena = '/arena';
  static const String battle = '/battle/:id';
  static const String leaderboard = '/leaderboard';
  static const String profile = '/profile';
  static const String achievements = '/achievements';
  static const String mentor = '/mentor';
  static const String settings = '/settings';
  static const String shop = '/shop';
  static const String opportunities = '/opportunities';
  static const String mentorReferee = '/mentor-referee';
  static const String teamLadder = '/team-ladder';
  static const String codeDna = '/code-dna';
  static const String notificationSettings = '/notification-settings';
  static const String languageBridge = '/language-bridge';
  static const String bugHunt = '/bug-hunt';
  static const String premium = '/premium';
  static const String faq = '/faq';
  static const String reportBug = '/report-bug';
  static const String privacyPolicy = '/privacy-policy';
  static const String dailyDrop = '/daily-drop';
  static const String typingRace = '/typing-race';
  static const String codePlayground = '/playground';
  static const String interviewPrep = '/interview-prep';
  static const String roadmap = '/roadmap';
  static const String certificate = '/certificate/:languageId';
  static const String languagePicker = '/language';
}

final appRouterProvider = Provider<GoRouter>((ref) => _buildRouter());

// Routes accessible without auth
const _publicRoutes = {
  AppRoutes.splash,
  AppRoutes.onboarding,
  AppRoutes.characterSelect,
  AppRoutes.skillLevel,
  AppRoutes.login,
  AppRoutes.register,
  AppRoutes.forgotPassword,
};

GoRouter _buildRouter() {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn =
          Supabase.instance.client.auth.currentSession != null;
      final isPublic = _publicRoutes.contains(state.matchedLocation);
      if (!isLoggedIn && !isPublic) return AppRoutes.login;
      return null;
    },
    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const OnboardingScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.characterSelect,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const CharacterSelectionScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.skillLevel,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const SkillLevelScreen(),
        ),
      ),

      // Auth
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _buildFadeTransition(
          state, const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (context, state) => _buildFadeTransition(
          state, const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Main Shell with Bottom Nav
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            pageBuilder: (context, state) => _buildFadeTransition(
              state, const HomeScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.worlds,
            pageBuilder: (context, state) => _buildFadeTransition(
              state, const WorldsScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.arena,
            pageBuilder: (context, state) => _buildFadeTransition(
              state, const ArenaScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.leaderboard,
            pageBuilder: (context, state) => _buildFadeTransition(
              state, const LeaderboardScreen(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => _buildFadeTransition(
              state, const ProfileScreen(),
            ),
          ),
        ],
      ),

      // Chapters screen (outside shell — no bottom nav)
      GoRoute(
        path: '/worlds/:languageId',
        pageBuilder: (context, state) => _buildSlideTransition(
          state, ChaptersScreen(languageId: state.pathParameters['languageId']!),
        ),
      ),

      // Lessons list for a chapter
      GoRoute(
        path: '/chapters/:chapterId/lessons',
        pageBuilder: (context, state) => _buildSlideTransition(
          state, LessonsListScreen(chapterId: state.pathParameters['chapterId']!),
        ),
      ),

      // Sub-screens (outside shell)
      GoRoute(
        path: AppRoutes.lesson,
        pageBuilder: (context, state) {
          final lang = state.uri.queryParameters['lang'];
          final orderStr = state.uri.queryParameters['order'];
          final order = orderStr != null ? int.tryParse(orderStr) : null;
          return _buildSlideTransition(
            state,
            LessonScreen(
              lessonId: state.pathParameters['id']!,
              languageId: lang,
              orderIndex: order,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.quiz,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, QuizScreen(quizId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: AppRoutes.challenge,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, CodingChallengeScreen(challengeId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: AppRoutes.bossBattle,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, BossBattleScreen(bossId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: AppRoutes.battle,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, BattleScreen(battleId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: '/chat/:roomId',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return _buildSlideTransition(
            state,
            ChatScreen(
              roomId: state.pathParameters['roomId']!,
              otherUsername: extra['name'] as String? ?? 'Chat',
              otherAvatar: extra['avatar'] as String?,
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.achievements,
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: AppRoutes.mentor,
        builder: (context, state) => const AiMentorScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.shop,
        builder: (context, state) => const ShopScreen(),
      ),
      GoRoute(
        path: AppRoutes.opportunities,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const OpportunitiesScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.mentorReferee,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const MentorRefereeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.teamLadder,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const TeamLadderScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.codeDna,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const CodeDnaScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.languageBridge,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const LanguageBridgeScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.bugHunt,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const BugHuntScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.notificationSettings,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const NotificationSettingsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.premium,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const PremiumScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.faq,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const FaqScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.reportBug,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const ReportBugScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const PrivacyPolicyScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.dailyDrop,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const DailyDropScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.typingRace,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const TypingRaceScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.languagePicker,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const LanguageScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.codePlayground,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, CodePlaygroundScreen(
            initialLanguageId: state.uri.queryParameters['lang'],
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.interviewPrep,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const InterviewPrepScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.roadmap,
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const RoadmapScreen(),
        ),
      ),
      GoRoute(
        path: '/certificate',
        pageBuilder: (context, state) => _buildSlideTransition(
          state, const CertificateScreen(
            languageId: 'python',
          ),
        ),
      ),
      GoRoute(
        path: '/certificate/:languageId',
        pageBuilder: (context, state) => _buildSlideTransition(
          state, CertificateScreen(
            languageId: state.pathParameters['languageId'] ?? 'python',
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
  );
}

CustomTransitionPage _buildFadeTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage _buildSlideTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 350),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeOutCubic));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

class _ErrorScreen extends StatelessWidget {
  final Exception? error;
  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Error: ${error?.toString() ?? "Unknown error"}'),
      ),
    );
  }
}
