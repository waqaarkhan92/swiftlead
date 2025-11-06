# Swiftlead v2.5.1 — Screen Layouts & Component Blueprints (10/10 Enhanced)

*Screen Layouts – v2.5.1 Enhanced to 10/10 (Final)

*Enhanced v2.5.1 — UX improvements, widget optimization, and micro-interactions applied 2025-11-02.*

> **📝 Document Updates Note:** This document has been updated to reflect the actual implementation. The Drawer Menu section (§1050) now includes **Contacts** and **Reviews** in addition to the originally specified items (AI Hub, Reports & Analytics, Settings, Support & Help, Legal / Privacy). These updates align the specification with the current application implementation.

> **v2.5.1 Enhancement Note:** Added comprehensive state handling (empty/loading/error), improved micro-interactions, skeleton loaders, tooltips, contextual help, progress indicators, and optimized widget usage across all screens. Enhanced responsive behavior and accessibility.

Complete visual specification for screen layouts, component hierarchies, and interaction patterns.

> **Adaptive Profession Note:**  
> All screen layouts dynamically adjust module names and visibility according to `IndustryProfile` and the user's selected profession (Trade, Salon/Clinic, Professional).  
> Layouts automatically hide non-relevant tiles and re-label tabs as defined in `product_definition_v2.5.1.md §3.14`.

> **Responsiveness Note:**  
> All layouts are responsive across breakpoints with adaptive touch targets and gesture support.  
> Mobile: 1-column flow with bottom nav, minimum 44x44pt touch targets.  
> Tablet: 2-column hybrid with drawer visible, adaptive density.  
> Web: 3-column adaptive grid (`maxWidth: 1024px`), full keyboard navigation.

---

## Quick Reference Summary

| Screen | Key Components | Data Source | Loading State | Empty State | Error State |
|---------|----------------|--------------|---------------|-------------|-------------|
| Home | FrostedAppBar, MetricsGrid, ChartCard, TrendTile, QuickActionChip, ActivityFeedRow, AIInsightBanner | get-dashboard-metrics | Skeleton metrics + chart | "Welcome! Start by adding your first job" + CTA | "Failed to load dashboard" + Retry |
| Inbox | FrostedAppBar, ChannelFilterChipsRow, ChatListView, ChatBubble, MessageComposerBar | /send_message | Skeleton list (5 rows) | "No conversations yet" + CTA "Start conversation" | "Connection failed" + Retry + Offline banner |
| Jobs | FrostedAppBar, JobCardList, ProgressPill | jobs.* | Skeleton cards | "Create your first job" + CTA | "Failed to load jobs" + Retry |
| Calendar | CalendarWidget, BookingList | bookings.* | Skeleton calendar | "No bookings scheduled" + CTA | "Failed to sync calendar" + Retry |
| Money | ChartCard, PaymentList | get-revenue-breakdown | Skeleton chart + list | "No transactions yet" + CTA "Send invoice" | "Failed to load transactions" + Retry |
| Reports | ChartCard, TrendTile | get-automation-stats | Skeleton charts | "Not enough data yet" + Info | "Failed to load reports" + Retry |
| AI Hub | AIReceptionistThread, SmartTileGrid | /ai_router | Skeleton tiles | "Configure AI to get started" + CTA | "AI service unavailable" + Retry |

---

## 🟩 PRIMARY TABS

### 1. HomeScreen (Revolut × Swiftlead Dashboard)

**Purpose:** Premium, data-rich, and interactive dashboard hub with real-time updates, smart insights, and comprehensive 10/10 UX features. (Note: Real-time updates deferred until backend is wired. Current implementation uses pull-based approach with progressive loading for instant perceived performance.)

**Sections (Top → Bottom):**

1. **FrostedAppBar** → greeting with time-of-day ("Good morning, Alex"), profile icon, notification badge with count
   - Haptic feedback on profile tap
   - Smooth page transitions on navigation

2. **Celebration Banner** (Conditional) → Milestone achievement notifications
   - Elastic bounce animation on appear
   - Auto-dismiss after 4 seconds
   - Dismissible with X button
   - Examples: "🎉 You hit £10k revenue!", "🚀 50 active jobs! Amazing work!"

3. **Swipeable Cards Section** → PageView with Today's Summary + Automation Insight Cards
   - **Today's Summary Card** (Hero card, first in sequence):
     - Gradient background (primaryTeal → accentAqua)
     - Displays: Active Jobs, Bookings, Messages
     - Animated counters with easeOutQuint
     - Greeting message based on time of day
   - **Automation Insight Cards** (4 cards, swipeable):
     - Time Saved (hours, trend %)
     - Actions Completed (count, trend %)
     - Success Rate (%, trend %)
     - Cost Saved (£, trend %)
     - Left accent border (3px, colored by metric)
     - Subtle background tint
     - Tap to navigate to AI Hub
     - Animated page indicator with smooth transitions
   - Haptic feedback on page change

4. **Time Range Selector** → SegmentedControl for metrics period
   - Options: 7D, 30D, 90D
   - Affects all metrics and comparisons
   - Haptic feedback on selection
   - Smooth loading state during transition

5. **MetricsRow** → 4 KPIs with interactive features (Revenue, Active Jobs, Messages, Conversion)
   - **Interactive Metrics:**
     - Tap → Opens detailed breakdown sheet (MetricDetailSheet)
     - Long-press → Context menu (View Details, Compare Periods, Export, Share)
     - Haptic feedback on all interactions
   - **Animated Counters:**
     - Numbers animate from 0 on load (800ms, easeOutQuint)
     - Updates smoothly when period changes
   - **Trend Indicators:**
     - Mini sparkline graphs
     - Percentage change vs. previous period
     - "vs. last [period]" comparison text
     - Color-coded (green up, red down)
   - **Rich Tooltips:**
     - Info icon on each metric
     - Long-press shows detailed breakdown
   - **Smart Prioritization:**
     - Tracks user interactions (tap counts, last viewed)
     - Metrics adapt order based on usage patterns
     - Revenue always prioritized

6. **Predictive Insights** (Conditional) → AI-powered forecast banner
   - "Based on current trends, you're on track for £X this month"
   - Tap to view detailed forecast
   - Dismissible

7. **AIInsightBanner** → Contextual AI suggestions
   - "AI found 3 unconfirmed bookings — confirm now?"
   - "2 quotes haven't received responses — send follow-up?"
   - Dismissible with X button
   - Tap to view details with smooth page transition
   - Haptic feedback on interactions
   - Auto-hides after action taken

8. **Upcoming Schedule Section** (Collapsible) → SmartCollapsibleSection
   - Shows next 3 bookings with:
     - Client name and service type
     - Time until booking
     - Travel time to first appointment
     - Conflict warnings
   - "View All" button → Calendar screen
   - Haptic feedback on expand/collapse
   - Smooth SizeTransition animation

9. **Weather Forecast Section** (Collapsible, Contextual) → SmartCollapsibleSection
   - Only shows when relevant (outdoor jobs, daytime hours)
   - Displays: Temperature, Condition, Precipitation %, Wind speed
   - Info banner with job planning advice
   - Contextual hiding logic:
     - Hidden if evening/night and no outdoor jobs
     - Hidden if no upcoming outdoor jobs
   - Haptic feedback on expand/collapse

10. **Goal Progress Section** (Collapsible) → SmartCollapsibleSection
    - Summary stats: Total Goals, On Track, Completed
    - Progress bars for key goals (Monthly Revenue, Jobs Completed)
    - Color-coded progress (green ≥70%, yellow ≥40%, red <40%)
    - "Manage" button → Goal Tracking screen
    - Haptic feedback on expand/collapse

11. **QuickActionChipsRow** → Horizontal scroll of action chips
    - "On My Way" (ETA sharing)
    - "Add Job" (with + icon)
    - "Send Payment" (with currency icon)
    - "Book Slot" (with calendar icon)
    - "AI Insights" (with sparkle icon)
    - Haptic feedback on tap
    - Smooth page transitions on navigation
    - Tooltip on hover showing what each action does

12. **ActivityFeed** → Chronological list with infinite scroll
    - Icon badges per event type (job, payment, message, booking)
    - Relative timestamps (Just now, 2h ago, Yesterday)
    - Swipe right for quick actions (view details, respond)
    - Pull-to-refresh syncs latest
    - Loading: Skeleton feed rows (progressive loading)
    - Empty: "All caught up!" with celebration icon

**Components Used:**
- **AnimatedCounter** → Animated number counter widget (easeOutQuint, 800ms)
- **MetricDetailSheet** → Detailed breakdown modal with charts, comparisons, breakdown, export/share
- **CelebrationBanner** → Milestone celebration with elastic bounce animation
- **SmartCollapsibleSection** → Collapsible section with smooth SizeTransition
- **ContextMenu** → Long-press context menu with actions
- **TrendTile** → Metric cards with sparklines and percentage change (now interactive)
- **QuickActionChip** → Action chips with tooltips and haptic feedback
- **AIInsightBanner** → Dismissible contextual AI suggestions
- **ActivityFeedRow** → Feed items with swipe actions
- **SkeletonLoader** → Loading states with shimmer animation
- **Badge** → Unread/count indicators
- **SegmentedControl** → Time range selector (7D/30D/90D)
- **FrostedContainer** → Glass-morphism containers for all cards
- **PageView** → Swipeable cards with animated page indicators

**Enhancements (v2.5.1 - 10/10 Features):**
- **Interactive Metrics:** All metrics tappable → detailed breakdown sheets with charts, comparisons, export/share
- **Animated Counters:** Numbers animate from 0 on load (easeOutQuint, 800ms) for premium feel
- **Time Range Selector:** 7D/30D/90D selector affects all metrics with smooth transitions
- **Progressive Disclosure:** Collapsible sections (Weather, Goals, Schedule) with SizeTransition animations
- **Context Menus:** Long-press any metric → context menu (View Details, Compare, Export, Share)
- **Smart Prioritization:** Tracks user interactions, adapts metric order based on usage patterns
- **Predictive Insights:** AI-powered forecast banners ("On track for £X this month")
- **Comparison Views:** All metrics show "vs. last period" with trend percentages
- **Contextual Hiding:** Weather widget hides when not relevant (evening, no outdoor jobs)
- **Smart Defaults:** Framework for role-based adaptation (ready for future enhancement)
- **Rich Tooltips:** Info icons on metrics, long-press for detailed breakdown
- **Smooth Animations:** Page transitions (fade + slide), animated page indicators, smooth chart updates
- **Haptic Feedback:** Medium impact on taps, light on selections, heavy on long-press
- **Progress Celebrations:** Milestone celebration banners with elastic bounce animation
- **Progressive Loading:** 3-phase loading (critical metrics → charts → feed) for instant perceived speed
- **Keyboard Shortcuts (Web):** Framework in place (Ctrl+R for refresh, extensible)
- **Parallax Effects:** Structure in place for scroll-based depth (can be enabled)
- **Error Recovery:** Network errors show inline retry without blocking the view
- **Reduced Motion Support:** Respects system preference, uses fade instead of slide

