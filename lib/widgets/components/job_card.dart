import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart' as swiftlead_badge;
import 'progress_pill.dart';
import 'date_chip.dart';

/// JobCard - Rich information card with all components
/// Exact specification from Screen_Layouts_v2.5.1
class JobCard extends StatelessWidget {
  final String jobTitle;
  final String clientName;
  final String? serviceType;
  final String status; // Quoted → Scheduled → In Progress → Completed
  final DateTime? dueDate;
  final String? price;
  final String? teamMemberName;
  final VoidCallback? onTap;
  final VoidCallback? onSwipeRight; // Quick complete
  final VoidCallback? onLongPress; // Batch selection
  
  const JobCard({
    super.key,
    required this.jobTitle,
    required this.clientName,
    this.serviceType,
    required this.status,
    this.dueDate,
    this.price,
    this.teamMemberName,
    this.onTap,
    this.onSwipeRight,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(jobTitle),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: const Icon(
          Icons.check_circle,
          color: Color(SwiftleadTokens.successGreen),
        ),
      ),
      onDismissed: (direction) {
        if (onSwipeRight != null) {
          onSwipeRight!();
        }
      },
      child: GestureDetector(
        onTap: onTap,
        onLongPress: onLongPress,
        child: FrostedContainer(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ClientAvatar with name
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Text(
                        clientName[0].toUpperCase(),
                        style: const TextStyle(
                          color: Color(SwiftleadTokens.primaryTeal),
                          fontWeight: FontWeight.w600,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // JobTitle and ServiceType badge
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                jobTitle,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (serviceType != null) ...[
                              const SizedBox(width: SwiftleadTokens.spaceS),
                              swiftlead_badge.Badge.status(
                                label: serviceType!,
                                status: swiftlead_badge.BadgeStatus.neutral,
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          clientName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  // QuickActions: Three-dot menu
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert, size: 20),
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          // Edit job
                          break;
                        case 'clone':
                          // Clone job
                          break;
                        case 'cancel':
                          // Cancel job
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text('Edit'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'clone',
                        child: Row(
                          children: [
                            Icon(Icons.copy, size: 18),
                            SizedBox(width: 8),
                            Text('Clone'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'cancel',
                        child: Row(
                          children: [
                            Icon(Icons.cancel, size: 18),
                            SizedBox(width: 8),
                            Text('Cancel'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              // ProgressPill, DateChip, PriceTag, TeamMemberAvatar
              Row(
                children: [
                  ProgressPill(status: status),
                  if (dueDate != null) ...[
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    DateChip(
                      date: dueDate!,
                      isPastDue: dueDate!.isBefore(DateTime.now()),
                    ),
                  ],
                  const Spacer(),
                  if (price != null)
                    Text(
                      price!,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
              if (teamMemberName != null) ...[
                const SizedBox(height: SwiftleadTokens.spaceS),
                Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          teamMemberName![0].toUpperCase(),
                          style: const TextStyle(
                            color: Color(SwiftleadTokens.primaryTeal),
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      teamMemberName!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
