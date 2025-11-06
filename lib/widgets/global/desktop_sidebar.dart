import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import 'badge.dart' as swiftlead_badge;
import 'frosted_bottom_nav_bar.dart' show NavItem;

/// Desktop Sidebar Navigation
/// Persistent sidebar for desktop/web, replaces bottom nav
class DesktopSidebar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<NavItem> items;
  final Widget? drawerContent;

  const DesktopSidebar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.drawerContent,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;

    return Container(
      width: 80, // Compact sidebar width
      decoration: BoxDecoration(
        color: isLight
            ? Colors.white.withOpacity(0.08)
            : Colors.black.withOpacity(0.32),
        border: Border(
          right: BorderSide(
            color: isLight
                ? Colors.black.withOpacity(0.10)
                : Colors.white.withOpacity(0.10),
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: SwiftleadTokens.blurBottomNav,
            sigmaY: SwiftleadTokens.blurBottomNav,
          ),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Navigation items
              ...items.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;
                final isActive = index == currentIndex;

                return _SidebarItem(
                  item: item,
                  isActive: isActive,
                  onTap: () => onTap(index),
                );
              }),
              const Spacer(),
              // Drawer toggle button
              if (drawerContent != null)
                IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    // Open drawer (handled by parent)
                  },
                  tooltip: 'More options',
                ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 80,
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: widget.isActive
                ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                : (_isHovered
                    ? (isLight
                        ? Colors.black.withOpacity(0.05)
                        : Colors.white.withOpacity(0.05))
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.item.badgeCount != null && widget.item.badgeCount! > 0
                  ? swiftlead_badge.Badge.count(
                      count: widget.item.badgeCount!,
                      child: widget.item.hasCustomIcon
                          ? Text(
                              widget.isActive
                                  ? widget.item.customActiveIcon!
                                  : widget.item.customIcon!,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                height: 1.0,
                                color: widget.isActive
                                    ? const Color(SwiftleadTokens.primaryTeal)
                                    : (isLight
                                        ? Colors.black.withOpacity(0.6)
                                        : Colors.white.withOpacity(0.6)),
                              ),
                            )
                          : Icon(
                              widget.isActive
                                  ? widget.item.activeIcon
                                  : widget.item.icon,
                              color: widget.isActive
                                  ? const Color(SwiftleadTokens.primaryTeal)
                                  : (isLight
                                      ? Colors.black.withOpacity(0.6)
                                      : Colors.white.withOpacity(0.6)),
                              size: 24,
                            ),
                    )
                  : widget.item.hasCustomIcon
                      ? Text(
                          widget.isActive
                              ? widget.item.customActiveIcon!
                              : widget.item.customIcon!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                            color: widget.isActive
                                ? const Color(SwiftleadTokens.primaryTeal)
                                : (isLight
                                    ? Colors.black.withOpacity(0.6)
                                    : Colors.white.withOpacity(0.6)),
                          ),
                        )
                      : Icon(
                          widget.isActive
                              ? widget.item.activeIcon
                              : widget.item.icon,
                          color: widget.isActive
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : (isLight
                                  ? Colors.black.withOpacity(0.6)
                                  : Colors.white.withOpacity(0.6)),
                          size: 24,
                        ),
              const SizedBox(height: 4),
              Text(
                widget.item.label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.normal,
                  color: widget.isActive
                      ? const Color(SwiftleadTokens.primaryTeal)
                      : (isLight
                          ? Colors.black.withOpacity(0.6)
                          : Colors.white.withOpacity(0.6)),
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


