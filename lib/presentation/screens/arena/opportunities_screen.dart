import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';

// ─── Data models ──────────────────────────────────────────────────────────────

enum OpportunityType { interview, miniProject, internship }

class _Opportunity {
  final String id, title, company, companyLogo, description;
  final OpportunityType type;
  final int requiredRankIndex; // index in AppConstants.ranks
  final int durationMinutes;
  final List<String> skills;
  final String reward;
  final bool isFeatured;

  const _Opportunity({
    required this.id, required this.title, required this.company,
    required this.companyLogo, required this.description,
    required this.type, required this.requiredRankIndex,
    required this.durationMinutes, required this.skills,
    required this.reward, this.isFeatured = false,
  });

  bool isUnlocked(int userRankIndex) => userRankIndex >= requiredRankIndex;
}

// ─── Mock opportunities ───────────────────────────────────────────────────────

final _opportunities = [
  _Opportunity(
    id: 'op1', title: 'Junior Dev Interview Prep',
    company: 'TechStart Inc.', companyLogo: '🚀',
    description: 'A structured 30-min mock interview covering DS&A basics, '
        'problem solving, and code quality. Get real recruiter feedback.',
    type: OpportunityType.interview, requiredRankIndex: 1,
    durationMinutes: 30, reward: '+500 XP + Certificate',
    skills: ['Arrays', 'Loops', 'Functions'], isFeatured: true,
  ),
  _Opportunity(
    id: 'op2', title: 'Build a REST API Mini-Project',
    company: 'CloudBase Co.', companyLogo: '☁️',
    description: 'Design and implement a simple REST API endpoint. '
        'Reviewed by a senior engineer with rubric-based scoring.',
    type: OpportunityType.miniProject, requiredRankIndex: 2,
    durationMinutes: 60, reward: '+1200 XP + Portfolio Badge',
    skills: ['APIs', 'OOP', 'Error Handling'],
  ),
  _Opportunity(
    id: 'op3', title: 'Algorithm Deep-Dive Interview',
    company: 'AlgoWorks', companyLogo: '🧠',
    description: 'Two rounds: one theory (Big-O, sorting) and one live coding '
        'problem solved in real time with a senior interviewer.',
    type: OpportunityType.interview, requiredRankIndex: 3,
    durationMinutes: 45, reward: '+2000 XP + Fast-track Referral',
    skills: ['Sorting', 'Binary Search', 'Recursion'],
  ),
  _Opportunity(
    id: 'op4', title: 'Data Pipeline Mini-Project',
    company: 'DataFlow Labs', companyLogo: '📊',
    description: 'Build a small data ingestion pipeline. Focus on clean code, '
        'test coverage, and performance. Reviewed by ML engineers.',
    type: OpportunityType.miniProject, requiredRankIndex: 4,
    durationMinutes: 90, reward: '+3500 XP + Interview Invitation',
    skills: ['Python', 'Data Structures', 'Testing'],
  ),
  _Opportunity(
    id: 'op5', title: 'Systems Design Interview',
    company: 'ScaleUp Corp.', companyLogo: '⚙️',
    description: 'Design a scalable system with a staff engineer. Covers DB '
        'design, caching, load balancing, and trade-off discussion.',
    type: OpportunityType.interview, requiredRankIndex: 5,
    durationMinutes: 60, reward: '+5000 XP + Internship Offer',
    skills: ['System Design', 'Databases', 'Architecture'], isFeatured: true,
  ),
  _Opportunity(
    id: 'op6', title: 'Full-Stack Internship Assessment',
    company: 'BuildFast', companyLogo: '🏗️',
    description: 'A 4-hour assessment: build a full mini-app with frontend, '
        'backend, and tests. Top performers get internship offers.',
    type: OpportunityType.internship, requiredRankIndex: 6,
    durationMinutes: 240, reward: '+10000 XP + Paid Internship',
    skills: ['Full-Stack', 'Testing', 'Deployment'],
  ),
];

// ─── Screen ───────────────────────────────────────────────────────────────────

class OpportunitiesScreen extends StatefulWidget {
  const OpportunitiesScreen({super.key});

  @override
  State<OpportunitiesScreen> createState() => _OpportunitiesScreenState();
}

