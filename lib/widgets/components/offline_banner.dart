import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// OfflineBanner - Displays offline status and queued message count
/// Specification from Product_Definition_v2.5.1 §3.1 (v2.5.1 Enhancement)
class OfflineBanner extends StatelessWidget {
  final int queuedCount;
  final VoidCallback? onTap;

  const OfflineBanner({
    super.key,
    required this.queuedCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    final warningColor = const Color(SwiftleadTokens.warningYellow);

    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.symmetric(
          horizontal: SwiftleadTokens.spaceM,
          vertical: SwiftleadTokens.spaceS,
        ),
        decoration: BoxDecoration(
          color: warningColor.withOpacity(isLight ? 0.1 : 0.15),
          border: Border(
            bottom: BorderSide(
              color: warningColor.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.cloud_off,
              size: 18,
              color: warningColor,
            ),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: Text(
                queuedCount > 0
                    ? 'You\'re offline. $queuedCount message${queuedCount > 1 ? 's' : ''} queued'
                    : 'You\'re offline',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: warningColor.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (queuedCount > 0) ...[
              const SizedBox(width: SwiftleadTokens.spaceS),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SwiftleadTokens.spaceS,
                  vertical: SwiftleadTokens.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: warningColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
                ),
                child: Text(
                  '$queuedCount',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: warningColor.withOpacity(0.9),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

