# Authentication & Onboarding Guide

## Overview

This guide explains how authentication and onboarding work in the Swiftlead app, and how to test them.

---

## 🔐 Authentication Flow

### Current Implementation

**Status:** Mock authentication (ready for backend integration)

**Flow:**
1. App checks if user is authenticated (`user_authenticated` in SharedPreferences)
2. If not authenticated → Show `LoginScreen`
3. If authenticated → Check onboarding status
4. If onboarding not completed → Show `OnboardingScreen`
5. If onboarding completed → Show `MainNavigation` (main app)

### Login Screen

**Location:** `lib/screens/auth/login_screen.dart`

**Features:**
- Email/password form with validation
- Mock authentication (any email/password works for testing)
- Password visibility toggle
- "Forgot Password" link (placeholder)
- "Sign Up" link (placeholder)
- Auto-navigates to onboarding or main app after login

**Testing:**
- Enter any email (e.g., `test@example.com`)
- Enter any password (min 6 characters)
- Click "Sign In"
- Will navigate to onboarding (if not completed) or main app

---

## 🎯 Onboarding Flow

### Current Implementation

**Status:** Fully implemented (8-step wizard)

**Flow:**
1. App checks if onboarding is completed (`onboarding_completed` in SharedPreferences)
2. If not completed → Show `OnboardingScreen`
3. User completes 8 steps or skips
4. Onboarding marked as completed
5. Navigate to main app

### Onboarding Steps

1. **Welcome** - Introduction screen
2. **Profession Selection** - Choose business type
3. **Business Details** - Name, logo, service area, hours
4. **Team Members** - Add team email addresses
5. **Integrations** - Connect Google Calendar, Stripe, SMS, etc.
6. **AI Configuration** - Enable AI, set tone, greeting
7. **Booking Setup** - Add services with duration and pricing
8. **Final Checklist** - Review and launch

**Features:**
- Progress bar showing current step
- "Skip for now" button on first step
- Back/Next navigation
- "Launch Swiftlead" button on final step

---

## 🧪 Testing Features

### Test Mode Toggle

**Location:** `lib/config/mock_config.dart`

```dart
const bool kTestMode = true;  // Set to false for production
```

**When `kTestMode = true`:**
- Authentication check is bypassed (goes straight to app)
- Test buttons appear in Settings
- Easy testing of onboarding and login screens

**When `kTestMode = false`:**
- Full authentication flow enforced
- Test buttons hidden
- Production behavior for clients

### Test Buttons in Settings

**Location:** Settings → "Testing (Test Mode Only)" section

**Available when `kTestMode = true`:**

1. **Reset Onboarding**
   - Clears `onboarding_completed` flag
   - Restart app to see onboarding again
   - Shows confirmation dialog

2. **View Login Screen**
   - Navigate to login screen for testing
   - Can test login flow without logging out

3. **Logout (Test)**
   - Clears `user_authenticated` flag
   - Restart app to see login screen
   - Shows confirmation dialog

---

## 📱 User Flow (Production)

### First-Time User

```
App Launch
  ↓
Not Authenticated
  ↓
Login Screen
  ↓
User enters email/password
  ↓
Authentication Success
  ↓
Onboarding Not Completed
  ↓
Onboarding Screen (8 steps)
  ↓
User completes or skips
  ↓
Main App
```

### Returning User

```
App Launch
  ↓
Authenticated ✓
  ↓
Onboarding Completed ✓
  ↓
Main App
```

---

## 🔧 Configuration

### Enable Test Mode

**File:** `lib/config/mock_config.dart`

```dart
const bool kTestMode = true;  // For testing
```

### Disable Test Mode (Production)

**File:** `lib/config/mock_config.dart`

```dart
const bool kTestMode = false;  // For production
```

**What changes:**
- Authentication check enforced
- Test buttons hidden in Settings
- Login screen shown if not authenticated
- Onboarding shown only after authentication

---

## 🚀 Backend Integration (Future)

### When Backend is Ready

1. **Update `lib/main.dart`:**
   ```dart
   // Replace SharedPreferences check with Supabase auth
   final session = SupabaseService.client.auth.currentSession;
   final isAuthenticated = session != null;
   ```

2. **Update `lib/screens/auth/login_screen.dart`:**
   ```dart
   // Replace mock auth with real Supabase auth
   final response = await SupabaseService.signInWithEmail(
     _emailController.text,
     _passwordController.text,
   );
   ```

3. **Update onboarding completion:**
   ```dart
   // Save to backend instead of SharedPreferences
   await SupabaseService.client
     .from('onboarding_sessions')
     .update({'completed_at': DateTime.now()})
     .eq('user_id', userId);
   ```

---

## 📝 Notes

- **SharedPreferences keys:**
  - `user_authenticated` - Boolean, tracks login status
  - `onboarding_completed` - Boolean, tracks onboarding completion

- **Test Mode:**
  - Always set `kTestMode = false` before production release
  - Test buttons are automatically hidden when disabled

- **Onboarding:**
  - Can be skipped on first step
  - Progress is saved when skipped
  - Can be accessed later from Settings (when implemented)

---

## ✅ Checklist

- [x] Onboarding screen implemented (8 steps)
- [x] Login screen implemented
- [x] Authentication flow connected
- [x] Test mode toggle added
- [x] Test buttons in Settings
- [x] SharedPreferences persistence
- [ ] Backend integration (pending)
- [ ] Real Supabase authentication (pending)
- [ ] Onboarding backend sync (pending)

---

**Last Updated:** Current session
**Status:** Ready for testing, backend integration pending

