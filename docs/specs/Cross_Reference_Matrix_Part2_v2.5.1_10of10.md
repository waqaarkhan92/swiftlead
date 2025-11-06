<!-- Split version for AI readability. Original structure preserved. -->

#### [Enhanced Addendum — Extended Cross-Reference: Contacts, Notifications, Import/Export]

## Module 7: Contacts / CRM

| Product Feature | UI Surfaces | Backend Tables | Edge Functions | External APIs |
|-----------------|-------------|----------------|----------------|---------------|
| Contact list & search | Contact List View, Search Bar | `contacts`, `contact_stages`, `contact_scores` | Direct SQL with filters | N/A |
| Contact detail view | Contact Detail Screen | `contacts`, `contact_timeline`, `contact_custom_field_values` | Direct CRUD | N/A |
| Add/edit contact | Add Contact Sheet, Contact Edit Sheet | `contacts` | Direct CRUD | N/A |
| **Custom fields** | Custom Fields Manager, Contact Edit Sheet | `contact_custom_fields`, `contact_custom_field_values` | Direct CRUD | N/A |
| **Contact lifecycle stages** | Contact Detail, Stage Progress Bar | `contact_stages` | `update-contact-stage` | N/A |
| **Lead scoring** | Contact Detail, Score Indicator | `contact_scores` | `calculate-contact-score` | N/A |
| **Activity timeline** | Activity Timeline Tab | `contact_timeline` | Direct SQL | N/A |
| **Contact relationships** | Contact Detail → Related Contacts | `contact_relationships` | Direct CRUD | N/A |
| **Segmentation** | Segment Builder, Segment List | `contact_segments`, `contact_segment_members` | `calculate-segment-members`, `refresh-dynamic-segments` (cron) | N/A |
| **Duplicate detection** | Duplicate Detector Screen | `contacts` | `detect-duplicates` | N/A |
| **Contact merging** | Contact Merge Preview | `contacts` | `merge-contacts` | N/A |
| **Bulk import** | Import Wizard | `import_jobs`, `import_errors`, `contacts` | `import-contacts`, `validate-import-data` | N/A |
| **Bulk export** | Export Builder | `export_jobs`, `contacts` | `export-contacts` | N/A |
| **Scheduled exports** | Scheduled Exports Manager | `scheduled_exports` | `process-scheduled-exports` (cron) | N/A |
| **Next action suggestions** | Contact Detail → Suggested Actions | `contacts`, `contact_timeline` | `suggest-next-action` | OpenAI |
| **Contact notes** | Contact Detail → Notes Tab | `contact_notes` | Direct CRUD | N/A |
| Contact tags | Contact Detail, Filter Sheet | `contacts.tags` | Direct CRUD | N/A |
| Contact assignments | Contact Detail | `contacts.assigned_to` | Direct CRUD | N/A |
| VIP marking | Contact Detail, Contact Card | `contacts.is_vip` | Direct CRUD | N/A |

### Component Mappings