class _OpportunitiesScreenState extends State<OpportunitiesScreen>
    with SingleTickerProviderStateMixin {
  // Simulated user rank index (0-7 matching AppConstants.ranks)
  final int _userRankIndex = 2; // Bug Hunter level
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabController.dispose(); super.dispose(); }

  List<_Opportunity> get _unlocked =>
      _opportunities.where((o) => o.isUnlocked(_userRankIndex)).toList();
  List<_Opportunity> get _locked =>
      _opportunities.where((o) => !o.isUnlocked(_userRankIndex)).toList();
  List<_Opportunity> get _featured =>
      _opportunities.where((o) => o.isFeatured).toList();

  @override
  Widget build(BuildContext context) {
    final rank = AppConstants.ranks[_userRankIndex];
    final nextRank = _userRankIndex < AppConstants.ranks.length - 1
        ? AppConstants.ranks[_userRankIndex + 1]
        : null;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          // ── App bar ──────────────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: AppColors.neonCyan, size: 18),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text('OPPORTUNITIES',
                style: TextStyle(fontFamily: 'Orbitron', fontSize: 15,
                    fontWeight: FontWeight.bold)),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.neonCyan,
              labelStyle: const TextStyle(fontFamily: 'Orbitron', fontSize: 10,
                  fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontFamily: 'Rajdhani', fontSize: 11),
              tabs: const [
                Tab(text: 'UNLOCKED'),
                Tab(text: 'LOCKED'),
                Tab(text: 'FEATURED'),
              ],
            ),
          ),

          // ── Rank progress banner ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    Color(rank['color'] as int).withOpacity(0.2),
                    context.cqCard,
                  ],
                ),
                border: Border.all(color: Color(rank['color'] as int).withOpacity(0.4)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(rank['icon'] as String,
                          style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(rank['title'] as String,
                                style: TextStyle(fontFamily: 'Orbitron', fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(rank['color'] as int))),
                            Text('${_unlocked.length} opportunities unlocked',
                                style: TextStyle(fontFamily: 'Rajdhani',
                                    fontSize: 13, color: context.cqTextSecondary)),
                          ],
                        ),
                      ),
                      // XP to next rank
                      if (nextRank != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(nextRank['icon'] as String,
                                style: const TextStyle(fontSize: 22)),
                            Text('Next: ${nextRank['title']}',
                                style: TextStyle(fontFamily: 'Rajdhani',
                                    fontSize: 10, color: context.cqTextMuted)),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Rank progression timeline
                  SizedBox(
                    height: 56,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: AppConstants.ranks.length,
                      itemBuilder: (_, i) {
                        final r = AppConstants.ranks[i];
                        final isReached = i <= _userRankIndex;
                        final isCurrent = i == _userRankIndex;
                        final rColor = Color(r['color'] as int);
                        return Row(
                          children: [
                            Column(
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  width: isCurrent ? 36 : 28,
                                  height: isCurrent ? 36 : 28,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isReached
                                        ? rColor.withOpacity(0.2)
                                        : context.cqSurface,
                                    border: Border.all(
                                      color: isReached ? rColor : context.cqTextMuted.withOpacity(0.3),
                                      width: isCurrent ? 2.5 : 1.5,
                                    ),
                                    boxShadow: isCurrent
                                        ? [BoxShadow(color: rColor.withOpacity(0.4), blurRadius: 10)]
                                        : [],
                                  ),
                                  child: Center(
                                    child: Text(r['icon'] as String,
                                        style: TextStyle(fontSize: isCurrent ? 18 : 13)),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  (r['title'] as String).split(' ').first,
                                  style: TextStyle(
                                    fontFamily: 'Rajdhani', fontSize: 8,
                                    color: isReached ? rColor : context.cqTextMuted,
                                  ),
                                ),
                              ],
                            ),
                            if (i < AppConstants.ranks.length - 1)
                              Container(
                                width: 20, height: 2,
                                margin: EdgeInsets.only(bottom: 14),
                                color: i < _userRankIndex
                                    ? Color(AppConstants.ranks[i + 1]['color'] as int)
                                        .withOpacity(0.4)
                                    : context.cqSurface,
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.1),
          ),
        ],

        body: TabBarView(
          controller: _tabController,
          children: [
            _OpportunityList(items: _unlocked, userRankIndex: _userRankIndex),
            _OpportunityList(items: _locked, userRankIndex: _userRankIndex, showLockInfo: true),
            _OpportunityList(items: _featured, userRankIndex: _userRankIndex),
          ],
        ),
      ),
    );
  }
}

