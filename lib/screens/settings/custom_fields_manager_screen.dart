import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';
import '../../utils/profession_config.dart';

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
    
    // Load profession-specific custom field templates
    final profession = ProfessionState.currentProfession;
    final templates = ProfessionConfig.getCustomFieldTemplates(profession);
    
    setState(() {
      // Add profession-specific templates
      for (var i = 0; i < templates.length; i++) {
        final template = templates[i];
        _fields.add(CustomField(
          id: 'profession_${i + 1}',
          name: template['name'] ?? '',
          type: template['type'] == 'textarea' 
              ? CustomFieldType.text
              : template['type'] == 'file'
                  ? CustomFieldType.text
                  : CustomFieldType.text,
          required: false,
        ));
      }
      
      // Add default fields if no profession-specific templates
      if (templates.isEmpty) {
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
      }
      
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
    final result = await _showFieldEditorSheet();
    if (result != null && mounted) {
      setState(() {
        _fields.add(CustomField(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: result['name'] as String,
          type: result['type'] as CustomFieldType,
          required: result['required'] as bool,
          options: result['options'] as List<String>?,
        ));
      });
      Toast.show(
        context,
        message: 'Custom field "${result['name']}" created',
        type: ToastType.success,
      );
    }
  }

  Future<void> _editField(CustomField field) async {
    final result = await _showFieldEditorSheet(initialField: field);
    if (result != null && mounted) {
      setState(() {
        final index = _fields.indexWhere((f) => f.id == field.id);
        if (index != -1) {
          _fields[index] = CustomField(
            id: field.id,
            name: result['name'] as String,
            type: result['type'] as CustomFieldType,
            required: result['required'] as bool,
            options: result['options'] as List<String>?,
          );
        }
      });
      Toast.show(
        context,
        message: 'Custom field "${result['name']}" updated',
        type: ToastType.success,
      );
    }
  }

  Future<Map<String, dynamic>?> _showFieldEditorSheet({CustomField? initialField}) async {
    final nameController = TextEditingController(text: initialField?.name ?? '');
    CustomFieldType selectedType = initialField?.type ?? CustomFieldType.text;
    bool isRequired = initialField?.required ?? false;
    final optionsController = TextEditingController(
      text: initialField?.options?.join('\n') ?? '',
    );
    bool showOptionsField = initialField?.type == CustomFieldType.dropdown ||
        selectedType == CustomFieldType.dropdown;

    return await SwiftleadBottomSheet.show<Map<String, dynamic>?>(
      context: context,
      title: initialField == null ? 'Add Custom Field' : 'Edit Custom Field',
      height: SheetHeight.threeQuarter,
      child: StatefulBuilder(
        builder: (context, setSheetState) => ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Field Name
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Field Name *',
                hintText: 'e.g., Company Size, Annual Budget',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
              autofocus: initialField == null,
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Field Type
            Text(
              'Field Type *',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Wrap(
              spacing: SwiftleadTokens.spaceS,
              runSpacing: SwiftleadTokens.spaceS,
              children: CustomFieldType.values.map((type) {
                return SwiftleadChip(
                  label: _getFieldTypeLabel(type),
                  isSelected: selectedType == type,
                  onTap: () {
                    setSheetState(() {
                      selectedType = type;
                      showOptionsField = type == CustomFieldType.dropdown;
                      if (type != CustomFieldType.dropdown) {
                        optionsController.clear();
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Options field (for dropdown type)
            if (showOptionsField) ...[
              Text(
                'Dropdown Options *',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                'Enter one option per line',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              TextFormField(
                controller: optionsController,
                decoration: InputDecoration(
                  labelText: 'Options',
                  hintText: 'Option 1\nOption 2\nOption 3',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                minLines: 3,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],

            // Required toggle
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Required Field',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'This field must be filled when creating contacts',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                  Switch(
                    value: isRequired,
                    onChanged: (value) {
                      setSheetState(() {
                        isRequired = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Save Button
            PrimaryButton(
              label: initialField == null ? 'Create Field' : 'Save Changes',
              onPressed: () {
                if (nameController.text.trim().isEmpty) {
                  Toast.show(
                    context,
                    message: 'Please enter a field name',
                    type: ToastType.error,
                  );
                  return;
                }
                if (selectedType == CustomFieldType.dropdown &&
                    optionsController.text.trim().isEmpty) {
                  Toast.show(
                    context,
                    message: 'Please enter at least one option for dropdown fields',
                    type: ToastType.error,
                  );
                  return;
                }
                final options = selectedType == CustomFieldType.dropdown
                    ? optionsController.text
                        .split('\n')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList()
                    : null;
                Navigator.pop(context, {
                  'name': nameController.text.trim(),
                  'type': selectedType,
                  'required': isRequired,
                  'options': options,
                });
              },
              icon: Icons.save,
            ),
          ],
        ),
      ),
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