| Module | Screen | Component | Backend | Notes |
|--------|--------|-----------|---------|-------|
| 7 | ContactListView | SkeletonLoader | N/A | Loading state (8 contact cards) |
| 7 | ContactListView | EmptyStateCard | N/A | "No contacts yet" + CTA |
| 7 | ContactListView | ContactCard | `contacts`, `contact_stages`, `contact_scores` | List item with stage badge, score indicator |
| 7 | ContactListView | Badge | `contact_stages.stage`, `contact_scores.classification` | Stage pill, score (hot/warm/cold) |
| 7 | ContactListView | SwipeAction | `contacts` | Left: Call/Message/Email, Right: Edit/Delete |
| 7 | ContactListView | FilterChips | Various filter fields | Stage, score, VIP, source, date range |
| 7 | ContactListView | SearchBar | Full-text search | Name, email, phone, tags |
| 7 | ContactDetail | ContactProfileCard | `contacts` | Header with photo, name, key info |
| 7 | ContactDetail | StageProgressBar | `contact_stages` | Visual stage progression |
| 7 | ContactDetail | ScoreIndicator | `contact_scores` | Lead score badge with color |
| 7 | ContactDetail | TimelineView | `contact_timeline` | Chronological activity feed |
| 7 | ContactDetail | QuickActions | Various tables | Call, message, email, create job/quote |
| 7 | ContactDetail | TabBar | N/A | Overview, Timeline, Notes, Related |
| 7 | ContactEditSheet | Form Fields | `contacts` | Standard + custom fields |
| 7 | ContactEditSheet | CustomFieldBuilder | `contact_custom_fields`, `contact_custom_field_values` | Dynamic field renderer |
| 7 | ContactEditSheet | Avatar Upload | Storage | Profile photo upload |
| 7 | StageChangeSheet | SegmentedControl | `contact_stages` | Stage selector |
| 7 | StageChangeSheet | ConfirmationDialog | N/A | Confirm stage downgrade |
| 7 | ScoreDetailSheet | ScoreBreakdownCard | `contact_scores` | Detailed score breakdown |
| 7 | ScoreDetailSheet | ProgressBar | `contact_scores.score_breakdown` | Progress per scoring factor |
| 7 | DuplicateDetector | DuplicateCard | `contacts` | Side-by-side comparison with confidence % |
| 7 | DuplicateDetector | SwipeAction | N/A | Swipe to dismiss false positive |
| 7 | MergePreview | ContactComparisonCard | `contacts` | Field-by-field comparison |
| 7 | MergePreview | ConfirmationDialog | N/A | Confirm merge action |
| 7 | SegmentBuilder | FilterBuilder | `contact_segments` | Drag-drop filter logic builder |
| 7 | SegmentBuilder | LiveCountBadge | Real-time calculation | Updates as filters change |
| 7 | SegmentList | SegmentCard | `contact_segments` | Segment name with count badge |
| 7 | ImportWizard | FileUploadZone | N/A | Drag-drop file upload |
| 7 | ImportWizard | FieldMapper | `import_jobs` | Drag columns to fields |
| 7 | ImportWizard | ValidationPreview | `import_errors` | Error list before import |
| 7 | ImportWizard | ProgressBar | `import_jobs` | Real-time import progress |
| 7 | ImportResults | ResultsSummaryCard | `import_jobs` | Success/error counts |
| 7 | ImportResults | ErrorDownloadButton | `import_errors` | Download error report |
| 7 | ExportBuilder | FieldSelector | N/A | Drag to reorder export columns |
| 7 | ExportBuilder | FormatSelector | N/A | CSV, Excel, vCard |
| 7 | ExportBuilder | FilterSelector | Various filter fields | Apply filters to export |
| 7 | CustomFieldsManager | CustomFieldCard | `contact_custom_fields` | Field definition card |
| 7 | CustomFieldsManager | FieldTypeSelector | N/A | Text, number, date, dropdown, etc. |
| 7 | CustomFieldsManager | SwipeAction | `contact_custom_fields` | Edit/delete custom field |
| 7 | ContactNotes | NoteCard | `contact_notes` | Note with timestamp + author |
| 7 | ContactNotes | RichTextEditor | N/A | Rich text with formatting |
| 7 | ContactNotes | @MentionSelector | `users` | Tag team members |

---

## Module 9: Notifications System (Enhanced)

| Product Feature | UI Surfaces | Backend Tables | Edge Functions | External APIs |
|-----------------|-------------|----------------|----------------|---------------|
| **Notification preferences** | Settings → Notifications → Grid | `notification_preferences` | Direct CRUD | N/A |
| **Channel-specific preferences** | Notification Grid (columns: In-App, Email, SMS, Push) | `notification_preferences` | Direct CRUD | N/A |
| **Notification types** | Notification Grid (rows: per event type) | `notification_preferences.notification_type` | N/A | N/A |
| **Do Not Disturb schedule** | Settings → Notifications → DND Schedule | `notification_preferences.dnd_schedule` | Direct CRUD | N/A |
| **Important-only mode** | Settings → Notifications → Important Only Toggle | `notification_preferences.important_only_mode` | Direct CRUD | N/A |
| **Digest delivery** | Settings → Notifications → Digest Settings | `notification_preferences.digest_frequency` | `send-notification-digest` (cron) | N/A |
| **Notification history** | Notifications Screen | `notification_delivery_log` | Direct SQL | N/A |
| **Delivery status tracking** | Notification History Card | `notification_delivery_log.status` | Direct SQL | N/A |
| Rich notifications | Native OS notifications | `notification_delivery_log` | `send-push-notification` | FCM, APNs |
| Mark as read | Notification History | `notification_delivery_log.read_at` | `mark-notification-read` | N/A |
| Clear all notifications | Notification History → Actions | `notification_delivery_log` | `clear-all-notifications` | N/A |
| Notification filters | Notification History → Filter Sheet | `notification_delivery_log` | Direct SQL | N/A |

