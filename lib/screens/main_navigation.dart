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
import 'reviews/reviews_screen.dart';
import 'settings/settings_screen.dart';
import 'support/support_screen.dart';
import 'legal/legal_screen.dart';
import 'contacts/contacts_screen.dart';
import '../theme/tokens.dart';
import '../utils/profession_config.dart';

/// Main Navigation - Bottom tab navigation with drawer
/// Exact specification from Screen_Layouts_v2.5.1
class MainNavigation extends StatefulWidget {
  final Function(ThemeMode)? onThemeChanged;
  final ThemeMode currentThemeMode;
  
  const MainNavigation({
    super.key,
    this.onThemeChanged,
    this.currentThemeMode = ThemeMode.system,
  });
  static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  
  // Get visible screens based on profession
  List<Widget> get _screens {
    final config = ProfessionState.config;
    final screens = <Widget>[];
    
    if (config.isModuleVisible('home')) screens.add(HomeScreen());
    if (config.isModuleVisible('inbox')) screens.add(InboxScreen());
    if (config.isModuleVisible('jobs')) screens.add(JobsScreen());
    if (config.isModuleVisible('calendar')) screens.add(CalendarScreen());
    if (config.isModuleVisible('money')) screens.add(MoneyScreen());
    
    return screens;
  }
  
  // Get navigation items based on profession
  List<NavItem> get _navItems {
    final config = ProfessionState.config;
    final items = <NavItem>[];
    
    if (config.isModuleVisible('home')) {
      items.add(NavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        label: 'Home',
      ));
    }
    if (config.isModuleVisible('inbox')) {
      items.add(NavItem(
        icon: Icons.inbox_outlined,
        activeIcon: Icons.inbox,
        label: 'Inbox',
        badgeCount: 24,
      ));
    }
    if (config.isModuleVisible('jobs')) {
      items.add(NavItem(
        icon: Icons.work_outline,
        activeIcon: Icons.work,
        label: config.getLabel('Jobs'),
      ));
    }
    if (config.isModuleVisible('calendar')) {
      items.add(NavItem(
        icon: Icons.calendar_today_outlined,
        activeIcon: Icons.calendar_today,
        label: 'Calendar',
      ));
    }
    if (config.isModuleVisible('money')) {
      items.add(NavItem(
        customIcon: '£',
        customActiveIcon: '£',
        label: 'Money',
      ));
    }
    
    return items;
  }
  
  // Mapping for drawer screens
  Map<String, Widget> get _drawerScreenMap => {
    'ai_hub': AIHubScreen(),
    'contacts': ContactsScreen(),
    'reports': ReportsScreen(),
    'reviews': ReviewsScreen(),
    'settings': SettingsScreen(
      onThemeChanged: widget.onThemeChanged ?? (_) {},
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
            icon: Icons.analytics_outlined,
            label: 'Reports & Analytics',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              setState(() => _drawerScreen = _drawerScreenMap['reports']);
            },
          ),
          DrawerItem(
            icon: Icons.star_outline,
            label: 'Reviews',
            isSelected: false,
            onTap: () {
              Navigator.pop(context);
              setState(() => _drawerScreen = _drawerScreenMap['reviews']);
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
            items: _navItems,
          ),
        ],
      ),
    );
  }
}

