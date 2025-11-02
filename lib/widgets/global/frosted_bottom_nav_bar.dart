import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import 'badge.dart' as swiftlead_badge;

/// FrostedBottomNavBar - Premium floating navigation capsule
/// Exact specification from Theme_and_Design_System_v2.5.1
class FrostedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItem> items;
  
  const FrostedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;

    return Positioned(
      left: 16,
      right: 16,
      bottom: 16 + bottomPadding,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusBottomNav),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: SwiftleadTokens.blurBottomNav,
            sigmaY: SwiftleadTokens.blurBottomNav,
          ),
          child: Container(
            height: 64,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: BoxDecoration(
              color: isLight
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.32),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusBottomNav),
              border: Border.all(
                color: isLight
                    ? Colors.black.withOpacity(0.10)
                    : Colors.white.withOpacity(0.10),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isLight ? 0.16 : 0.25),
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = index == currentIndex;
                
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          item.badgeCount != null && item.badgeCount! > 0
                              ? swiftlead_badge.Badge.count(
                                  count: item.badgeCount!,
                                  child: Icon(
                                    isActive ? item.activeIcon : item.icon,
                                    color: isActive
                                        ? const Color(SwiftleadTokens.primaryTeal)
                                        : (isLight
                                            ? Colors.black.withOpacity(0.45)
                                            : Colors.white.withOpacity(0.5)),
                                    size: 24,
                                  ),
                                )
                              : Icon(
                                  isActive ? item.activeIcon : item.icon,
                                  color: isActive
                                      ? const Color(SwiftleadTokens.primaryTeal)
                                      : (isLight
                                          ? Colors.black.withOpacity(0.45)
                                          : Colors.white.withOpacity(0.5)),
                                  size: 24,
                                ),
                          if (isActive)
                            Container(
                              margin: const EdgeInsets.only(top: 4),
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                color: const Color(SwiftleadTokens.primaryTeal),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int? badgeCount;
  
  NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount,
  });
}

