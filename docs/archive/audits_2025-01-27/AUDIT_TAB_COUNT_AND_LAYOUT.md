# Tab Count and Layout Audit Report

**Date:** 2025-01-XX  
**Purpose:** Identify screens with too many tabs and provide layout recommendations

## Executive Summary

Several screens use `SegmentedControl` with 5+ tabs, which can cause:
- Poor mobile UX (tabs too small, hard to tap)
- Visual clutter
- Reduced usability

**Recommendation:** Reduce tabs to 3-4 maximum, use progressive disclosure (secondary tabs in content area), or restructure navigation.

## Screens with Tab Issues

### 🔴 Critical: Money Screen (5 Tabs)

**Current Tabs:**
1. Dashboard
2. Invoices
3. Quotes
4. Payments
5. Deposits

**Issues:**
- 5 tabs is too many for mobile screens
- Tabs are cramped on smaller devices
- Visual hierarchy is unclear
- Primary actions (Invoices, Payments) are mixed with secondary (Deposits)

**Recommendations:**

**Option 1: Consolidate to 3 Primary Tabs (Recommended)**
- **Dashboard** (overview, metrics, charts)
- **Invoices** (combine Quotes into Invoices with filter)
- **Payments** (combine Deposits into Payments with filter)

**Option 2: Use Primary + Secondary Navigation**
- **Primary Tabs:** Dashboard | Invoices | Payments
- **Secondary Navigation:** Within Invoices tab, show "Invoices" and "Quotes" as sub-tabs or filter chips
- **Deposits:** Move to a secondary section within Payments tab or as a separate screen accessible from Dashboard

**Option 3: Bottom Navigation Style**
- Keep Dashboard as main screen
- Move Invoices, Quotes, Payments, Deposits to separate screens accessible via bottom nav or quick actions

**Implementation:**
```dart
// Recommended: 3 primary tabs
SegmentedControl(
  segments: const ['Dashboard', 'Invoices', 'Payments'],
  selectedIndex: _selectedTab,
  onSelectionChanged: (index) {
    setState(() => _selectedTab = index);
  },
),

// Within Invoices tab, show sub-navigation:
if (_selectedTab == 1) // Invoices tab
  Row(
    children: [
      FilterChip(
        label: Text('Invoices'),
        selected: _invoiceViewMode == 'invoices',
        onSelected: (_) => setState(() => _invoiceViewMode = 'invoices'),
      ),
      FilterChip(
        label: Text('Quotes'),
        selected: _invoiceViewMode == 'quotes',
        onSelected: (_) => setState(() => _invoiceViewMode = 'quotes'),
      ),
    ],
  ),
```

---

### 🟡 Moderate: Reviews Screen (5 Tabs)

**Current Tabs:**
1. Dashboard
2. Requests
3. All Reviews
4. Analytics
5. NPS

**Issues:**
- 5 tabs is manageable but could be better
- Analytics and NPS are secondary features

**Recommendations:**

**Option 1: Consolidate to 3 Primary Tabs (Recommended)**
- **Dashboard** (overview, recent reviews, quick stats)
- **Reviews** (combine "All Reviews" and "Requests" with filter/toggle)
- **Analytics** (combine Analytics and NPS into one comprehensive analytics view)

**Option 2: Use Progressive Disclosure**
- **Primary Tabs:** Dashboard | Reviews | Analytics
- **Secondary:** Within Reviews tab, show "All Reviews" and "Requests" as filter chips
- **NPS:** Move to Analytics tab as a section or expandable card

**Implementation:**
```dart
SegmentedControl(
  segments: const ['Dashboard', 'Reviews', 'Analytics'],
  selectedIndex: _selectedTab,
),

// Within Reviews tab:
if (_selectedTab == 1)
  Row(
    children: [
      FilterChip(
        label: Text('All Reviews'),
        selected: _reviewFilter == 'all',
        onSelected: (_) => setState(() => _reviewFilter = 'all'),
      ),
      FilterChip(
        label: Text('Requests'),
        selected: _reviewFilter == 'requests',
        onSelected: (_) => setState(() => _reviewFilter = 'requests'),
      ),
    ],
  ),
```

