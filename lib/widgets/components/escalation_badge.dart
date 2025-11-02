import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// EscalationBadge - Badge showing when AI escalated to human with reason
/// Exact specification from UI_Inventory_v2.5.1
class EscalationBadge extends StatelessWidget {
  final String reason;
  final DateTime? timestamp;

  const EscalationBadge({
    super.key,
    required this.reason,
    this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(SwiftleadTokens.warningYellow).withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(SwiftleadTokens.warningYellow).withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.arrow_upward,
            size: 12,
            color: Color(SwiftleadTokens.warningYellow),
          ),
          const SizedBox(width: 4),
          Text(
            'Escalated: $reason',
            style: const TextStyle(
              color: Color(SwiftleadTokens.warningYellow),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

