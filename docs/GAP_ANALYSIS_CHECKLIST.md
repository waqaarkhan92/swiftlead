# Gap Analysis Implementation Checklist

**Status Legend:**
- ⬜ Not Started
- 🟡 In Progress
- ✅ Complete
- ⏸️ Blocked/Paused

**Last Updated:** 2025-11-02

---

## ✅ Confirmation: Functional Changes Only

**This checklist ONLY includes functional implementations. It will NOT change:**
- ❌ Navigation structure (bottom nav, drawer)
- ❌ App bar design or styling
- ❌ Screen themes or visual design
- ❌ Component styling or appearance
- ❌ Overall app theme/design system

**All items in this checklist are about:**
- ✅ Wiring empty handlers (`onPressed` callbacks)
- ✅ Integrating existing components
- ✅ Completing partial functionality
- ✅ Creating missing functional screens/sheets
- ✅ Implementing missing business logic

**Intentional Design Decisions (Preserved):**
- ✅ **Quotes as tab in Money** - This is preserved. The checklist does NOT try to make it standalone.
- ✅ **Integrations directly from Settings** - No separate hub screen will be created. The checklist respects this design.
- ✅ **Reviews in drawer** - Already correctly implemented.

**Note:** If any checklist item appears to conflict with your intentional design decisions, we will skip or modify it to respect your design choices.

---

## Phase 1: Quick Wins - Empty Handlers (40+ items)

### Inbox Module

| Item | Location | Action Required | Status |
|------|----------|----------------|--------|
| Filter icon handler | `lib/screens/inbox/inbox_screen.dart:115` | Wire to filter sheet | ✅ |
| Compose icon handler | `lib/screens/inbox/inbox_screen.dart:146` | Wire to compose message sheet | ✅ |
| Archive swipe action | `lib/screens/inbox/inbox_screen.dart:261-295` | Implement archive logic | ✅ |
| Delete swipe action | `lib/screens/inbox/inbox_screen.dart:261-295` | Implement delete logic with undo | ✅ |
| Context menu long-press | `lib/screens/inbox/inbox_screen.dart:310` | Implement mark read, assign, add note | ✅ |
| View contact handler | `lib/screens/inbox/inbox_thread_screen.dart:78` | Navigate to ContactDetailScreen | ✅ |
| Search in thread handler | `lib/screens/inbox/inbox_thread_screen.dart:81` | Open thread search | ✅ |
| Internal notes handler | `lib/screens/inbox/inbox_thread_screen.dart:84` | Show InternalNotesModal | ✅ |
| Mute handler | `lib/screens/inbox/inbox_thread_screen.dart:87` | Implement mute logic | ✅ |
| Archive handler | `lib/screens/inbox/inbox_thread_screen.dart:90` | Implement archive logic | ✅ |
| Block handler | `lib/screens/inbox/inbox_thread_screen.dart:93` | Implement block logic | ✅ |

### Jobs Module

| Item | Location | Action Required | Status |
|------|----------|----------------|--------|
| Filter icon handler | `lib/screens/jobs/jobs_screen.dart:98` | Wire to filter sheet | ⏸️ | **NOTE: Filter sheet opens but filters don't apply correctly - needs investigation**
| Search icon handler | `lib/screens/jobs/jobs_screen.dart:137` | Implement search | ✅ |
| Add job icon handler | `lib/screens/jobs/jobs_screen.dart:141` | Wire to quick actions menu | ✅ |
| Sort icon handler | `lib/screens/jobs/jobs_screen.dart:131` | Implement sort dropdown | ✅ |
| Mark complete button | `lib/screens/jobs/job_detail_screen.dart:367` | Implement with confetti animation | ⬜ |
| Duplicate job handler | `lib/screens/jobs/job_detail_screen.dart:140-157` | Implement duplication logic | ⬜ |
| Export callback | `lib/screens/jobs/job_detail_screen.dart:163` | Implement onExportComplete | ⬜ |

### Calendar Module

