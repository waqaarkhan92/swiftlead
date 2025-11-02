import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// ScoreBreakdownCard - Detailed score breakdown
/// Exact specification from UI_Inventory_v2.5.1
class ScoreBreakdownCard extends StatelessWidget {
  final Map<String, int> scoreData;
  final VoidCallback? onClose;

  const ScoreBreakdownCard({
    super.key,
    required this.scoreData,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final totalScore = scoreData.values.fold(0, (sum, value) => sum + value);
    
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Score Breakdown',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: onClose,
                ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Total score
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Score',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  totalScore.toString(),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Score breakdown items
          ...scoreData.entries.map((entry) {
            final percentage = totalScore > 0
                ? (entry.value / totalScore * 100).round()
                : 0;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          entry.key,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      Text(
                        '+${entry.value}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color(SwiftleadTokens.successGreen),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: entry.value / 100,
                      minHeight: 4,
                      backgroundColor: Colors.black.withOpacity(0.05),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        const Color(SwiftleadTokens.successGreen).withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

