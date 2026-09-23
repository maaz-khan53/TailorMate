import 'package:flutter/material.dart';

/// Shared responsive rules for TailorX screens.
///
/// Breakpoints are intentionally simple so the same UI behaves consistently
/// on phones, foldables, tablets, desktop windows, and web.
abstract final class ResponsiveLayout {
  static const double phoneBreakpoint = 600;
  static const double desktopBreakpoint = 1024;
  static const double largeDesktopBreakpoint = 1440;

  static bool isPhone(BuildContext context) =>
      MediaQuery.sizeOf(context).width < phoneBreakpoint;

  static bool isTablet(BuildContext context) {
    final double width = MediaQuery.sizeOf(context).width;
    return width >= phoneBreakpoint && width < desktopBreakpoint;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopBreakpoint;

  static bool isTabletOrDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= phoneBreakpoint;

  static double horizontalPadding(double width) {
    if (width >= largeDesktopBreakpoint) return 48;
    if (width >= desktopBreakpoint) return 36;
    if (width >= phoneBreakpoint) return 24;
    if (width < 360) return 12;
    return 16;
  }

  static double contentMaxWidth(double width) {
    if (width >= largeDesktopBreakpoint) return 1240;
    if (width >= desktopBreakpoint) return 1120;
    if (width >= phoneBreakpoint) return 920;
    return double.infinity;
  }

  static double formMaxWidth(double width) {
    if (width >= desktopBreakpoint) return 980;
    if (width >= phoneBreakpoint) return 820;
    return double.infinity;
  }

  static int gridColumns(double width) {
    if (width >= 1180) return 3;
    if (width >= 760) return 2;
    return 1;
  }

  static double cardGap(double width) => width < phoneBreakpoint ? 10 : 14;

  static double scale(double width) {
    if (width < 360) return 0.92;
    if (width < phoneBreakpoint) return 1.0;
    if (width < desktopBreakpoint) return 1.04;
    return 1.08;
  }
}
