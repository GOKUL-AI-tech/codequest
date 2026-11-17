import 'package:flutter/material.dart';

/// Breakpoints
class Breakpoints {
  static const double phone = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

/// Returns true when the screen is tablet width or wider.
bool isTablet(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= Breakpoints.phone;

bool isDesktop(BuildContext context) =>
    MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

/// Responsive value helper.
T responsive<T>(BuildContext context, {required T phone, T? tablet, T? desktop}) {
  final w = MediaQuery.sizeOf(context).width;
  if (w >= Breakpoints.tablet && desktop != null) return desktop;
  if (w >= Breakpoints.phone && tablet != null) return tablet;
  return phone;
}

/// Padding that scales with screen size.
EdgeInsets responsivePadding(BuildContext context) {
  if (isDesktop(context)) return const EdgeInsets.symmetric(horizontal: 80);
  if (isTablet(context)) return const EdgeInsets.symmetric(horizontal: 40);
  return const EdgeInsets.symmetric(horizontal: 20);
}

/// Max content width for centering on large screens.
double maxContentWidth(BuildContext context) {
  if (isDesktop(context)) return 1000;
  if (isTablet(context)) return 700;
  return double.infinity;
}
