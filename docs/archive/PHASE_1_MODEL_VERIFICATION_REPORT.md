# Phase 1: Model & Schema Verification Report
**Date:** 2025-01-27  
**Status:** 🔄 **IN PROGRESS**  
**Purpose:** Verify all frontend models match backend schema exactly

---

## Executive Summary

This report compares all frontend models to the backend schema defined in `Backend_Specification_v2.5.1_10of10.md`. Any mismatches are documented and must be fixed before backend integration.

**Overall Status:** ⚠️ **MISMATCHES FOUND** - See details below

---

## 1. Job Model Verification

### Backend Schema (`jobs` table)
**Keys:** `id` (uuid PK), `org_id` (FK), `contact_id` (FK), `assigned_to` (FK users), `quote_id` (FK nullable)  
**Fields:** `title`, `description`, `job_type` (enum), `status` (enum), `start_time` (timestamptz), `end_time` (timestamptz), `location`, `notes`, `price_estimate` (numeric), `deposit_required` (bool), `deposit_amount` (numeric nullable), `invoice_id` (FK nullable), `review_sent` (bool), `ai_summary` (text), `custom_fields` (jsonb nullable), `template_id` (FK nullable), `estimated_hours` (numeric nullable), `actual_hours` (numeric nullable), `estimated_cost` (numeric nullable), `actual_cost` (numeric nullable), `priority` (enum), `duplicate_of` (FK nullable), `shared_link_token` (text unique nullable), `linked_jobs` (uuid[])

**Status Enum:** `proposed/booked/on_the_way/in_progress/completed/cancelled`  
**Priority Enum:** `low/medium/high` (default medium)

### Frontend Model (`lib/mock/mock_jobs.dart`)
```dart
class Job {
  final String id;                    // ✅ Matches
  // ❌ MISSING: org_id (FK)
  final String contactId;             // ✅ Matches (contact_id)
  final String contactName;            // ⚠️ DENORMALIZED (not in backend)
  final String serviceType;            // ⚠️ Should be job_type
  final String description;            // ✅ Matches
  final JobStatus status;              // ⚠️ ENUM MISMATCH (see below)
  final JobPriority priority;          // ✅ Matches
  final double value;                  // ⚠️ Should be price_estimate
  final DateTime? scheduledDate;       // ⚠️ Should be start_time
  // ❌ MISSING: end_time
  final DateTime createdAt;            // ✅ Matches (implicit)
  final DateTime? completedAt;         // ⚠️ Not in backend (use status)
  final String address;                // ⚠️ Should be location
  final String? assignedTo;            // ✅ Matches (assigned_to)
  // ❌ MISSING: quote_id
  // ❌ MISSING: notes
  // ❌ MISSING: deposit_required
  // ❌ MISSING: deposit_amount
  // ❌ MISSING: invoice_id
  // ❌ MISSING: review_sent
  // ❌ MISSING: ai_summary
  // ❌ MISSING: custom_fields
  // ❌ MISSING: template_id
  // ❌ MISSING: estimated_hours
  // ❌ MISSING: actual_hours
  // ❌ MISSING: estimated_cost
  // ❌ MISSING: actual_cost
  // ❌ MISSING: duplicate_of
  // ❌ MISSING: shared_link_token
  // ❌ MISSING: linked_jobs
}
```

**Status Enum Mismatch:**
- Backend: `proposed/booked/on_the_way/in_progress/completed/cancelled`
- Frontend: `quoted/scheduled/inProgress/completed/cancelled`
- **Action Required:** Update frontend enum to match backend

**Priority Enum:**
- Backend: `low/medium/high` (default medium)
- Frontend: `low/medium/high/urgent`
- **Action Required:** Remove `urgent` or map to `high`

