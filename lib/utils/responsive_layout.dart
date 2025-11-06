import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Responsive Layout Utilities
/// Provides breakpoint detection and responsive layout helpers
class ResponsiveLayout {
  // Breakpoints from specs
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 960;
  static const double desktopBreakpoint = 1280;
  static const double largeDesktopBreakpoint = 1920;

  /// Check if current screen is mobile
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < mobileBreakpoint;
  }

  /// Check if current screen is tablet
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < desktopBreakpoint;
  }

  /// Check if current screen is desktop
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktopBreakpoint;
  }

  /// Check if current screen is large desktop
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= largeDesktopBreakpoint;
  }

  /// Get current breakpoint name
  static String getBreakpoint(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileBreakpoint) return 'mobile';
    if (width < tabletBreakpoint) return 'tablet';
    if (width < desktopBreakpoint) return 'desktop';
    return 'largeDesktop';
  }

  /// Get max width for content container
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) {
      return 1024; // From specs
    } else if (isTablet(context)) {
      return 960; // From specs
    }
    return double.infinity; // Mobile: full width
  }

  /// Get column count for grid layouts
  static int getColumnCount(BuildContext context) {
    if (isDesktop(context)) return 3;
    if (isTablet(context)) return 2;
    return 1; // Mobile
  }

  /// Get padding based on screen size
  static EdgeInsets getPadding(BuildContext context) {
    if (isDesktop(context)) {
      return const EdgeInsets.all(32); // From specs
    } else if (isTablet(context)) {
      return const EdgeInsets.all(24); // From specs
    }
    return const EdgeInsets.all(16); // Mobile
  }

  /// Get gutter spacing for grid layouts
  static double getGutter(BuildContext context) {
    if (isDesktop(context)) return 32;
    if (isTablet(context)) return 24;
    return 16; // Mobile
  }
}

/// Responsive Layout Widget
/// Shows different layouts based on screen size
class ResponsiveLayoutWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayoutWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveLayout.isDesktop(context) && desktop != null) {
      return desktop!;
    } else if (ResponsiveLayout.isTablet(context) && tablet != null) {
      return tablet!;
    }
    return mobile;
  }
}

/// Responsive Grid Widget
/// Creates a responsive grid that adapts to screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? childAspectRatio;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.childAspectRatio,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final columnCount = ResponsiveLayout.getColumnCount(context);
    final gutter = ResponsiveLayout.getGutter(context);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columnCount,
        childAspectRatio: childAspectRatio ?? 1.0,
        crossAxisSpacing: crossAxisSpacing ?? gutter,
        mainAxisSpacing: mainAxisSpacing ?? gutter,
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}

/// Platform-aware widget that shows different content on web vs mobile
class PlatformAwareWidget extends StatelessWidget {
  final Widget mobile;
  final Widget? web;

  const PlatformAwareWidget({
    super.key,
    required this.mobile,
    this.web,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb && web != null) {
      return web!;
    }
    return mobile;
  }
}

