# Stripe Checkout to App Setup - Complete Automated Flow
**Date:** 2025-01-27  
**Purpose:** Document the complete automated flow from Stripe checkout purchase to app setup and first use

---

## 🎯 Overview

This document describes the **fully automated** flow from when a client purchases Swiftlead via your Stripe checkout link, through account creation, email delivery, app download, and initial setup.

**Goal:** Zero manual intervention - everything happens automatically.

---

## ✅ Answers & Decisions (Based on Your Requirements)

### 1. **Stripe Checkout Setup**
- ✅ **Q1:** Stripe product already set up
- ✅ **Q2:** £199/month (Monthly and Annual recurring)
- ✅ **Q3:** Recurring subscription (monthly and annual)
- ✅ **Q4:** Metadata to capture in Stripe checkout:
  - **Phone number** (required)
  - **Business name** (required)
  - **Business info** (address, service area)
  - **Facebook Page URL/ID** (for integration)
  - **Instagram Business handle** (for integration)
  - **Profession/Industry** (Trade/Salon/Professional - determines labels and modules)
  - **Business hours** (optional, can be set in onboarding)

### 2. **Account Creation & Email** (RECOMMENDATIONS)
- ✅ **Q5:** **RECOMMENDATION: Create account immediately** when payment succeeds
  - Faster user experience
  - Account ready when they receive email
  - Can still require email verification for security
  
- ✅ **Q6:** **RECOMMENDATION: Send welcome email with:**
  - ✅ App download links (iOS App Store, Google Play, Web App)
  - ✅ Magic link for passwordless login (best UX)
  - ✅ Quick start guide link
  - ✅ Account email (for reference)
  
- ✅ **Q7:** **RECOMMENDATION: Use Supabase Auth emails** (easiest)
  - Built-in, no extra setup
  - Handles email verification
  - Can customize templates
  - Free tier is generous
  
- ✅ **Q8:** **RECOMMENDATION: Magic link (passwordless)** - Best UX
  - No password to remember
  - More secure (no password storage)
  - One-click login from email
  - Can add password option later if needed

### 3. **App Download & Installation**
- ✅ **Q9:** Still in development
- ✅ **Q10:** **RECOMMENDATION: Both TestFlight (iOS) and Internal Testing (Android)**
  - TestFlight for iOS beta testing
  - Google Play Internal Testing for Android
  - Web app accessible immediately (no app store needed)
  
- ✅ **Q11:** No trial customers - all are paid customers
  - Same onboarding flow for everyone
  - All features unlocked based on subscription

### 4. **First Login & Setup** (RECOMMENDATIONS)
- ✅ **Q12:** **RECOMMENDATION: Wait for email verification** (more secure)
  - Account created immediately
  - User must verify email before first login
  - Prevents unauthorized access
  
- ✅ **Q13:** **RECOMMENDATION: Send reminder emails**
  - Day 1: "Complete your setup"
  - Day 3: "You're almost there!"
  - Day 7: "Last chance - complete setup to unlock all features"
  - After 7 days: Mark as inactive, send "We're here when you're ready"
  
- ✅ **Q14:** **RECOMMENDATION: Pre-populate from Stripe metadata:**
  - ✅ Business name (from Stripe)
  - ✅ Phone number (from Stripe)
  - ✅ Profession/Industry (from Stripe - determines labels/modules)
  - ✅ Business info (address, service area if provided)
  - ✅ Facebook/Instagram (if provided - ready for integration)
  - User can edit all fields during onboarding

### 5. **Error Handling & Edge Cases** (RECOMMENDATIONS)
- ✅ **Q15:** **RECOMMENDATION: Retry 3 times, then alert admin**
  - Automatic retry: 3 attempts with 5-minute delays
  - If all retries fail: Send alert email to admin
  - Admin can manually create account or investigate
  - User receives "Account creation in progress" email
  
- ✅ **Q16:** **RECOMMENDATION: Show friendly error, offer login**
  - Check if email exists in Supabase Auth
  - If exists: Send "Account already exists" email with login link
  - If not: Proceed with account creation
  - Prevents duplicate accounts
  
- ✅ **Q17:** **RECOMMENDATION: Grace period with feature limits**
  - Failed payment: 7-day grace period
  - During grace: Show warning banner, limit some features
  - After 7 days: Disable account access, send "Payment required" email
  - Subscription cancelled: Same 7-day grace period
  - User can reactivate by updating payment method

---

## 🔄 Proposed Automated Flow (Draft)

Based on your specs, here's the flow I'm proposing. **Please review and tell me what to change:**

