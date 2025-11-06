import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/components/payment_link_button.dart';
import '../../widgets/forms/payment_link_sheet.dart';
import '../../widgets/forms/payment_request_modal.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/global/toast.dart';
import '../../mock/mock_payments.dart';
import '../../widgets/components/chase_history_timeline.dart';
import '../../widgets/forms/link_invoice_to_job_sheet.dart';
import '../../theme/tokens.dart';
import '../../utils/profession_config.dart';
import 'create_edit_invoice_screen.dart';

/// InvoiceDetailScreen - Comprehensive invoice view
/// Exact specification from UI_Inventory_v2.5.1
class InvoiceDetailScreen extends StatefulWidget {
  final String invoiceId;
  final String invoiceNumber;

  const InvoiceDetailScreen({
    super.key,
    required this.invoiceId,
    required this.invoiceNumber,
  });

  @override
  State<InvoiceDetailScreen> createState() => _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends State<InvoiceDetailScreen> {
  String _status = 'Pending';
  double _subtotal = 450.00;
  double _tax = 90.00;
  double _total = 540.00;
  double _amountPaid = 0.0;
  double _amountDue = 540.00;
  List<Map<String, dynamic>> _splitPayments = []; // Track split payments

  @override
  void initState() {
    super.initState();
    _loadInvoice();
  }

  Future<void> _loadInvoice() async {
    final invoice = await MockPayments.fetchInvoiceById(widget.invoiceId);
    if (invoice != null && mounted) {
      setState(() {
        _status = invoice.status.displayName;
        _total = invoice.amount;
        _amountPaid = invoice.status == InvoiceStatus.paid ? invoice.amount : 0.0;
        _amountDue = invoice.status == InvoiceStatus.paid ? 0.0 : invoice.amount;
      });
    }
  }

  Future<void> _handleMarkPaid() async {
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Mark ${ProfessionState.config.getLabel('Invoice')} as Paid',
      description: 'Are you sure you want to mark this invoice as paid?',
      primaryActionLabel: 'Mark as Paid',
      secondaryActionLabel: 'Cancel',
      icon: Icons.check_circle,
    );

    if (confirmed != true) return;

    final success = await MockPayments.markInvoicePaid(widget.invoiceId);
    if (success && mounted) {
      await _loadInvoice();
      Toast.show(
        context,
        message: 'Invoice marked as paid',
        type: ToastType.success,
      );
    } else if (mounted) {
      Toast.show(
        context,
        message: 'Failed to mark invoice as paid',
        type: ToastType.error,
      );
    }
  }

  Future<void> _handleDeleteInvoice() async {
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Delete ${ProfessionState.config.getLabel('Invoice')}',
      description: 'Are you sure you want to delete this invoice? This action cannot be undone.',
      primaryActionLabel: 'Delete',
      secondaryActionLabel: 'Cancel',
      icon: Icons.warning_rounded,
      isDestructive: true,
    );

    if (confirmed != true) return;

