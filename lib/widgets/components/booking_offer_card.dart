import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/chip.dart';

/// BookingOfferCard - Card showing AI-suggested booking offer
/// Exact specification from UI_Inventory_v2.5.1
class BookingOfferCard extends StatelessWidget {
  final String timeSlot;
  final String serviceName;
  final String? clientName;
  final double? price;
  final int confidence; // 0-100
  final Function()? onAccept;
  final Function()? onDecline;

  const BookingOfferCard({
    super.key,
    required this.timeSlot,
    required this.serviceName,
    this.clientName,
    this.price,
    this.confidence = 0,
    this.onAccept,
    this.onDecline,
  });

  Color _getConfidenceColor(int confidence) {
    if (confidence >= 80) return const Color(SwiftleadTokens.successGreen);
    if (confidence >= 60) return const Color(SwiftleadTokens.warningYellow);
    return const Color(SwiftleadTokens.errorRed);
  }

  @override
  Widget build(BuildContext context) {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with confidence
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.auto_awesome,
                    size: 20,
                    color: Color(SwiftleadTokens.primaryTeal),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Text(
                    'AI Suggested',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              if (confidence > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getConfidenceColor(confidence).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '$confidence%',
                    style: TextStyle(
                      color: _getConfidenceColor(confidence),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Service Info
          Row(
            children: [
              const Icon(
                Icons.event,
                size: 18,
                color: Color(SwiftleadTokens.primaryTeal),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: Text(
                  timeSlot,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          
          Row(
            children: [
              const Icon(
                Icons.build,
                size: 18,
                color: Color(SwiftleadTokens.primaryTeal),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: Text(
                  serviceName,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          
          if (clientName != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                const Icon(
                  Icons.person,
                  size: 18,
                  color: Color(SwiftleadTokens.primaryTeal),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: Text(
                    clientName!,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ],
          
          if (price != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                Text(
                  '£${price!.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
          
          const SizedBox(height: SwiftleadTokens.spaceM),
          const Divider(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onDecline,
                  child: const Text('Decline'),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                flex: 2,
                child: PrimaryButton(
                  label: 'Accept Offer',
                  onPressed: onAccept,
                  icon: Icons.check,
                  size: ButtonSize.small,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

