# Decision Questionnaire - Swiftlead Feature Decisions

**Date:** 2025-11-05  
**Purpose:** Make all feature decisions efficiently in batches

---

## Instructions

For each question, answer:
- **KEEP** = Implement this feature
- **REMOVE** = Remove from specs, don't implement
- **FUTURE** = Keep in specs but mark as future feature (not in v1)
- **MOVE** = Move to different module/screen (specify where)

---

## BATCH 1: Reviews Module (3.7)

### Q1.1: Review Detail Screen
**Feature:** Dedicated review detail screen with customer info, response history, platform badge  
**Current:** Review cards in list view only  
**Question:** Should we add a dedicated ReviewDetailScreen?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q1.2: Review Requests UI
**Feature:** Review request management (automated workflows, templates, status tracking)  
**Current:** ReviewResponseForm exists but no request management UI  
**Question:** Should review requests be managed in ReviewsScreen or separate screen?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

### Q1.3: Platform Integration Settings
**Feature:** Google/Facebook/Yelp connection settings  
**Current:** Backend has `review_platforms` table but no UI  
**Question:** Should platform settings be in Settings screen or Reviews screen?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

### Q1.4: Review Widgets
**Feature:** Widget generation for website embedding (star rating, carousel)  
**Current:** Backend has function but no UI  
**Question:** Is this a future feature or implement now?  
**Answer:** [KEEP/REMOVE/FUTURE]

---

## BATCH 2: Notifications Module (3.8)

### Q2.1: Do-Not-Disturb Settings
**Feature:** Quiet hours with timezone support, critical override  
**Current:** Backend has fields but no UI  
**Question:** Should DND settings be added to NotificationsScreen Preferences tab?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q2.2: Digest Email Configuration
**Feature:** Daily/weekly digest email settings (time, content)  
**Current:** Backend has functions but no UI  
**Question:** Should digest settings be in Preferences tab or separate section?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

### Q2.3: Rich Notification Content
**Feature:** Images, actions, progress indicators in notifications  
**Current:** Basic NotificationCard exists  
**Question:** Should we enhance NotificationCard for rich content?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q2.4: Notification Actions
**Feature:** Interactive buttons (Reply, Mark Complete, View)  
**Current:** Needs verification  
**Question:** Should notification actions be implemented?  
**Answer:** [KEEP/REMOVE/FUTURE]

---

## BATCH 3: Data Import/Export (3.9)

### Q3.1: Scheduled Exports UI
**Feature:** Recurring exports with auto-email/cloud upload configuration  
**Current:** Export builder exists but no scheduling UI  
**Question:** Should scheduled exports be in Export Builder or separate screen?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

### Q3.2: Backups & Restore UI
**Feature:** Automatic daily backups, restore point selection  
**Current:** Backend-only, no UI  
**Question:** Should backup/restore UI be added to Settings?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

### Q3.3: Import Templates
**Feature:** Pre-built templates (Google Contacts, Jobber, etc.)  
**Current:** ContactImportWizardScreen exists, templates may be implied  
**Question:** Should import templates be explicitly implemented?  
**Answer:** [KEEP/REMOVE/FUTURE]

---

## BATCH 4: Dashboard (3.10)

### Q4.1: Activity Feed
**Feature:** Recent messages, bookings, quotes, payments, jobs, reviews feed  
**Current:** Not found in HomeScreen  
**Question:** Should Activity Feed be added to HomeScreen?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q4.2: Team Performance
**Feature:** Jobs/revenue/ratings per team member, utilization rate  
**Current:** Not found in HomeScreen  
**Question:** Should Team Performance be on HomeScreen or Reports screen?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

