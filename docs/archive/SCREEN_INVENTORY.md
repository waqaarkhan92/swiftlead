# Complete Screen Inventory

**Generated:** 2025-01-XX  
**Codebase:** Flutter implementation in `/lib/screens/`

---

## Navigation Structure

### Primary Tabs (Bottom Navigation Bar)
Accessed via bottom navigation bar - 5 main tabs:

| Tab | Screen | File | Status |
|-----|--------|------|--------|
| Home | HomeScreen | `home/home_screen.dart` | ✅ Standalone |
| Inbox | InboxScreen | `inbox/inbox_screen.dart` | ✅ Standalone |
| Jobs | JobsScreen | `jobs/jobs_screen.dart` | ✅ Has tabs (All, Active, Completed, Cancelled) |
| Calendar | CalendarScreen | `calendar/calendar_screen.dart` | ✅ Standalone |
| Money | MoneyScreen | `money/money_screen.dart` | ✅ Has tabs (Dashboard, Invoices, Quotes, Payments, Deposits) |

---

### Drawer Screens
Accessed via drawer menu (side navigation):

| Screen | File | Status |
|--------|------|--------|
| AI Hub | `ai_hub/ai_hub_screen.dart` | ✅ Standalone |
| Contacts | `contacts/contacts_screen.dart` | ✅ Standalone |
| Marketing | `marketing/marketing_screen.dart` | ✅ Standalone |
| Reports & Analytics | `reports/reports_screen.dart` | ✅ Has tabs (Overview, Revenue, Jobs, Clients, AI Performance, Team) |
| Reviews | `reviews/reviews_screen.dart` | ✅ Has tabs (Dashboard, Requests, All Reviews, Analytics, NPS) |
| Settings | `settings/settings_screen.dart` | ✅ Standalone (list of settings sections) |
| Support & Help | `support/support_screen.dart` | ✅ Standalone |
| Legal / Privacy | `legal/legal_screen.dart` | ✅ Standalone |

---

## Screens with Internal Tabs

### 1. Jobs Screen
**File:** `jobs/jobs_screen.dart`  
**Tabs:** All, Active, Completed, Cancelled  
**Access:** Bottom nav → Jobs tab

### 2. Money Screen
**File:** `money/money_screen.dart`  
**Tabs:** Dashboard, Invoices, Quotes, Payments, Deposits  
**Access:** Bottom nav → Money tab

### 3. Job Detail Screen
**File:** `jobs/job_detail_screen.dart`  
**Primary Tabs:** Timeline, Details, Notes (displayed as SegmentedControl)  
**More Menu:** Messages, Media, Chasers (accessible via dropdown menu)  
**Access:** Jobs Screen → Tap job card → Navigate to detail

### 4. Contact Detail Screen
**File:** `contacts/contact_detail_screen.dart`  
**Tabs:** Overview, Timeline, Notes, Related  
**Access:** Contacts Screen → Tap contact card → Navigate to detail

### 5. Reports Screen
**File:** `reports/reports_screen.dart`  
**Tabs:** Overview, Revenue, Jobs, Clients, AI Performance, Team  
**Access:** Drawer → Reports & Analytics

### 6. Reviews Screen
**File:** `reviews/reviews_screen.dart`  
**Tabs:** Dashboard, Requests, All Reviews, Analytics, NPS  
**Access:** Drawer → Reviews

### 7. Campaign Detail Screen
**File:** `marketing/campaign_detail_screen.dart`  
**Tabs:** Overview, Analytics, Recipients  
**Access:** Marketing Screen → Tap campaign card → Navigate to detail

### 8. Campaign Analytics Screen
**File:** `marketing/campaign_analytics_screen.dart`  
**Tabs:** (Multiple analytics views)  
**Access:** Campaign Detail → Analytics tab

### 9. Notifications Screen
**File:** `notifications/notifications_screen.dart`  
**Tabs:** (TabBar with multiple categories)  
**Access:** Drawer → Settings → Notifications (or direct navigation)

### 10. NPS Survey View
**File:** `reviews/nps_survey_view.dart`  
**Tabs:** Active Surveys, Results, History  
**Access:** Reviews Screen → NPS tab or related action

---

