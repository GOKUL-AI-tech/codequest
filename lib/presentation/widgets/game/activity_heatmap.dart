import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';

// ─── Provider ─────────────────────────────────────────────────────────────────

final activityHeatmapProvider = FutureProvider<Map<String, int>>((ref) async {
  final userId = Supabase.instance.client.auth.currentUser?.id;
  if (userId == null) return {};

  final since = DateTime.now().subtract(const Duration(days: 90));

  final data = await Supabase.instance.client
      .from('user_progress')
      .select('completed_at, xp_earned')
      .eq('user_id', userId)
      .eq('is_completed', true)
      .gte('completed_at', since.toIso8601String())
      .order('completed_at');

  final Map<String, int> dayXp = {};
  for (final row in data as List) {
    if (row['completed_at'] == null) continue;
    final dt = DateTime.parse(row['completed_at'] as String);
    final key = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    dayXp[key] = (dayXp[key] ?? 0) + ((row['xp_earned'] as num?)?.toInt() ?? 0);
  }
  return dayXp;
});

// ─── Widget ───────────────────────────────────────────────────────────────────

class ActivityHeatmap extends ConsumerWidget {
  const ActivityHeatmap({super.key});

  static const _days = 91; // ~13 weeks
  static const _cols = 13;
  static const _rows = 7;

  Color _cellColor(int xp) {
    if (xp == 0) return const Color(0xFF1A2235);
    if (xp < 50) return AppColors.neonCyan.withOpacity(0.25);
    if (xp < 150) return AppColors.neonCyan.withOpacity(0.50);
    if (xp < 300) return AppColors.neonCyan.withOpacity(0.75);
    return AppColors.neonCyan;
  }

  String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final heatAsync = ref.watch(activityHeatmapProvider);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.cqCard,
        border: Border.all(color: context.cqSurface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CODE PULSE',
                style: TextStyle(
                  fontFamily: 'Orbitron',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: context.cqTextMuted,
                  letterSpacing: 2,
                ),
              ),
              Text(
                'Last 90 days',
                style: TextStyle(
                  fontFamily: 'Share Tech Mono',
                  fontSize: 11,
                  color: context.cqTextMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          heatAsync.when(
            loading: () => const SizedBox(
              height: 80,
              child: Center(
                  child: CircularProgressIndicator(
                      color: AppColors.neonCyan, strokeWidth: 2)),
            ),
            error: (_, __) => const SizedBox(),
            data: (dayXp) {
              // Build grid from today backwards
              final today = DateTime.now();
              final cells = <DateTime>[];
              for (int i = _days - 1; i >= 0; i--) {
                cells.add(today.subtract(Duration(days: i)));
              }

              // Pad start so first column aligns to Monday
              final firstDay = cells.first;
              final paddingDays = (firstDay.weekday - 1) % 7;
              final paddedCells = [
                ...List.generate(paddingDays, (_) => null),
                ...cells.map((d) => d as DateTime?),
              ];

              // Total XP this period
              final totalXp = dayXp.values.fold(0, (a, b) => a + b);
              final activeDays = dayXp.values.where((v) => v > 0).length;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _StatChip(label: 'Total XP', value: '$totalXp', color: AppColors.neonCyan),
                      const SizedBox(width: 10),
                      _StatChip(label: 'Active Days', value: '$activeDays', color: AppColors.neonGreen),
                      const SizedBox(width: 10),
                      _StatChip(
                        label: 'Avg/Day',
                        value: activeDays > 0 ? '${(totalXp / activeDays).round()}' : '0',
                        color: AppColors.neonYellow,
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Day labels (Mon–Sun)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Weekday labels
                      Column(
                        children: ['M', 'T', 'W', 'T', 'F', 'S', 'S']
                            .map((d) => SizedBox(
                                  height: 11,
                                  child: Text(
                                    d,
                                    style: TextStyle(
                                      fontFamily: 'Share Tech Mono',
                                      fontSize: 8,
                                      color: context.cqTextMuted,
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                      const SizedBox(width: 4),

                      // Grid
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: _buildGrid(paddedCells, dayXp),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // Legend
                  Row(
                    children: [
                      Text(
                        'Less',
                        style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 9,
                            color: context.cqTextMuted),
                      ),
                      const SizedBox(width: 4),
                      ...['0', '50', '150', '300', '∞'].asMap().entries.map(
                            (e) => Container(
                              width: 11,
                              height: 11,
                              margin: const EdgeInsets.only(left: 3),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: _cellColor(
                                    [0, 25, 100, 200, 400][e.key]),
                              ),
                            ),
                          ),
                      const SizedBox(width: 4),
                      Text(
                        'More',
                        style: TextStyle(
                            fontFamily: 'Share Tech Mono',
                            fontSize: 9,
                            color: context.cqTextMuted),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(List<DateTime?> paddedCells, Map<String, int> dayXp) {
    // Arrange into columns (weeks)
    final cols = <List<DateTime?>>[];
    for (int i = 0; i < paddedCells.length; i += 7) {
      final end = (i + 7).clamp(0, paddedCells.length);
      final col = paddedCells.sublist(i, end);
      while (col.length < 7) col.add(null);
      cols.add(col);
    }

    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: cols.map((col) {
        return Column(
          children: col.map((dt) {
            if (dt == null) {
              return const SizedBox(width: 11, height: 11,
                  child: SizedBox());
            }
            final key = _dateKey(dt);
            final xp = dayXp[key] ?? 0;
            final isToday = key == todayKey;

            return Tooltip(
              message: xp > 0 ? '$xp XP on ${_formatDate(dt)}' : _formatDate(dt),
              child: Container(
                width: 11,
                height: 11,
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2),
                  color: _cellColor(xp),
                  border: isToday
                      ? Border.all(color: AppColors.neonCyan, width: 1)
                      : null,
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime dt) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[dt.month - 1]} ${dt.day}';
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip(
      {required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.08),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Orbitron',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Rajdhani',
              fontSize: 10,
              color: context.cqTextMuted,
            ),
          ),
        ],
      ),
    );
  }
}
