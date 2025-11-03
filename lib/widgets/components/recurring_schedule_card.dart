import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// RecurringScheduleCard - Shows recurring invoice schedule
/// Exact specification from UI_Inventory_v2.5.1
class RecurringScheduleCard extends StatelessWidget {
  final String invoiceNumber;
  final String clientName;
  final double amount;
  final RecurrenceFrequency frequency;
  final DateTime? nextOccurrence;
  final DateTime startDate;
  final RecurringInvoiceStatus status;
  final VoidCallback? onTap;

  const RecurringScheduleCard({
    super.key,
    required this.invoiceNumber,
    required this.clientName,
    required this.amount,
    required this.frequency,
    this.nextOccurrence,
    required this.startDate,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.repeat,
                            size: 18,
                            color: const Color(SwiftleadTokens.primaryTeal),
                          ),
                          const SizedBox(width: SwiftleadTokens.spaceS),
                          Text(
                            '#$invoiceNumber',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        clientName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
                SwiftleadBadge(
                  label: status.displayName,
                  variant: _getStatusBadgeVariant(status),
                  size: BadgeSize.medium,
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            
            // Amount
            Row(
              children: [
                Text(
                  '£${amount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(SwiftleadTokens.successGreen),
                      ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SwiftleadTokens.spaceS,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                  child: Text(
                    frequency.displayName,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(SwiftleadTokens.primaryTeal),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            
            const Divider(),
            const SizedBox(height: SwiftleadTokens.spaceS),
            
            // Schedule details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _ScheduleDetail(
                  icon: Icons.calendar_today,
                  label: 'Started',
                  value: '${startDate.day}/${startDate.month}/${startDate.year}',
                ),
                if (nextOccurrence != null)
                  _ScheduleDetail(
                    icon: Icons.next_plan,
                    label: 'Next',
                    value: '${nextOccurrence!.day}/${nextOccurrence!.month}/${nextOccurrence!.year}',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BadgeVariant _getStatusBadgeVariant(RecurringInvoiceStatus status) {
    switch (status) {
      case RecurringInvoiceStatus.active:
        return BadgeVariant.success;
      case RecurringInvoiceStatus.paused:
        return BadgeVariant.warning;
      case RecurringInvoiceStatus.cancelled:
        return BadgeVariant.error;
    }
  }
}

class _ScheduleDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ScheduleDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: SwiftleadTokens.spaceS),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Recurrence frequency enum
enum RecurrenceFrequency {
  weekly,
  biweekly,
  monthly,
  quarterly,
  yearly,
}

extension RecurrenceFrequencyExtension on RecurrenceFrequency {
  String get displayName {
    switch (this) {
      case RecurrenceFrequency.weekly:
        return 'Weekly';
      case RecurrenceFrequency.biweekly:
        return 'Bi-weekly';
      case RecurrenceFrequency.monthly:
        return 'Monthly';
      case RecurrenceFrequency.quarterly:
        return 'Quarterly';
      case RecurrenceFrequency.yearly:
        return 'Yearly';
    }
  }
}

/// Recurring invoice status enum
enum RecurringInvoiceStatus {
  active,
  paused,
  cancelled,
}

extension RecurringInvoiceStatusExtension on RecurringInvoiceStatus {
  String get displayName {
    switch (this) {
      case RecurringInvoiceStatus.active:
        return 'Active';
      case RecurringInvoiceStatus.paused:
        return 'Paused';
      case RecurringInvoiceStatus.cancelled:
        return 'Cancelled';
    }
  }
}