**Behaviour Notes:**
- **Progressive Loading:** Loads critical metrics first (instant UI), then charts (100ms delay), then feed (200ms delay)
- **Interactive Metrics:** Tap opens MetricDetailSheet with full-screen draggable modal, charts, comparisons, breakdown
- **Context Menus:** Long-press shows popup menu positioned at touch point, heavy haptic feedback
- **Animated Counters:** All numeric values animate from 0 on load and when period changes
- **Collapsible Sections:** Smooth SizeTransition (300ms) with rotation animation on chevron icon
- **Swipeable Cards:** PageView with 5 cards (Today's Summary + 4 Automation cards), animated page indicators
- **Smart Prioritization:** Tracks tap counts and last viewed timestamps, calculates priority scores
- **Milestone Tracking:** Monitors revenue, jobs, automation stats for milestones, shows celebration banners
- **Contextual Weather:** Logic checks hour of day and service types to determine relevance
- **Page Transitions:** All navigations use fade + slide transitions (300ms, easeOutCubic)
- **Haptic Feedback:** Consistent haptic on all interactions (light/medium/heavy based on action type)
- **Activity feed uses virtualized scrolling for performance**
- **Quick action chips show subtle scale animation on tap with haptic feedback**

**Layout Variants:**
| Device | Layout | Special Behaviors |
|--------|--------|-------------------|
| Mobile | Single column, floating nav | Sticky metrics on scroll, swipe for quick actions |
| Tablet | Two-column with right sidebar | Drawer always visible, metrics + chart side-by-side |
| Web | Three-column adaptive | Keyboard shortcuts enabled, hover tooltips active |

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Loading | Skeleton metrics, chart, feed (shimmer animation) | None | Loads in sequence: metrics → chart → feed |
| Empty (New User) | Welcome illustration, "Welcome to Swiftlead!" | "Add Your First Job" button | Highlights key features, shows tutorial option |
| Error | "Failed to load dashboard" | "Try Again" button | Retry loads only failed sections, maintains loaded data |
| Offline | Banner: "You're offline" + cached data | "Dismiss" | Shows last cached data with timestamp |

---

### 2. InboxScreen (WhatsApp-Inspired Omni Inbox)

**Purpose:** Unified message center for all channels with smart filtering and AI assistance.

**Sections:**

1. **FrostedAppBar** → compose icon (primary action), overflow menu (secondary actions: scheduled messages, filter)
   - iOS-aligned: Maximum 2 icons (primary action + more menu)
   - Search and filter moved to overflow menu (iOS pattern)
   - Filter count badge shown in menu item when active
2. **ChannelFilterChipsRow** → Horizontal scrollable chips
   - All (default) | SMS | WhatsApp | Instagram | Facebook | Email
   - Active chip shows count badge
   - Haptic feedback on selection
   - Tooltip shows channel name on long-press
3. **ChatListView** → Full-width list with optimized performance
   - **ChatTitleRow:** Contact name + last message preview + timestamp
   - **ChannelIconBadge:** Small logo per channel with tooltip
   - **UnreadBadge:** Teal dot + bold text for unread
   - **PinnedIndicator:** Pin icon for pinned chats (always at top)
   - **TypingIndicator:** Animated dots when contact is typing
   - **SwipeActions:** 
     - Left: Archive (with haptic)
     - Right: Pin/Unpin (with haptic)
   - **LongPress:** Context menu (Mark read, Assign, Add note, Delete)
   - **Avatar:** Optional, shown in dark mode for better separation
   - **Divider:** 0.5px hairline between conversations
4. **FloatingActionButton** → "+ New Chat" with extended label on scroll up
   - Shows "+24" badge if 24+ unread
   - Morphs to extended FAB on scroll up
   - Haptic on tap

**Components Used:**
- ChatBubble (Inbound / Outbound)
- MessageComposerBar (with attachment, payment, AI buttons)
- ChannelIconBadge (with tooltip)
- PinnedChatRow (dismissible)
- UnreadBadge (with count)
- TypingIndicator (animated)
- SearchBar (expandable)
- SkeletonLoader (for loading)
- SwipeAction (archive/pin)
- ContextMenu (long-press)
- Badge (filter count, unread count)
- Avatar (optional, dark mode)

**Enhancements (v2.5.1):**
- **Smart Filtering:** Filter combinations (e.g., "Unread WhatsApp messages")
- **Quick Search:** Recent contacts and search history appear immediately
- **Batch Actions:** Long-press to select multiple, show action bar
- **Read Receipts:** Visual indication of message delivery and read status
- **Voice Note Preview:** Inline waveform player for voice messages
- **Link Previews:** Rich previews of URLs in messages
- **Offline Indicator:** Banner when offline, shows last sync time
- **Smart Sorting:** Pinned → Unread → Recent → Archived
- **Keyboard Navigation (Web):** Arrow keys navigate, Enter opens, Space selects
- **Reduced Motion:** Disables swipe animations, uses fade instead

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Animated Counter:** Unread count in app bar title animates from 0 (easeOutQuint, 800ms)
  - **Smart Collapsible Sections:** Time-based grouping (Today, This Week, Older) with expand/collapse
  - **Custom Page Transitions:** Smooth fade + slide transitions via `_createPageRoute()` helper
- **Phase 2 - Intelligence:**
  - **Smart Prioritization:** Threads sorted by pinned → priority → unread → interaction frequency → recency
  - **Contextual Hiding:** Hides threads inactive >30 days (unless unread, pinned, or recently opened)
  - **AI Insight Banners:** Contextual suggestions (e.g., "5+ unread messages - catch up?")
  - **Interaction Tracking:** Tracks `_threadTapCounts` and `_threadLastOpened` for adaptive ordering
- **Phase 3 - Delight:**
  - **Celebration Banners:** Milestone celebrations (1st, 10th, 25th, 50th, 100th conversation) at top of list
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K, Cmd+N, Cmd+R, Esc)
  - **Rich Tooltips:** Long-press thread items shows detailed breakdown (channel, last message, priority, status)
  - **Staggered Animations:** List items fade-in + slide-up with staggered delays (300ms + index * 50ms)

**Behaviour Notes:**
- Unread chats show teal accent dot and semi-bold contact name
- DividerLine = 0.5px adaptive hairline (responds to theme)
- Swipe left/right with haptic feedback and spring animation
- Avatar displays only in dark mode for visual density
- Typing indicator appears when contact is actively typing
- Pull-to-refresh syncs all channels
- Virtualized list for performance with 1000+ conversations

#### InboxThreadScreen (Chat Thread)

**Sections:**

1. **FrostedAppBar** → back button, contact name, channel icon badge, overflow menu (•••)
   - Overflow menu: View contact, Search in chat, Mute, Archive, Block
   - Subtitle shows "Last seen 5m ago" or "Typing..."
2. **ChatThreadView** → Chronological message list
   - **MissedCallNotification:** Inline missed call notification displayed chronologically with messages
     - Shows missed call timestamp, phone number
     - "Call Back" button (opens phone dialer)
     - "Text Back" button (sends branded text-back message if not already sent)
     - Shows "Text-back sent" badge if automated text-back was sent
     - Orange-themed card with phone icon
   - **ChatBubble (Inbound):** Left-aligned, avatar (optional), timestamp, read receipt
   - **ChatBubble (Outbound):** Right-aligned, teal gradient, sending/sent/failed status
   - **MediaThumbnail (if message has attachment):** Attachment thumbnail displayed above message bubble, tap to open MediaPreviewModal for full-screen viewing
   - **DateSeparator:** "Today", "Yesterday", specific date for older
   - **LinkPreviewCard:** Rich preview for URLs
   - **VoiceNotePlayer:** Inline audio with waveform
   - **MediaGallery:** Tap to view full-screen with swipe
   - **AIResponseBadge:** "AI" badge on automated replies
   - Tap timestamp to show detailed delivery info
   - Long-press for context menu (Reply, Forward, Copy, Delete)
3. **InternalNotesButton** → Floating button for team notes
   - Shows note count badge if notes exist
   - Slides in from right when tapped
4. **MessageComposerBar** → Bottom sticky input
   - **TextInput** with auto-expanding height (max 5 lines)
   - **AttachmentButton:** Opens media picker (camera, photos, files)
   - **PaymentButton:** Quick payment request
   - **AIReplyButton:** Suggests AI-generated responses
   - **SendButton:** Teal gradient, disabled when empty, haptic on send
   - Character counter appears at 140+ characters
   - Shows "Contact is typing..." when they're typing

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Loading | Skeleton message bubbles | None | Loads recent messages first, older on scroll |
| Empty | "Start conversation" illustration | Suggested responses (e.g., "Hi [Name]!") | Shows templates and quick replies |
| Sending | Progress indicator on message | None | Shows sending status, allows retry on failure |
| Error | "Failed to send" on message bubble | "Try Again" | Allows manual retry with offline queue |
| Offline | "You're offline" banner with queued count | Tap to view details | Messages queued, sent when online. Shows "X messages queued" badge |

**Enhancements (v2.5.1):**
- **Conversation Preview:** Long-press conversation in inbox list to preview without opening full thread
  - Shows contact info, recent messages (last 3), unread count, channel badge
  - Quick actions: Open conversation, View contact, Archive, Pin/Unpin
  - Opens in 3/4 height bottom sheet with frosted glass effect
- **Priority Inbox:** AI-determined priority (High/Medium/Low) displayed as colored badge next to contact name
  - High priority: Red badge with upward arrow
  - Medium priority: Yellow badge with horizontal line
  - Low priority: Blue badge with downward arrow
  - Sorting: Pinned → Priority (High → Medium → Low) → Unread → Recent
  - Filter by priority in filter sheet (All/High/Medium/Low)
  - Filter by lead source in filter sheet (All/Google Ads/Facebook Ads/Website/Referral/Direct) - Note: Lead Source represents lead attribution (where the lead came from), distinct from message channel (communication platform)
- **Smart Reply Suggestions:** AI suggests 3 quick replies based on context
- **Scheduled Messages:** 
  - **Quick Schedule:** Long-press send button in message composer opens bottom sheet (`ScheduleMessageSheet`) to set date/time
  - **Manage Scheduled:** Full screen (`ScheduledMessagesScreen`) accessible from inbox header to view, edit, cancel, or delete all scheduled messages
  - Shows pending/sent/cancelled status, scheduled time, and allows editing or cancellation
- **Message Reactions:** Tap-hold to add emoji reaction
  - **Voice Input:** Hold mic button to record voice note with amplitude visualization
  - **Search in Thread:** Find specific messages or media
  - **Create Job:** Work icon button in MessageComposerBar opens job creation form with pre-filled client details
  - **AI Extract Job:** AI Extract button in MessageComposerBar extracts job details from conversation and pre-fills job form

---

### 3. JobsScreen (Pipeline + CRM Hybrid)

**Purpose:** Visual job pipeline with status tracking and quick actions.

**Sections:**

1. **FrostedAppBar** → add job icon (primary action), overflow menu (secondary actions: filter, search, sort, view toggle)
   - iOS-aligned: Maximum 2 icons (primary action + more menu)
   - Filter, search, sort, view toggle moved to overflow menu (iOS pattern)
   - Filter count badge shown in menu item when active
   - View toggle remains in content area as SegmentedControl (good UX)
2. **PipelineTabs** → SegmentedControl with counts
   - All (24) | Active (18) | Completed (6) | Cancelled (0)
   - Badge shows count per status
   - Smooth slide transition between tabs
3. **View Mode Toggle** → SegmentedControl (List | Kanban)
   - List view: Standard card grid
   - Kanban view: Columns grouped by status (Proposed → Scheduled → In Progress → Completed → Cancelled)
   - Drag-and-drop jobs between columns to change status
   - Column headers show job count badges
4. **JobCardList** → Card grid with rich information (List view)
   - **JobCard:** Contains:
     - **ClientAvatar** with name
     - **JobTitle** and **ServiceType** badge
     - **ProgressPill** showing status (Quoted → Scheduled → In Progress → Completed)
     - **DateChip** showing due date or completion date
     - **PriceTag** showing job value
     - **TeamMemberAvatar** (if assigned)
     - **QuickActions:** Three-dot menu (Edit, Clone, Cancel)
   - Swipe right for quick complete
   - Long-press for batch selection
   - Drag to reorder (web only)
4. **FilterSheet** → Slide-up panel
   - Date range picker
   - Service type chips
   - Team member selector
   - Price range slider
   - Status checkboxes
   - "Apply Filters" button with count
5. **FloatingActionButton** → "+ New Job" with extended label
   - Quick actions on long-press: "From Quote", "From Scratch", "From Template"
   - Also accessible from: Inbox thread (Create Job button), Booking detail (Create Job menu option)

**Components Used:**
- JobCard (rich information card)
- ProgressPill (status indicator)
- QuickActionChip (filter, sort)
- SegmentedControl (pipeline tabs)
- SkeletonLoader (loading state)
- EmptyStateCard (no jobs)
- FilterSheet (bottom sheet)
- DateChip (due dates)
- Badge (counts, status)
- SwipeAction (complete, archive)
- ContextMenu (long-press)

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) via `_createPageRoute()` helper
- **Phase 2 - Intelligence:**
  - **Smart Prioritization:** Jobs sorted by active status → interaction frequency → recency
  - **Contextual Hiding:** Hides completed jobs >30 days old (unless recently opened)
  - **AI Insight Banners:** Contextual suggestions (e.g., "3 overdue jobs - follow up?")
  - **Interaction Tracking:** Tracks `_jobTapCounts` and `_jobLastOpened` for adaptive ordering
