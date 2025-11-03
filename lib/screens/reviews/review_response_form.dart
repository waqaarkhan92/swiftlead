import 'package:flutter/material.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/badge.dart' show SwiftleadBadge, BadgeVariant, BadgeSize;
import '../../theme/tokens.dart';

/// Review Response Form - Respond to reviews on Google, Facebook, Yelp
/// Exact specification from Cross_Reference_Matrix_v2.5.1 Module 8
class ReviewResponseForm {
  static void show({
    required BuildContext context,
    required String platform,
    required String reviewAuthor,
    required int reviewRating,
    String? reviewComment,
    required VoidCallback onSent,
  }) {
    final TextEditingController responseController = TextEditingController();
    bool isSubmitting = false;

    SwiftleadBottomSheet.show(
      context: context,
      title: 'Respond to Review',
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Review Info
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        SwiftleadBadge(
                          label: platform,
                          variant: BadgeVariant.info,
                          size: BadgeSize.small,
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceS),
                        ...List.generate(5, (index) {
                          return Icon(
                            Icons.star,
                            size: 16,
                            color: index < reviewRating
                                ? const Color(SwiftleadTokens.warningYellow)
                                : Colors.grey.withOpacity(0.3),
                          );
                        }),
                      ],
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceS),
                    Text(
                      reviewAuthor,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    if (reviewComment != null && reviewComment.isNotEmpty) ...[
                      const SizedBox(height: SwiftleadTokens.spaceXS),
                      Text(
                        reviewComment,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              // Response Text Field
              TextField(
                controller: responseController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Your Response',
                  hintText: 'Thank you for your feedback...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.black.withOpacity(0.02)
                      : Colors.white.withOpacity(0.02),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              // Character count and guidelines
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${responseController.text.length}/500 characters',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black.withOpacity(0.5)
                              : Colors.white.withOpacity(0.5),
                        ),
                  ),
                  if (platform == 'Google')
                    Text(
                      'Max 4096 characters',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.black.withOpacity(0.5)
                                : Colors.white.withOpacity(0.5),
                          ),
                    ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              // Guidelines
              Container(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.light
                      ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                      : const Color(SwiftleadTokens.primaryTeal).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 18,
                      color: const Color(SwiftleadTokens.primaryTeal),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: Text(
                        'Be professional and courteous. Thank customers for positive reviews and address concerns in negative ones.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: const Color(SwiftleadTokens.primaryTeal),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      label: isSubmitting ? 'Posting...' : 'Post Response',
                      onPressed: isSubmitting
                          ? null
                          : () async {
                              if (responseController.text.trim().isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Please enter a response'),
                                  ),
                                );
                                return;
                              }

                              setState(() => isSubmitting = true);

                              // Simulate API call
                              await Future.delayed(const Duration(seconds: 1));

                              if (context.mounted) {
                                Navigator.pop(context);
                                onSent();
                              }
                            },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

