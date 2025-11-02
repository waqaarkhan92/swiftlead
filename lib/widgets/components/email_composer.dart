import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../global/frosted_container.dart';
import '../global/chip.dart';

/// EmailComposer - Rich email editor
/// Exact specification from UI_Inventory_v2.5.1
class EmailComposer extends StatefulWidget {
  final String? initialContent;
  final Function(String content)? onUpdate;
  final List<EmailTemplate>? templates;
  final bool showPreview;

  const EmailComposer({
    super.key,
    this.initialContent,
    this.onUpdate,
    this.templates,
    this.showPreview = false,
  });

  @override
  State<EmailComposer> createState() => _EmailComposerState();
}

class EmailTemplate {
  final String id;
  final String name;
  final String? preview;

  EmailTemplate({
    required this.id,
    required this.name,
    this.preview,
  });
}

class _EmailComposerState extends State<EmailComposer> {
  late TextEditingController _subjectController;
  late TextEditingController _contentController;
  bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    _subjectController = TextEditingController();
    _contentController = TextEditingController(text: widget.initialContent);
    _contentController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _subjectController.dispose();
    _contentController.removeListener(_onContentChanged);
    _contentController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    widget.onUpdate?.call(_contentController.text);
  }

  int _getWordCount() {
    return _contentController.text.trim().isEmpty
        ? 0
        : _contentController.text.trim().split(RegExp(r'\s+')).length;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Toolbar
        FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
          child: Row(
            children: [
              IconButton(
                icon: Icon(_isPreviewMode ? Icons.edit : Icons.preview),
                onPressed: () {
                  setState(() {
                    _isPreviewMode = !_isPreviewMode;
                  });
                },
                tooltip: _isPreviewMode ? 'Edit' : 'Preview',
              ),
              if (widget.templates != null && widget.templates!.isNotEmpty)
                PopupMenuButton<EmailTemplate>(
                  icon: const Icon(Icons.article_outlined),
                  tooltip: 'Templates',
                  itemBuilder: (context) => widget.templates!
                      .map((template) => PopupMenuItem(
                            value: template,
                            child: Text(template.name),
                          ))
                      .toList(),
                  onSelected: (template) {
                    _contentController.text = template.preview ?? '';
                  },
                ),
              const Spacer(),
              Text(
                '${_getWordCount()} words',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        
        // Editor or Preview
        Expanded(
          child: _isPreviewMode ? _buildPreview() : _buildEditor(),
        ),
      ],
    );
  }

  Widget _buildEditor() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Subject field
          TextField(
            controller: _subjectController,
            decoration: InputDecoration(
              hintText: 'Subject',
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(),
          
          // Content editor
          Expanded(
            child: TextField(
              controller: _contentController,
              maxLines: null,
              expands: true,
              decoration: InputDecoration(
                hintText: 'Type your email content...',
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preview subject
          if (_subjectController.text.isNotEmpty) ...[
            Text(
              _subjectController.text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Divider(),
          ],
          
          // Preview content
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                _contentController.text.isEmpty
                    ? 'No content to preview'
                    : _contentController.text,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

