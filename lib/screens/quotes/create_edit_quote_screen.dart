import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/info_banner.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/progress_bar.dart';
import '../../widgets/global/toast.dart';
import '../../widgets/forms/ai_quote_assistant_sheet.dart';
import 'package:flutter/services.dart';
import '../../theme/tokens.dart';

/// Create/Edit Quote Form - Create or edit a quote
/// Exact specification from UI_Inventory_v2.5.1
class CreateEditQuoteScreen extends StatefulWidget {
  final String? quoteId; // If provided, editing mode
  final Map<String, dynamic>? initialData;

  const CreateEditQuoteScreen({
    super.key,
    this.quoteId,
    this.initialData,
  });

  @override
  State<CreateEditQuoteScreen> createState() => _CreateEditQuoteScreenState();
}

class _QuoteLineItem {
  String description;
  int quantity;
  double rate;
  double get amount => quantity * rate;

  _QuoteLineItem({
    required this.description,
    this.quantity = 1,
    this.rate = 0.0,
  });
}

class _CreateEditQuoteScreenState extends State<CreateEditQuoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _termsConditionsController = TextEditingController();
  final TextEditingController _paymentTermsController = TextEditingController();
  
  bool _isSaving = false;
  DateTime? _validUntil;
  double _taxRate = 20.0;
  String? _serviceCategory;
  double _laborHours = 0.0;
  List<_QuoteLineItem> _lineItems = [
    _QuoteLineItem(description: '', quantity: 1, rate: 0.0),
  ];

  @override
  void initState() {
    super.initState();
    _validUntil = DateTime.now().add(const Duration(days: 30));
    
    if (widget.initialData != null) {
      _clientController.text = widget.initialData!['clientName'] ?? '';
      _notesController.text = widget.initialData!['notes'] ?? '';
      _taxRate = widget.initialData!['taxRate']?.toDouble() ?? 20.0;
    }
  }

  @override
  void dispose() {
    _clientController.dispose();
    _notesController.dispose();
    _termsConditionsController.dispose();
    _paymentTermsController.dispose();
    super.dispose();
  }

  double get _subtotal {
    return _lineItems.fold(0.0, (sum, item) => sum + item.amount);
  }

  double get _tax {
    return _subtotal * (_taxRate / 100);
  }

  double get _total {
    return _subtotal + _tax;
  }

  Future<void> _saveQuote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_lineItems.isEmpty || _lineItems.any((item) => item.description.isEmpty || item.rate == 0)) {
      Toast.show(
        context,
        message: 'Please add at least one valid line item',
        type: ToastType.error,
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Simulate save
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        HapticFeedback.mediumImpact();
        Toast.show(
          context,
          message: widget.quoteId != null ? 'Quote updated' : 'Quote created',
          type: ToastType.success,
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        Toast.show(
          context,
          message: 'Error: ${e.toString()}',
          type: ToastType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: widget.quoteId != null ? 'Edit Quote' : 'Create Quote',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
          children: [
            // Info Banner
            InfoBanner(
              message: widget.quoteId != null
                  ? 'Editing quote. Changes will be saved automatically.'
                  : 'Fill in the details below to create a new quote.',
              type: InfoBannerType.info,
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Feature 11: AI Quote Assistant Button
            if (widget.quoteId == null) ...[
              OutlinedButton.icon(
                onPressed: () {
                  final jobDescription = _clientController.text.isNotEmpty
                      ? 'Quote for ${_clientController.text}'
                      : 'New quote';
                  AIQuoteAssistantSheet.show(
                    context: context,
                    jobDescription: jobDescription,
                    onItemsSelected: (items) {
                      setState(() {
                        _lineItems = items.map((item) => _QuoteLineItem(
                          description: item.description,
                          quantity: item.quantity,
                          rate: item.rate,
                        )).toList();
                      });
                    },
                    onPricingApplied: (suggestion) {
                      // Apply pricing suggestion if provided
                      Toast.show(
                        context,
                        message: 'Pricing recommendation applied',
                        type: ToastType.info,
                      );
                    },
                  );
                },
                icon: const Icon(Icons.auto_awesome),
                label: const Text('AI Quote Assistant'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: const BorderSide(
                    color: Color(SwiftleadTokens.primaryTeal),
                  ),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],

            // Client Selector
            TextFormField(
              controller: _clientController,
              decoration: InputDecoration(
                labelText: 'Client *',
                hintText: 'Select or enter client name',
                suffixIcon: const Icon(Icons.person),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a client';
                }
                return null;
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Valid Until Date
            Text(
              'Valid Until *',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _validUntil ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() {
                    _validUntil = picked;
                  });
                }
              },
              icon: const Icon(Icons.event),
              label: Text(
                _validUntil != null
                    ? '${_validUntil!.day}/${_validUntil!.month}/${_validUntil!.year}'
                    : 'Select Date',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Tax Rate
            Text(
              'Tax Rate',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _taxRate,
                    min: 0,
                    max: 30,
                    divisions: 30,
                    label: '${_taxRate.toStringAsFixed(0)}%',
                    onChanged: (value) {
                      setState(() {
                        _taxRate = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Text(
                    '${_taxRate.toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Line Items
            Text(
              'Line Items *',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            // Feature 31: Visual Quote Editor - Drag-drop line items
            _lineItems.length <= 1
                ? _buildLineItemRow(0)
                : ReorderableListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (newIndex > oldIndex) {
                          newIndex -= 1;
                        }
                        final item = _lineItems.removeAt(oldIndex);
                        _lineItems.insert(newIndex, item);
                      });
                    },
                    children: List.generate(_lineItems.length, (index) {
                      return Padding(
                        key: ValueKey('lineitem_${_lineItems[index].hashCode}_$index'),
                        padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                        child: _buildLineItemRow(index),
                      );
                    }),
                  ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _lineItems.add(_QuoteLineItem(description: '', quantity: 1, rate: 0.0));
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Line Item'),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Totals Preview
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                children: [
                  _TotalRow(label: 'Subtotal', amount: _subtotal),
                  _TotalRow(label: 'Tax (${_taxRate.toStringAsFixed(0)}%)', amount: _tax),
                  const Divider(),
                  _TotalRow(
                    label: 'Total',
                    amount: _total,
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Service Category
            DropdownButtonFormField<String>(
              value: _serviceCategory,
              decoration: InputDecoration(
                labelText: 'Service Category',
                hintText: 'Select service category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
              items: ['Plumbing', 'Electrical', 'HVAC', 'General Maintenance', 'Other'].map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _serviceCategory = value;
                });
              },
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Labor Hours
            Text(
              'Labor Hours',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                Expanded(
                  child: Slider(
                    value: _laborHours,
                    min: 0,
                    max: 100,
                    divisions: 100,
                    label: '${_laborHours.toStringAsFixed(1)} hours',
                    onChanged: (value) {
                      setState(() {
                        _laborHours = value;
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 80,
                  child: Text(
                    '${_laborHours.toStringAsFixed(1)}h',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Payment Terms
            TextFormField(
              controller: _paymentTermsController,
              decoration: InputDecoration(
                labelText: 'Payment Terms',
                hintText: 'e.g., Net 15, Due on receipt, etc.',
                prefixIcon: const Icon(Icons.payment),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Terms & Conditions
            TextFormField(
              controller: _termsConditionsController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Terms & Conditions',
                hintText: 'Add terms and conditions for this quote...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Notes
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Additional Notes (Optional)',
                hintText: 'Add any additional notes...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceL),

            // Save Button
            if (_isSaving)
              const SwiftleadProgressBar()
            else
              PrimaryButton(
                label: widget.quoteId != null ? 'Update Quote' : 'Create Quote',
                onPressed: _saveQuote,
                icon: widget.quoteId != null ? Icons.save : Icons.add,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItemRow(int index) {
    final item = _lineItems[index];
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: Row(
        children: [
          // Drag handle for reordering (Feature 31)
          if (_lineItems.length > 1)
            const Icon(
              Icons.drag_handle,
              color: Color(SwiftleadTokens.textSecondaryLight),
              size: 20,
            ),
          if (_lineItems.length > 1)
            const SizedBox(width: SwiftleadTokens.spaceS),
          Expanded(
            flex: 3,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                isDense: true,
              ),
              onChanged: (value) {
                setState(() {
                  item.description = value;
                });
              },
              controller: TextEditingController(text: item.description),
            ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceS),
          SizedBox(
            width: 80,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Qty',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  item.quantity = int.tryParse(value) ?? 1;
                });
              },
              controller: TextEditingController(text: item.quantity.toString()),
            ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceS),
          SizedBox(
            width: 100,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Rate',
                prefixText: '£',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                ),
                isDense: true,
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  item.rate = double.tryParse(value) ?? 0.0;
                });
              },
              controller: TextEditingController(text: item.rate.toStringAsFixed(2)),
            ),
          ),
          const SizedBox(width: SwiftleadTokens.spaceS),
          SizedBox(
            width: 80,
            child: Text(
              '£${item.amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          if (_lineItems.length > 1)
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () {
                setState(() {
                  _lineItems.removeAt(index);
                });
              },
            ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final double amount;
  final bool isTotal;

  const _TotalRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceS),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
          Text(
            '£${amount.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: isTotal ? const Color(SwiftleadTokens.primaryTeal) : null,
            ),
          ),
        ],
      ),
    );
  }
}

