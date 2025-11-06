# Decision Matrix: Module 3.12 — Settings & Configuration

**Date:** 2025-11-05  
**Purpose:** Compare all specifications against code implementation to identify gaps, inconsistencies, and decisions needed

---

## Matrix Legend

| Status | Meaning |
|--------|---------|
| ✅ | Fully Implemented |
| ⚠️ | Partially Implemented |
| ❌ | Not Implemented |
| 🔄 | Intentional Deviation |
| ❓ | Needs Verification |
| 📝 | Documented but Different Implementation |

---

## Core Features

| Feature | Product Def §3.12 | UI Inventory | Screen Layouts | Backend Spec | Code Implementation | Decision Needed |
|---------|-------------------|--------------|----------------|--------------|---------------------|----------------|
| **Profile & Organization** | ✅ Business name, logo, brand colors, contact info, industry, service area, business hours, timezone, currency | ✅ Organization Profile Screen | ✅ Profile settings | ✅ `organisations`, `org_settings` tables | ✅ OrganizationProfileScreen exists | ✅ **ALIGNED** |
| **Team Management** | ✅ Add/remove members, roles, permissions, activity tracking, session management | ✅ Team Management Screen | ✅ Team settings | ✅ `users`, `team_members` tables | ✅ TeamManagementScreen exists | ✅ **ALIGNED** |
| **Integrations** | ✅ Calendar (Google/Apple/Outlook), Email (IMAP/SMTP), Messaging (Twilio/WhatsApp), Social (Facebook/Instagram), Payments (Stripe), Cloud (Drive/Dropbox) | ✅ Integration screens | ✅ Integration settings | ✅ Integration tables | ✅ GoogleCalendarSetupScreen, TwilioConfigurationScreen, MetaBusinessSetupScreen, StripeConnectionScreen, EmailConfigurationScreen | ✅ **ALIGNED** |
| **Billing & Subscription** | ✅ View plan, usage summary, add-ons, payment methods, billing history, upgrade/downgrade | ✅ Subscription Billing Screen | ✅ Billing settings | ✅ `subscriptions` table | ✅ SubscriptionBillingScreen exists | ✅ **ALIGNED** |
| **Notifications** | ✅ Global preferences, digest schedule, push settings, SMS alerts, in-app rules | ✅ Notifications Screen | ✅ Notification settings | ✅ `notification_preferences` table | ✅ NotificationsScreen (separate screen, linked from Settings) | ✅ **ALIGNED** |
| **Security** | ✅ 2FA, password change, active sessions, login history, API keys, audit logs | ✅ Security Settings Screen | ✅ Security settings | ✅ `2fa_settings`, audit logs | ✅ SecuritySettingsScreen, ChangePasswordScreen exists | ✅ **ALIGNED** |
| **Data & Privacy** | ✅ GDPR settings, data retention, export data, delete account, privacy policy, terms | ✅ Data Export Screen, Account Deletion Screen | ✅ Privacy settings | ✅ `gdpr_requests` table | ✅ DataExportScreen, AccountDeletionScreen exists | ✅ **ALIGNED** |
| **Customization** | ✅ Custom fields, service types, tax rates, invoice templates, email signatures, quick replies | ✅ Custom Fields Manager, Invoice Customization | ✅ Customization settings | ✅ `custom_fields`, `invoice_templates` tables | ✅ CustomFieldsManagerScreen, InvoiceCustomizationScreen, CannedResponsesScreen exists | ✅ **ALIGNED** |
| **Workflows & Automation** | ✅ Reminder settings, follow-up sequences, booking templates, payment reminders, review timing | ❌ Not mentioned | ❌ Not mentioned | ✅ Automation settings | ❌ Not found in Settings screen | ❓ **DECISION NEEDED** — Are automation settings in Settings or separate screens? |

---

## v2.5.1 Enhancements