- **Phase 3 - Delight:**
  - **Celebration Banners:** Milestone celebrations (1st, 10th, 25th, 50th, 100th job) at top of list
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K, Cmd+N for create job, Cmd+R, Esc)
  - **Staggered Animations:** Job cards fade-in + slide-up with staggered delays (300ms + index * 50ms)

#### JobDetailScreen

**Purpose:** Comprehensive job view with timeline, communications, and actions.

**Sections:**

1. **FrostedAppBar** → back button, job title, edit icon, overflow menu
   - Overflow: Share, Duplicate, Delete
2. **JobSummaryCard** → Key information at top
   - **ClientInfo:** Avatar, name, phone, email (tap to call/message)
   - **ServiceBadge:** Type of service
   - **ProgressBar:** Visual completion percentage (0-100%)
   - **StatusPill:** Current status with color coding
   - **KeyMetrics:** Date created, due date, time spent, value
3. **iOS-style Bottom Toolbar** → Sticky at bottom (replaces ActionButtonsRow)
   - **Secondary Actions Toolbar:** Icon + label buttons (Message, Quote, Invoice)
   - **Primary Action:** Full-width "Mark Complete" button at bottom
   - iOS pattern: Secondary actions in toolbar, primary action below
   - FrostedContainer with shadow for visual separation
4. **JobTabView** → Primary tabs + More dropdown
   - **Primary Tabs (3):** Timeline, Details, Notes
     - Displayed as horizontal SegmentedControl
   - **More Menu:** Messages, Media, Chasers
     - Dropdown menu button next to primary tabs
     - Shows checkmark when a More option is selected
   - **Timeline Tab:** Chronological activity feed
     - Status changes with timestamps
     - Messages linked to job
     - Quotes sent/accepted
     - Invoices created/paid
     - Reviews received
     - Team member actions
     - Pull-to-refresh updates
   - **Details Tab:** Full job information
     - Service details
     - Location with map preview (tap for navigation)
     - Custom fields
     - Internal notes (team only)
     - Attachments and files
   - **Notes Tab:** Team collaboration notes
     - Add notes with @mentions
     - Shows note author and timestamp
     - Edit/delete own notes
     - Notifications on @mention
   - **Messages Tab:** (Accessible via More menu)
     - Linked conversation thread
     - Shows relevant messages
     - Quick reply inline
     - Link new messages
   - **Media Tab:** (Accessible via More menu)
     - Photo gallery
     - Before/after sections
     - Tap to fullscreen with swipe
     - Add photos with camera/library
     - Captions and timestamps
   - **Chasers Tab:** (Accessible via More menu)
     - Quote chaser log
     - Follow-up reminders
5. **InternalNotesSection** → Team collaboration
   - Add notes with @mentions
   - Shows note author and timestamp
   - Edit/delete own notes
   - Notifications on @mention

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Loading | Skeleton job card + timeline | None | Progressive loading: summary → timeline → media |
| Empty Timeline | "No activity yet" | None | Shows when to expect updates |
| Empty Media | "No photos uploaded" | "Add Photos" | Opens camera/gallery |
| Error | "Failed to load job details" | "Try Again" | Retry preserves context |

**Enhancements (v2.5.1):**
- **Quick Status Change:** Tap status pill to change instantly
- **Inline Editing:** Tap any field to edit without modal
- **Smart Suggestions:** AI suggests next actions based on status
- **Duplicate Detection:** Warns if similar job exists
- **Custom Fields:** Add profession-specific fields (e.g., "Property Type" for trades)
- **Keyboard Shortcuts (Web):** `E` = Edit, `M` = Message, `C` = Complete
- **Photo Annotations:** Draw on photos before saving
- **Offline Support:** Changes sync when back online

**Behaviour Notes:**
- ProgressPill reflects live job status via real-time subscription
- Sticky action bar remains visible during scroll with frosted background
- Timeline auto-updates via realtime subscription
- Media gallery uses lazy loading for performance
- Status changes trigger notifications to client and team

---

### 4. CalendarScreen (Bookings & Scheduling)

**Purpose:** Visual calendar with smart availability and booking management.

**Sections:**

1. **FrostedAppBar** → add booking icon (primary action), overflow menu (secondary actions: today, search, filter, templates, analytics, etc.)
   - iOS-aligned: Maximum 2 icons (primary action + more menu)
   - Search, filter, today, templates moved to overflow menu (iOS pattern)
   - View toggle remains in content area (good UX)
   - View toggle with icons: 📅 (day) | 📆 (week) | 🗓️ (month)
   - "Today" button jumps to current date
   - **Swipe Actions:** Swipe right on BookingCard to mark confirmed, swipe left to cancel/delete
   - **Long-press Context Menu:** Long-press BookingCard for Edit, Call Client, Message Client, Share, Cancel Booking
2. **CalendarHeader** → Month/week navigation
   - **← Today →** navigation with smooth transitions
   - **Month/Year** display
   - **WeekdayLabels** with current day highlighted
3. **CalendarWidget** → Interactive calendar grid
   - **DayCell:** Shows date + event dots (up to 3, then "+2" indicator)
   - **EventDot:** Color-coded by status (confirmed, pending, cancelled)
   - **JobDot:** Scheduled jobs displayed alongside bookings (different dot style/color)
   - **CurrentDayHighlight:** Teal ring around today
   - **EventPreview:** Tap day to see all events (bookings + scheduled jobs)
   - **MultiSelect:** Long-press to select multiple days
   - **Availability Overlay:** Shows available/blocked times
4. **BookingList** → Cards below calendar (or right sidebar on tablet/web)
   - **BookingCard:** Contains:
     - **TimeSlot:** Start - end time with duration
     - **ClientInfo:** Avatar + name
     - **ServiceBadge:** Type of service
     - **StatusPill:** Confirmed/Pending/Cancelled
     - **LocationChip:** If on-site
     - **DepositIndicator:** $ icon if deposit required
     - **ReminderStatus:** Bell icon with checkmark if reminder sent
     - **QuickActions:** Message, Reschedule, Cancel, Complete
   - Swipe right to mark complete
   - Swipe left to cancel
   - Tap to view full details
   - **JobCard:** Scheduled jobs displayed alongside bookings (tap to navigate to JobDetailScreen)
     - Shows job title, client name, scheduled date/time, status badge
     - Different styling from BookingCard for visual distinction
5. **TeamCalendarToggle** → Show all team calendars
   - Checkbox per team member
   - Color-coded events per member
   - "View All" / "View Mine" quick toggle
6. **FloatingActionButton** → "+ Book Slot"
   - Quick actions: "New Booking", "Block Time", "Copy Previous Day"

**Components Used:**
- CalendarWidget (month/week/day views)
- BookingCard (with status and actions)
- EventDot (status indicator)
- StatusPill (confirmed/pending/cancelled)
- TimeSlot (duration display)
- SkeletonLoader (loading calendar)
- EmptyStateCard (no bookings)
- Badge (event count)
- SwipeAction (complete/cancel)
- ContextMenu (long-press)

**Enhancements (v2.5.1):**
- **Smart Availability:** AI suggests best time slots based on history
- **Recurring Bookings:** Create repeating patterns (daily, weekly, monthly)
- **Conflict Detection:** Warns of double-bookings with resolution options
- **Two-Way Sync (Requires Backend):** Google Calendar and Apple Calendar bidirectional sync - backend integration needed
- **Client Self-Booking:** Generate booking links for clients
- **Reminder Customization:** Custom timing per booking (T-24h, T-2h, T-30m)
- **Availability Rules:** Set working hours, breaks, and blocked days
- **Color Coding:** Custom colors per service type or client
- **Keyboard Shortcuts (Web):** Arrow keys navigate, `B` = New booking, `T` = Today
- **Multi-Day Events:** Support for multi-day jobs
- **Booking Templates:** `BookingTemplatesScreen` - Save/load common booking scenarios for quick creation (✅ Implemented)
- **Booking Analytics:** `BookingAnalyticsScreen` - Dashboard with booking sources, conversion rates, and peak times charts (✅ Implemented)
- **Capacity Optimization:** `CapacityOptimizationScreen` - Utilization visualization with optimization suggestions (✅ Implemented)
- **Resource Management:** `ResourceManagementScreen` - Track equipment/room availability and status (✅ Implemented)
- **Weather Integration:** Weather forecast displayed in `BookingDetailScreen` for outdoor jobs (✅ Implemented)
- **Swipe Booking:** Swipe right to complete, swipe left to cancel booking on `BookingCard` (✅ Implemented)
- **Pinch-to-Zoom:** Pinch gesture on calendar switches between week ↔ day view (✅ Implemented)
- **Buffer Time Management:** Visual indicators showing travel/buffer time between appointments in booking list, adjustable buffer (0-60min) in booking form with auto-conflict detection (✅ Implemented)
- **Quick Reschedule (Drag-and-Drop):** Drag booking cards in day view calendar to reschedule to new time slot with confirmation dialog (✅ Implemented)

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade transitions (200ms) via `_createPageRoute()` helper
- **Phase 2 - Intelligence:**
  - **Smart Prioritization:** Bookings sorted by upcoming status → interaction frequency → recency
  - **Contextual Hiding:** Hides past bookings >7 days old (unless recently opened)
  - **AI Insight Banners:** Contextual suggestions (e.g., "5+ bookings today - busy day!")
  - **Interaction Tracking:** Tracks `_bookingTapCounts` and `_bookingLastOpened` for adaptive ordering
- **Phase 3 - Delight:**
  - **Celebration Banners:** Milestone celebrations (1st, 10th, 25th, 50th, 100th booking) with elastic bounce
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K, Cmd+N, Cmd+R, Esc)
  - **Rich Tooltips:** Long-press booking items shows detailed breakdown (time, duration, status, location)
  - **Staggered Animations:** Booking cards fade-in + slide-up with staggered delays (300ms + index * 50ms)

**Behaviour Notes:**
- Calendar view persists across sessions
- Events use color saturation for status (bright = confirmed, muted = pending)
- Today button scrolls with smooth animation
- Pull-to-refresh syncs calendar integrations

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Loading | Skeleton calendar grid + booking cards | None | Shows skeleton while loading events |
| Empty Day | "No bookings for this day" | "Add Booking" | Suggests available times |
| Empty Month | "No bookings this month" | "Add First Booking" | Shows tutorial for new users |
| Sync Error | "Calendar sync failed" banner | "Retry Sync" | Retry syncs only failed calendars |
| Conflict Warning | "Double booking detected!" modal | "Resolve" / "Keep Both" | Shows conflicting events, suggests resolution |

---

### 4.1 BookingTemplatesScreen (v2.5.1 Enhancement)

**Purpose:** Manage saved booking templates for quick booking creation.

**Sections:**
1. **FrostedAppBar** → Title "Booking Templates", Add Template button
2. **TemplateList** → List of template cards
   - Each card shows: Template name, service name, duration, price, deposit info
   - Actions: Use Template, Edit, Delete (via PopupMenuButton)
   - Empty state: "No templates yet" with CTA to create
3. **TemplateCard** → Contains:
   - Template name and service type
   - Duration and price chips
   - Deposit indicator (if applicable)
   - Notes (if any)
   - "Use Template" button

**Navigation:** Calendar → Templates icon OR Create Booking → "Use Booking Template" button

---

### 4.2 BookingAnalyticsScreen (v2.5.1 Enhancement)

**Purpose:** Analytics dashboard for booking sources, conversion rates, and peak times.

**Sections:**
1. **FrostedAppBar** → Title "Booking Analytics", Period selector (Week/Month/Quarter/Year)
2. **SummaryCards** → 4 cards showing:
   - Total Bookings
   - Conversion Rate
   - Peak Time
   - Average Value
3. **Booking Sources Chart** → Pie chart showing distribution by source (Google Ads, Facebook, Website, etc.)
4. **Conversion Rates** → Bar chart/list showing conversion rates by source with percentage bars
5. **Peak Times Chart** → Bar chart showing booking frequency by hour

