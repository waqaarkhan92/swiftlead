import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// ConfidenceIndicator - Visual gauge showing AI confidence level (0-100%)
/// Exact specification from UI_Inventory_v2.5.1
class ConfidenceIndicator extends StatelessWidget {
  final int confidence; // 0-100
  final String? label;
  final bool showValue;

  const ConfidenceIndicator({
    super.key,
    required this.confidence,
    this.label,
    this.showValue = true,
  });

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 80) return const Color(SwiftleadTokens.successGreen);
    if (confidence >= 60) return const Color(SwiftleadTokens.warningYellow);
    return const Color(SwiftleadTokens.errorRed);
  }

  String _getConfidenceLabel(int confidence) {
    if (confidence >= 80) return 'High';
    if (confidence >= 60) return 'Medium';
    return 'Low';
  }

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
          
          // Confidence Gauge
          Stack(
            alignment: Alignment.center,
            children: [
              // Background Circle
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: confidence / 100,
                  strokeWidth: 12,
                  backgroundColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.05)
                      : Colors.white.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getConfidenceColor(confidence),
                  ),
                ),
              ),
              
              // Center Text
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showValue)
                    Text(
                      '$confidence%',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _getConfidenceColor(confidence),
                      ),
                    ),
                  Text(
                    _getConfidenceLabel(confidence),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getConfidenceColor(confidence),
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: SwiftleadTokens.spaceS),
          
          // Confidence Bar (Linear)
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: confidence / 100,
              minHeight: 8,
              backgroundColor: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.05)
                  : Colors.white.withOpacity(0.05),
              valueColor: AlwaysStoppedAnimation<Color>(
                _getConfidenceColor(confidence),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