| Item | Location | Action Required | Status |
|------|----------|----------------|--------|
| Search icon handler | `lib/screens/calendar/calendar_screen.dart:70` | Implement search | ✅ |
| Prev month button | `lib/screens/calendar/calendar_screen.dart:171` | Navigate to previous month | ⬜ |
| Next month button | `lib/screens/calendar/calendar_screen.dart:188` | Navigate to next month | ⬜ |
| Day tap handler | `lib/screens/calendar/calendar_screen.dart:237` | Show day events | ⬜ |
| Duplicate booking | `lib/screens/calendar/booking_detail_screen.dart:92-94` | Implement duplicate logic | ⬜ |

### Money Module

| Item | Location | Action Required | Status |
|------|----------|----------------|--------|
| Date range filter | `lib/screens/money/money_screen.dart:140` | Wire to date picker | ⬜ |
| Export icon handler | `lib/screens/money/money_screen.dart:147` | Wire to export builder | ✅ |
| Search icon handler | `lib/screens/money/money_screen.dart:151` | Implement search | ✅ |
| Add payment handler | `lib/screens/money/money_screen.dart:219-221` | Implement payment creation | ⬜ |
| Send invoice handler | `lib/screens/money/invoice_detail_screen.dart:74-76` | Implement send logic | ⬜ |
| Duplicate invoice | `lib/screens/money/invoice_detail_screen.dart:77-79` | Implement duplicate logic | ⬜ |
| Mark paid handler | `lib/screens/money/invoice_detail_screen.dart:80-82` | Implement mark paid logic | ⬜ |
| Delete invoice | `lib/screens/money/invoice_detail_screen.dart:83-85` | Implement delete logic | ⬜ |

### Contacts Module

| Item | Location | Action Required | Status |
|------|----------|----------------|--------|
| Edit contact handler | `lib/screens/contacts/contact_detail_screen.dart:115` | Navigate to edit screen | ⬜ |
| More menu handler | `lib/screens/contacts/contact_detail_screen.dart:119` | Implement more actions | ⬜ |

### Settings Module

| Item | Location | Action Required | Status |
|------|----------|----------------|--------|
| Edit Profile handler | `lib/screens/settings/settings_screen.dart:193-197` | Navigate to profile edit | ⬜ |
| Change Password handler | `lib/screens/settings/settings_screen.dart:198-202` | Navigate to password change | ⬜ |

### Marketing Module

| Item | Location | Action Required | Status |
|------|----------|----------------|--------|
| Pause campaign | `lib/screens/marketing/campaign_detail_screen.dart:63-65` | Implement pause logic | ⬜ |
| Clone campaign | `lib/screens/marketing/campaign_detail_screen.dart:66-68` | Implement clone logic | ⬜ |
| Archive campaign | `lib/screens/marketing/campaign_detail_screen.dart:69-71` | Implement archive logic | ⬜ |
| Delete campaign | `lib/screens/marketing/campaign_detail_screen.dart:72-74` | Implement delete logic | ⬜ |

### AI Hub Module

| Item | Location | Action Required | Status |
|------|----------|----------------|--------|
| Settings icon handler | `lib/screens/ai_hub/ai_hub_screen.dart:47` | Navigate to AI config screen | ✅ |
| Help icon handler | `lib/screens/ai_hub/ai_hub_screen.dart:51` | Show help | ✅ |
| Tone selector handler | `lib/screens/ai_hub/ai_hub_screen.dart:389-405` | Wire to AIToneSelectorSheet | ⬜ |
| Full Settings button | `lib/screens/ai_hub/ai_hub_screen.dart:423-426` | Navigate to AI config screen | ✅ |

---

## Phase 2: Component Integration (15+ items)

### Inbox Module

