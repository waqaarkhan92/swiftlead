import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// SegmentedControl - Tab-like toggle between views
/// Exact specification from UI_Inventory_v2.5.1
class SegmentedControl extends StatelessWidget {
  final List<String> segments;
  final int selectedIndex;
  final Function(int) onSelectionChanged;
  final List<int>? badgeCounts;
  
  const SegmentedControl({
    super.key,
    required this.segments,
    required this.selectedIndex,
    required this.onSelectionChanged,
    this.badgeCounts,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isLight
            ? Colors.black.withOpacity(0.05)
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: segments.asMap().entries.map((entry) {
          final index = entry.key;
          final segment = entry.value;
          final isSelected = index == selectedIndex;
          final badge = badgeCounts != null && index < badgeCounts!.length
              ? badgeCounts![index]
              : null;
          
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelectionChanged(index),
              child: AnimatedContainer(
                duration: SwiftleadTokens.motionFast,
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.white
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton - 4),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(isLight ? 0.05 : 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        badge != null ? '$segment ($badge)' : segment,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : Theme.of(context).textTheme.bodyMedium?.color,
                          fontSize: 13,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

