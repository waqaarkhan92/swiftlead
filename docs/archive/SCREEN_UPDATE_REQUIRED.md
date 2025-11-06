# Screen Updates Required After Model Fixes
**Date:** 2025-01-27  
**Status:** ⚠️ **ACTION REQUIRED**

---

## Summary

After updating models to match backend schema, the following screens need updates:

### Job Model Changes
- ✅ **Backward Compatible:** `job.value`, `job.address`, `job.scheduledDate`, `job.serviceType` (getters added)
- ⚠️ **Enum Updates Required:**
  - `JobStatus.quoted` → `JobStatus.proposed`
  - `JobStatus.scheduled` → `JobStatus.booked`
  - `JobStatus.inProgress` → `JobStatus.inProgress` (no change)

### Contact Model Changes
- ✅ **Backward Compatible:** `contact.name` (getter added)
- ⚠️ **Field Updates:**
  - `contact.name` → Use `contact.firstName` and `contact.lastName` (or keep using `contact.name` getter)
  - New fields available: `contact.address`, `contact.customFields`, `contact.updatedAt`

---

## Files Requiring Updates

### Job Status Enum Updates
1. `lib/screens/jobs/jobs_screen.dart`
2. `lib/screens/jobs/job_detail_screen.dart`
3. `lib/screens/jobs/job_search_screen.dart`
4. `lib/screens/home/home_screen.dart`
5. `lib/screens/calendar/calendar_screen.dart`
6. `lib/screens/contacts/contact_detail_screen.dart`

### Contact Name Updates (Optional - backward compatible)
- All files using `contact.name` will continue to work (getter provided)
- Consider updating to use `firstName`/`lastName` for better data structure

---

## Next Steps

1. Update all `JobStatus.quoted` → `JobStatus.proposed`
2. Update all `JobStatus.scheduled` → `JobStatus.booked`
3. Test all screens
4. Continue with Booking, Invoice, Message model fixes

---

**Last Updated:** 2025-01-27

