import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// LearningProgressBar - Progress bar showing AI training progress and improvement over time
/// Exact specification from UI_Inventory_v2.5.1
class LearningProgressBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final int totalExamples;
  final int trainedExamples;
  final String? label;
  final String? improvementNote;

  const LearningProgressBar({
    super.key,
    required this.progress,
    required this.totalExamples,
    required this.trainedExamples,
    this.label,
    this.improvementNote,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null) ...[
            Text(
              label!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
          ],
          
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.05)
                  : Colors.white.withOpacity(0.05),
              valueColor: AlwaysStoppedAnimation<Color>(
                progress >= 0.8
                    ? const Color(SwiftleadTokens.successGreen)
                    : progress >= 0.5
                        ? const Color(SwiftleadTokens.warningYellow)
                        : const Color(SwiftleadTokens.primaryTeal),
              ),
            ),
          ),
          
          const SizedBox(height: SwiftleadTokens.spaceS),
          
          // Stats
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$trainedExamples / $totalExamples examples trained',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
              ),
            ],
          ),
          
          if (improvementNote != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  size: 16,
                  color: Color(SwiftleadTokens.successGreen),
                ),
                const SizedBox(width: SwiftleadTokens.spaceXS),
                Text(
                  improvementNote!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(SwiftleadTokens.successGreen),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

