import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingSlide {
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradientColors;
  final String description;

  const OnboardingSlide({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradientColors,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingSlide> _slides = const [
    OnboardingSlide(
      title: 'LEARN TO CODE\nLIKE A GAME',
      subtitle: 'Your coding journey starts here',
      emoji: '🎮',
      gradientColors: [Color(0xFF7B2FBE), Color(0xFF00B4DB)],
      description: 'Master programming with missions, boss battles, and epic rewards. Coding has never been this addictive.',
    ),
    OnboardingSlide(
      title: 'LEVEL UP\nYOUR SKILLS',
      subtitle: 'XP, ranks, and achievements',
      emoji: '⚡',
      gradientColors: [Color(0xFFBF00FF), Color(0xFF00F5FF)],
      description: 'Earn XP, unlock achievements, climb the leaderboard, and become a Code Legend.',
    ),
    OnboardingSlide(
      title: 'BATTLE OTHER\nCODERS',
      subtitle: 'Real-time coding battles',
      emoji: '⚔️',
      gradientColors: [Color(0xFFFF6B00), Color(0xFFFF006E)],
      description: 'Challenge friends and strangers in live coding battles. Prove you\'re the fastest coder.',
    ),
    OnboardingSlide(
      title: 'AI MENTOR\nALWAYS READY',
      subtitle: 'Your personal coding guide',
      emoji: '🤖',
      gradientColors: [Color(0xFF00B09B), Color(0xFF39FF14)],
      description: 'Stuck on a problem? Your AI mentor explains concepts, fixes bugs, and keeps you motivated.',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _complete();
    }
  }

  Future<void> _complete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(AppConstants.kOnboardingDone, true);
    if (mounted) context.go(AppRoutes.characterSelect);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView.builder(
            controller: _pageController,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _slides.length,
            itemBuilder: (context, index) => _OnboardingPage(slide: _slides[index]),
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    final slide = _slides[_currentPage];
    return Container(
      padding: EdgeInsets.fromLTRB(32, 24, 32, 48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.transparent, context.cqBg],
        ),
      ),
      child: Column(
        children: [
          // Dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_slides.length, (i) {
              final isActive = i == _currentPage;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: isActive ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  gradient: isActive
                      ? LinearGradient(colors: slide.gradientColors)
                      : null,
                  color: isActive ? null : context.cqTextMuted,
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          // Next / Get Started button
          GestureDetector(
            onTap: _nextPage,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(colors: slide.gradientColors),
                boxShadow: [
                  BoxShadow(
                    color: slide.gradientColors.first.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _currentPage == _slides.length - 1 ? 'GET STARTED' : 'NEXT',
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          // Skip button
          if (_currentPage < _slides.length - 1)
            TextButton(
              onPressed: _complete,
              child: Text(
                'Skip',
                style: TextStyle(
                  color: context.cqTextSecondary,
                  fontFamily: 'Rajdhani',
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
            ),
          // Login link
          TextButton(
            onPressed: () => context.go(AppRoutes.login),
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 15),
                children: [
                  TextSpan(text: 'Already a coder? ', style: TextStyle(color: context.cqTextSecondary)),
                  TextSpan(text: 'Login', style: TextStyle(color: AppColors.neonCyan, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingSlide slide;
  const _OnboardingPage({required this.slide});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(color: context.cqBg),
      child: Stack(
        children: [
          // Gradient orb background
          Positioned(
            top: -100,
            left: -80,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    slide.gradientColors.first.withOpacity(0.2),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    slide.gradientColors.last.withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.fromLTRB(32, size.height * 0.12, 32, 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Emoji icon
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: slide.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: slide.gradientColors.first.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(slide.emoji, style: const TextStyle(fontSize: 36)),
                  ),
                )
                    .animate()
                    .scale(duration: 600.ms, curve: Curves.elasticOut)
                    .fadeIn(),

                const SizedBox(height: 40),

                // Subtitle
                Text(
                  slide.subtitle.toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Share Tech Mono',
                    fontSize: 12,
                    color: slide.gradientColors.last,
                    letterSpacing: 3,
                  ),
                )
                    .animate(delay: 100.ms)
                    .fadeIn(duration: 400.ms)
                    .slideX(begin: -0.2),

                const SizedBox(height: 12),

                // Title
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: slide.gradientColors,
                  ).createShader(bounds),
                  child: Text(
                    slide.title,
                    style: const TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.2,
                      letterSpacing: 1,
                    ),
                  ),
                )
                    .animate(delay: 200.ms)
                    .fadeIn(duration: 500.ms)
                    .slideX(begin: -0.3),

                const SizedBox(height: 24),

                // Description
                Text(
                  slide.description,
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 17,
                    color: context.cqTextSecondary,
                    height: 1.6,
                  ),
                )
                    .animate(delay: 350.ms)
                    .fadeIn(duration: 500.ms)
                    .slideY(begin: 0.2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
