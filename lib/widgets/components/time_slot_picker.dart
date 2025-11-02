import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';

/// TimeSlotPicker - Visual time slot selector with availability shading
/// Exact specification from UI_Inventory_v2.5.1
class TimeSlotPicker extends StatefulWidget {
  final List<TimeSlot> availableSlots;
  final List<TimeSlot>? bookedSlots;
  final TimeOfDay? selectedTime;
  final Function(TimeOfDay)? onTimeSelected;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int intervalMinutes;

  const TimeSlotPicker({
    super.key,
    this.availableSlots = const [],
    this.bookedSlots,
    this.selectedTime,
    this.onTimeSelected,
    this.startTime = const TimeOfDay(hour: 9, minute: 0),
    this.endTime = const TimeOfDay(hour: 17, minute: 0),
    this.intervalMinutes = 30,
  });

  @override
  State<TimeSlotPicker> createState() => _TimeSlotPickerState();
}

class _TimeSlotPickerState extends State<TimeSlotPicker> {
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _selectedTime = widget.selectedTime;
  }

  List<TimeSlot> _generateSlots() {
    final slots = <TimeSlot>[];
    int currentHour = widget.startTime.hour;
    int currentMinute = widget.startTime.minute;

    while (currentHour < widget.endTime.hour ||
        (currentHour == widget.endTime.hour && currentMinute <= widget.endTime.minute)) {
      final time = TimeOfDay(hour: currentHour, minute: currentMinute);
      final isBooked = widget.bookedSlots?.any((slot) =>
          slot.time.hour == time.hour && slot.time.minute == time.minute) ?? false;
      final isAvailable = widget.availableSlots.isEmpty ||
          widget.availableSlots.any((slot) =>
              slot.time.hour == time.hour && slot.time.minute == time.minute);

      slots.add(TimeSlot(
        time: time,
        isAvailable: isAvailable && !isBooked,
        isBooked: isBooked,
      ));

      currentMinute += widget.intervalMinutes;
      if (currentMinute >= 60) {
        currentMinute = 0;
        currentHour++;
      }
    }

    return slots;
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final slots = _generateSlots();

    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Time Slot',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Time Slots Grid
          Wrap(
            spacing: SwiftleadTokens.spaceS,
            runSpacing: SwiftleadTokens.spaceS,
            children: slots.map((slot) {
              final isSelected = _selectedTime != null &&
                  _selectedTime!.hour == slot.time.hour &&
                  _selectedTime!.minute == slot.time.minute;

              return GestureDetector(
                onTap: slot.isAvailable && !slot.isBooked
                    ? () {
                        setState(() {
                          _selectedTime = slot.time;
                        });
                        widget.onTimeSelected?.call(slot.time);
                      }
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: SwiftleadTokens.spaceM,
                    vertical: SwiftleadTokens.spaceS,
                  ),
                  decoration: BoxDecoration(
                    color: slot.isBooked
                        ? Theme.of(context).brightness == Brightness.light
                            ? Colors.black.withOpacity(0.05)
                            : Colors.white.withOpacity(0.05)
                        : isSelected
                            ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.2)
                            : slot.isAvailable
                                ? Colors.transparent
                                : Theme.of(context).brightness == Brightness.light
                                    ? Colors.black.withOpacity(0.03)
                                    : Colors.white.withOpacity(0.03),
                    border: Border.all(
                      color: slot.isBooked
                          ? Colors.transparent
                          : isSelected
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : slot.isAvailable
                                  ? Theme.of(context).brightness == Brightness.light
                                      ? Colors.black.withOpacity(0.1)
                                      : Colors.white.withOpacity(0.1)
                                  : Colors.transparent,
                      width: isSelected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
                  ),
                  child: Text(
                    _formatTime(slot.time),
                    style: TextStyle(
                      color: slot.isBooked
                          ? Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5)
                          : isSelected
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : slot.isAvailable
                                  ? Theme.of(context).textTheme.bodyMedium?.color
                                  : Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      decoration: slot.isBooked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class TimeSlot {
  final TimeOfDay time;
  final bool isAvailable;
  final bool isBooked;

  TimeSlot({
    required this.time,
    required this.isAvailable,
    this.isBooked = false,
  });
}

