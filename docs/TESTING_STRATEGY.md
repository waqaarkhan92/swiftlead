# Swiftlead App - Comprehensive Testing Strategy
**Date:** 2025-01-27  
**Purpose:** Complete testing guide for Swiftlead app  
**Target Coverage:** 70%+

---

## Testing Overview

Your app needs **three types of tests**:
1. **Unit Tests** - Test business logic, models, utilities (fast, isolated)
2. **Widget Tests** - Test UI components and screens (medium speed)
3. **Integration Tests** - Test complete user flows (slower, end-to-end)

---

## 1. Unit Tests

### Purpose
Test business logic, data models, utilities, and pure functions **without UI**.

### What to Test

#### A. Models & Data Structures

**Example: Job Model**
```dart
// test/models/job_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:swiftlead/models/job.dart';

void main() {
  group('Job Model', () {
    test('creates job with required fields', () {
      final job = Job(
        id: '1',
        title: 'Plumbing Repair',
        status: JobStatus.proposed,
        // ... other fields
      );
      
      expect(job.id, '1');
      expect(job.title, 'Plumbing Repair');
      expect(job.status, JobStatus.proposed);
    });
    
    test('calculates days overdue correctly', () {
      final overdueDate = DateTime.now().subtract(Duration(days: 5));
      final job = Job(
        id: '1',
        title: 'Test',
        dueDate: overdueDate,
        status: JobStatus.inProgress,
      );
      
      expect(job.isOverdue, true);
    });
    
    test('serializes to JSON correctly', () {
      final job = Job(/* ... */);
      final json = job.toJson();
      
      expect(json['id'], job.id);
      expect(json['title'], job.title);
    });
    
    test('deserializes from JSON correctly', () {
      final json = {'id': '1', 'title': 'Test', /* ... */};
      final job = Job.fromJson(json);
      
      expect(job.id, '1');
      expect(job.title, 'Test');
    });
  });
}
```

**What to Test:**
- ✅ Model creation with all fields
- ✅ JSON serialization (`toJson`)
- ✅ JSON deserialization (`fromJson`)
- ✅ Computed properties (e.g., `isOverdue`, `totalValue`)
- ✅ Validation logic
- ✅ Edge cases (null values, empty strings, etc.)

**Files to Test:**
- `lib/models/job.dart`
- `lib/models/contact.dart`
- `lib/models/booking.dart`
- `lib/models/message.dart`
- `lib/models/payment.dart`
- All other models

---

#### B. Utilities & Business Logic

**Example: ProfessionConfig**
```dart
// test/utils/profession_config_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:swiftlead/utils/profession_config.dart';

void main() {
  group('ProfessionConfig', () {
    test('returns correct label for trade profession', () {
      final config = ProfessionConfig.getProfessionConfig(ProfessionType.trade);
      expect(config.getLabel('Job'), 'Job');
      expect(config.getLabel('Jobs'), 'Jobs');
    });
    
    test('returns overridden label for professional services', () {
      final config = ProfessionConfig.getProfessionConfig(
        ProfessionType.professionalServices
      );
      expect(config.getLabel('Job'), 'Appointment');
      expect(config.getLabel('Jobs'), 'Appointments');
    });
    
    test('checks module visibility correctly', () {
      final config = ProfessionConfig.getProfessionConfig(ProfessionType.trade);
      expect(config.isModuleVisible('home'), true);
      expect(config.isModuleVisible('jobs'), true);
      expect(config.isModuleVisible('nonexistent'), false);
    });
    
    test('handles case-insensitive module names', () {
      final config = ProfessionConfig.getProfessionConfig(ProfessionType.trade);
      expect(config.isModuleVisible('HOME'), true);
      expect(config.isModuleVisible('Home'), true);
    });
  });
  
  group('ProfessionState', () {
    test('defaults to trade profession', () {
      expect(ProfessionState.currentProfession, ProfessionType.trade);
    });
    
    test('updates profession correctly', () {
      ProfessionState.setProfession(ProfessionType.professionalServices);
      expect(ProfessionState.currentProfession, ProfessionType.professionalServices);
    });
  });
}
```

**What to Test:**
- ✅ Utility functions (calculations, formatting, parsing)
- ✅ Configuration classes
- ✅ Validation functions
- ✅ Data transformation logic
- ✅ Edge cases and error handling

**Files to Test:**
- `lib/utils/profession_config.dart`
- `lib/utils/constants.dart`
- `lib/utils/keyboard_shortcuts.dart`
- Any pure functions in services

---

