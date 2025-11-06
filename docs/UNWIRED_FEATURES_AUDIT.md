# Unwired Features Audit

**Date:** 2025-11-05  
**Purpose:** Identify features specified in specs but not wired to screens

---

## Missing Features

### 1. Weather Widget on Home Screen ❌

**Status:** NOT FOUND in HomeScreen  
**Specification:** Product Definition v2.5.1 specifies "Weather forecast for outdoor jobs"  
**Decision Matrix:** DECISION_MADE: KEEP — Will implement weather widget in HomeScreen  
**Found In:** `booking_detail_screen.dart` (line 457) — weather widget exists for booking detail only  
**Action Required:** Add weather widget to HomeScreen

---

### 2. Activity Feed ✅

**Status:** FOUND in HomeScreen  
**Location:** `lib/screens/home/home_screen.dart` (line 509, `_buildActivityFeed()`)  
**Specification:** Product Definition v2.5.1 specifies activity feed with recent messages, bookings, quotes, payments  
**Decision Matrix:** DECISION_MADE: KEEP  
**Implementation:** ✅ Already implemented with `_ActivityFeedRow` widget  
**Action Required:** None — already wired

---

### 3. Upcoming Schedule Widget ❌

**Status:** NOT FOUND in HomeScreen  
**Specification:** Product Definition v2.5.1 specifies "next 3 bookings with travel time and conflicts"  
**Decision Matrix:** DECISION_MADE: KEEP — Will implement upcoming schedule widget  
**Action Required:** Add upcoming schedule widget to HomeScreen

---

### 4. Date Range Selector for Metrics ❌

**Status:** NOT FOUND in HomeScreen  
**Specification:** Product Definition v2.5.1 enhancement specifies date range comparison  
**Decision Matrix:** DECISION_MADE: KEEP  
**Action Required:** Add date range selector to HomeScreen for metrics

---

### 5. Goal Tracking ❌

**Status:** NOT FOUND in HomeScreen  
**Specification:** Product Definition v2.5.1 enhancement specifies goal setting and tracking  
**Decision Matrix:** DECISION_MADE: KEEP  
**Action Required:** Implement goal tracking in HomeScreen

---

## Summary

| Feature | Status | Location | Action Required |
|---------|--------|----------|-----------------|
| Weather Widget | ❌ Missing | HomeScreen | Add widget |
| Activity Feed | ✅ Implemented | HomeScreen | None |
| Upcoming Schedule | ❌ Missing | HomeScreen | Add widget |
| Date Range Selector | ❌ Missing | HomeScreen | Add selector |
| Goal Tracking | ❌ Missing | HomeScreen | Implement feature |

**Total Missing:** 4 features  
**Total Implemented:** 1 feature

---

## Recommendations

### High Priority
1. **Weather Widget** — Add to HomeScreen (after MetricsRow or before ChartCard)
2. **Upcoming Schedule** — Add widget showing next 3 bookings with travel time

### Medium Priority
3. **Date Range Selector** — Add date range picker for metrics (7D/30D/90D selector)
4. **Goal Tracking** — Add goal setting and progress tracking section

