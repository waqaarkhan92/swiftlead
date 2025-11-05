import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/bottom_sheet.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';
import '../global/toast.dart';
import '../global/primary_button.dart';

/// AI Quote Assistant Sheet - AI-powered quote generation assistance
/// Feature 11 from Decision Matrix Module 3.5
class AIQuoteAssistantSheet {
  static void show({
    required BuildContext context,
    required String jobDescription,
    Function(List<AISuggestedLineItem> items)? onItemsSelected,
    Function(String? pricingSuggestion)? onPricingApplied,
  }) {
    bool isGenerating = true;
    List<AISuggestedLineItem> suggestedItems = [];
    String? pricingSuggestion;
    List<String> upsellOpportunities = [];
    List<String> missingItems = [];

    SwiftleadBottomSheet.show(
      context: context,
      title: 'AI Quote Assistant',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setState) {
          // Simulate AI generation
          if (isGenerating) {
            Future.delayed(const Duration(seconds: 2), () {
              setState(() {
                isGenerating = false;
                suggestedItems = [
                  AISuggestedLineItem(
                    description: 'Kitchen Sink Repair',
                    quantity: 1,
                    rate: 120.0,
                    confidence: 0.95,
                    reason: 'Matches job description',
                  ),
                  AISuggestedLineItem(
                    description: 'Plumbing Labor (2 hours)',
                    quantity: 2,
                    rate: 45.0,
                    confidence: 0.88,
                    reason: 'Standard for sink repairs',
                  ),
                  AISuggestedLineItem(
                    description: 'Parts & Materials',
                    quantity: 1,
                    rate: 35.0,
                    confidence: 0.82,
                    reason: 'Estimated materials cost',
                  ),
                ];
                pricingSuggestion = 'Based on similar jobs, recommended total: £245';
                upsellOpportunities = [
                  'Consider adding: Annual Plumbing Maintenance Plan',
                  'Suggest: Water Leak Detection Service',
                ];
                missingItems = [
                  'Warranty information not included',
                  'Disposal fee may be required',
                ];
              });
            });
          }

          return ListView(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            children: [
              // Info Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_awesome,
                      size: 16,
                      color: Color(SwiftleadTokens.primaryTeal),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: Text(
                        'AI analyzed the job description and suggests these items.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(SwiftleadTokens.primaryTeal),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceL),

              if (isGenerating) ...[
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: SwiftleadTokens.spaceM),
                      Text('Analyzing job description...'),
                    ],
                  ),
                ),
              ] else ...[
                // Suggested Line Items
                Text(
                  'Suggested Line Items',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                ...suggestedItems.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                    child: FrostedContainer(
                      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.description,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      item.reason,
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SwiftleadChip(
                                label: '${(item.confidence * 100).toStringAsFixed(0)}%',
                              ),
                            ],
                          ),
                          const SizedBox(height: SwiftleadTokens.spaceS),
                          Row(
                            children: [
                              Text(
                                'Qty: ${item.quantity}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(width: SwiftleadTokens.spaceM),
                              Text(
                                'Rate: £${item.rate.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const Spacer(),
                              Text(
                                '£${(item.quantity * item.rate).toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: SwiftleadTokens.spaceS),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  onItemsSelected?.call([item]);
                                  Toast.show(
                                    context,
                                    message: 'Item added to quote',
                                    type: ToastType.success,
                                  );
                                },
                                child: const Text('Add Item'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),

                const SizedBox(height: SwiftleadTokens.spaceM),
                PrimaryButton(
                  label: 'Add All Items',
                  onPressed: () {
                    Navigator.pop(context);
                    onItemsSelected?.call(suggestedItems);
                    Toast.show(
                      context,
                      message: '${suggestedItems.length} items added to quote',
                      type: ToastType.success,
                    );
                  },
                ),

                const SizedBox(height: SwiftleadTokens.spaceL),

                // Pricing Suggestion
                if (pricingSuggestion != null) ...[
                  Text(
                    'Pricing Recommendation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  FrostedContainer(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.trending_up,
                          color: Color(SwiftleadTokens.primaryTeal),
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceS),
                        Expanded(
                          child: Text(
                            pricingSuggestion!,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            onPricingApplied?.call(pricingSuggestion);
                          },
                          child: const Text('Apply'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceL),
                ],

                // Upsell Opportunities
                if (upsellOpportunities.isNotEmpty) ...[
                  Text(
                    'Upsell Opportunities',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  ...upsellOpportunities.map((upsell) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                      child: FrostedContainer(
                        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lightbulb_outline,
                              color: Color(SwiftleadTokens.warningYellow),
                              size: 20,
                            ),
                            const SizedBox(width: SwiftleadTokens.spaceS),
                            Expanded(
                              child: Text(
                                upsell,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: SwiftleadTokens.spaceL),
                ],

                // Missing Items
                if (missingItems.isNotEmpty) ...[
                  Text(
                    'Missing Items',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(SwiftleadTokens.errorRed),
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  ...missingItems.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                      child: FrostedContainer(
                        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Color(SwiftleadTokens.errorRed),
                              size: 20,
                            ),
                            const SizedBox(width: SwiftleadTokens.spaceS),
                            Expanded(
                              child: Text(
                                item,
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: const Color(SwiftleadTokens.errorRed),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ],
            ],
          );
        },
      ),
    );
  }
}

class AISuggestedLineItem {
  final String description;
  final int quantity;
  final double rate;
  final double confidence; // 0.0 to 1.0
  final String reason;

  AISuggestedLineItem({
    required this.description,
    required this.quantity,
    required this.rate,
    required this.confidence,
    required this.reason,
  });
}
