# Changes Log

This document tracks all changes made during development sessions.

---

## Session 1: Bottom Navigation Bar Fixes

**Date:** 2025-01-15

### Change 1: Fixed Bottom Navigation Bar Overflow Issues
**Status:** ✅ COMPLETED

**Problem:** Bottom navigation bar had horizontal overflow by 2.0 pixels.

**Root Causes:**
1. Fixed height of 64px caused overflow when badges extended beyond container
2. Padding was too large (24px horizontal, 12px vertical) for 5 nav items with badges

**Solutions Applied:**

**File:** `lib/widgets/global/frosted_bottom_nav_bar.dart`

1. **Line 39:** Changed from fixed height to flexible constraints
   - **Before:** `height: 64,`
   - **After:** `constraints: const BoxConstraints(minHeight: 64),`

2. **Line 40:** Reduced padding to prevent overflow
   - **Before:** `padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),`
   - **After:** `padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),`

3. **Line 30:** Fixed bottom positioning
   - **Before:** `bottom: 16 + bottomPadding,`
   - **After:** `bottom: bottomPadding,`

**Result:** Navigation bar displays correctly at the bottom with no overflow, all 5 items fit properly, badges render correctly, and positioning respects safe area.

---

### Change 2: Fixed Drawer Menu Not Opening
**Status:** ✅ COMPLETED

**Problem:** Clicking the menu button in the app bar did nothing because nested Scaffolds caused `Scaffold.of(context)` to find the wrong Scaffold.

**Root Cause:** 
- `MainNavigation` has a `Scaffold` with the drawer
- Each screen (HomeScreen, InboxScreen, etc.) also has its own `Scaffold`
- `FrostedAppBar` used `Scaffold.of(context).openDrawer()` which found the screen's Scaffold instead of the parent's

**Solutions Applied:**

**File:** `lib/widgets/global/frosted_app_bar.dart`

1. **Lines 8-29:** Added `scaffoldKey` parameter
   - Added `final GlobalKey<ScaffoldState>? scaffoldKey;` to store the parent scaffold key
   - Modified constructor to accept optional `scaffoldKey`

2. **Lines 64-66:** Updated menu button to use scaffold key
   - **Before:** `onPressed: () => Scaffold.of(context).openDrawer()`
   - **After:** `onPressed: scaffoldKey != null ? () => scaffoldKey!.currentState?.openDrawer() : () => Scaffold.of(context).openDrawer()`

**File:** `lib/screens/main_navigation.dart`

1. **Line 22:** Made scaffold key accessible
   - **Before:** `final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();` (private in state)
   - **After:** `static final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();` (public static on MainNavigation)

2. **Line 42:** Updated reference to use static key
   - **Before:** `key: _scaffoldKey,`
   - **After:** `key: MainNavigation.scaffoldKey,`

**File:** `lib/screens/home/home_screen.dart`

1. **Line 12:** Added import
   - Added: `import '../main_navigation.dart' as main_nav;`

2. **Line 81:** Passed scaffold key to AppBar
   - Added: `scaffoldKey: main_nav.MainNavigation.scaffoldKey,`

**Result:** Menu button in app bar now correctly opens the drawer from the parent MainNavigation Scaffold, regardless of nested Scaffolds in child screens.

---

### Change 3: Fixed Drawer Navigation to Show Floating Nav Bar on All Screens
**Status:** ✅ COMPLETED

**Problem:** Drawer menu screens were pushed as new routes with `Navigator.push()`, which:
1. Lost access to the floating bottom navigation bar
2. Couldn't properly open the drawer menu button
3. Created a new navigation context separate from main screens

**Root Cause:** Using `Navigator.push()` creates new routes that sit above the MainNavigation scaffold, losing context to the drawer and bottom navigation bar.

**Solutions Applied:**

**File:** `lib/screens/main_navigation.dart`

1. **Lines 39-50:** Added drawer screen mapping
   - Created `final Map<String, Widget> _drawerScreenMap` to store all drawer screens
   - Added `Widget? _drawerScreen` state variable to track current drawer screen

2. **Lines 67-130:** Changed drawer navigation from push to state management
   - **Before:** `Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsScreen()))`
   - **After:** `setState(() => _drawerScreen = _drawerScreenMap['reports'])`
   - Removed `Navigator.push()` calls from all drawer items

3. **Line 173:** Updated body to show drawer screen when active
   - **Before:** `_screens[_currentIndex]`
   - **After:** `_drawerScreen ?? _screens[_currentIndex]`

4. **Lines 175-180:** Updated bottom nav bar to clear drawer screen on tab switch
   - Set `currentIndex` to `-1` when drawer screen is active
   - Clear `_drawerScreen = null` when switching tabs

**Result:** ✅ Drawer menu screens now display within the MainNavigation context, showing the floating bottom navigation bar on all screens and allowing the drawer menu button to work correctly from any screen. Navigating via drawer switches content but maintains the same navigation context, keeping both the drawer and bottom nav bar accessible.