#### C. Service Layer (When Implemented)

**Example: MessagesService**
```dart
// test/services/messages_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:swiftlead/services/messages_service.dart';
import 'package:swiftlead/models/message.dart';

void main() {
  group('MessagesService', () {
    test('fetches all threads successfully', () async {
      final threads = await MessagesService.fetchAllThreads();
      
      expect(threads, isA<List<MessageThread>>());
      expect(threads.length, greaterThan(0));
    });
    
    test('handles empty thread list', () async {
      // Mock empty response
      final threads = await MessagesService.fetchAllThreads();
      expect(threads, isEmpty);
    });
    
    test('handles network errors gracefully', () async {
      // Mock network error
      expect(
        () => MessagesService.fetchAllThreads(),
        throwsA(isA<Exception>()),
      );
    });
    
    test('filters blocked contacts', () async {
      final threads = await MessagesService.fetchAllThreads();
      final hasBlocked = threads.any((t) => t.contactId == 'blocked-id');
      expect(hasBlocked, false);
    });
  });
}
```

**What to Test:**
- ✅ API calls (when backend is ready)
- ✅ Data fetching
- ✅ Error handling
- ✅ Data filtering
- ✅ Caching logic
- ✅ Offline queue management

---

## 2. Widget Tests

### Purpose
Test UI components, screens, and user interactions **in isolation**.

### What to Test

#### A. Reusable Components

**Example: PrimaryButton**
```dart
// test/widgets/global/primary_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swiftlead/widgets/global/primary_button.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('displays label correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Save',
              onPressed: () {},
            ),
          ),
        ),
      );
      
      expect(find.text('Save'), findsOneWidget);
    });
    
    testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
      var tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Save',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );
      
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();
      
      expect(tapped, true);
    });
    
    testWidgets('shows loading state correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Save',
              onPressed: () {},
              isLoading: true,
            ),
          ),
        ),
      );
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Save'), findsNothing);
    });
    
    testWidgets('is disabled when onPressed is null', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryButton(
              label: 'Save',
              onPressed: null,
            ),
          ),
        ),
      );
      
      final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.onPressed, isNull);
    });
  });
}
```

**What to Test:**
- ✅ Widget renders correctly
- ✅ Displays correct data
- ✅ Handles user interactions (tap, scroll, etc.)
- ✅ Shows correct states (loading, disabled, error)
- ✅ Accessibility (Semantics widgets)
- ✅ Responsive behavior

**Components to Test:**
- `lib/widgets/global/primary_button.dart`
- `lib/widgets/global/frosted_bottom_nav_bar.dart`
- `lib/widgets/global/search_bar.dart`
- `lib/widgets/global/empty_state_card.dart`
- `lib/widgets/global/error_state_card.dart`
- All reusable components (178 widgets)

---

#### B. Screen Widgets

**Example: ContactsScreen**
```dart
// test/screens/contacts/contacts_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:swiftlead/screens/contacts/contacts_screen.dart';

void main() {
  group('ContactsScreen', () {
    testWidgets('displays loading state initially', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContactsScreen(),
        ),
      );
      
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
    
    testWidgets('displays contacts list after loading', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContactsScreen(),
        ),
      );
      
      // Wait for loading to complete
      await tester.pumpAndSettle();
      
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('No contacts found'), findsNothing);
    });
    
    testWidgets('displays empty state when no contacts', (WidgetTester tester) async {
      // Mock empty data
      await tester.pumpWidget(
        MaterialApp(
          home: ContactsScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      expect(find.text('No contacts found'), findsOneWidget);
    });
    
    testWidgets('filters contacts by selected filter', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContactsScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Tap on "Hot" filter
      await tester.tap(find.text('Hot'));
      await tester.pumpAndSettle();
      
      // Verify filtered results
      // (Would need to check actual filtered list)
    });
    
    testWidgets('navigates to contact detail on tap', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContactsScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      // Tap on first contact
      final firstContact = find.byType(ListTile).first;
      await tester.tap(firstContact);
      await tester.pumpAndSettle();
      
      // Verify navigation occurred
      expect(find.byType(ContactDetailScreen), findsOneWidget);
    });
    
    testWidgets('shows search bar', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ContactsScreen(),
        ),
      );
      
      await tester.pumpAndSettle();
      
      expect(find.byType(SearchBar), findsOneWidget);
    });
  });
}
```

**What to Test:**
- ✅ Screen renders correctly
- ✅ Loading states
- ✅ Empty states
- ✅ Error states
- ✅ Data display
- ✅ User interactions (taps, scrolls, inputs)
- ✅ Navigation
- ✅ Filtering and searching
- ✅ Form submissions