// ─── Opportunity list ─────────────────────────────────────────────────────────

class _OpportunityList extends StatelessWidget {
  final List<_Opportunity> items;
  final int userRankIndex;
  final bool showLockInfo;

  const _OpportunityList({
    required this.items, required this.userRankIndex, this.showLockInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏆', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(
              showLockInfo
                  ? 'All opportunities unlocked!'
                  : 'Keep levelling up to unlock opportunities',
              style: TextStyle(fontFamily: 'Rajdhani', fontSize: 16,
                  color: context.cqTextSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
      itemCount: items.length,
      itemBuilder: (ctx, i) => _OpportunityCard(
        opportunity: items[i],
        userRankIndex: userRankIndex,
        showLockInfo: showLockInfo,
      ).animate(delay: Duration(milliseconds: i * 70)).fadeIn().slideX(begin: 0.05),
    );
  }
}

// ─── Opportunity card ─────────────────────────────────────────────────────────

class _OpportunityCard extends StatelessWidget {
  final _Opportunity opportunity;
  final int userRankIndex;
  final bool showLockInfo;

  const _OpportunityCard({
    required this.opportunity, required this.userRankIndex, required this.showLockInfo,
  });

  Color get _typeColor => switch (opportunity.type) {
        OpportunityType.interview   => AppColors.neonCyan,
        OpportunityType.miniProject => const Color(0xFF7B2FFF),
        OpportunityType.internship  => AppColors.neonYellow,
      };

  String get _typeLabel => switch (opportunity.type) {
        OpportunityType.interview   => 'INTERVIEW',
        OpportunityType.miniProject => 'MINI PROJECT',
        OpportunityType.internship  => 'INTERNSHIP',
      };

  String get _typeEmoji => switch (opportunity.type) {
        OpportunityType.interview   => '🎙️',
        OpportunityType.miniProject => '💻',
        OpportunityType.internship  => '🏢',
      };

  @override
  Widget build(BuildContext context) {
    final isUnlocked = opportunity.isUnlocked(userRankIndex);
    final reqRank = AppConstants.ranks[opportunity.requiredRankIndex];

    return GestureDetector(
      onTap: isUnlocked
          ? () => _showApplySheet(context)
          : () => _showLockedInfo(context, reqRank),
      child: Container(
        margin: EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.cqCard,
          border: Border.all(
            color: isUnlocked
                ? _typeColor.withOpacity(0.35)
                : context.cqTextMuted.withOpacity(0.15),
            width: 1.5,
          ),
          boxShadow: isUnlocked
              ? [BoxShadow(color: _typeColor.withOpacity(0.1), blurRadius: 16)]
              : [],
        ),
        child: Stack(
          children: [
            // Featured glow
            if (opportunity.isFeatured)
              Positioned(
                top: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20), bottomLeft: Radius.circular(12)),
                    gradient: AppColors.cyberpunkGradient,
                  ),
                  child: const Text('⭐ FEATURED',
                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 8,
                          color: Colors.white, letterSpacing: 1)),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Company + type
                  Row(
                    children: [
                      Text(opportunity.companyLogo, style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(opportunity.company,
                                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                                    color: isUnlocked
                                        ? _typeColor.withOpacity(0.9)
                                        : context.cqTextMuted)),
                            Text(opportunity.title,
                                style: TextStyle(fontFamily: 'Orbitron', fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isUnlocked
                                        ? context.cqTextPrimary
                                        : context.cqTextMuted)),
                          ],
                        ),
                      ),
                      // Type badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: isUnlocked
                              ? _typeColor.withOpacity(0.15)
                              : context.cqSurface,
                          border: Border.all(
                              color: isUnlocked
                                  ? _typeColor.withOpacity(0.4)
                                  : context.cqTextMuted.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(_typeEmoji, style: const TextStyle(fontSize: 10)),
                            SizedBox(width: 4),
                            Text(_typeLabel,
                                style: TextStyle(fontFamily: 'Orbitron', fontSize: 7,
                                    color: isUnlocked ? _typeColor : context.cqTextMuted,
                                    letterSpacing: 0.8)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),
                  Text(opportunity.description,
                      style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13,
                          color: isUnlocked ? context.cqTextSecondary : context.cqTextMuted,
                          height: 1.4),
                      maxLines: 2, overflow: TextOverflow.ellipsis),

