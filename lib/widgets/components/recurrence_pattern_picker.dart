import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';

/// RecurrencePatternPicker - Visual picker for daily/weekly/monthly patterns with preview
/// Exact specification from UI_Inventory_v2.5.1
class RecurrencePatternPicker extends StatefulWidget {
  final RecurrencePattern? initialPattern;
  final Function(RecurrencePattern)? onPatternChanged;

  const RecurrencePatternPicker({
    super.key,
    this.initialPattern,
    this.onPatternChanged,
  });

  @override
  State<RecurrencePatternPicker> createState() => _RecurrencePatternPickerState();
}

class _RecurrencePatternPickerState extends State<RecurrencePatternPicker> {
  RecurrencePattern? _selectedPattern;

  @override
  void initState() {
    super.initState();
    _selectedPattern = widget.initialPattern;
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recurrence Pattern',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Pattern Type Selection
          Wrap(
            spacing: SwiftleadTokens.spaceS,
            runSpacing: SwiftleadTokens.spaceS,
            children: [
              'Daily',
              'Weekly',
              'Monthly',
              'None',
            ].map((type) {
              final isSelected = _selectedPattern?.type == type.toLowerCase();
              return SwiftleadChip(
                label: type,
                isSelected: isSelected,
                onTap: () {
                  setState(() {
                    if (type == 'None') {
                      _selectedPattern = null;
                    } else {
                      _selectedPattern = RecurrencePattern(
                        type: type.toLowerCase(),
                        interval: 1,
                      );
                    }
                  });
                  widget.onPatternChanged?.call(_selectedPattern!);
                },
              );
            }).toList(),
          ),
          
          if (_selectedPattern != null && _selectedPattern!.type != 'none') ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            
            // Interval Selection
            Row(
              children: [
                Text(
                  'Repeat every',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _selectedPattern!.interval,
                    decoration: InputDecoration(
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                      ),
                    ),
                    items: List.generate(10, (i) => i + 1)
                        .map((num) => DropdownMenuItem(
                              value: num,
                              child: Text(num.toString()),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPattern = RecurrencePattern(
                          type: _selectedPattern!.type,
                          interval: value!,
                        );
                      });
                      widget.onPatternChanged?.call(_selectedPattern!);
                    },
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Text(
                  _selectedPattern!.type,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            
            const SizedBox(height: SwiftleadTokens.spaceM),
            
            // Preview
            Container(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.05),
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline,
                    size: 16,
                    color: Color(SwiftleadTokens.primaryTeal),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Expanded(
                    child: Text(
                      'Preview: This booking will repeat ${_selectedPattern!.interval > 1 ? "every ${_selectedPattern!.interval} " : ""}${_selectedPattern!.type}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(SwiftleadTokens.primaryTeal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class RecurrencePattern {
  final String type; // 'daily', 'weekly', 'monthly'
  final int interval;

  RecurrencePattern({
    required this.type,
    this.interval = 1,
  });
}

