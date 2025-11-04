import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';

/// ConfidenceThresholdConfigSheet - Configure minimum confidence threshold
/// Note: Backend verification needed once backend is wired
class ConfidenceThresholdConfigSheet {
  static Future<double?> show({
    required BuildContext context,
    double initialThreshold = 0.7,
  }) async {
    double threshold = initialThreshold;
    
    return await SwiftleadBottomSheet.show<double>(
      context: context,
      title: 'Confidence Threshold',
      height: SheetHeight.half,
      child: StatefulBuilder(
        builder: (context, setState) {
          return ListView(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            children: [
              // Info banner
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: const Color(SwiftleadTokens.infoBlue),
                          size: 20,
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceS),
                        Expanded(
                          child: Text(
                            'AI will only respond if confidence is above this threshold.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceS),
                    Text(
                      'Current threshold: ${(threshold * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(SwiftleadTokens.primaryTeal),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Slider
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Column(
                  children: [
                    Slider(
                      value: threshold,
                      min: 0.0,
                      max: 1.0,
                      divisions: 20,
                      label: '${(threshold * 100).toStringAsFixed(0)}%',
                      activeColor: const Color(SwiftleadTokens.primaryTeal),
                      onChanged: (value) {
                        setState(() {
                          threshold = value;
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '0%',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Text(
                          '100%',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
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
                  Navigator.pop(context, threshold);
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