                  const SizedBox(height: 10),
                  // Skills chips
                  Wrap(
                    spacing: 6, runSpacing: 6,
                    children: opportunity.skills.map((s) => Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: isUnlocked
                            ? _typeColor.withOpacity(0.08)
                            : context.cqSurface,
                        border: Border.all(
                            color: isUnlocked
                                ? _typeColor.withOpacity(0.25)
                                : context.cqTextMuted.withOpacity(0.15)),
                      ),
                      child: Text(s,
                          style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11,
                              color: isUnlocked ? _typeColor : context.cqTextMuted)),
                    )).toList(),
                  ),

                  SizedBox(height: 12),
                  // Footer
                  Row(
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 14, color: context.cqTextMuted.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text('${opportunity.durationMinutes} min',
                          style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                              color: context.cqTextMuted)),
                      SizedBox(width: 16),
                      Text('🎁 ${opportunity.reward}',
                          style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                              color: isUnlocked ? AppColors.neonYellow : context.cqTextMuted,
                              fontWeight: FontWeight.w600)),
                      const Spacer(),
                      if (!isUnlocked) ...[
                        Text(reqRank['icon'] as String,
                            style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text('Requires ${reqRank['title']}',
                            style: TextStyle(fontFamily: 'Rajdhani', fontSize: 11,
                                color: context.cqTextMuted)),
                      ] else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [_typeColor, _typeColor.withOpacity(0.6)]),
                          ),
                          child: const Text('APPLY NOW',
                              style: TextStyle(fontFamily: 'Orbitron', fontSize: 10,
                                  fontWeight: FontWeight.bold, color: Colors.white,
                                  letterSpacing: 1)),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Lock overlay
            if (!isUnlocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: context.cqBg.withOpacity(0.45),
                  ),
                  child: Center(
                    child: Icon(Icons.lock_rounded, color: context.cqTextMuted, size: 32),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showApplySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _ApplySheet(opportunity: opportunity),
    );
  }

  void _showLockedInfo(BuildContext context, Map<String, dynamic> reqRank) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: context.cqCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(reqRank['icon'] as String, style: const TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text('LOCKED',
                  style: TextStyle(fontFamily: 'Orbitron', fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(reqRank['color'] as int))),
              const SizedBox(height: 8),
              Text('Reach "${reqRank['title']}" rank to unlock this opportunity.',
                  style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14,
                      color: context.cqTextSecondary),
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Required XP: ${reqRank['minXp']}',
                  style: const TextStyle(fontFamily: 'Share Tech Mono', fontSize: 12,
                      color: AppColors.neonYellow)),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('GOT IT',
                    style: TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                        color: AppColors.neonCyan, letterSpacing: 1)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Apply sheet ──────────────────────────────────────────────────────────────

class _ApplySheet extends StatefulWidget {
  final _Opportunity opportunity;
  const _ApplySheet({required this.opportunity});

  @override
  State<_ApplySheet> createState() => _ApplySheetState();
}

class _ApplySheetState extends State<_ApplySheet> {
  bool _applied = false;

