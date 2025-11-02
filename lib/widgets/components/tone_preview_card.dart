import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// TonePreviewCard - Shows sample responses in each tone style
/// Exact specification from UI_Inventory_v2.5.1
class TonePreviewCard extends StatelessWidget {
  final String tone; // 'Formal', 'Friendly', 'Concise'
  final String sampleQuestion;
  final String sampleResponse;
  final bool isSelected;
  final VoidCallback? onTap;

  const TonePreviewCard({
    super.key,
    required this.tone,
    required this.sampleQuestion,
    required this.sampleResponse,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        decoration: BoxDecoration(
          border: isSelected
              ? Border.all(
                  color: const Color(SwiftleadTokens.primaryTeal),
                  width: 2,
                )
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  tone,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(SwiftleadTokens.primaryTeal),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 12,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            
            // Sample Question
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black.withOpacity(0.05)
                        : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Q:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: Text(
                    sampleQuestion,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: SwiftleadTokens.spaceS),
            
            // Sample Response
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'AI:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      color: Color(SwiftleadTokens.primaryTeal),
                    ),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                    ),
                    child: Text(
                      sampleResponse,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

