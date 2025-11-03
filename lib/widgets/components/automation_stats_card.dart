import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// AutomationStatsCard - Shows automation activity and time saved
/// Exact specification from UI_Inventory_v2.5.1 line 363
class AutomationStatsCard extends StatelessWidget {
  final int actionsCompleted;
  final double timeSavedHours;
  final int successRate;
  final double costSaved;
  final VoidCallback? onTap;

  const AutomationStatsCard({
    super.key,
    required this.actionsCompleted,
    required this.timeSavedHours,
    required this.successRate,
    required this.costSaved,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Automation Stats',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Icon(
                  Icons.autorenew,
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Actions',
                    value: '$actionsCompleted',
                    icon: Icons.check_circle_outline,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Time Saved',
                    value: '${timeSavedHours.toStringAsFixed(1)}h',
                    icon: Icons.access_time,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                Expanded(
                  child: _StatItem(
                    label: 'Success Rate',
                    value: '$successRate%',
                    icon: Icons.trending_up,
                  ),
                ),
                Expanded(
                  child: _StatItem(
                    label: 'Cost Saved',
                    value: '£${costSaved.toStringAsFixed(0)}',
                    icon: Icons.savings_outlined,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: const Color(SwiftleadTokens.primaryTeal),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: const Color(SwiftleadTokens.primaryTeal),
              ),
        ),
      ],
    );
  }
}

