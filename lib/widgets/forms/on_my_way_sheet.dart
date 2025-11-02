import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';

/// OnMyWaySheet - Share ETA with client
/// Exact specification from Screen_Layouts_v2.5.1
class OnMyWaySheet {
  static void show({
    required BuildContext context,
    required Function(int minutes) onSendETA,
  }) {
    int selectedETA = 15;

    SwiftleadBottomSheet.show(
      context: context,
      title: 'On My Way',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            Text(
              'Let your client know when you\'ll arrive',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),
            
            // MapPreview
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Colors.black.withOpacity(0.05)
                    : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.map, size: 48),
                    const SizedBox(height: SwiftleadTokens.spaceS),
                    Text(
                      'Map preview',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // ETASelector
            Text(
              'Estimated Time of Arrival',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              runSpacing: SwiftleadTokens.spaceS,
              children: [15, 30, 45, 60].map((minutes) {
                final isSelected = selectedETA == minutes;
                return GestureDetector(
                  onTap: () {
                    setState(() => selectedETA = minutes);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SwiftleadTokens.spaceM,
                      vertical: SwiftleadTokens.spaceS,
                    ),
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
                    child: Text(
                      '$minutes min',
                      style: TextStyle(
                        color: isSelected
                            ? const Color(SwiftleadTokens.primaryTeal)
                            : Theme.of(context).textTheme.bodyMedium?.color,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // NotesField (optional)
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Optional Message',
                hintText: 'e.g., "Running a few minutes early"',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // ConfirmButton
            PrimaryButton(
              label: 'Send ETA',
              onPressed: () {
                Navigator.pop(context);
                onSendETA(selectedETA);
              },
              icon: Icons.send,
            ),
          ],
        ),
      ),
    );
  }
}