**Components:** fl_chart (PieChart, BarChart), SummaryCards, FrostedContainer

---

### 4.3 CapacityOptimizationScreen (v2.5.1 Enhancement)

**Purpose:** Visualize schedule utilization and receive optimization suggestions.

**Sections:**
1. **FrostedAppBar** → Title "Capacity Optimization", Period selector (Week/Month)
2. **Overall Utilization** → Circular progress indicator showing average utilization percentage
3. **Daily Utilization Chart** → Bar chart showing utilization by day of week with color coding:
   - Green: Optimal (50-90%)
   - Yellow: Underutilized (<50%)
   - Red: Overbooked (>90%)
4. **Optimization Suggestions** → List of suggestion cards with:
   - Title and description
   - Priority badge (High/Medium)
   - Impact level

**Components:** fl_chart (BarChart), CircularProgressIndicator, UtilizationSuggestionCard, InfoBanner

---

### 4.4 ResourceManagementScreen (v2.5.1 Enhancement)

**Purpose:** Track equipment and room availability.

**Sections:**
1. **FrostedAppBar** → Title "Resource Management", Add Resource button
2. **Category Filter** → SegmentedButton (All/Equipment/Rooms)
3. **ResourceList** → List of resource cards
   - Each card shows: Resource name, category icon, status badge
   - Current booking info (if in use)
   - Maintenance notes (if in maintenance)
   - Actions: Edit, Delete (via PopupMenuButton)
4. **ResourceCard** → Contains:
   - Resource name and category icon
   - Status badge (Available/In Use/Maintenance)
   - Current booking name (if in use)
   - Maintenance notes (if applicable)

**Status Badges:**
- Available: Green with check icon
- In Use: Yellow with event icon
- Maintenance: Red with build icon

**Navigation:** Calendar → Resource Management icon

---

### 4.5 BookingDetailScreen Enhancements (v2.5.1)

**Weather Forecast Section:**
- Displayed after Service Details section
- Shows: Temperature, condition icon, precipitation chance, wind speed
- InfoBanner with date-specific forecast and rescheduling suggestion
- Only shown for outdoor services (mock implementation shows for all)

**Swipe Actions on BookingCard:**
- Swipe right: Mark as completed (visual feedback with green check icon)
- Swipe left: Cancel booking (with confirmation dialog)
- Visual feedback during swipe with colored backgrounds

**Pinch-to-Zoom on Calendar:**
- Pinch out (scale > 1.2): Switch from week to day view
- Pinch in (scale < 0.8): Switch from day to week view
- GestureDetector with onScaleUpdate handler

---

### 5. MoneyScreen (Quotes, Invoices & Payments)

**Purpose:** Financial overview with quotes, invoices, transaction history, and quick payment actions.

**Sections:**

1. **FrostedAppBar** → add menu (primary action: create invoice, quote, payment, etc.)
   - iOS-aligned: Maximum 1 icon (primary action menu)
   - Filter, search, date range moved to overflow menu (iOS pattern)
   - Date range chip shown in content area when active (good UX)
   - **Long-press Context Menu:** Long-press InvoiceCard for Edit, Send Reminder, Download PDF, Share, Duplicate, Delete
   - **Batch Actions:** Reduced to 2 primary actions (Send Reminder, Mark Paid) + More menu (Download, Delete)
2. **TabBar** → SegmentedControl with tabs: Dashboard | Quotes | Invoices | Payments | Deposits
2. **Quotes Tab** (if Quotes tab selected)
   - **QuotesListView** → List of quotes with status filters (All/Draft/Sent/Viewed/Accepted/Declined/Expired)
   - **QuoteCard** → Shows client, amount, status, expiry date, quick actions
   - **FAB** → "+ New Quote" with quick actions: "From Job", "From Template", "Blank"
3. **Invoices Tab** (if Invoices tab selected)
   - **InvoiceListView** → List of invoices with status filters (All/Paid/Pending/Overdue)
4. **Dashboard Tab** (default, if Dashboard tab selected)
   - **BalanceHeader** → Large numeric display
   - **TotalBalance:** Large bold number with currency symbol
   - **TrendIndicator:** ↑ 12% vs last month (green) or ↓ 5% (red)
   - **QuickActions:** "Send Invoice", "Request Payment", "Add Expense"
   - **StripeConnectionStatus:** "Connected to Stripe" with checkmark (or connect CTA)
5. **MetricsRow** → 4 key financial metrics (Dashboard tab only)
   - **Outstanding:** Amount not yet paid (with count)
   - **Paid This Month:** Total received
   - **Pending:** In processing
   - **Overdue:** Late payments (with count and red highlight)
   - Each metric tappable for filtered view
6. **RevenueBreakdownChart** → Interactive visualization (Dashboard tab only)
   - **ChartTypeSwitcher:** Line / Bar / Donut toggle
   - **TimePeriod Selector:** 7D / 30D / 90D / 1Y / All
   - **Interactive Legend:** Tap to hide/show data series
   - **Tooltip:** Hover/tap data points for exact values
7. **TransactionFilterChips** → Quick filters (Payments tab only)
   - All | Paid | Pending | Overdue | Refunded
   - Badge shows count per status
8. **PaymentList** → Transaction history (Payments tab only)
   - **PaymentTile:** Contains:
     - **ClientInfo:** Avatar + name
     - **Amount:** Bold with currency
     - **StatusPill:** Paid/Pending/Overdue/Refunded
     - **Date:** Relative (2h ago) or absolute
     - **PaymentMethod:** Icon (Stripe, Cash, Bank Transfer)
     - **LinkedJob:** Link to related job (if applicable)
     - **QuickActions:** Three-dot menu (View Invoice, Refund, Send Reminder, Download Receipt)
   - Swipe left to refund (confirmation required)
   - Swipe right to resend payment link
   - Tap to view full invoice
   - Pull-to-refresh syncs with Stripe
9. **FloatingActionButton** → "+ New" (context-aware: Quote/Invoice/Payment based on active tab)
   - Quick actions: "Send Invoice", "Payment Link", "Record Cash Payment"

**Components Used:**
- ChartCard (revenue visualization)
- PaymentTile (transaction row)
- StatusPill (payment status)
- MetricsGrid (financial KPIs)
- SkeletonLoader (loading state)
- EmptyStateCard (no transactions)
- FilterSheet (advanced filters)
- Badge (status counts)
- SwipeAction (refund/resend)
- ContextMenu (long-press)
- Tooltip (metric explanations)

**Enhancements (v2.5.1):**
- **Real-Time Balance:** Updates live via Stripe webhooks
- **Smart Reminders:** AI suggests optimal reminder timing
- **Batch Actions:** Select multiple to send reminders or export
- **Payment Reconciliation:** Auto-match payments to invoices
- **Expense Tracking:** Record business expenses for profit tracking
<!-- REMOVED: Tax Export - Removed per decision matrix 2025-11-05 -->

- **Recurring Payments:** Setup subscription-like recurring invoices
- **Payment Plans:** Split large invoices into installments
- **Custom Payment Terms:** Net 15/30/60 with auto-reminders
- **Refund Workflow:** Track partial/full refunds with reasons
- **Keyboard Shortcuts (Web):** `I` = New invoice, `P` = Payment link

**Behaviour Notes:**
- Balance animates count-up on load
- Chart data points are tappable for drill-down
- Overdue payments highlighted with subtle red glow
- Pull-to-refresh syncs Stripe balance and recent transactions
- Swipe actions have confirmation for destructive actions

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Loading | Skeleton balance + chart + transaction list | None | Progressive: balance → chart → transactions |
| Empty | "No transactions yet" illustration | "Send First Invoice" | Highlights payment setup steps |
| Stripe Not Connected | Banner: "Connect Stripe to accept payments" | "Connect Now" | Opens Stripe OAuth flow |
| Sync Error | "Failed to sync with Stripe" banner | "Retry" | Retry shows last successful sync time |
| Zero Balance | Shows $0.00 with encouraging message | "Send Your First Invoice" | Tutorial highlight |

---



## 📥 DRAWER / SECONDARY SCREENS

### 6. AI Hub

**Purpose:** Central control for AI features with performance metrics and configuration.

**Sections:**

1. **FrostedAppBar** → settings icon, help icon
2. **AIStatusCard** → Current AI state
   - **StatusIndicator:** Active (green pulse) / Paused / Error
   - **LastActivity:** "Last response 2m ago"
   - **TodayStats:** Responses sent, leads qualified, bookings made
   - **QuickToggle:** Pause/Resume AI
3. **SmartTileGrid** → 2×2 feature tiles
   - **Auto-Reply:** Configure missed call responses
   - **Smart Replies:** AI-generated suggestions
   - **FAQ Manager:** Add/edit common questions
   - **Booking Assistant:** Configure availability
   - Each tile shows usage count badge
4. **AIReceptionistThread** → Simulated conversation
   - Shows recent AI interactions
   - **AIBubble:** Responses sent by AI (with AI badge)
   - **ClientBubble:** Incoming messages that triggered AI
   - **HandoverIndicator:** When AI transferred to human
   - Tap conversation to see full thread in Inbox
   - "View All AI Interactions" link
5. **AIConfigurationCard** → Settings quick access
   - **Tone Selector:** Formal / Friendly / Concise (chips)
   - **Business Hours:** Set active times
   - **Response Delay:** 0s / 30s / 60s (simulate human delay)
   - **Auto-Handover:** Configure when to transfer to human
6. **AIPerformanceMetrics** → Analytics dashboard
   - **Response Time:** Average time to reply
   - **Qualification Rate:** % of leads fully qualified
   - **Booking Conversion:** % of inquiries → bookings
   - **Chart:** Trend over time (line graph)
   - Tap metrics for detailed breakdown
7. **InfoBanner** → Current status
   - "AI active on WhatsApp + SMS" (green)
   - "AI paused — messages need manual reply" (yellow)
   - Tap to configure channels

**Components Used:**
- AIReceptionistThread (conversation view)
- SmartTileGrid (feature access)
- StatusIndicator (AI state)
- MetricsCard (performance data)
- ToneSelector (chip group)
- SkeletonLoader (loading)
- Toggle (pause/resume)
- Badge (activity counts)
- InfoBanner (status messages)

**Enhancements (v2.5.1):**
- **Custom Responses:** Override AI responses for specific keywords (Note: Backend verification needed once backend is wired)
- **Escalation Rules:** Smart handover based on sentiment or complexity (Note: Backend verification needed once backend is wired)
- **Voice Integration:** AI handles voice call transcriptions
<!-- REMOVED: Multi-Language - Removed per decision matrix 2025-11-05 -->
- **Confidence Scoring:** AI reports confidence level per response (Note: Backend verification needed once backend is wired)
- **Booking Assistance:** Configure AI to offer available time slots automatically (Note: Backend verification needed once backend is wired)
- **Lead Qualification:** Configure information to collect before handover (Note: Backend verification needed once backend is wired)
- **Smart Handover:** Configure handover triggers (Note: Backend verification needed once backend is wired)
- **Response Delay:** Configure delay before AI responds (Note: Backend verification needed once backend is wired)
- **Fallback Responses:** Configure message when AI is uncertain (Note: Backend verification needed once backend is wired)
- **Two-Way Confirmations:** Handle YES/NO responses automatically (Note: Backend verification needed once backend is wired)
- **Context Retention:** AI remembers previous conversations (Note: Backend verification needed once backend is wired)

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) via `_createPageRoute()` helper
  - **Progressive Disclosure:** Collapsible sections for status, performance, and configuration
- **Phase 2 - Intelligence:**
  - **Celebration Tracking:** Framework for milestone celebrations (ready for future implementation)
  - **AI Insight Banners:** Contextual AI status and performance insights
- **Phase 3 - Delight:**
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K, Cmd+R, Esc)
  - **Smooth Animations:** All navigation uses consistent page transitions

