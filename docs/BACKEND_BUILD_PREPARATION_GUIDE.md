# Backend Build Preparation Guide
**Date:** 2025-01-27  
**Purpose:** What you need ready before building, and how to build safely without breaking your app

---

## 🎯 The Build Strategy: Safe & Gradual

### How We'll Build (To Prevent Breaking Your App)

**Phase 1: Build Backend First (App Still Uses Mock Data)**
- ✅ Build all database tables
- ✅ Build all API endpoints (Edge Functions)
- ✅ Test backend with Postman/curl
- ✅ **Your app continues working with mock data** (no changes to app)

**Phase 2: Wire Frontend Gradually (Feature Flags)**
- ✅ Add feature flag: `USE_REAL_BACKEND = false` (app still uses mocks)
- ✅ Wire ONE feature at a time (e.g., just "send message")
- ✅ Test thoroughly
- ✅ If it works → Enable for that feature
- ✅ If it breaks → App still works (falls back to mocks)

**Phase 3: Full Switch (When Everything Works)**
- ✅ All features tested and working
- ✅ Switch `USE_REAL_BACKEND = true`
- ✅ Remove mock data code (optional cleanup)

**Result:** Your app NEVER breaks because we test each piece before switching.

---

## 📋 What You Need Ready Before Building

### 1. Supabase Account (Required)

**What:** Your database and backend hosting platform

**Steps:**
1. Go to https://supabase.com
2. Sign up for free account
3. Create a new project
4. Get your project URL and API keys

**What You'll Get:**
- Project URL: `https://xxxxx.supabase.co`
- API Key (anon): `eyJhbGc...` (public key, safe for frontend)
- Service Role Key: `eyJhbGc...` (secret key, backend only)

**Cost:** Free tier is generous for development

---

### 2. Twilio Account (For SMS/WhatsApp)

**What:** Service to send/receive SMS and WhatsApp messages

**Steps:**
1. Go to https://www.twilio.com
2. Sign up for account
3. Get a phone number (free trial number available)
4. Get your credentials:
   - Account SID
   - Auth Token
   - Phone Number

**Cost:** 
- Free trial: $15.50 credit
- Pay-as-you-go: ~$0.0075 per SMS

**When Needed:** Before wiring messaging features

---

### 3. Stripe Account (For Payments)

**What:** Payment processing for invoices

**Steps:**
1. Go to https://stripe.com
2. Sign up for account
3. Get your API keys:
   - Publishable Key (starts with `pk_`)
   - Secret Key (starts with `sk_`)
