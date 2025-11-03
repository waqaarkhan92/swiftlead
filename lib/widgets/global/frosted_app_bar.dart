import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../../screens/notifications/notifications_screen.dart';

/// FrostedAppBar - Premium glass app bar
/// Exact specification from Screen_Layouts_v2.5.1
class FrostedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final Widget? flexibleSpace;
  final double? elevation;
  final bool automaticallyImplyLeading;
  final Widget? profileIcon;
  final int? notificationBadgeCount;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  
  const FrostedAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.flexibleSpace,
    this.elevation,
    this.automaticallyImplyLeading = true,
    this.profileIcon,
    this.notificationBadgeCount,
    this.scaffoldKey,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final blur = brightness == Brightness.light 
        ? SwiftleadTokens.blurLight + 2 
        : SwiftleadTokens.blurDark;
    
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blur,
          sigmaY: blur,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: brightness == Brightness.light
                ? Colors.white.withOpacity(SwiftleadTokens.appBarOpacityLight)
                : const Color(0xFF131516).withOpacity(SwiftleadTokens.appBarOpacityDark),
            border: Border(
              bottom: BorderSide(
                color: brightness == Brightness.light
                    ? Colors.black.withOpacity(0.06)
                    : Colors.white.withOpacity(0.08),
                width: 0.5,
              ),
            ),
          ),
          child: AppBar(
            title: titleWidget ?? (title != null ? Text(title!) : null),
            leading: leading ?? (automaticallyImplyLeading
                ? Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: scaffoldKey != null 
                          ? () => scaffoldKey!.currentState?.openDrawer()
                          : () => Scaffold.of(context).openDrawer(),
                    ),
                  )
                : null),
            actions: [
              if (profileIcon != null) profileIcon!,
              if (notificationBadgeCount != null && notificationBadgeCount! > 0)
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const NotificationsScreen(),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(SwiftleadTokens.errorRed),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          notificationBadgeCount! > 99 ? '99+' : '$notificationBadgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              if (actions != null) ...actions!,
            ],
            flexibleSpace: flexibleSpace,
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: automaticallyImplyLeading && leading == null,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