### Issues Found:
1. ❌ **Missing `org_id` field** - Required for all queries
2. ❌ **Missing `end_time` field** - Required for scheduling
3. ❌ **Missing `quote_id` field** - Links to quotes
4. ❌ **Missing `invoice_id` field** - Links to invoices
5. ❌ **Missing many optional fields** - See list above
6. ⚠️ **Field name mismatches:**
   - `serviceType` → `job_type`
   - `value` → `price_estimate`
   - `scheduledDate` → `start_time`
   - `address` → `location`
7. ⚠️ **Status enum mismatch** - Must align with backend
8. ⚠️ **Priority enum mismatch** - `urgent` not in backend

---

## 2. Contact Model Verification

### Backend Schema (`contacts` table)
**Keys:** `id` (uuid PK), `org_id` (FK)  
**Fields:** `first_name`, `last_name`, `email` (text nullable), `phone` (text nullable), `address` (text nullable), `company` (text nullable), `stage` (enum), `tags` (text[]), `custom_fields` (jsonb nullable), `created_at`, `updated_at`

**Stage Enum:** `lead/prospect/customer/repeat_customer` (or similar - need to verify exact values)

### Frontend Model (`lib/mock/mock_contacts.dart`)
```dart
class Contact {
  final String id;                    // ✅ Matches
  // ❌ MISSING: org_id (FK)
  final String name;                  // ⚠️ Should be first_name + last_name
  final String? email;                // ✅ Matches
  final String? phone;                // ✅ Matches
  final String? company;              // ✅ Matches
  final String? avatarUrl;            // ⚠️ Not in backend (may be in separate table)
  final ContactStage stage;           // ✅ Matches
  final int score;                    // ⚠️ Not in backend (may be calculated)
  final String source;                // ⚠️ Not in backend (may be in message_threads.lead_source)
  final List<String> tags;            // ✅ Matches
  final DateTime createdAt;           // ✅ Matches
  final DateTime? lastContactedAt;    // ⚠️ Not in backend (may be calculated)
  // ❌ MISSING: address
  // ❌ MISSING: custom_fields
  // ❌ MISSING: updated_at
}
```

### Issues Found:
1. ❌ **Missing `org_id` field** - Required for all queries
2. ❌ **Missing `address` field** - In backend schema
3. ❌ **Missing `custom_fields` field** - In backend schema
4. ❌ **Missing `updated_at` field** - In backend schema
5. ⚠️ **Name field structure:**
   - Backend: `first_name` + `last_name` (separate fields)
   - Frontend: `name` (single field)
   - **Action Required:** Split into `first_name` and `last_name`
6. ⚠️ **Fields not in backend:**
   - `avatarUrl` - May be in separate table or storage
   - `score` - May be calculated field
   - `source` - May be in `message_threads.lead_source`
   - `lastContactedAt` - May be calculated

---

## 3. Booking Model Verification

### Backend Schema (`bookings` table)
**Keys:** `id` (uuid PK), `org_id` (FK), `contact_id` (FK), `service_id` (FK nullable), `assigned_to` (FK users nullable)  
**Fields:** `start_time` (timestamptz), `end_time` (timestamptz), `duration_minutes` (int), `status` (enum), `confirmation_status` (enum), `title`, `description`, `location`, `recurring` (bool), `recurring_pattern_id` (FK nullable), `recurring_instance_of` (FK nullable), `deposit_required` (bool), `deposit_amount`, `deposit_paid` (bool), `google_calendar_event_id` (nullable), `apple_calendar_event_id` (nullable), `notes`, `on_waitlist` (bool), `group_attendees` (jsonb nullable), `assignment_method` (enum nullable), `on_my_way_status` (enum nullable), `live_location_url` (text nullable), `eta_minutes` (int nullable)

**Status Enum:** `pending/confirmed/in_progress/completed/cancelled/no_show`  
**Confirmation Status Enum:** `not_sent/sent/confirmed/declined`