### Component Mappings

| Module | Screen | Component | Backend | Notes |
|--------|--------|-----------|---------|-------|
| 9 | NotificationSettings | PreferenceGrid | `notification_preferences` | Matrix: rows (event types) × columns (channels) |
| 9 | NotificationSettings | ToggleSwitch | `notification_preferences` | Per cell in grid |
| 9 | NotificationSettings | SectionHeader | N/A | Group headers (Jobs, Bookings, Messages, etc.) |
| 9 | NotificationSettings | QuickToggle | N/A | Tap column/row header to toggle all in that column/row |
| 9 | DNDSchedule | TimeRangePicker | `notification_preferences.dnd_schedule` | Start/end time per day |
| 9 | DNDSchedule | DaySelector | `notification_preferences.dnd_schedule` | Checkboxes for days of week |
| 9 | DNDSchedule | QuickActions | N/A | "DND until morning", "DND for 1 hour" |
| 9 | DigestSettings | SegmentedControl | `notification_preferences.digest_frequency` | Never, Daily, Weekly |
| 9 | DigestSettings | TimePicker | `notification_preferences.digest_time` | Delivery time for digests |
| 9 | NotificationHistory | SkeletonLoader | N/A | Loading state (8 notification cards) |
| 9 | NotificationHistory | EmptyStateCard | N/A | "No notifications" or "All caught up!" |
| 9 | NotificationHistory | NotificationHistoryCard | `notification_delivery_log` | Notification with delivery status badge |
| 9 | NotificationHistory | Badge | `notification_delivery_log.status` | Sent, Delivered, Failed, Opened |
| 9 | NotificationHistory | SwipeAction | N/A | Swipe to mark read, archive, or take action |
| 9 | NotificationHistory | FilterChips | `notification_delivery_log` | Unread, Important, By channel, By type |
| 9 | NotificationHistory | ClearAllButton | N/A | Clear all read notifications |
| 9 | NotificationPreview | NotificationPreview | N/A | Preview how notification will look (iOS/Android style) |

---

## Module 10: Import / Export

| Product Feature | UI Surfaces | Backend Tables | Edge Functions | External APIs |
|-----------------|-------------|----------------|----------------|---------------|
| **Bulk import wizard** | Import Wizard (multi-step) | `import_jobs`, `import_errors` | `import-contacts`, `import-jobs`, `import-bookings`, `import-invoices`, `import-payments` | N/A |
| **File upload** | Import Wizard → Upload Step | N/A | Storage upload | N/A |
| **Field mapping** | Import Wizard → Mapping Step | `import_jobs.field_mapping` | N/A | N/A |
| **AI field auto-mapping** | Import Wizard → Mapping Step | N/A | `suggest-field-mapping` | OpenAI |
| **Validation preview** | Import Wizard → Validation Step | `import_errors` | `validate-import-data` | N/A |
| **Import execution** | Import Wizard → Progress | `import_jobs` | Type-specific import function | N/A |
| **Import results** | Import Results Screen | `import_jobs`, `import_errors` | Direct SQL | N/A |
| **Error report download** | Import Results → Download Button | `import_errors` | Generate CSV | N/A |
| **Import undo** | Import Results → Undo Button (if <24h) | `import_jobs` | `undo-import` | N/A |
| **Bulk export builder** | Export Builder | `export_jobs` | Type-specific export function | N/A |
| **Field selection** | Export Builder → Fields Step | N/A | N/A | N/A |
| **Filter selection** | Export Builder → Filters Step | Various filter fields | N/A | N/A |
| **Format selection** | Export Builder → Format Step | `export_jobs.format` | N/A | N/A |
| **Export execution** | Export Builder → Progress | `export_jobs` | `export-contacts`, `export-jobs`, `export-bookings`, `export-invoices`, `export-payments` | N/A |
| **Export download** | Export History | `export_jobs.file_url` | Direct download | N/A |
| **Scheduled exports** | Scheduled Exports Manager | `scheduled_exports` | `process-scheduled-exports` (cron) | N/A |
| **Export history** | Export History Screen | `export_jobs` | Direct SQL | N/A |
| **GDPR data requests** | GDPR Requests Dashboard | `gdpr_requests` | `process-gdpr-export`, `process-gdpr-deletion` | N/A |
| Google Contacts sync | Contact List → Import → Google | `import_jobs` | `import-google-contacts` | Google People API |
<!-- REMOVED: Outlook Contacts sync - Removed per decision matrix 2025-11-05 -->
| CSV import | Import Wizard | `import_jobs` | `import-contacts` | N/A |
| Excel import | Import Wizard | `import_jobs` | `import-contacts` | N/A |
| vCard import | Import Wizard | `import_jobs` | `import-contacts` | N/A |