## Standalone Screens (Navigated To)

### Home Module
- **HomeScreen** - Bottom nav tab (primary)

### Inbox Module
- **InboxScreen** - Bottom nav tab (primary)
- **InboxThreadScreen** - Navigate from Inbox list → Tap conversation
- **MessageSearchScreen** - Navigate from Inbox → Search icon
- **ScheduledMessagesScreen** - Navigate from Inbox → Scheduled messages action
- **ThreadSearchScreen** - Navigate from Inbox → Thread search action

### Jobs Module
- **JobsScreen** - Bottom nav tab (primary) - Has tabs
- **JobDetailScreen** - Navigate from Jobs list → Tap job card - Has tabs
- **CreateEditJobScreen** - Navigate from Jobs → "+" button or "Create Job" action
- **JobSearchScreen** - Navigate from Jobs → Search icon

### Calendar Module
- **CalendarScreen** - Bottom nav tab (primary)
- **BookingDetailScreen** - Navigate from Calendar → Tap booking
- **CreateEditBookingScreen** - Navigate from Calendar → "+" button or tap empty slot
- **CalendarSearchScreen** - Navigate from Calendar → Search icon
- **ServiceCatalogScreen** - Navigate from Settings → Services or Calendar → Service catalog
- **ServiceEditorScreen** - Navigate from Service Catalog → Edit service
- **ReminderSettingsScreen** - Navigate from Calendar → Reminder settings

### Money Module
- **MoneyScreen** - Bottom nav tab (primary) - Has tabs
- **InvoiceDetailScreen** - Navigate from Money → Invoices tab → Tap invoice
- **CreateEditInvoiceScreen** - Navigate from Money → "+" menu → Create Invoice
- **PaymentDetailScreen** - Navigate from Money → Payments tab → Tap payment
- **DepositsScreen** - Navigate from Money → "+" menu → Deposits (also accessible as tab in Money)
- **RecurringInvoicesScreen** - Navigate from Money → "+" menu → Recurring Invoices
- **PaymentMethodsScreen** - Navigate from Money → "+" menu → Payment Methods
- **MoneySearchScreen** - Navigate from Money → Search icon

### Quotes Module
- **QuoteDetailScreen** - Navigate from Money → Quotes tab → Tap quote
- **CreateEditQuoteScreen** - Navigate from Money → "+" menu → Create Quote, or from Job/Contact → Create Quote action

### Contacts Module
- **ContactsScreen** - Drawer → Contacts
- **ContactDetailScreen** - Navigate from Contacts → Tap contact card - Has tabs
- **CreateEditContactScreen** - Navigate from Contacts → "+" button or "Add Contact" action
- **ContactImportWizardScreen** - Navigate from Contacts → Menu → Import
- **ContactImportResultsScreen** - Navigate from Import Wizard → After import
- **ContactExportBuilderScreen** - Navigate from Contacts → Menu → Export
- **DuplicateDetectorScreen** - Navigate from Contacts → Menu → Find Duplicates
- **SegmentsScreen** - Navigate from Contacts → Menu → Segments
- **SegmentBuilderScreen** - Navigate from Segments → Create/Edit segment

### Marketing Module
- **MarketingScreen** - Drawer → Marketing
- **CampaignDetailScreen** - Navigate from Marketing → Tap campaign card - Has tabs
- **CampaignBuilderScreen** - Navigate from Marketing → "+" menu → Create Campaign
- **CampaignAnalyticsScreen** - Navigate from Campaign Detail → Analytics tab - Has tabs
- **VisualWorkflowEditorScreen** - Navigate from Campaign Builder → Workflow editor
- **LandingPageBuilderScreen** - Navigate from Marketing → "+" menu → Create Landing Page

### Reports Module
- **ReportsScreen** - Drawer → Reports & Analytics - Has tabs
- **CustomReportBuilderScreen** - Navigate from Reports → Action button → Custom Report Builder
- **GoalTrackingScreen** - Navigate from Reports → Action button → Goal Tracking
- **BenchmarkComparisonScreen** - Navigate from Reports → Action button → Benchmark Comparison
- **ScheduledReportsScreen** - Navigate from Reports → Action button → Scheduled Reports