**User Confirmed:** Works perfectly after hot restart! All drawer menu screens now have both the floating nav bar and working menu button.

---

### Change 4: Implemented Theme Switching Functionality
**Status:** ✅ COMPLETED

**Problem:** Theme button in Settings screen didn't work. App only had `ThemeMode.system` hardcoded with no way to switch between light, dark, or auto themes.

**Root Cause:** `SwiftleadApp` was a stateless widget with `ThemeMode.system` hardcoded, and SettingsScreen had an empty `onTap` callback for the theme setting.

**Solutions Applied:**

**File:** `lib/main.dart`

1. **Lines 20-48:** Converted SwiftleadApp to StatefulWidget
   - **Before:** `class SwiftleadApp extends StatelessWidget`
   - **After:** `class SwiftleadApp extends StatefulWidget` with `_SwiftleadAppState`
   - Added `ThemeMode _themeMode = ThemeMode.system;` state variable
   - Added `void setThemeMode(ThemeMode mode)` method to update theme
   - Changed `themeMode: ThemeMode.system` to `themeMode: _themeMode`
   - Passed `onThemeChanged: setThemeMode` and `currentThemeMode: _themeMode` to MainNavigation

**File:** `lib/screens/main_navigation.dart`

1. **Lines 20-28:** Added theme callback parameters
   - Added `final Function(ThemeMode) onThemeChanged;` parameter
   - Added `final ThemeMode currentThemeMode;` parameter
   - Updated constructor to require these parameters

2. **Lines 34-54:** Converted screen lists from `final` to `get` to support parameters
   - Changed `final List<Widget> _screens` to `List<Widget> get _screens =>`
   - Changed `final Map<String, Widget> _drawerScreenMap` to `Map<String, Widget> get _drawerScreenMap =>`
   - Passed theme parameters to SettingsScreen: `SettingsScreen(onThemeChanged: widget.onThemeChanged, currentThemeMode: widget.currentThemeMode)`

**File:** `lib/screens/settings/settings_screen.dart`

1. **Lines 13-26:** Added theme callback parameters
   - Added `final Function(ThemeMode) onThemeChanged;` parameter
   - Added `final ThemeMode currentThemeMode;` parameter
   - Added `ThemeMode get _themeMode => widget.currentThemeMode;` helper

2. **Lines 356-364:** Implemented theme switching
   - **Before:** `onTap: () {},`
   - **After:** `onTap: () => _showThemeSelector(context)`
   - Changed trailing text from `'Auto'` to `_getThemeModeLabel(_themeMode)`

3. **Lines 522-531:** Added theme label helper
   - `String _getThemeModeLabel(ThemeMode mode)` returns 'Light', 'Dark', or 'Auto'

4. **Lines 533-578:** Added theme selector dialog
   - `void _showThemeSelector(BuildContext context)` shows AlertDialog with RadioListTiles
   - Options: 'Auto (System)', 'Light', 'Dark'
   - Calls `widget.onThemeChanged(value)` when selection changes
   - Closes dialog after selection

**Result:** ✅ Theme switching now works! Users can tap the Theme setting in Settings to choose between Auto (follows system), Light, or Dark themes. The selected theme immediately applies across the entire app.

**User Confirmed:** Theme switching works perfectly!

---

### Change 5: Fixed TrendTile Widget Formatting Issues
**Status:** ✅ COMPLETED

**Problem:** TrendTile widgets had weird formatting/layout issues due to:
1. Column without `mainAxisSize` constraint causing vertical expansion
2. Sparkline without width constraint
3. Text overflow not being handled
4. Row inside trend indicator without size constraint

**Root Cause:** Missing layout constraints on multiple nested widgets causing unpredictable sizing behavior.

**Solutions Applied:**

**File:** `lib/widgets/components/trend_tile.dart`

1. **Line 44:** Added mainAxisSize to Column
   - **Before:** `child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [`
   - **After:** `child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [`

2. **Lines 49-50:** Added text overflow handling to label
   - Added: `overflow: TextOverflow.ellipsis, maxLines: 1,`

3. **Lines 58-59:** Added text overflow handling to value
   - Added: `overflow: TextOverflow.ellipsis, maxLines: 1,`

4. **Line 65:** Added width constraint to sparkline
   - **Before:** `SizedBox(height: 20, child: CustomPaint(`
   - **After:** `SizedBox(height: 20, width: double.infinity, child: CustomPaint(`

5. **Line 79:** Added mainAxisSize to Row inside trend indicator
   - **Before:** `Row(children: [`
   - **After:** `Row(mainAxisSize: MainAxisSize.min, children: [`

**Result:** ✅ TrendTile widgets now have proper constraints preventing unpredictable layout, text properly truncates with ellipsis, sparkline fills available width, and overall layout is consistent across all metric cards.

---

### Change 6: Fixed Metrics Row Layout to 2x2 Grid on Mobile
**Status:** ✅ COMPLETED

**Problem:** TrendTile metrics were cramped with text showing "..." ellipsis because 4 tiles were trying to fit in a single horizontal row on mobile screens, leaving too little space per tile.