### Component Mappings

| Module | Screen | Component | Backend | Notes |
|--------|--------|-----------|---------|-------|
| 10 | ImportWizard | MultiStepWizard | N/A | Upload → Map → Validate → Import → Results |
| 10 | ImportWizard | FileUploadZone | N/A | Drag-drop or click to upload |
| 10 | ImportWizard | FileValidator | N/A | Check file type, size, structure |
| 10 | ImportWizard | FieldMapper | `import_jobs.field_mapping` | Drag columns to fields |
| 10 | ImportWizard | AutoMapButton | N/A | AI suggests mappings |
| 10 | ImportWizard | ValidationPreview | `import_errors` | Error/warning list before import |
| 10 | ImportWizard | ErrorQuickFix | N/A | Edit value inline to fix error |
| 10 | ImportWizard | ImportProgressBar | `import_jobs` | Real-time progress (X of Y rows) |
| 10 | ImportWizard | ProgressBar | `import_jobs.progress` | Visual progress indicator |
| 10 | ImportResults | ResultsSummaryCard | `import_jobs` | Success/error counts, duration |
| 10 | ImportResults | ErrorList | `import_errors` | List of errors with row numbers |
| 10 | ImportResults | ErrorDownloadButton | N/A | Download error report CSV |
| 10 | ImportResults | ViewContactsButton | N/A | Navigate to imported contacts |
| 10 | ImportResults | UndoButton | N/A | Visible if import <24h old |
| 10 | ExportBuilder | BottomSheet | N/A | Compact export configuration |
| 10 | ExportBuilder | FilterSelector | Various filter fields | Apply filters to export |
| 10 | ExportBuilder | FieldSelector | N/A | Checkboxes + drag to reorder |
| 10 | ExportBuilder | FormatSelector | `export_jobs.format` | CSV, Excel, vCard radio buttons |
| 10 | ExportBuilder | ProgressBar | `export_jobs` | Real-time export progress |
| 10 | ExportBuilder | DownloadButton | N/A | Download when ready |
| 10 | ScheduledExportsManager | SkeletonLoader | N/A | Loading state (5 cards) |
| 10 | ScheduledExportsManager | EmptyStateCard | N/A | "Set up first export" + CTA |
| 10 | ScheduledExportsManager | ScheduledExportCard | `scheduled_exports` | Frequency, filters, format |
| 10 | ScheduledExportsManager | SwipeAction | `scheduled_exports` | Edit, Delete, Disable |
| 10 | ScheduledExportsManager | CreateButton | N/A | FAB to create new scheduled export |
| 10 | ScheduledExportsManager | TestButton | N/A | "Send Test Export Now" |
| 10 | ExportHistory | SkeletonLoader | N/A | Loading state (8 cards) |
| 10 | ExportHistory | EmptyStateCard | N/A | "No exports yet" |
| 10 | ExportHistory | ExportJobCard | `export_jobs` | File name, size, date, status |
| 10 | ExportHistory | DownloadButton | `export_jobs.file_url` | Download link (if not expired) |
| 10 | ExportHistory | FilterChips | `export_jobs.data_type` | Contacts, Jobs, Bookings, Invoices, Payments |
| 10 | GDPRDashboard | SkeletonLoader | N/A | Loading state (5 cards) |
| 10 | GDPRDashboard | EmptyStateCard | N/A | "No GDPR requests" ✓ |
| 10 | GDPRDashboard | GDPRRequestCard | `gdpr_requests` | Request type, status, date, contact info |
| 10 | GDPRDashboard | StatusBadge | `gdpr_requests.status` | Pending, Approved, Completed, Rejected |
| 10 | GDPRDashboard | ApproveButton | N/A | Approve data export/deletion request |
| 10 | GDPRDashboard | RejectButton | N/A | Reject request with reason |
| 10 | GDPRDashboard | ConfirmationDialog | N/A | Confirm action |