### Reviews Module
- **ReviewsScreen** - Drawer → Reviews - Has tabs
- **NPS Survey View** - Navigate from Reviews → NPS tab - Has tabs
- **ReviewResponseForm** - Navigate from Reviews → Respond to review

### AI Hub Module
- **AIHubScreen** - Drawer → AI Hub
- **AIConfigurationScreen** - Navigate from AI Hub → Settings icon
- **AITrainingModeScreen** - Navigate from AI Hub → Training Mode card/action
- **AIPerformanceScreen** - Navigate from AI Hub → Performance card/action
- **AIActivityLogScreen** - Navigate from AI Hub → Activity Log card/action
- **CallTranscriptScreen** - Navigate from AI Hub → Call Transcripts or Inbox → Call transcript
- **FAQManagementScreen** - Navigate from AI Hub → FAQ Management card/action or Settings → FAQs

### Settings Module
- **SettingsScreen** - Drawer → Settings
- **EditProfileScreen** - Navigate from Settings → Profile section
- **ChangePasswordScreen** - Navigate from Settings → Security section
- **SecuritySettingsScreen** - Navigate from Settings → Security section
- **AppPreferencesScreen** - Navigate from Settings → Preferences section
- **OrganizationProfileScreen** - Navigate from Settings → Organization section
- **TeamManagementScreen** - Navigate from Settings → Team section
- **SubscriptionBillingScreen** - Navigate from Settings → Billing section
- **InvoiceCustomizationScreen** - Navigate from Settings → Invoice customization
- **CustomFieldsManagerScreen** - Navigate from Settings → Custom Fields section
- **CannedResponsesScreen** - Navigate from Settings → Canned Responses section
- **DataExportScreen** - Navigate from Settings → Data Export section
- **AccountDeletionScreen** - Navigate from Settings → Danger Zone → Delete Account

### Integration/Configuration Screens
- **EmailConfigurationScreen** - Navigate from Settings → Email configuration
- **GoogleCalendarSetupScreen** - Navigate from Settings → Calendar integration
- **MetaBusinessSetupScreen** - Navigate from Settings → Meta/Facebook integration
- **StripeConnectionScreen** - Navigate from Settings → Stripe integration
- **TwilioConfigurationScreen** - Navigate from Settings → Twilio/SMS configuration

### Other Screens
- **SupportScreen** - Drawer → Support & Help
- **LegalScreen** - Drawer → Legal / Privacy
- **NotificationsScreen** - Navigate from Settings → Notifications or direct navigation - Has tabs
- **OnboardingScreen** - App entry point (first launch)

---

## Summary Statistics

| Category | Count |
|----------|-------|
| **Primary Tabs (Bottom Nav)** | 5 |
| **Drawer Screens** | 8 |
| **Screens with Internal Tabs** | 10 |
| **Standalone Detail Screens** | ~25 |
| **Standalone Create/Edit Screens** | ~10 |
| **Standalone Configuration/Setup Screens** | ~15 |
| **Total Screens** | ~93+ |

---

## Navigation Patterns

### 1. Bottom Navigation (Primary Tabs)
- Home, Inbox, Jobs, Calendar, Money
- Always visible, persists across navigation

### 2. Drawer Navigation
- AI Hub, Contacts, Marketing, Reports, Reviews, Settings, Support, Legal
- Replaces bottom tab content when opened
- Accessible from hamburger menu

### 3. Push Navigation
- Most detail screens, create/edit screens
- Uses `Navigator.push()` with `MaterialPageRoute`
- Full screen replacement

### 4. Modal/Sheet Navigation
- Some forms use bottom sheets
- Quick actions, filters, settings

### 5. Tab Navigation Within Screens
- SegmentedControl for horizontal tabs
- TabBar for traditional tabs
- IndexedStack for tab content switching

---

## Notes

- **Deposits** appears both as a tab in Money screen AND as a standalone screen (accessed via menu)
- **Settings** is a list-based screen with sections, not tabs
- **Onboarding** is typically shown only on first launch
- Most detail screens are accessed by tapping cards/items in list screens
- Create/Edit screens typically have a "+" button or "Create" action in parent screen

---

**Last Updated:** 2025-01-XX  
**Next Review:** After major navigation changes

