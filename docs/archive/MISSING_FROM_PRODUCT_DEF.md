# Features in Codebase Missing from Product Definition v2.5.1

**Analysis Date:** 2025-01-XX  
**Product Definition:** `Product_Definition_v2.5.1_10of10.md`  
**Codebase:** Flutter implementation in `/lib/screens/`

---

## Summary

This document identifies features and screens that are **implemented in the codebase** but are **not documented** (or only partially documented) in the Product Definition specification.

**Status Legend:**
- ✅ **Implemented** - Feature exists in codebase
- ⚠️ **Partially Documented** - Mentioned in spec but not detailed
- ❌ **Not Documented** - Completely missing from spec

---

## 1. Money Module - Dedicated Screens

### 1.1 Deposits Screen (`lib/screens/money/deposits_screen.dart`)
**Status:** ❌ **Not Documented**

**Implementation:**
- Standalone screen for managing deposits
- Filter by status: All, Pending, Collected, Refunded
- Deposit cards showing job title, client name, amount, status, dates
- Request deposit action (FAB)
- Tracks: requested date, due date, collected date, refunded date

**Spec Mention:**
- Product Definition §3.6 mentions "Deposits and installments" (line 493) but no dedicated screen
- Spec mentions "Payment request if deposit required" (line 330) but not deposit management

**Recommendation:** Add §3.6.1 "Deposits Management" with full screen specification

---

### 1.2 Payment Methods Screen (`lib/screens/money/payment_methods_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Standalone screen for managing payment methods
- List of payment methods (cards, bank accounts)
- Set default payment method
- Remove payment methods
- Add payment method (placeholder)
- Shows last 4 digits, expiry, holder name, bank name

**Spec Mention:**
- Product Definition §3.6 mentions "Payment method management" (line 1206) but no screen details
- Spec mentions "Store cards securely" (line 496) but not management UI

**Recommendation:** Add §3.6.2 "Payment Methods Management" with screen specification

---

### 1.3 Recurring Invoices Screen (`lib/screens/money/recurring_invoices_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Standalone screen for managing recurring invoices
- List of recurring invoices with:
  - Invoice number, client name, amount
  - Frequency (weekly, monthly, quarterly)
  - Next occurrence date
  - Status (active, paused)
- Create recurring invoice action
- RecurringScheduleCard component

**Spec Mention:**
- Product Definition §3.6 mentions "Recurring Invoices" (line 501-506) but no dedicated screen
- Spec mentions features but not screen layout or navigation

**Recommendation:** Add §3.6.3 "Recurring Invoices Management" with screen specification

---

## 2. Marketing Module - Advanced Features

### 2.1 Visual Workflow Editor (`lib/screens/marketing/visual_workflow_editor_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Full drag-drop workflow editor with canvas
- Node palette (Start, Email, SMS, Wait, Condition, End)
- Zoom controls (in/out, min 0.5x, max 3.0x)
- Undo/Redo functionality (50-state history)
- Grid background for alignment
- Node connections visualization
- Workflow validation
- Save workflow

**Spec Mention:**
- Product Definition §3.8 mentions "Visual Campaign Builder" with "Drag-Drop Workflow" (lines 733-740)
- Spec describes workflow concepts but not the editor UI details

**Gaps:**
- No mention of zoom controls
- No mention of undo/redo
- No mention of node palette UI
- No mention of canvas grid
- No mention of workflow validation UI

**Recommendation:** Enhance §3.8.1 "Visual Campaign Builder" with detailed UI specifications

---

### 2.2 Landing Page Builder (`lib/screens/marketing/landing_page_builder_screen.dart`)
**Status:** ❌ **Not Documented**

**Implementation:**
- Full landing page builder screen
- Content blocks palette (sidebar)
- Editor with preview mode toggle
- Title and URL fields
- Drag-drop content blocks
- Save functionality
- Preview mode (read-only view)

**Spec Mention:**
- Product Definition §3.8 mentions "Landing pages" but no builder screen
- No specification for landing page creation UI

**Recommendation:** Add §3.8.2 "Landing Page Builder" with complete screen specification

---

## 3. Jobs Module - Quote Chasers Tab

### 3.1 Job Detail "Chasers" Tab (`lib/screens/jobs/job_detail_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Sixth tab in Job Detail screen: "Chasers"
- Displays quote chaser history using ChaseHistoryTimeline component
- Shows chaser records with:
  - Message/description
  - Timestamp
  - Status (sent, delivered, scheduled)
  - Channel (email, SMS)
- Empty state: "No chasers scheduled" with info banner

**Spec Mention:**
- Product Definition §3.5 mentions "Quote Follow-Up" and automated chasers (lines 427-431)
- Backend Spec §5 mentions `quote_chasers` table (line 316)
- **BUT:** No mention of displaying chasers in Job Detail screen
- Spec doesn't mention Chasers tab in job detail view

**Recommendation:** Add to §3.3 "Jobs" that Job Detail screen includes "Chasers" tab showing quote chaser history

---

## 4. Reports Module - Advanced Screens

### 4.1 Custom Report Builder (`lib/screens/reports/custom_report_builder_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Standalone screen for building custom reports
- Available from Reports screen action button

**Spec Mention:**
- Product Definition mentions reporting but not custom report builder screen
- Spec mentions "Custom Report Builder (v2.5.1)" in UI Inventory context but not detailed

**Recommendation:** Add §3.17.1 "Custom Report Builder" with screen specification

---

### 4.2 Goal Tracking Screen (`lib/screens/reports/goal_tracking_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Standalone screen for goal tracking
- Available from Reports screen action button

**Spec Mention:**
- Product Definition mentions goals/KPIs but not dedicated goal tracking screen
- Spec mentions "Goal Tracking Section (v2.5.1)" but not as standalone screen

