import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// DateSeparator - Date divider in chat thread
/// Exact specification from Screen_Layouts_v2.5.1
class DateSeparator extends StatelessWidget {
  final DateTime date;
  
  const DateSeparator({
    super.key,
    required this.date,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateDay = DateTime(date.year, date.month, date.day);
    
    if (dateDay == today) {
      return 'Today';
    } else if (dateDay == yesterday) {
      return 'Yesterday';
    } else {
      return '${date.day} ${_getMonthName(date.month)} ${date.year}';
    }
  }

  String _getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceM),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceM),
            child: Text(
              _formatDate(date),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

