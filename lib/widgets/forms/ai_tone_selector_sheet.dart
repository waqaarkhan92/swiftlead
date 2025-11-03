import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/chip.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';

/// AI Tone Selector Sheet - Select AI response tone
class AIToneSelectorSheet extends StatefulWidget {
  final String? selectedTone;

  const AIToneSelectorSheet({
    super.key,
    this.selectedTone,
  });

  @override
  State<AIToneSelectorSheet> createState() => _AIToneSelectorSheetState();
}

class _AIToneSelectorSheetState extends State<AIToneSelectorSheet> {
  late String _selectedTone;

  @override
  void initState() {
    super.initState();
    _selectedTone = widget.selectedTone ?? 'Friendly';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(SwiftleadTokens.radiusCard),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Tone',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Choose how the AI should respond to messages',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          Wrap(
            spacing: SwiftleadTokens.spaceS,
            runSpacing: SwiftleadTokens.spaceS,
            children: [
              _ToneOption(
                label: 'Formal',
                description: 'Professional and respectful',
                isSelected: _selectedTone == 'Formal',
                onTap: () {
                  setState(() {
                    _selectedTone = 'Formal';
                  });
                },
              ),
              _ToneOption(
                label: 'Friendly',
                description: 'Warm and approachable',
                isSelected: _selectedTone == 'Friendly',
                onTap: () {
                  setState(() {
                    _selectedTone = 'Friendly';
                  });
                },
              ),
              _ToneOption(
                label: 'Concise',
                description: 'Brief and to the point',
                isSelected: _selectedTone == 'Concise',
                onTap: () {
                  setState(() {
                    _selectedTone = 'Concise';
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          PrimaryButton(
            label: 'Apply Tone',
            onPressed: () {
              Navigator.of(context).pop(_selectedTone);
            },
          ),
        ],
      ),
    );
  }
}

class _ToneOption extends StatelessWidget {
  final String label;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToneOption({
    required this.label,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? const Color(SwiftleadTokens.primaryTeal)
                : Colors.grey.withOpacity(0.3),
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? const Color(SwiftleadTokens.primaryTeal)
                            : null,
                      ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  const Icon(
                    Icons.check_circle,
                    color: Color(SwiftleadTokens.primaryTeal),
                    size: 20,
                  ),
                ],
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceXS),
            Text(
              description,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

