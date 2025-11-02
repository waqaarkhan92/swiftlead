import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/chip.dart';
import '../global/search_bar.dart';

/// ReviewRequestSheet - Request review from client
/// Exact specification from Screen_Layouts_v2.5.1 and UI_Inventory_v2.5.1
class ReviewRequestSheet {
  static void show({
    required BuildContext context,
    String? jobId,
    String? jobTitle,
    String? clientId,
    String? clientName,
    Function(String platform, String message, bool sendNow, DateTime? scheduledTime)? onSend,
  }) {
    String selectedPlatform = 'Google';
    final TextEditingController messageController = TextEditingController(
      text: 'Hi! We hope you were happy with our service. Would you mind leaving us a review?',
    );
    bool sendNow = true;
    bool incentiveEnabled = false;
    DateTime? scheduledTime;

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Request Review',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Job Link (if provided)
            if (jobTitle != null) ...[
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  children: [
                    const Icon(
                      Icons.build,
                      size: 20,
                      color: Color(SwiftleadTokens.primaryTeal),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Job',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            jobTitle,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],

            // Client Selector (if multiple)
            if (clientName != null) ...[
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          clientName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Color(SwiftleadTokens.primaryTeal),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceM),
                    Expanded(
                      child: Text(
                        clientName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],

            // Review Platforms
            Text(
              'Select Platform',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              children: ['Google', 'Facebook', 'Custom'].map((platform) {
                final isSelected = selectedPlatform == platform;
                return SwiftleadChip(
                  label: platform,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      selectedPlatform = platform;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Message Template
            Text(
              'Message Template',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your review request message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.05)
                    : Colors.white.withOpacity(0.05),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Incentive Toggle
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Offer Incentive',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Optional discount for leaving a review',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: incentiveEnabled,
                    onChanged: (value) {
                      setState(() {
                        incentiveEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Timing Picker
            Text(
              'Send Timing',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        sendNow = true;
                        scheduledTime = null;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: sendNow
                          ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                          : null,
                      side: BorderSide(
                        color: sendNow
                            ? const Color(SwiftleadTokens.primaryTeal)
                            : Colors.grey,
                      ),
                    ),
                    child: const Text('Send Now'),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now().add(const Duration(days: 1)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (time != null) {
                          setState(() {
                            sendNow = false;
                            scheduledTime = DateTime(
                              picked.year,
                              picked.month,
                              picked.day,
                              time.hour,
                              time.minute,
                            );
                          });
                        }
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      backgroundColor: !sendNow
                          ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                          : null,
                      side: BorderSide(
                        color: !sendNow
                            ? const Color(SwiftleadTokens.primaryTeal)
                            : Colors.grey,
                      ),
                    ),
                    child: Text(scheduledTime != null
                        ? 'Schedule: ${_formatDateTime(scheduledTime!)}'
                        : 'Schedule Later'),
                  ),
                ),
              ],
            ),
            if (scheduledTime != null) ...[
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                'Scheduled: ${_formatDateTime(scheduledTime!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
              ),
            ],
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Send Button
            PrimaryButton(
              label: 'Send Review Request',
              onPressed: () {
                onSend?.call(
                  selectedPlatform,
                  messageController.text,
                  sendNow,
                  scheduledTime,
                );
                Navigator.pop(context);
              },
              icon: Icons.star_outline,
            ),
          ],
        ),
      ),
    );
  }

  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

