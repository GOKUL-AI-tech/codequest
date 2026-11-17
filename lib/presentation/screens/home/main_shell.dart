import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/common/game_icon_badge.dart';
import '../../../core/utils/responsive.dart';
import '../../../l10n/app_localizations.dart';

// ─── Nav items ────────────────────────────────────────────────────────────────

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}

List<_NavItem> _buildNavItems(AppLocalizations l10n) => [
  _NavItem(icon: Icons.home_outlined,          activeIcon: Icons.home,            label: l10n.navHome,    route: AppRoutes.home),
  _NavItem(icon: Icons.public_outlined,         activeIcon: Icons.public,          label: l10n.navLearn,   route: AppRoutes.worlds),
  _NavItem(icon: Icons.sports_esports_outlined, activeIcon: Icons.sports_esports,  label: l10n.navArena,   route: AppRoutes.arena),
  _NavItem(icon: Icons.leaderboard_outlined,    activeIcon: Icons.leaderboard,     label: l10n.navRanks,   route: AppRoutes.leaderboard),
  _NavItem(icon: Icons.person_outline,          activeIcon: Icons.person,          label: l10n.navProfile, route: AppRoutes.profile),
];

// ─── Shell ────────────────────────────────────────────────────────────────────

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  int _getIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.home))        return 0;
    if (location.startsWith(AppRoutes.worlds))      return 1;
    if (location.startsWith(AppRoutes.arena))       return 2;
    if (location.startsWith(AppRoutes.leaderboard)) return 3;
    if (location.startsWith(AppRoutes.profile))     return 4;
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    const routes = [
      AppRoutes.home,
      AppRoutes.worlds,
      AppRoutes.arena,
      AppRoutes.leaderboard,
      AppRoutes.profile,
    ];
    context.go(routes[index]);
  }

  @override
  Widget build(BuildContext context) {
    final index = _getIndex(context);
    final l10n = AppLocalizations.of(context);
    final navItems = _buildNavItems(l10n);

    // ── Tablet / Web: side navigation rail ──────────────────────────────────
    if (isTablet(context)) {
      return Scaffold(
        body: Row(
          children: [
            _SideNavRail(
              currentIndex: index,
              onTap: (i) => _onTap(context, i),
              navItems: navItems,
            ),
            // Thin divider
            Container(width: 1, color: const Color(0xFF1E2A3F)),
            // Content area — centred + max-width on desktop
            Expanded(
              child: isDesktop(context)
                  ? Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: maxContentWidth(context)),
                        child: child,
                      ),
                    )
                  : child,
            ),
          ],
        ),
      );
    }

    // ── Phone: bottom nav bar ────────────────────────────────────────────────
    return Scaffold(
      body: child,
      bottomNavigationBar: _CyberNavBar(
        currentIndex: index,
        onTap: (i) => _onTap(context, i),
        navItems: navItems,
      ),
    );
  }
}

// ─── Side Navigation Rail (Tablet / Web) ─────────────────────────────────────

class _SideNavRail extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<_NavItem> navItems;
  const _SideNavRail({required this.currentIndex, required this.onTap, required this.navItems});

  @override
  Widget build(BuildContext context) {
    final wide = isDesktop(context);

    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      width: wide ? 220 : 72,
      color: context.cqBgSecondary,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo / brand
            Padding(
              padding: EdgeInsets.fromLTRB(wide ? 20 : 14, 20, 14, 24),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: AppColors.cyberpunkGradient,
                    ),
                    child: const Center(
                      child: Text(
                        '</>',
                        style: TextStyle(
                          fontFamily: 'Share Tech Mono',
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  if (wide) ...[
                    const SizedBox(width: 12),
                    Text(
                      'CodeQuest',
                      style: TextStyle(
                        fontFamily: 'Orbitron',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: context.cqTextPrimary,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Divider(color: Color(0xFF1E2A3F), height: 1),
            const SizedBox(height: 12),

            // Nav items
            ...navItems.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final isActive = i == currentIndex;
              final isArena = i == 2;

              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.symmetric(
                      horizontal: wide ? 12 : 8, vertical: 3),
                  padding: EdgeInsets.symmetric(
                      horizontal: wide ? 12 : 8, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: isArena && isActive ? AppColors.fireGradient : null,
                    color: !isArena && isActive
                        ? AppColors.neonCyan.withOpacity(0.1)
                        : isArena && !isActive
                            ? AppColors.neonPurple.withOpacity(0.08)
                            : Colors.transparent,
                    border: isActive && !isArena
                        ? Border.all(
                            color: AppColors.neonCyan.withOpacity(0.3))
                        : null,
                  ),
                  child: Row(
                    children: [
                      GameIconBadge(
                        icon: isActive ? item.activeIcon : item.icon,
                        color: isArena
                            ? (isActive ? Colors.white : AppColors.neonPurple)
                            : (isActive ? AppColors.neonCyan : context.cqTextMuted),
                        active: isActive,
                        size: 32,
                      ),
                      if (wide) ...[
                        const SizedBox(width: 12),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 15,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isArena
                                ? (isActive ? Colors.white : AppColors.neonPurple)
                                : (isActive ? AppColors.neonCyan : context.cqTextMuted),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),

            const Spacer(),

            // Extra links on wide desktop sidebar
            if (wide) ...[
              const Divider(color: Color(0xFF1E2A3F), height: 1),
              _SidebarShortcut(
                icon: Icons.play_circle_outline,
                label: 'Playground',
                onTap: () => GoRouter.of(context).push(AppRoutes.codePlayground),
              ),
              _SidebarShortcut(
                icon: Icons.map_outlined,
                label: 'Roadmap',
                onTap: () => GoRouter.of(context).push(AppRoutes.roadmap),
              ),
              _SidebarShortcut(
                icon: Icons.quiz_outlined,
                label: 'Interview Prep',
                onTap: () => GoRouter.of(context).push(AppRoutes.interviewPrep),
              ),
              const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _SidebarShortcut extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SidebarShortcut({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(icon, color: context.cqTextMuted, size: 18),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Rajdhani',
                fontSize: 13,
                color: context.cqTextMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Bottom Nav Bar (Phone) ───────────────────────────────────────────────────

class _CyberNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<_NavItem> navItems;
  const _CyberNavBar({required this.currentIndex, required this.onTap, required this.navItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cqBgSecondary,
        border: const Border(top: BorderSide(color: Color(0xFF1E2A3F), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: navItems.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              final isActive = i == currentIndex;
              final isArena = i == 2;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isArena)
                        _ArenaButton(isActive: isActive)
                      else ...[
                        GameIconBadge(
                          icon: isActive ? item.activeIcon : item.icon,
                          color: isActive ? AppColors.neonCyan : context.cqTextMuted,
                          active: isActive,
                          hex: true,
                          size: 40,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontFamily: 'Rajdhani',
                            fontSize: 11,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            color: isActive ? AppColors.neonCyan : context.cqTextMuted,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class _ArenaButton extends StatelessWidget {
  final bool isActive;
  const _ArenaButton({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isActive ? AppColors.fireGradient : AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: (isActive ? AppColors.neonPink : AppColors.neonPurple)
                .withOpacity(0.4),
            blurRadius: 12,
          ),
        ],
      ),
      child: const Icon(Icons.sports_esports, color: Colors.white, size: 26),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(duration: 2000.ms, color: Colors.white.withOpacity(0.2));
  }
}
