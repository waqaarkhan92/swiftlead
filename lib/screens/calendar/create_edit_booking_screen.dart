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
import '../../widgets/forms/deposit_request_sheet.dart';
import '../../widgets/forms/booking_offer_sheet.dart';
import '../../widgets/components/recurrence_pattern_picker.dart';
import '../../widgets/components/conflict_warning_card.dart';
import '../../widgets/forms/ai_availability_suggestions_sheet.dart';
import '../../widgets/global/info_banner.dart';
import 'booking_templates_screen.dart';

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
  bool _isMultiDay = false; // Multi-day booking support
  DateTime? _selectedEndDate; // End date for multi-day bookings
  bool _hasConflict = false; // Track if booking time conflicts with existing booking
  String? _conflictingBookingTitle;
  DateTime? _conflictingTime;
  String? _selectedTeamMember; // Team member assignment
  List<String> _selectedGroupAttendees = []; // For group bookings (multi-person appointments)
  bool _isGroupBooking = false; // Group booking toggle
  bool _addToWaitlist = false; // Waitlist toggle
  int _bufferTimeMinutes = 15; // Buffer time between bookings (default 15 minutes)
  bool _showBufferTime = true; // Show buffer time indicators

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

  // Smooth page route transitions
  PageRoute _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _clientController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _formatTimeWithBuffer() {
    if (_selectedStartTime == null || _duration == null) return '';
    final startMinutes = _selectedStartTime!.hour * 60 + _selectedStartTime!.minute;
    final endMinutes = startMinutes + _duration! + _bufferTimeMinutes;
    final endHour = (endMinutes ~/ 60) % 24;
    final endMin = endMinutes % 60;
    return '${endHour.toString().padLeft(2, '0')}:${endMin.toString().padLeft(2, '0')}';
  }

  void _checkForConflicts() {
    // Mock conflict detection - in real app, this would check against existing bookings
    // Includes buffer time calculation
    if (_selectedDate != null && _selectedStartTime != null && _duration != null) {
      final bookingStartTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedStartTime!.hour,
        _selectedStartTime!.minute,
      );
      final bookingEndTime = bookingStartTime.add(Duration(minutes: _duration!));
      final bookingEndWithBuffer = bookingEndTime.add(Duration(minutes: _bufferTimeMinutes));
      
      // Mock: Check if time conflicts (e.g., 10am-11am on same day)
      // Also check if buffer time would overlap with next booking
      final now = DateTime.now();
      final mockConflictTime = DateTime(now.year, now.month, now.day + 1, 10, 0);
      final mockConflictEnd = mockConflictTime.add(const Duration(hours: 1));
      
      // Check if booking overlaps or if buffer time would conflict
      final hasOverlap = (bookingStartTime.isBefore(mockConflictEnd) && bookingEndWithBuffer.isAfter(mockConflictTime));
      
      if (hasOverlap && bookingStartTime.year == mockConflictTime.year &&
          bookingStartTime.month == mockConflictTime.month &&
          bookingStartTime.day == mockConflictTime.day) {
        setState(() {
          _hasConflict = true;
          _conflictingBookingTitle = 'Bathroom Renovation';
          _conflictingTime = mockConflictTime;
        });
      } else {
        setState(() {
          _hasConflict = false;
          _conflictingBookingTitle = null;
          _conflictingTime = null;
        });
      }
    }
  }

  void _showTeamAssignmentSheet() {
    // Simple team member selector
    final teamMembers = ['Alex', 'Sam', 'Jordan', 'Taylor', 'Casey'];
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Team Member',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            ...teamMembers.map((member) => ListTile(
              title: Text(member),
              leading: CircleAvatar(
                child: Text(member[0]),
              ),
              selected: _selectedTeamMember == member,
              onTap: () {
                setState(() {
                  _selectedTeamMember = _selectedTeamMember == member ? null : member;
                });
                Navigator.pop(context);
              },
            )),
            if (_selectedTeamMember != null)
              ListTile(
                title: const Text('Unassign'),
                leading: const Icon(Icons.clear),
                onTap: () {
                  setState(() {
                    _selectedTeamMember = null;
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showSkillBasedAssignment() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skill-Based Assignment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Select required skills for this booking:'),
            const SizedBox(height: SwiftleadTokens.spaceM),
            ...['Plumbing', 'Electrical', 'HVAC', 'Carpentry', 'General'].map((skill) {
              return CheckboxListTile(
                title: Text(skill),
                value: false, // Would track selected skills
                onChanged: (value) {
                  // Handle skill selection
                },
              );
            }),
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
                message: 'Skill-based assignment enabled - will match team members with required skills',
                type: ToastType.success,
              );
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
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
    
    if (_isMultiDay && _selectedEndDate == null) {
      Toast.show(
        context,
        message: 'Please select an end date for multi-day booking',
        type: ToastType.error,
      );
      return;
    }
    
    if (_isMultiDay && _selectedEndDate != null && _selectedDate != null && _selectedEndDate!.isBefore(_selectedDate!)) {
      Toast.show(
        context,
        message: 'End date must be after start date',
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

            // Use Template Button (only when creating new booking)
            if (widget.bookingId == null)
              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    _createPageRoute(BookingTemplatesScreen()),
                  );
                },
                icon: const Icon(Icons.event_note_outlined),
                label: const Text('Use Booking Template'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            if (widget.bookingId == null) const SizedBox(height: SwiftleadTokens.spaceM),

            // Conflict Warning Card - Show if booking time conflicts
            if (_hasConflict && _conflictingBookingTitle != null && _conflictingTime != null && _selectedDate != null && _selectedStartTime != null)
              Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceM),
                child: ConflictWarningCard(
                  conflictingBookingTitle: _conflictingBookingTitle!,
                  conflictingTime: _conflictingTime!,
                  newBookingTime: DateTime(
                    _selectedDate!.year,
                    _selectedDate!.month,
                    _selectedDate!.day,
                    _selectedStartTime!.hour,
                    _selectedStartTime!.minute,
                  ),
                  onAdjust: () {
                    // Allow user to adjust time
                    setState(() {
                      _hasConflict = false;
                    });
                  },
                  onContinue: () {
                    // Continue with conflicting time
                    setState(() {
                      _hasConflict = false;
                    });
                  },
                  onCancel: () {
                    // Cancel booking creation
                    Navigator.of(context).pop();
                  },
                ),
              ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            // iOS-style grouped sections
            // Section 1: Client & Service Information
            FrostedContainer(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Text(
                      'Client & Service Information',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Column(
                      children: [
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
                  _createPageRoute(ServiceCatalogScreen(
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            // Section 2: Scheduling & Time
            FrostedContainer(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Text(
                      'Scheduling & Time',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Column(
                      children: [
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
                  _checkForConflicts();
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
            // Multi-Day Booking Toggle
            SwitchListTile(
              title: const Text('Multi-Day Booking'),
              subtitle: const Text('Booking spans multiple days'),
              value: _isMultiDay,
              onChanged: (value) {
                setState(() {
                  _isMultiDay = value;
                  if (value && _selectedDate != null) {
                    _selectedEndDate = _selectedDate!.add(const Duration(days: 1));
                  } else {
                    _selectedEndDate = null;
                  }
                });
              },
            ),
            
            // End Date Picker (shown when multi-day is enabled)
            if (_isMultiDay) ...[
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                'End Date *',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              OutlinedButton.icon(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedEndDate ?? (_selectedDate?.add(const Duration(days: 1)) ?? DateTime.now().add(const Duration(days: 2))),
                    firstDate: _selectedDate ?? DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedEndDate = picked;
                    });
                  }
                },
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  _selectedEndDate != null
                      ? '${_selectedEndDate!.day}/${_selectedEndDate!.month}/${_selectedEndDate!.year}'
                      : 'Select End Date',
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],

            // Team Assignment
            Text(
              'Assign to Team Member',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showTeamAssignmentSheet();
                    },
                    icon: const Icon(Icons.person_outline),
                    label: Text(
                      _selectedTeamMember ?? 'Select Team Member',
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                    ),
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceS),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    if (value == 'round_robin') {
                      Toast.show(
                        context,
                        message: 'Round-robin assignment enabled - next booking will auto-assign',
                        type: ToastType.info,
                      );
                    } else if (value == 'skill_based') {
                      _showSkillBasedAssignment();
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'round_robin',
                      child: Text(
                        'Round-Robin Assignment',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                    ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'skill_based',
                      child: Text(
                        'Skill-Based Assignment',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Group Booking Toggle
            SwitchListTile(
              title: const Text('Group Booking'),
              subtitle: const Text('Multi-person appointment'),
              value: _isGroupBooking,
              onChanged: (value) {
                setState(() {
                  _isGroupBooking = value;
                  if (!value) {
                    _selectedGroupAttendees = [];
                  }
                });
              },
            ),
            
            // Group Attendees Selector (shown when group booking is enabled)
            if (_isGroupBooking) ...[
              const SizedBox(height: SwiftleadTokens.spaceS),
              Text(
                'Additional Attendees',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: SwiftleadTokens.spaceS),
              OutlinedButton.icon(
                onPressed: () {
                  final teamMembers = ['Alex', 'Sam', 'Jordan', 'Taylor', 'Casey'];
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setModalState) => Container(
                        padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Select Attendees',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: SwiftleadTokens.spaceM),
                            ...teamMembers.map((member) => CheckboxListTile(
                              title: Text(member),
                              value: _selectedGroupAttendees.contains(member),
                              onChanged: (checked) {
                                setModalState(() {
                                  if (checked == true) {
                                    if (!_selectedGroupAttendees.contains(member)) {
                                      _selectedGroupAttendees.add(member);
                                    }
                                  } else {
                                    _selectedGroupAttendees.remove(member);
                                  }
                                });
                                setState(() {}); // Update parent state
                              },
                            )),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.people_outline),
                label: Text(
                  _selectedGroupAttendees.isEmpty
                      ? 'Select Attendees'
                      : '${_selectedGroupAttendees.length} attendee${_selectedGroupAttendees.length > 1 ? 's' : ''} selected',
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                ),
              ),
              if (_selectedGroupAttendees.isNotEmpty) ...[
                const SizedBox(height: SwiftleadTokens.spaceS),
                Wrap(
                  spacing: SwiftleadTokens.spaceS,
                  runSpacing: SwiftleadTokens.spaceS,
                  children: _selectedGroupAttendees.map((attendee) => Chip(
                    label: Text(attendee),
                    onDeleted: () {
                      setState(() {
                        _selectedGroupAttendees.remove(attendee);
                      });
                    },
                  )).toList(),
                ),
              ],
              const SizedBox(height: SwiftleadTokens.spaceM),
            ],

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
                      // Show AI suggestions first
                      if (_selectedDate != null) {
                        final suggestedTime = await AIAvailabilitySuggestionsSheet.show(
                          context: context,
                          startDate: _selectedDate!,
                          durationMinutes: _duration ?? 60,
                        );
                        if (suggestedTime != null && mounted) {
                          setState(() {
                            _selectedStartTime = TimeOfDay(
                              hour: suggestedTime.hour,
                              minute: suggestedTime.minute,
                            );
                            if (_duration != null) {
                              final startMinutes = suggestedTime.hour * 60 + suggestedTime.minute;
                              final endMinutes = startMinutes + _duration!;
                              _selectedEndTime = TimeOfDay(
                                hour: (endMinutes ~/ 60) % 24,
                                minute: endMinutes % 60,
                              );
                            }
                          });
                          _checkForConflicts();
                          return;
                        }
                      }
                      // Fallback to regular time picker
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
                        _checkForConflicts();
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
                              Flexible(
                                child: Column(
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
                                      overflow: TextOverflow.ellipsis,
                      ),
                    ],
                                ),
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
              Row(
                children: [
                              Flexible(
                                child: Text(
                    'Deposit Amount: £${_depositAmount!.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                                  overflow: TextOverflow.ellipsis,
                                ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      DepositRequestSheet.show(
                        context: context,
                        jobTitle: widget.bookingId != null ? 'Booking' : _selectedServiceName,
                        jobAmount: _price,
                        onSend: (amount, dueDate, message) {
                          setState(() {
                            _depositAmount = amount;
                          });
                        },
                      );
                    },
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Configure'),
                  ),
                ],
              ),
            ],
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Send Booking Offer Button
            OutlinedButton.icon(
              onPressed: () {
                BookingOfferSheet.show(
                  context: context,
                  onSendOffer: (timeSlot, service) {
                    // Handle booking offer sent
                  },
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Send Booking Offer'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Recurring Toggle
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                              Flexible(
                                child: Column(
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
                                      overflow: TextOverflow.ellipsis,
                      ),
                    ],
                                ),
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
            // Show recurrence pattern picker when recurring is enabled
            if (_isRecurring) ...[
              const SizedBox(height: SwiftleadTokens.spaceM),
              RecurrencePatternPicker(
                onPatternChanged: (pattern) {
                  // Handle pattern selection
                },
              ),
            ],
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Waitlist Toggle
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                              Flexible(
                                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add to Waitlist',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add client to waitlist if slot is full',
                        style: Theme.of(context).textTheme.bodySmall,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                      ),
                    ],
                                ),
                  ),
                  Switch(
                    value: _addToWaitlist,
                    onChanged: (value) {
                      setState(() {
                        _addToWaitlist = value;
                      });
                    },
                    activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),

            // Buffer Time Management
            FrostedContainer(
              padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                                  Flexible(
                                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Buffer Time',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Auto-calculate travel/prep time between appointments',
                            style: Theme.of(context).textTheme.bodySmall,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                          ),
                        ],
                                    ),
                      ),
                      Switch(
                        value: _showBufferTime,
                        onChanged: (value) {
                          setState(() {
                            _showBufferTime = value;
                          });
                          _checkForConflicts();
                        },
                        activeTrackColor: const Color(SwiftleadTokens.primaryTeal),
                      ),
                    ],
                  ),
                  if (_showBufferTime) ...[
                    const SizedBox(height: SwiftleadTokens.spaceM),
                    Row(
                      children: [
                                    Flexible(
                          child: Text(
                            'Buffer: ${_bufferTimeMinutes} minutes',
                            style: Theme.of(context).textTheme.bodyMedium,
                                        overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _bufferTimeMinutes > 0
                              ? () {
                                  setState(() {
                                    _bufferTimeMinutes = (_bufferTimeMinutes - 5).clamp(0, 60);
                                  });
                                  _checkForConflicts();
                                }
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: _bufferTimeMinutes < 60
                              ? () {
                                  setState(() {
                                    _bufferTimeMinutes = (_bufferTimeMinutes + 5).clamp(0, 60);
                                  });
                                  _checkForConflicts();
                                }
                              : null,
                        ),
                      ],
                    ),
                    if (_duration != null && _selectedStartTime != null) ...[
                      const SizedBox(height: SwiftleadTokens.spaceS),
                      InfoBanner(
                        message: 'Booking ends at ${_formatTimeWithBuffer()} (includes ${_bufferTimeMinutes}min buffer)',
                        type: InfoBannerType.info,
                      ),
                    ],
                  ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            // Section 3: Additional Options & Notes
            FrostedContainer(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Text(
                      'Additional Options & Notes',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
                    child: Column(
                      children: [
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            // Sticky save button (iOS pattern)
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

