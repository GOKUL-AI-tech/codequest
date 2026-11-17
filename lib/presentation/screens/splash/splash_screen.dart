import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 3200));
    if (!mounted) return;

    final session = Supabase.instance.client.auth.currentSession;
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool(AppConstants.kOnboardingDone) ?? false;

    if (!mounted) return;

    if (session != null) {
      context.go(AppRoutes.home);
    } else if (!onboardingDone) {
      context.go(AppRoutes.onboarding);
    } else {
      context.go(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated grid background
          _buildGridBackground(),

          // Floating particles
          _buildParticles(),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: AppColors.cyberpunkGradient,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonCyan.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '</>', // Code icon
                      style: TextStyle(
                        fontFamily: 'Share Tech Mono',
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
                    .animate()
                    .scale(
                      duration: 800.ms,
                      curve: Curves.elasticOut,
                      begin: const Offset(0.3, 0.3),
                      end: const Offset(1.0, 1.0),
                    )
                    .then()
                    .shimmer(duration: 1200.ms, color: AppColors.neonCyan.withOpacity(0.3)),

                const SizedBox(height: 32),

                // App name
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.cyberpunkGradient.createShader(bounds),
                  child: const Text(
                    'CODEQUEST',
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 6,
                    ),
                  ),
                )
                    .animate(delay: 400.ms)
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: 0.3, end: 0),

                SizedBox(height: 8),

                Text(
                  AppConstants.appTagline,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 16,
                    color: context.cqTextSecondary,
                    letterSpacing: 3,
                  ),
                )
                    .animate(delay: 700.ms)
                    .fadeIn(duration: 600.ms),

                const SizedBox(height: 80),

                // Loading bar
                _buildLoadingBar()
                    .animate(delay: 1000.ms)
                    .fadeIn(duration: 400.ms),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridBackground() {
    return Opacity(
      opacity: 0.06,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 10,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neonCyan, width: 0.3),
          ),
        ),
      ),
    );
  }

  Widget _buildParticles() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Stack(
          children: List.generate(12, (i) {
            final offset = (i * 0.083 + _particleController.value) % 1.0;
            final x = (i * 97.3 % 300) / 300;
            return Positioned(
              left: MediaQuery.of(context).size.width * x,
              top: MediaQuery.of(context).size.height * (1 - offset),
              child: Container(
                width: 3,
                height: 3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i.isEven
                      ? AppColors.neonCyan.withOpacity(0.6)
                      : AppColors.neonPurple.withOpacity(0.6),
                  boxShadow: [
                    BoxShadow(
                      color: i.isEven ? AppColors.neonCyan : AppColors.neonPurple,
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildLoadingBar() {
    return SizedBox(
      width: 200,
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 2000),
            builder: (context, value, child) {
              return Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: value,
                      backgroundColor: context.cqCardSecondary,
                      valueColor: AlwaysStoppedAnimation(AppColors.neonCyan),
                      minHeight: 3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'LOADING SYSTEM... ${(value * 100).toInt()}%',
                    style: TextStyle(
                      fontFamily: 'Share Tech Mono',
                      fontSize: 10,
                      color: context.cqTextMuted,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
