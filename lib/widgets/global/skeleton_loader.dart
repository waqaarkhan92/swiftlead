import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/tokens.dart';
import 'frosted_container.dart';

/// SkeletonLoader - Loading placeholder with shimmer animation
/// Exact specification from Theme_and_Design_System_v2.5.1
class SkeletonLoader extends StatelessWidget {
  final double width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool isCircular;
  
  const SkeletonLoader({
    super.key,
    required this.width,
    this.height,
    this.borderRadius,
    this.isCircular = false,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final baseColor = brightness == Brightness.light
        ? const Color.fromRGBO(0, 0, 0, 0.08)
        : const Color.fromRGBO(255, 255, 255, 0.08);
    final highlightColor = brightness == Brightness.light
        ? Colors.white.withOpacity(0.4)
        : Colors.white.withOpacity(0.15);
    
    final radius = borderRadius ?? 
        (isCircular ? null : BorderRadius.circular(12));
    
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: width,
        height: height ?? 16,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: isCircular ? null : radius,
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}

/// Pre-built skeleton patterns
class SkeletonCard extends StatelessWidget {
  final bool hasAvatar;
  final int lines;
  
  const SkeletonCard({
    super.key,
    this.hasAvatar = false,
    this.lines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasAvatar)
            Row(
              children: [
                const SkeletonLoader(width: 40, height: 40, isCircular: true),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(width: 120, height: 16),
                      const SizedBox(height: 8),
                      SkeletonLoader(width: 80, height: 14),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: double.infinity, height: 20),
                const SizedBox(height: 12),
                ...List.generate(lines, (i) => Padding(
                  padding: EdgeInsets.only(bottom: i < lines - 1 ? 8 : 0),
                  child: SkeletonLoader(
                    width: i == 0 ? double.infinity : (i == 1 ? 200 : 150),
                    height: 16,
                  ),
                )),
              ],
            ),
        ],
      ),
    );
  }
}

