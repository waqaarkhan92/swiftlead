import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// DNDScheduleEditor - Time range + days selector
/// Exact specification from UI_Inventory_v2.5.1
class DNDScheduleEditor extends StatefulWidget {
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final List<int>? days;
  final bool overrideCritical;
  final Function(TimeOfDay start, TimeOfDay end, List<int> days, bool overrideCritical)? onScheduleChanged;

  const DNDScheduleEditor({
    super.key,
    this.startTime,
    this.endTime,
    this.days,
    this.overrideCritical = false,
    this.onScheduleChanged,
  });

  @override
  State<DNDScheduleEditor> createState() => _DNDScheduleEditorState();
}

class _DNDScheduleEditorState extends State<DNDScheduleEditor> {
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late List<int> _selectedDays;
  bool _overrideCritical = false;

  @override
  void initState() {
    super.initState();
    _startTime = widget.startTime ?? const TimeOfDay(hour: 22, minute: 0);
    _endTime = widget.endTime ?? const TimeOfDay(hour: 8, minute: 0);
    _selectedDays = widget.days ?? [1, 2, 3, 4, 5, 6, 7]; // All days
    _overrideCritical = widget.overrideCritical;
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Do Not Disturb Schedule',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Time Range
          Row(
            children: [
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Start Time',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    _startTime.format(context),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _startTime,
                    );
                    if (picked != null) {
                      setState(() {
                        _startTime = picked;
                      });
                      widget.onScheduleChanged?.call(_startTime, _endTime, _selectedDays, _overrideCritical);
                    }
                  },
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'End Time',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    _endTime.format(context),
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _endTime,
                    );
                    if (picked != null) {
                      setState(() {
                        _endTime = picked;
                      });
                      widget.onScheduleChanged?.call(_startTime, _endTime, _selectedDays, _overrideCritical);
                    }
                  },
                ),
              ),
            ],
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
              final index = entry.key + 1;
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
                  widget.onScheduleChanged?.call(_startTime, _endTime, _selectedDays, _overrideCritical);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Override Critical Toggle
          SwitchListTile(
            title: const Text('Override for Critical Notifications'),
            subtitle: const Text('Allow critical notifications even during DND'),
            value: _overrideCritical,
            onChanged: (value) {
              setState(() {
                _overrideCritical = value;
              });
              widget.onScheduleChanged?.call(_startTime, _endTime, _selectedDays, _overrideCritical);
            },
          ),
        ],
      ),
    );
  }
}

