# Backend Integration Migration Guide
**Date:** 2025-01-27  
**Purpose:** Step-by-step guide to migrate from mock data to backend integration  
**Confidence Level:** 10000% after completion

---

## Overview

This guide provides a **systematic, zero-risk approach** to migrating your frontend from mock data to live backend integration. Follow each step in order and verify before proceeding.

---

## Pre-Migration Checklist

### ✅ Phase 1: Verification (Complete Before Starting)

1. **Data Model Verification**
   - [ ] All models match backend schema (see `10000_PERCENT_CONFIDENCE_VERIFICATION.md`)
   - [ ] All enums match backend enums
   - [ ] All data types match backend types

2. **API Integration Points**
   - [ ] All mock calls mapped to backend endpoints
   - [ ] All Edge Functions parameters verified
   - [ ] All request/response formats documented

3. **Service Layer Structure**
   - [ ] Service layer architecture defined
   - [ ] Error handling pattern established
   - [ ] Authentication flow ready

4. **State Management**
   - [ ] All loading states implemented
   - [ ] All error states implemented
   - [ ] All empty states implemented

5. **Form Validation**
   - [ ] Client-side validation matches backend
   - [ ] All required fields validated
   - [ ] All format validation implemented

---

## Migration Steps

### Step 1: Create Service Layer Structure

**Location:** `lib/services/`

Create service classes for each module:

```dart
// lib/services/messages_service.dart
class MessagesService {
  static Future<List<MessageThread>> fetchAllThreads() async {
    if (kUseMockData) {
      return MockMessages.fetchAllThreads();
    }
    // Backend implementation
    final response = await SupabaseService.client
        .from('message_threads')
        .select()
        .eq('org_id', getCurrentOrgId())
        .order('last_message_at', ascending: false);
    // Map response to MessageThread objects
  }
}
```

**Services to Create:**
- [ ] `messages_service.dart`
- [ ] `jobs_service.dart`
- [ ] `bookings_service.dart`
- [ ] `contacts_service.dart`
- [ ] `payments_service.dart`
- [ ] `reports_service.dart`
- [ ] `reviews_service.dart`

### Step 2: Update All Screen Files

**Pattern:** Replace direct mock calls with service calls

**Before:**
```dart
if (kUseMockData) {
  _threads = await MockMessages.fetchAllThreads();
} else {
  // TODO: Load from live backend
}
```

**After:**
```dart
_threads = await MessagesService.fetchAllThreads();
```

**Files to Update:**
- [ ] `lib/screens/inbox/inbox_screen.dart`
- [ ] `lib/screens/inbox/inbox_thread_screen.dart`
- [ ] `lib/screens/jobs/jobs_screen.dart`
- [ ] `lib/screens/jobs/job_detail_screen.dart`
- [ ] `lib/screens/calendar/calendar_screen.dart`
- [ ] `lib/screens/contacts/contacts_screen.dart`
- [ ] `lib/screens/money/money_screen.dart`
- [ ] `lib/screens/home/home_screen.dart`
- [ ] All other screens using mock data

### Step 3: Implement Authentication

**Location:** `lib/services/auth_service.dart`

```dart
class AuthService {
  static Future<AuthResponse> signIn(String email, String password) async {
    return await SupabaseService.signInWithEmail(email, password);
  }
  
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    return await SupabaseService.signUp(
      email: email,
      password: password,
      data: data,
    );
  }
  
  static String? getCurrentOrgId() {
    final user = SupabaseService.currentUser;
    return user?.userMetadata?['org_id'] as String?;
  }
}
```

**Tasks:**
- [ ] Create `auth_service.dart`
- [ ] Implement `getCurrentOrgId()` helper
- [ ] Update all service calls to include `org_id` filter

### Step 4: Implement Error Handling

**Location:** `lib/services/base_service.dart`

```dart
class BaseService {
  static Future<T> handleRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on PostgrestException catch (e) {
      throw _mapPostgrestError(e);
    } on AuthException catch (e) {
      throw _mapAuthError(e);
    } catch (e) {
      throw ServiceException('An unexpected error occurred: ${e.toString()}');
    }
  }
  
  static ServiceException _mapPostgrestError(PostgrestException e) {
    // Map backend errors to user-friendly messages
  }
}
```

**Tasks:**
- [ ] Create `base_service.dart`
- [ ] Implement error mapping
- [ ] Update all services to use `handleRequest`

### Step 5: Test with Mock Data First

**Before switching to backend:**

