import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/bottom_sheet.dart';

/// AI Response Preview Sheet - Live simulation preview
/// Exact specification from UI_Inventory_v2.5.1
class AIResponsePreviewSheet extends StatefulWidget {
  const AIResponsePreviewSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AIResponsePreviewSheet(),
    );
  }

  @override
  State<AIResponsePreviewSheet> createState() => _AIResponsePreviewSheetState();
}

class _AIResponsePreviewSheetState extends State<AIResponsePreviewSheet> {
  final TextEditingController _testMessageController = TextEditingController();
  String? _previewResponse;
  bool _isGenerating = false;

  @override
  void dispose() {
    _testMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SwiftleadBottomSheet(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'AI Response Preview',
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
            'Test how the AI will respond to different messages.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Test message input
          TextField(
            controller: _testMessageController,
            decoration: InputDecoration(
              labelText: 'Test Message',
              hintText: 'e.g., "Do you service my area?"',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _previewResponse = null;
              });
            },
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          PrimaryButton(
            label: _isGenerating ? 'Generating...' : 'Generate Preview',
            onPressed: _isGenerating || _testMessageController.text.isEmpty
                ? null
                : _generatePreview,
            icon: Icons.auto_awesome,
          ),
          if (_previewResponse != null) ...[
            const SizedBox(height: SwiftleadTokens.spaceM),
            _buildPreviewCard(),
          ],
          const SizedBox(height: SwiftleadTokens.spaceM),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 20,
                  color: Color(SwiftleadTokens.primaryTeal),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                'AI Response',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            _previewResponse!,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SwiftleadTokens.spaceS,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, size: 14, color: Colors.green),
                    const SizedBox(width: 4),
                    Text(
                      '92% Confidence',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _generatePreview() async {
    setState(() {
      _isGenerating = true;
      _previewResponse = null;
    });

    // Simulate AI response generation
    await Future.delayed(const Duration(seconds: 1));

    // Mock response based on test message
    final testMessage = _testMessageController.text.toLowerCase();
    String response;
    
    if (testMessage.contains('area') || testMessage.contains('service')) {
      response = 'Yes! We cover most areas. Could you share your postcode so I can confirm we service your location?';
    } else if (testMessage.contains('price') || testMessage.contains('cost')) {
      response = 'Our pricing depends on the specific job. Would you like to book a free quote? I can help you schedule an appointment.';
    } else if (testMessage.contains('book') || testMessage.contains('appointment')) {
      response = 'I\'d be happy to help you book an appointment! When would be convenient for you?';
    } else {
      response = 'Thanks for reaching out! I\'m here to help. Could you tell me more about what you need?';
    }

    setState(() {
      _previewResponse = response;
      _isGenerating = false;
    });
  }
}
