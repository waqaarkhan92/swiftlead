import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// DrawerMenu - Premium glass drawer navigation
/// Exact specification from Theme_and_Design_System_v2.5.1
class SwiftleadDrawer extends StatelessWidget {
  final String? userName;
  final String? organizationName;
  final String? planBadge;
  final VoidCallback? onProfileTap;
  final List<DrawerItem> items;
  final Widget? footer;
  
  const SwiftleadDrawer({
    super.key,
    this.userName,
    this.organizationName,
    this.planBadge,
    this.onProfileTap,
    required this.items,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    
    return Drawer(
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: isLight ? 22 : 26,
            sigmaY: isLight ? 22 : 26,
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isLight
                    ? [
                        const Color(0xFFF3FBFA),
                        const Color(0xFFE7F7F4),
                      ]
                    : [
                        const Color(0xFF0E1414),
                        const Color(0xFF0A0E0E),
                      ],
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  height: 168,
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceXL),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isLight
                            ? Colors.black.withOpacity(0.06)
                            : Colors.white.withOpacity(0.08),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (organizationName != null)
                        Text(
                          organizationName!,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: isLight 
                                ? const Color(0xFF1A1A1A)
                                : Colors.white,
                          ),
                        ),
                      if (userName != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          userName!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: isLight
                                ? const Color(0xFF707070)
                                : Colors.white.withOpacity(0.65),
                          ),
                        ),
                      ],
                      if (planBadge != null) ...[
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            planBadge!,
                            style: TextStyle(
                              color: const Color(SwiftleadTokens.primaryTeal),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                
                // Menu Items
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: items.map((item) {
                      final isSelected = item.isSelected;
                      return Container(
                        margin: EdgeInsets.only(left: isSelected ? 6 : 0),
                        decoration: isSelected
                            ? BoxDecoration(
                                color: const Color(0xFF00D6C7).withOpacity(
                                  isLight ? 0.08 : 0.12,
                                ),
                                border: Border(
                                  left: BorderSide(
                                    color: const Color(SwiftleadTokens.primaryTeal),
                                    width: 6,
                                  ),
                                ),
                              )
                            : null,
                        child: ListTile(
                          leading: Icon(
                            item.icon,
                            color: isSelected
                                ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.9)
                                : (isLight
                                    ? Colors.black.withOpacity(0.75)
                                    : Colors.white.withOpacity(0.8)),
                          ),
                          title: Text(
                            item.label,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isLight
                                  ? const Color(0xFF1A1A1A)
                                  : Colors.white,
                            ),
                          ),
                          trailing: item.badge != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(SwiftleadTokens.errorRed),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    item.badge!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : null,
                          onTap: item.onTap,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                // Footer
                if (footer != null)
                  Container(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: footer,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final bool isSelected;
  final String? badge;
  
  DrawerItem({
    required this.icon,
    required this.label,
    this.onTap,
    this.isSelected = false,
    this.badge,
  });
}

