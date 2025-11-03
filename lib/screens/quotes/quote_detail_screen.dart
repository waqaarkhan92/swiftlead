import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/bottom_sheet.dart';
import '../../widgets/global/confirmation_dialog.dart';
import '../../widgets/forms/send_quote_sheet.dart';
import '../../widgets/forms/convert_quote_modal.dart';
import '../../widgets/global/toast.dart';
import '../../theme/tokens.dart';
import 'create_edit_quote_screen.dart';

/// QuoteDetailScreen - Comprehensive quote view
/// Exact specification from UI_Inventory_v2.5.1 and Cross_Reference_Matrix_v2.5.1
class QuoteDetailScreen extends StatefulWidget {
  final String quoteId;
  final String quoteNumber;

  const QuoteDetailScreen({
    super.key,
    required this.quoteId,
    required this.quoteNumber,
  });

  @override
  State<QuoteDetailScreen> createState() => _QuoteDetailScreenState();
}

class _QuoteDetailScreenState extends State<QuoteDetailScreen> {
  bool _isLoading = false;
  String _status = 'Sent';
  double _subtotal = 450.00;
  double _tax = 90.00;
  double _total = 540.00;
  DateTime _validUntil = DateTime.now().add(const Duration(days: 5));

  void _handleDuplicateQuote() async {
    // Navigate to create/edit screen with duplicated data
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateEditQuoteScreen(
          initialData: {
            'clientName': 'John Smith',
            'notes': 'Duplicated from ${widget.quoteNumber}',
            'taxRate': 20.0,
          },
        ),
      ),
    ).then((_) {
      Toast.show(
        context,
        message: 'Quote duplicated successfully',
        type: ToastType.success,
      );
    });
  }

  void _handleDeleteQuote() async {
    final confirmed = await SwiftleadConfirmationDialog.show(
      context: context,
      title: 'Delete Quote',
      description: 'Are you sure you want to delete ${widget.quoteNumber}? This action cannot be undone.',
      isDestructive: true,
      icon: Icons.delete_outline,
    );

    if (confirmed == true) {
      // Delete the quote
      Toast.show(
        context,
        message: 'Quote ${widget.quoteNumber} deleted',
        type: ToastType.success,
      );
      
      // Navigate back to quotes list
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Quote #${widget.quoteNumber}',
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
                  builder: (context) => CreateEditQuoteScreen(
                    quoteId: widget.quoteId,
                  ),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'send':
                  SendQuoteSheet.show(
                    context: context,
                    quoteId: widget.quoteId,
                    quoteNumber: widget.quoteNumber,
                    clientName: 'John Smith',
                    amount: _total,
                  );
                  break;
                case 'duplicate':
                  _handleDuplicateQuote();
                  break;
                case 'convert_job':
                  ConvertQuoteModal.show(
                    context: context,
                    quoteId: widget.quoteId,
                    quoteNumber: widget.quoteNumber,
                    clientName: 'John Smith',
                    amount: _total,
                  );
                  break;
                case 'convert_invoice':
                  ConvertQuoteModal.show(
                    context: context,
                    quoteId: widget.quoteId,
                    quoteNumber: widget.quoteNumber,
                    clientName: 'John Smith',
                    amount: _total,
                  );
                  break;
                case 'delete':
                  _handleDeleteQuote();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'send', child: Text('Send Quote')),
              const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
              const PopupMenuItem(value: 'convert_job', child: Text('Convert to Job')),
              const PopupMenuItem(value: 'convert_invoice', child: Text('Convert to Invoice')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
      floatingActionButton: _buildQuickActions(),
    );
  }

  Widget _buildLoadingState() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // QuoteSummaryCard
        _buildQuoteSummaryCard(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // ClientInfo
        _buildClientInfo(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // LineItems
        _buildLineItems(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // TermsAndValidity
        _buildTermsCard(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // QuoteChasers
        _buildChasersSection(),
      ],
    );
  }

  Widget _buildQuoteSummaryCard() {
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
                      widget.quoteNumber,
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
            child: Row(
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
          _LineItemRow(
            description: 'Kitchen Sink Repair',
            quantity: 1,
            rate: 300.00,
            amount: 300.00,
          ),
          const Divider(),
          _LineItemRow(
            description: 'Materials',
            quantity: 1,
            rate: 150.00,
            amount: 150.00,
          ),
          const Divider(),
          _LineItemRow(
            description: 'Subtotal',
            quantity: null,
            rate: null,
            amount: _subtotal,
            isSubtotal: true,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _LineItemRow(
            description: 'VAT (20%)',
            quantity: null,
            rate: null,
            amount: _tax,
            isSubtotal: true,
          ),
          const Divider(),
          _LineItemRow(
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

  Widget _buildTermsCard() {
    final daysRemaining = _validUntil.difference(DateTime.now()).inDays;
    
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Terms & Validity',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _InfoRow(
            label: 'Valid Until',
            value: _formatDate(_validUntil),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _InfoRow(
            label: 'Days Remaining',
            value: '$daysRemaining days',
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _InfoRow(
            label: 'Payment Terms',
            value: 'Net 15',
          ),
        ],
      ),
    );
  }

  Widget _buildChasersSection() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Follow-up Reminders',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Automated reminders will be sent if quote is not responded to.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _ChaserItem(
            label: 'Day 1 Reminder',
            status: 'Scheduled',
            date: DateTime.now().add(const Duration(days: 1)),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _ChaserItem(
            label: 'Day 3 Reminder',
            status: 'Scheduled',
            date: DateTime.now().add(const Duration(days: 3)),
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _ChaserItem(
            label: 'Day 7 Reminder',
            status: 'Scheduled',
            date: DateTime.now().add(const Duration(days: 7)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    if (_status == 'Draft') {
      return FloatingActionButton.extended(
        onPressed: () {
          SendQuoteSheet.show(
            context: context,
            quoteId: widget.quoteId,
            quoteNumber: widget.quoteNumber,
            clientName: 'John Smith',
            amount: _total,
          );
        },
        icon: const Icon(Icons.send),
        label: const Text('Send Quote'),
        backgroundColor: const Color(SwiftleadTokens.primaryTeal),
      );
    } else if (_status == 'Accepted') {
      return FloatingActionButton.extended(
        onPressed: () {
          ConvertQuoteModal.show(
            context: context,
            quoteId: widget.quoteId,
            quoteNumber: widget.quoteNumber,
            clientName: 'John Smith',
            amount: _total,
          );
        },
        icon: const Icon(Icons.arrow_forward),
        label: const Text('Convert'),
        backgroundColor: const Color(SwiftleadTokens.successGreen),
      );
    }
    return const SizedBox.shrink();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Accepted':
        return const Color(SwiftleadTokens.successGreen);
      case 'Viewed':
        return const Color(SwiftleadTokens.primaryTeal);
      case 'Sent':
        return const Color(SwiftleadTokens.infoBlue);
      case 'Declined':
        return const Color(SwiftleadTokens.errorRed);
      case 'Draft':
      default:
        return const Color(SwiftleadTokens.textSecondaryLight);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _LineItemRow extends StatelessWidget {
  final String description;
  final int? quantity;
  final double? rate;
  final double amount;
  final bool isSubtotal;
  final bool isTotal;

  const _LineItemRow({
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

class _ChaserItem extends StatelessWidget {
  final String label;
  final String status;
  final DateTime date;

  const _ChaserItem({
    required this.label,
    required this.status,
    required this.date,
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
              label,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              _formatDate(date),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: const Color(SwiftleadTokens.infoBlue).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: const TextStyle(
              color: Color(SwiftleadTokens.infoBlue),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