**Screens to Test (Priority Order):**
1. **Critical Screens:**
   - `lib/screens/home/home_screen.dart`
   - `lib/screens/jobs/jobs_screen.dart`
   - `lib/screens/contacts/contacts_screen.dart`
   - `lib/screens/inbox/inbox_screen.dart`
   - `lib/screens/money/money_screen.dart`

2. **Detail Screens:**
   - `lib/screens/jobs/job_detail_screen.dart`
   - `lib/screens/contacts/contact_detail_screen.dart`
   - `lib/screens/money/invoice_detail_screen.dart`

3. **Form Screens:**
   - `lib/screens/jobs/create_edit_job_screen.dart`
   - `lib/screens/contacts/create_edit_contact_screen.dart`
   - `lib/screens/money/create_edit_invoice_screen.dart`

---

## 3. Integration Tests

### Purpose
Test **complete user flows** end-to-end, simulating real user behavior.

### What to Test

#### A. Critical User Flows

**Example: Create Job Flow**
```dart
// integration_test/create_job_flow_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swiftlead/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Create Job Flow', () {
    testWidgets('user can create a new job', (WidgetTester tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();
      
      // Navigate to Jobs screen
      await tester.tap(find.text('Jobs'));
      await tester.pumpAndSettle();
      
      // Tap create button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      
      // Fill in job form
      await tester.enterText(find.byKey(Key('job_title')), 'Plumbing Repair');
      await tester.enterText(find.byKey(Key('job_description')), 'Fix leaky faucet');
      
      // Select contact
      await tester.tap(find.byKey(Key('contact_selector')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('John Smith').first);
      await tester.pumpAndSettle();
      
      // Submit form
      await tester.tap(find.text('Create Job'));
      await tester.pumpAndSettle();
      
      // Verify job was created
      expect(find.text('Plumbing Repair'), findsOneWidget);
      expect(find.text('Job created'), findsOneWidget);
    });
  });
}
```

**Critical Flows to Test:**
1. **Onboarding Flow**
   - New user signs up
   - Completes onboarding
   - Lands on home screen

2. **Create Job Flow**
   - Navigate to Jobs
   - Create new job
   - Verify job appears in list

3. **Contact Management Flow**
   - Create contact
   - View contact details
   - Edit contact
   - Delete contact

4. **Messaging Flow**
   - Open inbox
   - Select conversation
   - Send message
   - Verify message appears

5. **Invoice Flow**
   - Create invoice from job
   - Send invoice
   - Mark as paid
   - Verify payment recorded

6. **Calendar Booking Flow**
   - Create booking
   - View in calendar
   - Edit booking
   - Cancel booking

---

## Testing Checklist

### Unit Tests Checklist

- [ ] **Models** (8 files)
  - [ ] Job model
  - [ ] Contact model
  - [ ] Booking model
  - [ ] Message model
  - [ ] Payment model
  - [ ] All other models

- [ ] **Utilities** (3 files)
  - [ ] ProfessionConfig
  - [ ] Constants
  - [ ] Keyboard shortcuts

- [ ] **Services** (2 files - when ready)
  - [ ] SupabaseService
  - [ ] OfflineQueueManager

**Target:** 50+ unit tests

---

### Widget Tests Checklist

- [ ] **Global Widgets** (23 files)
  - [ ] PrimaryButton
  - [ ] FrostedBottomNavBar
  - [ ] SearchBar
  - [ ] EmptyStateCard
  - [ ] ErrorStateCard
  - [ ] All other global widgets

- [ ] **Component Widgets** (106 files - priority)
  - [ ] ContactCard
  - [ ] JobCard
  - [ ] BookingCard
  - [ ] MessageBubble
  - [ ] InvoiceCard
  - [ ] Top priority components

- [ ] **Screen Widgets** (76 files - critical first)
  - [ ] HomeScreen
  - [ ] JobsScreen
  - [ ] ContactsScreen
  - [ ] InboxScreen
  - [ ] MoneyScreen
  - [ ] All detail screens
  - [ ] All form screens

**Target:** 100+ widget tests

---

### Integration Tests Checklist

- [ ] **Critical Flows** (6 flows)
  - [ ] Onboarding flow
  - [ ] Create job flow
  - [ ] Contact management flow
  - [ ] Messaging flow
  - [ ] Invoice flow
  - [ ] Calendar booking flow

