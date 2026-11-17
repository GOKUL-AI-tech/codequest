import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_theme.dart';

/// A shimmer-based skeleton loading placeholder.
///
/// Usage:
/// ```dart
/// LoadingSkeleton(width: double.infinity, height: 16, radius: 8)
/// ```
class LoadingSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final double radius;

  const LoadingSkeleton({
    super.key,
    this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.cqSurface,
      highlightColor: context.cqCard,
      period: Duration(milliseconds: 1400),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.cqSurface,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

/// A full card skeleton placeholder (icon + two lines of text).
class LoadingCardSkeleton extends StatelessWidget {
  final double? width;
  final double height;

  const LoadingCardSkeleton({super.key, this.width, this.height = 90});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.cqSurface,
      highlightColor: context.cqCard,
      period: Duration(milliseconds: 1400),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: context.cqSurface,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            // Icon placeholder
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.cqCard,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(width: 12),
            // Text placeholders
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.cqCard,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    height: 11,
                    width: 140,
                    decoration: BoxDecoration(
                      color: context.cqCard,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A grid skeleton for displaying multiple card placeholders.
class SkeletonGrid extends StatelessWidget {
  final int count;
  final double childAspectRatio;
  final int crossAxisCount;

  const SkeletonGrid({
    super.key,
    this.count = 6,
    this.childAspectRatio = 1.1,
    this.crossAxisCount = 2,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: count,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: context.cqSurface,
        highlightColor: context.cqCard,
        child: Container(
          decoration: BoxDecoration(
            color: context.cqSurface,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

/// A skeleton list tile (icon + 2 text lines).
class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.cqSurface,
      highlightColor: context.cqCard,
      period: const Duration(milliseconds: 1400),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: context.cqCard,
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: context.cqCard,
                      borderRadius: BorderRadius.circular(7),
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    height: 11,
                    width: 180,
                    decoration: BoxDecoration(
                      color: context.cqCard,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
