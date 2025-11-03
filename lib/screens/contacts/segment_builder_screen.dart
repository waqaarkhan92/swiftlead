import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';

/// Segmentation Builder Screen - Visual filter builder with drag-drop
/// Exact specification from UI_Inventory_v2.5.1
class SegmentBuilderScreen extends StatefulWidget {
  final String? segmentId; // If provided, editing mode

  const SegmentBuilderScreen({
    super.key,
    this.segmentId,
  });

  @override
  State<SegmentBuilderScreen> createState() => _SegmentBuilderScreenState();
}

class _SegmentBuilderScreenState extends State<SegmentBuilderScreen> {
  final TextEditingController _nameController = TextEditingController();
  final List<FilterRule> _rules = [];
  int _matchCount = 0;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    if (widget.segmentId != null) {
      // Load existing segment
      _loadSegment();
    }
    _calculateCount();
  }

  void _loadSegment() {
    // Mock: Load existing segment
    _nameController.text = 'Hot Prospects';
    _rules.addAll([
      FilterRule(
        field: 'score',
        operator: 'greater_than',
        value: '70',
      ),
      FilterRule(
        field: 'stage',
        operator: 'equals',
        value: 'prospect',
        logicOperator: 'AND',
      ),
    ]);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _calculateCount() async {
    setState(() => _isCalculating = true);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _matchCount = 42; // Mock count
      _isCalculating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: widget.segmentId != null ? 'Edit Segment' : 'Create Segment',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        children: [
          // Segment Name
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Segment Name',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Hot Prospects, VIP Customers',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Match Count Badge
          Row(
            children: [
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_isCalculating)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: const Color(SwiftleadTokens.primaryTeal),
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(width: SwiftleadTokens.spaceS),
                    Text(
                      _isCalculating
                          ? 'Counting contacts...'
                          : '$_matchCount contacts match',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),

          // Filter Builder
          FrostedContainer(
            padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter Rules',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    TextButton.icon(
                      onPressed: _addRule,
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Add Rule'),
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                if (_rules.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(SwiftleadTokens.spaceL),
                      child: Column(
                        children: [
                          Icon(
                            Icons.filter_alt_outlined,
                            size: 48,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: SwiftleadTokens.spaceM),
                          Text(
                            'No filters yet',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                          const SizedBox(height: SwiftleadTokens.spaceS),
                          Text(
                            'Add rules to build your segment',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ..._rules.asMap().entries.map((entry) {
                    final index = entry.key;
                    final rule = entry.value;
                    return _buildFilterRule(rule, index);
                  }),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),

          // Save Button
          PrimaryButton(
            label: widget.segmentId != null ? 'Update Segment' : 'Create Segment',
            onPressed: _saveSegment,
            icon: Icons.save,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRule(FilterRule rule, int index) {
    return Padding(
      padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
      child: FrostedContainer(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Column(
          children: [
            if (index > 0)
              Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment(value: 'AND', label: Text('AND')),
                          ButtonSegment(value: 'OR', label: Text('OR')),
                        ],
                        selected: {rule.logicOperator ?? 'AND'},
                        onSelectionChanged: (Set<String> selected) {
                          setState(() {
                            rule.logicOperator = selected.first;
                            _calculateCount();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                // Field
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: rule.field,
                    decoration: InputDecoration(
                      labelText: 'Field',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'stage', child: Text('Stage')),
                      DropdownMenuItem(value: 'score', child: Text('Score')),
                      DropdownMenuItem(value: 'source', child: Text('Source')),
                      DropdownMenuItem(value: 'tags', child: Text('Tags')),
                      DropdownMenuItem(value: 'created', child: Text('Created Date')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        rule.field = value!;
                        _calculateCount();
                      });
                    },
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                // Operator
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: rule.operator,
                    decoration: InputDecoration(
                      labelText: 'Operator',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'equals', child: Text('equals')),
                      DropdownMenuItem(value: 'not_equals', child: Text('not equals')),
                      DropdownMenuItem(value: 'contains', child: Text('contains')),
                      DropdownMenuItem(value: 'greater_than', child: Text('greater than')),
                      DropdownMenuItem(value: 'less_than', child: Text('less than')),
                    ],
                    onChanged: (value) {
                      setState(() {
                        rule.operator = value!;
                        _calculateCount();
                      });
                    },
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                // Value
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    initialValue: rule.value,
                    decoration: InputDecoration(
                      labelText: 'Value',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      rule.value = value;
                      _calculateCount();
                    },
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                // Delete
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () {
                    setState(() {
                      _rules.removeAt(index);
                      _calculateCount();
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _addRule() {
    setState(() {
      _rules.add(FilterRule(
        field: 'stage',
        operator: 'equals',
        value: '',
        logicOperator: _rules.isEmpty ? null : 'AND',
      ));
    });
  }

  Future<void> _saveSegment() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a segment name')),
      );
      return;
    }

    if (_rules.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one filter rule')),
      );
      return;
    }

    // Simulate save
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (mounted) {
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.segmentId != null
              ? 'Segment updated'
              : 'Segment created'),
        ),
      );
    }
  }
}

class FilterRule {
  String field;
  String operator;
  String value;
  String? logicOperator; // AND/OR

  FilterRule({
    required this.field,
    required this.operator,
    required this.value,
    this.logicOperator,
  });
}
