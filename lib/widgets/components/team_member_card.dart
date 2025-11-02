import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// TeamMemberCard - Card with avatar, name, role, permissions, edit/remove actions
/// Exact specification from UI_Inventory_v2.5.1
class TeamMemberCard extends StatelessWidget {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatarUrl;
  final bool isOnline;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const TeamMemberCard({
    super.key,
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatarUrl,
    this.isOnline = false,
    this.onEdit,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                  shape: BoxShape.circle,
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
                          name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Color(SwiftleadTokens.primaryTeal),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.successGreen),
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
          const SizedBox(width: SwiftleadTokens.spaceM),
          
          // Name & Role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 4),
                SwiftleadBadge(
                  label: role,
                  variant: BadgeVariant.secondary,
                  size: BadgeSize.small,
                ),
              ],
            ),
          ),
          
          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 20),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: onRemove,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

