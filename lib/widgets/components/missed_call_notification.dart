import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../theme/tokens.dart';
import '../../models/message.dart';
import '../global/frosted_container.dart';

/// MissedCallNotification - Displays missed call notifications inline with messaging threads
/// Specification from Product_Definition_v2.5.1 §3.1
/// Matches app theme and design system
class MissedCallNotification extends StatelessWidget {
  final MissedCall missedCall;
  final VoidCallback? onTextBack;
  final VoidCallback? onCallBack;

  const MissedCallNotification({
    super.key,
    required this.missedCall,
    this.onTextBack,
    this.onCallBack,
  });

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }

  Future<void> _handleCallBack() async {
    final uri = Uri.parse('tel:${missedCall.phoneNumber}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
    onCallBack?.call();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isLight = brightness == Brightness.light;
    
    // Use warningYellow from theme tokens for consistency
    final warningColor = const Color(SwiftleadTokens.warningYellow);
    final successColor = const Color(SwiftleadTokens.successGreen);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SwiftleadTokens.spaceM,
        vertical: SwiftleadTokens.spaceS,
      ),
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        decoration: BoxDecoration(
          color: warningColor.withOpacity(isLight ? 0.1 : 0.15),
          border: Border.all(
            color: warningColor.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
                  decoration: BoxDecoration(
                    color: warningColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(SwiftleadTokens.spaceS),
                  ),
                  child: Icon(
                    Icons.phone_missed,
                    size: 20,
                    color: warningColor,
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Missed Call',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isLight 
                              ? warningColor.withOpacity(0.9)
                              : warningColor.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: SwiftleadTokens.spaceXXS),
                      Text(
                        _formatTimestamp(missedCall.timestamp),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: isLight
                              ? const Color(SwiftleadTokens.textSecondaryLight)
                              : const Color(SwiftleadTokens.textSecondaryDark),
                        ),
                      ),
                    ],
                  ),
                ),
                if (missedCall.textBackSent) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: SwiftleadTokens.spaceS,
                      vertical: SwiftleadTokens.spaceXS,
                    ),
                    decoration: BoxDecoration(
                      color: successColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(SwiftleadTokens.radiusChip),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: successColor,
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceXS),
                        Text(
                          'Text-back sent',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: successColor.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _handleCallBack,
                    icon: const Icon(Icons.phone, size: 18),
                    label: const Text('Call Back'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: SwiftleadTokens.spaceM,
                        vertical: SwiftleadTokens.spaceS,
                      ),
                      minimumSize: const Size(0, SwiftleadTokens.buttonHeightMedium),
                      side: BorderSide(
                        color: isLight
                            ? Colors.black.withOpacity(0.1)
                            : Colors.white.withOpacity(0.2),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                if (!missedCall.textBackSent && onTextBack != null)
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onTextBack,
                      icon: const Icon(Icons.message, size: 18),
                      label: const Text('Text Back'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: warningColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: SwiftleadTokens.spaceM,
                          vertical: SwiftleadTokens.spaceS,
                        ),
                        minimumSize: const Size(0, SwiftleadTokens.buttonHeightMedium),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
                        ),
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

