import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/global/info_banner.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/components/refund_progress.dart';
import '../../widgets/components/payment_link_button.dart';
import '../../widgets/forms/refund_modal.dart';
import '../../theme/tokens.dart';

/// Payment Detail Screen - View payment details and process refunds
/// Exact specification from UI_Inventory_v2.5.1
class PaymentDetailScreen extends StatefulWidget {
  final String paymentId;
  final String? paymentNumber;

  const PaymentDetailScreen({
    super.key,
    required this.paymentId,
    this.paymentNumber,
  });

  @override
  State<PaymentDetailScreen> createState() => _PaymentDetailScreenState();
}

class _PaymentDetailScreenState extends State<PaymentDetailScreen> {
  bool _isLoading = false;
  String _status = 'Completed';
  double _amount = 540.00;
  String _method = 'Stripe';
  DateTime _date = DateTime.now().subtract(const Duration(days: 2));
  String? _invoiceId;
  String? _invoiceNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: widget.paymentNumber != null
            ? 'Payment #${widget.paymentNumber}'
            : 'Payment Details',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        SkeletonLoader(
          width: double.infinity,
          height: 200,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        SkeletonLoader(
          width: double.infinity,
          height: 150,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return ListView(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      children: [
        // Payment Summary
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Amount',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    '£${_amount.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(SwiftleadTokens.successGreen),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Status',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SwiftleadBadge(
                    label: _status,
                    variant: _getStatusBadgeVariant(),
                    size: BadgeSize.medium,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),

        // Payment Details
        FrostedContainer(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payment Details',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
              _DetailRow(
                label: 'Payment Method',
                value: _method,
              ),
              const Divider(),
              _DetailRow(
                label: 'Payment Date',
                value: '${_date.day}/${_date.month}/${_date.year}',
              ),
              const Divider(),
              _DetailRow(
                label: 'Transaction ID',
                value: widget.paymentId,
              ),
              if (_invoiceNumber != null) ...[
                const Divider(),
                _DetailRow(
                  label: 'Invoice',
                  value: '#$_invoiceNumber',
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),

        // Refund Policy Info Banner
        if (_status == 'Completed')
          InfoBanner(
            message: 'Refunds can be processed within 90 days of payment. Processing may take 5-10 business days.',
            type: InfoBannerType.info,
          ),
        const SizedBox(height: SwiftleadTokens.spaceM),

        // Refund Progress (if processing)
        // This would show if refund is in progress - for now it's hidden
        // RefundProgress(
        //   status: RefundStatus.processing,
        //   progress: 0.5,
        //   message: 'Refund is being processed...',
        // ),
        // const SizedBox(height: SwiftleadTokens.spaceM),

        // Refund Button
        if (_status == 'Completed')
          PrimaryButton(
            label: 'Process Refund',
            onPressed: () {
              RefundModal.show(
                context: context,
                paymentId: widget.paymentId,
                amount: _amount,
                invoiceNumber: _invoiceNumber,
                onRefundProcessed: (refundAmount) {
                  // Show refund progress after processing starts
                  setState(() {
                    _status = 'Refunded';
                  });
                },
              );
            },
            icon: Icons.refresh,
          ),
      ],
    );
  }

  BadgeVariant _getStatusBadgeVariant() {
    switch (_status) {
      case 'Completed':
        return BadgeVariant.success;
      case 'Pending':
        return BadgeVariant.warning;
      case 'Failed':
        return BadgeVariant.error;
      default:
        return BadgeVariant.secondary;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({
    required this.label,
    required this.value,
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
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