---

## Automations Summary (Enhanced Modules)

### Cron Jobs

| Function | Schedule | Purpose | Modules |
|----------|----------|---------|---------|
| `calculate-contact-score` | Daily at 3 AM | Recalculate lead scores for all active leads | Contacts/CRM |
| `refresh-dynamic-segments` | Every 6 hours | Update dynamic segment membership | Contacts/CRM |
| `identify-at-risk-contacts` | Daily at 8 AM | Flag contacts with no activity 60+ days | Contacts/CRM |
| `process-scheduled-exports` | Hourly | Execute scheduled exports | Import/Export |
| `send-notification-digest` | User-configured | Send daily/weekly notification digests | Notifications |
| `cleanup-expired-exports` | Daily at 2 AM | Delete export files >7 days old | Import/Export |

### Triggers

| Event | Action | Purpose | Modules |
|-------|--------|---------|---------|
| Contact created | Calculate initial lead score | Immediate scoring for new contacts | Contacts/CRM |
| Contact stage changed | Log to `contact_stages`, send notification | Track stage history | Contacts/CRM |
| Import job completed | Send email notification with results | Notify user of import completion | Import/Export |
| Contact activity recorded | Update contact score | Real-time score adjustments | Contacts/CRM |
| GDPR request approved | Execute data export or deletion | Compliance automation | Import/Export |
| Export job completed | Send email with download link | Notify user of export completion | Import/Export |
| Duplicate contacts detected | Create duplicate merge suggestion | Proactive data quality | Contacts/CRM |

---

## Integration Touchpoints (Enhanced Modules)

### External API Usage

| API | Purpose | Modules | Functions |
|-----|---------|---------|-----------|
| **OpenAI** | AI-powered suggestions | Contacts/CRM | `suggest-next-action`, `suggest-field-mapping` |
| **Google People API** | Google Contacts sync | Import/Export | `import-google-contacts` |
<!-- REMOVED: Microsoft Graph API (Outlook Contacts sync) - Removed per decision matrix 2025-11-05 -->
| **FCM** (Firebase Cloud Messaging) | Push notifications (Android) | Notifications | `send-push-notification` |
| **APNs** (Apple Push Notification service) | Push notifications (iOS) | Notifications | `send-push-notification` |
| **SendGrid / Mailgun** (optional) | Transactional email service | Notifications | Transactional email sending |

---

*Cross-Reference Matrix Enhancement v2.5.1 — November 2025 (Merged)*  
*This addendum adds cross-reference mappings for 4 expanded modules with 100+ new feature mappings*


---



---

## API Contract Definitions

**Purpose:** Complete request/response specifications for top Edge Functions.

### Authentication APIs

#### POST /auth/signup
**Purpose:** Create new user account

**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!",
  "org_name": "ABC Plumbing",
  "industry_profile": "trade",
  "phone": "+441234567890"
}
```

**Response (Success 201):**
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "created_at": "2025-11-02T10:30:00Z"
  },
  "org": {
    "id": "uuid",
    "name": "ABC Plumbing",
    "industry_profile": "trade"
  },
  "session": {
    "access_token": "jwt_token",
    "refresh_token": "jwt_refresh_token",
    "expires_at": "2025-11-02T22:30:00Z"
  }
}
```

**Errors:**
- `400` — Invalid email format, weak password, or missing required fields
- `409` — Email already registered
- `429` — Too many signup attempts (rate limit)

---

### Messaging APIs

#### POST /send-message
**Purpose:** Send outbound message via any channel

**Authentication:** Bearer token required

**Request:**
```json
{
  "thread_id": "uuid",
  "contact_id": "uuid",
  "channel": "sms|whatsapp|email|instagram|facebook",
  "body": "Hi John, your quote is ready!",
  "media_urls": ["https://storage/image.jpg"],
  "scheduled_for": "2025-11-02T14:00:00Z" // Optional
}
```

