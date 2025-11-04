import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';

/// BookingAssistanceConfigSheet - Configure booking assistance settings
/// Note: Backend verification needed once backend is wired
class BookingAssistanceConfigSheet {
  static Future<void> show({
    required BuildContext context,
    bool initialEnabled = false,
  }) async {
    await SwiftleadBottomSheet.show(
      context: context,
      title: 'Booking Assistance',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) {
          bool enabled = initialEnabled;
          
          return ListView(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            children: [
              // Info banner
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: const Color(SwiftleadTokens.infoBlue),
                      size: 20,
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: Text(
                        'AI will automatically offer available time slots when booking inquiries are detected.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Enable toggle
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Enable Booking Assistance',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'AI offers available slots automatically',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Switch(
                      value: enabled,
                      onChanged: (value) {
                        setState(() {
                          enabled = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceL),
              
              // Note about backend
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: SwiftleadTokens.spaceS),
                child: Text(
                  'Note: Backend verification needed once backend is wired.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              PrimaryButton(
                label: 'Save',
                onPressed: () {
                  // TODO: Save booking assistance config
                  Navigator.pop(context);
                },
                icon: Icons.check,
              ),
            ],
          );
        },
      ),
    );
  }
}

