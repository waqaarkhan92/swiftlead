import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';
import 'create_edit_booking_screen.dart';
import 'booking_detail_screen.dart';
import 'calendar_search_screen.dart';
import '../../config/mock_config.dart';
import '../../mock/mock_repository.dart';
import '../../widgets/components/booking_card.dart';
import '../../widgets/components/job_card.dart';
import '../../models/job.dart';
import '../../mock/mock_jobs.dart';
import '../jobs/job_detail_screen.dart';
import '../../widgets/forms/on_my_way_sheet.dart';
import '../../widgets/forms/calendar_filter_sheet.dart';
import '../../widgets/global/toast.dart';
import '../main_navigation.dart' as main_nav;
import 'blocked_time_screen.dart';
import 'booking_templates_screen.dart';
import 'booking_analytics_screen.dart';
import 'capacity_optimization_screen.dart';
import 'resource_management_screen.dart';

/// CalendarScreen - Bookings & Scheduling
/// Exact specification from Screen_Layouts_v2.5.1
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  bool _isLoading = true;
  String _selectedView = 'month'; // day | week | month
  bool _isTeamView = false; // Personal vs Team calendar
  List<Booking> _allBookings = [];
  List<Booking> _filteredBookings = []; // Filtered bookings
  List<Booking> _todayBookings = [];
  List<Job> _allJobs = []; // Jobs with scheduled dates
  late DateTime _selectedDate;
  late DateTime _currentMonth;
  Map<String, dynamic>? _activeFilters; // Active filter state
  double _calendarScale = 1.0; // Pinch-to-zoom scale
  
  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = now;
    _currentMonth = DateTime(now.year, now.month, 1);
    _loadBookings();
  }


  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);

    if (kUseMockData) {
      _allBookings = await MockBookings.fetchAll();
      _todayBookings = await MockBookings.fetchToday();
      // Load scheduled jobs for calendar view
      final allJobs = await MockJobs.fetchAll();
      _allJobs = allJobs.where((j) => j.scheduledDate != null).toList();
      _applyFilters(); // Apply filters after loading
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  void _handleDragReschedule(Booking booking, DateTime newStartTime) {
    // Calculate duration from original booking
    final duration = booking.endTime.difference(booking.startTime);
    final newEndTime = newStartTime.add(duration);
    
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reschedule Booking'),
        content: Text(
          'Reschedule "${booking.serviceType}" to ${newStartTime.hour.toString().padLeft(2, '0')}:${newStartTime.minute.toString().padLeft(2, '0')}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Update booking time (in real app, this would call backend)
              setState(() {
                final index = _allBookings.indexWhere((b) => b.id == booking.id);
                if (index != -1) {
                  _allBookings[index] = Booking(
                    id: booking.id,
                    contactId: booking.contactId,
                    contactName: booking.contactName,
                    serviceType: booking.serviceType,
                    startTime: newStartTime,
                    endTime: newEndTime,
                    status: booking.status,
                    address: booking.address,
                    notes: booking.notes,
                    reminderSent: booking.reminderSent,
                    depositRequired: booking.depositRequired,
                    depositAmount: booking.depositAmount,
                    createdAt: booking.createdAt,
                    assignedTo: booking.assignedTo,
                    groupAttendees: booking.groupAttendees,
                    completedAt: booking.completedAt,
                  );
                  _applyFilters();
                }
              });
              Navigator.pop(context);
              Toast.show(
                context,
                message: 'Booking rescheduled successfully',
                type: ToastType.success,
              );
            },
            child: const Text('Reschedule'),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    if (_activeFilters == null && !_isTeamView) {
      _filteredBookings = List.from(_allBookings);
      return;
    }

    _filteredBookings = _allBookings.where((booking) {
      // Team view filter - show only bookings assigned to team members
      if (_isTeamView) {
        if (booking.assignedTo == null) return false;
      }

      // Status filter
      if (_activeFilters != null && _activeFilters!['status'] != null && _activeFilters!['status'] != 'All') {
        final filterStatus = _activeFilters!['status'] as String;
        final bookingStatus = booking.status.displayName;
        if (bookingStatus != filterStatus) return false;
      }

      // Service type filter
      if (_activeFilters != null && _activeFilters!['serviceType'] != null && _activeFilters!['serviceType'] != 'All') {
        final filterService = _activeFilters!['serviceType'] as String;
        if (booking.serviceType != filterService) return false;
      }

      // Team member filter
      if (_activeFilters != null && _activeFilters!['teamMember'] != null && _activeFilters!['teamMember'] != 'All') {
        final filterMember = _activeFilters!['teamMember'] as String;
        if (booking.assignedTo != filterMember) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: FrostedAppBar(
        scaffoldKey: main_nav.MainNavigation.scaffoldKey,
        title: 'Calendar',
        actions: [
          // Primary actions - always visible
          IconButton(
            icon: const Icon(Icons.search_outlined),
            tooltip: 'Search',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CalendarSearchScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list_outlined),
            tooltip: 'Filter',
            onPressed: () async {
              final filters = await CalendarFilterSheet.show(
                context: context,
                initialFilters: _activeFilters,
              );
              if (filters != null) {
                setState(() {
                  _activeFilters = filters;
                  _applyFilters();
                });
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.today_outlined),
            tooltip: 'Today',
            onPressed: () {
              setState(() {
                final now = DateTime.now();
                _selectedDate = now;
                _currentMonth = DateTime(now.year, now.month, 1);
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'New Booking',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateEditBookingScreen(),
                ),
              );
            },
          ),
          // More menu for additional actions
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More',
            onSelected: (value) {
              switch (value) {
                case 'templates':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingTemplatesScreen(),
                    ),
                  );
                  break;
                case 'blocked_time':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BlockedTimeScreen(),
                    ),
                  );
                  break;
                case 'analytics':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BookingAnalyticsScreen(),
                    ),
                  );
                  break;
                case 'capacity':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CapacityOptimizationScreen(),
                    ),
                  );
                  break;
                case 'resources':
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResourceManagementScreen(),
                    ),
                  );
                  break;
                case 'team_toggle':
                  setState(() {
                    _isTeamView = !_isTeamView;
                    _applyFilters();
                  });
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'templates',
                child: Row(
                  children: [
                    Icon(Icons.event_note_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Booking Templates'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'blocked_time',
                child: Row(
                  children: [
                    Icon(Icons.event_busy, size: 20),
                    SizedBox(width: 12),
                    Text('Blocked Time'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'analytics',
                child: Row(
                  children: [
                    Icon(Icons.analytics_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Booking Analytics'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'capacity',
                child: Row(
                  children: [
                    Icon(Icons.tune_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Capacity Optimization'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'resources',
                child: Row(
                  children: [
                    Icon(Icons.construction_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Resource Management'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'team_toggle',
                child: Row(
                  children: [
                    Icon(_isTeamView ? Icons.person : Icons.people, size: 20),
                    const SizedBox(width: 12),
                    Text(_isTeamView ? 'Switch to Personal' : 'Switch to Team'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : _buildContent(),
    );
  }

  Widget _buildLoadingState() {
    return ListView(
      padding: const EdgeInsets.only(
        left: SwiftleadTokens.spaceM,
        right: SwiftleadTokens.spaceM,
        top: SwiftleadTokens.spaceM,
        bottom: 96, // 64px nav height + 32px spacing for floating aesthetic
      ),
      children: [
        // Calendar skeleton
        SkeletonLoader(
          width: double.infinity,
          height: 300,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
        const SizedBox(height: SwiftleadTokens.spaceL),
        // Booking list skeleton
        SkeletonLoader(
          width: double.infinity,
          height: 100,
          borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return RefreshIndicator(
      onRefresh: () async {
        // Pull-to-refresh syncs calendar integrations
        await _loadBookings();
      },
      child: ListView(
        padding: const EdgeInsets.only(
          left: SwiftleadTokens.spaceM,
          right: SwiftleadTokens.spaceM,
          top: SwiftleadTokens.spaceM,
          bottom: 96, // 64px nav height + 32px spacing for floating aesthetic
        ),
        children: [
          // CalendarHeader - Month/week navigation
          _buildCalendarHeader(),
          const SizedBox(height: SwiftleadTokens.spaceM),
          
          // CalendarWidget - Interactive calendar grid (Day/Week/Month view) with pinch-to-zoom
          GestureDetector(
            onScaleUpdate: (details) {
              // Pinch-to-zoom: Zoom in/out between week ↔ day view
              if (details.scale > 1.2 && _selectedView == 'week') {
                setState(() {
                  _selectedView = 'day';
                });
              } else if (details.scale < 0.8 && _selectedView == 'day') {
                setState(() {
                  _selectedView = 'week';
                });
              }
            },
            child: Transform.scale(
              scale: _calendarScale,
              child: _buildCalendarWidget(),
            ),
          ),
          const SizedBox(height: SwiftleadTokens.spaceL),
          
          // On My Way Button - Quick action for heading to appointments
          if (_hasConfirmedBookingsToday()) _buildOnMyWayButton(),
          if (_hasConfirmedBookingsToday()) const SizedBox(height: SwiftleadTokens.spaceL),
          
          // BookingList - Cards below calendar
          _buildBookingList(),
        ],
      ),
    );
  }

  Widget _buildCalendarHeader() {
    return Column(
      children: [
        // View toggle (day/week/month)
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'day', label: Text('Day')),
            ButtonSegment(value: 'week', label: Text('Week')),
            ButtonSegment(value: 'month', label: Text('Month')),
          ],
          selected: {_selectedView},
          onSelectionChanged: (Set<String> newSelection) {
            setState(() => _selectedView = newSelection.first);
          },
        ),
        const SizedBox(height: SwiftleadTokens.spaceM),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {
                setState(() {
                  _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
                });
              },
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  final now = DateTime.now();
                  _selectedDate = now;
                  _currentMonth = DateTime(now.year, now.month, 1);
                });
              },
              child: const Text('Today'),
            ),
            Text(
              _formatMonthYear(_currentMonth),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                setState(() {
                  _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarWidget() {
    // Render different views based on _selectedView
    switch (_selectedView) {
      case 'day':
        return _buildDayView();
      case 'week':
        return _buildWeekView();
      case 'month':
      default:
        return _buildMonthView();
    }
  }

  Widget _buildDayView() {
    // Get bookings for selected day
    final displayBookings = _filteredBookings.isEmpty ? _allBookings : _filteredBookings;
    final dayBookings = displayBookings.where((booking) {
      final bookingDate = booking.startTime;
      return bookingDate.year == _selectedDate.year &&
          bookingDate.month == _selectedDate.month &&
          bookingDate.day == _selectedDate.day;
    }).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatDate(_selectedDate),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Hourly time slots (limited to 12 hours for better UX)
          ...List.generate(12, (index) {
            final hour = index + 8; // 8 AM to 8 PM
            final hourStart = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, hour);
            final hourEnd = hourStart.add(const Duration(hours: 1));
            
            // Find bookings/jobs in this hour
            final hourBookings = dayBookings.where((b) {
              return b.startTime.isBefore(hourEnd) && b.endTime.isAfter(hourStart);
            }).toList();
            
            // Check for buffer time indicators (15min default buffer between bookings)
            final bufferTimeMinutes = 15;
            final hasBufferTime = hourBookings.isNotEmpty && hourBookings.length > 1;
            
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.2),
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 60,
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  Flexible(
                    child: DragTarget<Booking>(
                      onAccept: (draggedBooking) {
                        // Handle drop on empty time slot - reschedule booking to this hour
                        _handleDragReschedule(draggedBooking, hourStart);
                      },
                      builder: (context, candidateData, rejectedData) {
                        return Container(
                          decoration: BoxDecoration(
                            color: candidateData.isNotEmpty
                                ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: candidateData.isNotEmpty
                                ? Border.all(color: const Color(SwiftleadTokens.primaryTeal), width: 2, style: BorderStyle.solid)
                                : null,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: hourBookings.map((booking) {
                              return Draggable<Booking>(
                                data: booking,
                                feedback: Material(
                                  color: Colors.transparent,
                                  child: Opacity(
                                    opacity: 0.8,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(SwiftleadTokens.primaryTeal),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '${booking.startTime.hour.toString().padLeft(2, '0')}:${booking.startTime.minute.toString().padLeft(2, '0')} - ${booking.serviceType}',
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                childWhenDragging: Opacity(
                                  opacity: 0.3,
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 4),
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${booking.startTime.hour.toString().padLeft(2, '0')}:${booking.startTime.minute.toString().padLeft(2, '0')} - ${booking.serviceType}',
                                      style: Theme.of(context).textTheme.bodySmall,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.drag_handle, size: 16),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          '${booking.startTime.hour.toString().padLeft(2, '0')}:${booking.startTime.minute.toString().padLeft(2, '0')} - ${booking.serviceType}',
                                          style: Theme.of(context).textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
          if (dayBookings.isEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'No bookings scheduled for this day',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWeekView() {
    // Calculate start of week (Monday)
    final weekStart = _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
    final weekDays = List.generate(7, (i) => weekStart.add(Duration(days: i)));
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Weekday headers
          Row(
            children: weekDays.map((day) {
              final isToday = day.year == DateTime.now().year &&
                  day.month == DateTime.now().month &&
                  day.day == DateTime.now().day;
              final isSelected = day.year == _selectedDate.year &&
                  day.month == _selectedDate.month &&
                  day.day == _selectedDate.day;
              
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = day;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                      border: isToday
                          ? Border.all(
                              color: const Color(SwiftleadTokens.primaryTeal),
                              width: 2,
                            )
                          : null,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][day.weekday - 1],
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            color: isToday || isSelected
                                ? const Color(SwiftleadTokens.primaryTeal)
                                : null,
                            fontWeight: isToday || isSelected ? FontWeight.w700 : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // Week view content - show bookings for selected day
          _buildDayView(),
        ],
      ),
    );
  }

  Widget _buildMonthView() {
    // Calculate the first day of the month
    final firstDayOfMonth = DateTime(_currentMonth.year, _currentMonth.month, 1);
    // Get the weekday (0 = Sunday, 1 = Monday, ..., 6 = Saturday)
    final firstDayOfWeek = firstDayOfMonth.weekday % 7;
    // Get the number of days in the current month
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    // Get today's date
    final today = DateTime.now();
    // Get selected date (only year and month and day matter)
    final selectedDateOnly = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
      ),
      child: Column(
        children: [
          // WeekdayLabels with current day highlighted
          Row(
            children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: SwiftleadTokens.spaceM),
          // DayCell grid - Shows date + event dots
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: 35, // 5 weeks
            itemBuilder: (context, index) {
              // Calculate which day this cell represents
              int day;
              bool isInCurrentMonth = false;
              
              if (index < firstDayOfWeek) {
                // Days from previous month (show as empty/grey)
                day = 0; // Empty cell
              } else if (index < firstDayOfWeek + daysInMonth) {
                // Days in current month
                day = index - firstDayOfWeek + 1;
                isInCurrentMonth = true;
              } else {
                // Days from next month (show as empty/grey)
                day = 0; // Empty cell
              }
              
              if (day == 0) {
                // Empty cell (previous/next month)
                return Container();
              }
              
              // Create the date for this cell
              final cellDate = DateTime(_currentMonth.year, _currentMonth.month, day);
              final cellDateOnly = DateTime(cellDate.year, cellDate.month, cellDate.day);
              
              // Check if this is today
              final isToday = cellDateOnly.year == today.year &&
                  cellDateOnly.month == today.month &&
                  cellDateOnly.day == today.day;
              
              // Check if this is selected
              final isSelected = cellDateOnly.year == selectedDateOnly.year &&
                  cellDateOnly.month == selectedDateOnly.month &&
                  cellDateOnly.day == selectedDateOnly.day;
              
              // Check if this day has bookings or jobs (use filtered bookings)
              final hasBooking = _filteredBookings.any((booking) {
                final bookingDate = booking.startTime;
                return bookingDate.year == cellDate.year &&
                    bookingDate.month == cellDate.month &&
                    bookingDate.day == cellDate.day;
              });
              final hasJob = _allJobs.any((job) {
                final jobDate = job.scheduledDate!;
                return jobDate.year == cellDate.year &&
                    jobDate.month == cellDate.month &&
                    jobDate.day == cellDate.day;
              });
              final hasEvent = hasBooking || hasJob;
              
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = cellDate;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(SwiftleadTokens.primaryTeal).withOpacity(0.1)
                        : null,
                    border: isToday
                        ? Border.all(
                            color: const Color(SwiftleadTokens.primaryTeal),
                            width: 2,
                          )
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$day',
                        style: TextStyle(
                          color: isToday || isSelected
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : (isInCurrentMonth
                                  ? Theme.of(context).textTheme.bodyLarge?.color
                                  : Theme.of(context).textTheme.bodyLarge?.color?.withOpacity(0.3)),
                          fontWeight: isToday || isSelected ? FontWeight.w700 : FontWeight.normal,
                        ),
                      ),
                      if (hasEvent)
                        const SizedBox(height: 2),
                      if (hasEvent)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: Color(SwiftleadTokens.primaryTeal),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
                     'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatMonthYear(DateTime date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
                     'July', 'August', 'September', 'October', 'November', 'December'];
    return '${months[date.month - 1]} ${date.year}';
  }

  Widget _buildBookingList() {
    // Use filtered bookings for display
    final displayBookings = _filteredBookings.isEmpty ? _allBookings : _filteredBookings;
    
    if (displayBookings.isEmpty && _allJobs.isEmpty) {
      return EmptyStateCard(
        title: 'No bookings scheduled',
        description: 'Your calendar is clear. Start booking appointments.',
        icon: Icons.calendar_today_outlined,
        actionLabel: 'Book Appointment',
        onAction: () {},
      );
    }

    return Column(
      children: [
        // Show bookings (use filtered bookings) with buffer time indicators
        ...List.generate(displayBookings.length, (index) {
          final booking = displayBookings[index];
          final nextBooking = index < displayBookings.length - 1 ? displayBookings[index + 1] : null;
          
          // Calculate buffer time between bookings (default 15 minutes)
          final bufferTimeMinutes = 15;
          final hasBufferTime = nextBooking != null;
          final timeBetween = hasBufferTime 
              ? nextBooking.startTime.difference(booking.endTime).inMinutes
              : null;
          final needsBufferWarning = hasBufferTime && timeBetween != null && timeBetween < bufferTimeMinutes;
          
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
                child: BookingCard(
                  bookingId: booking.id,
                  clientName: booking.contactName,
                  serviceName: booking.serviceType,
                  startTime: booking.startTime,
                  endTime: booking.endTime,
                  status: booking.status.name,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingDetailScreen(
                          bookingId: booking.id,
                          clientName: booking.contactName,
                        ),
                      ),
                    );
                  },
                  onStatusChange: () {
                    // Reload bookings after status change
                    _loadBookings();
                  },
                ),
              ),
              // Buffer time indicator between bookings
              if (hasBufferTime && timeBetween != null) ...[
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: needsBufferWarning
                        ? const Color(SwiftleadTokens.warningYellow).withOpacity(0.1)
                        : const Color(SwiftleadTokens.successGreen).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: needsBufferWarning
                          ? const Color(SwiftleadTokens.warningYellow).withOpacity(0.3)
                          : const Color(SwiftleadTokens.successGreen).withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        needsBufferWarning ? Icons.warning_amber_rounded : Icons.access_time,
                        size: 14,
                        color: needsBufferWarning
                            ? const Color(SwiftleadTokens.warningYellow)
                            : const Color(SwiftleadTokens.successGreen),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        needsBufferWarning
                            ? 'Only ${timeBetween}min gap - consider ${bufferTimeMinutes - timeBetween}min buffer'
                            : '${timeBetween}min buffer time',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: needsBufferWarning
                              ? const Color(SwiftleadTokens.warningYellow)
                              : const Color(SwiftleadTokens.successGreen),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          );
        }),
        // Show scheduled jobs
        ...List.generate(_allJobs.length, (index) {
          final job = _allJobs[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: SwiftleadTokens.spaceS),
            child: JobCard(
              jobTitle: job.title,
              clientName: job.contactName,
              serviceType: job.serviceType,
              status: job.status.displayName,
              dueDate: job.scheduledDate,
              price: job.value > 0 ? '£${job.value.toStringAsFixed(2)}' : null,
              teamMemberName: job.assignedTo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JobDetailScreen(
                      jobId: job.id,
                      jobTitle: job.title,
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  bool _hasConfirmedBookingsToday() {
    final today = DateTime.now();
    final displayBookings = _filteredBookings.isEmpty ? _allBookings : _filteredBookings;
    return displayBookings.any((booking) {
      final bookingDate = DateTime(
        booking.startTime.year,
        booking.startTime.month,
        booking.startTime.day,
      );
      final todayDate = DateTime(today.year, today.month, today.day);
      return bookingDate == todayDate && 
             booking.status == BookingStatus.confirmed;
    });
  }


  Widget _buildOnMyWayButton() {
    return FrostedContainer(
      padding: const EdgeInsets.all(SwiftleadTokens.spaceM),
      child: PrimaryButton(
        label: 'On My Way',
        icon: Icons.directions_car,
        onPressed: () {
          OnMyWaySheet.show(
            context: context,
            onSendETA: (minutes) {
              // Handle ETA sent
            },
          );
        },
      ),
    );
  }
}
