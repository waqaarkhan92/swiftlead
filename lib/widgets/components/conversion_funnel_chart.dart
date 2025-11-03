import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// ConversionFunnelChart - Visual funnel showing drop-off at each stage
/// Exact specification from UI_Inventory_v2.5.1
class ConversionFunnelChart extends StatelessWidget {
  final List<FunnelStage> stages;
  final VoidCallback? onStageTap;

  const ConversionFunnelChart({
    super.key,
    required this.stages,
    this.onStageTap,
  });

  @override
  Widget build(BuildContext context) {
    if (stages.isEmpty) {
      return const SizedBox.shrink();
    }

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Conversion Funnel',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Funnel visualization
          ...stages.asMap().entries.map((entry) {
            final index = entry.key;
            final stage = entry.value;
            final percentage = (stage.value / stages.first.value) * 100;
            
            return GestureDetector(
              onTap: () => onStageTap?.call(),
              child: _FunnelBar(
                label: stage.label,
                value: stage.value,
                percentage: percentage,
                color: _getStageColor(index),
                isFirst: index == 0,
                isLast: index == stages.length - 1,
              ),
            );
          }).toList(),
          
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Legend
          Wrap(
            spacing: SwiftleadTokens.spaceM,
            runSpacing: SwiftleadTokens.spaceS,
            children: stages.asMap().entries.map((entry) {
              final index = entry.key;
              final stage = entry.value;
              return _LegendItem(
                color: _getStageColor(index),
                label: stage.label,
                value: stage.value,
                dropOff: entry.key > 0 
                    ? ((stage.value - stages[entry.key - 1].value) / stages[entry.key - 1].value * 100).abs()
                    : null,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getStageColor(int index) {
    final colors = [
      const Color(SwiftleadTokens.primaryTeal),
      const Color(SwiftleadTokens.successGreen),
      const Color(SwiftleadTokens.warningOrange),
      const Color(SwiftleadTokens.errorRed),
    ];
    return colors[index % colors.length];
  }
}

class _FunnelBar extends StatelessWidget {
  final String label;
  final int value;
  final double percentage;
  final Color color;
  final bool isFirst;
  final bool isLast;

  const _FunnelBar({
    required this.label,
    required this.value,
    required this.percentage,
    required this.color,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        bottom: SwiftleadTokens.spaceS,
        left: isFirst ? 0 : 20,
        right: isLast ? 0 : 20,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceS,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusSmall),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          Text(
            value.toString(),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceS),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: SwiftleadTokens.spaceS,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusSmall),
            ),
            child: Text(
              '${percentage.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final int value;
  final double? dropOff;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
    this.dropOff,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
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
            if (dropOff != null)
              Text(
                '${dropOff!.toStringAsFixed(1)}% drop-off',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// Funnel stage model
class FunnelStage {
  final String label;
  final int value;

  FunnelStage({
    required this.label,
    required this.value,
  });
}