**Root Cause:** Using a single `Row` with 4 `Expanded` TrendTiles in a horizontal layout on small mobile screens caused severe space constraints and text overflow.

**Solutions Applied:**

**File:** `lib/screens/home/home_screen.dart`

1. **Lines 213-293:** Changed from horizontal Row to 2x2 Column layout
   - **Before:** `Row(children: [4 Expanded TrendTiles with 8px spacing])`
   - **After:** `Column(children: [Row of 2 tiles, SizedBox(height: 8), Row of 2 tiles])`
   - Each row now has only 2 tiles with 8px spacing between them
   - Added 8px vertical spacing between the two rows

2. **Lines 111-136:** Updated loading skeleton to match 2x2 grid
   - **Before:** Single Row with 4 skeleton loaders
   - **After:** Column with 2 Rows, each containing 2 skeleton loaders
   - Maintains consistent loading state with actual layout

**Result:** ✅ Metrics now display in a 2x2 grid on mobile, giving each tile proper space for labels, values, sparklines, and trend indicators without text truncation. Layout matches specifications for mobile responsive behavior.

**User Confirmed:** Works perfectly!

---

### Change 7: Swapped Home Screen Layout to Avoid Color Clash
**Status:** ✅ COMPLETED

**Problem:** Green revenue chart directly above the bottom navigation bar created a visual color clash.

**Root Cause:** ChartCard with green visualization colors was positioned too close to the navigation bar, creating visual interference.

**Solutions Applied:**

**File:** `lib/screens/home/home_screen.dart`

1. **Lines 192-220:** Reordered home screen content sections
   - **Before:** MetricsRow → ChartCard → SmartTileGrid → QuickActionChips → AIInsightBanner → ActivityFeed
   - **After:** MetricsRow → SmartTileGrid → ChartCard → QuickActionChips → AIInsightBanner → ActivityFeed
   - Moved ChartCard below SmartTileGrid to create visual separation from navigation bar

2. **Lines 137-174:** Updated loading skeleton order to match
   - **Before:** Metrics skeleton → Chart skeleton → Tile grid skeleton
   - **After:** Metrics skeleton → Tile grid skeleton → Chart skeleton
   - Maintains consistent loading state with actual layout

**Result:** ✅ Green chart is now positioned further down the screen with better visual separation from the navigation bar, improving overall visual hierarchy and reducing color clashes.

**User Confirmed:** Works perfectly!

---

### Change 8: Removed Redundant FABs from Main Tab Screens
**Status:** ✅ COMPLETED

**Problem:** Floating action buttons (FABs) were duplicating functionality already available in the app bar actions, causing UI clutter and navigation bar overlap issues.

**Root Cause:** Main tab screens and drawer screens had FABs that performed the same actions as the existing app bar icon buttons.

**Solutions Applied:**

**File:** `lib/screens/inbox/inbox_screen.dart`
1. **Lines 155-194:** Removed FAB and `_buildFAB()` method
   - FAB "New Chat" was redundant with AppBar `Icons.edit` button

**File:** `lib/screens/jobs/jobs_screen.dart`
1. **Lines 147-157:** Removed FAB
   - FAB "New Job" was redundant with AppBar `Icons.add` button

**File:** `lib/screens/calendar/calendar_screen.dart`
1. **Lines 94-109:** Removed FAB
   - FAB "Book Slot" was redundant with AppBar `Icons.add` button

**File:** `lib/screens/contacts/contacts_screen.dart`
1. **Lines 60-64:** Removed FAB
   - FAB "Add Contact" was redundant with AppBar `Icons.add` button

**File:** `lib/screens/marketing/marketing_screen.dart`
1. **Lines 57-61:** Removed FAB
   - FAB "Create Campaign" was redundant with AppBar `Icons.add` button

**Note:** MoneyScreen FAB was kept because it provides tab-specific functionality (Invoice/Quote/Payment) that changes based on the selected tab, not available in the app bar.

**Result:** ✅ Cleaner UI with no redundant FABs across all main screens. All functionality remains accessible via app bar actions. No overlap issues with floating bottom navigation bar.

---

### Change 9: Fixed Balance Header Formatting in Money Screen Dashboard
**Status:** ✅ COMPLETED

**Problem:** Balance header in Money screen dashboard tab had weird formatting with numbers hidden due to layout constraints. Balance amount, percentage badge, and "Connected to Stripe" badge were all competing for horizontal space.

**Root Cause:** Complex nested layout with Row containing Expanded columns and badges side-by-side caused the balance amount to be squeezed and potentially hidden when badges were present.

**Solutions Applied:**

**File:** `lib/screens/money/money_screen.dart`

1. **Lines 391-459:** Simplified layout structure
   - **Before:** Row containing Expanded Column (with nested Row/Wrap) and badge side-by-side
   - **After:** Single Column with Wrap containing all elements (balance, percentage badge, Stripe badge)
   - Removed complex nested Row with Expanded and crossAxisAlignment
   - Changed from nested Row/Flexible layout to single Wrap layout

