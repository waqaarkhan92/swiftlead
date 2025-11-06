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
    this.onTap,
    this.onSwipeRight,
    this.onLongPress,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'quoted':
        return const Color(SwiftleadTokens.infoBlue);
      case 'scheduled':
      case 'booked':
        return const Color(SwiftleadTokens.primaryTeal);
      case 'in progress':
      case 'in_progress':
        return const Color(SwiftleadTokens.warningYellow);
      case 'completed':
        return const Color(SwiftleadTokens.successGreen);
      case 'cancelled':
        return const Color(SwiftleadTokens.errorRed);
      default:
        return const Color(SwiftleadTokens.primaryTeal);
    }
  }

  IconData _getJobTypeIcon() {
    // Map service type to icon (or use default)
    if (serviceType != null) {
      final lower = serviceType!.toLowerCase();
      if (lower.contains('plumb') || lower.contains('pipe')) {
        return Icons.plumbing;
      } else if (lower.contains('electr')) {
        return Icons.electrical_services;
      } else if (lower.contains('paint')) {
        return Icons.format_paint;
      } else if (lower.contains('repair') || lower.contains('fix')) {
        return Icons.build;
      } else if (lower.contains('install')) {
        return Icons.install_mobile;
      } else if (lower.contains('clean')) {
        return Icons.cleaning_services;
      }
    }
    return Icons.work_outline;
  }

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
        child: Container(
          margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            boxShadow: [
              BoxShadow(
                color: _getStatusColor().withOpacity(0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
                spreadRadius: 0,
              ),
              BoxShadow(
                color: _getStatusColor().withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 8),
                spreadRadius: -2,
              ),
            ],
          ),
          child: Row(
            children: [
              // Color-coded left border (4px wide)
              Container(
                width: 4,
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(SwiftleadTokens.radiusCard),
                    bottomLeft: Radius.circular(SwiftleadTokens.radiusCard),
                  ),
                ),
              ),
              // Main card content
              Expanded(
                child: FrostedContainer(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header row with avatar, title, and menu
                      Row(
                        children: [
                          // Enhanced avatar with gradient
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  _getStatusColor().withOpacity(0.2),
                                  _getStatusColor().withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(26),
                              border: Border.all(
                                color: _getStatusColor().withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                clientName[0].toUpperCase(),
                                style: TextStyle(
                                  color: _getStatusColor(),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: SwiftleadTokens.spaceM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Job title with icon
                                Row(
                                  children: [
                                    Icon(
                                      _getJobTypeIcon(),
                                      size: 16,
                                      color: _getStatusColor(),
                                    ),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        jobTitle,
                                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      clientName,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    if (serviceType != null) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: _getStatusColor().withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          serviceType!,
                                          style: TextStyle(
                                            color: _getStatusColor(),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // QuickActions menu
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              size: 20,
                              color: Theme.of(context).textTheme.bodySmall?.color,
                            ),
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
                      // Progress bar for in-progress jobs
                      if (status.toLowerCase() == 'in progress' || status.toLowerCase() == 'in_progress') ...[
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: _getStatusColor().withOpacity(0.1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 0.65, // 65% progress (mock - would come from job data)
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    _getStatusColor(),
                                    _getStatusColor().withOpacity(0.7),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: SwiftleadTokens.spaceS),
                      ],
                      // Bottom row: Status, Date, Price
                      Row(
                        children: [
                          // Enhanced status pill
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor().withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getStatusColor().withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: _getStatusColor().withOpacity(0.5),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  status.toUpperCase(),
                                  style: TextStyle(
                                    color: _getStatusColor(),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (dueDate != null) ...[
                            const SizedBox(width: SwiftleadTokens.spaceS),
                            DateChip(
                              date: dueDate!,
                              isPastDue: dueDate!.isBefore(DateTime.now()),
                            ),
                          ],
                          const Spacer(),
                          // Enhanced price display
                          if (price != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(SwiftleadTokens.successGreen).withOpacity(0.15),
                                    const Color(SwiftleadTokens.successGreen).withOpacity(0.08),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(SwiftleadTokens.successGreen).withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                price!,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(SwiftleadTokens.successGreen),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