**Behaviour Notes:**
- Simulates AI receptionist chat with animated typing indicator (3 dots)
- Auto-scrolls to newest message with smooth animation
- Real-time updates when AI responds to new messages
- Pause toggle shows confirmation dialog
- Performance metrics update hourly

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Not Configured | "Setup AI receptionist" illustration | "Get Started" wizard | 3-step setup: tone → hours → test |
| Paused | "AI is paused" banner with reason | "Resume AI" | Shows stats from when it was active |
| No Activity | "No AI interactions yet" | "Test AI" | Opens test conversation interface |
| Error | "AI service unavailable" | "Check Status" / "Contact Support" | Shows error details and last working state |

---

### 7. Reviews

**Purpose:** Review management and reputation tracking across multiple platforms.

**Sections:**

1. **FrostedAppBar** → refresh icon, settings icon
2. **SegmentedControl** → Tab selector
   - Dashboard | Requests | All Reviews | Analytics | NPS
3. **Tab Content** (IndexedStack):
   
   **Dashboard Tab:**
   - **OverviewMetricsCard** → Key stats
     - Average Rating (with trend indicator)
     - Total Reviews (with platform breakdown)
     - Response Rate percentage
     - Recent Reviews count (last 7 days)
   - **RatingDistributionChart** → 5-star breakdown
     - Visual bar chart showing count per star
     - Percentage labels
     - Tap to filter by rating
   - **PlatformComparisonCard** → Rating by platform
     - Google, Facebook, Yelp, Internal
     - Side-by-side comparison
     - Platform badges with direct links
   - **RecentReviewsList** → Latest 5 reviews
     - ReviewCard with rating, platform, author
     - Quick respond button
     - Tap to view full review
   - **QuickActionsRow** → CTAs
     - "Request Reviews" button
     - "View All Reviews" button
     - "Export Data" button

   **Requests Tab:**
   - **FilterChips** → Filter by status
     - All | Pending | Sent | Received | Expired
   - **RequestList** → List of review requests
     - RequestCard with customer name, date, status
     - Resend button for pending/expired
     - Status badge (Pending/Sent/Received)
     - Tap to view request details

   **All Reviews Tab:**
   - **FilterChips** → Platform filters
     - All | Google | Facebook | Yelp | Internal
   - **ReviewList** → All reviews
     - ReviewCard with full details
     - Rating stars display
     - Platform badge
     - Customer name with link to contact
     - Review text with expand/collapse
     - Response button (if not responded)
     - Response history (if responded)
     - Search bar for filtering

   **Analytics Tab:**
   - **TrendLineChart** → Average rating over time
     - 7D/30D/90D/1Y/All period selector
     - Interactive line chart
   - **PlatformComparisonChart** → Rating by platform
     - Bar or line chart comparison
     - Platform color coding
   - **RatingDistributionChart** → 5-star breakdown
     - Donut or bar chart
     - Percentage and count labels
   - **SentimentChart** → Sentiment analysis
     - Positive/Neutral/Negative breakdown
     - Pie or bar chart
   - **ResponseMetricsCard** → Response stats
     - Average response time
     - Response rate by platform
     - Response quality metrics

   **NPS Tab:**
   - **NPSScoreCard** → Current NPS score
     - Large score display (0-100)
     - Trend indicator (up/down)
     - Promoter/Passive/Detractor breakdown
   - **ActiveSurveysList** → Running surveys
     - Survey card with status, response count
     - Tap to view results
   - **SurveyResultsChart** → Response distribution
     - 0-10 scale breakdown
     - Promoter/Passive/Detractor categorization
   - **SurveyHistory** → Past surveys
     - Historical NPS scores
     - Trend over time

4. **ReviewResponseForm** (BottomSheet) → Respond to review
   - Platform badge and review details
   - TextArea with character counter
   - Platform-specific rules info
   - Response template selector
   - AI-suggested response button
   - Send button with loading state

5. **ReviewSettingsSheet** → Configuration
   - Platform integrations (Google, Facebook, Yelp)
   - Connection status and configure buttons
   - Request automation settings
   - Response templates
   - Notification preferences

**Components Used:**
- SegmentedControl (tab selector)
- ReviewCard (review display)
- RatingStars (star rating)
- PlatformBadge (platform indicator)
- RequestCard (request item)
- NPSScoreCard (NPS display)
- TrendLineChart (rating trends)
- RatingDistributionChart (5-star breakdown)
- PlatformComparisonChart (platform comparison)
- SentimentChart (sentiment analysis)
- ReviewResponseForm (response editor)
- FilterChips (filtering)
- SearchBar (search reviews)
- SkeletonLoader (loading states)
- EmptyStateCard (empty states)

**Enhancements (v2.5.1):**
- **AI-Suggested Responses:** AI generates contextual responses
- **Auto-Response Rules:** Auto-respond to 5-star reviews
- **Review Widgets:** Generate embed codes for website
- **Sentiment Analysis:** AI-powered sentiment tracking
- **Review Request Optimization:** AI suggests best timing
- **Competitor Benchmarking:** Compare to industry averages
- **Review Insights:** AI-powered improvement suggestions

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) via `_createPageRoute()` helper
  - **Progressive Disclosure:** Collapsible sections for Recent, This Month, Older reviews
- **Phase 2 - Intelligence:**
  - **Celebration Tracking:** Framework for milestone celebrations (ready for future implementation)
- **Phase 3 - Delight:**
  - **Celebration Banners:** Framework for milestone celebrations (ready for future implementation)
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K, Cmd+R, Esc)
  - **Smooth Animations:** All navigation uses consistent page transitions

**Behaviour Notes:**
- Real-time sync with platforms (when configured)
- Manual refresh option
- Pull-to-refresh on lists
- Review cards expand on tap
- Response form validates platform rules
- Charts are interactive (tap to filter)
- Empty states show helpful CTAs

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Loading | Skeleton metrics + cards | None | Progressive loading |
| No Reviews | "No reviews yet" illustration | "Request First Review" | Shows setup wizard |
| No Platform Connection | "Connect platforms" message | "Connect Google/Facebook/Yelp" | Opens integration settings |
| Error | "Failed to sync reviews" | "Retry" | Shows last sync time |

---

### 8. Contacts (CRM)

**Purpose:** Contact and customer relationship management with smart prioritization and comprehensive 10/10 UX features.

**Sections:**

1. **FrostedAppBar** → add contact button (primary action), overflow menu (filter, import, export, segments, duplicates)
   - iOS-aligned: Maximum 1 icon (add contact button)
   - Filter, import, export, segments, duplicates moved to overflow menu (iOS pattern)
2. **SegmentedControl** → Filter tabs: All | VIP | Recent | Low Score
3. **Celebration Banner** (Conditional) → Milestone achievement notifications
   - Elastic bounce animation on appear
   - Auto-dismiss after 4 seconds
   - Dismissible with X button
   - Examples: "🎉 Your 1st contact!", "🎊 10 contacts added!", "🚀 25 contacts milestone!", "🌟 50 contacts!", "💎 100 contacts!"
4. **AI Insight Banner** (Conditional) → Contextual insights and suggestions
   - Examples: "You have 5 inactive contacts (score <30). Consider re-engaging them.", "12 VIP contacts identified. Focus on these relationships.", "3 contacts haven't been accessed in 90+ days. Consider archiving."
5. **Smart Collapsible Sections** (Progressive Disclosure):
   - **VIP Contacts** (default expanded): High-score contacts (score >= 90) or tagged VIP
   - **Recent Contacts** (default expanded): Contacts accessed in last 7 days
   - **All Contacts** (default collapsed): Full contact list with smart prioritization
6. **ContactList** → List of contacts with smart prioritization
   - **ContactCard:** Contains:
     - **Avatar:** Contact profile image or initials
     - **Name:** Contact name (bold for VIP)
     - **Score:** CRM score (0-100) with color-coded badge
     - **Tags:** Contact tags (VIP, Regular, etc.)
     - **Last Interaction:** Relative time (2h ago) or absolute date
     - **Quick Actions:** Three-dot menu (Edit, View Timeline, Send Message, Add Note, Archive)
   - **Smart Prioritization:** Sorted by:
     - VIP status (VIP contacts first)
     - Interaction frequency (frequently accessed contacts prioritized)
     - Recency (recently opened contacts prioritized)
     - Score (high-score contacts prioritized)
   - **Contextual Hiding:** Low-score (<30) and inactive (not accessed in >90 days) contacts hidden by default, with option to show
   - **Staggered Animations:** List items animate in with staggered delay (50ms per item)
   - Swipe left to archive (confirmation required)
   - Swipe right to send message
   - Tap to view contact detail
   - Long-press for context menu (Edit, View Timeline, Send Message, Add Note, Archive, Delete)
   - Pull-to-refresh syncs contact data
7. **SearchBar** → Search contacts by name, email, phone, tags
   - Auto-complete suggestions
   - Recent searches
   - Filter by tags, score range, last interaction
8. **FloatingActionButton** → "+ Add Contact" with quick actions: "New Contact", "Import Contacts", "From Message"

**Components Used:**
- ContactCard (contact row)
- ScoreBadge (CRM score indicator)
- TagChip (contact tags)
- SkeletonLoader (loading state)
- EmptyStateCard (no contacts)
- FilterSheet (advanced filters)
- CelebrationBanner (milestone notifications)
- AIInsightBanner (contextual insights)
- SmartCollapsibleSection (progressive disclosure)
- RichTooltip (long-press tooltips)

**Enhancements (v2.5.1):**
- **Smart Search:** AI-powered contact search with context
- **Quick Actions:** Bulk selection for tagging, archiving, exporting
- **Stage Drag-Drop:** Drag contacts between CRM stages
- **Timeline Filtering:** Filter contacts by interaction timeline
- **Score Breakdown:** Detailed view of how CRM score is calculated
- **Merge Comparison:** Side-by-side comparison when merging duplicate contacts
- **Import/Export:** CSV import/export with field mapping
- **Duplicate Detection:** AI-powered duplicate detection and merging
- **Segments:** Create contact segments for targeted actions
- **Custom Fields:** Profession-specific custom fields for contacts

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) via `_createPageRoute()` helper
  - **Progressive Disclosure:** Collapsible sections for VIP, Recent, and All contacts with expand/collapse
- **Phase 2 - Intelligence:**
  - **Smart Prioritization:** Contacts sorted by VIP status, interaction frequency, recency, and score
  - **Contextual Hiding:** Low-score (<30) and inactive (not accessed in >90 days) contacts hidden by default
  - **AI Insight Banners:** Contextual insights about inactive contacts, VIP contacts, and archiving suggestions
  - **Interaction Tracking:** Tracks tap counts and last opened timestamps for prioritization
- **Phase 3 - Delight:**
  - **Expanded Celebration Milestones:** 1st, 10th, 25th, 50th, and 100th contact milestones with celebration messages
  - **Celebration Banners:** Elastic bounce animation on appear, auto-dismiss after 4 seconds
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K for search, Cmd+N for create contact, Cmd+R for refresh, Esc)
  - **Rich Tooltips:** Long-press contacts for detailed tooltips with contact info, score breakdown, and last interaction
  - **Staggered List Animations:** List items animate in with staggered delay (50ms per item) using `TweenAnimationBuilder`

**Behaviour Notes:**
- Smart prioritization updates automatically as contacts are accessed
- Contextual hiding reduces clutter while maintaining access to all contacts via "Show All" toggle
- AI Insight Banners provide actionable suggestions based on contact data
- Celebration banners appear for milestone achievements (1st, 10th, 25th, 50th, 100th contacts)
- Staggered animations create smooth visual experience when list loads
- Long-press on contacts shows rich tooltips with detailed information
- Keyboard shortcuts enable quick navigation and actions (Cmd+K for search, Cmd+N for create contact)

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Loading | Skeleton contact cards (5 rows) | None | Progressive loading: sections → contacts |
| Empty | "No contacts yet" illustration | "Add First Contact" | Shows import options and quick add |
| No Search Results | "No contacts found" + suggestions | "Clear Search" | Shows popular contacts instead |
| Contextual Hiding Active | "Showing 45 of 120 contacts" banner | "Show All" | Expands to show hidden contacts |
| Error | "Failed to load contacts" | "Try Again" | Retry preserves filters and search |

---

### 9. Reports & Analytics

**Purpose:** Comprehensive business analytics.

**Sections:**

