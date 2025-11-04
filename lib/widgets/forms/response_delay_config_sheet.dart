import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';
import '../global/primary_button.dart';

/// ResponseDelayConfigSheet - Configure AI response delay
/// Note: Backend verification needed once backend is wired
class ResponseDelayConfigSheet {
  static Future<int?> show({
    required BuildContext context,
    int initialDelaySeconds = 0,
  }) async {
    int selectedDelay = initialDelaySeconds;
    
    return await SwiftleadBottomSheet.show<int>(
      context: context,
      title: 'Response Delay',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) {
          final delayOptions = [
            {'label': 'Instant', 'seconds': 0},
            {'label': '30 seconds', 'seconds': 30},
            {'label': '1 minute', 'seconds': 60},
            {'label': '2 minutes', 'seconds': 120},
          ];
          
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
                        'Simulate human response time by adding a delay before AI responds.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Delay options
              Wrap(
                spacing: SwiftleadTokens.spaceS,
                runSpacing: SwiftleadTokens.spaceS,
                children: delayOptions.map((option) {
                  final isSelected = selectedDelay == option['seconds'] as int;
                  return SwiftleadChip(
                    label: option['label'] as String,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        selectedDelay = option['seconds'] as int;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
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
                  Navigator.pop(context, selectedDelay);
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

