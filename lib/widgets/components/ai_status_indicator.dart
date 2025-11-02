import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// AIStatusIndicator - Real-time indicator showing AI active/learning/error status
/// Exact specification from UI_Inventory_v2.5.1
class AIStatusIndicator extends StatelessWidget {
  final AIStatus status;
  final String? message;

  const AIStatusIndicator({
    super.key,
    required this.status,
    this.message,
  });

  Color _getStatusColor(AIStatus status) {
    switch (status) {
      case AIStatus.active:
        return const Color(SwiftleadTokens.successGreen);
      case AIStatus.learning:
        return const Color(SwiftleadTokens.infoBlue);
      case AIStatus.error:
        return const Color(SwiftleadTokens.errorRed);
      case AIStatus.paused:
        return const Color(SwiftleadTokens.warningYellow);
    }
  }

  String _getStatusLabel(AIStatus status) {
    switch (status) {
      case AIStatus.active:
        return 'Active';
      case AIStatus.learning:
        return 'Learning';
      case AIStatus.error:
        return 'Error';
      case AIStatus.paused:
        return 'Paused';
    }
  }

  IconData _getStatusIcon(AIStatus status) {
    switch (status) {
      case AIStatus.active:
        return Icons.check_circle;
      case AIStatus.learning:
        return Icons.school;
      case AIStatus.error:
        return Icons.error;
      case AIStatus.paused:
        return Icons.pause_circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    final isPulsing = status == AIStatus.active || status == AIStatus.learning;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            if (isPulsing)
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
              ),
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: isPulsing
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(width: SwiftleadTokens.spaceS),
        Text(
          _getStatusLabel(status),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (message != null) ...[
          const SizedBox(width: SwiftleadTokens.spaceXS),
          Text(
            '• $message',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}

enum AIStatus {
  active,
  learning,
  error,
  paused,
}