1. **FrostedAppBar** → date range picker
2. **ReportTypeTabs** → SegmentedControl
   - Overview | Revenue | Jobs | Clients | AI Performance
3. **KPISummaryRow** → Top-level metrics
   - 4-6 key metrics with sparklines
   - Period comparison (vs previous period)
   - Color-coded trends (green up, red down)
   - Tap for detailed view
4. **ChartCardGrid** → 2×2 or 3×1 chart layout
   - **Revenue Chart:** Line/bar showing income over time
   - **Jobs Chart:** Pipeline visualization (funnel)
   - **Client Acquisition:** New vs returning (donut)
   - **Channel Performance:** Messages by channel (bar)
   - **Response Times:** Average by channel (line)
   - **Conversion Rates:** Inquiry → booking → payment (funnel)
   - Each chart interactive with drill-down
5. **DataTableSection** → Detailed breakdowns
   - **Top Services:** Service type + count + revenue
   - **Top Clients:** Client + lifetime value + jobs count
   - **Busiest Days:** Day of week + booking count + revenue
   - **Peak Hours:** Hour of day + activity level
   - Sortable columns (tap headers)
   - Pagination with "Load More"
6. **AutomationHistoryTable** → AI activity log
   - **Timestamp:** When action occurred
   - **Action:** Auto-reply, booking offer, quote chase, etc.
   - **Outcome:** Successful/failed + result
   - **LinkedConversation:** Link to thread
   - Search and filter capabilities
  <!-- REMOVED: Export functionality (Format, Email report, Template selector, Generate Report) - Removed per decision matrix 2025-11-05 -->

**Components Used:**
- TrendTile (KPI cards)
- ChartCard (various chart types)
- DataTable (sortable, paginated)
- SkeletonLoader (loading)
- EmptyStateCard (no data)
- DateRangePicker (filter)
- SegmentedControl (report types)
- Badge (comparison indicators)

**Enhancements (v2.5.1):**
<!-- REMOVED: Custom Reports, Scheduled Reports - Removed per decision matrix 2025-11-05 -->
- **Benchmarks:** Compare to industry averages
- **Forecasting:** AI predicts next month's revenue
- **Goal Tracking:** Set targets, track progress
- **Cohort Analysis:** Client retention over time
- **Attribution:** Which channels drive most revenue
- **Team Performance:** Individual team member stats (if multi-user)
- **Break-Even Analysis:** Calculate profitability per job
- **Keyboard Shortcuts (Web):** `R` = Refresh, `D` = Change date range

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade transitions (200ms) via `_createPageRoute()` helper
  - **Progressive Disclosure:** Collapsible sections for Key Metrics, Charts, Details with expand/collapse
- **Phase 2 - Intelligence:**
  - **Celebration Tracking:** Framework for milestone celebrations (ready for future implementation)
- **Phase 3 - Delight:**
  - **Celebration Banners:** Framework for milestone celebrations (ready for future implementation)
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K, Cmd+R, Esc)
  - **Smooth Animations:** All navigation uses consistent page transitions

**Behaviour Notes:**
- TrendTile shows mini KPI comparisons with arrow up/down icons
- ChartCard supports donut mode for category breakdowns
- Animated gradient backgrounds on metric cards
- Sticky summary header when scrolling
- Charts use lazy loading for large datasets
- Real-time updates via subscriptions (where applicable)

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Loading | Skeleton metrics + charts | None | Progressive: KPIs → charts → tables |
| Insufficient Data | "Not enough data yet" + info | "View Requirements" | Explains minimum data needed (e.g., 7 days) |
| No Data | "No activity in this period" | "Change Date Range" | Suggests expanding date range |
| Error | "Failed to load reports" | "Try Again" | Retry preserves filters and date range |

---

### 10. Settings

**Purpose:** Organization configuration and user preferences.

**Sections:**

1. **FrostedAppBar** → back button, title, help icon
2. **ProfileCard** → User information
   - **Avatar:** Tap to change photo
   - **Name:** Display name (tap to edit)
   - **Email:** Contact email
   - **PhoneNumber:** Business phone
   - **OrganisationName:** Business name
   - **PlanBadge:** Current subscription tier
3. **SettingsSectionList** → Grouped settings
   - **Account**
     - Edit Profile
     - Change Password
     - Email Preferences
     - Notification Settings
     - Privacy Settings
   - **Business**
     - Organisation Details
     - Team Members (if multi-user)
     - Business Hours
     - Services & Pricing
     - Tax Settings
   - **Integrations**
     - WhatsApp Connect (status + configure)
     - Instagram Connect (status + configure)
     - Facebook Connect (status + configure)
     - Google Calendar Sync (status + configure)
     - Stripe Connect (status + configure)
     - IMAP/SMTP Email (status + configure)
   - **AI Configuration**
     - AI Receptionist Settings
     - Tone & Language
     - Auto-Response Rules
     - FAQ Management
   - **Notifications**
     - Push Notifications (toggle)
     - Email Notifications (toggle)
     - SMS Notifications (toggle)
     - Notification Sounds (toggle)
     - Do Not Disturb Schedule
   - **Appearance**
     - Theme (Light / Dark / Auto)
     - Accent Color (optional profession-specific)
     - Density (Compact / Comfortable / Spacious)
     - Language
   - **Data & Privacy**
     - Data Export
     - Data Deletion
     - Privacy Policy
     - Terms of Service
4. **PlanCard** → Subscription information
   - **CurrentPlan:** Name + price
   - **Features:** List of included features
   - **BillingCycle:** Next billing date
   - **PaymentMethod:** Card ending in ••••
   - **ManageButton:** Update plan or payment method
5. **DangerZone** → Critical actions
   - **DeleteAccount:** Red button with confirmation
   - **LogoutButton:** Secondary style
   - **ClearCache:** Clear local data

**Components Used:**
- ProfileCard (user info)
- SettingsList (grouped items)
- Toggle (switches)
- PlanCard (subscription)
- SkeletonLoader (loading)
- ConfirmationDialog (destructive actions)
- StatusIndicator (integration status)
- Badge (plan tier)

**Enhancements (v2.5.1):**
- **Quick Toggles:** One-tap enable/disable key features
- **Search Settings:** Find settings by keyword
- **Sync Status:** Shows last sync for each integration
- **Test Connections:** Test integrations directly from settings
- **Notification Preview:** See what notifications look like
- **Theme Preview:** Preview themes before applying
- **Multi-Factor Auth:** Optional 2FA for security
- **Session Management:** View/revoke active sessions
- **API Access:** Generate API keys for custom integrations
- **Keyboard Shortcuts (Web):** `S` = Search settings, `T` = Toggle theme

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) via `_createPageRoute()` helper
- **Phase 2 - Intelligence:**
  - **Celebration Tracking:** Framework for milestone celebrations (ready for future implementation)
- **Phase 3 - Delight:**
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K for search, Cmd+R for refresh, Esc)
  - **Smooth Animations:** All navigation uses consistent page transitions

**Behaviour Notes:**
- Settings save automatically (no save button needed)
- Integration status shows green checkmark or red error
- Disconnecting integration shows confirmation with impact explanation
- Theme changes apply immediately with smooth transition
- Password changes require current password
- Destructive actions show double confirmation

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Loading | Skeleton profile + settings list | None | Progressive loading of sections |
| Integration Error | Red warning icon + error message | "Reconnect" | Shows error details and steps to fix |
| Unsaved Changes | Banner: "You have unsaved changes" | "Save" / "Discard" | Appears on profile edits |
| Delete Confirmation | "Are you sure?" modal | "Yes, Delete" / "Cancel" | Explains consequences, requires typing "DELETE" |

---

### 11. Support / Help

**Purpose:** Self-service help and support access.

**Sections:**

1. **FrostedAppBar** → back button, search icon
2. **SearchBar** → Search help articles
   - Auto-complete suggestions
   - Recent searches
   - Popular topics
3. **StatusBanner** → System status
   - "All systems operational" (green)
   - "Investigating issues with WhatsApp" (yellow)
   - "Major outage — SMS delayed" (red)
   - Link to status page
4. **QuickLinksGrid** → 2×2 help shortcuts
   - **Getting Started:** Onboarding guide
   - **Video Tutorials:** Library of how-to videos
   - **Feature Guides:** Detailed feature docs
   - **FAQ:** Common questions
5. **FAQList** → Expandable accordion
   - **Categories:** Account, Billing, Features, Integrations, Troubleshooting
   - **QuestionRow:** Tap to expand answer
   - **HelpfulButtons:** Was this helpful? 👍 👎
   - **RelatedArticles:** Links to similar help content
6. **ContactSupportCard** → Get help from team
   - **LiveChat:** "Chat with us" (if available)
   - **EmailSupport:** "Send us an email"
   - **PhoneSupport:** "Call us" (with hours)
   - **CommunityForum:** "Ask the community"
   - **ResponseTime:** "Typical response: 2-4 hours"
7. **TroubleshootingTools** → Self-diagnostic
   - **Connection Test:** Test all integrations
   - **Clear Cache:** Reset local data
   - **ReportBug:** Submit bug with logs
   - **RequestFeature:** Submit feature request

**Components Used:**
- SearchBar (help search)
- StatusBanner (system status)
- FAQAccordion (expandable Q&A)
- QuickLinkCard (help shortcuts)
- SkeletonLoader (loading)
- EmptyStateCard (no results)
- Badge (unread count)
- InfoBanner (announcements)

**Enhancements (v2.5.1):**
- **Smart Search:** AI-powered help search with context
- **Chatbot:** AI assistant for common questions
- **Screen Recording:** Record screen for bug reports
- **Remote Assistance:** Share screen with support (optional)
- **Community Forum:** Connect with other users
- **Feature Voting:** Vote on upcoming features
- **Beta Access:** Opt into early feature testing
- **Changelog:** See what's new in recent updates
- **Keyboard Shortcuts (Web):** `?` = Show keyboard shortcuts, `/` = Focus search

**Behaviour Notes:**
- FAQ categories collapse/expand with smooth animation
- Status banner shows real-time status updates
- Search shows instant results as you type
- Contact support shows estimated response time
- Helpful/not helpful buttons provide feedback
- Bug reports auto-include device/version info

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Loading | Skeleton FAQ + quick links | None | Loads in order: status → quick links → FAQs |
| No Search Results | "No articles found" + suggestions | "Clear Search" | Shows popular articles instead |
| Offline | "You're offline" + cached help articles | None | Shows last cached help content |
| Support Unavailable | "Support offline" message | "Send Email" | Alternative contact methods |

---

### 10. Legal / Privacy

**Purpose:** Legal documents and privacy information.

**Sections:**

1. **FrostedAppBar** → back button, share icon
2. **LegalDocumentList** → List of legal pages
   - **Privacy Policy:** Link to full policy
   - **Terms of Service:** Link to terms
   - **Cookie Policy:** Link to cookie info
   - **Data Processing Agreement:** Link to DPA
   - **GDPR Information:** Rights and procedures
   - Each item shows last updated date
3. **WebView** → Document viewer
   - Renders full legal documents
   - Scrollable with table of contents
   - Search within document
   - Print/share options

**Components Used:**
- WebView (document display)
- DocumentList (legal pages)
- ShareButton (share document)
- SkeletonLoader (loading)

**Enhancements (v2.5.1):**
- **Plain English Summary:** Simplified version of each document
- **Change Log:** See what changed in updates
- **Dark Mode Support:** Dark theme for documents
- **Accessibility:** Screen reader optimized
- **Download PDF:** Save documents offline
- **Table of Contents:** Quick navigation
- **Search in Document:** Find specific terms
- **Highlight Updates:** Shows new/changed sections

**Behaviour Notes:**
- Documents load in WebView with native feel
- Back button returns to list, not previous page in document
- Share button creates shareable link or PDF
- Last updated date shown prominently
- Print-friendly formatting

**State Screens:**
| State | Visual | CTA | Behavior |
|-------|--------|-----|----------|
| Loading | Skeleton document | None | Shows loading spinner while fetching |
| Failed to Load | "Document unavailable" | "Try Again" / "View Cached" | Shows cached version if available |
| Offline | "Viewing cached version" banner | None | Indicates document may be outdated |

