import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// StageProgressBar - Visual stage progression
/// Exact specification from UI_Inventory_v2.5.1
class StageProgressBar extends StatelessWidget {
  final String currentStage;
  final List<String> stages;
  final Function(String stage)? onStageSelect;
  final bool readOnly;

  const StageProgressBar({
    super.key,
    required this.currentStage,
    required this.stages,
    this.onStageSelect,
    this.readOnly = false,
  });

  int _getCurrentIndex() {
    return stages.indexWhere((s) => s == currentStage);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex();
    final progress = currentIndex >= 0
        ? (currentIndex + 1) / stages.length
        : 0.0;

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.black.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(SwiftleadTokens.primaryTeal),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Stage labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: stages.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              final isCurrent = index == currentIndex;
              final isCompleted = index < currentIndex;
              
              return GestureDetector(
                onTap: readOnly
                    ? null
                    : () => onStageSelect?.call(stage),
                child: Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? const Color(SwiftleadTokens.successGreen)
                            : isCurrent
                                ? const Color(SwiftleadTokens.primaryTeal)
                                : Colors.black.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isCompleted
                            ? Icons.check
                            : Icons.circle,
                        size: 16,
                        color: isCompleted || isCurrent
                            ? Colors.white
                            : Colors.black.withOpacity(0.4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 60,
                      child: Text(
                        stage,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
                          color: isCurrent
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