### Q4.3: Upcoming Schedule
**Feature:** Next 3 bookings with travel time and conflicts  
**Current:** Not found in HomeScreen  
**Question:** Should Upcoming Schedule be added to HomeScreen?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q4.4: Date Range Selector
**Feature:** Compare metrics across date ranges (today, week, month, custom)  
**Current:** Not found in HomeScreen  
**Question:** Should date range selector be added to HomeScreen?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q4.5: Goal Tracking
**Feature:** Set revenue/booking goals and track progress  
**Current:** Not found in HomeScreen  
**Question:** Is this a future feature or implement now?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q4.6: Weather Widget
**Feature:** Weather forecast for outdoor jobs  
**Current:** Not found in HomeScreen  
**Question:** Is this a future feature or implement now?  
**Answer:** [KEEP/REMOVE/FUTURE]

---

## BATCH 5: AI Hub (3.11)

### Q5.1: AI Quote Assistant Configuration
**Feature:** Smart pricing, pricing rules, historical analysis settings  
**Current:** Not in AIHubScreen  
**Question:** Should Quote Assistant config be in AI Hub or Money screen?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

### Q5.2: AI Review Reply Configuration
**Feature:** Auto-respond, tone, templates, approval workflow settings  
**Current:** Not in AIHubScreen  
**Question:** Should Review Reply config be in AI Hub or Reviews screen?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

### Q5.3: AI Usage & Credits Display
**Feature:** Monthly allocation, used vs remaining, breakdown by feature  
**Current:** Backend has tracking but no UI  
**Question:** Should usage/credits be displayed in AI Hub?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q5.4: Conversation Simulator
**Feature:** Preview AI responses before enabling (Test Mode)  
**Current:** Not found in code  
**Question:** Should conversation simulator be added to AIConfigurationScreen?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q5.5: Confidence Thresholds
**Feature:** Set minimum confidence before AI responds  
**Current:** Not found in code  
**Question:** Should confidence thresholds be added to AIConfigurationScreen?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q5.6: Fallback Rules
**Feature:** Define what happens when AI is uncertain  
**Current:** Not found in code  
**Question:** Should fallback rules be added to AIConfigurationScreen?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q5.7: Multi-Language Configuration
**Feature:** Configure AI responses per language  
**Current:** Not found in code  
**Question:** Should multi-language be added to AIConfigurationScreen?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q5.8: Sentiment Analysis
**Feature:** Monitor emotional tone of AI interactions  
**Current:** Not found in code  
**Question:** Should sentiment analysis be added to AIPerformanceScreen?  
**Answer:** [KEEP/REMOVE/FUTURE]

---

## BATCH 6: Settings (3.12)

### Q6.1: Workflows & Automation Settings
**Feature:** Reminder settings, follow-up sequences, booking templates, payment reminders  
**Current:** Not found in Settings screen  
**Question:** Should automation settings be in Settings or separate screens?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

### Q6.2: Settings Search
**Feature:** Find any setting quickly with search  
**Current:** Not found in SettingsScreen  
**Question:** Should settings search be added?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q6.3: Bulk Configuration
**Feature:** Apply settings across team members  
**Current:** Not found in code  
**Question:** Is this a future feature or implement now?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q6.4: Template Library
**Feature:** Pre-built configurations for common professions  
**Current:** Not found in code  
**Question:** Is this a future feature or implement now?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q6.5: Import/Export Settings
**Feature:** Transfer configuration between organizations  
**Current:** Not found in code  
**Question:** Is this a future feature or implement now?  
**Answer:** [KEEP/REMOVE/FUTURE]

---

## BATCH 7: Adaptive Profession (3.13)

