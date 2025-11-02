import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// AIInsightBanner - Dismissible contextual AI suggestions
/// Exact specification from Screen_Layouts_v2.5.1
class AIInsightBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;
  final VoidCallback? onDismiss;
  
  const AIInsightBanner({
    super.key,
    required this.message,
    this.onTap,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 18,
              color: Color(SwiftleadTokens.primaryTeal),
            ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceM),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onTap != null)
            TextButton(
              onPressed: onTap,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'View',
                style: TextStyle(
                  color: Color(SwiftleadTokens.primaryTeal),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.close, size: 18),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: onDismiss,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ],
      ),
    );
  }
}

