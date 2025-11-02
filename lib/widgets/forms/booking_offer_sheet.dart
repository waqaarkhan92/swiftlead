import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/chip.dart';

/// BookingOfferSheet - Send booking offer with time slots
/// Exact specification from Screen_Layouts_v2.5.1
class BookingOfferSheet {
  static void show({
    required BuildContext context,
    required Function(String timeSlot, String service) onSendOffer,
  }) {
    String selectedTimeSlot = '';
    String selectedService = 'Standard Service';

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Send Booking Offer',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // AvailabilityGrid
            Text(
              'Available Time Slots',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: SwiftleadTokens.spaceS,
                mainAxisSpacing: SwiftleadTokens.spaceS,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                final time = ['9:00 AM', '10:00 AM', '11:00 AM', '2:00 PM', '3:00 PM', '4:00 PM', '5:00 PM'][index % 7];
                final isSelected = selectedTimeSlot == time;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedTimeSlot = time);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? const Color(SwiftleadTokens.primaryTeal)
                            : Theme.of(context).brightness == Brightness.light
                                ? Colors.black.withOpacity(0.1)
                                : Colors.white.withOpacity(0.1),
                      ),
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
                    ),
                    child: Center(
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : Theme.of(context).textTheme.bodyMedium?.color,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // ServicePicker
            Text(
              'Service',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            DropdownButtonFormField<String>(
              value: selectedService,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
              items: ['Standard Service', 'Premium Service', 'Express Service'].map((service) {
                return DropdownMenuItem(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedService = value);
                }
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // DurationSelector
            Text(
              'Duration',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            DropdownButtonFormField<String>(
              value: '1 hour',
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
              items: ['30 min', '1 hour', '2 hours', '3 hours'].map((duration) {
                return DropdownMenuItem(
                  value: duration,
                  child: Text(duration),
                );
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // PricePreview
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Price',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '£150.00',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // NotesField
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Optional Message',
                hintText: 'Add a personal note...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // ConfirmButton
            PrimaryButton(
              label: 'Send Booking Offer',
              onPressed: selectedTimeSlot.isNotEmpty
                  ? () {
                      Navigator.pop(context);
                      onSendOffer(selectedTimeSlot, selectedService);
                    }
                  : null,
              icon: Icons.send,
            ),
          ],
        ),
      ),
    );
  }
}