| Feature | Product Def §3.12 | UI Inventory | Screen Layouts | Backend Spec | Code Implementation | Decision Needed |
|---------|-------------------|--------------|----------------|--------------|---------------------|----------------|
| **Quick Setup Wizard** | ✅ Guided onboarding for first-time setup | ✅ Onboarding Screen | ✅ Onboarding flow | ✅ Onboarding tracking | ✅ OnboardingScreen exists (separate module) | ✅ **ALIGNED** (separate module) |
| **Settings Search** | ✅ Find any setting quickly | ❌ Not mentioned | ❌ Not mentioned | ❌ Not mentioned | ❌ Not found in SettingsScreen | ✅ **KEEP** — To be added to SettingsScreen |
| **Bulk Configuration** | ✅ Apply settings across team members | ❌ Not mentioned | ❌ Not mentioned | ❌ Not mentioned | ❌ Not found in code | ✅ **KEEP** — To be added to SettingsScreen |
| **Template Library** | ✅ Pre-built configurations for common professions | ❌ Not mentioned | ❌ Not mentioned | ❌ Not mentioned | ❌ Not found in code | ✅ **KEEP** — To be added to SettingsScreen |
| **Import/Export Settings** | ✅ Transfer configuration between organizations | ❌ Not mentioned | ❌ Not mentioned | ❌ Not mentioned | ❌ Not found in code | ✅ **KEEP** — To be added to SettingsScreen |
| **Dark Mode** | ✅ Toggle light/dark theme | ✅ Theme toggle | ✅ Theme settings | ✅ Theme preference | ✅ SettingsScreen has theme toggle | ✅ **ALIGNED** |
| **Accessibility** | ✅ Font size, contrast, screen reader mode | ✅ App Preferences Screen | ✅ Accessibility settings | ✅ `user_preferences` table | ✅ AppPreferencesScreen exists | ✅ **ALIGNED** |
| **Keyboard Shortcuts** | ✅ View and customize shortcuts | ❌ Not mentioned | ❌ Not mentioned | ❌ Not mentioned | ❌ Not found in code | ❓ **DECISION NEEDED** — Are keyboard shortcuts web-only or should they be documented? |

---

## Summary Statistics

| Category | Count | Status |
|----------|-------|--------|
| **✅ Fully Aligned** | 9 | Core settings features implemented (including Quick Setup Wizard) |
| **⚠️ Partial/Deferred** | 4 | Settings Search, Bulk Configuration, Template Library, Import/Export Settings |
| **🔴 Missing from Code** | 1 | Workflows & Automation settings |
| **📝 Different Implementation** | 0 | - |
| **❓ Needs Verification** | 2 | Keyboard Shortcuts, Workflows & Automation location |
| **Total Features** | 16 | |

---

## User Decisions (2025-11-05)

### Batch 6: Settings Decisions

1. **Quick Setup Wizard** — ✅ **KEEP**
   - Decision: Already implemented (OnboardingScreen exists as separate module)
   - Status: ✅ Aligned

2. **Settings Search** — ✅ **KEEP**
   - Decision: Add search functionality to SettingsScreen
   - Action: Add search bar to SettingsScreen to find any setting quickly

3. **Bulk Configuration** — ✅ **KEEP**
   - Decision: Add bulk configuration feature
   - Action: Add bulk settings section to SettingsScreen for applying settings across team members

4. **Template Library** — ✅ **KEEP**
   - Decision: Add template library feature
   - Action: Add template library section to SettingsScreen with pre-built configurations for common professions

5. **Import/Export Settings** — ✅ **KEEP**
   - Decision: Add settings import/export feature
   - Action: Add import/export section to SettingsScreen for transferring configuration between organizations

### Remaining Decisions

6. **Keyboard Shortcuts** — ❓ **DECISION NEEDED**
   - Product Def v2.5.1 enhancement specifies keyboard shortcuts
   - **Decision Needed:** Are shortcuts web-only or should they be documented in mobile app?

7. **Workflows & Automation Settings** — ❓ **DECISION NEEDED**
   - Product Def specifies reminder settings, follow-up sequences, booking templates, payment reminders
   - **Decision Needed:** Are these settings in Settings screen, Calendar screen, or separate Automation screen?

---

## Implementation Actions

### Immediate (Next Sprint)
1. ⏳ **Add Settings Search** to SettingsScreen (search bar in app bar or top of screen)
2. ⏳ **Add Bulk Configuration** section to SettingsScreen (apply settings across team members)
3. ⏳ **Add Template Library** section to SettingsScreen (pre-built configurations for professions)
4. ⏳ **Add Import/Export Settings** section to SettingsScreen (transfer configuration between organizations)

### Pending Decisions
5. **Decide** on Workflows & Automation settings location (Settings, Calendar, or separate Automation screen)
6. **Decide** on Keyboard Shortcuts (web-only or document in mobile app)

---

**Document Version:** 1.0  
**Next Review:** After Module 3.13 (Adaptive Profession) analysis
