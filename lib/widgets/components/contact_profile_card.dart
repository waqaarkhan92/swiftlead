import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/badge.dart';
import '../global/chip.dart';
import 'score_indicator.dart';

/// ContactProfileCard - Header with photo, name, key details
/// Exact specification from UI_Inventory_v2.5.1
class ContactProfileCard extends StatelessWidget {
  final String contactId;
  final String name;
  final String? email;
  final String? phone;
  final String? company;
  final String? avatarUrl;
  final int? leadScore;
  final String? stage;
  final List<String>? tags;
  final VoidCallback? onEdit;
  final Function()? onCall;
  final Function()? onMessage;
  final Function()? onEmail;

  const ContactProfileCard({
    super.key,
    required this.contactId,
    required this.name,
    this.email,
    this.phone,
    this.company,
    this.avatarUrl,
    this.leadScore,
    this.stage,
    this.tags,
    this.onEdit,
    this.onCall,
    this.onMessage,
    this.onEmail,
  });

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
              // Avatar
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: avatarUrl != null
                      ? ClipOval(
                          child: Image.network(
                            avatarUrl!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : '',
                            style: const TextStyle(
                              color: Color(SwiftleadTokens.primaryTeal),
                              fontSize: 32,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              
              // Name & Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (company != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        company!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                    if (email != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            email!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                    if (phone != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone_outlined, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            phone!,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              
              // Edit Button
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
            ],
          ),
          
          // Score & Stage
          if (leadScore != null || stage != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            Row(
              children: [
                if (leadScore != null)
                  Expanded(
                    child: ScoreIndicator(score: leadScore!),
                  ),
                if (leadScore != null && stage != null)
                  const SizedBox(width: SwiftleadTokens.spaceM),
                if (stage != null)
                  Expanded(
                    child: SwiftleadBadge(
                      label: stage!,
                      variant: BadgeVariant.secondary,
                      size: BadgeSize.medium,
                    ),
                  ),
              ],
            ),
          ],
          
          // Tags
          if (tags != null && tags!.isNotEmpty) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              runSpacing: SwiftleadTokens.spaceS,
              children: tags!.map((tag) => SwiftleadChip(
                label: tag,
                isSelected: false,
                onTap: null,
              )).toList(),
            ),
          ],
          
          // Quick Actions
          const SizedBox(height: SwiftleadTokens.spaceM),
          const Divider(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _QuickActionButton(
                icon: Icons.phone,
                label: 'Call',
                onPressed: onCall,
              ),
              _QuickActionButton(
                icon: Icons.message,
                label: 'Message',
                onPressed: onMessage,
              ),
              _QuickActionButton(
                icon: Icons.email,
                label: 'Email',
                onPressed: onEmail,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(label),
    );
  }
}