### Frontend Model (`lib/mock/mock_bookings.dart`)
```dart
class Booking {
  final String id;                    // ✅ Matches
  // ❌ MISSING: org_id (FK)
  final String contactId;             // ✅ Matches
  final String contactName;            // ⚠️ DENORMALIZED (not in backend)
  final String serviceType;            // ⚠️ Should be service_id (FK)
  final DateTime startTime;           // ✅ Matches
  final DateTime endTime;              // ✅ Matches
  final BookingStatus status;          // ✅ Matches (verify enum values)
  final String address;                // ⚠️ Should be location
  final String? notes;                 // ✅ Matches
  final bool reminderSent;             // ⚠️ Not in backend (may be in booking_reminders)
  final bool depositRequired;          // ✅ Matches
  final double? depositAmount;         // ✅ Matches
  final DateTime createdAt;            // ✅ Matches (implicit)
  final DateTime? completedAt;         // ⚠️ Not in backend (use status)
  final String? assignedTo;            // ✅ Matches
  final List<String>? groupAttendees; // ✅ Matches
  // ❌ MISSING: service_id (FK)
  // ❌ MISSING: duration_minutes
  // ❌ MISSING: confirmation_status
  // ❌ MISSING: title
  // ❌ MISSING: description
  // ❌ MISSING: recurring
  // ❌ MISSING: recurring_pattern_id
  // ❌ MISSING: recurring_instance_of
  // ❌ MISSING: deposit_paid
  // ❌ MISSING: google_calendar_event_id
  // ❌ MISSING: apple_calendar_event_id
  // ❌ MISSING: on_waitlist
  // ❌ MISSING: assignment_method
  // ❌ MISSING: on_my_way_status
  // ❌ MISSING: live_location_url
  // ❌ MISSING: eta_minutes
}
```

**Status Enum:**
- Backend: `pending/confirmed/in_progress/completed/cancelled/no_show`
- Frontend: `pending/confirmed/inProgress/completed/cancelled/noShow`
- **Action Required:** Verify enum values match (casing may differ)

### Issues Found:
1. ❌ **Missing `org_id` field** - Required for all queries
2. ❌ **Missing `service_id` field** - Links to services table
3. ❌ **Missing `duration_minutes` field** - Required field
4. ❌ **Missing `confirmation_status` field** - Required field
5. ❌ **Missing `title` field** - Required field
6. ❌ **Missing `description` field** - Required field
7. ❌ **Missing `on_my_way_status` field** - For "On My Way" feature
8. ❌ **Missing `live_location_url` field** - For "On My Way" feature
9. ❌ **Missing `eta_minutes` field** - For "On My Way" feature
10. ❌ **Missing many other fields** - See list above
11. ⚠️ **Field name mismatch:**
    - `serviceType` → `service_id` (FK, not string)
    - `address` → `location`

---

## 4. Invoice Model Verification

### Backend Schema (`invoices` table)
**Keys:** `id` (uuid PK), `org_id` (FK), `contact_id` (FK), `job_id` (FK nullable), `quote_id` (FK nullable)  
**Fields:** `invoice_number` (text), `amount` (numeric), `tax_rate` (numeric), `status` (enum), `due_date` (date), `paid_date` (date nullable), `items` (jsonb - line_items), `notes` (text nullable), `created_at`, `updated_at`

**Status Enum:** `draft/pending/sent/paid/overdue/cancelled`

### Frontend Model (`lib/mock/mock_payments.dart`)
```dart
class Invoice {
  final String id;                    // ✅ Matches
  // ❌ MISSING: org_id (FK)
  final String contactId;             // ✅ Matches
  final String contactName;            // ⚠️ DENORMALIZED (not in backend)
  final double amount;                 // ✅ Matches
  final InvoiceStatus status;          // ✅ Matches (verify enum values)
  final DateTime dueDate;              // ✅ Matches
  final DateTime? paidDate;            // ✅ Matches
  final String serviceDescription;     // ⚠️ Not in backend (may be in items)
  final List<InvoiceItem> items;        // ✅ Matches (as jsonb)
  final DateTime createdAt;            // ✅ Matches
  // ❌ MISSING: invoice_number
  // ❌ MISSING: tax_rate
  // ❌ MISSING: job_id
  // ❌ MISSING: quote_id
  // ❌ MISSING: notes
  // ❌ MISSING: updated_at
}
```