4. Set up webhook endpoint (we'll give you the URL)

**Cost:**
- No monthly fee
- 1.4% + 20p per card payment (UK)
- 2.9% + 20p per card payment (other countries)

**When Needed:** Before wiring payment features

---

### 4. OpenAI Account (For AI Receptionist)

**What:** Powers your AI auto-replies

**Steps:**
1. Go to https://platform.openai.com
2. Sign up for account
3. Add payment method (pay-as-you-go)
4. Get your API key

**Cost:**
- Pay-as-you-go
- ~$0.002 per 1K tokens (very cheap)
- Typical auto-reply: ~$0.001

**When Needed:** Before wiring AI features

---

### 5. Google Cloud Account (For Calendar Sync)

**What:** Allows calendar sync with Google Calendar

**Steps:**
1. Go to https://console.cloud.google.com
2. Create project
3. Enable Google Calendar API
4. Create OAuth credentials
5. Get Client ID and Client Secret

**Cost:** Free (within limits)

**When Needed:** Before wiring calendar sync

---

### 6. OneSignal Account (For Push Notifications)

**What:** Sends push notifications to your phone

**Steps:**
1. Go to https://onesignal.com
2. Sign up for free account
3. Create app
4. Get App ID and API Key

**Cost:** Free tier: 10,000 subscribers

**When Needed:** Before wiring notifications

---

## 🛡️ Safety Measures: How We Prevent Breaking Your App

### 1. Feature Flags (The Safety Net)

**How It Works:**
```dart
// In your app code
if (kUseRealBackend) {
  // Use real backend API
  await apiService.sendMessage(message);
} else {
  // Use mock data (current behavior)
  await mockService.sendMessage(message);
}
```

**Benefits:**
- ✅ App works with mocks while backend is being built
- ✅ Can test real backend without breaking app
- ✅ Can switch back instantly if something breaks
- ✅ Can enable features one at a time

**Current State:**
- Your app has `kUseMockData = true` in `lib/config/mock_config.dart`
- App works perfectly with mock data
- We'll add `kUseRealBackend` flag alongside it

---

### 2. Gradual Rollout (One Feature at a Time)

**The Process:**

**Week 1: Backend Setup**
- Build database tables
- Build API endpoints
- Test with Postman
- **App unchanged** (still uses mocks)

**Week 2: Wire First Feature (Messages)**
- Add feature flag: `USE_REAL_MESSAGES = false`
- Wire message sending to backend
- Test thoroughly
- If works → `USE_REAL_MESSAGES = true`
- If breaks → Keep `false`, fix issues

**Week 3: Wire Second Feature (Jobs)**
- Same process for jobs
- App still works (other features use mocks)

**Week 4: Wire Third Feature (Bookings)**
- Same process
- Continue until all features wired

**Result:** If one feature breaks, others still work.

---

### 3. Error Handling & Fallbacks

**How We'll Handle Errors:**

```dart
try {
  // Try real backend
  final result = await apiService.getJobs();
  return result;
} catch (e) {
  // If backend fails, fall back to mocks
  print('Backend error: $e');
  return mockService.getJobs();
}
```

**Benefits:**
- ✅ App never crashes
- ✅ Shows error message to user
- ✅ Falls back to working mock data
- ✅ Logs error for debugging

---

### 4. Testing Strategy

**Before Wiring Each Feature:**

1. **Backend Testing**
   - Test API endpoints with Postman
   - Verify database queries work
   - Check error handling

2. **Integration Testing**
   - Wire feature with flag OFF
   - Test with mock data (should work)
   - Turn flag ON
   - Test with real backend
   - Compare results

3. **User Testing**
   - Test in app
   - Verify UI works
   - Check error messages
   - Verify fallbacks work

**Only enable feature if ALL tests pass.**

---

### 5. Rollback Plan

**If Something Breaks:**

1. **Instant Rollback**
   - Change feature flag: `USE_REAL_BACKEND = false`
   - App immediately uses mocks again
   - Everything works

2. **Fix Issues**
   - Debug backend problem
   - Fix in backend
   - Test again
   - Re-enable when fixed

3. **No Data Loss**
   - Mock data still works
   - Real data safe in database
   - Can switch back and forth

---

## 📅 Recommended Build Timeline

### Phase 1: Preparation (Week 1)
- ✅ Set up Supabase account
- ✅ Set up Twilio account (get phone number)
- ✅ Set up Stripe account
- ✅ Set up OpenAI account
- ✅ Set up Google Cloud (for calendar)
- ✅ Set up OneSignal (for push notifications)

**Your app:** Still works with mock data ✅

---

### Phase 2: Backend Build (Week 2-3)
- ✅ Create all database tables
- ✅ Set up Row-Level Security (RLS)
- ✅ Create all Edge Functions
- ✅ Test all endpoints with Postman
- ✅ Set up webhooks

**Your app:** Still works with mock data ✅

---

### Phase 3: Gradual Wiring (Week 4-8)
- ✅ Week 4: Wire messaging (with feature flag)
- ✅ Week 5: Wire jobs (with feature flag)
- ✅ Week 6: Wire bookings (with feature flag)
- ✅ Week 7: Wire money/quotes/invoices (with feature flag)
- ✅ Week 8: Wire remaining features (with feature flag)

**Your app:** Works throughout, features enabled one by one ✅

---

### Phase 4: Full Switch (Week 9)
- ✅ All features tested and working
- ✅ Switch `USE_REAL_BACKEND = true` globally
- ✅ Monitor for issues
- ✅ Remove mock data code (optional)

**Your app:** Fully on real backend ✅

---

## 🔒 Safety Checklist

Before we start building, confirm:

- [ ] You have Supabase account ready
- [ ] You understand feature flags will prevent breaking
- [ ] You're okay with gradual rollout (one feature at a time)
- [ ] You understand we can rollback instantly if needed
- [ ] You know your app will keep working with mocks during build

**If all checked:** We're ready to build safely! 🚀

---

## 🎯 What Happens If We Make Mistakes?

### Scenario 1: Backend Has Bug
- **Impact:** Feature doesn't work
- **Solution:** Feature flag OFF → App uses mocks → Fix backend → Re-enable
- **App Status:** ✅ Still works

### Scenario 2: API Returns Wrong Data
- **Impact:** UI shows wrong info
- **Solution:** Feature flag OFF → App uses mocks → Fix backend → Re-enable
- **App Status:** ✅ Still works

### Scenario 3: Database Schema Wrong
- **Impact:** Can't save data
- **Solution:** Fix schema → Re-test → Re-enable
- **App Status:** ✅ Still works (using mocks)

### Scenario 4: Integration Fails (Twilio/Stripe)
- **Impact:** Can't send message/process payment
- **Solution:** Feature flag OFF → App uses mocks → Fix integration → Re-enable
- **App Status:** ✅ Still works

**Bottom Line:** Your app NEVER breaks because:
1. Feature flags let us switch instantly
2. Mock data always works as fallback
3. We test before enabling
4. We can rollback anytime

---

## 🚀 Ready to Start?

**What I Need From You:**

1. **Confirmation:** You understand the safety measures
2. **Accounts:** Set up the accounts listed above (or tell me which ones you have)
3. **Timeline:** Confirm you're okay with gradual rollout
4. **Go/No-Go:** Ready to start building backend?

**Once you confirm, I'll:**
1. Start building database schema
2. Create all tables
3. Set up Edge Functions
4. Test everything
5. Then we'll wire frontend gradually

**Your app will keep working the entire time.** ✅

