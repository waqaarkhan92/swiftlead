import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// RichTooltip - Phase 3: Enhanced tooltip with detailed information
class RichTooltip extends StatelessWidget {
  final String title;
  final String? description;
  final List<String>? details;
  final Widget child;
  final TooltipPosition position;

  const RichTooltip({
    super.key,
    required this.title,
    this.description,
    this.details,
    required this.child,
    this.position = TooltipPosition.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => _showRichTooltip(context),
      child: child,
    );
  }

  void _showRichTooltip(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
        margin: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            if (description != null) ...[
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            if (details != null && details!.isNotEmpty) ...[
              const SizedBox(height: SwiftleadTokens.spaceM),
              ...details!.map((detail) => Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: const Color(SwiftleadTokens.primaryTeal),
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Expanded(
                      child: Text(
                        detail,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              )),
            ],
          ],
        ),
      ),
    );
  }
}

enum TooltipPosition { top, bottom, left, right }

