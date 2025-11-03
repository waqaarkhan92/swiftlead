import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../theme/tokens.dart';

/// Custom Fields Manager Screen - Manage contact custom fields
/// Exact specification from UI_Inventory_v2.5.1
class CustomFieldsManagerScreen extends StatefulWidget {
  const CustomFieldsManagerScreen({super.key});

  @override
  State<CustomFieldsManagerScreen> createState() => _CustomFieldsManagerScreenState();
}

class _CustomFieldsManagerScreenState extends State<CustomFieldsManagerScreen> {
  bool _isLoading = true;
  final List<CustomField> _fields = [];

  @override
  void initState() {
    super.initState();
    _loadFields();
  }

  Future<void> _loadFields() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    
    setState(() {
      _fields.addAll([
        CustomField(
          id: '1',
          name: 'Company Size',
          type: CustomFieldType.dropdown,
          required: false,
          options: ['1-10', '11-50', '51-200', '200+'],
        ),
        CustomField(
          id: '2',
          name: 'Annual Budget',
          type: CustomFieldType.number,
          required: false,
        ),
        CustomField(
          id: '3',
          name: 'Preferred Contact Time',
          type: CustomFieldType.dropdown,
          required: false,
          options: ['Morning', 'Afternoon', 'Evening'],
        ),
      ]);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Custom Fields',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddFieldSheet(),
            tooltip: 'Add Field',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _fields.isEmpty
              ? _buildEmptyState()
              : _buildFieldsList(),
      floatingActionButton: _fields.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () => _showAddFieldSheet(),
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        ...List.generate(3, (index) => Padding(
          padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
          child: FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Row(
              children: [
                SkeletonLoader(width: 24, height: 24, isCircular: true),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SkeletonLoader(width: double.infinity, height: 20),
                      const SizedBox(height: SwiftleadTokens.spaceS),
                      SkeletonLoader(width: 100, height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: EmptyStateCard(
        icon: Icons.label_outline,
        title: 'No Custom Fields',
        description: 'Create custom fields to capture additional contact information.',
        actionLabel: 'Add First Field',
        onAction: () => _showAddFieldSheet(),
      ),
    );
  }

  Widget _buildFieldsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      itemCount: _fields.length,
      itemBuilder: (context, index) {
        final field = _fields[index];
        return _buildFieldCard(field, index);
      },
    );
  }

  Widget _buildFieldCard(CustomField field, int index) {
    return Dismissible(
      key: Key('field_${field.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: SwiftleadTokens.spaceM),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.2),
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.red),
      ),
      confirmDismiss: (direction) async {
        return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete Field?'),
            content: Text('Are you sure you want to delete "${field.name}"? This cannot be undone.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ?? false;
      },
      onDismissed: (direction) {
        setState(() {
          _fields.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${field.name} deleted')),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
        child: FrostedContainer(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          child: InkWell(
            onTap: () => _editField(field),
            borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            child: Row(
              children: [
                Icon(
                  _getFieldIcon(field.type),
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            field.name,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          if (field.required) ...[
                            const SizedBox(width: SwiftleadTokens.spaceS),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Required',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _getFieldTypeLabel(field.type),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                      if (field.options != null && field.options!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${field.options!.length} options',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                              ),
                        ),
                      ],
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => _editField(field),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getFieldIcon(CustomFieldType type) {
    switch (type) {
      case CustomFieldType.text:
        return Icons.text_fields;
      case CustomFieldType.number:
        return Icons.numbers;
      case CustomFieldType.date:
        return Icons.calendar_today;
      case CustomFieldType.dropdown:
        return Icons.list;
      case CustomFieldType.checkbox:
        return Icons.check_box;
      case CustomFieldType.url:
        return Icons.link;
    }
  }

  String _getFieldTypeLabel(CustomFieldType type) {
    switch (type) {
      case CustomFieldType.text:
        return 'Text';
      case CustomFieldType.number:
        return 'Number';
      case CustomFieldType.date:
        return 'Date';
      case CustomFieldType.dropdown:
        return 'Dropdown';
      case CustomFieldType.checkbox:
        return 'Checkbox';
      case CustomFieldType.url:
        return 'URL';
    }
  }

  Future<void> _showAddFieldSheet() async {
    // TODO: Implement add field sheet
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Add field functionality coming soon')),
    );
  }

  Future<void> _editField(CustomField field) async {
    // TODO: Implement edit field sheet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Edit "${field.name}" functionality coming soon')),
    );
  }
}

enum CustomFieldType {
  text,
  number,
  date,
  dropdown,
  checkbox,
  url,
}

class CustomField {
  final String id;
  final String name;
  final CustomFieldType type;
  final bool required;
  final List<String>? options;

  CustomField({
    required this.id,
    required this.name,
    required this.type,
    required this.required,
    this.options,
  });
}