---

## 📑 SHARED SHEETS & MODALS

| Name | Sections | Enhancements (v2.5.1) |
|------|----------|-----------------------|
| **OnMyWaySheet** | FrostedHeader, MapPreview (with live location), ETASelector (15/30/45/60 min), NotesField (optional message), ConfirmButton ("Send ETA") | Real-time traffic updates, Tap map to open in Maps app, "Share Live Location" toggle, Custom ETA input, Auto-stop sharing after arrival |
| **BookingOfferSheet** | AvailabilityGrid (visual time slot selector), ServicePicker, DurationSelector, PricePreview, NotesField, ConfirmButton ("Send Booking Offer") | Smart suggestions based on client history, Conflict warnings, Deposit requirement toggle, Customizable message template |
| **RescheduleSheet** | CurrentBookingCard (shows original details), CalendarWidget (with conflict detection), TimeSlotPicker (available times only), ReasonField (optional), ClientNotification toggle, ConfirmButton ("Reschedule") | Suggests best alternative times, Shows impact (e.g., "This creates 30min gap"), Auto-notifies client option, Batch reschedule for recurring |
| **PaymentRequestModal** | ClientSelector (if multiple), AmountField (with currency), DescriptionField, DueDatePicker, PaymentMethodChips (Stripe link/Cash/Bank transfer), MessagePreview (editable), SendButton ("Send Request") | Smart amount suggestions from recent jobs, Invoice attachment option, Partial payment support, Recurring payment setup, Payment plan builder |
| **DepositRequestSheet** | JobLink (selected job), DepositAmount (% or fixed), DueDatePicker, PaymentLinkToggle (auto-generate), MessagePreview, SendButton ("Request Deposit") | Suggested deposit % by job type, Balance due display, Multiple payment method support, Auto-link to booking confirmation |
| **ReviewRequestSheet** | ClientSelector, JobLink, ReviewPlatforms (Google/Facebook/Custom), MessageTemplate (customizable), IncentiveToggle (optional discount for review), TimingPicker (send now/later), SendButton ("Request Review") | A/B tested message templates, Optimal timing suggestions, Multi-platform at once, Follow-up reminder option, Review response monitoring |
| **QuickActionsSheet** | ActionButtonGrid with icons and labels: "Add Job", "Add Booking", "Send Invoice", "Send Payment Link", "Add Contact", "New Message", Keyboard shortcuts shown below | Customizable actions (drag to reorder), Recently used actions at top, Search actions, Keyboard shortcuts (e.g., Cmd+J for jobs) |
| **FilterSheet** | Filter categories with counts, Date range picker (calendar + presets), Status checkboxes, Service type chips, Team member selector (if applicable), Price range slider, Apply/Clear buttons | Save filter presets, "Recently used" quick access, Filter result count preview, Share filter with team, Reset to defaults |
| **ConfirmationDialog** | Icon (⚠️ for destructive), Title, Description (explains consequences), Secondary action ("No, Cancel"), Primary action ("Yes, [Action]" - red if destructive) | Checkbox "Don't ask again" option, Type "DELETE" for critical actions, Shows undo window time if applicable, Keyboard shortcut (Enter/Esc) |
| **BottomSheet** | Handle (drag indicator), Content area (scrollable), Action buttons at bottom (sticky), Backdrop (tap to dismiss) | Half/full height auto-switch based on content, Swipe to dismiss gesture, Keyboard avoidance, Snap to breakpoints (25%, 50%, 100%), Nested scrolling support |

---

## 🧭 UNIVERSAL COMPONENTS / LAYOUTS

### Universal App Bar (Enhanced v2.5.1)

**Layout (iOS-Aligned):**
- **Left:** Back/Menu icon (tap to navigate, long-press for breadcrumbs)
- **Center:** Title/Search (tap title to copy/share, tap search to expand)
- **Right:** 1–2 action icons maximum (iOS pattern: primary action + overflow menu)
  - Primary action: Most important action (e.g., Add, Create, Compose)
  - Overflow menu: All secondary actions (Filter, Search, Sort, Settings, etc.)
  - iOS best practice: Premium apps use 1-2 icons max to reduce density
- **Search Integration:** Search moved from app bar to content area (iOS pattern)
  - Search bar in content area (tap to navigate to full search screen)
  - App bar icon removed for cleaner look
- **Context Menus:** Long-press list items for additional actions (iOS pattern)
- **Swipe Actions:** Swipe gestures on list items for quick actions (iOS pattern)

**Style:**
- Frosted background (blur 26px, glass opacity 0.88/0.78)
- Collapses on scroll down, expands on scroll up (smart hide behavior)
- Haptic tap feedback on all interactions
- Elevation shadow increases when scrolling content beneath

**States:**
- **Default:** Full height, all icons visible
- **Collapsed:** Reduced height, title shrinks, some icons hidden in overflow
- **Search Active:** Search expands full-width, other icons fade
- **Loading:** Progress indicator below app bar
- **Offline:** Yellow banner slides down from app bar

**Interactions:**
- **Back Button:** Pop navigation with slide animation
- **Menu Button:** Opens drawer with slide-from-left
- **Title:** Long-press for context menu (share, refresh, etc.)
- **Search:** Expands inline, shows recent searches
- **Action Icons:** Tooltip on hover (web) or long-press (mobile)
- **Overflow Menu:** Shows additional actions

**Accessibility:**
- **Screen Reader:** "App bar, [title], [action count] actions available"
- **Focus Order:** Back → Title → Actions left-to-right
- **Touch Targets:** Minimum 44x44pt
- **Color Contrast:** WCAG AA compliant

---

### FrostedBottomNavBar (Enhanced v2.5.1)

**Layout:**
- **5 Primary Icons:** Home, Inbox, Jobs, Calendar, Money
- **Floating Capsule:** Sits 12px above safe area
- **Active Indicator:** Glowing gradient ring around active icon
- **Badge Support:** Shows counts (e.g., unread messages)
- **Shadow:** 12px blur, floats above content

**Style:**
- **Background:** Frosted glass with backdrop blur (24px)
- **Border Radius:** 28px (full pill shape)
- **Icon Size:** 24x24px with 8px padding
- **Active State:** Teal gradient ring (2px), scale 1.1
- **Inactive State:** Gray icon, scale 1.0

**Interactions:**
- **Tap:** Switch tab with haptic feedback
- **Long-Press:** Quick actions sheet for that tab
- **Swipe:** Gesture to switch tabs (mobile only)
- **Badge:** Pulse animation when count increases
- **Hover (Web):** Tooltip shows tab name

**States:**
- **Default:** All tabs visible
- **Profession-Adapted:** Hides irrelevant tabs, reorders remaining
- **Keyboard Focus (Web):** Shows focus ring, Tab key navigation
- **Notification:** Badge pulses + haptic when new notification

**Accessibility:**
- **Screen Reader:** "Navigation bar, [current tab], [tab count] tabs"
- **Focus Order:** Left to right
- **Touch Targets:** 56x56px (larger than visual icon)
- **Semantic Roles:** role="navigation", role="tab"

**Behaviour:**
- Hides on scroll down (except Home)
- Shows on scroll up
- Persists active state across sessions
- Animates badge count changes
- Smooth tab switching with cross-fade

---

### DrawerMenu (Enhanced v2.5.1)

**Layout:**
- **Header:** 
  - Organisation logo (tap to change)
  - User name (tap to profile)
  - Plan badge (tap for billing)
  - Close button (X icon)
- **Navigation Items:** Vertical list with icons
  - AI Hub (with status indicator)
  - Contacts
  - Reports & Analytics
  - Reviews
  - Settings
  - Support & Help (with unread badge)
  - Legal / Privacy
- **Footer:**
  - App version
  - Status indicator (green = online)
  - Logout button

**Style:**
- **Width:** 280px (mobile), 320px (tablet/web)
- **Background:** Layered gradient blur (20px) with subtle drop shadow
- **Active Item:** Highlight bar (4px teal bar on left) + light background tint
- **Divider:** Hairline between sections
- **Animation:** Slides in from left (350ms easeOutCubic)

**Interactions:**
- **Tap Item:** Navigate to screen + close drawer
- **Long-Press Item:** Show quick actions for that section
- **Swipe Right:** Close drawer
- **Tap Backdrop:** Close drawer
- **Swipe from Left Edge:** Open drawer

**States:**
- **Open:** Visible with backdrop
- **Closed:** Hidden off-screen
- **Partially Open:** Swipe gesture in progress
- **Loading:** Skeleton items while loading user data

**Accessibility:**
- **Screen Reader:** "Navigation drawer, [item count] menu items"
- **Focus Trap:** Focus stays within drawer when open
- **Keyboard:** Tab through items, Esc closes
- **Touch Targets:** Minimum 48px height per item
- **Color Contrast:** WCAG AA text on background

**Profession Adaptation:**
- Hides irrelevant sections based on profession
- Reorders items by usage frequency
- Shows relevant badges (e.g., "New" for recently added features)

---

## Global Spacing & Motion Tokens (Enhanced v2.5.1)

| Token | Value | Description | Usage Examples |
|--------|--------|-------------|----------------|
| `spaceXXS` | 2px | Hairline spacing | Icon badge offset, divider gaps |
| `spaceXS` | 4px | Micro padding | Chip internal padding, badge padding |
| `spaceS` | 8px | Small gap | Chip gaps, list item internal spacing |
| `spaceM` | 16px | Base unit (1rem) | Card padding, list item spacing |
| `spaceL` | 24px | Large spacing | Card spacing, section gaps |
| `spaceXL` | 32px | Extra large | Screen margin, major section spacing |
| `spaceXXL` | 48px | Screen-level | Top-level section spacing |
| `motionInstant` | 100ms | Immediate | Tooltip show, focus ring |
| `motionFast` | 200-250ms | Quick | Button press, chip selection, toggle |
| `motionMedium` | 300-400ms | Standard | Card animation, chart draw, modal appear |
| `motionSlow` | 500-600ms | Deliberate | Modal/sheet slide, drawer open, screen transition |
| `motionXSlow` | 800-1000ms | Emphasis | Success animation, celebration effects |
| `curveStandard` | easeOutQuart | Default ease | Most animations |
| `curveSmooth` | easeOutQuint | Extra smooth | Chart animations, value counters |
| `curveSpring` | spring(1, 0.8, 0.3) | Bouncy | Drawer open, bottom sheet, modals |
| `curveSharp` | easeInOutCubic | Snappy | Quick toggles, instant feedback |

**Motion Principles (v2.5.1):**
- **Reduced Motion:** All animations respect `prefers-reduced-motion`
- **Haptic Feedback:** Pairs with key animations (tap, swipe, toggle)
- **Progressive Enhancement:** Core functionality works without animation
- **Performance:** Use GPU-accelerated properties (transform, opacity)
- **Consistency:** Same animation for same action type across app

---

## Appendix – Profession Adaptation Visual Rules (Enhanced v2.5.1)

| Profession | Visible Tabs | Label Changes | Accent | Dashboard Priorities | Key Metrics |
|-------------|--------------|----------------|---------|---------------------|-------------|
| **Trade** | Home, Inbox, Jobs, Calendar, Money | Standard labels | Shared Theme | Jobs + Revenue focus | Active jobs, Completion rate, Revenue, Response time |
| **Salon / Clinic** | Home, Inbox, Calendar, Money | Job→Appointment, Payment→Invoice, Add Job→Book Appointment | Shared Theme | Calendar + Bookings focus | Today's bookings, Repeat clients, Revenue, No-show rate |
| **Professional** | Home, Inbox, Jobs, Reports, Money | Job→Client, Payment→Fee, Calendar→hidden, Add Job→New Client | Shared Theme | Client relationships + Reports | Active clients, Retention rate, Revenue, Avg project value |

**Enhanced Adaptation Behavior (v2.5.1):**

1. **Smart Defaults by Profession:**
   - **Trade:** Default view = Jobs pipeline, Quick action = "Add Job"
   - **Salon:** Default view = Today's bookings, Quick action = "Book Appointment"
   - **Professional:** Default view = Client list, Quick action = "New Client"

