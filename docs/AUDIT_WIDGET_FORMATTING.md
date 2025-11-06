# Widget Formatting and Visual Consistency Audit

**Date:** 2025-01-XX  
**Purpose:** Identify widgets with formatting issues that don't match app theme and design system

## Executive Summary

Several widgets have formatting issues that don't align with the app's design system:
- **Kebab menu popups** (PopupMenuButton) don't match FrostedContainer styling
- **Calendar tiles** (booking cards in day view) have inconsistent styling
- **Calendar time chips** (hour labels above calendar) don't match theme typography

## Issues Identified

### 🔴 Critical: Kebab Menu (PopupMenuButton) Styling

**Location:** Multiple screens (Jobs, Contacts, Money, etc.)

**Current Issues:**
- Uses default Material popup menu styling (white background, no blur)
- Doesn't match FrostedContainer aesthetic
- No theme consistency (light/dark mode support inconsistent)
- Text and icons don't match app typography/spacing

**Screens Affected:**
- `jobs_screen.dart` - More menu (filter, search, sort, view toggle)
- `contacts_screen.dart` - More menu (filter, duplicates, segments, import, export)
- `money_screen.dart` - More menu (filter, search, etc.)
- Other screens with PopupMenuButton

**Recommendations:**

**Option 1: Custom Frosted Popup Menu (Recommended)**
```dart
// Create custom widget: lib/widgets/components/frosted_popup_menu.dart
class FrostedPopupMenu<T> extends StatelessWidget {
  final Widget child;
  final List<PopupMenuEntry<T>> items;
  final Function(T)? onSelected;
  
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<T>(
      child: child,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
      ),
      color: Theme.of(context).cardTheme.color?.withOpacity(0.95),
      elevation: 8,
      itemBuilder: (context) => items,
      onSelected: onSelected,
    );
  }
}

// Usage:
FrostedPopupMenu<String>(
  child: Icon(Icons.more_vert),
  items: [
    PopupMenuItem(
      value: 'filter',
      child: Row(
        children: [
          Icon(Icons.filter_list_outlined, size: 20),
          SizedBox(width: 12),
          Text('Filter'),
        ],
      ),
    ),
    // ... more items
  ],
  onSelected: (value) => _handleMenuAction(value),
),
```

**Option 2: Use FrostedContainer in Custom Menu**
```dart
showModalBottomSheet(
  context: context,
  backgroundColor: Colors.transparent,
  builder: (context) => FrostedContainer(
    padding: EdgeInsets.zero,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.filter_list_outlined),
          title: Text('Filter'),
          onTap: () => _showFilterSheet(context),
        ),
        // ... more items
      ],
    ),
  ),
);
```

**Implementation Priority:** HIGH
- Affects multiple screens
- High visibility (used frequently)
- Easy to implement with custom widget

---

### 🟡 Moderate: Calendar Booking Tiles

**Location:** `calendar_screen.dart` - Day view booking cards

**Current Issues:**
- Booking tiles use basic Container styling
- Don't match FrostedContainer aesthetic
- Inconsistent padding/spacing
- Text styling doesn't match theme typography
- Drag handle icon positioning could be better

**Current Code:**
```dart
// Line ~893-914 in calendar_screen.dart
Container(
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
```

**Recommendations:**

**Option 1: Use FrostedContainer (Recommended)**
```dart
FrostedContainer(
  padding: EdgeInsets.all(SwiftleadTokens.spaceS),
  margin: EdgeInsets.only(bottom: SwiftleadTokens.spaceXS),
  child: Row(
    children: [
      Icon(
        Icons.drag_handle,
        size: 16,
        color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
      ),
      SizedBox(width: SwiftleadTokens.spaceS),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_formatTime(booking.startTime)} - ${_formatTime(booking.endTime)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              booking.serviceType,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
      Icon(
        Icons.chevron_right,
        size: 16,
        color: Theme.of(context).iconTheme.color?.withOpacity(0.4),
      ),
    ],
  ),
),
```

**Option 2: Enhanced Styling with Status Indicators**
```dart
Container(
  margin: EdgeInsets.only(bottom: SwiftleadTokens.spaceXS),
  padding: EdgeInsets.all(SwiftleadTokens.spaceS),
  decoration: BoxDecoration(
    color: Theme.of(context).cardTheme.color,
    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusCard),
    border: Border.all(
      color: Theme.of(context).dividerColor.withOpacity(0.2),
      width: 1,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  ),
  child: Row(
    children: [
      // Status indicator (colored dot)
      Container(
        width: 4,
        height: 40,
        decoration: BoxDecoration(
          color: _getBookingStatusColor(booking.status),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      SizedBox(width: SwiftleadTokens.spaceS),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${_formatTime(booking.startTime)} - ${_formatTime(booking.endTime)}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              booking.serviceType,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      Icon(
        Icons.drag_handle,
        size: 18,
        color: Theme.of(context).iconTheme.color?.withOpacity(0.4),
      ),
    ],
  ),
),
```

