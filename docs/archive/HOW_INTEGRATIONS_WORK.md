# How Integrations Work in Your App
**Date:** 2025-01-27  
**Purpose:** Plain English explanation of how Twilio, Stripe, and other integrations work

---

## 🎯 Your App's Core Function

**Swiftlead is an all-in-one platform that:**
1. **Captures leads** - Gets messages from customers via SMS, WhatsApp, Email, Facebook, Instagram
2. **Books jobs** - Schedules appointments and manages your calendar
3. **Gets you paid** - Sends quotes, invoices, and processes payments
4. **Uses AI** - Automatically replies to customers, especially after hours

**Everything happens in ONE app** - no switching between tools.

---

## 📱 How Twilio Integration Works

### What Twilio Does
Twilio is a service that lets you send/receive SMS and WhatsApp messages. You don't need your own phone number infrastructure.

### How It Works in Your App

#### **Sending a Message (You → Customer)**

```
1. You type a message in the app
   ↓
2. App calls backend: "send-message" function
   ↓
3. Backend saves message to database
   ↓
4. Backend calls Twilio API: "Send this SMS to +44..."
   ↓
5. Twilio sends the message to customer's phone
   ↓
6. Twilio sends webhook back: "Message delivered"
   ↓
7. Backend updates message status: "delivered"
   ↓
8. Your app shows: ✓ Delivered
```

#### **Receiving a Message (Customer → You)**

```
1. Customer texts your Twilio number
   ↓
2. Twilio receives the message
   ↓
3. Twilio sends webhook to your backend: "New message received"
   ↓
4. Backend function "process-twilio-webhook" runs
   ↓
5. Backend saves message to database
   ↓
6. Backend checks: "Should AI reply?" (if after hours)
   ↓
7a. [AI Replies] → Backend calls Twilio → Customer gets reply
7b. [Human Required] → You get push notification
   ↓
8. Your app shows new message in inbox
```

### Setup Process

1. **You get Twilio account** - Sign up at twilio.com, get API keys
2. **You configure in app** - Go to Settings → Integrations → Twilio
3. **You enter API keys** - App saves them securely in `integration_configs` table
4. **Backend connects** - Uses your API keys to send/receive messages
5. **Webhooks configured** - Twilio knows to send messages to your backend URL

---

## 💳 How Stripe Integration Works

### What Stripe Does
Stripe processes credit card payments. When a customer pays an invoice, Stripe handles the payment securely.

### How It Works

#### **Customer Pays Invoice**

```
1. You send invoice to customer
   ↓
2. Customer clicks "Pay Now" link
   ↓
3. Customer redirected to Stripe checkout page
   ↓
4. Customer enters card details (Stripe handles this securely)
   ↓
5. Customer clicks "Pay"
   ↓
6. Stripe processes payment
   ↓
7. Stripe sends webhook to your backend: "Payment succeeded"
   ↓
8. Backend function "process-stripe-webhook" runs
   ↓
9. Backend updates invoice: status = "paid", amount_paid = £500
   ↓
10. Backend creates payment record
   ↓
11. You get notification: "Invoice #1234 paid"
   ↓
12. Your app shows invoice as "Paid"
```

### Setup Process

1. **You get Stripe account** - Sign up at stripe.com
2. **You connect in app** - Settings → Integrations → Stripe
3. **OAuth flow** - Stripe connects to your account
4. **Webhook configured** - Stripe sends payment events to your backend

---

## 📅 How Google Calendar Integration Works

### What It Does
Syncs your bookings with Google Calendar so you see everything in one place.

### How It Works

```
1. You create a booking in app
   ↓
2. Backend saves booking to database
   ↓
3. Backend function "sync-google-calendar" runs
   ↓
4. Backend calls Google Calendar API: "Create event"
   ↓
5. Event appears in your Google Calendar
   ↓
6. If you edit in Google Calendar → Webhook → Backend updates booking
   ↓
7. If you edit in app → Backend updates Google Calendar
```

**Two-way sync** - Changes in either place update the other.

---

## 📧 How Email Integration Works

### What It Does
Connects your email inbox to the app so emails appear in your unified inbox.

### How It Works