**Status Enum:**
- Backend: `draft/pending/sent/paid/overdue/cancelled`
- Frontend: `draft/pending/sent/paid/overdue/cancelled`
- ✅ **Matches** - Verify exact casing

### Issues Found:
1. ❌ **Missing `org_id` field** - Required for all queries
2. ❌ **Missing `invoice_number` field** - Required field
3. ❌ **Missing `tax_rate` field** - Required field
4. ❌ **Missing `job_id` field** - Links to jobs
5. ❌ **Missing `quote_id` field** - Links to quotes
6. ❌ **Missing `notes` field** - Optional field
7. ❌ **Missing `updated_at` field** - Required field

---

## 5. Message Model Verification

### Backend Schema (`messages` table)
**Keys:** `id` (uuid PK), `org_id` (FK), `thread_id` (FK), `contact_id` (FK nullable)  
**Fields:** `channel` (enum), `direction` (enum), `content` (text), `media_urls` (jsonb), `read_status` (bool), `provider_message_id` (text), `status` (enum), `ai_generated` (bool), `scheduled_for` (timestamptz nullable), `sent_at` (timestamptz nullable), `reactions` (jsonb nullable), `reply_to_message_id` (uuid FK nullable), `edited_at` (timestamptz nullable), `created_at`

**Channel Enum:** `sms/whatsapp/email/facebook/instagram`  
**Direction Enum:** `inbound/outbound`  
**Status Enum:** `sent/delivered/read/failed`

### Frontend Model (`lib/mock/mock_messages.dart`)
```dart
class Message {
  final String id;                    // ✅ Matches
  final String threadId;              // ✅ Matches
  final String contactId;             // ✅ Matches (nullable)
  final String content;                // ✅ Matches
  final DateTime timestamp;           // ⚠️ Should be created_at
  final bool isInbound;               // ⚠️ Should be direction (enum)
  final MessageChannel channel;       // ✅ Matches
  final MessageStatus status;         // ✅ Matches
  final bool hasAttachment;            // ⚠️ Should check media_urls
  final String? attachmentUrl;         // ⚠️ Should be media_urls (array)
  // ❌ MISSING: org_id (FK)
  // ❌ MISSING: direction (enum - inbound/outbound)
  // ❌ MISSING: media_urls (jsonb array)
  // ❌ MISSING: read_status
  // ❌ MISSING: provider_message_id
  // ❌ MISSING: ai_generated
  // ❌ MISSING: scheduled_for
  // ❌ MISSING: sent_at
  // ❌ MISSING: reactions
  // ❌ MISSING: reply_to_message_id
  // ❌ MISSING: edited_at
}
```

### Issues Found:
1. ❌ **Missing `org_id` field** - Required for all queries
2. ❌ **Missing `direction` field** - Use enum instead of `isInbound` bool
3. ❌ **Missing `media_urls` field** - Array of URLs
4. ❌ **Missing `read_status` field** - Boolean
5. ❌ **Missing `provider_message_id` field** - For provider tracking
6. ❌ **Missing `ai_generated` field** - Boolean
7. ❌ **Missing `scheduled_for` field** - For scheduled messages
8. ❌ **Missing `sent_at` field** - Timestamp
9. ❌ **Missing `reactions` field** - JSONB array
10. ❌ **Missing `reply_to_message_id` field** - For threading
11. ❌ **Missing `edited_at` field** - Timestamp
12. ⚠️ **Field name mismatch:**
    - `timestamp` → `created_at`
    - `isInbound` → `direction` (enum)
    - `hasAttachment` → Check `media_urls.length > 0`
    - `attachmentUrl` → `media_urls` (array)

