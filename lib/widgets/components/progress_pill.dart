import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// ProgressPill - Status indicator showing job progress
/// Exact specification from Screen_Layouts_v2.5.1
class ProgressPill extends StatelessWidget {
  final String status;
  final double? progress; // 0.0 to 1.0
  
  const ProgressPill({
    super.key,
    required this.status,
    this.progress,
  });

  Color _getStatusColor() {
    switch (status.toLowerCase()) {
      case 'quoted':
        return const Color(SwiftleadTokens.infoBlue);
      case 'scheduled':
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

  @override
  Widget build(BuildContext context) {
    final color = _getStatusColor();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

