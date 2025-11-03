import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
import '../../widgets/global/toast.dart';
import 'create_edit_booking_screen.dart';
import '../../widgets/forms/on_my_way_sheet.dart';
import 'reminder_settings_screen.dart';
import '../inbox/inbox_screen.dart';

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
                case 'reminder_settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ReminderSettingsScreen(),
                    ),
                  );
                  break;
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
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'reminder_settings', child: Text('Reminder Settings')),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'reschedule', child: Text('Reschedule')),
              const PopupMenuItem(value: 'cancel', child: Text('Cancel')),
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

        // Reminder Status
        _buildReminderStatus(),
        const SizedBox(height: SwiftleadTokens.spaceL),

        // Booking Notes
        _buildBookingNotes(),
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
                onPressed: () async {
                  final phoneNumber = '+44 7700 900123';
                  final uri = Uri.parse('tel:$phoneNumber');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    if (mounted) {
                      Toast.show(
                        context,
                        message: 'Could not launch phone dialer',
                        type: ToastType.error,
                      );
                    }
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {
                  // Navigate to inbox and filter by contact name
                  // In a real app, would find thread by contact ID/name
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const InboxScreen(),
                    ),
                  );
                  // Show a toast to indicate which contact to look for
                  Future.delayed(const Duration(milliseconds: 300), () {
                    if (mounted) {
                      Toast.show(
                        context,
                        message: 'Navigate to conversation with ${widget.clientName}',
                        type: ToastType.info,
                      );
                    }
                  });
                },
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
                decoration: BoxDecoration(
                  color: _status == 'Confirmed' || _status == 'Pending'
                      ? const Color(SwiftleadTokens.successGreen)
                      : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Text(
                _status == 'Confirmed' ? 'Confirmed by client' : 'Pending confirmation',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          if (_status == 'Confirmed') ...[
            const SizedBox(height: SwiftleadTokens.spaceS),
            Text(
              'Client confirmed on ${_formatDate(DateTime.now().subtract(const Duration(days: 1)))}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          const SizedBox(height: SwiftleadTokens.spaceM),
          PrimaryButton(
            label: _status == 'Confirmed' ? 'Resend Confirmation' : 'Confirm Booking',
            onPressed: () {
              BookingConfirmationSheet.show(
                context: context,
                bookingId: widget.bookingId,
                clientName: widget.clientName,
                bookingTime: _bookingTime,
                serviceName: 'Kitchen Sink Repair',
                currentStatus: _status.toLowerCase(),
                onConfirmed: (confirmed, sendNotification) {
                  if (confirmed && _status != 'Confirmed') {
                    setState(() {
                      _status = 'Confirmed';
                    });
                  }
                },
              );
            },
            icon: _status == 'Confirmed' ? Icons.send : Icons.check_circle,
            size: ButtonSize.small,
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
              setState(() {
                _onMyWay = false;
                _status = 'In Progress';
              });
              Toast.show(
                context,
                message: 'Marked as arrived',
                type: ToastType.success,
              );
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

  Widget _buildReminderStatus() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reminder Status',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Row(
            children: [
              Icon(
                Icons.notifications_active,
                size: 18,
                color: const Color(SwiftleadTokens.successGreen),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: Text(
                  '24h reminder sent',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                '2 hours ago',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceS),
          Row(
            children: [
              Icon(
                Icons.notifications_active,
                size: 18,
                color: const Color(SwiftleadTokens.warningYellow),
              ),
              const SizedBox(width: SwiftleadTokens.spaceS),
              Expanded(
                child: Text(
                  '2h reminder pending',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Text(
                'In 22 hours',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingNotes() {
    return FrostedContainer(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Booking Notes',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextButton.icon(
                onPressed: () {
                  // Edit notes
                },
                icon: const Icon(Icons.edit, size: 18),
                label: const Text('Edit'),
              ),
            ],
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          Text(
            'Client mentioned that the sink is leaking and making strange noises. Please bring extra washers and check the water pressure.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
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

