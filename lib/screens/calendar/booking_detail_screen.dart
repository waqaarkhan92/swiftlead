import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/badge.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/forms/reschedule_sheet.dart';
import '../../widgets/forms/cancel_booking_modal.dart';
import '../../widgets/forms/complete_booking_modal.dart';
import '../../widgets/forms/booking_confirmation_sheet.dart';
import '../../theme/tokens.dart';
import 'create_edit_booking_screen.dart';
import '../../widgets/forms/on_my_way_sheet.dart';

/// BookingDetailScreen - Comprehensive booking view
/// Exact specification from UI_Inventory_v2.5.1 and Screen_Layouts_v2.5.1
class BookingDetailScreen extends StatefulWidget {
  final String bookingId;
  final String clientName;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
    required this.clientName,
  });

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  bool _isLoading = false;
  String _status = 'Confirmed';
  DateTime _bookingTime = DateTime.now().add(const Duration(days: 2, hours: 3));
  bool _onMyWay = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        title: 'Booking Details',
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
                  builder: (context) => CreateEditBookingScreen(
                    bookingId: widget.bookingId,
                    initialDate: _bookingTime,
                  ),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'reschedule':
                  RescheduleSheet.show(
                    context: context,
                    bookingTitle: 'Kitchen Sink Repair',
                    clientName: widget.clientName,
                    currentStartTime: _bookingTime,
                    currentEndTime: _bookingTime.add(const Duration(hours: 1)),
                    onReschedule: (newStartTime, newEndTime, reason, notifyClient) {
                      setState(() {
                        _bookingTime = newStartTime;
                      });
                    },
                  );
                  break;
                case 'cancel':
                  CancelBookingModal.show(
                    context: context,
                    bookingId: widget.bookingId,
                    clientName: widget.clientName,
                    bookingTime: _bookingTime,
                    serviceName: 'Kitchen Sink Repair',
                    depositAmount: 100.0,
                    depositPaid: true,
                  );
                  break;
                case 'duplicate':
                  // Duplicate booking
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'reschedule', child: Text('Reschedule')),
              const PopupMenuItem(value: 'cancel', child: Text('Cancel')),
              const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
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
        // BookingSummaryCard
        _buildBookingSummaryCard(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // ClientInfo
        _buildClientInfo(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // ServiceDetails
        _buildServiceDetails(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // StatusAndConfirmation
        _buildStatusCard(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // OnMyWayButton (if applicable)
        if (!_onMyWay && _status == 'Confirmed') _buildOnMyWayButton(),
        if (_onMyWay) _buildETACountdown(),
      ],
    );
  }

  Widget _buildBookingSummaryCard() {
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
                      'Kitchen Sink Repair',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: SwiftleadTokens.spaceXS),
                    Text(
                      'Service',
                      style: Theme.of(context).textTheme.bodySmall,
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
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 18,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                '${_formatDate(_bookingTime)} at ${_formatTime(_bookingTime)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 18,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                'Duration: 2 hours',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            children: [
              Icon(
                Icons.attach_money,
                size: 18,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                '£450',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
            'Client Information',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    widget.clientName[0],
                    style: const TextStyle(
                      color: Color(SwiftleadTokens.primaryTeal),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.clientName,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '+44 7700 900123',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.phone),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            '123 Main Street, London, SW1A 1AA',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          OutlinedButton.icon(
            onPressed: () {
              // Open navigation
            },
            icon: const Icon(Icons.directions),
            label: const Text('Navigate'),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDetails() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Details',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          _DetailRow(label: 'Service Type', value: 'Plumbing Repair'),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _DetailRow(label: 'Duration', value: '2 hours'),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _DetailRow(label: 'Deposit Required', value: '£100'),
          const SizedBox(height: SwiftleadTokens.spaceS),
          _DetailRow(label: 'Deposit Status', value: 'Paid'),
        ],
      ),
    );
  }

  Widget _buildStatusCard() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Confirmation Status',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Color(SwiftleadTokens.successGreen),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                'Confirmed by client',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Text(
            'Client confirmed on ${_formatDate(DateTime.now().subtract(const Duration(days: 1)))}',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Icon(
                Icons.notifications_active,
                size: 18,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                'Reminder sent',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOnMyWayButton() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: PrimaryButton(
        label: 'On My Way',
        onPressed: () {
          OnMyWaySheet.show(
            context: context,
            onSendETA: (minutes) {
              setState(() {
                _onMyWay = true;
              });
            },
          );
        },
        icon: Icons.directions_run,
      ),
    );
  }

  Widget _buildETACountdown() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimated Arrival',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                '30 min',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          OutlinedButton(
            onPressed: () {
              // Mark as arrived
            },
            child: const Text('Mark as Arrived'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FloatingActionButton(
          heroTag: 'complete',
          onPressed: () {
            CompleteBookingModal.show(
              context: context,
              bookingId: widget.bookingId,
              clientName: widget.clientName,
              serviceName: 'Kitchen Sink Repair',
            );
          },
          backgroundColor: const Color(SwiftleadTokens.successGreen),
          child: const Icon(Icons.check),
        ),
        const SizedBox(height: SwiftleadTokens.spaceS),
        FloatingActionButton(
          heroTag: 'message',
          onPressed: () {
            // Message client
          },
          child: const Icon(Icons.message),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return const Color(SwiftleadTokens.successGreen);
      case 'Pending':
        return const Color(SwiftleadTokens.warningYellow);
      case 'Cancelled':
        return const Color(SwiftleadTokens.errorRed);
      default:
        return const Color(SwiftleadTokens.textSecondaryLight);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
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