**Recommendation:** Add §3.17.2 "Goal Tracking" with screen specification

---

### 4.3 Benchmark Comparison Screen (`lib/screens/reports/benchmark_comparison_screen.dart`)
**Status:** ❌ **Not Documented**

**Implementation:**
- Standalone screen for comparing performance against benchmarks
- Available from Reports screen action button

**Spec Mention:**
- Product Definition mentions competitive positioning but not benchmark comparison feature

**Recommendation:** Add §3.17.3 "Benchmark Comparison" with screen specification

---

### 4.4 Scheduled Reports Screen (`lib/screens/reports/scheduled_reports_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Standalone screen for managing scheduled reports
- Lists scheduled reports with:
  - Name, frequency, next run date
  - Recipients
  - Active/inactive status
- Available from Reports screen action button

**Spec Mention:**
- Product Definition mentions report scheduling but not dedicated management screen

**Recommendation:** Add §3.17.4 "Scheduled Reports Management" with screen specification

---

## 5. Contacts Module - Additional Features

### 5.1 Contact Timeline Tab
**Status:** ✅ **Documented but Location Different**

**Implementation:**
- Contact Detail screen has "Timeline" tab
- Shows chronological activity

**Spec Mention:**
- Product Definition §3.7 mentions "360° Activity Timeline" (lines 595-607)
- Spec correctly describes timeline but location is verified

**Note:** This is documented, just confirming implementation matches spec

---

## 6. Settings Module - Additional Screens

### 6.1 Email Configuration Screen (`lib/screens/settings/email_configuration_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Standalone screen for email configuration
- Likely includes SMTP settings, IMAP configuration

**Spec Mention:**
- Product Definition mentions email integration but not dedicated configuration screen

**Recommendation:** Add to §3.13 "Settings" - email configuration screen details

---

### 6.2 Google Calendar Setup Screen (`lib/screens/settings/google_calendar_setup_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Standalone screen for Google Calendar integration setup
- OAuth flow likely

**Spec Mention:**
- Product Definition mentions calendar sync but not dedicated setup screen

**Recommendation:** Add to §3.4 "Calendar & Bookings" - Google Calendar setup screen

---

### 6.3 Meta Business Setup Screen (`lib/screens/settings/meta_business_setup_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Standalone screen for Meta (Facebook/Instagram) Business API setup
- OAuth flow and configuration

**Spec Mention:**
- Product Definition mentions Meta integration but not dedicated setup screen

**Recommendation:** Add to §3.1 "Omni-Inbox" or §3.13 "Settings" - Meta setup screen

---

### 6.4 Stripe Connection Screen (`lib/screens/settings/stripe_connection_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Standalone screen for Stripe payment integration setup
- OAuth/API key configuration

**Spec Mention:**
- Product Definition mentions Stripe integration but not dedicated setup screen

**Recommendation:** Add to §3.6 "Invoices & Billing" or §3.13 "Settings" - Stripe setup screen

---

### 6.5 Twilio Configuration Screen (`lib/screens/settings/twilio_configuration_screen.dart`)
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Standalone screen for Twilio SMS/WhatsApp configuration
- API credentials setup

**Spec Mention:**
- Product Definition mentions Twilio integration but not dedicated configuration screen

**Recommendation:** Add to §3.1 "Omni-Inbox" or §3.13 "Settings" - Twilio configuration screen

---

## 7. Component-Level Features

### 7.1 ChaseHistoryTimeline Component
**Status:** ⚠️ **Partially Documented**

**Implementation:**
- Widget component used in Job Detail "Chasers" tab
- Displays timeline of quote chaser events

**Spec Mention:**
- Component mentioned in UI Inventory but not detailed in Product Definition

**Recommendation:** Add to §3.3 "Jobs" - component details

---

### 7.2 RecurringScheduleCard Component
**Status:** ❌ **Not Documented**

**Implementation:**
- Card component for displaying recurring invoice schedule
- Shows frequency, next occurrence, status

**Spec Mention:**
- Not mentioned in Product Definition

**Recommendation:** Add to §3.6 "Invoices & Billing" - component details

---

## Summary Statistics

| Category | Count | Status |
|----------|-------|--------|
| **Not Documented** | 4 | Need full specification |
| **Partially Documented** | 11 | Need enhancement |
| **Total Missing/Incomplete** | 15 | Features to add/enhance |

---

## Priority Recommendations

### High Priority (User-Facing Features)
1. **Deposits Screen** - Full specification for deposit management
2. **Payment Methods Screen** - Full specification for payment method management  
3. **Recurring Invoices Screen** - Full specification for recurring invoice management
4. **Landing Page Builder** - Complete specification for landing page creation
5. **Visual Workflow Editor** - Enhanced UI details (zoom, undo/redo, palette)

### Medium Priority (Enhanced Features)
6. **Job Detail Chasers Tab** - Document chasers display in job detail
7. **Custom Report Builder** - Detailed specification
8. **Goal Tracking Screen** - Standalone screen specification
9. **Benchmark Comparison** - New feature specification
10. **Scheduled Reports** - Management screen specification

### Low Priority (Configuration Screens)
11. **Email Configuration Screen**
12. **Google Calendar Setup Screen**
13. **Meta Business Setup Screen**
14. **Stripe Connection Screen**
15. **Twilio Configuration Screen**

---

## Next Steps

1. Review each item with product team
2. Prioritize which features to add to Product Definition
3. Create detailed specifications for high-priority items
4. Update Product Definition v2.5.1 with missing features
5. Sync with UI Inventory and Screen Layouts documents

---

**Document Version:** 1.0  
**Last Updated:** 2025-01-XX  
**Next Review:** After Product Definition updates

