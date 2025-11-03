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
      title: 'Mark Invoice as Paid',
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
      title: 'Delete Invoice',
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
      title: 'Send Invoice',
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
        title: 'Invoice #${widget.invoiceNumber}',
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
              const PopupMenuItem(value: 'send', child: Text('Send Invoice')),
              const PopupMenuItem(value: 'request_payment', child: Text('Request Payment')),
              const PopupMenuItem(value: 'link_job', child: Text('Link to Job')),
              const PopupMenuItem(value: 'mark_paid', child: Text('Mark as Paid')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: _buildContent(),
      floatingActionButton: _status == 'Pending' || _status == 'Overdue'
          ? FloatingActionButton.extended(
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
              backgroundColor: const Color(SwiftleadTokens.primaryTeal),
            )
          : null,
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

        // Payment Link Button
        if (_status == 'Pending' || _status == 'Overdue')
          PaymentLinkButton(
            paymentLink: 'https://swiftlead.app/pay/${widget.invoiceId}',
            showCopyButton: true,
            onShare: () {
              PaymentLinkSheet.show(
                context: context,
                invoiceId: widget.invoiceId,
                invoiceNumber: widget.invoiceNumber,
                amount: _total,
              );
            },
          ),
        if (_status == 'Pending' || _status == 'Overdue')
          const SizedBox(height: SwiftleadTokens.spaceL),

        // PaymentHistory
        if (_amountPaid > 0) ...[
          _buildPaymentHistory(),
          const SizedBox(height: SwiftleadTokens.spaceL),
        ],

        // Payment Reminders Timeline
        if (_status != 'Paid') ...[
          _buildPaymentRemindersTimeline(),
          const SizedBox(height: SwiftleadTokens.spaceL),
        ],

        // TermsAndNotes
        _buildTermsCard(),
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
          _PaymentHistoryItem(
            date: DateTime.now().subtract(const Duration(days: 2)),
            amount: _amountPaid,
            method: 'Stripe',
            status: 'Completed',
          ),
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

  const _PaymentHistoryItem({
    required this.date,
    required this.amount,
    required this.method,
    required this.status,
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
