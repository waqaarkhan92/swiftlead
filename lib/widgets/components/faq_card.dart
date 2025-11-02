import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// FAQCard - Expandable FAQ card with question, answer, edit/delete, usage stats
/// Exact specification from UI_Inventory_v2.5.1
class FAQCard extends StatefulWidget {
  final String id;
  final String question;
  final String answer;
  final int usageCount;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final Function(bool)? onToggleExpand;

  const FAQCard({
    super.key,
    required this.id,
    required this.question,
    required this.answer,
    this.usageCount = 0,
    this.onEdit,
    this.onDelete,
    this.onToggleExpand,
  });

  @override
  State<FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.question,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Used ${widget.usageCount} times',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      _isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                    ),
                    onPressed: () {
                      setState(() {
                        _isExpanded = !_isExpanded;
                      });
                      widget.onToggleExpand?.call(_isExpanded);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: widget.onEdit,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: widget.onDelete,
                  ),
                ],
              ),
            ],
          ),
          
          // Answer (expandable)
          if (_isExpanded) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            const Divider(),
            const SizedBox(height: SwiftleadTokens.spaceM),
            Text(
              widget.answer,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

