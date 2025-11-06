# Model Fixes Progress
**Date:** 2025-01-27  
**Status:** 🔄 **IN PROGRESS**

---

## ✅ Completed

### Job Model (`lib/mock/mock_jobs.dart`)
- ✅ Added `orgId` field
- ✅ Fixed status enum to match backend (proposed/booked/on_the_way/in_progress/completed/cancelled)
- ✅ Fixed priority enum (urgent maps to high)
- ✅ Added all missing fields (endTime, quoteId, invoiceId, etc.)
- ✅ Renamed fields: `scheduledDate` → `startTime`, `value` → `priceEstimate`, `address` → `location`, `serviceType` → `jobType`
- ✅ Added backward compatibility getters (`address`, `scheduledDate`, `value`)
- ✅ Added `fromJson` and `toJson` methods
- ✅ Updated all mock data to use new structure
- ✅ Updated enum extensions with `backendValue` and `fromBackend` methods

---

## 🔄 In Progress

### Contact Model (`lib/mock/mock_contacts.dart`)
- [ ] Add `orgId` field
- [ ] Split `name` into `firstName` and `lastName`
- [ ] Add `address` field
- [ ] Add `customFields` field
- [ ] Add `updatedAt` field
- [ ] Add backward compatibility getter for `name`
- [ ] Add `fromJson` and `toJson` methods

### Booking Model (`lib/mock/mock_bookings.dart`)
- [ ] Add `orgId` field
- [ ] Add `serviceId` (FK) field
- [ ] Add `durationMinutes` field
- [ ] Add `confirmationStatus` field
- [ ] Add `title` and `description` fields
- [ ] Add "On My Way" fields: `onMyWayStatus`, `liveLocationUrl`, `etaMinutes`
- [ ] Rename `serviceType` → `serviceId` (FK)
- [ ] Rename `address` → `location`
- [ ] Add all other missing fields
- [ ] Add backward compatibility
- [ ] Add `fromJson` and `toJson` methods

### Invoice Model (`lib/mock/mock_payments.dart`)
- [ ] Add `orgId` field
- [ ] Add `invoiceNumber` field
- [ ] Add `taxRate` field
- [ ] Add `jobId` and `quoteId` fields
- [ ] Add `notes` field
- [ ] Add `updatedAt` field
- [ ] Add `fromJson` and `toJson` methods

### Message Model (`lib/mock/mock_messages.dart`)
- [ ] Add `orgId` field
- [ ] Replace `isInbound` bool with `direction` enum
- [ ] Add `mediaUrls` array field
- [ ] Add `readStatus` field
- [ ] Add `providerMessageId` field
- [ ] Add `aiGenerated` field
- [ ] Add `scheduledFor` field
- [ ] Add `sentAt` field
- [ ] Add `reactions` field
- [ ] Add `replyToMessageId` field
- [ ] Add `editedAt` field
- [ ] Rename `timestamp` → `createdAt`
- [ ] Replace `hasAttachment`/`attachmentUrl` with `mediaUrls` array
- [ ] Add backward compatibility
- [ ] Add `fromJson` and `toJson` methods

---

## 📋 Next Steps

1. Continue fixing Contact model
2. Continue fixing Booking model
3. Continue fixing Invoice model
4. Continue fixing Message model
5. Update all screens that use these models
6. Test compilation
7. Update Phase 1 verification report

---

**Last Updated:** 2025-01-27

