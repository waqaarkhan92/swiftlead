import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/bottom_sheet.dart';

/// After-Hours Response Editor Sheet - Edit after-hours message
/// Exact specification from UI_Inventory_v2.5.1
class AfterHoursResponseEditorSheet extends StatefulWidget {
  final String? initialMessage;

  const AfterHoursResponseEditorSheet({
    super.key,
    this.initialMessage,
  });

  static Future<String?> show(
    BuildContext context, {
    String? initialMessage,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AfterHoursResponseEditorSheet(
        initialMessage: initialMessage,
      ),
    );
  }

  @override
  State<AfterHoursResponseEditorSheet> createState() => _AfterHoursResponseEditorSheetState();
}

class _AfterHoursResponseEditorSheetState extends State<AfterHoursResponseEditorSheet> {
  late TextEditingController _messageController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(
      text: widget.initialMessage ??
          'Thanks for your message! We\'re currently outside business hours. We\'ll get back to you during our next business day.',
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
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
                'After-Hours Response',
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
            'This message will be sent automatically when someone contacts you outside business hours.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Message editor
          TextField(
            controller: _messageController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter your after-hours response message...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Preview
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Text(
                      'Preview',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  _messageController.text,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: PrimaryButton(
                  label: _isSaving ? 'Saving...' : 'Save Message',
                  onPressed: _isSaving ? null : _saveMessage,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _saveMessage() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      Navigator.of(context).pop(_messageController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('After-hours message saved')),
      );
    }
  }
}