  @override
  Widget build(BuildContext context) {
    final opp = widget.opportunity;

    if (_applied) {
      return Container(
        height: 360,
        decoration: BoxDecoration(
          color: context.cqCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64))
                .animate().scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 16),
            const Text('APPLICATION SENT!',
                style: TextStyle(fontFamily: 'Orbitron', fontSize: 20,
                    fontWeight: FontWeight.bold, color: AppColors.neonGreen, letterSpacing: 2)),
            const SizedBox(height: 8),
            Text('${opp.company} will review your profile.',
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14,
                    color: context.cqTextSecondary)),
            const SizedBox(height: 4),
            Text('You\'ll be notified within 24 hours.',
                style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13,
                    color: context.cqTextMuted)),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.neonYellow.withOpacity(0.15),
                border: Border.all(color: AppColors.neonYellow.withOpacity(0.4)),
              ),
              child: Text('⭐ ${opp.reward}',
                  style: const TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                      color: AppColors.neonYellow, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CLOSE',
                  style: TextStyle(fontFamily: 'Orbitron', fontSize: 12,
                      color: context.cqTextSecondary)),
            ),
          ],
        ),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.72,
      decoration: BoxDecoration(
        color: context.cqCard,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF1E2A3F))),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: AppColors.neonCyan, size: 18),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(opp.companyLogo, style: const TextStyle(fontSize: 28)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(opp.title,
                          style: TextStyle(fontFamily: 'Orbitron', fontSize: 13,
                              fontWeight: FontWeight.bold, color: context.cqTextPrimary)),
                      Text(opp.company,
                          style: TextStyle(fontFamily: 'Rajdhani', fontSize: 12,
                              color: context.cqTextSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // What to expect
                  _SectionLabel('WHAT TO EXPECT'),
                  Text(opp.description,
                      style: TextStyle(fontFamily: 'Rajdhani', fontSize: 14,
                          color: context.cqTextSecondary, height: 1.5)),
                  const SizedBox(height: 20),

                  _SectionLabel('SKILLS ASSESSED'),
                  Wrap(
                    spacing: 8, runSpacing: 8,
                    children: opp.skills.map((s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: AppColors.cyberpunkGradient,
                      ),
                      child: Text(s, style: const TextStyle(fontFamily: 'Rajdhani',
                          fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                    )).toList(),
                  ),
                  const SizedBox(height: 20),

                  _SectionLabel('DETAILS'),
                  _DetailRow('⏱️', 'Duration', '${opp.durationMinutes} minutes'),
                  _DetailRow('🎁', 'Reward', opp.reward),
                  _DetailRow('📋', 'Format',
                      opp.type == OpportunityType.interview
                          ? 'Live session with recruiter'
                          : opp.type == OpportunityType.miniProject
                              ? 'Async submission, reviewed in 24h'
                              : 'Assessment + Interview'),
                  const SizedBox(height: 20),

                  _SectionLabel('SCORING RUBRIC'),
                  ...[
                    ('Problem Understanding', 0.25),
                    ('Code Quality', 0.30),
                    ('Efficiency', 0.25),
                    ('Communication', 0.20),
                  ].map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        SizedBox(width: 160,
                            child: Text(r.$1, style: TextStyle(
                                fontFamily: 'Rajdhani', fontSize: 13,
                                color: context.cqTextSecondary))),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: r.$2,
                              backgroundColor: context.cqSurface,
                              valueColor: const AlwaysStoppedAnimation(AppColors.neonCyan),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text('${(r.$2 * 100).round()}%',
                            style: const TextStyle(fontFamily: 'Orbitron', fontSize: 10,
                                color: AppColors.neonCyan)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),

          // Apply button
          Padding(
            padding: EdgeInsets.fromLTRB(20, 8, 20,
                MediaQuery.of(context).padding.bottom + 16),
            child: GestureDetector(
              onTap: () => setState(() => _applied = true),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: AppColors.cyberpunkGradient,
                  boxShadow: [
                    BoxShadow(color: AppColors.neonCyan.withOpacity(0.3), blurRadius: 20)
                  ],
                ),
                child: const Center(
                  child: Text('APPLY NOW  →',
                      style: TextStyle(fontFamily: 'Orbitron', fontSize: 14,
                          fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(text, style: TextStyle(fontFamily: 'Orbitron', fontSize: 11,
          fontWeight: FontWeight.bold, color: context.cqTextMuted, letterSpacing: 2)),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String emoji, label, value;
  const _DetailRow(this.emoji, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text('$label: ', style: TextStyle(fontFamily: 'Rajdhani', fontSize: 13,
              color: context.cqTextMuted)),
          Expanded(child: Text(value, style: TextStyle(fontFamily: 'Rajdhani',
              fontSize: 13, color: context.cqTextPrimary, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