---

### 🟢 Acceptable: Jobs Screen (4 Tabs + View Toggle)

**Current Navigation:**
- **Status Tabs:** All | Active | Completed | Cancelled (4 tabs)
- **View Toggle:** List | Kanban (separate control)

**Status:**
- ✅ 4 tabs is acceptable
- ✅ View toggle is separate (good UX)
- ✅ Tabs use badge counts (good visual feedback)

**Recommendation:**
- **KEEP AS IS** - This is a good pattern
- Consider adding a "More" dropdown if more status filters are needed in the future

---

### 🟢 Acceptable: Calendar Screen

**Current Navigation:**
- **View Toggle:** Day | Week | Month (3 options, good)
- No tab issues

**Status:**
- ✅ 3 views is perfect
- ✅ Uses toggle/segmented control appropriately

**Recommendation:**
- **KEEP AS IS**

---

## General Recommendations

### Tab Count Guidelines

| Tab Count | Status | Recommendation |
|-----------|--------|----------------|
| **2-3 tabs** | ✅ Excellent | Perfect for mobile, easy to navigate |
| **4 tabs** | ✅ Good | Acceptable, use badge counts for clarity |
| **5 tabs** | ⚠️ Warning | Consider consolidation or progressive disclosure |
| **6+ tabs** | ❌ Poor | Must restructure - too many for mobile |

### Best Practices

1. **Primary Actions First:** Most frequently used tabs should be leftmost
2. **Progressive Disclosure:** Use secondary navigation (filter chips, sub-tabs) within primary tabs
3. **Visual Hierarchy:** Use badge counts, icons, or different styling to indicate importance
4. **Consolidation:** Combine related features into single tabs with filters
5. **Alternative Navigation:** Consider bottom navigation, drawer menu, or separate screens for secondary features

### Implementation Patterns

**Pattern 1: Primary + Filter Chips (Recommended)**
```dart
// Primary tabs (3 max)
SegmentedControl(
  segments: ['Dashboard', 'Invoices', 'Payments'],
),

// Secondary filters within tab
if (_selectedTab == 1)
  Wrap(
    spacing: 8,
    children: [
      FilterChip(label: Text('All'), selected: _filter == 'all'),
      FilterChip(label: Text('Quotes'), selected: _filter == 'quotes'),
      FilterChip(label: Text('Overdue'), selected: _filter == 'overdue'),
    ],
  ),
```

**Pattern 2: Collapsible Sections**
```dart
// Within a tab, use expandable sections
ExpansionPanelList(
  children: [
    ExpansionPanel(
      headerBuilder: (context, isExpanded) => Text('Quotes'),
      body: _buildQuotesList(),
    ),
    ExpansionPanel(
      headerBuilder: (context, isExpanded) => Text('Deposits'),
      body: _buildDepositsList(),
    ),
  ],
),
```

**Pattern 3: Bottom Sheet Navigation**
```dart
// For secondary features, use bottom sheet
FloatingActionButton(
  onPressed: () => showModalBottomSheet(
    context: context,
    builder: (context) => QuickActionsSheet(),
  ),
),
```

## Priority Actions

### High Priority
1. **Money Screen:** Reduce from 5 tabs to 3 tabs (Dashboard, Invoices, Payments)
2. **Reviews Screen:** Reduce from 5 tabs to 3 tabs (Dashboard, Reviews, Analytics)

### Medium Priority
3. Monitor Jobs screen if more status filters are added
4. Consider adding "More" dropdown for secondary actions

### Low Priority
5. Review other screens for tab count optimization opportunities

## Testing Checklist

- [ ] Money screen tabs are readable and tappable on mobile
- [ ] Reviews screen tabs are readable and tappable on mobile
- [ ] Filter chips work within consolidated tabs
- [ ] Navigation is intuitive after consolidation
- [ ] All functionality is still accessible after restructuring