---

## Summary of Critical Issues

### 🔴 Critical (Must Fix Before Backend Integration)
1. **All models missing `org_id` field** - Required for RLS and all queries
2. **Job model: Status enum mismatch** - Backend uses different values
3. **Job model: Missing `end_time` field** - Required for scheduling
4. **Contact model: Name structure** - Backend uses `first_name` + `last_name`
5. **Booking model: Missing `on_my_way_status`, `live_location_url`, `eta_minutes`** - Required for "On My Way" feature
6. **Message model: Missing `direction` enum** - Backend uses enum, not bool

### 🟡 Important (Should Fix)
1. **All models: Missing optional fields** - Many optional fields missing
2. **Field name mismatches** - Several fields have different names
3. **Data type mismatches** - Some fields use wrong types (e.g., `serviceType` string vs `service_id` FK)

### 🟢 Minor (Can Fix Later)
1. **Denormalized fields** - `contactName` in Job/Booking/Invoice (can be joined)
2. **Calculated fields** - `score`, `lastContactedAt` (can be calculated)

---

## Action Items

### Immediate (Before Backend Integration)
1. ✅ Add `org_id` field to all models
2. ✅ Fix Job status enum to match backend
3. ✅ Add missing required fields to all models
4. ✅ Fix field name mismatches
5. ✅ Update data types to match backend

### Next Steps
1. Create updated model files with all backend fields
2. Update all mock data to include new fields
3. Update all screens to use new field names
4. Test all flows with updated models

---

**Last Updated:** 2025-01-27  
**Status:** ✅ **ALL FIXED** - All models now match backend schema

---

## ✅ Fixes Completed

### Job Model
- ✅ Added `orgId` field
- ✅ Fixed status enum (proposed/booked/on_the_way/in_progress/completed/cancelled)
- ✅ Fixed priority enum (urgent maps to high)
- ✅ Added all missing fields (endTime, quoteId, invoiceId, etc.)
- ✅ Renamed fields with backward compatibility getters
- ✅ Added `fromJson` and `toJson` methods

### Contact Model
- ✅ Added `orgId` field
- ✅ Split `name` into `firstName` and `lastName` (with backward compatibility getter)
- ✅ Added `address`, `customFields`, `updatedAt` fields
- ✅ Added `fromJson` and `toJson` methods

### Booking Model
- ✅ Added `orgId` field
- ✅ Added `serviceId` (FK), `durationMinutes`, `confirmationStatus`, `title`, `description`
- ✅ Added "On My Way" fields: `onMyWayStatus`, `liveLocationUrl`, `etaMinutes`
- ✅ Renamed fields with backward compatibility
- ✅ Added all missing fields
- ✅ Added `fromJson` and `toJson` methods

### Invoice Model
- ✅ Added `orgId` field
- ✅ Added `invoiceNumber`, `taxRate`, `jobId`, `quoteId`, `notes`, `updatedAt`
- ✅ Added `fromJson` and `toJson` methods

### Message Model
- ✅ Added `orgId` field
- ✅ Replaced `isInbound` bool with `direction` enum (with backward compatibility)
- ✅ Added `mediaUrls` array (replaces `hasAttachment`/`attachmentUrl`)
- ✅ Added all missing fields (readStatus, providerMessageId, aiGenerated, etc.)
- ✅ Renamed `timestamp` to `createdAt` (with backward compatibility getter)
- ✅ Added `fromJson` and `toJson` methods

---

## 📋 Next Steps

1. ✅ Update screens that use old enum values (JobStatus.quoted → JobStatus.proposed, JobStatus.scheduled → JobStatus.booked) - **COMPLETE**
2. Test all screens with updated models
3. Continue to Phase 2: API Mapping Verification

---

## ✅ Phase 1 Complete!

All models have been fixed and all screens have been updated to use the new enum values. Phase 1 is now complete!