2. **Line 397:** Used Wrap instead of Row
   - **Before:** `Row(children: [...])`
   - **After:** `Wrap(children: [...])`
   - Allows all elements to flow naturally and wrap to next line if needed

3. **Line 398:** Added WrapCrossAlignment
   - Added: `crossAxisAlignment: WrapCrossAlignment.center,`

4. **Lines 400-457:** All three elements in one Wrap
   - Balance amount Text widget
   - Percentage trend badge Container
   - Stripe connection badge Container

**Result:** ✅ Balance header now displays balance amount, percentage badge, and Stripe badge properly. Elements wrap to next line if needed, preventing numbers from being hidden or cut off. Clean, responsive layout.

**User Confirmed:** Works perfectly!

---

### Change 10: Moved Percentage Badge to Top Right Corner of Balance Header
**Status:** ✅ COMPLETED

**Problem:** Percentage trend badge was mixed in with balance amount and Stripe badge in a Wrap, creating a cluttered layout.

**Root Cause:** All three elements were in the same Wrap, competing for horizontal space and wrapping unpredictably.

**Solutions Applied:**

**File:** `lib/screens/money/money_screen.dart`

1. **Lines 388-489:** Restructured layout using Stack
   - **Before:** Column with Wrap containing all elements
   - **After:** Stack with Column for main content and Positioned for percentage badge
   - Changed from single Wrap layout to Stack with Positioned widget

2. **Lines 390-455:** Main content Column
   - Contains: label, balance amount, Stripe badge, and quick action buttons
   - Vertical flow without percentage badge crowding

3. **Lines 456-485:** Positioned percentage badge
   - **Position:** `top: 0, right: 0`
   - Absolute positioning in top-right corner of the tile

**Result:** ✅ Clean, professional layout with percentage badge elegantly positioned in top-right corner. Balance amount has full width, and all elements are properly spaced.

**User Confirmed:** Works perfectly!

---

### Change 11: Replaced Dollar Sign Icon with Pound Symbol
**Status:** ✅ COMPLETED

**Problem:** Dollar sign icon (`Icons.attach_money`) was displayed for Money tab instead of pound symbol (£) for UK currency.

**Root Cause:** Money tab was using `attach_money` icon which displays a $ symbol, not appropriate for UK-based currency.

**Solutions Applied:**

**File:** `lib/widgets/global/frosted_bottom_nav_bar.dart`

1. **Lines 123-141:** Made NavItem support custom text icons
   - Made `icon` and `activeIcon` optional (`IconData?`)
   - Added `customIcon` and `customActiveIcon` optional String fields
   - Added helper properties: `hasCustomIcon`, `hasIcon`

2. **Lines 76-123:** Updated rendering logic to support both icon types
   - Check `item.hasCustomIcon` to render Text widget with custom symbol
   - Text styling matches icon colors (active/inactive states)
   - Both Icon and Text wrapped in Badge when badgeCount is present

**File:** `lib/screens/main_navigation.dart`

1. **Lines 210-214:** Changed Money tab to use £ symbol
   - **Before:** `icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet`
   - **After:** `customIcon: '£', customActiveIcon: '£'`

**File:** `lib/screens/home/home_screen.dart`

1. **Lines 537-622:** Made _SmartTile support custom text icons
   - Made `icon` optional (`IconData?`)
   - Added `customIcon` optional String field
   - Updated rendering to show Text widget when customIcon is provided

2. **Lines 387, 410-414:** Changed widgets to use £ symbol
   - SmartTile Money tile: `customIcon: '£'`
   - QuickActionChip "Send Payment": `customIcon: '£'`
   - Activity feed keeps wallet icon for payment events

**File:** `lib/widgets/components/quick_action_chip.dart`

1. **Lines 7-20:** Made icon optional, added custom icon support
   - Changed `icon` from required to optional `IconData?`
   - Added `customIcon` optional String field

2. **Lines 49-62:** Updated rendering logic
   - Check for `customIcon` and render Text if provided
   - Fall back to Icon widget if customIcon is null

**Files:** Removed redundant wallet icons before £ price displays in:
- `lib/screens/calendar/service_catalog_screen.dart` (removed icon before price)
- `lib/screens/calendar/booking_detail_screen.dart` (removed icon before price)
- `lib/widgets/components/booking_offer_card.dart` (removed icon before price)

**Result:** ✅ Money tab, SmartTiles, QuickActionChips, and all price displays now use £ symbol. No redundant wallet icons. Navigation bar and all currency widgets support custom text symbols.

**User Confirmed:** Works perfectly!

---

### Change 12: Fixed Calendar App Bar Overflow and Icon Sizing Issues
**Status:** ✅ COMPLETED

**Problem:** 
1. Calendar app bar had overflow issues due to SegmentedButton taking too much horizontal space
2. Nav bar icons appeared different sizes (Calendar icon looked bigger than others)

