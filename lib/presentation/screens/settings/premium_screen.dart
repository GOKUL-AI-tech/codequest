import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/cyber_snackbar.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  int _selectedPlan = 1; // 0=monthly, 1=yearly

  static const _features = [
    ('♾️', 'Unlimited Lives', 'Never wait for lives to refill'),
    ('🤖', 'Unlimited AI Mentor', 'Ask ALEX anything, anytime'),
    ('⚡', 'Double XP', 'Earn 2× XP on every lesson'),
    ('🏆', 'Exclusive Arenas', 'Access premium battle arenas'),
    ('🎨', 'Premium Skins', 'Unlock all character skins & themes'),
    ('📊', 'Advanced Code DNA', 'Full analytics & skill breakdown'),
    ('🚫', 'Ad-Free', 'Zero interruptions, pure focus'),
    ('☁️', 'Cloud Sync', 'Progress synced across all devices'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Hero header
          SliverToBoxAdapter(child: _buildHeader(context)),

          // Plan selector
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: _buildPlanSelector(),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          ),

          // Features
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EVERYTHING INCLUDED',
                    style: TextStyle(
                      fontFamily: 'Share Tech Mono',
                      fontSize: 11,
                      color: context.cqTextMuted,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 14),
                  ..._features.asMap().entries.map((e) => _FeatureRow(
                        emoji: e.value.$1,
                        title: e.value.$2,
                        subtitle: e.value.$3,
                        delay: (e.key * 50).ms,
                      )),
                ],
              ),
            ),
          ),

          // CTA
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 32, 20, 12),
              child: _buildCTA(context),
            ).animate().fadeIn(delay: 600.ms),
          ),

          // Disclaimer
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
              child: Text(
                'Cancel anytime. Billed through Google Play.\nSubscription renews automatically unless cancelled 24 hours before renewal.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 11,
                  color: context.cqTextMuted,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 260,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A0533), Color(0xFF0A1628)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 12,
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),

          // Crown + title
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFF8C00)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.neonYellow.withOpacity(0.4),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('👑', style: TextStyle(fontSize: 38)),
                  ),
                )
                    .animate()
                    .scale(duration: 700.ms, curve: Curves.elasticOut),
                const SizedBox(height: 16),
                const Text(
                  'CODEQUEST PREMIUM',
                  style: TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ).animate(delay: 200.ms).fadeIn(),
                const SizedBox(height: 6),
                Text(
                  'Level up without limits',
                  style: TextStyle(
                    fontFamily: 'Rajdhani',
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ).animate(delay: 300.ms).fadeIn(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanSelector() {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.cqCard,
        border: Border.all(color: context.cqSurface),
      ),
      child: Row(
        children: [
          _PlanCard(
            label: 'MONTHLY',
            price: '₹299',
            period: '/month',
            badge: null,
            isSelected: _selectedPlan == 0,
            onTap: () => setState(() => _selectedPlan = 0),
          ),
          _PlanCard(
            label: 'YEARLY',
            price: '₹1,999',
            period: '/year',
            badge: 'SAVE 44%',
            isSelected: _selectedPlan == 1,
            onTap: () => setState(() => _selectedPlan = 1),
          ),
        ],
      ),
    );
  }

  Widget _buildCTA(BuildContext context) {
    final isYearly = _selectedPlan == 1;
    return GestureDetector(
      onTap: () {
        CyberSnackbar.showSuccess(
          context,
          isYearly
              ? '🚀 Starting yearly plan — ₹1,999/year'
              : '🚀 Starting monthly plan — ₹299/month',
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: AppColors.goldGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.neonYellow.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            const Text(
              'START PREMIUM',
              style: TextStyle(
                fontFamily: 'Orbitron',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isYearly ? '₹1,999 / year · ≈ ₹167/month' : '₹299 / month',
              style: const TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final String label;
  final String price;
  final String period;
  final String? badge;
  final bool isSelected;
  final VoidCallback onTap;

  const _PlanCard({
    required this.label,
    required this.price,
    required this.period,
    required this.badge,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isSelected ? AppColors.goldGradient : null,
            color: isSelected ? null : Colors.transparent,
          ),
          child: Column(
            children: [
              if (badge != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isSelected
                        ? Colors.black.withOpacity(0.2)
                        : AppColors.neonGreen.withOpacity(0.15),
                  ),
                  child: Text(
                    badge!,
                    style: TextStyle(
                      fontFamily: 'Orbitron',
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.black : AppColors.neonGreen,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 11,
                  color: isSelected ? Colors.black : context.cqTextMuted,
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 4),
              Text(
                price,
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.black : context.cqTextPrimary,
                ),
              ),
              Text(
                period,
                style: TextStyle(
                  fontFamily: 'Rajdhani',
                  fontSize: 12,
                  color: isSelected ? Colors.black54 : context.cqTextMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Duration delay;

  const _FeatureRow({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: context.cqCard,
              border: Border.all(color: AppColors.neonYellow.withOpacity(0.2)),
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.cqTextPrimary,
                    )),
                Text(subtitle,
                    style: TextStyle(
                      fontFamily: 'Rajdhani',
                      fontSize: 12,
                      color: context.cqTextMuted,
                    )),
              ],
            ),
          ),
          const Icon(Icons.check_circle, color: AppColors.neonGreen, size: 20),
        ],
      ),
    ).animate(delay: delay).fadeIn().slideX(begin: 0.1);
  }
}