### **Phase 1: Stripe Checkout → Payment Success**

```
1. Client clicks your Stripe checkout link
   ↓
2. Client enters payment details and completes payment
   ↓
3. Stripe processes payment → Payment succeeds
   ↓
4. Stripe sends webhook: checkout.session.completed
   ↓
5. Your Supabase Edge Function receives webhook
   ↓
6. Verify webhook signature (security)
```

### **Phase 2: Account Creation (Automated)**

```
7. Extract customer data from Stripe checkout session:
   - Email (from Stripe customer.email)
   - Phone number (from metadata.phone_number - REQUIRED)
   - Business name (from metadata.business_name - REQUIRED)
   - Business address (from metadata.business_address)
   - Service area (from metadata.service_area)
   - Facebook Page URL/ID (from metadata.facebook_page_id)
   - Instagram Business handle (from metadata.instagram_handle)
   - Profession/Industry (from metadata.profession: "trade" | "salon" | "professional")
   - Business hours (from metadata.business_hours - optional, JSON)
   - Subscription plan (from checkout session)
   ↓
8. Check for duplicate email:
   - Query Supabase Auth: Does email exist?
   - If YES → Skip account creation, send "Account exists" email with login link
   - If NO → Continue with account creation
   ↓
9. Create Supabase Auth user:
   - Email: from Stripe
   - Phone: from Stripe metadata (store in user metadata)
   - Email confirmation: REQUIRED (send verification email)
   - Magic link: Generate and include in welcome email
   ↓
10. Create Organization record:
    - org_name: from Stripe metadata.business_name
    - phone: from Stripe metadata.phone_number
    - address: from Stripe metadata.business_address (if provided)
    - service_area: from Stripe metadata.service_area (if provided)
    - business_hours: from Stripe metadata.business_hours (if provided, JSON)
    - subscription_status: "active"
    - subscription_plan: from Stripe (monthly/annual)
    - subscription_starts_at: NOW()
    - stripe_customer_id: from Stripe
    - stripe_subscription_id: from Stripe
    - industry_key: from Stripe metadata.profession (determines labels/modules)
    ↓
11. Create User record (owner):
    - user_id: from Supabase Auth
    - org_id: newly created organization
    - role: "owner"
    - email: from Stripe
    - phone: from Stripe metadata
    - full_name: from Stripe customer name (if provided)
    ↓
12. Create Integration Config records (pre-configured, not connected yet):
    - Facebook Pages: Store metadata.facebook_page_id (ready to connect)
    - Instagram Business: Store metadata.instagram_handle (ready to connect)
    - WhatsApp: Ready for connection (Twilio setup needed)
    - Email: Ready for connection (IMAP/SMTP setup needed)
    - Status: "pending" (not connected, but metadata stored)
```

### **Phase 3: Welcome Email (Automated)**

```
13. Send welcome email via Supabase Auth:
    - Subject: "Welcome to Swiftlead! 🎉 Your account is ready"
    - Content:
      * Thank you message
      * Account email: [their email]
      * Magic link: [one-click login link] (expires in 24 hours)
      * App download links:
        - Web App: [your web app URL] (accessible immediately)
        - iOS: [TestFlight link] (if in development)
        - Android: [Google Play Internal Testing link] (if in development)
      * Quick start guide: [link to guide]
      * Support: [support email/link]
    ↓
14. Email sent via Supabase Auth email service
    - Uses Supabase email templates (customizable)
    - Includes email verification link
    - Magic link for passwordless login
```

### **Phase 4: App Download & First Launch**

```
13. Client receives email
   ↓
14. Client clicks app download link
   ↓
15. Client installs app (App Store/Play Store)
   ↓
16. Client opens app for first time
   ↓
17. App checks: Is user authenticated?
   - NO → Show Login Screen
   - YES → Check onboarding status
```

### **Phase 5: Login & Authentication**

```
18. Client enters email + password (from welcome email)
   OR clicks magic link in email
   ↓
19. Supabase Auth verifies credentials
   ↓
20. If successful:
    - Store auth session locally
    - Fetch user profile from database
    - Check onboarding status
   ↓
21. If onboarding not completed:
    → Show Onboarding Screen (4 steps)
   If onboarding completed:
    → Show Main Navigation (Home screen)
```

### **Phase 6: Onboarding (4 Steps - Pre-populated from Stripe)**

