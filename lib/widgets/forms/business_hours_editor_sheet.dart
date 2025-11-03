import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';

/// BusinessHoursEditorSheet - Edit business hours
/// Exact specification from UI_Inventory_v2.5.1
class BusinessHoursEditorSheet {
  static Future<String?> show({
    required BuildContext context,
    String? currentHours,
  }) async {
    Map<String, Map<String, TimeOfDay?>> hours = {
      'Monday': {'open': const TimeOfDay(hour: 9, minute: 0), 'close': const TimeOfDay(hour: 17, minute: 0)},
      'Tuesday': {'open': const TimeOfDay(hour: 9, minute: 0), 'close': const TimeOfDay(hour: 17, minute: 0)},
      'Wednesday': {'open': const TimeOfDay(hour: 9, minute: 0), 'close': const TimeOfDay(hour: 17, minute: 0)},
      'Thursday': {'open': const TimeOfDay(hour: 9, minute: 0), 'close': const TimeOfDay(hour: 17, minute: 0)},
      'Friday': {'open': const TimeOfDay(hour: 9, minute: 0), 'close': const TimeOfDay(hour: 17, minute: 0)},
      'Saturday': {'open': null, 'close': null},
      'Sunday': {'open': null, 'close': null},
    };

    return await SwiftleadBottomSheet.show<String>(
      context: context,
      title: 'Business Hours',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            ...hours.entries.map((entry) {
              final day = entry.key;
              final times = entry.value;
              final isClosed = times['open'] == null;

              return Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                child: FrostedContainer(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            day,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Switch(
                            value: !isClosed,
                            onChanged: (value) {
                              setState(() {
                                if (value) {
                                  hours[day] = {
                                    'open': const TimeOfDay(hour: 9, minute: 0),
                                    'close': const TimeOfDay(hour: 17, minute: 0),
                                  };
                                } else {
                                  hours[day] = {'open': null, 'close': null};
                                }
                              });
                            },
                            activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                          ),
                        ],
                      ),
                      if (!isClosed) ...[
                        const SizedBox(height: SwiftleadTokens.spaceM),
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: times['open']!,
                                  );
                                  if (time != null) {
                                    setState(() {
                                      hours[day]!['open'] = time;
                                    });
                                  }
                                },
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
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Open',
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                          Text(
                                            _formatTime(times['open']!),
                                            style: Theme.of(context).textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                      const Icon(Icons.access_time, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: SwiftleadTokens.spaceM),
                            Expanded(
                              child: InkWell(
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: times['close']!,
                                  );
                                  if (time != null) {
                                    setState(() {
                                      hours[day]!['close'] = time;
                                    });
                                  }
                                },
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
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Close',
                                            style: Theme.of(context).textTheme.bodySmall,
                                          ),
                                          Text(
                                            _formatTime(times['close']!),
                                            style: Theme.of(context).textTheme.bodyLarge,
                                          ),
                                        ],
                                      ),
                                      const Icon(Icons.access_time, size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ] else
                        Text(
                          'Closed',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
            const SizedBox(height: SwiftleadTokens.spaceL),
            PrimaryButton(
              label: 'Save Hours',
              onPressed: () {
                // Format hours as string
                final openDays = hours.entries
                    .where((e) => e.value['open'] != null)
                    .map((e) => e.key)
                    .toList();
                if (openDays.isEmpty) {
                  Navigator.pop(context, 'Closed');
                } else {
                  final firstDay = openDays.first;
                  final lastDay = openDays.last;
                  final openTime = _formatTime(hours[firstDay]!['open']!);
                  final closeTime = _formatTime(hours[firstDay]!['close']!);
                  Navigator.pop(context, '$firstDay-$lastDay, $openTime-$closeTime');
                }
              },
              icon: Icons.check,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