**Response (Success 200):**
```json
{
  "message_id": "uuid",
  "thread_id": "uuid",
  "status": "sent|scheduled",
  "sent_at": "2025-11-02T10:35:00Z",
  "channel": "sms",
  "external_id": "twilio_message_id"
}
```

**Errors:**
- `400` — Invalid channel or missing required fields
- `401` — Unauthorized (invalid/expired token)
- `403` — Channel not configured (e.g., WhatsApp not connected)
- `404` — Contact or thread not found
- `429` — Rate limit exceeded
- `500` — External API failure (Twilio/Meta)

**Rate Limits:**
- 100 messages per minute per organization
- 1000 messages per hour per organization

---

### Job Management APIs

#### POST /create-job
**Purpose:** Create new job

**Authentication:** Bearer token required

**Request:**
```json
{
  "contact_id": "uuid",
  "title": "Kitchen Sink Repair",
  "description": "Replace leaking faucet and check pipes",
  "service_type": "Plumbing",
  "scheduled_date": "2025-11-05",
  "scheduled_time": "10:00",
  "address": "123 Main St, London",
  "postcode": "SW1A 1AA",
  "status": "pending",
  "priority": "normal|high|urgent",
  "estimated_cost": 150.00,
  "deposit_required": true,
  "deposit_amount": 50.00,
  "notes": "Customer mentioned previous leak last year"
}
```

**Response (Success 201):**
```json
{
  "job_id": "uuid",
  "job_number": "JOB-001234",
  "status": "pending",
  "created_at": "2025-11-02T10:40:00Z",
  "contact": {
    "id": "uuid",
    "name": "John Smith",
    "phone": "+441234567890"
  },
  "notifications_sent": ["sms", "email"]
}
```

**Errors:**
- `400` — Invalid date, missing required fields, or invalid postcode
- `404` — Contact not found
- `409` — Time slot conflict (if checking calendar integration)

---

### Payment APIs

#### POST /create-payment-link
**Purpose:** Generate Stripe payment link for invoice

**Authentication:** Bearer token required

**Request:**
```json
{
  "invoice_id": "uuid",
  "amount": 250.00,
  "currency": "GBP",
  "description": "Kitchen Sink Repair - Invoice #INV-001234",
  "customer_email": "john@example.com",
  "success_url": "https://app.swiftlead.co/payments/success",
  "cancel_url": "https://app.swiftlead.co/payments/cancel"
}
```

**Response (Success 200):**
```json
{
  "payment_link_id": "uuid",
  "stripe_payment_link": "https://checkout.stripe.com/pay/cs_test_xxxxx",
  "expires_at": "2025-11-03T10:40:00Z",
  "short_url": "https://swft.link/p/abc123"
}
```

**Errors:**
- `400` — Invalid amount or currency
- `404` — Invoice not found
- `403` — Stripe not connected for organization
- `500` — Stripe API failure

---

### AI APIs

#### POST /ai-auto-reply
**Purpose:** Generate AI response to incoming message

**Authentication:** Bearer token required (service key for webhook calls)

**Request:**
```json
{
  "thread_id": "uuid",
  "message_id": "uuid",
  "message_body": "Hi, do you service my area? Postcode is SW1A 1AA",
  "contact_context": {
    "name": "John Smith",
    "previous_jobs": 0,
    "last_interaction": null
  },
  "org_context": {
    "business_name": "ABC Plumbing",
    "service_areas": ["SW1", "SW2", "SW3"],
    "ai_tone": "friendly",
    "working_hours": "Mon-Fri 8am-6pm"
  }
}
```

**Response (Success 200):**
```json
{
  "should_reply": true,
  "suggested_response": "Hi John! Yes, we cover SW1A. We're ABC Plumbing and we can help with any plumbing needs. Would you like to book an appointment?",
  "confidence_score": 0.92,
  "intent_detected": "service_area_inquiry",
  "booking_offered": true,
  "human_handover_recommended": false
}
```

**Response (Handover Required 200):**
```json
{
  "should_reply": false,
  "suggested_response": null,
  "confidence_score": 0.45,
  "intent_detected": "complex_technical_question",
  "human_handover_recommended": true,
  "handover_reason": "Question requires technical expertise"
}
```

**Errors:**
- `400` — Missing required context
- `500` — OpenAI API failure
- `503` — AI service temporarily unavailable