**Root Cause:** 
1. SegmentedButton with 3 segments (Day/Week/Month) plus 3 IconButtons in app bar exceeded available width
2. £ custom icon text needed height constraint to match Icon widget size

**Solutions Applied:**

**File:** `lib/screens/calendar/calendar_screen.dart`

1. **Lines 52-78:** Removed SegmentedButton from app bar actions
   - **Before:** AppBar had SegmentedButton + 3 IconButtons causing overflow
   - **After:** AppBar has only 3 IconButtons (Today, Search, Add)

2. **Lines 140-184:** Moved SegmentedButton to calendar header
   - **Before:** `_buildCalendarHeader()` returned Row with navigation controls
   - **After:** Returns Column with SegmentedButton first, then Row with navigation
   - Added 16px spacing between segments and navigation

**File:** `lib/widgets/global/frosted_bottom_nav_bar.dart`

1. **Lines 85, 109:** Added height constraint to custom icon Text widgets
   - Added: `height: 1.0` to TextStyle
   - Prevents text from having extra line height making it appear smaller than icons

**Result:** ✅ Calendar app bar no longer overflows. Nav bar icons now have consistent sizing. SegmentedButton positioned in calendar header for better UX.

**User Confirmed:** Works perfectly!

---

### Change 13: Fixed Reports & Analytics KPI Layout to 2x2 Grid
**Status:** ✅ COMPLETED

**Problem:** Reports & Analytics KPI summary row had cramped TrendTiles with text overflow, same issue as Home screen had previously.

**Root Cause:** Single `Row` with 4 `Expanded` TrendTiles in horizontal layout causes severe space constraints on mobile screens.

**Solutions Applied:**

**File:** `lib/screens/reports/reports_screen.dart`

1. **Lines 301-357:** Changed from horizontal Row to 2x2 Column layout
   - **Before:** `Row(children: [4 Expanded TrendTiles with 8px spacing])`
   - **After:** `Column(children: [Row of 2 tiles, SizedBox(height: 8), Row of 2 tiles])`
   - Each row now has only 2 tiles (Revenue/Jobs on top, Clients/Conversion on bottom)
   - Added 8px vertical spacing between the two rows

2. **Lines 77-118:** Updated loading skeleton to match 2x2 grid
   - **Before:** Single Row with 4 skeleton loaders
   - **After:** Column with 2 Rows, each containing 2 skeleton loaders
   - Maintains consistent loading state with actual layout

**Result:** ✅ KPI metrics now display in a 2x2 grid, giving each tile proper space for labels, values, sparklines, and trend indicators without text truncation. Layout matches Home screen fix and mobile responsive specifications.

**User Confirmed:** Works perfectly!

---

### Change 14: Replaced Money Screen FABs with Dropdown Menu in App Bar
**Status:** ✅ COMPLETED

**Problem:** Multiple FABs on Money screen tabs were creating clutter and conflicting with the floating bottom navigation bar.

**Root Cause:** Each tab (Dashboard, Invoices, Quotes) had its own FAB with different actions, which was inconsistent and space-consuming.

**Solutions Applied:**

**File:** `lib/screens/money/money_screen.dart`

1. **Lines 93-167:** Removed floatingActionButton and _buildFloatingActionButton method
   - **Before:** Different FABs shown based on selected tab (Payment, Invoice, Quote)
   - **After:** No FAB, replaced with unified menu

2. **Lines 114-161:** Added PopupMenuButton in app bar actions
   - **Location:** Rightmost position after Search, Export, and Date Range buttons
   - **Icon:** `Icons.add` (plus icon)
   - **Menu Items:**
     - Add Payment (payment icon) → `_handleAddPayment()`
     - Create Invoice (receipt icon) → `_handleAddInvoice()` → Opens CreateEditInvoiceScreen
     - Create Quote (description icon) → `_handleAddQuote()` → Opens CreateEditQuoteScreen

3. **Lines 170-188:** Added handler methods
   - `_handleAddPayment()`: Placeholder for payment functionality
   - `_handleAddInvoice()`: Navigates to CreateEditInvoiceScreen
   - `_handleAddQuote()`: Navigates to CreateEditQuoteScreen

**Result:** ✅ All Money screen FABs removed. Single unified "+" menu in app bar provides all actions across all tabs. Cleaner UI, no FAB overlap with navigation bar, consistent with other main screens.

**User Confirmed:** Works perfectly!

---

### Change 15: Fixed Create Quote Navigation in Money Screen Menu
**Status:** ✅ COMPLETED

**Problem:** "Create Quote" button in Money screen dropdown menu was navigating to the quotes list screen instead of the create/edit quote screen.

**Root Cause:** Import was missing and handler was navigating to `QuotesScreen` instead of `CreateEditQuoteScreen`.

**Solutions Applied:**

**File:** `lib/screens/money/money_screen.dart`

1. **Line 11:** Added import for `CreateEditQuoteScreen`
   - Added: `import '../quotes/create_edit_quote_screen.dart';`