- [ ] **Navigation Flows**
  - [ ] Bottom navigation
  - [ ] Drawer navigation
  - [ ] Deep linking

- [ ] **Error Handling Flows**
  - [ ] Network error handling
  - [ ] Form validation errors
  - [ ] Empty state handling

**Target:** 10+ integration tests

---

## Test Organization

### Folder Structure
```
test/
├── unit/
│   ├── models/
│   │   ├── job_test.dart
│   │   ├── contact_test.dart
│   │   └── ...
│   ├── utils/
│   │   ├── profession_config_test.dart
│   │   └── ...
│   └── services/
│       └── ...
├── widget/
│   ├── global/
│   │   ├── primary_button_test.dart
│   │   └── ...
│   ├── components/
│   │   └── ...
│   └── screens/
│       ├── contacts/
│       │   └── contacts_screen_test.dart
│       └── ...
└── integration/
    ├── create_job_flow_test.dart
    └── ...
```

---

## Running Tests

### Run All Tests
```bash
flutter test
```

### Run Specific Test File
```bash
flutter test test/unit/models/job_test.dart
```

### Run with Coverage
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Run Integration Tests
```bash
flutter test integration_test/
```

---

## Test Coverage Goals

| Category | Current | Target | Priority |
|----------|---------|--------|----------|
| Unit Tests | 0% | 80% | HIGH |
| Widget Tests | 0% | 70% | HIGH |
| Integration Tests | 0% | 50% | MEDIUM |
| **Overall** | **0%** | **70%** | **HIGH** |

---

## Testing Best Practices

### 1. Test Naming
```dart
// ✅ Good
test('calculates days overdue correctly', () {});
testWidgets('displays loading state initially', (tester) async {});

// ❌ Bad
test('test1', () {});
testWidgets('test', (tester) async {});
```

### 2. Test Organization
```dart
// ✅ Good - Use groups
group('Job Model', () {
  group('Serialization', () {
    test('toJson works', () {});
    test('fromJson works', () {});
  });
  
  group('Computed Properties', () {
    test('isOverdue works', () {});
  });
});
```

### 3. Test Isolation
```dart
// ✅ Good - Each test is independent
test('test1', () {
  final job = Job(/* ... */);
  // Test job
});

test('test2', () {
  final job = Job(/* ... */); // Fresh instance
  // Test job
});
```

### 4. Mock Data
```dart
// ✅ Good - Use test fixtures
final testJob = Job(
  id: 'test-1',
  title: 'Test Job',
  // ... minimal required fields
);
```

### 5. Async Testing
```dart
// ✅ Good - Use await and pumpAndSettle
await tester.pumpAndSettle();
expect(find.text('Loaded'), findsOneWidget);
```

---

## Common Testing Patterns

### Testing State Changes
```dart
testWidgets('updates state on button tap', (tester) async {
  await tester.pumpWidget(MyWidget());
  
  expect(find.text('Initial'), findsOneWidget);
  
  await tester.tap(find.byKey(Key('update_button')));
  await tester.pump();
  
  expect(find.text('Updated'), findsOneWidget);
});
```

### Testing Navigation
```dart
testWidgets('navigates to detail screen', (tester) async {
  await tester.pumpWidget(MyApp());
  
  await tester.tap(find.text('View Details'));
  await tester.pumpAndSettle();
  
  expect(find.byType(DetailScreen), findsOneWidget);
});
```

### Testing Forms
```dart
testWidgets('validates required fields', (tester) async {
  await tester.pumpWidget(MyForm());
  
  await tester.tap(find.text('Submit'));
  await tester.pump();
  
  expect(find.text('Title is required'), findsOneWidget);
});
```

### Testing Lists
```dart
testWidgets('displays all items in list', (tester) async {
  await tester.pumpWidget(MyList(items: testItems));
  
  expect(find.byType(ListTile), findsNWidgets(5));
  expect(find.text('Item 1'), findsOneWidget);
});
```

---

## Next Steps

1. **Start with Unit Tests** (Week 1)
   - Test all models
   - Test utilities
   - Get to 50+ unit tests

2. **Add Widget Tests** (Week 2-3)
   - Test critical components
   - Test critical screens
   - Get to 100+ widget tests

3. **Add Integration Tests** (Week 4)
   - Test critical flows
   - Get to 10+ integration tests

4. **Maintain Coverage** (Ongoing)
   - Run tests before commits
   - Aim for 70%+ coverage
   - Fix failing tests immediately

---

**Testing Strategy Created:** 2025-01-27  
**Estimated Time to 70% Coverage:** 4-6 weeks