```
1. You configure email in Settings → Integrations → Email
   ↓
2. You enter IMAP/SMTP settings (Gmail, Outlook, etc.)
   ↓
3. Backend saves credentials securely
   ↓
4. Every 5 minutes, backend function "process-email-imap" runs
   ↓
5. Backend checks your email inbox for new messages
   ↓
6. New emails saved to database
   ↓
7. Emails appear in your unified inbox alongside SMS/WhatsApp
   ↓
8. When you reply, backend uses SMTP to send email
```

---

## 🤖 How AI Receptionist Works

### What It Does
Automatically replies to customer messages, especially after hours.

### How It Works

```
1. Customer sends message: "Do you cover SW1A?"
   ↓
2. Backend receives message (via Twilio webhook)
   ↓
3. Backend checks: "Is it after hours?" → Yes
   ↓
4. Backend checks: "Is AI enabled?" → Yes
   ↓
5. Backend calls OpenAI: "Generate reply to this message"
   ↓
6. OpenAI returns: "Yes, we cover SW1A. Would you like to book?"
   ↓
7. Backend calls Twilio: "Send this reply"
   ↓
8. Customer receives AI reply
   ↓
9. Message marked as "ai_generated = true" in database
   ↓
10. You see conversation in inbox with AI badge
```

---

## 🔄 Real-Time Updates

### How Your App Stays Updated

```
1. Something happens (new message, payment, booking)
   ↓
2. Backend updates database
   ↓
3. Supabase Realtime broadcasts change
   ↓
4. Your app (if open) receives update instantly
   ↓
5. UI updates automatically (no refresh needed)
```

**This is why you see messages instantly** - even if you didn't send them from your phone.

---

## 🔐 Security & Authentication

### How It's Secure

1. **API Keys Stored Securely**
   - Your Twilio/Stripe keys saved in `integration_configs` table
   - Encrypted at rest
   - Only your backend can access them

2. **Webhook Security**
   - Twilio signs webhooks with HMAC SHA-256
   - Backend verifies signature before processing
   - Prevents fake messages

3. **OAuth for Google/Meta**
   - You sign in with Google/Meta
   - They give your backend a token
   - Token refreshes automatically

---

## 📊 Integration Status Tracking

### How You Know If Integrations Are Working

Your app shows:
- ✅ **Connected** - Integration working, last synced 2 min ago
- ⚠️ **Error** - Something wrong, click to fix
- ❌ **Disconnected** - Not connected, click to set up

**All stored in `integration_configs` table:**
- `status` - connected/disconnected/error
- `last_synced_at` - When last sync happened
- `error_message` - What went wrong (if error)

---

## 🎯 Summary: How Everything Connects

```
Your App (Flutter)
    ↓
Backend (Supabase Edge Functions)
    ↓
External Services (Twilio, Stripe, Google, etc.)
    ↓
Webhooks (Real-time updates back to backend)
    ↓
Database (Supabase PostgreSQL)
    ↓
Your App (Updates via Realtime)
```

**Everything flows through your backend** - your app never talks directly to Twilio/Stripe. This is secure and allows you to:
- Log everything
- Add AI processing
- Handle errors gracefully
- Track usage

---

## ✅ Do I Know Exactly How Your App Functions?

**YES!** Based on your specifications, I understand:

1. **Core Purpose:** All-in-one platform for service businesses to manage leads, jobs, bookings, and payments

2. **Key Features:**
   - Unified inbox (SMS, WhatsApp, Email, Facebook, Instagram)
   - AI Receptionist (auto-replies after hours)
   - Job management (Kanban board, list view)
   - Calendar & bookings (syncs with Google/Apple Calendar)
   - Quotes & invoices (with payment links)
   - Payments (Stripe integration)
   - Reviews management
   - Contacts/CRM
   - Analytics & reports

3. **User Experience:**
   - iOS/Revolut-quality design
   - Smooth animations
   - Haptic feedback
   - Real-time updates
   - Offline support

4. **Target Users:**
   - Trades (plumbers, electricians)
   - Service businesses (salons, clinics)
   - Anyone who needs to capture leads, book jobs, get paid

**Your backend specification covers ALL of this** - every feature, every integration, every automation. You're ready to build! 🚀

