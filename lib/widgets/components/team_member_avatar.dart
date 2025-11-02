import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// TeamMemberAvatar - Avatar with availability indicator and tap to filter
/// Exact specification from UI_Inventory_v2.5.1
class TeamMemberAvatar extends StatelessWidget {
  final String memberId;
  final String name;
  final String? avatarUrl;
  final bool isOnline;
  final bool isAvailable;
  final VoidCallback? onTap;
  final double size;

  const TeamMemberAvatar({
    super.key,
    required this.memberId,
    required this.name,
    this.avatarUrl,
    this.isOnline = false,
    this.isAvailable = true,
    this.onTap,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              shape: BoxShape.circle,
              border: isAvailable
                  ? null
                  : Border.all(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black.withOpacity(0.2)
                          : Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
            ),
            child: avatarUrl != null
                ? ClipOval(
                    child: Image.network(
                      avatarUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : Center(
                    child: Text(
                      name.isNotEmpty ? name[0].toUpperCase() : '',
                      style: TextStyle(
                        color: const Color(SwiftleadTokens.primaryTeal),
                        fontWeight: FontWeight.w600,
                        fontSize: size * 0.4,
                      ),
                    ),
                  ),
          ),
          
          // Online/Available Indicator
          if (isOnline || isAvailable)
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: size * 0.3,
                height: size * 0.3,
                decoration: BoxDecoration(
                  color: isOnline
                      ? const Color(SwiftleadTokens.successGreen)
                      : const Color(SwiftleadTokens.warningYellow),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