2. **Lines 184-189:** Updated `_handleAddQuote` method
   - **Before:** `Navigator.push(builder: (context) => const QuotesScreen())`
   - **After:** `Navigator.push(builder: (context) => const CreateEditQuoteScreen())`

**Result:** ✅ Create Quote button now correctly opens the CreateEditQuoteScreen for immediate quote creation.

**User Confirmed:** Works perfectly!

---

### Change 16: Removed Duplicate App Bar from Quotes Tab in Money Screen
**Status:** ✅ COMPLETED

**Problem:** Quotes tab on Money screen had duplicate app bar with drawer menu, filters, and plus button because it was using the full QuotesScreen widget that has its own Scaffold and AppBar.

**Root Cause:** Using `const QuotesScreen()` in the Money screen IndexedStack embedded a complete Scaffold within another Scaffold, creating nested app bars and UI duplication.

**Solutions Applied:**

**File:** `lib/screens/money/money_screen.dart`

1. **Line 12:** Added import for `quote_detail_screen.dart`
   - Added: `import '../quotes/quote_detail_screen.dart';`

2. **Line 254:** Changed tab content from full widget to custom method
   - **Before:** `const QuotesScreen()`
   - **After:** `_buildQuotesTab()`

3. **Lines 401-463:** Added `_buildQuotesTab()` method
   - Returns a RefreshIndicator with ListView (no Scaffold/AppBar)
   - Includes filter chips and ListView.builder for quotes list
   - Proper padding for bottom nav bar spacing

4. **Lines 470-487:** Added helper methods for quote data
   - `_getQuoteClientName()`, `_getQuoteService()`, `_getQuoteAmount()`, `_getQuoteStatus()`

5. **Lines 870-988:** Added `_QuoteCard` widget class
   - Displays quote number, client, service, amount, status, and expiry
   - Handles navigation to QuoteDetailScreen on tap
   - Color-coded status badges

**Result:** ✅ Quotes tab no longer has duplicate app bar. Tab content is now a simple list that shares the Money screen's app bar. Cleaner UI without nested Scaffolds.

**User Confirmed:** Works perfectly!

---

### Change 17: Made Quote Filter Chips Functional in Money Screen
**Status:** ✅ COMPLETED

**Problem:** Quote filter chips on the Quotes tab had no functionality - they were just dummy buttons with empty `onTap` callbacks and `isSelected: false`, unlike the working invoice filter chips.

**Root Cause:** Missing state variables for quote filter tracking and selection handling.

**Solutions Applied:**

**File:** `lib/screens/money/money_screen.dart`

1. **Lines 33-34:** Added quote filter state variables
   - Added: `String _selectedQuoteFilter = 'All';`
   - Added: `final List<String> _quoteFilters = ['All', 'Draft', 'Sent', 'Viewed', 'Accepted', 'Declined', 'Expired'];`

2. **Lines 420-432:** Updated filter chip generation
   - **Before:** Hardcoded filter list, `isSelected: false`, `onTap: () {}`
   - **After:** Uses `_quoteFilters`, `isSelected: _selectedQuoteFilter == filter`, `onTap: () { setState(() => _selectedQuoteFilter = filter); }`

**Result:** ✅ Quote filter chips now behave exactly like invoice filter chips - they update state when tapped and show visual feedback for the selected filter.

**User Confirmed:** Works perfectly!

---

### Change 18: Implemented Actual Filtering for Quote Chips in Money Screen
**Status:** ✅ COMPLETED

**Problem:** Quote filter chips updated visual state but didn't actually filter the displayed quotes. User couldn't see the filtering working because the list remained unchanged.

**Root Cause:** Missing actual data filtering logic - only state update was implemented, but the ListView.builder still showed all quotes regardless of filter selection.

**Solutions Applied:**

**File:** `lib/screens/money/money_screen.dart`

1. **Lines 92-107:** Added `_getFilteredQuotes()` method
   - Generates list of 8 mock quotes with status, client, service, amount, etc.
   - Returns all quotes if filter is 'All'
   - Filters by selected quote status otherwise
   - Each quote includes original index for proper detail screen navigation

2. **Lines 454-490:** Updated ListView.builder to use filtered data
   - **Before:** Hardcoded `itemCount: 8` and used index directly
   - **After:** `itemCount: _getFilteredQuotes().length` and uses quote data from filtered list
   - Added empty state with `EmptyStateCard` when no quotes match filter

**Result:** ✅ Quote filter chips now actually filter the displayed quotes. Users can see different quotes when selecting Draft, Sent, Accepted, etc., and empty state appears when no quotes match the filter.

**User Confirmed:** Works perfectly!

---

### Change 19: Fixed Money Screen TrendTiles Layout to 2x2 Grid
**Status:** ✅ COMPLETED

**Problem:** TrendTiles in Money screen dashboard had cramped layout with text overflow, same issue as on Home and Reports screens.

**Root Cause:** Using a single `Row` with 4 `Expanded` TrendTiles in horizontal layout causes severe space constraints on mobile screens.

**Solutions Applied:**