```
22. Step 1: Welcome + Profession Selection
    - Profession: PRE-SELECTED from Stripe metadata.profession
      * Trade → Shows: Jobs, Calendar, Money (all modules)
      * Salon/Clinic → Shows: Appointments, Calendar, Money (hides Jobs)
      * Professional → Shows: Clients, Reports, Money (hides Calendar)
    - User can change if needed
    - Labels automatically update based on profession
    ↓
23. Step 2: Business Name & Details
    - Business Name: PRE-FILLED from Stripe metadata.business_name
    - Phone Number: PRE-FILLED from Stripe metadata.phone_number
    - Service Area: PRE-FILLED from Stripe metadata.service_area (if provided)
    - Business Hours: PRE-FILLED from Stripe metadata.business_hours (if provided)
    - User can edit all fields
    ↓
24. Step 3: Quick Setup (Integrations Ready)
    - AI Assistant: Enabled by default (toggle on/off)
    - Integrations (ready to connect, metadata already stored):
      * Facebook Pages: Shows "Connect" button (metadata already stored)
      * Instagram Business: Shows "Connect" button (handle already stored)
      * WhatsApp: Shows "Connect" button (ready for Twilio setup)
      * Email: Shows "Connect" button (ready for IMAP/SMTP setup)
      * Calendar: Optional (Google/Apple Calendar)
    - User can connect now or skip for later
    - All integrations go to unified Inbox when connected
    ↓
25. Step 4: Done & Summary
    - Summary shows:
      * Profession: [selected]
      * Business: [name]
      * Phone: [number]
      * Integrations ready: Facebook, Instagram, WhatsApp, Email
      * AI Assistant: [enabled/disabled]
    - "Launch Swiftlead" button
    ↓
26. Onboarding complete:
    - Save onboarding_completed = true
    - Update organization with any changes made
    - Navigate to Main Navigation (Home Dashboard)
    - Send "Onboarding Complete" email (optional)
    - All integrations remain in "pending" status until user connects them
```

### **Phase 7: First Use**

```
27. User lands on Home Dashboard
   ↓
28. App is ready to use:
    - All features unlocked (based on subscription plan)
    - Mock data available (if enabled)
    - Real backend connected
```

---

## 🔧 Technical Implementation Details

### **Stripe Webhook Handler (Supabase Edge Function)**

**Function:** `process-stripe-checkout-webhook`

**Trigger:** Stripe webhook `checkout.session.completed`

**What it does:**
1. Verify webhook signature (HMAC SHA-256)
2. Extract data from Stripe checkout session:
   ```typescript
   {
     customer_email: string,
     customer_id: string,
     subscription_id: string,
     subscription_plan: "monthly" | "annual",
     metadata: {
       phone_number: string,           // REQUIRED
       business_name: string,          // REQUIRED
       business_address?: string,
       service_area?: string,
       facebook_page_id?: string,      // For Facebook Pages integration
       instagram_handle?: string,      // For Instagram Business integration
       profession: "trade" | "salon" | "professional", // Determines labels/modules
       business_hours?: string,        // JSON string of business hours
     }
   }
   ```
3. Check for duplicate email in Supabase Auth
4. Create Supabase Auth user (with email verification required)
5. Create Organization with all metadata
6. Create User (owner) record
7. Create Integration Config records (Facebook, Instagram, WhatsApp, Email - all "pending")
8. Set industry_key based on profession (determines visible modules and labels)
9. Generate magic link for passwordless login
10. Send welcome email with magic link and app download links
11. Return success

**Metadata Validation:**
- REQUIRED: phone_number, business_name, profession
- OPTIONAL: All other fields (can be set during onboarding)

**Error Handling:**
- If account creation fails → Log error, send alert email to admin
- If email send fails → Retry queue
- If duplicate email → Skip account creation, send "Account already exists" email

### **Welcome Email Template**

**Subject:** "Welcome to Swiftlead! 🎉 Your account is ready"

**Content:**
```
Hi [Name],

Thank you for choosing Swiftlead! Your account has been created and is ready to use.

🔐 LOGIN (One-Click):
Click this magic link to log in instantly: [MAGIC LINK]
(Link expires in 24 hours)

Or log in with your email: [their email]

📱 DOWNLOAD THE APP:
- Web App: [your web app URL] (accessible immediately)
- iOS App: [TestFlight link] (beta testing)
- Android App: [Google Play Internal Testing link] (beta testing)

📚 QUICK START (2 minutes):
1. Click the magic link above to log in
2. Complete quick setup (pre-filled from your checkout)
3. Connect your integrations (Facebook, Instagram, WhatsApp, Email)
4. Start managing your business!

✨ WHAT'S PRE-CONFIGURED:
- Business: [business_name]
- Phone: [phone_number]
- Profession: [profession] (labels customized for your industry)
- Integrations ready: Facebook, Instagram, WhatsApp, Email

Need help? Reply to this email or visit [support link]

- The Swiftlead Team
```

