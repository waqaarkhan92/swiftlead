import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// TemplateCard - Template preview card
/// Exact specification from UI_Inventory_v2.5.1
class TemplateCard extends StatelessWidget {
  final String templateName;
  final String? description;
  final String? thumbnailUrl;
  final String? category;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onSelect;

  const TemplateCard({
    super.key,
    required this.templateName,
    this.description,
    this.thumbnailUrl,
    this.category,
    this.isSelected = false,
    this.onTap,
    this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? onSelect,
      child: FrostedContainer(
        padding: EdgeInsets.zero,
        margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.05),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(SwiftleadTokens.radiusCard),
                  topRight: Radius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
              child: thumbnailUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SwiftleadTokens.radiusCard),
                        topRight: Radius.circular(SwiftleadTokens.radiusCard),
                      ),
                      child: Image.network(
                        thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(
                              Icons.broken_image,
                              color: Colors.grey,
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.email_outlined,
                        size: 48,
                        color: Colors.grey.withOpacity(0.5),
                      ),
                    ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          templateName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isSelected)
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: const Color(SwiftleadTokens.primaryTeal),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                  if (description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      description!,
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (category != null) ...[
                    const SizedBox(height: 8),
                    SwiftleadBadge(
                      label: category!,
                      variant: BadgeVariant.secondary,
                      size: BadgeSize.small,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

