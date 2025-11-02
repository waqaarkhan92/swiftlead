import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';

/// CampaignTypeSelector - Choose campaign type
/// Exact specification from UI_Inventory_v2.5.1
class CampaignTypeSelector extends StatelessWidget {
  final String? selectedType;
  final Function(String type)? onTypeSelected;

  const CampaignTypeSelector({
    super.key,
    this.selectedType,
    this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final types = [
      _CampaignTypeOption(
        type: 'email',
        label: 'Email',
        icon: Icons.email_outlined,
        description: 'Send to email addresses',
      ),
      _CampaignTypeOption(
        type: 'sms',
        label: 'SMS',
        icon: Icons.message_outlined,
        description: 'Send text messages',
      ),
      _CampaignTypeOption(
        type: 'whatsapp',
        label: 'WhatsApp',
        icon: Icons.chat_bubble_outline,
        description: 'Send via WhatsApp',
      ),
      _CampaignTypeOption(
        type: 'multichannel',
        label: 'Multi-channel',
        icon: Icons.layers_outlined,
        description: 'Send across multiple channels',
      ),
    ];

    return Column(
      children: types.map((typeOption) {
        final isSelected = selectedType == typeOption.type;
        
        return Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
          child: GestureDetector(
            onTap: () => onTypeSelected?.call(typeOption.type),
            child: FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              backgroundColor: isSelected
                  ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                  : null,
              decoration: isSelected
                  ? BoxDecoration(
                      border: Border.all(
                        color: const Color(SwiftleadTokens.primaryTeal),
                        width: 2,
                      ),
                    )
                  : null,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.2)
                          : Theme.of(context).brightness == Brightness.light
                              ? Colors.black.withOpacity(0.05)
                              : Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      typeOption.icon,
                      color: isSelected
                          ? const Color(SwiftleadTokens.primaryTeal)
                          : Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          typeOption.label,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          typeOption.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(
                      Icons.check_circle,
                      color: Color(SwiftleadTokens.primaryTeal),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _CampaignTypeOption {
  final String type;
  final String label;
  final IconData icon;
  final String description;

  _CampaignTypeOption({
    required this.type,
    required this.label,
    required this.icon,
    required this.description,
  });
}

