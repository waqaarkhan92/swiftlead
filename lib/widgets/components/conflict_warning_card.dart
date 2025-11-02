import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/info_banner.dart';
import '../global/primary_button.dart';

/// ConflictWarningCard - Warning card showing conflicting bookings with resolve options
/// Exact specification from UI_Inventory_v2.5.1
class ConflictWarningCard extends StatelessWidget {
  final String conflictingBookingTitle;
  final DateTime conflictingTime;
  final DateTime newBookingTime;
  final Function()? onAdjust;
  final Function()? onContinue;
  final Function()? onCancel;

  const ConflictWarningCard({
    super.key,
    required this.conflictingBookingTitle,
    required this.conflictingTime,
    required this.newBookingTime,
    this.onAdjust,
    this.onContinue,
    this.onCancel,
  });

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InfoBanner(
          message: 'Time slot conflicts with "$conflictingBookingTitle"',
          type: InfoBannerType.warning,
          onTap: null,
          onDismiss: onCancel,
        ),
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Conflict Details',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                'Existing: $_formatDateTime(conflictingTime)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                'New: $_formatDateTime(newBookingTime)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onCancel,
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onAdjust,
                      child: const Text('Adjust Time'),
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Continue',
                      onPressed: onContinue,
                      size: ButtonSize.small,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

