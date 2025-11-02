import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';

/// BusinessHoursGrid - Visual weekly schedule with time blocks
/// Exact specification from UI_Inventory_v2.5.1
class BusinessHoursGrid extends StatefulWidget {
  final Map<String, _DayHours> hours;
  final Function(String day, TimeOfDay? start, TimeOfDay? end)? onHoursChanged;

  const BusinessHoursGrid({
    super.key,
    required this.hours,
    this.onHoursChanged,
  });

  @override
  State<BusinessHoursGrid> createState() => _BusinessHoursGridState();
}

class _BusinessHoursGridState extends State<BusinessHoursGrid> {
  final Map<String, _DayHours> _hours = {};

  @override
  void initState() {
    super.initState();
    _hours.addAll(widget.hours);
  }

  @override
  Widget build(BuildContext context) {
    final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Hours',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          ...days.map((day) {
            final dayHours = _hours[day] ?? _DayHours(isClosed: true);
            return Padding(
              padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
              child: _DayRow(
                day: day,
                hours: dayHours,
                onToggle: (isClosed) {
                  setState(() {
                    if (isClosed) {
                      _hours[day] = _DayHours(isClosed: true);
                    } else {
                      _hours[day] = _DayHours(
                        isClosed: false,
                        start: const TimeOfDay(hour: 9, minute: 0),
                        end: const TimeOfDay(hour: 17, minute: 0),
                      );
                    }
                  });
                  widget.onHoursChanged?.call(
                    day,
                    _hours[day]?.start,
                    _hours[day]?.end,
                  );
                },
                onTimeChanged: (start, end) {
                  setState(() {
                    _hours[day] = _DayHours(
                      isClosed: false,
                      start: start,
                      end: end,
                    );
                  });
                  widget.onHoursChanged?.call(day, start, end);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DayRow extends StatelessWidget {
  final String day;
  final _DayHours hours;
  final Function(bool) onToggle;
  final Function(TimeOfDay, TimeOfDay) onTimeChanged;

  const _DayRow({
    required this.day,
    required this.hours,
    required this.onToggle,
    required this.onTimeChanged,
  });

  Future<void> _selectTime(
    BuildContext context,
    bool isStart,
    TimeOfDay currentTime,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: currentTime,
    );
    if (picked != null) {
      if (isStart) {
        onTimeChanged(picked, hours.end ?? picked);
      } else {
        onTimeChanged(hours.start ?? picked, picked);
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            day,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Switch(
                value: !hours.isClosed,
                onChanged: onToggle,
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              if (!hours.isClosed && hours.start != null && hours.end != null) ...[
                OutlinedButton(
                  onPressed: () => _selectTime(context, true, hours.start!),
                  child: Text(_formatTime(hours.start!)),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                const Text('to'),
                const SizedBox(width: SwiftleadTokens.spaceS),
                OutlinedButton(
                  onPressed: () => _selectTime(context, false, hours.end!),
                  child: Text(_formatTime(hours.end!)),
                ),
              ] else if (!hours.isClosed)
                const Text('Set hours'),
              if (hours.isClosed)
                Text(
                  'Closed',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayHours {
  final bool isClosed;
  final TimeOfDay? start;
  final TimeOfDay? end;

  _DayHours({
    this.isClosed = false,
    this.start,
    this.end,
  });
}

