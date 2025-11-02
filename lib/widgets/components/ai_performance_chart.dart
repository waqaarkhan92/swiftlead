import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// AIPerformanceChart - Multi-series chart showing AI performance over time
/// Exact specification from UI_Inventory_v2.5.1
class AIPerformanceChart extends StatelessWidget {
  final List<_PerformanceDataPoint> data;
  final String? selectedMetric; // 'response_rate', 'booking_rate', 'satisfaction'
  final Function(String)? onMetricSelected;

  const AIPerformanceChart({
    super.key,
    required this.data,
    this.selectedMetric,
    this.onMetricSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Performance Over Time',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              // Metric Selector
              Row(
                children: [
                  _MetricChip(
                    label: 'Response',
                    isSelected: selectedMetric == 'response_rate',
                    onTap: () => onMetricSelected?.call('response_rate'),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  _MetricChip(
                    label: 'Booking',
                    isSelected: selectedMetric == 'booking_rate',
                    onTap: () => onMetricSelected?.call('booking_rate'),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  _MetricChip(
                    label: 'Satisfaction',
                    isSelected: selectedMetric == 'satisfaction',
                    onTap: () => onMetricSelected?.call('satisfaction'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Chart Placeholder (would use a chart library in production)
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black.withOpacity(0.02)
                  : Colors.white.withOpacity(0.02),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 48,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.3),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Text(
                    'Performance Chart',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    'Multi-series line chart showing trends over time',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.4),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Key Metrics Summary
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  label: 'Avg Response Time',
                  value: '2.4s',
                  trend: '+5%',
                  isPositive: false,
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: _MetricTile(
                  label: 'Booking Rate',
                  value: '42%',
                  trend: '+8%',
                  isPositive: true,
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: _MetricTile(
                  label: 'Satisfaction',
                  value: '4.8',
                  trend: '⭐',
                  isPositive: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _MetricChip({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
              : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? const Color(SwiftleadTokens.primaryTeal)
                : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color(SwiftleadTokens.primaryTeal)
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final String trend;
  final bool isPositive;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.trend,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black.withOpacity(0.02)
            : Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  color: isPositive
                      ? const Color(SwiftleadTokens.successGreen)
                      : const Color(SwiftleadTokens.errorRed),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PerformanceDataPoint {
  final DateTime date;
  final double responseRate;
  final double bookingRate;
  final double satisfaction;

  _PerformanceDataPoint({
    required this.date,
    required this.responseRate,
    required this.bookingRate,
    required this.satisfaction,
  });
}

