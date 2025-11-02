import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/chip.dart';

/// RescheduleSheet - Reschedule a booking
/// Exact specification from Screen_Layouts_v2.5.1
class RescheduleSheet {
  static void show({
    required BuildContext context,
    required String bookingTitle,
    required DateTime currentStartTime,
    required DateTime currentEndTime,
    required String? clientName,
    Function(DateTime newStartTime, DateTime newEndTime, String? reason, bool notifyClient)? onReschedule,
  }) {
    DateTime? selectedDate;
    TimeOfDay? selectedStartTime;
    TimeOfDay? selectedEndTime;
    final TextEditingController reasonController = TextEditingController();
    bool notifyClient = true;

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Reschedule Booking',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Current Booking Card
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Current Booking',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Text(
                    bookingTitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (clientName != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      clientName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${currentStartTime.day}/${currentStartTime.month}/${currentStartTime.year}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceM),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${currentStartTime.hour.toString().padLeft(2, '0')}:${currentStartTime.minute.toString().padLeft(2, '0')} - ${currentEndTime.hour.toString().padLeft(2, '0')}:${currentEndTime.minute.toString().padLeft(2, '0')}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // New Date Picker
            Text(
              'Select New Date',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? currentStartTime,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : 'Select Date',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // New Time Pickers
            Text(
              'Select New Time',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedStartTime ?? TimeOfDay.fromDateTime(currentStartTime),
                      );
                      if (time != null) {
                        setState(() {
                          selectedStartTime = time;
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      selectedStartTime != null
                          ? '${selectedStartTime!.hour.toString().padLeft(2, '0')}:${selectedStartTime!.minute.toString().padLeft(2, '0')}'
                          : 'Start',
                    ),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: selectedEndTime ?? TimeOfDay.fromDateTime(currentEndTime),
                      );
                      if (time != null) {
                        setState(() {
                          selectedEndTime = time;
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      selectedEndTime != null
                          ? '${selectedEndTime!.hour.toString().padLeft(2, '0')}:${selectedEndTime!.minute.toString().padLeft(2, '0')}'
                          : 'End',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Reason Field (Optional)
            Text(
              'Reason (Optional)',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add a reason for rescheduling...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Client Notification Toggle
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notify Client',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Send notification to client about rescheduling',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: notifyClient,
                    onChanged: (value) {
                      setState(() {
                        notifyClient = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Reschedule Button
            PrimaryButton(
              label: 'Reschedule',
              onPressed: () {
                if (selectedDate != null && selectedStartTime != null && selectedEndTime != null) {
                  final newStartTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedStartTime!.hour,
                    selectedStartTime!.minute,
                  );
                  final newEndTime = DateTime(
                    selectedDate!.year,
                    selectedDate!.month,
                    selectedDate!.day,
                    selectedEndTime!.hour,
                    selectedEndTime!.minute,
                  );
                  onReschedule?.call(
                    newStartTime,
                    newEndTime,
                    reasonController.text.isEmpty ? null : reasonController.text,
                    notifyClient,
                  );
                  Navigator.pop(context);
                }
              },
              icon: Icons.schedule,
            ),
          ],
        ),
      ),
    );
  }
}