| Item | Component | Target Location | Action Required | Status |
|------|-----------|----------------|------------------|--------|
| VoiceNotePlayer | `lib/widgets/components/voice_note_player.dart` | ChatBubble in InboxThreadScreen | Add when message has voice note | ⬜ |
| LinkPreviewCard | `lib/widgets/components/link_preview_card.dart` | ChatBubble in InboxThreadScreen | Add when message has URL | ⬜ |
| AISummaryCard | `lib/widgets/components/ai_summary_card.dart` | InboxThreadScreen header | Add expandable summary card | ⬜ |
| ReactionPicker | `lib/widgets/components/reaction_picker.dart` | Message long-press menu | Add "React" option to PopupMenuButton | ⬜ |
| MessageDetailSheet | `lib/widgets/components/message_detail_sheet.dart` | Message long-press menu | Add "Details" option to PopupMenuButton | ⬜ |
| InternalNotesModal | `lib/widgets/components/internal_notes_modal.dart` | InboxThreadScreen | Wire to internal_notes menu item | ⬜ |
| TypingIndicator | Component needs creation | InboxThreadScreen | Show when contact is typing | ⬜ |

### Jobs Module

| Item | Component | Target Location | Action Required | Status |
|------|-----------|----------------|------------------|--------|
| ChaseHistoryTimeline | `lib/widgets/components/chase_history_timeline.dart` | JobDetailScreen | Add as 6th tab "Chasers" | ⬜ |
| RecurrencePatternPicker | `lib/widgets/components/recurrence_pattern_picker.dart` | CreateEditBookingScreen | Show when recurring toggle enabled | ⬜ |
| ConflictWarningCard | `lib/widgets/components/conflict_warning_card.dart` | CreateEditBookingScreen | Show during booking creation if conflict | ⬜ |

### Money Module

| Item | Component | Target Location | Action Required | Status |
|------|-----------|----------------|------------------|--------|
| ChaseHistoryTimeline (payments) | `lib/widgets/components/chase_history_timeline.dart` | InvoiceDetailScreen | Show payment reminders timeline | ⬜ |
| RecurringScheduleCard | `lib/widgets/components/recurring_schedule_card.dart` | Recurring Invoices screen/tab | Use in recurring invoices management | ⬜ |

### Contacts Module

| Item | Component | Target Location | Action Required | Status |
|------|-----------|----------------|------------------|--------|
| ScoreBreakdownCard | `lib/widgets/components/score_breakdown_card.dart` | ContactDetailScreen | Make score badge tappable to show sheet | ⬜ |

---

## Phase 3: Partial Implementations - Complete Existing Features (60+ items)

### Inbox Module

| Item | Current State | What's Missing | Status |
|------|---------------|----------------|--------|
| Quick Reply Templates | Hardcoded in method | Load from database | ⬜ |
| Message Search Screen | UI exists, placeholder search | Full-text search implementation | ⬜ |
| Archive/Delete with undo | Swipe exists, no handlers | Implement logic + undo toast | ⬜ |
| Pin action | Missing from swipe | Add swipe right → Pin | ⬜ |
| Batch selection | Not implemented | Long-press to select multiple | ⬜ |
| Pull-to-refresh in thread | Placeholder refresh | Actual message sync | ⬜ |
| Scheduled Messages | Completely missing | Need sheet + list + edit/delete | ⬜ |
| Character counter | Only shows at 140+ | Always show for SMS | ⬜ |
| AI Reply suggestions | Basic integration | Real-time context-aware suggestions | ⬜ |

### Jobs Module

| Item | Current State | What's Missing | Status |
|------|---------------|----------------|--------|
| Job Timeline | Mock data | Real events from quotes, invoices, reviews | ⬜ |
| Job Notes | Basic TextField | Rich text editor with @mentions | ⬜ |
| Job Media Gallery | Basic grid | Before/after sections | ⬜ |
| Custom Fields | Not present | Add custom fields section to Details tab | ⬜ |
| Job Templates | Not in form | Add template selector to CreateEditJobScreen | ⬜ |
| Client Selector | TextField | Contact picker with search | ⬜ |
| Service Type | Hardcoded chips | Load from services catalog | ⬜ |

### Calendar Module

| Item | Current State | What's Missing | Status |
|------|---------------|----------------|--------|
| Recurring Booking | Toggle exists | Pattern picker when enabled | ⬜ |
| Deposit Requirement | Variables exist | UI to set deposit amount | ⬜ |
| Team Calendar | Personal only | Toggle for team vs personal view | ⬜ |
| Booking Notes | Missing | Add notes section to BookingDetailScreen | ⬜ |
| Reminder Status | Missing | Display reminder status in BookingDetailScreen | ⬜ |
| ETA Countdown | Component exists | Verify fully functional | ⬜ |

