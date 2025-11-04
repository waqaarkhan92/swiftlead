import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/primary_button.dart';
import '../global/bottom_sheet.dart';

/// Auto-Reply Template Editor Sheet - Edit missed call text template
/// Exact specification from UI_Inventory_v2.5.1
class AutoReplyTemplateEditorSheet extends StatefulWidget {
  final String? initialTemplate;

  const AutoReplyTemplateEditorSheet({
    super.key,
    this.initialTemplate,
  });

  static Future<String?> show(
    BuildContext context, {
    String? initialTemplate,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AutoReplyTemplateEditorSheet(
        initialTemplate: initialTemplate,
      ),
    );
  }

  @override
  State<AutoReplyTemplateEditorSheet> createState() => _AutoReplyTemplateEditorSheetState();
}

class _AutoReplyTemplateEditorSheetState extends State<AutoReplyTemplateEditorSheet> {
  late TextEditingController _templateController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _templateController = TextEditingController(
      text: widget.initialTemplate ??
          'Hi! We missed your call. We\'re here to help. Reply to this message to get started.',
    );
  }

  @override
  void dispose() {
    _templateController.dispose();
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
                'Auto-Reply Template',
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
            'Customize the message sent automatically after a missed call. Note: Backend verification needed once backend is wired.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Variable tags
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
            child: Wrap(
              spacing: SwiftleadTokens.spaceS,
              runSpacing: SwiftleadTokens.spaceS,
              children: [
                _buildVariableTag('{{business_name}}', 'Your business name'),
                _buildVariableTag('{{contact_name}}', 'Contact name'),
                _buildVariableTag('{{booking_link}}', 'Booking link'),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Template editor
          TextField(
            controller: _templateController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Enter your auto-reply template...',
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
                Text(
                  'Preview',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  _getPreviewText(),
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
                  label: _isSaving ? 'Saving...' : 'Save Template',
                  onPressed: _isSaving ? null : _saveTemplate,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariableTag(String variable, String description) {
    return InkWell(
      onTap: () {
        final text = _templateController.text;
        final selection = _templateController.selection;
        final newText = text.replaceRange(
          selection.start,
          selection.end,
          variable,
        );
        _templateController.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: selection.start + variable.length,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SwiftleadTokens.spaceS,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              variable,
              style: TextStyle(
                color: const Color(SwiftleadTokens.primaryTeal),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Tooltip(
              message: description,
              child: const Icon(
                Icons.info_outline,
                size: 14,
                color: Color(SwiftleadTokens.primaryTeal),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPreviewText() {
    return _templateController.text
        .replaceAll('{{business_name}}', 'ABC Plumbing')
        .replaceAll('{{contact_name}}', 'John')
        .replaceAll('{{booking_link}}', 'https://book.swiftlead.co/abc');
  }

  Future<void> _saveTemplate() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      Navigator.of(context).pop(_templateController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Template saved')),
      );
    }
  }
}
