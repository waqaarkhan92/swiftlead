import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// DateChip - Date display chip for jobs/bookings
/// Exact specification from Screen_Layouts_v2.5.1
class DateChip extends StatelessWidget {
  final DateTime date;
  final bool isDue;
  final bool isPastDue;
  
  const DateChip({
    super.key,
    required this.date,
    this.isDue = false,
    this.isPastDue = false,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateDay = DateTime(date.year, date.month, date.day);
    
    if (dateDay == today) {
      return 'Today';
    } else if (dateDay == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else if (dateDay == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = isPastDue
        ? const Color(SwiftleadTokens.errorRed)
        : (isDue
            ? const Color(SwiftleadTokens.warningYellow)
            : Theme.of(context).textTheme.bodySmall?.color);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isPastDue
            ? const Color(SwiftleadTokens.errorRed).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isPastDue
            ? Border.all(
                color: const Color(SwiftleadTokens.errorRed).withOpacity(0.3),
              )
            : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            _formatDate(date),
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

