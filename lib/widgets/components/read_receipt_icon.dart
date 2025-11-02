import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// ReadReceiptIcon - Check marks (single/double) showing delivery and read status
/// Exact specification from UI_Inventory_v2.5.1
enum ReadReceiptStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

class ReadReceiptIcon extends StatelessWidget {
  final ReadReceiptStatus status;
  final double size;
  final Color? color;
  
  const ReadReceiptIcon({
    super.key,
    required this.status,
    this.size = 16,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? 
        (status == ReadReceiptStatus.failed
            ? Colors.red
            : (status == ReadReceiptStatus.read
                ? const Color(SwiftleadTokens.infoBlue)
                : Colors.white.withOpacity(0.7)));

    IconData icon;
    switch (status) {
      case ReadReceiptStatus.sending:
        icon = Icons.access_time;
        break;
      case ReadReceiptStatus.sent:
        icon = Icons.check;
        break;
      case ReadReceiptStatus.delivered:
        icon = Icons.done_all;
        break;
      case ReadReceiptStatus.read:
        icon = Icons.done_all;
        break;
      case ReadReceiptStatus.failed:
        icon = Icons.error_outline;
        break;
    }

    return Icon(
      icon,
      size: size,
      color: effectiveColor,
    );
  }
}

