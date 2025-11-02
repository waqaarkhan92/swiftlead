import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// ServiceTile - Service card with name, duration, price, color indicator + tap to edit
/// Exact specification from UI_Inventory_v2.5.1
class ServiceTile extends StatelessWidget {
  final String serviceId;
  final String serviceName;
  final Duration duration;
  final double price;
  final Color? colorIndicator;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const ServiceTile({
    super.key,
    required this.serviceId,
    required this.serviceName,
    required this.duration,
    required this.price,
    this.colorIndicator,
    this.onTap,
    this.onEdit,
  });

  String _formatDuration(Duration duration) {
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
    }
    return '${duration.inMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Row(
          children: [
            // Color Indicator
            if (colorIndicator != null)
              Container(
                width: 4,
                height: 48,
                decoration: BoxDecoration(
                  color: colorIndicator,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            if (colorIndicator != null)
              const SizedBox(width: SwiftleadTokens.spaceM),
            
            // Service Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
              ),
              child: const Icon(
                Icons.room_service,
                color: Color(SwiftleadTokens.primaryTeal),
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            
            // Service Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    serviceName,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDuration(duration),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Text(
                        '•',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceS),
                      Text(
                        '£${price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Edit Button
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit ?? onTap,
            ),
          ],
        ),
      ),
    );
  }
}

