import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// KPICard - Large metric card with current value, trend arrow, vs previous period, sparkline
/// Exact specification from UI_Inventory_v2.5.1
class KPICard extends StatelessWidget {
  final String label;
  final String value;
  final String? trend;
  final String? vsPreviousPeriod;
  final bool isPositive;
  final List<double>? sparklineData;
  final String? tooltip;
  final VoidCallback? onTap;
  
  const KPICard({
    super.key,
    required this.label,
    required this.value,
    this.trend,
    this.vsPreviousPeriod,
    this.isPositive = true,
    this.sparklineData,
    this.tooltip,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: tooltip != null
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(tooltip!),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          : null,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            if (sparklineData != null && sparklineData!.isNotEmpty) ...[
              const SizedBox(height: 16),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    data: sparklineData!,
                    color: isPositive
                        ? const Color(SwiftleadTokens.successGreen)
                        : const Color(SwiftleadTokens.errorRed),
                  ),
                ),
              ),
            ],
            if (trend != null || vsPreviousPeriod != null) ...[
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (trend != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPositive ? Icons.trending_up : Icons.trending_down,
                          size: 16,
                          color: isPositive
                              ? const Color(SwiftleadTokens.successGreen)
                              : const Color(SwiftleadTokens.errorRed),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          trend!,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: isPositive
                                    ? const Color(SwiftleadTokens.successGreen)
                                    : const Color(SwiftleadTokens.errorRed),
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ],
                    ),
                  if (vsPreviousPeriod != null)
                    Text(
                      'vs $vsPreviousPeriod',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<double> data;
  final Color color;

  _SparklinePainter({
    required this.data,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final path = Path();
    final maxValue = data.reduce((a, b) => a > b ? a : b);
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final range = maxValue - minValue;
    final stepX = size.width / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = i * stepX;
      final normalizedValue = range > 0
          ? (data[i] - minValue) / range
          : 0.5;
      final y = size.height - (normalizedValue * size.height);
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_SparklinePainter oldDelegate) {
    return oldDelegate.data != data || oldDelegate.color != color;
  }
}

