import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';

/// CampaignCard - Campaign list item
/// Exact specification from UI_Inventory_v2.5.1
enum CampaignStatus { draft, scheduled, sending, sent, paused, cancelled }

class CampaignCard extends StatelessWidget {
  final String campaignName;
  final String campaignType;
  final CampaignStatus status;
  final DateTime? scheduledDate;
  final DateTime? sentDate;
  final int? recipientCount;
  final double? openRate;
  final double? clickRate;
  final VoidCallback? onTap;

  const CampaignCard({
    super.key,
    required this.campaignName,
    required this.campaignType,
    required this.status,
    this.scheduledDate,
    this.sentDate,
    this.recipientCount,
    this.openRate,
    this.clickRate,
    this.onTap,
  });

  Color _getStatusColor() {
    switch (status) {
      case CampaignStatus.draft:
        return const Color(SwiftleadTokens.textSecondaryLight);
      case CampaignStatus.scheduled:
        return const Color(SwiftleadTokens.infoBlue);
      case CampaignStatus.sending:
        return const Color(SwiftleadTokens.primaryTeal);
      case CampaignStatus.sent:
        return const Color(SwiftleadTokens.successGreen);
      case CampaignStatus.paused:
        return const Color(SwiftleadTokens.warningYellow);
      case CampaignStatus.cancelled:
        return const Color(SwiftleadTokens.errorRed);
    }
  }

  String _getStatusLabel() {
    switch (status) {
      case CampaignStatus.draft:
        return 'Draft';
      case CampaignStatus.scheduled:
        return 'Scheduled';
      case CampaignStatus.sending:
        return 'Sending';
      case CampaignStatus.sent:
        return 'Sent';
      case CampaignStatus.paused:
        return 'Paused';
      case CampaignStatus.cancelled:
        return 'Cancelled';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    
    return GestureDetector(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        campaignName,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        campaignType,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getStatusLabel(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            
            if (recipientCount != null || openRate != null || clickRate != null) ...[
              const SizedBox(height: SwiftleadTokens.spaceM),
              Row(
                children: [
                  if (recipientCount != null) ...[
                    Icon(
                      Icons.people_outline,
                      size: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$recipientCount recipients',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (openRate != null) ...[
                    const SizedBox(width: SwiftleadTokens.spaceM),
                    Icon(
                      Icons.email_outlined,
                      size: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${openRate!.toStringAsFixed(1)}% open',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                  if (clickRate != null) ...[
                    const SizedBox(width: SwiftleadTokens.spaceM),
                    Icon(
                      Icons.touch_app_outlined,
                      size: 16,
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${clickRate!.toStringAsFixed(1)}% click',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ],
            
            if (scheduledDate != null || sentDate != null) ...[
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                scheduledDate != null
                    ? 'Scheduled: ${_formatDate(scheduledDate!)}'
                    : 'Sent: ${_formatDate(sentDate!)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

