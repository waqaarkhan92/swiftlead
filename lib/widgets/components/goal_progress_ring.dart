import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// GoalProgressRing - Circular progress indicator
/// Exact specification from UI_Inventory_v2.5.1
class GoalProgressRing extends StatelessWidget {
  final String goalName;
  final double currentValue;
  final double targetValue;
  final String unit;
  final Color? progressColor;
  final VoidCallback? onTap;

  const GoalProgressRing({
    super.key,
    required this.goalName,
    required this.currentValue,
    required this.targetValue,
    required this.unit,
    this.progressColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentValue / targetValue).clamp(0.0, 1.0);
    final color = progressColor ?? const Color(SwiftleadTokens.primaryTeal);
    final percentage = (progress * 100).toStringAsFixed(0);

    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Column(
          children: [
            Text(
              goalName,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            
            // Circular progress ring
            SizedBox(
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background circle
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: 1.0,
                      strokeWidth: 12,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.grey.shade200,
                      ),
                    ),
                  ),
                  // Progress circle
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      strokeCap: StrokeCap.round,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                  // Center text
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        percentage,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: color,
                            ),
                      ),
                      Text(
                        '%',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            
            // Stats
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                  label: 'Current',
                  value: '${currentValue.toStringAsFixed(0)}$unit',
                  color: color,
                ),
                _StatItem(
                  label: 'Target',
                  value: '${targetValue.toStringAsFixed(0)}$unit',
                  color: Colors.grey,
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
  final Color color;

  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

