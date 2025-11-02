import 'package:flutter/material.dart';
import '../widgets/global/frosted_bottom_nav_bar.dart';
import '../widgets/global/drawer.dart';
import 'home/home_screen.dart';
import 'inbox/inbox_screen.dart';
import 'jobs/jobs_screen.dart';
import 'calendar/calendar_screen.dart';
import 'money/money_screen.dart';
import 'ai_hub/ai_hub_screen.dart';
import 'reports/reports_screen.dart';
import 'settings/settings_screen.dart';
import 'support/support_screen.dart';
import 'legal/legal_screen.dart';
import 'contacts/contacts_screen.dart';
import 'marketing/marketing_screen.dart';
import '../theme/tokens.dart';

/// Main Navigation - Bottom tab navigation with drawer
/// Exact specification from Screen_Layouts_v2.5.1
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  final List<Widget> _screens = [
    const HomeScreen(),
    const InboxScreen(),
    const JobsScreen(),
    const CalendarScreen(),
    const MoneyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: SwiftleadDrawer(
        userName: 'Alex Johnson',
        organizationName: 'ABC Plumbing',
        planBadge: 'Swiftlead Pro',
        onProfileTap: () {
          Navigator.pop(context);
          // Navigate to profile
        },
        items: [
          DrawerItem(
            icon: Icons.auto_awesome,
            label: 'AI Hub',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AIHubScreen()),
              );
            },
          ),
          DrawerItem(
            icon: Icons.people_outline,
            label: 'Contacts',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ContactsScreen()),
              );
            },
          ),
          DrawerItem(
            icon: Icons.campaign_outlined,
            label: 'Marketing',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MarketingScreen()),
              );
            },
          ),
          DrawerItem(
            icon: Icons.analytics_outlined,
            label: 'Reports & Analytics',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ReportsScreen()),
              );
            },
          ),
          DrawerItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          DrawerItem(
            icon: Icons.help_outline,
            label: 'Support & Help',
            isSelected: false,
            badge: '2',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SupportScreen()),
              );
            },
          ),
          DrawerItem(
            icon: Icons.privacy_tip_outlined,
            label: 'Legal / Privacy',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LegalScreen()),
              );
            },
          ),
        ],
        footer: Column(
          children: [
            Text(
              'Version 2.5.1',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).brightness == Brightness.light
                    ? const Color(0xFF707070)
                    : Colors.white.withOpacity(0.65),
              ),
            ),
            const SizedBox(height: SwiftleadTokens.spaceS),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(SwiftleadTokens.successGreen),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: SwiftleadTokens.spaceXS),
                Text(
                  'Online',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: SwiftleadTokens.spaceM),
            TextButton(
              onPressed: () {
                // Logout
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _screens[_currentIndex],
          FrostedBottomNavBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() => _currentIndex = index);
            },
            items: [
              NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
              ),
              NavItem(
                icon: Icons.inbox_outlined,
                activeIcon: Icons.inbox,
                label: 'Inbox',
                badgeCount: 24, // Example
              ),
              NavItem(
                icon: Icons.work_outline,
                activeIcon: Icons.work,
                label: 'Jobs',
              ),
              NavItem(
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: 'Calendar',
              ),
              NavItem(
                icon: Icons.attach_money_outlined,
                activeIcon: Icons.attach_money,
                label: 'Money',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

