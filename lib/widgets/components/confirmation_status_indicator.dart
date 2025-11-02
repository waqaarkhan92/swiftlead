import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/badge.dart';

/// ConfirmationStatusIndicator - Color-coded indicator (pending/confirmed/completed/cancelled)
/// Exact specification from UI_Inventory_v2.5.1
class ConfirmationStatusIndicator extends StatelessWidget {
  final String status; // 'pending', 'confirmed', 'completed', 'cancelled'

  const ConfirmationStatusIndicator({
    super.key,
    required this.status,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return const Color(SwiftleadTokens.successGreen);
      case 'pending':
        return const Color(SwiftleadTokens.warningYellow);
      case 'completed':
        return const Color(SwiftleadTokens.infoBlue);
      case 'cancelled':
        return const Color(SwiftleadTokens.errorRed);
      default:
        return const Color(SwiftleadTokens.textSecondaryLight);
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor(status);
    
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: SwiftleadTokens.spaceXS),
        Icon(
          _getStatusIcon(status),
          size: 16,
          color: color,
        ),
        const SizedBox(width: SwiftleadTokens.spaceXS),
        Text(
          status.toUpperCase(),
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

