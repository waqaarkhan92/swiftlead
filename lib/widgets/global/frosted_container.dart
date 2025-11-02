import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// FrostedContainer - Premium glass effect component
/// Implements exact specifications from Theme_and_Design_System_v2.5.1
class FrostedContainer extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  final double? blurSigma;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final BoxDecoration? decoration;
  
  const FrostedContainer({
    super.key,
    required this.child,
    this.borderRadius,
    this.blurSigma,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final radius = borderRadius ?? SwiftleadTokens.radiusCard;
    final blur = blurSigma ?? 
        (brightness == Brightness.light 
            ? SwiftleadTokens.blurLight 
            : SwiftleadTokens.blurDark);
    
    final isLight = brightness == Brightness.light;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          padding: padding,
          margin: margin,
          decoration: decoration ?? BoxDecoration(
            gradient: backgroundColor == null ? LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isLight
                  ? [
                      const Color(0xFFFFFFFF),
                      const Color(0xFFF8FBFA),
                    ]
                  : [
                      const Color(0xFF141616),
                      const Color(0xFF101111),
                    ],
            ) : null,
            color: backgroundColor ?? (isLight
                ? Colors.white.withOpacity(SwiftleadTokens.surfaceOpacityLight)
                : const Color(0xFF131516).withOpacity(SwiftleadTokens.surfaceOpacityDark)),
            border: Border.all(
              color: isLight
                  ? Colors.black.withOpacity(SwiftleadTokens.borderOpacityLight)
                  : Colors.white.withOpacity(SwiftleadTokens.borderOpacityDark),
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  isLight 
                      ? SwiftleadTokens.shadowOpacityLight 
                      : SwiftleadTokens.shadowOpacityDark,
                ),
                blurRadius: isLight 
                    ? SwiftleadTokens.shadowBlurLight 
                    : SwiftleadTokens.shadowBlurDark,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          // Inner glow for dark mode
          child: !isLight
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(
                      color: Colors.white.withOpacity(SwiftleadTokens.innerGlowOpacity),
                      width: 2.0,
                    ),
                  ),
                  child: child,
                )
              : child,
        ),
      ),
    );
  }
}

