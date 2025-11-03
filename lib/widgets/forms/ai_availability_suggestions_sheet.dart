import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';

/// AIAvailabilitySuggestionsSheet - AI-powered availability suggestions
/// Exact specification from UI_Inventory_v2.5.1
class AIAvailabilitySuggestionsSheet {
  static Future<DateTime?> show({
    required BuildContext context,
    required DateTime startDate,
    required int durationMinutes,
  }) async {
    DateTime? selectedTime;
    List<_TimeSlot> suggestions = [];

    // Generate AI suggestions (mock)
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    suggestions = [
      _TimeSlot(
        date: tomorrow,
        time: '09:00',
        confidence: 0.95,
        reason: 'No conflicts, optimal time',
      ),
      _TimeSlot(
        date: tomorrow,
        time: '14:00',
        confidence: 0.88,
        reason: 'Good availability',
      ),
      _TimeSlot(
        date: tomorrow.add(const Duration(days: 1)),
        time: '10:00',
        confidence: 0.92,
        reason: 'Peak booking time',
      ),
      _TimeSlot(
        date: tomorrow.add(const Duration(days: 1)),
        time: '15:30',
        confidence: 0.85,
        reason: 'Afternoon slot available',
      ),
    ];

    return await SwiftleadBottomSheet.show<DateTime>(
      context: context,
      title: 'AI Availability Suggestions',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            Text(
              'Based on your schedule and preferences, here are the best times:',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
            ...suggestions.map((slot) {
              final isSelected = selectedTime != null &&
                  selectedTime!.day == slot.date.day &&
                  selectedTime!.hour == int.parse(slot.time.split(':')[0]);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                child: InkWell(
                  onTap: () {
                    final timeParts = slot.time.split(':');
                    final selected = DateTime(
                      slot.date.year,
                      slot.date.month,
                      slot.date.day,
                      int.parse(timeParts[0]),
                      int.parse(timeParts[1]),
                    );
                    setState(() {
                      selectedTime = selected;
                    });
                  },
                  child: FrostedContainer(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isSelected
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : null,
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    _formatDate(slot.date),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: SwiftleadTokens.spaceS),
                                  Text(
                                    slot.time,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: const Color(SwiftleadTokens.primaryTeal),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.insights,
                                    size: 14,
                                    color: _getConfidenceColor(slot.confidence),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${(slot.confidence * 100).toStringAsFixed(0)}% match',
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: _getConfidenceColor(slot.confidence),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                slot.reason,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: SwiftleadTokens.spaceL),
            PrimaryButton(
              label: 'Select Time',
              onPressed: selectedTime != null
                  ? () => Navigator.pop(context, selectedTime)
                  : null,
              icon: Icons.check,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == tomorrow) return 'Tomorrow';
    return '${date.day}/${date.month}/${date.year}';
  }

  static Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.9) return const Color(SwiftleadTokens.successGreen);
    if (confidence >= 0.8) return const Color(SwiftleadTokens.primaryTeal);
    return const Color(SwiftleadTokens.warningYellow);
  }
}

class _TimeSlot {
  final DateTime date;
  final String time;
  final double confidence;
  final String reason;

  _TimeSlot({
    required this.date,
    required this.time,
    required this.confidence,
    required this.reason,
  });
}

