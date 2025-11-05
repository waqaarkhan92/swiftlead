import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/info_banner.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/progress_bar.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';

/// Create/Edit Invoice Form - Create or edit an invoice
/// Exact specification from UI_Inventory_v2.5.1
class CreateEditInvoiceScreen extends StatefulWidget {
  final String? invoiceId; // If provided, editing mode
  final Map<String, dynamic>? initialData;

  const CreateEditInvoiceScreen({
    super.key,
    this.invoiceId,
    this.initialData,
  });

  @override
  State<CreateEditInvoiceScreen> createState() => _CreateEditInvoiceScreenState();
}

class _InvoiceLineItem {
  String description;
  int quantity;
  double rate;
  double get amount => quantity * rate;

  _InvoiceLineItem({
    required this.description,
    this.quantity = 1,
    this.rate = 0.0,
  });
}

class _CreateEditInvoiceScreenState extends State<CreateEditInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _paymentTermsController = TextEditingController();
  
  bool _isSaving = false;
  DateTime? _dueDate;
  DateTime? _issueDate;
  double _taxRate = 20.0;
  bool _attachJobPhotos = false; // Attach job photos to invoice
  String? _linkedJobId; // Track linked job for photo attachment
  double _laborHours = 0.0;
  double _fees = 0.0;
  List<_InvoiceLineItem> _lineItems = [
    _InvoiceLineItem(description: '', quantity: 1, rate: 0.0),
  ];

  @override
  void initState() {
    super.initState();
    _issueDate = DateTime.now();
    _dueDate = DateTime.now().add(const Duration(days: 15));
    
    if (widget.initialData != null) {
      _clientController.text = widget.initialData!['clientName'] ?? '';
      _notesController.text = widget.initialData!['notes'] ?? '';
      _taxRate = widget.initialData!['taxRate']?.toDouble() ?? 20.0;
      _attachJobPhotos = widget.initialData!['attachJobPhotos'] ?? false;
      _linkedJobId = widget.initialData!['jobId'];
    }
  }

  @override
  void dispose() {
    _clientController.dispose();
    _notesController.dispose();
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
    final laborCost = _laborHours * 50.0; // Assuming £50/hour rate
    final subtotalWithLaborAndFees = _subtotal + _fees + laborCost;
    final taxOnTotal = subtotalWithLaborAndFees * (_taxRate / 100);
    return subtotalWithLaborAndFees + taxOnTotal;
  }

  Future<void> _saveInvoice() async {
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
        Toast.show(
          context,
          message: widget.invoiceId != null ? 'Invoice updated' : 'Invoice created',
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
        title: widget.invoiceId != null ? 'Edit Invoice' : 'Create Invoice',
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
              message: widget.invoiceId != null
                  ? 'Editing invoice. Changes will be saved automatically.'
                  : 'Fill in the details below to create a new invoice.',
              type: InfoBannerType.info,
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Client Selector
            TextFormField(
              controller: _clientController,
              decoration: InputDecoration(
                labelText: 'Bill To *',
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

            // Dates
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Issue Date',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: SwiftleadTokens.spaceS),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _issueDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() {
                              _issueDate = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(
                          _issueDate != null
                              ? '${_issueDate!.day}/${_issueDate!.month}/${_issueDate!.year}'
                              : 'Select Date',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: SwiftleadTokens.spaceS),
                      OutlinedButton.icon(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _dueDate ?? DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setState(() {
                              _dueDate = picked;
                            });
                          }
                        },
                        icon: const Icon(Icons.event),
                        label: Text(
                          _dueDate != null
                              ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                              : 'Select Date',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
            ...List.generate(_lineItems.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: _buildLineItemRow(index),
              );
            }),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _lineItems.add(_InvoiceLineItem(description: '', quantity: 1, rate: 0.0));
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Line Item'),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Labor & Fees
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Labor & Fees',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceM),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Labor Hours',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: SwiftleadTokens.spaceXS),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '0.0',
                                prefixText: 'Hours: ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                                ),
                                isDense: true,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _laborHours = double.tryParse(value) ?? 0.0;
                                });
                              },
                              controller: TextEditingController(text: _laborHours.toStringAsFixed(1)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: SwiftleadTokens.spaceM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Additional Fees',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: SwiftleadTokens.spaceXS),
                            TextField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '0.00',
                                prefixText: '£',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                                ),
                                isDense: true,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _fees = double.tryParse(value) ?? 0.0;
                                });
                              },
                              controller: TextEditingController(text: _fees.toStringAsFixed(2)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Totals Preview
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                children: [
                  _TotalRow(label: 'Subtotal', amount: _subtotal),
                  if (_fees > 0)
                    _TotalRow(label: 'Additional Fees', amount: _fees),
                  if (_laborHours > 0)
                    _TotalRow(label: 'Labor (${_laborHours.toStringAsFixed(1)}h)', amount: _laborHours * 50.0), // Assuming £50/hour rate
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

            // Attach Job Photos (if creating from job)
            if (_linkedJobId != null) ...[
              FrostedContainer(
                padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Attach Job Photos',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Include job photos with invoice',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _attachJobPhotos,
                      onChanged: (value) {
                        setState(() {
                          _attachJobPhotos = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],
            
            // Notes
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add payment terms or additional notes...',
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
                label: widget.invoiceId != null ? 'Update Invoice' : 'Create Invoice',
                onPressed: _saveInvoice,
                icon: widget.invoiceId != null ? Icons.save : Icons.add,
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

