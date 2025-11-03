import 'package:flutter/material.dart';
import '../../widgets/global/frosted_app_bar.dart';
import '../../widgets/global/frosted_container.dart';
import '../../widgets/global/skeleton_loader.dart';
import '../../widgets/global/empty_state_card.dart';
import '../../widgets/global/primary_button.dart';
import '../../theme/tokens.dart';
import 'create_edit_booking_screen.dart';
import 'booking_detail_screen.dart';
import '../../config/mock_config.dart';
import '../../mock/mock_repository.dart';
import '../../widgets/components/booking_card.dart';
import '../../widgets/forms/on_my_way_sheet.dart';
import '../main_navigation.dart' as main_nav;

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
  List<Booking> _allBookings = [];
  List<Booking> _todayBookings = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    setState(() => _isLoading = true);

    if (kUseMockData) {
      _allBookings = await MockBookings.fetchAll();
      _todayBookings = await MockBookings.fetchToday();
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
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
          IconButton(
            icon: const Icon(Icons.today_outlined),
            onPressed: () {
              setState(() {
                _selectedDate = DateTime.now();
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.search_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateEditBookingScreen(),
                ),
              );
            },
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
          
          // CalendarWidget - Interactive calendar grid
          _buildCalendarWidget(),
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
              onPressed: () {},
            ),
            TextButton(
              onPressed: () {
                // Jump to today
              },
              child: const Text('Today'),
            ),
            const Text(
              'November 2024',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendarWidget() {
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
              final day = index + 1;
              final isToday = day == DateTime.now().day;
              final hasEvent = index % 5 == 0; // Example: some days have events
              
              return GestureDetector(
                onTap: () {
                  // Tap day to see all events
                },
                child: Container(
                  decoration: BoxDecoration(
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
                          color: isToday
                              ? const Color(SwiftleadTokens.primaryTeal)
                              : Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: isToday ? FontWeight.w700 : FontWeight.normal,
                        ),
                      ),
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

  Widget _buildBookingList() {
    if (_allBookings.isEmpty) {
      return EmptyStateCard(
        title: 'No bookings scheduled',
        description: 'Your calendar is clear. Start booking appointments.',
        icon: Icons.calendar_today_outlined,
        actionLabel: 'Book Appointment',
        onAction: () {},
      );
    }

    return Column(
      children: List.generate(_allBookings.length, (index) {
        final booking = _allBookings[index];
        return Padding(
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
          ),
        );
      }),
    );
  }

  bool _hasConfirmedBookingsToday() {
    final today = DateTime.now();
    return _allBookings.any((booking) {
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
