import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../theme/tokens.dart';

/// Landing Page Builder Screen - Create and edit landing pages
/// Exact specification from UI_Inventory_v2.5.1, line 560
class LandingPageBuilderScreen extends StatefulWidget {
  final String? pageId;

  const LandingPageBuilderScreen({
    super.key,
    this.pageId,
  });

  @override
  State<LandingPageBuilderScreen> createState() => _LandingPageBuilderScreenState();
}

class _LandingPageBuilderScreenState extends State<LandingPageBuilderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _urlController = TextEditingController();
  final List<_ContentBlock> _blocks = [];
  bool _isSaving = false;
  bool _isPreviewMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.pageId != null) {
      _loadPage();
    }
  }

  void _loadPage() {
    // Load existing page data
    _titleController.text = 'Sample Landing Page';
    _urlController.text = 'sample-page';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: widget.pageId != null ? 'Edit Landing Page' : 'Create Landing Page',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(_isPreviewMode ? Icons.edit : Icons.preview),
            onPressed: () {
              setState(() => _isPreviewMode = !_isPreviewMode);
            },
            tooltip: _isPreviewMode ? 'Edit Mode' : 'Preview Mode',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _savePage,
          ),
        ],
      ),
      body: _isPreviewMode ? _buildPreview() : _buildEditor(),
    );
  }

  Widget _buildEditor() {
    return Row(
      children: [
        // Content Blocks Palette
        Container(
          width: 200,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              right: BorderSide(color: Theme.of(context).dividerColor),
            ),
          ),
          child: _buildBlocksPalette(),
        ),
        
        // Editor
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Settings
                FrostedContainer(
                  padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Page Settings',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: SwiftleadTokens.spaceM),
                      TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Page Title',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: SwiftleadTokens.spaceS),
                      TextField(
                        controller: _urlController,
                        decoration: const InputDecoration(
                          labelText: 'URL Slug',
                          prefixText: '/',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: SwiftleadTokens.spaceM),
                
                // Content Blocks
                Text(
                  'Content Blocks',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                
                if (_blocks.isEmpty)
                  EmptyStateCard(
                    title: 'No blocks yet',
                    description: 'Drag blocks from the palette to add content',
                    icon: Icons.add_circle_outline,
                  )
                else
                  ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = _blocks.removeAt(oldIndex);
                        _blocks.insert(newIndex, item);
                      });
                    },
                    children: _blocks
                        .asMap()
                        .entries
                        .map((entry) => _buildBlockEditor(entry.value, entry.key))
                        .toList(),
                  ),
                
                const SizedBox(height: SwiftleadTokens.spaceM),
                
                PrimaryButton(
                  label: 'Publish',
                  onPressed: _isSaving ? null : _publishPage,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBlocksPalette() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Content Blocks',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        ..._BlockType.values.map((type) => _buildPaletteItem(type)),
      ],
    );
  }

  Widget _buildPaletteItem(_BlockType type) {
    return InkWell(
      onTap: () => _addBlock(type),
      child: Container(
        margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
        padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Row(
          children: [
            Icon(_getBlockIcon(type), size: 20),
            const SizedBox(width: SwiftleadTokens.spaceS),
            Expanded(
              child: Text(
                _getBlockLabel(type),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlockEditor(_ContentBlock block, int index) {
    return Card(
      key: ValueKey(block.id),
      margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
      child: ListTile(
        leading: Icon(_getBlockIcon(block.type)),
        title: Text(_getBlockLabel(block.type)),
        subtitle: Text(block.content ?? ''),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () => _editBlock(block),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _removeBlock(block),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Column(
        children: [
          Text(
            _titleController.text.isEmpty ? 'Page Title' : _titleController.text,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          ..._blocks.map((block) => _buildBlockPreview(block)),
        ],
      ),
    );
  }

  Widget _buildBlockPreview(_ContentBlock block) {
    switch (block.type) {
      case _BlockType.heading:
        return Text(
          block.content ?? 'Heading',
          style: Theme.of(context).textTheme.headlineSmall,
        );
      case _BlockType.text:
        return Text(block.content ?? 'Text content');
      case _BlockType.image:
        return Image.asset(
          'assets/images/placeholder.png',
          height: 200,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 200,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 48),
            );
          },
        );
      case _BlockType.button:
        return PrimaryButton(
          label: block.content ?? 'Button',
          onPressed: () {},
        );
      case _BlockType.form:
        return Container(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).dividerColor),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              PrimaryButton(
                label: 'Submit',
                onPressed: () {},
              ),
            ],
          ),
        );
    }
  }

  void _addBlock(_BlockType type) {
    setState(() {
      _blocks.add(_ContentBlock(
        id: 'block_${_blocks.length}',
        type: type,
        content: null,
      ));
    });
  }

  void _editBlock(_ContentBlock block) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${_getBlockLabel(block.type)}'),
        content: TextField(
          controller: TextEditingController(text: block.content),
          onChanged: (value) {
            setState(() {
              block.content = value;
            });
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _removeBlock(_ContentBlock block) {
    setState(() {
      _blocks.remove(block);
    });
  }

  Future<void> _savePage() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isSaving = false);
      Toast.show(
        context,
        message: 'Page saved successfully',
        type: ToastType.success,
      );
    }
  }

  Future<void> _publishPage() async {
    if (_titleController.text.isEmpty) {
      Toast.show(
        context,
        message: 'Please enter a page title',
        type: ToastType.error,
      );
      return;
    }
    
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isSaving = false);
      Toast.show(
        context,
        message: 'Page published successfully',
        type: ToastType.success,
      );
      Navigator.of(context).pop(true);
    }
  }

  IconData _getBlockIcon(_BlockType type) {
    switch (type) {
      case _BlockType.heading:
        return Icons.title;
      case _BlockType.text:
        return Icons.text_fields;
      case _BlockType.image:
        return Icons.image;
      case _BlockType.button:
        return Icons.touch_app;
      case _BlockType.form:
        return Icons.description;
    }
  }

  String _getBlockLabel(_BlockType type) {
    switch (type) {
      case _BlockType.heading:
        return 'Heading';
      case _BlockType.text:
        return 'Text';
      case _BlockType.image:
        return 'Image';
      case _BlockType.button:
        return 'Button';
      case _BlockType.form:
        return 'Form';
    }
  }
}

class _ContentBlock {
  final String id;
  final _BlockType type;
  String? content;

  _ContentBlock({
    required this.id,
    required this.type,
    this.content,
  });
}

enum _BlockType {
  heading,
  text,
  image,
  button,
  form,
}