**Email Service:** Supabase Auth (built-in, customizable templates)

### **Database Schema Updates Needed**

**New fields in `organizations` table:**
- `stripe_customer_id` (text, unique)
- `stripe_subscription_id` (text, unique)
- `subscription_status` (enum: active/cancelled/past_due)
- `subscription_plan` (text)
- `subscription_starts_at` (timestamp)
- `subscription_ends_at` (timestamp, nullable)

**New fields in `users` table:**
- `stripe_customer_id` (text, nullable, for reference)

---

## 🚨 Edge Cases & Error Handling

### **1. Payment Succeeds, Account Creation Fails**
- **Action:** Log error, send alert to admin
- **Recovery:** Admin manually creates account or retry function
- **User Experience:** User receives email explaining delay, account created within 24h

### **2. Duplicate Email**
- **Action:** Check if email exists in Supabase Auth
- **If exists:** Send "Account already exists" email with login link
- **If not:** Proceed with account creation

### **3. Email Send Fails**
- **Action:** Add to retry queue
- **Retry:** Every 5 minutes, max 3 attempts
- **Fallback:** Admin notification if all retries fail

### **4. User Doesn't Complete Onboarding**
- **Action:** Send reminder emails at:
  - Day 1: "Complete your setup"
  - Day 3: "You're almost there!"
  - Day 7: "Last chance to get started"
- **After 7 days:** Mark as inactive, send "We're here when you're ready" email

### **5. Subscription Cancelled/Expired**
- **Action:** Stripe webhook: `customer.subscription.deleted`
- **Update:** Set `subscription_status = 'cancelled'`
- **Email:** Send "Subscription cancelled" email
- **App:** Show "Subscription expired" banner, limit features

---

## 📊 Monitoring & Analytics

**Track these metrics:**
- Stripe checkout → Account creation success rate
- Account creation → Email sent success rate
- Email sent → App download rate
- App download → First login rate
- First login → Onboarding completion rate
- Onboarding completion → First job/contact created rate

**Dashboards:**
- Stripe dashboard: Revenue, subscriptions
- Supabase dashboard: User signups, active users
- Custom dashboard: Conversion funnel metrics

---

## 📋 Stripe Checkout Configuration Required

**To make this work, you need to configure your Stripe checkout to collect:**

### Required Metadata Fields:
1. `phone_number` - Customer's phone number (REQUIRED)
2. `business_name` - Business name (REQUIRED)
3. `profession` - Must be one of: `"trade"`, `"salon"`, or `"professional"` (REQUIRED)

### Optional Metadata Fields:
4. `business_address` - Full business address
5. `service_area` - Service area (e.g., "London, UK" or "10 mile radius")
6. `facebook_page_id` - Facebook Page ID or URL
7. `instagram_handle` - Instagram Business handle (without @)
8. `business_hours` - JSON string of business hours (can be set in onboarding)

### How to Add Metadata to Stripe Checkout:

**Option 1: Stripe Checkout Session API**
```javascript
const session = await stripe.checkout.sessions.create({
  // ... other config
  metadata: {
    phone_number: customerPhone,
    business_name: customerBusinessName,
    profession: 'trade', // or 'salon' or 'professional'
    facebook_page_id: customerFacebookPage,
    instagram_handle: customerInstagram,
    // ... other optional fields
  }
});
```

**Option 2: Stripe Payment Link (with custom fields)**
- Add custom fields to your Stripe Payment Link
- Map them to metadata in webhook handler

---

## ✅ Next Steps

**Based on your answers, I will now:**
1. ✅ Finalize the automated flow (DONE - see above)
2. ⏳ Create the Stripe webhook handler code (Supabase Edge Function)
3. ⏳ Set up the welcome email template (Supabase Auth)
4. ⏳ Configure error handling and retry logic
5. ⏳ Create database schema updates for new fields
6. ⏳ Provide testing checklist

**Ready to implement:**
- Stripe webhook handler Edge Function
- Database migrations for new fields
- Email template customization
- Integration config table setup
- Onboarding pre-population logic

**Would you like me to:**
1. Create the Supabase Edge Function code now?
2. Create the database migration SQL?
3. Set up the email templates?
4. Update the onboarding screen to pre-populate from Stripe data?

---

## 📝 Notes

- All automation should be idempotent (safe to retry)
- All sensitive operations should be logged
- All user-facing emails should be tested
- All error scenarios should have recovery paths
- All webhooks should verify signatures for security