### Q7.1: Adaptive Terminology
**Feature:** Dynamic label changes (Job → Appointment, Client → Patient, etc.)  
**Current:** Backend has `label_overrides` but not applied in UI  
**Question:** Should terminology be dynamically applied throughout UI?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q7.2: Module Visibility
**Feature:** Show/hide modules per profession  
**Current:** Backend has `visible_modules` but not configurable in UI  
**Question:** Should module visibility be configurable per profession?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q7.3: Workflow Defaults
**Feature:** Profession-specific defaults (booking duration, payment terms, etc.)  
**Current:** Not found in code  
**Question:** Should workflow defaults be profession-specific?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q7.4: Smart Recommendations
**Feature:** AI suggests optimal settings based on profession  
**Current:** Not found in code  
**Question:** Is this a future feature?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q7.5: Industry Benchmarks
**Feature:** Compare performance to industry averages  
**Current:** Not found in code  
**Question:** Is this a future feature?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q7.6: Multi-Profession Support
**Feature:** Manage multiple service types in one account  
**Current:** Not found in code  
**Question:** Is this a future feature or implement now?  
**Answer:** [KEEP/REMOVE/FUTURE]

---

## BATCH 8: Onboarding (3.14)

### Q8.1: Save & Continue Later
**Feature:** Pause onboarding and resume later  
**Current:** Not found in code  
**Question:** Should save/resume be implemented?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q8.2: Smart Defaults
**Feature:** AI suggests settings based on profession  
**Current:** Not found in code  
**Question:** Is this a future feature?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q8.3: Import Data During Onboarding
**Feature:** Migrate from competitors during onboarding  
**Current:** Import functions exist but not in onboarding  
**Question:** Should import be available during onboarding?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q8.4: Video Tutorials
**Feature:** Inline help videos per step  
**Current:** Not found in code  
**Question:** Is this a future feature?  
**Answer:** [KEEP/REMOVE/FUTURE]

---

## BATCH 9: Integrations (3.15)

### Q9.1: Cloud Storage Integrations
**Feature:** Google Drive, Dropbox integration  
**Current:** Not found in code  
**Question:** Should cloud storage integrations be added to Settings?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q9.2: Review Platform Integrations
**Feature:** Google Business Profile, Trustpilot connection  
**Current:** Not found in code  
**Question:** Should review platform integrations be in Settings or Reviews screen?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

### Q9.3: Call Tracking Integration
**Feature:** Twilio Voice (call forwarding, recording, transcription)  
**Current:** Not found in code  
**Question:** Should call tracking be in TwilioConfigurationScreen or separate?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

### Q9.4: Integration Marketplace
**Feature:** Unified marketplace to browse and enable integrations  
**Current:** Not found in code  
**Question:** Should there be a unified Integration Marketplace screen?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q9.5: Sync Status Dashboard
**Feature:** Monitor integration health and sync status  
**Current:** Backend has tracking but no UI  
**Question:** Should sync status dashboard be added to Settings?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q9.6: Webhook Support
**Feature:** Custom integrations via webhooks  
**Current:** Backend has functions but no UI  
**Question:** Should webhook configuration be added to Settings?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q9.7: Zapier Integration
**Feature:** Connect to 1000+ apps via Zapier  
**Current:** Not found in code  
**Question:** Is this a future feature?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q9.8: API Access
**Feature:** Developer API for custom integrations, API key management  
**Current:** Backend has API but no key management UI  
**Question:** Should API access be in Settings or separate screen?  
**Answer:** [KEEP/REMOVE/FUTURE/MOVE] (if MOVE, specify where)

---

## BATCH 10: Reports & Analytics (3.16)

### Q10.1: Predictive Analytics
**Feature:** Forecast revenue and bookings  
**Current:** Not found in code  
**Question:** Is this a future feature?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q10.2: Cohort Analysis
**Feature:** Track client retention over time  
**Current:** Not found in code  
**Question:** Is this a future feature?  
**Answer:** [KEEP/REMOVE/FUTURE]

### Q10.3: Data Warehouse
**Feature:** Historical data retention for trend analysis  
**Current:** Backend has policies but no UI indicators  
**Question:** Is data warehouse a backend-only feature or should it have UI indicators?  
**Answer:** [KEEP/REMOVE/FUTURE]

---

## Notes

- Answer all questions to proceed
- Use "FUTURE" for features you want but not in v1
- Use "MOVE" if feature exists but should be in different location
- I'll process all answers and update specs/code accordingly
