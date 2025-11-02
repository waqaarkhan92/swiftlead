import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// DigestScheduleSelector - Time and day pickers
/// Exact specification from UI_Inventory_v2.5.1
class DigestScheduleSelector extends StatefulWidget {
  final TimeOfDay? initialTime;
  final List<int>? initialDays;
  final Function(TimeOfDay time, List<int> days)? onScheduleChanged;

  const DigestScheduleSelector({
    super.key,
    this.initialTime,
    this.initialDays,
    this.onScheduleChanged,
  });

  @override
  State<DigestScheduleSelector> createState() => _DigestScheduleSelectorState();
}

class _DigestScheduleSelectorState extends State<DigestScheduleSelector> {
  late TimeOfDay _selectedTime;
  late List<int> _selectedDays;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.initialTime ?? const TimeOfDay(hour: 9, minute: 0);
    _selectedDays = widget.initialDays ?? [1, 2, 3, 4, 5]; // Monday-Friday
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Digest Schedule',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Time Picker
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Time',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              _selectedTime.format(context),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _selectedTime,
              );
              if (picked != null && picked != _selectedTime) {
                setState(() {
                  _selectedTime = picked;
                });
                widget.onScheduleChanged?.call(_selectedTime, _selectedDays);
              }
            },
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Days Selector
          Text(
            'Days',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Wrap(
            spacing: SwiftleadTokens.spaceS,
            children: [
              'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
            ].asMap().entries.map((entry) {
              final index = entry.key + 1; // 1 = Monday
              final day = entry.value;
              final isSelected = _selectedDays.contains(index);
              
              return FilterChip(
                selected: isSelected,
                label: Text(day),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedDays.add(index);
                    } else {
                      _selectedDays.remove(index);
                    }
                  });
                  widget.onScheduleChanged?.call(_selectedTime, _selectedDays);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

