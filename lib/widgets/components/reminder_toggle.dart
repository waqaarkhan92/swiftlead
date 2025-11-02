import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// ReminderToggle - Toggle switches for different reminder timings
/// Exact specification from UI_Inventory_v2.5.1
class ReminderToggle extends StatelessWidget {
  final String timing; // '24h', '2h', '30m', etc.
  final String label;
  final bool isEnabled;
  final Function(bool)? onChanged;

  const ReminderToggle({
    super.key,
    required this.timing,
    required this.label,
    this.isEnabled = false,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.notifications_outlined,
                size: 20,
                color: Color(SwiftleadTokens.primaryTeal),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    timing,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
          Switch(
            value: isEnabled,
            onChanged: onChanged,
            activeColor: const Color(SwiftleadTokens.primaryTeal),
          ),
        ],
      ),
    );
  }
}

