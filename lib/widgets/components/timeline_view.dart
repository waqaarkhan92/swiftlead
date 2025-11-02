import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/avatar.dart';
import '../global/badge.dart';

/// TimelineView - Chronological activity feed
/// Exact specification from UI_Inventory_v2.5.1
class TimelineActivity {
  final String id;
  final String type;
  final String title;
  final String? description;
  final DateTime timestamp;
  final String? actorName;
  final String? actorAvatar;
  final Map<String, dynamic>? metadata;

  TimelineActivity({
    required this.id,
    required this.type,
    required this.title,
    this.description,
    required this.timestamp,
    this.actorName,
    this.actorAvatar,
    this.metadata,
  });
}

class TimelineView extends StatelessWidget {
  final List<TimelineActivity> activities;
  final VoidCallback? onLoadMore;
  final bool isLoading;
  final bool hasMore;
  final Function(String activityId)? onActivityTap;

  const TimelineView({
    super.key,
    required this.activities,
    this.onLoadMore,
    this.isLoading = false,
    this.hasMore = false,
    this.onActivityTap,
  });

  IconData _getActivityIcon(String type) {
    switch (type.toLowerCase()) {
      case 'message':
        return Icons.message;
      case 'call':
        return Icons.phone;
      case 'email':
        return Icons.email;
      case 'job':
        return Icons.build;
      case 'quote':
        return Icons.description;
      case 'payment':
        return Icons.payment;
      case 'meeting':
        return Icons.event;
      default:
        return Icons.circle;
    }
  }

  Color _getActivityColor(String type) {
    switch (type.toLowerCase()) {
      case 'message':
        return const Color(SwiftleadTokens.primaryTeal);
      case 'call':
        return const Color(SwiftleadTokens.infoBlue);
      case 'email':
        return const Color(SwiftleadTokens.warningYellow);
      case 'job':
        return const Color(SwiftleadTokens.successGreen);
      case 'quote':
        return const Color(SwiftleadTokens.accentAqua);
      case 'payment':
        return const Color(SwiftleadTokens.successGreen);
      case 'meeting':
        return const Color(SwiftleadTokens.primaryTeal);
      default:
        return const Color(SwiftleadTokens.textSecondaryLight);
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty && !isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.timeline,
              size: 48,
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Text(
              'No activity yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      itemCount: activities.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == activities.length) {
          return Center(
            child: TextButton(
              onPressed: isLoading ? null : onLoadMore,
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Load More'),
            ),
          );
        }

        final activity = activities[index];
        final color = _getActivityColor(activity.type);
        final isLast = index == activities.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeline line
            Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getActivityIcon(activity.type),
                    size: 20,
                    color: color,
                  ),
                ),
                if (!isLast || hasMore)
                  Container(
                    width: 2,
                    height: 40,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            
            // Activity content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceL),
                child: GestureDetector(
                  onTap: () => onActivityTap?.call(activity.id),
                  child: FrostedContainer(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                activity.title,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              _formatTimestamp(activity.timestamp),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        if (activity.description != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            activity.description!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                        if (activity.actorName != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (activity.actorAvatar != null)
                                SwiftleadAvatar(
                                  imageUrl: activity.actorAvatar,
                                  size: AvatarSize.small,
                                )
                              else
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      activity.actorName![0].toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Text(
                                activity.actorName!,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