---

## Data Flow Diagrams

**Purpose:** Visual representation of key system flows.

### User Message Flow (Inbound)

```
1. Twilio/Meta Webhook → Edge Function: process-webhook
   ↓
2. Parse message, extract contact info
   ↓
3. INSERT INTO messages (channel, body, contact_id)
   ↓
4. Check if AI should respond → Edge Function: ai-auto-reply
   ↓
5a. [AI Responds] → Edge Function: send-message → Twilio/Meta
5b. [Human Required] → Send push notification to user
   ↓
6. UPDATE message_threads (last_message, unread_count)
   ↓
7. Broadcast real-time update via Supabase Realtime
   ↓
8. Client receives update → UI updates conversation list
```

### Job Creation Flow

```
1. User taps "Create Job" → JobCreateScreen
   ↓
2. User fills form → Validation (client-side)
   ↓
3. Submit → Edge Function: create-job
   ↓
4. INSERT INTO jobs (contact_id, title, status, etc.)
   ↓
5. [Optional] INSERT INTO calendar_events (if scheduled)
   ↓
6. [Optional] Edge Function: send-job-confirmation (SMS/Email)
   ↓
7. Return job object with ID
   ↓
8. Client navigates to JobDetailScreen
   ↓
9. Supabase Realtime broadcasts job update to team members
```

### Payment Flow (Customer Pays Invoice)

```
1. Customer clicks payment link → Stripe Checkout
   ↓
2. Customer completes payment → Stripe processes
   ↓
3. Stripe sends webhook → Edge Function: handle-stripe-webhook
   ↓
4. Verify webhook signature
   ↓
5. UPDATE invoices SET status='paid', paid_at=NOW()
   ↓
6. INSERT INTO payments (invoice_id, amount, stripe_id)
   ↓
7. Edge Function: send-payment-confirmation → Email/SMS to customer
   ↓
8. Edge Function: send-payment-notification → Push to business owner
   ↓
9. Supabase Realtime broadcasts update
   ↓
10. Client UI shows "Payment Received" toast + confetti animation
```

### Real-Time Subscription Flow

```
1. Client opens InboxScreen
   ↓
2. Subscribe to messages table changes:
   supabase.from('messages')
     .on('INSERT', handleNewMessage)
     .on('UPDATE', handleMessageUpdate)
     .subscribe()
   ↓
3. New message arrives via webhook
   ↓
4. Database INSERT triggers Supabase Realtime broadcast
   ↓
5. Client receives real-time event
   ↓
6. handleNewMessage(payload) → Update local state
   ↓
7. UI updates with new message (with animation)
   ↓
8. [If thread is open] Mark message as read immediately
```

---

## Integration Test Scenarios

**Purpose:** End-to-end test cases for critical user flows.

### Test Scenario 1: New User Onboarding
**Goal:** Verify complete signup to first job creation flow

**Steps:**
1. User taps "Sign Up"
2. Enters email, password, business name, phone
3. Selects industry profile (Trade/Salon/Professional)
4. Completes onboarding wizard
5. Reaches Home Dashboard
6. Taps "Create Job" quick action
7. Creates first job with contact
8. Receives confirmation toast
9. Job appears in Jobs list

**Expected Results:**
- ✅ User account created in `users` table
- ✅ Organization created in `organizations` table
- ✅ Welcome email sent
- ✅ Default settings initialized
- ✅ Job created with correct status
- ✅ Contact created and linked to job
- ✅ Dashboard shows correct metrics (1 active job)

**Pass Criteria:** All steps complete without errors, data persists correctly

---

### Test Scenario 2: Inbound Message with AI Response
**Goal:** Verify AI auto-reply system handles inquiry correctly

**Steps:**
1. Send SMS to Twilio number: "Do you do emergency repairs?"
2. Webhook received by `process-webhook`
3. AI analyzes message
4. AI generates response
5. Response sent via Twilio
6. Message thread created/updated
7. User sees conversation in Inbox

**Expected Results:**
- ✅ Message inserted into `messages` table
- ✅ Thread created in `message_threads` table
- ✅ AI response generated with >0.8 confidence
- ✅ Outbound message sent successfully
- ✅ User receives push notification
- ✅ Conversation appears in Inbox with unread badge
- ✅ AI interaction logged in `ai_interactions` table

