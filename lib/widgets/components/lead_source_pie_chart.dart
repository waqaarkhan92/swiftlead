import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// LeadSourcePieChart - Donut chart with breakdown by source
/// Exact specification from UI_Inventory_v2.5.1
class LeadSourcePieChart extends StatefulWidget {
  final List<LeadSourceData> sources;
  final Function(LeadSourceData)? onSourceTap;

  const LeadSourcePieChart({
    super.key,
    required this.sources,
    this.onSourceTap,
  });

  @override
  State<LeadSourcePieChart> createState() => _LeadSourcePieChartState();
}

class _LeadSourcePieChartState extends State<LeadSourcePieChart> {
  int? _touchedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.sources.isEmpty) {
      return const SizedBox.shrink();
    }

    final total = widget.sources.fold<int>(0, (sum, source) => sum + source.value);
    
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lead Sources',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Pie chart
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              _touchedIndex = null;
                              return;
                            }
                            _touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(show: false),
                      sectionsSpace: 2,
                      centerSpaceRadius: 50,
                      sections: _buildSections(total),
                    ),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: widget.sources.asMap().entries.map((entry) {
                        final index = entry.key;
                        final source = entry.value;
                        final isSelected = _touchedIndex == index;
                        final percentage = (source.value / total) * 100;
                        
                        return GestureDetector(
                          onTap: () => widget.onSourceTap?.call(source),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 3,
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? source.color.withOpacity(0.2)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                              border: isSelected 
                                  ? Border.all(color: source.color)
                                  : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: source.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        source.label,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                      Text(
                                        '${percentage.toStringAsFixed(1)}%',
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(int total) {
    return widget.sources.asMap().entries.map((entry) {
      final index = entry.key;
      final source = entry.value;
      final isSelected = _touchedIndex == index;
      final percentage = (source.value / total) * 100;
      
      return PieChartSectionData(
        color: source.color,
        value: source.value.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        radius: isSelected ? 60 : 50,
        titleStyle: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: _getContrastColor(source.color),
        ),
        borderSide: BorderSide(
          color: Colors.white,
          width: isSelected ? 3 : 2,
        ),
      );
    }).toList();
  }

  Color _getContrastColor(Color color) {
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

/// Lead source data model
class LeadSourceData {
  final String label;
  final int value;
  final Color color;

  LeadSourceData({
    required this.label,
    required this.value,
    required this.color,
  });
}

