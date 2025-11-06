import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import 'segmented_control.dart';

/// TrendLineChart - Interactive line chart
/// Exact specification from UI_Inventory_v2.5.1
class TrendLineChart extends StatefulWidget {
  final String title;
  final List<ChartDataPoint> dataPoints;
  final Color? lineColor;
  final String yAxisLabel;
  final Function(ChartDataPoint)? onDataPointTap;
  final Map<String, List<ChartDataPoint>>? periodData; // Optional period data

  const TrendLineChart({
    super.key,
    required this.title,
    required this.dataPoints,
    this.lineColor,
    this.yAxisLabel = '',
    this.onDataPointTap,
    this.periodData,
  });

  @override
  State<TrendLineChart> createState() => _TrendLineChartState();
}

class _TrendLineChartState extends State<TrendLineChart> {
  List<ChartDataPoint> _displayData = [];
  int _selectedPeriodIndex = 0;

  @override
  void initState() {
    super.initState();
    _displayData = widget.dataPoints;
    _selectedPeriodIndex = 0;
  }

  @override
  void didUpdateWidget(TrendLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.dataPoints != oldWidget.dataPoints || widget.periodData != oldWidget.periodData) {
      _updateDisplayData();
    }
  }

  void _updateDisplayData() {
    if (widget.periodData != null && _selectedPeriodIndex < widget.periodData!.values.length) {
      _displayData = widget.periodData!.values.elementAt(_selectedPeriodIndex);
    } else {
      _displayData = widget.dataPoints;
    }
  }

  void _onPeriodChanged(int index) {
    setState(() {
      _selectedPeriodIndex = index;
      _updateDisplayData();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_displayData.isEmpty) {
      return const SizedBox.shrink();
    }

    final chartColor = widget.lineColor ?? const Color(SwiftleadTokens.primaryTeal);
    final maxY = _displayData
        .map((d) => d.value)
        .reduce((a, b) => a > b ? a : b);
    final minY = _displayData
        .map((d) => d.value)
        .reduce((a, b) => a < b ? a : b);
    final yRange = maxY - minY;
    final paddingY = yRange * 0.1;

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          if (widget.periodData != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            SegmentedControl(
              segments: widget.periodData!.keys.toList(),
              selectedIndex: _selectedPeriodIndex,
              onSelectionChanged: _onPeriodChanged,
            ),
          ],
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          SizedBox(
            height: 250,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: (maxY - minY) / 4,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade300,
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < _displayData.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              _displayData[index].label,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 10,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 50,
                      interval: (maxY - minY) / 4,
                      getTitlesWidget: (value, meta) {
                        // Format for hours (e.g., 8.5h) or whole numbers
                        final displayValue = value % 1 == 0 
                            ? value.toInt().toString()
                            : value.toStringAsFixed(1);
                        return Text(
                          displayValue,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 10,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                minX: 0,
                maxX: _displayData.length.toDouble() - 1,
                minY: minY - paddingY,
                maxY: maxY + paddingY,
                lineBarsData: [
                  LineChartBarData(
                    spots: _displayData
                        .asMap()
                        .entries
                        .map((entry) => FlSpot(
                              entry.key.toDouble(),
                              entry.value.value,
                            ))
                        .toList(),
                    isCurved: true,
                    curveSmoothness: 0.35,
                    color: chartColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          chartColor.withValues(alpha: 0.3),
                          chartColor.withValues(alpha: 0.05),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: chartColor,
                    tooltipRoundedRadius: 8,
                    fitInsideHorizontally: true,
                    getTooltipItems: (List<LineBarSpot> touchedSpots) {
                      return touchedSpots.map((spot) {
                        final value = spot.y;
                        final displayValue = value % 1 == 0 
                            ? value.toInt().toString()
                            : value.toStringAsFixed(1);
                        final label = widget.yAxisLabel.isNotEmpty 
                            ? '${displayValue}${widget.yAxisLabel}'
                            : displayValue;
                        return LineTooltipItem(
                          '${_displayData[spot.x.toInt()].label}\n$label',
                          const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchedSpotIndicator: (LineChartBarData barData,
                      List<int> indicators) {
                    return indicators.map((index) {
                      final spot = barData.spots[index];
                      if (spot.x == -1 || spot.y == -1) {
                        return const TouchedSpotIndicatorData(
                          FlLine(color: Colors.transparent),
                          FlDotData(show: false),
                        );
                      }
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: chartColor,
                          strokeWidth: 2,
                        ),
                        FlDotData(
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 6,
                            color: chartColor,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                    if (response != null && response.lineBarSpots != null) {
                      final spot = response.lineBarSpots!.first;
                      widget.onDataPointTap?.call(_displayData[spot.x.toInt()]);
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Chart data point model
class ChartDataPoint {
  final String label;
  final double value;

  ChartDataPoint({
    required this.label,
    required this.value,
  });
}