    final success = await MockPayments.deleteInvoice(widget.invoiceId);
    if (success && mounted) {
      Toast.show(
        context,
        message: 'Invoice deleted',
        type: ToastType.success,
      );
      Navigator.of(context).pop(true); // Return true to signal deletion
    } else if (mounted) {
      Toast.show(
        context,
        message: 'Failed to delete invoice',
        type: ToastType.error,
      );
    }
  }

  Future<void> _handleSendInvoice() async {
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Send ${ProfessionState.config.getLabel('Invoice')}',
      description: 'Send invoice #${widget.invoiceNumber} to the client?',
      primaryActionLabel: 'Send',
      secondaryActionLabel: 'Cancel',
      icon: Icons.send,
    );

    if (confirmed == true && mounted) {
      // Simulate sending
      await Future.delayed(const Duration(seconds: 1));
      Toast.show(
        context,
        message: 'Invoice sent successfully',
        type: ToastType.success,
      );
    }
  }

  Future<void> _handleLinkToJob() async {
    final jobId = await LinkInvoiceToJobSheet.show(
      context: context,
      invoiceId: widget.invoiceId,
    );
    if (jobId != null && mounted) {
      Toast.show(
        context,
        message: 'Invoice linked to job',
        type: ToastType.success,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: '${ProfessionState.config.getLabel('Invoice')} #${widget.invoiceNumber}',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateEditInvoiceScreen(
                    invoiceId: widget.invoiceId,
                  ),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'request_payment':
                  PaymentRequestModal.show(
                    context: context,
                    clientName: 'John Smith', // Would get from invoice data
                    onSendRequest: (amount, method) {
                      // Handle payment request sent
                    },
                  );
                  break;
                case 'send':
                  _handleSendInvoice();
                  break;
                case 'link_job':
                  _handleLinkToJob();
                  break;
                case 'mark_paid':
                  _handleMarkPaid();
                  break;
                case 'delete':
                  _handleDeleteInvoice();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'send',
                child: Text(
                  'Send Invoice',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'request_payment',
                child: Text(
                  'Request Payment',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'link_job',
                child: Text(
                  'Link to Job',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'mark_paid',
                child: Text(
                  'Mark as Paid',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Text(
                  'Delete',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(SwiftleadTokens.errorRed),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Scrollable content
          Expanded(
            child: _buildContent(),
          ),
          // iOS-style bottom toolbar (sticky at bottom)
          if (_status == 'Pending' || _status == 'Overdue') _buildBottomToolbar(),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // InvoiceSummaryCard
        _buildInvoiceSummaryCard(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // ClientInfo
        _buildClientInfo(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // LineItems
        _buildLineItems(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // Payment Link Button (moved to bottom toolbar for pending/overdue)
        if (_status == 'Pending' || _status == 'Overdue')
          const SizedBox(height: SwiftleadTokens.spaceL),

        // PaymentHistory
        if (_amountPaid > 0) ...[
          _buildPaymentHistory(),
          const SizedBox(height: SwiftleadTokens.spaceL),
        ],

        // Feature 14: Bank Transfer Details Section
        _buildBankDetailsSection(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // Payment Reminders Timeline
        if (_status != 'Paid') ...[
          _buildPaymentRemindersTimeline(),
          const SizedBox(height: SwiftleadTokens.spaceL),
        ],

        // TermsAndNotes
        _buildTermsCard(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // Feature 14: Smart Invoice Timing - AI suggests optimal send time
        if (_status == 'Draft') _buildSmartInvoiceTimingSection(),
      ],
    );
  }

  Widget _buildInvoiceSummaryCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invoice #${widget.invoiceNumber}',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceXS),
                    Text(
                      'Kitchen Sink Repair',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(_status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _status,
                  style: TextStyle(
                    color: _getStatusColor(_status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Text(
                      '£${_total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: const Color(SwiftleadTokens.primaryTeal),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                if (_amountPaid > 0) ...[
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount Paid',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '£${_amountPaid.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(SwiftleadTokens.successGreen),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: SwiftleadTokens.spaceS),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount Due',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '£${_amountDue.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: _status == 'Overdue'
                              ? const Color(SwiftleadTokens.errorRed)
                              : const Color(SwiftleadTokens.primaryTeal),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientInfo() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bill To',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'John Smith',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
          Text(
            '123 Main Street',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            'London, SW1A 1AA',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceXS),
          Text(
            'john.smith@example.com',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildLineItems() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Line Items',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _InvoiceLineItemRow(
            description: 'Kitchen Sink Repair',
            quantity: 1,
            rate: 300.00,
            amount: 300.00,
          ),
          const Divider(),
          _InvoiceLineItemRow(
            description: 'Materials',
            quantity: 1,
            rate: 150.00,
            amount: 150.00,
          ),
          const Divider(),
          _InvoiceLineItemRow(
            description: 'Subtotal',
            quantity: null,
            rate: null,
            amount: _subtotal,
            isSubtotal: true,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _InvoiceLineItemRow(
            description: 'VAT (20%)',
            quantity: null,
            rate: null,
            amount: _tax,
            isSubtotal: true,
          ),
          const Divider(),
          _InvoiceLineItemRow(
            description: 'Total',
            quantity: null,
            rate: null,
            amount: _total,
            isSubtotal: true,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentHistory() {
    final allPayments = <Map<String, dynamic>>[];
    
    // Add existing payment if any
    if (_amountPaid > 0 && _splitPayments.isEmpty) {
      allPayments.add({
        'date': DateTime.now().subtract(const Duration(days: 2)),
        'amount': _amountPaid,
        'method': 'Stripe (Card)',
        'status': 'Completed',
        'details': 'Visa ending in 4242',
      });
    }
    
    // Add split payments
    for (var split in _splitPayments) {
      allPayments.add({
        'date': split['date'] as DateTime,
        'amount': split['amount'] as double,
        'method': '${split['method']}',
        'status': 'Completed',
        'details': split['method'] == 'Bank Transfer' 
            ? 'HSBC • Account ending in 1234 • Sort Code: 12-34-56' 
            : split['method'] == 'Card' 
                ? 'Visa ending in 4242'
                : null,
      });
    }
    
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment History',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          if (allPayments.isEmpty)
            Text(
              'No payments recorded yet',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
            )
          else
            ...allPayments.map((payment) {
              return Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: _PaymentHistoryItem(
                  date: payment['date'] as DateTime,
                  amount: payment['amount'] as double,
                  method: payment['method'] as String,
                  status: payment['status'] as String,
                  paymentMethodDetails: payment['details'] as String?,
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildPaymentRemindersTimeline() {
    // Mock chase records for payment reminders
    final chaseRecords = [
      ChaseRecord(
        message: 'Payment reminder sent via email',
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        status: ChaseStatus.sent,
        channel: ChaseChannel.email,
      ),
      ChaseRecord(
        message: 'Payment reminder sent via SMS',
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        status: ChaseStatus.delivered,
        channel: ChaseChannel.sms,
      ),
    ];

    return ChaseHistoryTimeline(chaseRecords: chaseRecords);
  }

  void _showSplitPaymentDialog() {
    final TextEditingController amountController = TextEditingController();
    String selectedMethod = 'Cash';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Record Split Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Amount Due: £${_amountDue.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Payment Amount',
                  prefixText: '£',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Wrap(
                spacing: SwiftleadTokens.spaceS,
                children: ['Cash', 'Check', 'Bank Transfer', 'Card'].map((method) {
                  final isSelected = selectedMethod == method;
                  return ChoiceChip(
                    label: Text(method),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedMethod = method;
                      });
                    },
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount > 0 && amount <= _amountDue) {
                  Navigator.pop(context);
                  // Save split payment to state
                  setState(() {
                    _splitPayments.add({
                      'amount': amount,
                      'method': selectedMethod,
                      'date': DateTime.now(),
                    });
                    _amountPaid += amount;
                    _amountDue -= amount;
                    if (_amountDue <= 0) {
                      _status = 'Paid';
                    }
                  });
                  Toast.show(
                    context,
                    message: 'Split payment recorded: £${amount.toStringAsFixed(2)} via $selectedMethod',
                    type: ToastType.success,
                  );
                } else {
                  Toast.show(
                    context,
                    message: 'Invalid amount. Must be between £0.01 and £${_amountDue.toStringAsFixed(2)}',
                    type: ToastType.error,
                  );
                }
              },
              child: const Text('Record Payment'),
            ),
          ],
        ),
      ),
    );
  }

  // Feature 36: Payment Plans - Set up flexible installments
  void _showPaymentPlanDialog() {
    int numberOfPayments = 2;
    double installmentAmount = _total / numberOfPayments;
    DateTime firstPaymentDate = DateTime.now().add(const Duration(days: 7));

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Set Up Payment Plan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Amount: £${_total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Number of Payments',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: numberOfPayments > 2
                        ? () {
                            setState(() {
                              numberOfPayments--;
                              installmentAmount = _total / numberOfPayments;
                            });
                          }
                        : null,
                  ),
                  Expanded(
                    child: Text(
                      '$numberOfPayments payments',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: numberOfPayments < 12
                        ? () {
                            setState(() {
                              numberOfPayments++;
                              installmentAmount = _total / numberOfPayments;
                            });
                          }
                        : null,
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Installment Amount: £${installmentAmount.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(SwiftleadTokens.primaryTeal),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'First Payment Date',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: firstPaymentDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      firstPaymentDate = picked;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  '${firstPaymentDate.day}/${firstPaymentDate.month}/${firstPaymentDate.year}',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Toast.show(
                  context,
                  message: 'Payment plan created: $numberOfPayments installments of £${installmentAmount.toStringAsFixed(2)}',
                  type: ToastType.success,
                );
                // TODO: Save payment plan to backend
              },
              child: const Text('Create Plan'),
            ),
          ],
        ),
      ),
    );
  }

  // Feature 38: Offline Payments - Record cash/check offline, sync later
  void _showOfflinePaymentDialog() {
    final TextEditingController amountController = TextEditingController(text: _amountDue.toStringAsFixed(2));
    final TextEditingController referenceController = TextEditingController();
    String selectedMethod = 'Cash';
    DateTime paymentDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Record Offline Payment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'This payment will be recorded offline and synced when online.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Payment Amount',
                  prefixText: '£',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              Wrap(
                spacing: SwiftleadTokens.spaceS,
                children: ['Cash', 'Check', 'Bank Transfer'].map((method) {
                  final isSelected = selectedMethod == method;
                  return ChoiceChip(
                    label: Text(method),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedMethod = method;
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              TextField(
                controller: referenceController,
                decoration: InputDecoration(
                  labelText: 'Reference (optional)',
                  hintText: 'Check number, transaction ID, etc.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
                  ),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Text(
                'Payment Date',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: paymentDate,
                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      paymentDate = picked;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  '${paymentDate.day}/${paymentDate.month}/${paymentDate.year}',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount > 0) {
                  Navigator.pop(context);
                  // Save offline payment to state (will sync when online)
                  setState(() {
                    _splitPayments.add({
                      'amount': amount,
                      'method': selectedMethod,
                      'date': paymentDate,
                      'reference': referenceController.text.isNotEmpty ? referenceController.text : null,
                      'offline': true,
                    });
                    _amountPaid += amount;
                    _amountDue -= amount;
                    if (_amountDue <= 0) {
                      _status = 'Paid';
                    }
                  });
                  Toast.show(
                    context,
                    message: 'Offline payment recorded: £${amount.toStringAsFixed(2)} via $selectedMethod. Will sync when online.',
                    type: ToastType.info,
                  );
                } else {
                  Toast.show(
                    context,
                    message: 'Please enter a valid amount',
                    type: ToastType.error,
                  );
                }
              },
              child: const Text('Record Payment'),
            ),
          ],
        ),
      ),
    );
  }

  // Feature 14: Bank Transfer Details Section
  Widget _buildBankDetailsSection() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.account_balance,
                size: 24,
                color: Color(SwiftleadTokens.primaryTeal),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                'Bank Transfer Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'For bank transfer payments, please use the following details:',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _InfoRow(
            label: 'Bank Name',
            value: 'HSBC',
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _InfoRow(
            label: 'Account Name',
            value: 'Swiftlead Ltd',
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _InfoRow(
            label: 'Account Number',
            value: '12345678',
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _InfoRow(
            label: 'Sort Code',
            value: '12-34-56',
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reference',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                widget.invoiceNumber,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms & Notes',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _InfoRow(
            label: 'Due Date',
            value: '15 days from invoice date',
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _InfoRow(
            label: 'Payment Terms',
            value: 'Net 15',
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _InfoRow(
            label: 'Issued Date',
            value: '15/11/2024',
          ),
        ],
      ),
    );
  }

  // Feature 14: Smart Invoice Timing - AI suggests optimal send time
  Widget _buildSmartInvoiceTimingSection() {
    // Mock AI timing suggestion - in production would call AI service
    final mockTiming = {
      'optimalSendTime': DateTime.now().add(const Duration(hours: 2)),
      'reason': 'Based on client payment patterns, sending at 10:00 AM on Tuesday increases payment speed by 23%',
      'predictedPaymentDays': 12,
      'averagePaymentDays': 18,
    };

    final optimalTime = mockTiming['optimalSendTime'] as DateTime;
    final timeUntilOptimal = optimalTime.difference(DateTime.now());

    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.schedule,
                  color: Color(SwiftleadTokens.primaryTeal),
                  size: 20,
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                'Smart Invoice Timing',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
              borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Optimal Send Time',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${optimalTime.hour.toString().padLeft(2, '0')}:${optimalTime.minute.toString().padLeft(2, '0')}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(SwiftleadTokens.primaryTeal),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SwiftleadTokens.spaceS),
                Text(
                  '${timeUntilOptimal.inHours}h ${timeUntilOptimal.inMinutes.remainder(60)}m from now',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(SwiftleadTokens.textSecondaryLight),
                  ),
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Text(
                  mockTiming['reason'] as String,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: SwiftleadTokens.spaceM),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTimingMetric(
                      'Predicted Payment',
                      '${mockTiming['predictedPaymentDays']} days',
                      Icons.trending_down,
                      const Color(SwiftleadTokens.successGreen),
                    ),
                    _buildTimingMetric(
                      'Average Payment',
                      '${mockTiming['averagePaymentDays']} days',
                      Icons.trending_flat,
                      const Color(SwiftleadTokens.textSecondaryLight),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          PrimaryButton(
            label: 'Schedule Send at Optimal Time',
            onPressed: () {
              Toast.show(
                context,
                message: 'Invoice scheduled to send at ${optimalTime.hour.toString().padLeft(2, '0')}:${optimalTime.minute.toString().padLeft(2, '0')}',
                type: ToastType.success,
              );
            },
            icon: Icons.send,
          ),
        ],
      ),
    );
  }

  Widget _buildTimingMetric(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: SwiftleadTokens.spaceXS),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceXS),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return const Color(SwiftleadTokens.successGreen);
      case 'Pending':
        return const Color(SwiftleadTokens.warningYellow);
      case 'Overdue':
        return const Color(SwiftleadTokens.errorRed);
      default:
        return const Color(SwiftleadTokens.textSecondaryLight);
    }
  }

  Widget _buildBottomToolbar() {
    // iOS-style bottom toolbar: Secondary actions in toolbar, primary action below
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Secondary actions toolbar (iOS pattern: icon + label)
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: SwiftleadTokens.spaceM,
                vertical: SwiftleadTokens.spaceS,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _ToolbarAction(
                    icon: Icons.account_balance_wallet,
                    label: 'Split',
                    onTap: _showSplitPaymentDialog,
                  ),
                  _ToolbarAction(
                    icon: Icons.calendar_today,
                    label: 'Plan',
                    onTap: _showPaymentPlanDialog,
                  ),
                  _ToolbarAction(
                    icon: Icons.payment,
                    label: 'Offline',
                    onTap: _showOfflinePaymentDialog,
                  ),
                ],
              ),
            ),
            // Primary action: Full-width button at bottom (iOS pattern)
            Container(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        PaymentLinkSheet.show(
                          context: context,
                          invoiceId: widget.invoiceId,
                          invoiceNumber: widget.invoiceNumber,
                          amount: _total,
                        );
                      },
                      icon: const Icon(Icons.payment),
                      label: const Text('Request Payment'),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                    ),
                  ),
                  const SizedBox(width: SwiftleadTokens.spaceS),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Mark Paid',
                      onPressed: _handleMarkPaid,
                      icon: Icons.check_circle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for toolbar actions (iOS pattern: icon + label)
  Widget _ToolbarAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusButton),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: SwiftleadTokens.spaceS,
            horizontal: SwiftleadTokens.spaceXS,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: const Color(SwiftleadTokens.primaryTeal),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvoiceLineItemRow extends StatelessWidget {
  final String description;
  final int? quantity;
  final double? rate;
  final double amount;
  final bool isSubtotal;
  final bool isTotal;

  const _InvoiceLineItemRow({
    required this.description,
    this.quantity,
    this.rate,
    required this.amount,
    this.isSubtotal = false,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: SwiftleadTokens.spaceS),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              description,
              style: isTotal
                  ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    )
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (quantity != null && rate != null) ...[
            Expanded(
              child: Text(
                quantity.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: Text(
                '£${rate!.toStringAsFixed(2)}',
                textAlign: TextAlign.right,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
          Expanded(
            child: Text(
              '£${amount.toStringAsFixed(2)}',
              textAlign: TextAlign.right,
              style: isTotal
                  ? Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    )
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentHistoryItem extends StatelessWidget {
  final DateTime date;
  final double amount;
  final String method;
  final String status;
  final String? paymentMethodDetails;

  const _PaymentHistoryItem({
    required this.date,
    required this.amount,
    required this.method,
    required this.status,
    this.paymentMethodDetails,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(date),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              method,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (paymentMethodDetails != null)
              Text(
                paymentMethodDetails!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 11,
                  color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '£${amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: const Color(SwiftleadTokens.successGreen),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                status,
                style: const TextStyle(
                  color: Color(SwiftleadTokens.successGreen),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
