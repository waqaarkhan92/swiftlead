import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/primary_button.dart';
import '../../widgets/global/info_banner.dart';
import '../../widgets/global/chip.dart';
import '../../widgets/global/progress_bar.dart';
import '../../widgets/global/toast.dart';
import 'package:flutter/services.dart';
import '../../theme/tokens.dart';
import '../calendar/service_catalog_screen.dart';

/// Create/Edit Booking Form - Create or edit a booking
/// Exact specification from UI_Inventory_v2.5.1
class CreateEditBookingScreen extends StatefulWidget {
  final String? bookingId; // If provided, editing mode
  final DateTime? initialDate;
  final Map<String, dynamic>? initialData;

  const CreateEditBookingScreen({
    super.key,
    this.bookingId,
    this.initialDate,
    this.initialData,
  });

  @override
  State<CreateEditBookingScreen> createState() => _CreateEditBookingScreenState();
}

class _CreateEditBookingScreenState extends State<CreateEditBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _clientController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  
  bool _isSaving = false;
  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;
  String? _selectedServiceId;
  String? _selectedServiceName;
  int? _duration; // minutes
  double? _price;
  bool _requiresDeposit = false;
  double? _depositAmount;
  bool _isRecurring = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate ?? DateTime.now().add(const Duration(days: 1));
    _selectedStartTime = const TimeOfDay(hour: 10, minute: 0);
    
    if (widget.initialData != null) {
      _clientController.text = widget.initialData!['clientName'] ?? '';
      _notesController.text = widget.initialData!['notes'] ?? '';
      _selectedServiceName = widget.initialData!['serviceName'];
      _duration = widget.initialData!['duration'];
      _price = widget.initialData!['price']?.toDouble();
    }
  }

  @override
  void dispose() {
    _clientController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _saveBooking() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDate == null || _selectedStartTime == null || _selectedServiceId == null) {
      Toast.show(
        context,
        message: 'Please fill in all required fields',
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
          message: widget.bookingId != null ? 'Booking updated' : 'Booking created',
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
        title: widget.bookingId != null ? 'Edit Booking' : 'Create Booking',
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
              message: widget.bookingId != null
                  ? 'Editing booking. Changes will be saved automatically.'
                  : 'Fill in the details below to create a new booking.',
              type: InfoBannerType.info,
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

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

            // Service Selector
            Text(
              'Service *',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            OutlinedButton.icon(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ServiceCatalogScreen(
                      onServiceSelected: (serviceId, serviceName) {
                        setState(() {
                          _selectedServiceId = serviceId;
                          _selectedServiceName = serviceName;
                          // Could fetch duration and price from service
                          _duration = 60; // Default
                          _price = 150.0; // Default
                        });
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.build),
              label: Text(
                _selectedServiceName ?? 'Select Service',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Date Picker
            Text(
              'Date *',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            OutlinedButton.icon(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                  });
                }
              },
              icon: const Icon(Icons.calendar_today),
              label: Text(
                _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'Select Date',
              ),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Time Pickers
            Text(
              'Time *',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _selectedStartTime ?? TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          _selectedStartTime = time;
                          if (_duration != null) {
                            final startMinutes = time.hour * 60 + time.minute;
                            final endMinutes = startMinutes + _duration!;
                            _selectedEndTime = TimeOfDay(
                              hour: (endMinutes ~/ 60) % 24,
                              minute: endMinutes % 60,
                            );
                          }
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _selectedStartTime != null
                          ? '${_selectedStartTime!.hour.toString().padLeft(2, '0')}:${_selectedStartTime!.minute.toString().padLeft(2, '0')}'
                          : 'Start',
                    ),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _selectedEndTime ?? TimeOfDay.now(),
                      );
                      if (time != null) {
                        setState(() {
                          _selectedEndTime = time;
                        });
                      }
                    },
                    icon: const Icon(Icons.access_time),
                    label: Text(
                      _selectedEndTime != null
                          ? '${_selectedEndTime!.hour.toString().padLeft(2, '0')}:${_selectedEndTime!.minute.toString().padLeft(2, '0')}'
                          : 'End',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Duration
            if (_duration != null) ...[
              Text(
                'Duration: ${(_duration! / 60).toStringAsFixed(0)}h ${(_duration! % 60)}min',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],

            // Price
            if (_price != null) ...[
              Text(
                'Price: £${_price!.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: const Color(SwiftleadTokens.primaryTeal),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],

            // Deposit Toggle
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Require Deposit',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Request deposit payment',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: _requiresDeposit,
                    onChanged: (value) {
                      setState(() {
                        _requiresDeposit = value;
                        if (value && _price != null) {
                          _depositAmount = _price! * 0.5; // 50% default
                        } else {
                          _depositAmount = null;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_requiresDeposit && _depositAmount != null) ...[
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                'Deposit Amount: £${_depositAmount!.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Recurring Toggle
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recurring Booking',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Repeat this booking',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Switch(
                    value: _isRecurring,
                    onChanged: (value) {
                      setState(() {
                        _isRecurring = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Notes
            TextFormField(
              controller: _notesController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add booking notes...',
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
                label: widget.bookingId != null ? 'Update Booking' : 'Create Booking',
                onPressed: _saveBooking,
                icon: widget.bookingId != null ? Icons.save : Icons.add,
              ),
          ],
        ),
      ),
    );
  }
}

