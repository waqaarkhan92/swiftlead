import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../../models/message.dart';
import '../../models/scheduled_message.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../mock/mock_messages.dart';

/// ScheduleMessageSheet - Bottom sheet for scheduling messages
/// Exact specification from UI_Inventory_v2.5.1
class ScheduleMessageSheet {
  static Future<ScheduledMessage?> show({
    required BuildContext context,
    required String threadId,
    String? contactId,
    required MessageChannel channel,
    required String content,
    List<String>? mediaUrls,
  }) async {
    return await showModalBottomSheet<ScheduledMessage?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ScheduleMessageSheetContent(
        threadId: threadId,
        contactId: contactId,
        channel: channel,
        content: content,
        mediaUrls: mediaUrls,
      ),
    );
  }
}

class _ScheduleMessageSheetContent extends StatefulWidget {
  final String threadId;
  final String? contactId;
  final MessageChannel channel;
  final String content;
  final List<String>? mediaUrls;

  const _ScheduleMessageSheetContent({
    required this.threadId,
    this.contactId,
    required this.channel,
    required this.content,
    this.mediaUrls,
  });

  @override
  State<_ScheduleMessageSheetContent> createState() => _ScheduleMessageSheetContentState();
}

class _ScheduleMessageSheetContentState extends State<_ScheduleMessageSheetContent> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    // Default to tomorrow at 9am
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    _selectedDate = DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    _selectedTime = const TimeOfDay(hour: 9, minute: 0);
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  DateTime? get _scheduledDateTime {
    if (_selectedDate == null || _selectedTime == null) return null;
    return DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final date = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (date == today) {
      dateStr = 'Today';
    } else if (date == tomorrow) {
      dateStr = 'Tomorrow';
    } else {
      dateStr = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }

    final timeStr = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    return '$dateStr at $timeStr';
  }

  Future<void> _scheduleMessage() async {
    if (_scheduledDateTime == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final scheduled = await MockMessages.scheduleMessage(
        threadId: widget.threadId,
        contactId: widget.contactId,
        channel: widget.channel,
        content: widget.content,
        scheduledFor: _scheduledDateTime!,
        mediaUrls: widget.mediaUrls,
      );

      if (mounted) {
        Navigator.pop(context, scheduled);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error scheduling message: ${e.toString()}'),
            backgroundColor: const Color(SwiftleadTokens.errorRed),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SwiftleadBottomSheet(
      title: 'Schedule Message',
      height: SheetHeight.half,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Preview content
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Message Preview',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Text(
                    widget.content,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Date selector
            Text(
              'Date',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            InkWell(
              onTap: _selectDate,
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              child: Container(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : 'Select date',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Icon(Icons.calendar_today, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Time selector
            Text(
              'Time',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            InkWell(
              onTap: _selectTime,
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              child: Container(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  ),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : 'Select time',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const Icon(Icons.access_time, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Preview scheduled time
            if (_scheduledDateTime != null) ...[
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule,
                      color: Color(SwiftleadTokens.primaryTeal),
                      size: 20,
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: Text(
                        'Will send ${_formatDateTime(_scheduledDateTime!)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(SwiftleadTokens.primaryTeal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],

            // Schedule button
            PrimaryButton(
              label: 'Schedule Message',
              onPressed: _scheduledDateTime != null && !_isSaving ? _scheduleMessage : null,
              isLoading: _isSaving,
            ),
          ],
        ),
      ),
    );
  }
}

