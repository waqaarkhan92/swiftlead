import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/primary_button.dart';

/// OnMyWayButton - Large CTA button with GPS icon and ETA display
/// Exact specification from UI_Inventory_v2.5.1
class OnMyWayButton extends StatelessWidget {
  final bool isActive;
  final Duration? eta;
  final VoidCallback? onTap;
  final Function()? onArrived;

  const OnMyWayButton({
    super.key,
    this.isActive = false,
    this.eta,
    this.onTap,
    this.onArrived,
  });

  String _formatETA(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    return '${duration.inMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    if (isActive && eta != null) {
      return Container(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(SwiftleadTokens.primaryTeal),
              Color(SwiftleadTokens.accentAqua),
            ],
          ),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.navigation,
                  color: Colors.white,
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Text(
                  'ETA: ${_formatETA(eta!)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            OutlinedButton(
              onPressed: onArrived,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.white),
                foregroundColor: Colors.white,
              ),
              child: const Text('Mark as Arrived'),
            ),
          ],
        ),
      );
    }

    return PrimaryButton(
      label: 'On My Way',
      onPressed: onTap,
      icon: Icons.navigation,
    );
  }
}

