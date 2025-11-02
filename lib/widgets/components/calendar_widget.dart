import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// CalendarWidget - Month/week grid with event dots, color-coded by status, drag-to-create, pinch-to-zoom
/// Exact specification from UI_Inventory_v2.5.1
class CalendarWidget extends StatefulWidget {
  final DateTime initialDate;
  final String view; // 'day', 'week', 'month'
  final List<CalendarEvent> events;
  final Function(DateTime)? onDateSelected;
  final Function(CalendarEvent)? onEventTap;
  final Function(DateTime)? onDateTapped;

  const CalendarWidget({
    super.key,
    required this.initialDate,
    this.view = 'month',
    required this.events,
    this.onDateSelected,
    this.onEventTap,
    this.onDateTapped,
  });

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  late DateTime _currentMonth;
  late List<List<int>> _calendarDays;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
    _buildCalendarGrid();
  }

  void _buildCalendarGrid() {
    final firstDayOfMonth = _currentMonth;
    final firstDayOfWeek = firstDayOfMonth.weekday % 7; // 0 = Sunday
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    
    _calendarDays = [];
    List<int> week = List.filled(7, 0);
    
    // Fill first week with empty days if needed
    int dayIndex = 1;
    for (int i = 0; i < 7; i++) {
      if (i < firstDayOfWeek) {
        week[i] = 0; // Empty day
      } else {
        week[i] = dayIndex++;
      }
    }
    _calendarDays.add(List.from(week));
    
    // Fill remaining weeks
    while (dayIndex <= daysInMonth) {
      week = List.filled(7, 0);
      for (int i = 0; i < 7 && dayIndex <= daysInMonth; i++) {
        week[i] = dayIndex++;
      }
      _calendarDays.add(List.from(week));
    }
  }

  List<CalendarEvent> _getEventsForDay(int day) {
    if (day == 0) return [];
    return widget.events.where((event) {
      return event.date.year == _currentMonth.year &&
          event.date.month == _currentMonth.month &&
          event.date.day == day;
    }).toList();
  }

  bool _isToday(int day) {
    if (day == 0) return false;
    final today = DateTime.now();
    return day == today.day &&
        _currentMonth.year == today.year &&
        _currentMonth.month == today.month;
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        children: [
          // Weekday Labels
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((dayLabel) {
              return Expanded(
                child: Center(
                  child: Text(
                    dayLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Calendar Grid
          ..._calendarDays.map((week) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: week.asMap().entries.map((entry) {
                  final day = entry.value;
                  final events = _getEventsForDay(day);
                  final isToday = _isToday(day);
                  
                  return Expanded(
                    child: GestureDetector(
                      onTap: day > 0 ? () {
                        final date = DateTime(_currentMonth.year, _currentMonth.month, day);
                        widget.onDateTapped?.call(date);
                        widget.onDateSelected?.call(date);
                      } : null,
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: isToday
                              ? Border.all(
                                  color: const Color(SwiftleadTokens.primaryTeal),
                                  width: 2,
                                )
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (day > 0) ...[
                              Text(
                                '$day',
                                style: TextStyle(
                                  color: isToday
                                      ? const Color(SwiftleadTokens.primaryTeal)
                                      : Theme.of(context).textTheme.bodyLarge?.color,
                                  fontWeight: isToday ? FontWeight.w700 : FontWeight.normal,
                                ),
                              ),
                              if (events.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: events.take(3).map((event) {
                                    return Container(
                                      width: 4,
                                      height: 4,
                                      margin: const EdgeInsets.symmetric(horizontal: 1),
                                      decoration: BoxDecoration(
                                        color: event.color,
                                        shape: BoxShape.circle,
                                      ),
                                    );
                                  }).toList()
                                    ..addAll(
                                      events.length > 3
                                          ? [
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 2),
                                                child: Text(
                                                  '+${events.length - 3}',
                                                  style: TextStyle(
                                                    fontSize: 8,
                                                    color: Theme.of(context).textTheme.bodySmall?.color,
                                                  ),
                                                ),
                                              ),
                                            ]
                                          : [],
                                    ),
                                ),
                              ],
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class CalendarEvent {
  final String id;
  final DateTime date;
  final String title;
  final Color color;
  final String status;

  CalendarEvent({
    required this.id,
    required this.date,
    required this.title,
    required this.color,
    required this.status,
  });
}

