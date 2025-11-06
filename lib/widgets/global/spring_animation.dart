import 'package:flutter/material.dart';

/// Spring Animation Utilities - iOS-style spring physics
/// Provides smooth, natural animations matching iOS/Revolut quality
class SpringAnimation {
  /// Standard spring curve for buttons and cards
  static const Curve standard = Curves.easeOutCubic;
  
  /// Spring curve for modals and sheets
  static const Curve modal = Curves.easeOutQuart;
  
  /// Fast spring for micro-interactions
  static const Curve fast = Curves.easeInOutQuad;
  
  /// Smooth spring for premium interactions
  static const Curve smooth = Curves.easeOutQuart;
  
  /// Create a spring animation controller
  static AnimationController createController(
    TickerProvider vsync, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return AnimationController(
      duration: duration,
      vsync: vsync,
    );
  }
  
  /// Create a spring animation with custom curve
  static Animation<double> createAnimation(
    AnimationController controller,
    Curve curve,
  ) {
    return CurvedAnimation(
      parent: controller,
      curve: curve,
        );
  }
  
  /// Spring scale animation for buttons
  static Widget springScale({
    required Widget child,
    required AnimationController controller,
    double scale = 0.95,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.0 - (controller.value * (1.0 - scale)),
              child: child,
        );
      },
      child: child,
    );
  }
  
  /// Spring opacity animation
  static Widget springOpacity({
    required Widget child,
    required AnimationController controller,
  }) {
    return FadeTransition(
      opacity: controller,
      child: child,
    );
  }
  
  /// Spring slide animation
  static Widget springSlide({
    required Widget child,
    required AnimationController controller,
    Offset begin = const Offset(0.0, 0.1),
    Offset end = Offset.zero,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: begin,
        end: end,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: smooth,
      )),
        child: child,
    );
  }
  }
  
/// Spring Button - Button with spring animation on press
class SpringButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration duration;
  final double pressScale;
  
  const SpringButton({
    super.key,
    required this.child,
    this.onPressed,
    this.duration = const Duration(milliseconds: 150),
    this.pressScale = 0.95,
  });
  
  @override
  State<SpringButton> createState() => _SpringButtonState();
}

class _SpringButtonState extends State<SpringButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: SpringAnimation.fast,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }
  
  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onPressed?.call();
  }
  
  void _handleTapCancel() {
    _controller.reverse();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
        child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

/// Spring Card - Card with spring animation on press
class SpringCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  
  const SpringCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
  });
  
  @override
  State<SpringCard> createState() => _SpringCardState();
}

class _SpringCardState extends State<SpringCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: SpringAnimation.standard,
    ));
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
  }
  
  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap?.call();
  }
  
  void _handleTapCancel() {
    _controller.reverse();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onTap != null ? _handleTapDown : null,
      onTapUp: widget.onTap != null ? _handleTapUp : null,
      onTapCancel: widget.onTap != null ? _handleTapCancel : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
