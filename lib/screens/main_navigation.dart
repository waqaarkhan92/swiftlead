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
  final Function(ThemeMode) onThemeChanged;
  final ThemeMode currentThemeMode;
  
  const MainNavigation({super.key, required this.onThemeChanged, required this.currentThemeMode});
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  List<Widget> get _screens => [
    HomeScreen(),
    InboxScreen(),
    JobsScreen(),
    CalendarScreen(),
    MoneyScreen(),
  ];
  
  // Mapping for drawer screens
  Map<String, Widget> get _drawerScreenMap => {
    'ai_hub': AIHubScreen(),
    'contacts': ContactsScreen(),
    'marketing': MarketingScreen(),
    'reports': ReportsScreen(),
    'settings': SettingsScreen(
      onThemeChanged: widget.onThemeChanged,
      currentThemeMode: widget.currentThemeMode,
    ),
    'support': SupportScreen(),
    'legal': LegalScreen(),
  };
  
  Widget? _drawerScreen;

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      key: MainNavigation.scaffoldKey,
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
              setState(() => _drawerScreen = _drawerScreenMap['ai_hub']);
            },
          ),
          DrawerItem(
            icon: Icons.people_outline,
            label: 'Contacts',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              setState(() => _drawerScreen = _drawerScreenMap['contacts']);
            },
          ),
          DrawerItem(
            icon: Icons.campaign_outlined,
            label: 'Marketing',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              setState(() => _drawerScreen = _drawerScreenMap['marketing']);
            },
          ),
          DrawerItem(
            icon: Icons.analytics_outlined,
            label: 'Reports & Analytics',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              setState(() => _drawerScreen = _drawerScreenMap['reports']);
            },
          ),
          DrawerItem(
            icon: Icons.settings_outlined,
            label: 'Settings',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              setState(() => _drawerScreen = _drawerScreenMap['settings']);
            },
          ),
          DrawerItem(
            icon: Icons.help_outline,
            label: 'Support & Help',
            isSelected: false,
            badge: '2',
            onTap: () {
              Navigator.pop(context);
              setState(() => _drawerScreen = _drawerScreenMap['support']);
            },
          ),
          DrawerItem(
            icon: Icons.privacy_tip_outlined,
            label: 'Legal / Privacy',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              setState(() => _drawerScreen = _drawerScreenMap['legal']);
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
          _drawerScreen ?? _screens[_currentIndex],
          FrostedBottomNavBar(
            currentIndex: _drawerScreen != null ? -1 : _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _drawerScreen = null; // Clear drawer screen when switching tabs
              });
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
                customIcon: '£',
                customActiveIcon: '£',
                label: 'Money',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