**File:** `lib/screens/money/money_screen.dart`

1. **Lines 626-678:** Changed from horizontal Row to 2x2 Column layout
   - **Before:** `Row(children: [4 Expanded TrendTiles with 8px spacing])`
   - **After:** `Column(children: [Row of 2 tiles, SizedBox(height: 8), Row of 2 tiles])`
   - Each row now has only 2 tiles (Outstanding/Paid This Month on top, Pending/Overdue on bottom)
   - Added 8px vertical spacing between the two rows

2. **Lines 227-256:** Updated loading skeleton to match 2x2 grid
   - **Before:** Single Row with 4 skeleton loaders
   - **After:** Column with 2 Rows, each containing 2 skeleton loaders
   - Maintains consistent loading state with actual layout

**Result:** ✅ Money screen metrics now display in a 2x2 grid, giving each tile proper space for labels, values, sparklines, and trend indicators without text truncation. Consistent with Home and Reports screen layouts.

**User Confirmed:** Works perfectly!

---

### Change 21: Wired NotificationsScreen, PaymentDetailScreen, and BookingDetailScreen into Navigation
**Status:** ✅ COMPLETED

**Problem:** Several screens (NotificationsScreen, PaymentDetailScreen, BookingDetailScreen) existed in the codebase but were not wired into navigation flows, making them inaccessible to users.

**Root Cause:** These detail/secondary screens were created but not connected to their parent screens or navigation entry points.

**Solutions Applied:**

**File:** `lib/screens/settings/settings_screen.dart`

1. **Line 9:** Added import for `NotificationsScreen`
2. **Lines 193-204:** Wired "Notification Settings" item in Account section to navigate to `NotificationsScreen`
   - **Before:** `onTap: () {}`
   - **After:** Opens NotificationsScreen via Navigator.push

**File:** `lib/screens/money/money_screen.dart`

1. **Line 15:** Added import for `PaymentDetailScreen`
2. **Lines 779-821:** Updated `_buildPaymentList()` to show payment cards instead of empty state
   - **Before:** Always returned `EmptyStateCard`
   - **After:** Returns `EmptyStateCard` only if `_payments.isEmpty`, otherwise shows `ListView.builder` with `_PaymentCard` widgets
3. **Lines 806-816:** Each payment card navigates to `PaymentDetailScreen` on tap
4. **Lines 824-929:** Added `_PaymentCard` widget class
   - Displays payment number, client, date, method, amount, and status badge
   - Color-coded status (completed/pending/failed)
   - Handles navigation to `PaymentDetailScreen`

**File:** `lib/screens/calendar/calendar_screen.dart`

1. **Line 7:** Added import for `BookingDetailScreen`
2. **Lines 278-323:** Updated `_buildBookingList()` to show booking cards instead of empty state
   - **Before:** Always returned `EmptyStateCard`
   - **After:** Returns `EmptyStateCard` only if `_allBookings.isEmpty`, otherwise shows `Column` with `BookingCard` widgets
3. **Lines 289-320:** Changed from nested `ListView.builder` to `Column` with `List.generate` to fix overflow
4. **Lines 304-314:** Each booking card navigates to `BookingDetailScreen` on tap

**Result:** ✅ All screens are now accessible. Users can navigate to NotificationsScreen from Settings, PaymentDetailScreen from Money/Payments tab, and BookingDetailScreen from Calendar booking list. Mock data properly populates the lists when available.

**User Confirmed:** Works perfectly!

---

### Change 22: Fixed BookingCard Overflow and Added On My Way Buttons
**Status:** ✅ COMPLETED

**Problem:** 
1. BookingCard had 60 pixel horizontal overflow due to three wide TextButton.icon buttons (Message, Reschedule, Complete)
2. Text wrapping to two lines when buttons were Expanded
3. "On My Way" functionality was only accessible deep in BookingDetailScreen, not visible enough for important quick action

**Root Cause:** 
1. Row with three TextButton.icon buttons exceeded available width on mobile screens
2. Labels were too long ("Reschedule", "Complete") to fit in single line with icons
3. "On My Way" button was buried in mid-list on detail screen

**Solutions Applied:**

**File:** `lib/widgets/components/booking_card.dart`

1. **Line 70:** Added `mainAxisSize: MainAxisSize.min` to main Column
2. **Lines 192-218:** Fixed bottom quick actions row
   - **Before:** Simple Row with three TextButton.icon buttons
   - **After:** Row with `mainAxisSize: MainAxisSize.min`, each button wrapped in `Expanded`
   - Changed "Reschedule" to "Move", shortened labels to fit better
   - Icons remain size 18 for good visibility

**File:** `lib/screens/calendar/calendar_screen.dart`

1. **Lines 2-3, 6, 13:** Added imports for FrostedContainer, PrimaryButton, OnMyWaySheet
2. **Lines 137-139:** Added "On My Way" button between calendar and booking list
   - Shows only when `_hasConfirmedBookingsToday()` returns true
   - Prominent primary button with directions_car icon
