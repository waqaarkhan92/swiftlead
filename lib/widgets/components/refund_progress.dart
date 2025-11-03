import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart' as global_badge;

/// RefundProgress - Shows refund processing status
/// Exact specification from UI_Inventory_v2.5.1
class RefundProgress extends StatelessWidget {
  final RefundStatus status;
  final double progress; // 0.0 to 1.0
  final String? message;

  const RefundProgress({
    super.key,
    required this.status,
    this.progress = 0.0,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    String displayMessage;
    Color progressColor;
    IconData statusIcon;

    switch (status) {
      case RefundStatus.processing:
        displayMessage = message ?? 'Processing refund...';
        progressColor = const Color(SwiftleadTokens.warningYellow);
        statusIcon = Icons.refresh;
        break;
      case RefundStatus.completed:
        displayMessage = message ?? 'Refund completed successfully';
        progressColor = const Color(SwiftleadTokens.successGreen);
        statusIcon = Icons.check_circle;
        break;
      case RefundStatus.failed:
        displayMessage = message ?? 'Refund failed';
        progressColor = const Color(SwiftleadTokens.errorRed);
        statusIcon = Icons.error;
        break;
      case RefundStatus.pending:
        displayMessage = message ?? 'Refund pending';
        progressColor = Colors.grey;
        statusIcon = Icons.pending;
        break;
    }

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(statusIcon, color: progressColor, size: 20),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: Text(
                  'Refund Status',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
              global_badge.SwiftleadBadge(
                label: status.displayName,
                variant: _getBadgeVariant(status),
                size: global_badge.BadgeSize.small,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            displayMessage,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: progressColor,
                ),
          ),
          if (status == RefundStatus.processing && progress > 0) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            ClipRRect(
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
                minHeight: 4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  global_badge.BadgeVariant _getBadgeVariant(RefundStatus status) {
    switch (status) {
      case RefundStatus.completed:
        return global_badge.BadgeVariant.success;
      case RefundStatus.failed:
        return global_badge.BadgeVariant.error;
      case RefundStatus.processing:
        return global_badge.BadgeVariant.warning;
      case RefundStatus.pending:
        return global_badge.BadgeVariant.secondary;
    }
  }
}

/// Refund status enum
enum RefundStatus {
  pending,
  processing,
  completed,
  failed,
}

extension RefundStatusExtension on RefundStatus {
  String get displayName {
    switch (this) {
      case RefundStatus.pending:
        return 'Pending';
      case RefundStatus.processing:
        return 'Processing';
      case RefundStatus.completed:
        return 'Completed';
      case RefundStatus.failed:
        return 'Failed';
    }
  }
}