### Money Module

| Item | Current State | What's Missing | Status |
|------|---------------|----------------|--------|
| Payment Reminders Timeline | Component exists | Add to InvoiceDetailScreen | ⬜ |
| Recurring Invoices | Component exists | Create management screen/tab | ⬜ |
| Revenue Chart | Basic chart | Full interactive features (tooltip, drill-down) | ⬜ |
| Deposits Tab | Missing | Add Deposits tab to MoneyScreen | ⬜ |

### Contacts Module

| Item | Current State | What's Missing | Status |
|------|---------------|----------------|--------|
| Filter Sheet | Placeholder text | Actual filter UI with stage, score, source, tags | ⬜ |
| Add Contact | Basic form | Full contact form with all fields | ⬜ |
| Timeline Filtering | Basic timeline | Filter by activity type | ⬜ |
| Contact Notes | Basic notes | Rich text with @mentions | ⬜ |
| Stage Change Sheet | Missing | Bottom sheet with stage selector | ⬜ |
| Score Breakdown Sheet | Component exists | Make accessible from score badge | ⬜ |
| Custom Fields | Missing | Add custom fields section | ⬜ |

### Settings Module

| Item | Current State | What's Missing | Status |
|------|---------------|----------------|--------|
| Notification Preferences | Basic screen | Full type×channel matrix | ⬜ |
| Security Settings | Basic item | Dedicated security screen | ⬜ |
| Data Export | Basic export | GDPR-compliant full export | ⬜ |
| Account Deletion | Basic item | Multi-step deletion flow | ⬜ |
| App Preferences | Basic items | Full preferences screen | ⬜ |

---

## Phase 4: Missing Screens/Sheets - New Implementations (50+ items)

### High Priority Missing Items

| Item | Spec Reference | Expected Path | Status |
|------|----------------|---------------|--------|
| Filter Sheet (Inbox) | UI_Inventory §1, line 83 | `lib/widgets/forms/inbox_filter_sheet.dart` | ⬜ |
| Compose Message Sheet | UI_Inventory §1, line 79 | `lib/widgets/forms/compose_message_sheet.dart` | ⬜ |
| Schedule Message Sheet | UI_Inventory §1, line 79 | `lib/widgets/forms/schedule_message_sheet.dart` | ⬜ |
| Scheduled Messages List Screen | UI_Inventory §1 | `lib/screens/inbox/scheduled_messages_screen.dart` | ⬜ |
| Message Actions Sheet | UI_Inventory §1, line 80 | `lib/widgets/forms/message_actions_sheet.dart` | ⬜ |
| Filter Sheet (Jobs) | UI_Inventory §3, line 180 | `lib/widgets/forms/jobs_filter_sheet.dart` | ⬜ |
| Job Template Selector Sheet | UI_Inventory §3, line 248 | `lib/widgets/forms/job_template_selector_sheet.dart` | ⬜ |
| Link Invoice to Job Sheet | UI_Inventory §3, line 182 | `lib/widgets/forms/link_invoice_to_job_sheet.dart` | ⬜ |
| Jobs Quick Actions Menu | UI_Inventory §3, line 277 | Part of JobsScreen | ⬜ |
| Service Editor Form | UI_Inventory §4, line 227 | `lib/screens/calendar/service_editor_screen.dart` | ⬜ |
| Reminder Settings Screen | UI_Inventory §4, line 231 | `lib/screens/calendar/reminder_settings_screen.dart` | ⬜ |
| AI Availability Suggestions Sheet | UI_Inventory §4, line 232 | `lib/widgets/forms/ai_availability_suggestions_sheet.dart` | ⬜ |
| Invoice Customization Screen | UI_Inventory §5, line 456 | `lib/screens/settings/invoice_customization_screen.dart` | ⬜ |
| Subscription & Billing Screen | UI_Inventory §5, line 457 | `lib/screens/settings/subscription_billing_screen.dart` | ⬜ |
| Payment Methods Screen | UI_Inventory §5, line 290 | `lib/screens/money/payment_methods_screen.dart` | ⬜ |
| Recurring Invoices Screen | UI_Inventory §5, line 292 | `lib/screens/money/recurring_invoices_screen.dart` | ⬜ |
| Deposits Screen | UI_Inventory §5, line 295 | `lib/screens/money/deposits_screen.dart` | ⬜ |
| Contact Stage Change Sheet | UI_Inventory, line 512 | `lib/widgets/forms/contact_stage_change_sheet.dart` | ⬜ |
| Contact Score Detail Sheet | UI_Inventory, line 513 | `lib/widgets/forms/contact_score_detail_sheet.dart` | ⬜ |
| AI Configuration Screen | UI_Inventory §2, line 130 | `lib/screens/ai_hub/ai_configuration_screen.dart` | ⬜ |
| Business Hours Editor Sheet | UI_Inventory §2, line 131 | `lib/widgets/forms/business_hours_editor_sheet.dart` | ⬜ |
| AI Tone Selector Sheet | UI_Inventory §2, line 133 | `lib/widgets/forms/ai_tone_selector_sheet.dart` | ⬜ |