3. **Lines 325-337:** Added `_hasConfirmedBookingsToday()` helper method
   - Checks if any bookings exist for today with confirmed status
   - Compares date-only portions to avoid time conflicts
4. **Lines 339-355:** Added `_buildOnMyWayButton()` method
   - Returns FrostedContainer with PrimaryButton
   - Opens OnMyWaySheet on tap

**File:** `lib/screens/home/home_screen.dart`

1. **Lines 404-409:** Added "On My Way" QuickActionChip as first action
   - Placed before "Add Job" as requested
   - Uses directions_car icon, labels as "On My Way"
   - Currently placeholder tap handler
2. **Lines 193-207:** Reordered Home screen layout to avoid teal color clash
   - **Before:** Metrics → Chart → Tiles → QuickActions (caused teal Tile Grid to clash with nav bar)
   - **After:** Metrics → Tiles → Chart → QuickActions (proper separation from floating nav bar)
   - Maintains visual hierarchy while avoiding color conflicts with bottom navigation

**Result:** ✅ BookingCard no longer overflows. Shortened button labels fit properly with icons on single line. "On My Way" is now visible in two strategic locations: Home screen quick actions (prominently placed after trend tiles) and Calendar screen (when applicable), making the critical action easily accessible.

**User Confirmed:** Works perfectly!

---

### Change 23: Fixed MessageComposerBar Layout - Stacked Action Buttons Above Input
**Status:** ✅ COMPLETED

**Problem:** The InboxThreadScreen message composer had all action buttons (attach, payment, templates, AI) in the same row as the text input, causing everything to be squashed up together and the input field to be too cramped.

**Root Cause:** The MessageComposerBar had all elements in a single Row, placing 4 icon buttons, TextField, and send button all on one line, making the input field very narrow and cluttered.

**Solutions Applied:**

**File:** `lib/widgets/components/message_composer_bar.dart`

1. **Lines 79-117:** Created separate action buttons row
   - **Before:** All buttons and TextField in a single Row
   - **After:** Four action buttons (attach, payment, templates, AI) in their own Row at the top
   - These are now stacked vertically above the input

2. **Line 117:** Added spacing between rows
   - Added: `const SizedBox(height: SwiftleadTokens.spaceS)` between action buttons and text input

3. **Lines 118-184:** Created separate text input row
   - **Before:** TextField cramped with 4 buttons before it
   - **After:** TextField and send button in their own Row
   - TextField now has `Expanded` and full width

**Result:** ✅ MessageComposerBar now has clean vertical layout: action buttons on top row, text input with send button on bottom row. No more squashing, proper spacing, and better usability.

**User Confirmed:** Works perfectly!

---

### Change 24: Moved Internal Notes from FAB to App Bar Menu on InboxThreadScreen
**Status:** ✅ COMPLETED

**Problem:** The InternalNotesButton FAB was floating at the bottom of InboxThreadScreen, potentially overlapping with the message composer and taking up screen space.

**Root Cause:** The InternalNotesButton was implemented as a FloatingActionButton, which is redundant when there's already a message composer taking up the bottom space.

**Solutions Applied:**

**File:** `lib/screens/inbox/inbox_thread_screen.dart`

1. **Line 96-127:** Added "Internal Notes" to PopupMenuButton
   - Added `PopupMenuItem` with value `'internal_notes'`
   - Uses `Icons.note_add` icon
   - Shows note count badge when `_noteCount > 0`
   - Badge styled with teal background, white text
   - Placed between "Search in chat" and "Mute" menu items

2. **Lines 54-73:** Added handler for internal_notes case
   - Added `case 'internal_notes':` to switch statement
   - Currently placeholder for future implementation

3. **Removed:** FloatingActionButton and InternalNotesButton import
   - Removed `floatingActionButton: InternalNotesButton(...)` property
   - Removed import for `internal_notes_button.dart`
   - Cleaner, less cluttered bottom area

**Result:** ✅ Internal Notes functionality now accessible via app bar menu (three-dot button), with note count badge displayed in the menu item. Removed floating FAB eliminates potential overlap and provides cleaner UI.

**User Confirmed:** Works perfectly!

---

### Change 25: Centered Action Icons in MessageComposerBar
**Status:** ✅ COMPLETED

**Problem:** The action buttons (attach, payment, templates, AI) in MessageComposerBar were left-aligned, looking asymmetrical.

**Root Cause:** The Row containing the action buttons didn't have `mainAxisAlignment` specified, defaulting to `MainAxisAlignment.start`.

**Solutions Applied:**

**File:** `lib/widgets/components/message_composer_bar.dart`

1. **Line 81:** Added `mainAxisAlignment: MainAxisAlignment.center` to Row
   - Centers the four action icon buttons horizontally
   - Creates more balanced, symmetrical visual appearance

**Result:** ✅ Action icons in MessageComposerBar are now centered above the text input field, creating better visual balance and a more polished look.

**User Confirmed:** Works perfectly!

---

*Next changes will be logged below as we continue development.*