**Implementation Priority:** MEDIUM
- Affects calendar screen usability
- Visual consistency important
- Moderate complexity

---

### 🟡 Moderate: Calendar Time Chips

**Location:** `calendar_screen.dart` - Hour labels in day view

**Current Issues:**
- Time labels use `bodySmall` typography
- Fixed width (60px) might not be optimal
- No visual separation/distinction from booking tiles
- Doesn't match app's typography scale

**Current Code:**
```dart
// Line ~832-838 in calendar_screen.dart
SizedBox(
  width: 60,
  child: Text(
    '${hour.toString().padLeft(2, '0')}:00',
    style: Theme.of(context).textTheme.bodySmall,
  ),
),
```

**Recommendations:**

**Option 1: Enhanced Typography (Recommended)**
```dart
SizedBox(
  width: 70, // Slightly wider for better readability
  child: Text(
    '${hour.toString().padLeft(2, '0')}:00',
    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontWeight: FontWeight.w500,
      color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
      letterSpacing: 0.2,
    ),
    textAlign: TextAlign.right,
  ),
),
```

**Option 2: Add Visual Separator**
```dart
Row(
  children: [
    SizedBox(
      width: 70,
      child: Text(
        '${hour.toString().padLeft(2, '0')}:00',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.8),
        ),
        textAlign: TextAlign.right,
      ),
    ),
    SizedBox(width: SwiftleadTokens.spaceM),
    Expanded(
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Theme.of(context).dividerColor.withOpacity(0.3),
      ),
    ),
  ],
),
```

**Option 3: Time Chip Style**
```dart
Container(
  width: 70,
  padding: EdgeInsets.symmetric(
    horizontal: SwiftleadTokens.spaceXS,
    vertical: SwiftleadTokens.spaceXXS,
  ),
  decoration: BoxDecoration(
    color: Theme.of(context).cardTheme.color?.withOpacity(0.5),
    borderRadius: BorderRadius.circular(SwiftleadTokens.radiusSmall),
  ),
  child: Text(
    '${hour.toString().padLeft(2, '0')}:00',
    style: Theme.of(context).textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w600,
      fontSize: 11,
    ),
    textAlign: TextAlign.center,
  ),
),
```

**Implementation Priority:** LOW
- Minor visual improvement
- Low impact on functionality
- Easy to implement

---

## Design System Alignment

### Typography Scale
- **Headlines:** `headlineSmall`, `headlineMedium`, `headlineLarge`
- **Body:** `bodySmall`, `bodyMedium`, `bodyLarge`
- **Labels:** `labelSmall`, `labelMedium`, `labelLarge`
- **Titles:** `titleSmall`, `titleMedium`, `titleLarge`

### Spacing Scale
- Use `SwiftleadTokens.spaceXXS`, `spaceXS`, `spaceS`, `spaceM`, `spaceL`, `spaceXL`
- Consistent padding: `EdgeInsets.all(SwiftleadTokens.spaceM)`

### Color System
- Use `Theme.of(context).cardTheme.color` for backgrounds
- Use `Theme.of(context).dividerColor` for borders
- Use `Theme.of(context).textTheme` for text colors
- Use opacity modifiers: `.withOpacity(0.1)`, `.withOpacity(0.2)`, etc.

### Border Radius
- Use `SwiftleadTokens.radiusSmall`, `radiusCard`, `radiusLarge`
- Consistent rounding: `BorderRadius.circular(SwiftleadTokens.radiusCard)`

## Priority Actions

### High Priority
1. **Kebab Menu Styling:** Create custom FrostedPopupMenu widget
2. **Apply to all screens:** Jobs, Contacts, Money, and other screens with PopupMenuButton

### Medium Priority
3. **Calendar Booking Tiles:** Update to use FrostedContainer or enhanced styling
4. **Add status indicators:** Visual feedback for booking status

### Low Priority
5. **Calendar Time Chips:** Enhance typography and spacing
6. **Add visual separators:** Improve time label readability

## Testing Checklist

- [ ] Kebab menus match FrostedContainer aesthetic
- [ ] Calendar booking tiles match app theme
- [ ] Calendar time chips are readable and properly styled
- [ ] All widgets respect light/dark mode
- [ ] Typography is consistent across all widgets
- [ ] Spacing follows design tokens
- [ ] Colors match theme system

## Implementation Notes

- Create reusable widgets for consistency
- Use design tokens for all spacing, colors, and typography
- Test on both light and dark themes
- Ensure accessibility (contrast ratios, touch targets)
- Consider iOS Human Interface Guidelines for popup menus

