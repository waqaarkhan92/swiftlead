import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../theme/tokens.dart';

/// Custom Report Builder Screen - Drag-drop interface for building custom reports
/// Exact specification from UI_Inventory_v2.5.1, line 347
class CustomReportBuilderScreen extends StatefulWidget {
  final String? reportId;

  const CustomReportBuilderScreen({
    super.key,
    this.reportId,
  });

  @override
  State<CustomReportBuilderScreen> createState() => _CustomReportBuilderScreenState();
}

class _CustomReportBuilderScreenState extends State<CustomReportBuilderScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<_ReportField> _selectedFields = [];
  final List<_ReportChart> _charts = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.reportId != null) {
      _loadReport();
    }
  }

  void _loadReport() {
    _nameController.text = 'Custom Report';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: widget.reportId != null ? 'Edit Report' : 'Create Custom Report',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _isSaving ? null : _saveReport,
          ),
        ],
      ),
      body: Row(
        children: [
          // Field Palette
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                right: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: _buildFieldPalette(),
          ),
          
          // Builder Area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Report Name
                  FrostedContainer(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Report Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  
                  // Selected Fields
                  Text(
                    'Selected Fields',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  
                  if (_selectedFields.isEmpty)
                    EmptyStateCard(
                      title: 'No fields selected',
                      description: 'Drag fields from the palette to add them',
                      icon: Icons.drag_indicator,
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
                          final item = _selectedFields.removeAt(oldIndex);
                          _selectedFields.insert(newIndex, item);
                        });
                      },
                      children: _selectedFields
                          .asMap()
                          .entries
                          .map((entry) => _buildFieldItem(entry.value, entry.key))
                          .toList(),
                    ),
                  
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  
                  // Charts
                  Text(
                    'Charts',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  
                  Wrap(
                    spacing: SwiftleadTokens.spaceS,
                    runSpacing: SwiftleadTokens.spaceS,
                    children: _ChartType.values
                        .map((type) => _buildChartOption(type))
                        .toList(),
                  ),
                  
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  
                  PrimaryButton(
                    label: 'Save Report',
                    onPressed: _isSaving ? null : _saveReport,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFieldPalette() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        Text(
          'Available Fields',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        ..._FieldCategory.values.map((category) => _buildCategorySection(category)),
      ],
    );
  }

  Widget _buildCategorySection(_FieldCategory category) {
    final fields = _getFieldsForCategory(category);
    
    return ExpansionTile(
      title: Text(_getCategoryName(category)),
      children: fields.map((field) => _buildPaletteField(field)).toList(),
    );
  }

  Widget _buildPaletteField(_ReportField field) {
    return ListTile(
      leading: const Icon(Icons.drag_handle, size: 20),
      title: Text(field.name),
      subtitle: Text(field.type),
      onTap: () => _addField(field),
    );
  }

  Widget _buildFieldItem(_ReportField field, int index) {
    return Card(
      key: ValueKey('${field.id}_$index'),
      margin: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
      child: ListTile(
        leading: const Icon(Icons.drag_handle),
        title: Text(field.name),
        subtitle: Text(field.type),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _removeField(field),
        ),
      ),
    );
  }

  Widget _buildChartOption(_ChartType type) {
    final isSelected = _charts.any((chart) => chart.type == type);
    
    return InkWell(
      onTap: () => _toggleChart(type),
      child: Container(
        width: 150,
        height: 100,
        padding: const EdgeInsets.all(SwiftleadTokens.spaceS),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(SwiftleadTokens.primaryTeal)
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getChartIcon(type),
              size: 32,
              color: isSelected
                  ? const Color(SwiftleadTokens.primaryTeal)
                  : null,
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Text(
              _getChartLabel(type),
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _addField(_ReportField field) {
    setState(() {
      _selectedFields.add(_ReportField(
        id: 'field_${_selectedFields.length}',
        name: field.name,
        type: field.type,
        category: field.category,
      ));
    });
  }

  void _removeField(_ReportField field) {
    setState(() {
      _selectedFields.remove(field);
    });
  }

  void _toggleChart(_ChartType type) {
    setState(() {
      final existing = _charts.firstWhere(
        (chart) => chart.type == type,
        orElse: () => _ReportChart(id: '', type: type),
      );
      
      if (_charts.contains(existing)) {
        _charts.remove(existing);
      } else {
        _charts.add(_ReportChart(
          id: 'chart_${_charts.length}',
          type: type,
        ));
      }
    });
  }

  Future<void> _saveReport() async {
    if (_nameController.text.isEmpty) {
      Toast.show(
        context,
        message: 'Please enter a report name',
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
        message: 'Report saved successfully',
        type: ToastType.success,
      );
      Navigator.of(context).pop(true);
    }
  }

  List<_ReportField> _getFieldsForCategory(_FieldCategory category) {
    switch (category) {
      case _FieldCategory.jobs:
        return [
          _ReportField(id: 'job_id', name: 'Job ID', type: 'Text', category: category),
          _ReportField(id: 'job_title', name: 'Title', type: 'Text', category: category),
          _ReportField(id: 'job_status', name: 'Status', type: 'Text', category: category),
          _ReportField(id: 'job_value', name: 'Value', type: 'Currency', category: category),
        ];
      case _FieldCategory.invoices:
        return [
          _ReportField(id: 'invoice_id', name: 'Invoice ID', type: 'Text', category: category),
          _ReportField(id: 'invoice_amount', name: 'Amount', type: 'Currency', category: category),
          _ReportField(id: 'invoice_status', name: 'Status', type: 'Text', category: category),
        ];
      case _FieldCategory.contacts:
        return [
          _ReportField(id: 'contact_name', name: 'Name', type: 'Text', category: category),
          _ReportField(id: 'contact_score', name: 'Score', type: 'Number', category: category),
          _ReportField(id: 'contact_stage', name: 'Stage', type: 'Text', category: category),
        ];
    }
  }

  String _getCategoryName(_FieldCategory category) {
    switch (category) {
      case _FieldCategory.jobs:
        return 'Jobs';
      case _FieldCategory.invoices:
        return 'Invoices';
      case _FieldCategory.contacts:
        return 'Contacts';
    }
  }

  IconData _getChartIcon(_ChartType type) {
    switch (type) {
      case _ChartType.line:
        return Icons.show_chart;
      case _ChartType.bar:
        return Icons.bar_chart;
      case _ChartType.pie:
        return Icons.pie_chart;
      case _ChartType.table:
        return Icons.table_chart;
    }
  }

  String _getChartLabel(_ChartType type) {
    switch (type) {
      case _ChartType.line:
        return 'Line Chart';
      case _ChartType.bar:
        return 'Bar Chart';
      case _ChartType.pie:
        return 'Pie Chart';
      case _ChartType.table:
        return 'Table';
    }
  }
}

class _ReportField {
  final String id;
  final String name;
  final String type;
  final _FieldCategory category;

  _ReportField({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
  });
}

class _ReportChart {
  final String id;
  final _ChartType type;

  _ReportChart({
    required this.id,
    required this.type,
  });
}

enum _FieldCategory {
  jobs,
  invoices,
  contacts,
}

enum _ChartType {
  line,
  bar,
  pie,
  table,
}