2. **Dashboard Personalization:**
   - **Trade:** Shows job pipeline chart, upcoming jobs, payment status
   - **Salon:** Shows today's schedule, recurring clients, booking rate
   - **Professional:** Shows client timeline, project status, billing overview

3. **Terminology Consistency:**
   - All labels change throughout entire app (buttons, titles, messages, notifications)
   - System messages adapt (e.g., "Job completed" → "Appointment completed")
   - Email/SMS templates use profession-specific terms
   - AI responses adapt tone and terminology

4. **Feature Visibility:**
   - **Trade-Specific:** "On My Way" ETA, Job site photos, Material costs
   - **Salon-Specific:** Recurring bookings UI, Service duration, Stylist assignment
   - **Professional-Specific:** Project milestones, Hourly rate tracking, Document attachments

5. **Visual Consistency:**
   - All professions share identical color, typography, and motion
   - Accent token: `accentPrimary` (#00C6A2) used universally
   - No per-industry palette variations
   - Icon set consistent across professions

**Per-Tab Behaviour Notes:**
- **Professional:** Hides Calendar/Bookings entirely, promotes Reports tab
- **Salon:** Hides Jobs tab, promotes Calendar with advanced booking features
- **Trade:** Shows all default tabs with standard labels

**Drawer Adaptation:**
- Tiles and menu items auto-hide for irrelevant modules
- Order adjusts based on profession priorities
- Badge counts reflect profession-specific metrics

---

## State Screen Specifications (v2.5.1 Addition)

All screens must implement these states for consistency and resilience:

### Loading States

**Visual Requirements:**
- Skeleton loaders that match actual content layout
- Shimmer animation (1.2s duration, left-to-right gradient sweep)
- Preserve layout dimensions to prevent content shift
- Show skeleton for a minimum 300ms (prevent flash)

**Implementation Pattern:**
```
- Header: Full width skeleton bar
- Content: 3-5 skeleton cards/rows matching actual content structure
- Action buttons: Skeleton button placeholders
- No spinners unless loading time >2 seconds
```

### Empty States

**Visual Requirements:**
- Centered illustration (optional, 120-160px size)
- Clear headline (18-22px, semibold)
- Supportive description (14-16px, regular, 2-3 lines max)
- Primary CTA button
- Secondary link (optional, for alternative action)

**Content Requirements:**
- Headline: Explains what's missing ("No jobs yet", "Inbox is empty")
- Description: Explains why or what to do next
- CTA: Action verb that creates first item ("Add Your First Job")

**Implementation Pattern:**
```
[Illustration]
"No [Items] Yet"
"You haven't created any [items]. Start by [action]."
[Primary CTA Button]
[Optional: Secondary Link]
```

### Error States

**Visual Requirements:**
- Error icon (⚠️ or 🚫, 40-48px)
- Error headline (16-18px, semibold, neutral/red color)
- Error description (14px, explains what went wrong)
- Primary retry button
- Secondary support/help link
- Preserve UI context (don't blank entire screen)

**Content Requirements:**
- Headline: Short error description ("Failed to Load Jobs")
- Description: Technical but user-friendly explanation
- Error code/ID for support reference (small, muted)

**Implementation Pattern:**
```
[Error Icon]
"Failed to Load [Content]"
"We couldn't connect to the server. Check your internet connection."
[Error ID: E-1234]
[Primary: "Try Again"] [Secondary: "Get Help"]
```

### Offline States

**Visual Requirements:**
- Yellow/orange banner at top (non-blocking)
- Offline icon (📡 or cloud with slash)
- Show cached data with timestamp
- Disable actions that require network
- Show "Last updated" timestamp

**Content Requirements:**
- Banner: "You're offline" or "No internet connection"
- Show what functionality is available offline
- Indicate which actions require connection

**Implementation Pattern:**
```
[Banner: "You're offline • Last updated 5 minutes ago"]
[Show cached content normally]
[Disabled: Network-required actions]
[Enable: Offline-capable actions]
```

---



---

## Keyboard Shortcuts Reference (Web/Desktop)

**Purpose:** Complete keyboard navigation support for power users and accessibility.

### Global Shortcuts (Available on All Screens) — *🔮 Future Feature (Web-only, Planned for Post-v2.5.1)*

| Shortcut | Action | Notes |
|----------|--------|-------|
| `G then H` | Navigate to Home | Vim-style navigation |
| `G then I` | Navigate to Inbox | |
| `G then J` | Navigate to Jobs | |
| `G then C` | Navigate to Calendar | |
| `G then M` | Navigate to Money | |
| `G then R` | Navigate to Reports | |
| `G then A` | Navigate to AI Hub | |
| `/` | Focus search bar | Works on list screens |
| `Ctrl/Cmd + K` | Open command palette | Quick access to all actions |
| `Esc` | Close modal/drawer/sheet | Exit focused UI element |
| `?` | Show keyboard shortcuts help | Display shortcut overlay |

### Screen-Specific Shortcuts

#### Home Dashboard
| Shortcut | Action |
|----------|--------|
| `R` | Refresh dashboard data |
| `1-5` | Focus on metric card 1-5 |
| `A` | Open quick actions menu |

#### Inbox
| Shortcut | Action |
|----------|--------|
| `C` | Compose new message |
| `J` / `K` | Next/previous conversation |
| `Enter` | Open selected conversation |
| `A` | Archive selected conversation |
| `P` | Pin/unpin conversation |
| `X` | Select conversation (batch mode) |
| `Ctrl/Cmd + Enter` | Send message |
| `1-5` | Apply channel filter (All/SMS/WhatsApp/IG/FB) |

#### Jobs
| Shortcut | Action |
|----------|--------|
| `N` | Create new job |
| `J` / `K` | Next/previous job |
| `Enter` | Open selected job |
| `E` | Edit selected job |
| `Shift + D` | Duplicate job |
| `D` | Delete job (with confirmation) |
| `1-6` | Filter by status (All/Pending/Active/Completed/etc.) |

#### Calendar
| Shortcut | Action |
|----------|--------|
| `N` | Create new booking |
| `T` | Jump to today |
| `Left/Right Arrow` | Previous/next week |
| `Up/Down Arrow` | Previous/next day (day view) |
| `M` | Switch to month view |
| `W` | Switch to week view |
| `D` | Switch to day view |

#### Money
| Shortcut | Action |
|----------|--------|
| `N` | Create new invoice |
| `J` / `K` | Next/previous transaction |
| `Enter` | Open selected transaction |
| `1-4` | Filter by status (All/Paid/Pending/Overdue) |

### Accessibility Shortcuts
| Shortcut | Action |
|----------|--------|
| `Tab` | Focus next interactive element |
| `Shift + Tab` | Focus previous interactive element |
| `Space` | Activate button/toggle |
| `Enter` | Submit form / Open item |
| `Escape` | Cancel / Close / Go back |

---

## Gesture Guide (Mobile/Tablet)

**Purpose:** Comprehensive gesture patterns for touch interfaces.

### Standard Gestures (All Screens)

| Gesture | Action | Visual Feedback |
|---------|--------|-----------------|
| **Tap** | Select/activate | Ripple effect, scale to 0.95 |
| **Long Press (500ms)** | Open context menu | Haptic medium, menu appears |
| **Swipe Left** | Secondary action (e.g., archive) | Action icon slides in from right |
| **Swipe Right** | Primary action (e.g., reply) | Action icon slides in from left |
| **Pull Down** | Refresh content | Loading indicator at top |
| **Pinch In** | Zoom out / Close | Scale animation |
| **Pinch Out** | Zoom in / Expand | Scale animation |
| **Drag** | Reorder items (lists) | Item lifts with shadow |

### Screen-Specific Gestures

#### Home Dashboard
| Gesture | Action |
|---------|--------|
| **Swipe Down** on metrics | Refresh dashboard |
| **Long Press** on metric tile | Show detailed breakdown |
| **Swipe Left/Right** on chart | Change time period |
| **Pinch** on chart | Zoom in/out (if supported) |

#### Inbox
| Gesture | Action | Customizable |
|---------|--------|--------------|
| **Swipe Right** | Archive conversation | ✅ Yes |
| **Swipe Left** | Delete conversation | ✅ Yes |
| **Long Press** | Select conversation (batch mode) | No |
| **Pull Down** | Refresh messages | No |
| **Swipe Down** in thread | Load older messages | No |

#### Jobs List
| Gesture | Action |
|---------|--------|
| **Swipe Right** | Mark as completed |
| **Swipe Left** | Edit job |
| **Long Press** | Multi-select mode |
| **Drag** (in Kanban) | Move job between columns |

#### Calendar
| Gesture | Action |
|---------|--------|
| **Tap** on empty slot | Create booking |
| **Long Press** on slot | Quick booking menu |
| **Drag** across time | Create multi-hour booking |
| **Drag** booking | Reschedule (move to new time) |
| **Pinch** on calendar | Zoom in/out (week ↔ day view) |
| **Swipe Left/Right** | Previous/next week |

#### Money
| Gesture | Action |
|---------|--------|
| **Swipe Right** | Mark invoice as paid |
| **Swipe Left** | Send payment reminder |
| **Long Press** | Open payment details |

### Gesture Priority Rules

When multiple gestures are possible on the same element:
1. **Long Press** always takes precedence over tap (500ms threshold)
2. **Swipe** detected after 8px movement
3. **Drag** detected after 16px movement with 200ms hold
4. **Pinch** requires two simultaneous touch points

### Haptic Feedback Mapping

| Action | Haptic Type | Duration |
|--------|-------------|----------|
| Button tap | Light | 10ms |
| Toggle switch | Medium | 15ms |
| Swipe action complete | Medium | 20ms |
| Long press activate | Heavy | 25ms |
| Error/warning | Heavy + Light sequence | 40ms |
| Success confirmation | Medium + Light + Light | 50ms |
| Drag start | Light | 10ms |
| Drag end | Medium | 15ms |

---

## Responsive Grid System

**Purpose:** Consistent layout structure across all breakpoints.

### Breakpoint Definitions

| Breakpoint | Min Width | Device Type | Layout |
|------------|-----------|-------------|--------|
| **xs** (extra small) | 0px | Mobile portrait | 1-column, 16px gutters |
| **sm** (small) | 600px | Mobile landscape | 1-column, 16px gutters |
| **md** (medium) | 960px | Tablet portrait | 2-column, 24px gutters |
| **lg** (large) | 1280px | Tablet landscape / Desktop | 2-3 column, 32px gutters |
| **xl** (extra large) | 1920px | Large desktop | 3-column, max-width 1024px |

### Grid Specifications

#### Mobile (xs/sm) — 320px to 959px
```
Container padding: 16px
Column count: 1
Gutter: 16px
Max width: 100%
Touch target: 44x44pt minimum
Font scale: 1.0 (base)
```

#### Tablet (md) — 960px to 1279px
```
Container padding: 24px
Column count: 2
Gutter: 24px
Max width: 960px
Touch target: 44x44pt minimum
Font scale: 1.0 (base)
Drawer: Always visible (persistent)
```

#### Desktop (lg/xl) — 1280px+
```
Container padding: 32px
Column count: 3
Gutter: 32px
Max width: 1024px
Touch target: 40x40px (mouse precision)
Font scale: 1.0 (base)
Drawer: Always visible
Hover states: Enabled
```

### Responsive Behavior Examples

**Home Dashboard:**
- **Mobile:** Single column, stacked metrics, full-width chart
- **Tablet:** 2-column grid, metrics side-by-side, chart below
- **Desktop:** 3-column grid, metrics in top row, chart + activity feed side-by-side

**Inbox:**
- **Mobile:** Full-screen thread view, back button to list
- **Tablet:** Split view (list 40%, thread 60%)
- **Desktop:** Three-pane (list 30%, thread 50%, details 20%)

**Jobs:**
- **Mobile:** Vertical list, full-width cards
- **Tablet:** 2-column grid cards
- **Desktop:** 3-column grid or Kanban board view

---
*Version 2.5.1 Enhanced Screen Layouts & Component Blueprints – November 2025*
*Complete visual specification with UX improvements, state handling, and micro-interactions for professional implementation.*
-e 

---

**Screen_Layouts_v2.5.1_10of10.md — Complete 10/10 Specification**