**Pass Criteria:** Response sent within 5 seconds, user can continue conversation

---

### Test Scenario 3: Job to Invoice to Payment
**Goal:** Verify complete revenue cycle from job completion to payment received

**Steps:**
1. User marks job as "Completed"
2. User creates invoice from completed job
3. User sends invoice via SMS
4. Customer clicks payment link
5. Customer completes Stripe payment
6. Webhook received
7. Invoice marked as paid
8. User receives payment notification

**Expected Results:**
- ✅ Job status updated to "completed"
- ✅ Invoice created with correct line items and total
- ✅ Payment link generated (Stripe Checkout)
- ✅ SMS sent with link
- ✅ Stripe payment processed
- ✅ Webhook verified and processed
- ✅ Invoice status updated to "paid"
- ✅ Payment record created
- ✅ Dashboard revenue metrics updated
- ✅ User receives "Payment received" notification

**Pass Criteria:** Full flow completes end-to-end, payment reconciled correctly

---

### Test Scenario 4: Calendar Sync and Booking Conflict Detection
**Goal:** Verify calendar integration and conflict detection

**Steps:**
1. User connects Google Calendar
2. OAuth flow completes
3. Calendar events sync to Swiftlead
4. User attempts to create booking at conflicting time
5. System detects conflict
6. User shown warning with options
7. User adjusts time
8. Booking created successfully
9. Event synced back to Google Calendar

**Expected Results:**
- ✅ Calendar integration created in `calendar_integrations` table
- ✅ Events imported and stored in `calendar_events` table
- ✅ Conflict detection triggers on overlapping times
- ✅ Warning shown with clear conflict details
- ✅ User can override or adjust
- ✅ Booking created with correct time
- ✅ Event pushed to Google Calendar via API
- ✅ Two-way sync maintained

**Pass Criteria:** No double-bookings allowed without explicit override

---

### Test Scenario 5: Offline Mode and Sync
**Goal:** Verify offline queue and sync when connection restored

**Steps:**
1. User opens app with internet connection
2. Data loads normally
3. User goes offline (airplane mode)
4. User creates new job
5. Job queued locally with indicator
6. User edits existing job
7. Changes queued
8. User goes back online
9. Queued actions sync automatically
10. UI updates with server confirmation

**Expected Results:**
- ✅ Offline state detected and banner shown
- ✅ New job stored in local offline queue
- ✅ Edit stored in offline queue
- ✅ Queue persisted across app restarts
- ✅ Connection restoration detected
- ✅ Queue processed in correct order
- ✅ Server creates job and returns ID
- ✅ Local job updated with server ID
- ✅ Offline banner dismissed
- ✅ Success toast shown

**Pass Criteria:** No data loss, seamless sync when online

---

### Integration Points to Test

| Integration | Test Type | Critical Flows | Success Criteria |
|-------------|-----------|----------------|------------------|
| **Twilio SMS** | Webhook → Send | Inbound SMS → AI response → Outbound SMS | Messages delivered within 5s |
| **Twilio WhatsApp** | Webhook → Send | Inbound WhatsApp → Thread → Reply | Messages delivered, media supported |
| **Meta (FB/IG)** | Webhook → Send | Inbound DM → Reply → Status update | Real-time delivery confirmation |
| **Stripe Payments** | Checkout → Webhook | Create link → Customer pays → Webhook processed | Payment reconciled correctly |
| **Google Calendar** | OAuth → Sync | Connect → Two-way sync → Conflict detection | Events match on both sides |
| **Apple Calendar** | CalDAV | Connect → Sync → Update | iOS calendar events sync |
| **OpenAI** | API Call | AI auto-reply → Quote generation → Review response | Responses <30s, >85% accuracy |
| **Supabase Realtime** | Subscribe → Broadcast | Client subscribes → Server INSERT → Client receives | Updates within 500ms |
| **Push Notifications** | FCM/APNs | Server sends → Device receives → User taps → Deep link | 95%+ delivery rate |

---
*Version 2.5.1 Enhanced Cross-Reference Matrix – November 2025 (Complete feature-to-implementation mapping with UX enhancements, global components, templates, analytics, and accessibility improvements).*


---

**Cross_Reference_Matrix_v2.5.1_10of10.md — Complete 10/10 Specification** — ready for 10/10 polish.**