### Medium Priority Missing Items

| Item | Spec Reference | Expected Path | Status |
|------|----------------|---------------|--------|
| Filter Sheet (Calendar) | Implied | `lib/widgets/forms/calendar_filter_sheet.dart` | ⬜ |
| Filter Sheet (Money) | Implied | `lib/widgets/forms/money_filter_sheet.dart` | ⬜ |
| Filter Sheet (Contacts) | Implied | `lib/widgets/forms/contacts_filter_sheet.dart` | ⬜ |
| Security Settings Screen | UI_Inventory §8, line 458 | `lib/screens/settings/security_settings_screen.dart` | ⬜ |
| Call Transcript Screen | UI_Inventory §2, line 134 | `lib/screens/ai_hub/call_transcript_screen.dart` | ⬜ |
| AI Performance Metrics Screen | UI_Inventory §2, line 135 | `lib/screens/ai_hub/ai_performance_screen.dart` | ⬜ |

---

## Phase 5: Advanced Features (Low Priority)

| Item | Spec Reference | Expected Path | Status |
|------|----------------|---------------|--------|
| Visual Workflow Editor | UI_Inventory, line 551 | `lib/screens/marketing/visual_workflow_editor_screen.dart` | ⬜ |
| Landing Page Builder | UI_Inventory, line 560 | `lib/screens/marketing/landing_page_builder_screen.dart` | ⬜ |
| Custom Report Builder (drag-drop) | UI_Inventory, line 347 | Enhanced version of existing | ⬜ |
| Benchmark Comparison Screen | UI_Inventory, line 349 | `lib/screens/reports/benchmark_comparison_screen.dart` | ⬜ |
| Goal Tracking Screen | UI_Inventory, line 351 | `lib/screens/reports/goal_tracking_screen.dart` | ⬜ |
| Scheduled Reports Screen | UI_Inventory, line 352 | `lib/screens/reports/scheduled_reports_screen.dart` | ⬜ |
| Multi-Day Booking | UI_Inventory §4, line 238 | Part of CreateEditBookingScreen | ⬜ |

---

## Notes & Blockers

### Current Blocker
- **Jobs Filter Handler**: Filter sheet opens and chips can be selected, but filters don't apply to the job list. Debug logs show filter values are being set, but the list doesn't update. Needs investigation - may be a state update issue or filter matching logic.

### Decisions Needed
- Template system backend schema design
- Custom fields schema design
- Recurring booking/invoice scheduling approach

### Completed Today
- None yet

---

**Progress Summary:**
- Phase 1 (Empty Handlers): 7/40+ complete (1 blocked - Jobs filter)
- Phase 2 (Integration): 0/15+ complete  
- Phase 3 (Partial): 0/60+ complete
- Phase 4 (Missing): 0/50+ complete
- Phase 5 (Advanced): 0/7 complete

**Overall: 0/170+ items complete**

