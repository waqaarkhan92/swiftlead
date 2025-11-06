import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';
import '../global/primary_button.dart';

/// AIQuoteAssistantConfigSheet - Configure AI Quote Assistant settings
/// Feature from Decision Matrix Module 3.11
class AIQuoteAssistantConfigSheet {
  static Future<void> show({
    required BuildContext context,
  }) async {
    bool smartPricingEnabled = true;
    bool historicalAnalysisEnabled = true;
    bool competitorPricingEnabled = false;
    double approvalThreshold = 0.8;
    
    await SwiftleadBottomSheet.show(
      context: context,
      title: 'AI Quote Assistant Configuration',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) {
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
                        'Configure how AI suggests pricing and line items for quotes. The AI Quote Assistant sheet remains available in the Quotes screen.',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceL),
              
              // Smart Pricing Toggle
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Smart Pricing',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'AI suggests pricing based on job type and history',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: smartPricingEnabled,
                      onChanged: (value) {
                        setState(() {
                          smartPricingEnabled = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Historical Analysis Toggle
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Historical Analysis',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Use past quote acceptance rates to inform pricing',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: historicalAnalysisEnabled,
                      onChanged: (value) {
                        setState(() {
                          historicalAnalysisEnabled = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Competitor Pricing Toggle
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Competitor Pricing Data',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Compare with market rates (requires external data)',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: competitorPricingEnabled,
                      onChanged: (value) {
                        setState(() {
                          competitorPricingEnabled = value;
                        });
                      },
                      activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              
              // Approval Threshold
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Approval Threshold',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceS),
                    Text(
                      'Minimum confidence before AI suggests pricing: ${(approvalThreshold * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceM),
                    Slider(
                      value: approvalThreshold,
                      min: 0.5,
                      max: 1.0,
                      divisions: 10,
                      label: '${(approvalThreshold * 100).toStringAsFixed(0)}%',
                      activeColor: const Color(SwiftleadTokens.primaryTeal),
                      onChanged: (value) {
                        setState(() {
                          approvalThreshold = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceL),
              
              // Pricing Rules Section
              Text(
                'Pricing Rules',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Configure pricing rules in Quotes screen',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceM),
                    TextButton.icon(
                      onPressed: () {
                        // Navigate to Quotes screen pricing rules
                        Navigator.pop(context);
                        // TODO: Navigate to pricing rules configuration
                      },
                      icon: const Icon(Icons.settings),
                      label: const Text('Open Pricing Rules'),
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
                label: 'Save Configuration',
                onPressed: () {
                  // TODO: Save AI Quote Assistant configuration
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

