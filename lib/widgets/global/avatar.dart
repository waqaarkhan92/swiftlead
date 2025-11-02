import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Avatar - User/contact profile image
/// Exact specification from UI_Inventory_v2.5.1
class SwiftleadAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final AvatarSize size;
  final Color? backgroundColor;
  final Widget? badge;
  final VoidCallback? onTap;

  const SwiftleadAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = AvatarSize.medium,
    this.backgroundColor,
    this.badge,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final avatarSize = _getSize(size);
    final effectiveBgColor =
        backgroundColor ?? const Color(SwiftleadTokens.primaryTeal);

    final avatar = Container(
      width: avatarSize,
      height: avatarSize,
      decoration: BoxDecoration(
        color: effectiveBgColor.withOpacity(0.1),
        shape: BoxShape.circle,
        image: imageUrl != null
            ? DecorationImage(
                image: NetworkImage(imageUrl!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: imageUrl == null && initials != null
          ? Center(
              child: Text(
                initials!,
                style: TextStyle(
                  color: effectiveBgColor,
                  fontSize: _getFontSize(size),
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          : null,
    );

    if (badge != null) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          avatar,
          Positioned(
            right: -2,
            bottom: -2,
            child: badge!,
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }

  double _getSize(AvatarSize size) {
    switch (size) {
      case AvatarSize.small:
        return 32;
      case AvatarSize.medium:
        return 48;
      case AvatarSize.large:
        return 64;
      case AvatarSize.xlarge:
        return 80;
    }
  }

  double _getFontSize(AvatarSize size) {
    switch (size) {
      case AvatarSize.small:
        return 12;
      case AvatarSize.medium:
        return 16;
      case AvatarSize.large:
        return 20;
      case AvatarSize.xlarge:
        return 24;
    }
  }
}

enum AvatarSize { small, medium, large, xlarge }

