import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/badge.dart';
import '../global/spring_animation.dart';
import 'score_indicator.dart';

/// ContactCard - List item showing contact summary
/// Exact specification from UI_Inventory_v2.5.1
class ContactCard extends StatelessWidget {
  final String contactName;
  final String? contactEmail;
  final String? contactPhone;
  final String? stage;
  final int? score;
  final String? classification;
  final bool isVip;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onCall;
  final VoidCallback? onMessage;
  final VoidCallback? onEmail;

  const ContactCard({
    super.key,
    required this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.stage,
    this.score,
    this.classification,
    this.isVip = false,
    this.isSelected = false,
    this.onTap,
    this.onCall,
    this.onMessage,
    this.onEmail,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Contact ${contactName}${isVip ? ", VIP" : ""}${stage != null ? ", $stage" : ""}${score != null ? ", score $score" : ""}',
      button: true,
      child: SpringCard(
      onTap: onTap,
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
        child: Row(
          children: [
              // Avatar - Enhanced with subtle animation
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: 0.9 + (0.1 * value),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                shape: BoxShape.circle,
                    border: isVip
                        ? Border.all(
                            color: const Color(SwiftleadTokens.warningYellow),
                            width: 2,
                          )
                        : null,
              ),
              child: Center(
                child: Text(
                  _getInitials(contactName),
                      style: TextStyle(
                        fontSize: Theme.of(context).textTheme.titleMedium?.fontSize ?? 18,
                    fontWeight: FontWeight.w600,
                        color: const Color(SwiftleadTokens.primaryTeal),
                      ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: SwiftleadTokens.spaceM),
            
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          contactName,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isVip)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          margin: const EdgeInsets.only(left: 8),
                          decoration: BoxDecoration(
                            color: const Color(SwiftleadTokens.warningYellow).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'VIP',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Color(SwiftleadTokens.warningYellow),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (contactEmail != null || contactPhone != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      contactEmail ?? contactPhone ?? '',
                      style: Theme.of(context).textTheme.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      if (stage != null) ...[
                        SwiftleadBadge(
                          label: stage!,
                          variant: BadgeVariant.secondary,
                          size: BadgeSize.small,
                        ),
                        const SizedBox(width: SwiftleadTokens.spaceS),
                      ],
                      if (score != null)
                        ScoreIndicator(
                          score: score!,
                          classification: classification,
                          compact: true,
                        ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Quick Actions
            if (onCall != null || onMessage != null || onEmail != null) ...[
              const SizedBox(width: SwiftleadTokens.spaceS),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, size: 20),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onSelected: (value) {
                  switch (value) {
                    case 'call':
                      onCall?.call();
                      break;
                    case 'message':
                      onMessage?.call();
                      break;
                    case 'email':
                      onEmail?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (onCall != null)
                    const PopupMenuItem(
                      value: 'call',
                      child: Row(
                        children: [
                          Icon(Icons.phone, size: 18),
                          SizedBox(width: 8),
                          Text('Call'),
                        ],
                      ),
                    ),
                  if (onMessage != null)
                    const PopupMenuItem(
                      value: 'message',
                      child: Row(
                        children: [
                          Icon(Icons.message, size: 18),
                          SizedBox(width: 8),
                          Text('Message'),
                        ],
                      ),
                    ),
                  if (onEmail != null)
                    const PopupMenuItem(
                      value: 'email',
                      child: Row(
                        children: [
                          Icon(Icons.email, size: 18),
                          SizedBox(width: 8),
                          Text('Email'),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
}

