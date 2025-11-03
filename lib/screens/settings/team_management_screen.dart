import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/badge.dart';
import '../../theme/tokens.dart';

/// Team Management Screen
/// Exact specification from UI_Inventory_v2.5.1
class TeamManagementScreen extends StatefulWidget {
  const TeamManagementScreen({super.key});

  @override
  State<TeamManagementScreen> createState() => _TeamManagementScreenState();
}

class _TeamManagementScreenState extends State<TeamManagementScreen> {
  bool _isLoading = false;
  
  final List<_TeamMember> _teamMembers = [
    _TeamMember(
      id: '1',
      name: 'Alex Johnson',
      email: 'alex@abcplumbing.co.uk',
      role: 'Owner',
      avatar: null,
      isActive: true,
    ),
    _TeamMember(
      id: '2',
      name: 'Sarah Williams',
      email: 'sarah@abcplumbing.co.uk',
      role: 'Admin',
      avatar: null,
      isActive: true,
    ),
    _TeamMember(
      id: '3',
      name: 'Mike Taylor',
      email: 'mike@abcplumbing.co.uk',
      role: 'Member',
      avatar: null,
      isActive: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Team Members',
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Toast.show(
                context,
                message: 'Add team member coming soon',
                type: ToastType.info,
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Toast.show(
            context,
            message: 'Invite team member',
            type: ToastType.info,
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Invite Member'),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: List.generate(3, (i) => Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: SkeletonLoader(
          width: double.infinity,
          height: 100,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      )),
    );
  }

  Widget _buildContent() {
    if (_teamMembers.isEmpty) {
      return EmptyStateCard(
        title: 'No team members yet',
        description: 'Invite your team to collaborate',
        icon: Icons.people_outline,
        actionLabel: 'Invite First Member',
        onAction: () {
          Toast.show(
            context,
            message: 'Invite team member',
            type: ToastType.info,
          );
        },
      );
    }

    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        ..._teamMembers.map((member) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
          child: _TeamMemberCard(
            member: member,
            onRemove: () {
              Toast.show(
                context,
                message: '${member.name} removed',
                type: ToastType.success,
              );
            },
          ),
        )),
      ],
    );
  }
}

class _TeamMember {
  final String id;
  final String name;
  final String email;
  final String role;
  final String? avatar;
  final bool isActive;

  _TeamMember({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.avatar,
    required this.isActive,
  });
}

class _TeamMemberCard extends StatelessWidget {
  final _TeamMember member;
  final VoidCallback onRemove;

  const _TeamMemberCard({
    required this.member,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                member.name.substring(0, 2).toUpperCase(),
                style: const TextStyle(
                  color: Color(SwiftleadTokens.primaryTeal),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        member.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SwiftleadBadge(
                      label: member.role,
                      variant: member.role == 'Owner' ? BadgeVariant.success : BadgeVariant.info,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  member.email,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              Toast.show(
                context,
                message: 'Edit member',
                type: ToastType.info,
              );
            },
          ),
        ],
      ),
    );
  }
}