1. **Update `kUseMockData` to use service layer:**
   ```dart
   // lib/services/messages_service.dart
   static Future<List<MessageThread>> fetchAllThreads() async {
     if (kUseMockData) {
       return MockMessages.fetchAllThreads();
     }
     // Backend will go here
   }
   ```

2. **Test all flows with `kUseMockData = true`:**
   - [ ] All screens load correctly
   - [ ] All forms submit correctly
   - [ ] All navigation works
   - [ ] All filters work
   - [ ] All search works

### Step 6: Implement Backend Calls

**For each service, implement backend calls:**

```dart
// Example: messages_service.dart
static Future<List<MessageThread>> fetchAllThreads() async {
  if (kUseMockData) {
    return MockMessages.fetchAllThreads();
  }
  
  return await BaseService.handleRequest(() async {
    final orgId = AuthService.getCurrentOrgId();
    if (orgId == null) throw ServiceException('Not authenticated');
    
    final response = await SupabaseService.client
        .from('message_threads')
        .select()
        .eq('org_id', orgId)
        .order('last_message_at', ascending: false);
    
    return (response as List)
        .map((json) => MessageThread.fromJson(json))
        .toList();
  });
}
```

**Tasks:**
- [ ] Implement backend calls for Messages Service
- [ ] Implement backend calls for Jobs Service
- [ ] Implement backend calls for Bookings Service
- [ ] Implement backend calls for Contacts Service
- [ ] Implement backend calls for Payments Service

### Step 7: Implement Edge Functions

**For actions that use Edge Functions:**

```dart
// Example: send message
static Future<void> sendMessage({
  required String threadId,
  required String content,
  List<String>? mediaUrls,
}) async {
  if (kUseMockData) {
    // Mock implementation
    return;
  }
  
  return await BaseService.handleRequest(() async {
    await SupabaseService.client.functions.invoke(
      'send-message',
      body: {
        'thread_id': threadId,
        'content': content,
        'media_urls': mediaUrls,
      },
    );
  });
}
```

**Edge Functions to Implement:**
- [ ] `send-message`
- [ ] `create-job`
- [ ] `update-job`
- [ ] `create-booking`
- [ ] `cancel-booking`
- [ ] `create-invoice`
- [ ] `send-on-my-way`

### Step 8: Switch to Backend

**Final Step:**

1. **Update `lib/config/mock_config.dart`:**
   ```dart
   const bool kUseMockData = false; // Switch to backend
   ```

2. **Initialize Supabase in `main.dart`:**
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     
     await SupabaseService.initialize(
       url: 'YOUR_SUPABASE_URL',
       anonKey: 'YOUR_SUPABASE_ANON_KEY',
     );
     
     runApp(const SwiftleadApp());
   }
   ```

3. **Test Everything:**
   - [ ] Login works
   - [ ] All screens load
   - [ ] All forms submit
   - [ ] All navigation works
   - [ ] All filters work
   - [ ] All search works
   - [ ] Error handling works

---

## Rollback Plan

**If issues occur:**

1. **Immediate Rollback:**
   ```dart
   const bool kUseMockData = true; // Revert to mock
   ```

2. **Fix Issues:**
   - Check error logs
   - Verify API endpoints
   - Verify authentication
   - Fix service implementations

3. **Re-test:**
   - Test with mock data first
   - Then test with backend again

---

## Testing Checklist

### Before Migration
- [ ] All screens work with mock data
- [ ] All forms validate correctly
- [ ] All navigation works
- [ ] All error states work

### During Migration
- [ ] Service layer works with mock data
- [ ] Error handling works
- [ ] Authentication works
- [ ] All API calls structured correctly

### After Migration
- [ ] All screens load from backend
- [ ] All forms submit to backend
- [ ] All real-time updates work (if applicable)
- [ ] All error handling works
- [ ] Performance is acceptable

---

## Common Issues & Solutions

### Issue 1: Authentication Errors
**Solution:** Verify `org_id` is included in user metadata and all queries filter by `org_id`

### Issue 2: RLS Policy Errors
**Solution:** Verify backend RLS policies are set up correctly

### Issue 3: Data Type Mismatches
**Solution:** Verify all data types match backend schema exactly

### Issue 4: Missing Fields
**Solution:** Verify all required fields are included in requests

### Issue 5: Performance Issues
**Solution:** Implement pagination, caching, and optimize queries

---

## Success Criteria

✅ **Migration is successful when:**
1. All screens load data from backend
2. All forms submit to backend
3. All error handling works correctly
4. Performance is acceptable
5. No crashes or data loss
6. All user flows work end-to-end

---

**Last Updated:** 2025-01-27  
**Status:** Ready for Migration

