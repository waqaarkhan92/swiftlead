# Swiftlead v2.5.1 — Product Definition (10/10 Enhanced)

*Product Definition – v2.5.1 Enhanced to 10/10 (Final)

*Enhanced v2.5.1 — UX improvements, feature enhancements, and interaction patterns applied 2025-11-02.*

> **📝 Document Updates Note:** This document has been updated to reflect the actual implementation. The Drawer / Secondary Navigation section (§21) now includes **Contacts** and **Reviews** in addition to the originally specified items (AI Hub, Reports & Analytics, Settings, Support & Help, Legal / Privacy). These updates align the specification with the current application implementation.

> **🔄 Module Restructuring Note (v2.5.1):** Module 3.5 has been renamed to **"Money"** and now combines all features from the original Module 3.5 (Quotes & Estimates) and Module 3.6 (Invoices & Billing) into a single unified financial management module. All subsequent modules have been renumbered accordingly (3.6 → 3.7, 3.7 → 3.8, etc.). This aligns with the actual implementation where the Money screen contains tabs for Dashboard, Invoices, Quotes, Payments, and Deposits.

> **v2.5.1 Enhancement Note:** Added comprehensive state handling (loading/empty/error), micro-interactions, smart suggestions, batch actions, keyboard shortcuts, offline support, accessibility enhancements, and improved data visualization across all modules. Synchronized with enhanced screen layouts and UI inventory.

> **v2.5 Integration Note:** Document synchronized with premium layout component suite.  
> For structural blueprints, see screen_layouts_and_component_blueprints_v2.5.md.

## Navigation Structure

### Primary Tabs (Bottom Navigation)
1. **Home** — Dashboard, analytics, and insights
2. **Inbox** — Omni-Inbox unified messaging
3. **Jobs** — Job management and tracking
4. **Calendar** — Bookings and scheduling
5. **Money** — Quotes, Invoices & Billing

### Drawer / Secondary Navigation
- **AI Hub** — AI tools and configuration
- **Contacts** — Contact and customer relationship management
- **Reports & Analytics** — Advanced analytics and reporting
- **Reviews** — Review management and reputation tracking
- **Settings** — Organisation configuration and preferences
- **Support & Help** — Help documentation and support
- **Legal / Privacy** — Legal information and privacy settings

---

## 1️⃣ Mission / Value Promise
> **Swiftlead is the all-in-one platform powered by AI that captures leads, books jobs, and gets you paid automatically — so you never miss a job again.**

Swiftlead replaces scattered tools with one premium system that manages messaging, scheduling, payments, and client communication while you work.  
No extra tiers, no upsells — everything included.

---

#### [Enhanced Addendum — Competitive Positioning]

## 🆕 Competitive Positioning

**Primary Competitors:**
- **Jobber:** Strong job management, weak AI, expensive scaling ($129-249/mo)
- **Housecall Pro:** Good mobile UX, basic messaging, no AI automation ($69-249/mo)
- **ServiceTitan:** Enterprise-focused, complex, expensive ($500+/mo)
- **Setmore:** Good booking, limited communication, no job management ($25-69/mo)

**Swiftlead Differentiation:**
1. **AI-First:** Only platform with AI Receptionist, Quote Assistant, and Review Reply built-in
2. **True Omni-Channel:** SMS + WhatsApp + Email + Facebook + Instagram in ONE inbox
3. **All-Inclusive Pricing:** £199/mo with unlimited automation (competitors charge per message)
4. **Premium UX:** Revolut-grade interface vs dated competitor UIs
5. **Adaptive Verticals:** One platform serves trades, salons, and professionals seamlessly
6. **Complete CRM:** Full lifecycle management vs basic contact lists

---

## 2️⃣ Target Market & Expansion
| Stage | Audience | Description | Purpose |
|--------|-----------|-------------|----------|
| **Launch** | Trades & local service providers (plumbers, electricians, roofers, cleaners) | Constant inbound leads + missed-call pain | Fast validation |
| **Expansion** | Professional services (salons, clinics, consultants, legal) | Same workflows with different labels (appointments / clients) | Broaden market |
| **Adaptive Configuration** | One codebase → multi-vertical fit | Profession selected at onboarding changes labels and visible modules | Zero-code scaling |

---

## 3️⃣ Core Modules (Everything Included)

### 3.1 Omni-Inbox (Unified Messaging)
**Purpose:** Unified messaging hub for all customer communication channels across SMS, WhatsApp, Facebook, Instagram, and Email with enhanced UX and smart features.

**Core Capabilities:**
- **Unified Message View:** Single interface displaying all SMS, WhatsApp, Facebook Messenger, Instagram Direct, and **Email (IMAP/SMTP)** messages in chronological order
- **Message Threading:** Automatic grouping of messages by contact, maintaining conversation history across all channels
- **Real-time Updates:** Live message delivery with push notifications and in-app badges (Note: Deferred until backend is wired. Current implementation uses pull-based approach with `_loadMessages()` which is acceptable for MVP.)
- **Internal Notes & @Mentions:**
  - Add private notes to conversations visible only to team members
  - @mention team members to notify them of important conversations
  - Notes include timestamps and author information
- **Message Management:**
  - **Pinning:** Pin important conversations to top of inbox
  - **Archive:** Move inactive conversations to archive (with undo)
  - **Batch Actions:** Select multiple conversations for bulk actions
- **AI Message Summarisation:** Automatically summarises long conversation threads into key points and action items
- **Quick Reply Templates:** Pre-written response templates accessible via shortcuts for common queries
- **Canned Responses:** Library of saved responses organized by category (booking, pricing, availability, etc.)
- **Smart Reply Suggestions:** AI suggests 3 contextual quick replies based on conversation content
- **Rich Media Support:** Send and receive file attachments, photos, voice notes, and documents across all platforms
- **Voice Note Player:** Inline audio player with waveform visualization and playback controls
- **Link Previews:** Rich previews of URLs shared in messages with thumbnail and metadata
- **Search & Filters:** Full-text search across all messages with filters by contact, date, channel, read status, and lead source
- **Advanced Filters:** Combine filters (e.g., "Unread WhatsApp messages from this week")
- **Lead Source Tagging:** Automatically tag messages with lead source (Google Ads / Facebook Ads / Website / Referral / Direct) for tracking. Note: Lead Source is distinct from message channel - it represents where the lead originally came from, not the communication platform used.
- **Typing Indicators:** Display real-time typing status where supported by platform APIs
- **Read Receipts:** Visual confirmation of message delivery and read status (where supported)
- **Missed-Call Integration:** Display missed call notifications inline with messaging threads
- **Message Actions:** Reply, forward, mark as read/unread, archive, delete, assign to team members, and convert to quote/job
- **Scheduled Messages:** Schedule messages to send at specific times
  - Quick scheduling: Bottom sheet when composing messages (long-press send button)
  - Management: Full screen (`ScheduledMessagesScreen`) to view, edit, cancel, or delete all scheduled messages
- **Message Reactions:** Add emoji reactions to messages (where supported)

**🆕 v2.5.1 Enhancements:**
- **Smart Sorting:** Pinned → Unread → Recent → Archived with customizable order
- **Conversation Preview:** Long-press conversation for quick preview without opening
- **Search in Thread:** Find specific messages or media within a conversation
- **Offline Queue:** Messages queued when offline, sent automatically when connection restored
  - Offline banner shows queue status and count
  - Messages persist across app restarts
  - Automatic retry with exponential backoff (max 3 retries)
  - Queue processes automatically when connection restored
- **Priority Inbox:** AI identifies important conversations and highlights them
- **Notification Grouping:** Group message notifications by conversation thread to reduce clutter (e.g., "3 new messages from John Smith")

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Animated Counter:** Unread count animates with easeOutQuint (800ms)
  - **Smart Collapsible Sections:** Time-based grouping (Today, This Week, Older) with smooth SizeTransition
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) for all navigation
  - **Smooth Page Routes:** `_createPageRoute()` helper for consistent transitions across app
- **Phase 2 - Intelligence:**
  - **Smart Prioritization:** Tracks thread interactions (tap counts, last opened) to adapt list order
  - **Contextual Hiding:** Automatically hides threads inactive for >30 days (unless unread, pinned, or recently opened)
  - **AI Insight Banners:** Predictive insights (e.g., "5+ unread messages - catch up?")
  - **Trend Comparisons:** Previous period comparisons for message counts
- **Phase 3 - Delight:**
  - **Celebration Banners:** Milestone celebrations (1st, 10th, 25th, 50th, 100th conversation) with elastic bounce
  - **Keyboard Shortcuts (Web):** Cmd+K (search), Cmd+N (compose), Cmd+R (refresh), Esc (close)
  - **Rich Tooltips:** Long-press thread items shows detailed conversation info (channel, last message time, priority, status)
  - **Staggered List Animations:** Smooth fade-in + slide-up animations for list items (TweenAnimationBuilder)

**🔮 Future Features (Planned for Post-v2.5.1):**
- **Keyboard Shortcuts (Web):** Gmail-style keyboard navigation for web version (`G I` = Inbox, `C` = Compose, `/` = Search, `A` = Archive, `P` = Pin)
- **Drag-Select (Web/Tablet):** Drag to select multiple conversations for batch operations (web and tablet devices only)

**Interactions:**
- Tap message to expand and view full conversation thread
- Swipe actions for quick reply, archive, pin, or delete
- Long-press for additional options (forward, assign, add note, batch select)
- Pull-to-refresh to sync latest messages
- Scroll to load message history (infinite scroll with virtualization)
- Filter by lead source, channel, or assigned team member
- Search across all conversations with instant results and highlighted matches
- Tap-hold message bubble for reactions or context menu

**UI Enhancements:** ChatBubble and MessageComposerBar enable WhatsApp-style threads. Skeleton loaders for smooth loading. Toast notifications for actions. Badge counts on filters.

---

### 3.2 AI Receptionist
**Purpose:** Automated first-response system that handles incoming inquiries 24/7 and qualifies leads with enhanced intelligence and performance tracking.

**Core Capabilities:**
- **Instant Auto-Reply:** Automatically responds to missed calls, texts, or messages within seconds
- **Branded Missed Call Text-Back:** Sends professional follow-up message after missed calls with direct link to book appointment or reply
- **Smart FAQs:** AI-powered responses to frequently asked questions learned from business profile and historical conversations
- **Booking Assistance:** Automatically offers available time slots based on calendar availability when booking inquiries are detected (Note: Backend verification needed once backend is wired)
- **Lead Qualification:** Collects essential information (name, service needed, postcode/address) before human handover (Note: Backend verification needed once backend is wired)
- **After-Hours Handling:** Provides automated responses outside business hours with clear expectation of response time next morning
- **AI Tone Customisation:** Configure AI responses to match brand voice:
  - **Formal:** Professional, business-like tone
  - **Friendly:** Warm, conversational tone
  - **Concise:** Brief, direct responses
  - **Custom:** Train AI with your own examples
- **AI Call Transcription & Summary:** 
  - Automatic transcription for answered calls and voicemails
  - AI-generated summary of call content with key points extracted
  - Transcripts and summaries saved to client record and Inbox
  - Sentiment analysis and action items highlighted
- **Two-Way Confirmations:** Automatically handles YES/NO confirmation responses from clients (Note: Backend verification needed once backend is wired):
  - Parses confirmation responses and updates booking status
  - Sends follow-up messages based on response
  - Recognizes intent variations (e.g., "Yes!", "Sounds good", "Ok")
- **Smart Handover:** Seamlessly transfers qualified leads to human team members with full context and conversation history (Note: Backend verification needed once backend is wired)
- **Interaction Logging:** Records all AI interactions in the Inbox for transparency and follow-up
<!-- REMOVED: Multi-Language Support - Removed per decision matrix 2025-11-05 -->
- **Confidence Scoring:** AI reports confidence level per response for quality monitoring (Note: Backend verification needed once backend is wired)

**🆕 v2.5.1 Enhancements:**
- **Custom Response Override:** Set specific responses for particular keywords or phrases (Note: Backend verification needed once backend is wired)
- **Escalation Rules:** Smart handover based on sentiment, complexity, or keywords (Note: Backend verification needed once backend is wired)
- **AI Performance Analytics:** Track response time, qualification rate, booking conversion
- **Test Mode:** Test AI responses in sandbox before enabling for real customers
- **Fallback Responses:** Graceful handling when AI is uncertain (Note: Backend verification needed once backend is wired)
- **Context Retention:** AI remembers previous conversations with same contact (Note: Backend verification needed once backend is wired)

**Automations:**
- Trigger on missed call → send branded text-back within 30 seconds
- Trigger on new message after hours → send after-hours greeting with next-day response promise
- Trigger on booking keyword → offer available slots immediately
- Trigger on location question → share service area coverage
- Trigger on pricing question → respond with standard pricing range or offer to quote
- Trigger on qualification complete → notify team + create lead record

**UI Components:** AISwitchToggle, ResponsePreview, AIInsightCard, ConversationSimulator, LearningGraph, PerformanceMetrics

---

### 3.3 Jobs (Job Management)
**Purpose:** Track jobs from quote to completion with AI insights, smart scheduling, and team coordination.

**Core Capabilities:**
- **Job Lifecycle:** Quote → Scheduled → In Progress → Completed → Invoiced/Paid
- **Job Creation:**
  - Create from Inbox conversation (auto-import client details)
  - Create from booking (auto-link calendar event)
  - Create standalone (manual entry)
  - AI extracts job details from message thread
- **Job Details:**
  - Client (auto-linked from contacts)
  - Service type (pre-defined or custom)
  - Job description with rich text formatting
  - Service address with map preview
  - Scheduled date/time with calendar sync
  - Assigned team member(s)
  - Priority level (Low / Medium / High / Urgent)
  - Job value estimate
  - Attachments (photos, documents, voice notes)
  - Custom fields per profession
- **Job Status Tracking:**
  - Visual pipeline view (Kanban board)
  - List view with filters and sorting
  - Calendar view for scheduled jobs
  - Status badges and color coding
  - Completion percentage
- **Site Photos & Documentation:**
  - Take photos directly in-app
  - Before/after comparison slider
  - Organize photos by category
  - Time-stamped and GPS-tagged
  - Attach to invoice for transparency
- **Parts & Materials:** *(Removed - not needed)*
- **Job Notes & Comments:**
  - Rich text notes per job
  - Team collaboration comments
  - @mention team members
  - Client-visible vs internal notes
  - Activity timeline
- **Job Templates:**
  - Pre-defined job configurations for common services
  - Include standard pricing
  - Quick job creation from template
- **Quality Checklists:** *(Removed - not needed)*
- **Job Assignment & Dispatch:**
  - Assign to team members
  - Driving directions integration

**🆕 v2.5.1 Enhancements:**
- **Smart Job Suggestions:** AI suggests related services based on job history (Note: Backend verification needed once backend is wired)
- **Quick Actions:** Swipe gestures for common operations
- **Risk Alerts:** Warn about scheduling conflicts or overdue jobs
- **Job Analytics:** Track completion time, profitability, team performance (Note: Backend verification needed once backend is wired)

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) via `_createPageRoute()` helper
- **Phase 2 - Intelligence:**
  - **Smart Prioritization:** Jobs sorted by active status → interaction frequency → recency
  - **Contextual Hiding:** Hides completed jobs >30 days old (unless recently opened)
  - **AI Insight Banners:** Contextual suggestions (e.g., "3 overdue jobs - follow up?")
  - **Interaction Tracking:** Tracks `_jobTapCounts` and `_jobLastOpened` for adaptive ordering
- **Phase 3 - Delight:**
  - **Celebration Banners:** Milestone celebrations (1st, 10th, 25th, 50th, 100th job) with elastic bounce
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K, Cmd+N for create job, Cmd+R, Esc)
  - **Staggered Animations:** Job cards fade-in + slide-up with staggered delays (300ms + index * 50ms)
<!-- REMOVED: Export Job Report - Removed per decision matrix 2025-11-05 -->

**Interactions:**
- Tap job to view full details
- Swipe job card for quick actions (call client, navigate, mark complete)
- Drag-and-drop jobs between status columns (Kanban)
- Filter by status, assigned team member, date range, priority
- Search jobs by client name, address, or description
- Sort by due date, priority, value, or creation date
- Tap client name to view full contact profile
- Tap address to open in maps
- Long-press for batch selection
- Pull-to-refresh to sync latest updates

**UI Components:** JobCard, JobStatusPipeline, JobTimeline, PhotoGallery, TimerWidget, RecurrenceSelector, AssignmentPicker

---

### 3.4 Calendar & Bookings
**Purpose:** Unified scheduling with availability management, automated confirmations, and multi-calendar sync.

**Core Capabilities:**
- **Unified Calendar View:**
  - Day / Week / Month views
  - Color-coded by job type or team member
  - Multi-resource scheduling (team members / equipment)
- **Availability Rules:**
  - Business hours per day
  - Team member specific hours
  - Blocked time / time off
  - Travel time calculation
  - Service-specific availability
- **Booking Management:**
  - Accept / Decline / Reschedule requests
  - Send confirmation emails/SMS automatically
  - Reminder automation (24h before, 1h before)
  - Client self-reschedule/cancel option (with notice period)
  - Waitlist for fully booked slots
- **Calendar Sync:** *(Requires backend integration)*
  - Two-way sync with Google Calendar
  - Two-way sync with Apple Calendar (CalDAV)
  <!-- REMOVED: Two-way sync with Outlook Calendar - Removed per decision matrix 2025-11-05 -->
  - Prevent double-booking across calendars
  - Choose which events to sync
- **Booking Confirmations:**
  - Instant confirmation email/SMS
  - Calendar invite attachment (.ics)
  - Booking details and preparation instructions
  - Payment request if deposit required
  - Cancellation policy reminder
- **Appointment Reminders:**
  - Automated reminders via SMS/email
  - Customizable timing (e.g., 24h + 1h before)
  - Include preparation instructions
  - One-click confirm/reschedule
  - Reduce no-shows
- **Team Scheduling:**
  - View team availability side-by-side
  - Assign bookings to specific team members
  - Round-robin auto-assignment
  - Skill-based assignment
  - Client manages own recurring bookings
  - Pause or cancel series
- **No-Show Tracking:**
  - Mark bookings as no-show
  - Track no-show rate per client
  - Flag high-risk clients
  - Automated follow-up messages
  - No-show fee invoicing

**🆕 v2.5.1 Enhancements:**
- **Smart Availability:** AI suggests optimal time slots based on preferences
- **Capacity Optimization:** Visualize utilization and suggest improvements
- **Booking Templates:** Pre-configure common booking scenarios
- **Conflict Resolution:** Smart suggestions when double-booking detected
- **Group Bookings:** Handle multi-person appointments (classes, consultations)
- **Resource Management:** Track equipment/room availability
- **Booking Analytics:** Track booking sources, conversion rates, peak times
- **Weather Integration:** Display weather forecast for outdoor jobs
- **Buffer Time Management:** Auto-calculate travel/prep time between appointments with visual indicators and adjustable buffer settings
- **Quick Reschedule:** Drag-and-drop booking cards to reschedule to new time slots with automatic notifications

**Interactions:**
- Tap date to view day details
- Tap booking to view/edit
- Long-press for quick actions (call, message, directions, cancel)
- Swipe booking for quick status change
- Pinch-to-zoom calendar view
- Drag-and-drop booking to reschedule (day view)
- Filter by team member, service type, or status
- Color code by category

**UI Components:** CalendarGrid, AvailabilityEditor, BookingForm, TimeSlotPicker, RecurrenceBuilder, ReminderScheduler

---

### 3.5 Money (Quotes, Invoices & Billing)
**Purpose:** Complete financial management hub combining professional quote generation, automated invoicing, payment processing, and financial analytics in one unified interface.

**Core Capabilities:**

#### Quotes & Estimates
- **Quote Builder:**
  - Line-item editor with description, quantity, unit price
  - Add service categories
  - Labor tracking
  - Subtotal, tax, total calculation
  - Expiry date
  - Terms and conditions
- **AI Quote Assistant:**
  - Analyzes job description and suggests line items
  - Recommends pricing based on historical data
  - Identifies upsell opportunities
  - Flags missing items
  - Learns from accepted quotes
- **Professional Presentation:**
  - Payment terms clearly stated
- **Quote Delivery:**
  - Send via email with preview link
  - Send via SMS with short link
  - Share via Inbox conversation
- **Client Interaction:**
  - Deposit payment option
  - Countdown to expiry
- **Quote Tracking:**
  - Status: Draft / Sent / Viewed / Accepted / Declined / Expired
  - View count tracking
  - Follow-up reminders
- **Quote Follow-Up:**
  - Automated follow-up sequences
  - Reminder at 3 days, 7 days before expiry
  - Manual follow-up prompts
  - Convert to job on acceptance
- **Quote Insights:**
  - AI analysis of quote acceptance/decline patterns
  - Acceptance probability predictions

#### Invoices & Billing
- **Invoice Creation:**
  - Manual creation
  - Auto-generate from job completion
  - Convert from quote
- **Invoice Details:**
  - Line items from job/quote
  - Labor, fees
  - Tax calculation (VAT, sales tax)
  - Payment terms (Due on receipt / Net 7/15/30)
  - Notes and terms
- **Flexible Payment Options:**
  - Credit/Debit cards via Stripe
  - Bank transfer (display bank details)
  - Cash payments
  - Check payments
  - Split payments
  - Partial payments
  - Deposits and installments
- **Payment Processing:**
  - Integrated Stripe checkout
  - Store cards securely for repeat clients
  - Payment links sent via email/SMS
  - 3D Secure authentication
- **Recurring Invoices:**
  - Define billing schedule
  - Automatic generation and sending
  - Subscription management
- **Payment Tracking:**
  - Status: Draft / Sent / Viewed / Partially Paid / Paid / Overdue / Void
  - Payment history per invoice
  - Payment reminders automation
- **Reminders & Collections:**
  - Automated payment reminders (due date, 7 days overdue, 14 days overdue)
- **Receipts:**
  - Include payment method details

#### Financial Dashboard
- **Overview Metrics:**
  - Outstanding invoices
  - Revenue by period
  - Average invoice value
  - Days to payment
  - Overdue amount
  - Cash flow projection
- **Revenue Analytics:**
  - This week vs last week
  - This month vs last month
  - Year-to-date revenue
  - Revenue by service type (chart)
  - Average job value
- **Quick Stats:**
  - Pending Quotes (count + value)
  - Overdue Invoices (count + total amount)
  - Active Payments (count + total)
  - Deposits Pending (count + total)

**🆕 v2.5.1 Enhancements:**

#### Quotes Enhancements
- **AI Quote Assistant:** Analyzes job description, suggests line items, pricing recommendations, upsell opportunities
- **Smart Pricing:** Dynamic pricing based on demand, seasonality, client history
- **Visual Quote Editor:** Drag-drop line items with live preview
- **Quote Expiration Alerts:** Notify team when quotes about to expire
- **One-Click Resend:** Resend with updated expiry date
- **Quote Insights:** AI analysis of why quotes accepted/declined
- **Quick Quote:** Generate quote from message in under 60 seconds
- **Mobile Optimized:** Full quote builder on mobile

#### Invoices & Billing Enhancements
- **Smart Invoice Timing:** AI suggests optimal send time for payment
- **Payment Plans:** Flexible installment options with auto-billing
- **Quick Pay QR Code:** Generate QR code for instant payment
- **Offline Payments:** Record cash/check payments offline, sync later
- **Batch Actions:** Send reminders or mark paid for multiple invoices

#### Financial Dashboard Enhancements
- **Date Range Selector:** Compare any period (today, week, month, quarter, year, custom)
- **Real-Time Refresh:** Live updates without manual refresh

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Animated Counter:** Total revenue animates with easeOutQuint (800ms)
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) via `_createPageRoute()` helper
- **Phase 2 - Intelligence:**
  - **Smart Prioritization:** Invoices sorted by overdue → interaction frequency → recency
  - **Contextual Hiding:** Hides paid invoices >90 days old (unless recently opened)
  - **AI Insight Banners:** Contextual suggestions (e.g., "3 overdue invoices - send reminders?")
  - **Trend Comparisons:** Previous month comparisons for all metrics (outstanding, revenue, overdue)
  - **Interaction Tracking:** Tracks `_invoiceTapCounts` and `_invoiceLastOpened` for adaptive ordering
- **Phase 3 - Delight:**
  - **Celebration Banners:** Milestone celebrations (1st invoice, £500, £1k, £5k, £10k revenue) with elastic bounce
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K, Cmd+N for create invoice, Cmd+R, Esc)
  - **Staggered Animations:** Invoice cards fade-in + slide-up with staggered delays (300ms + index * 50ms)

**Interactions:**
- Create quote from Inbox conversation or Job
- Create invoice from job or quote
- Tap to add/edit line items
- Toggle between detailed and summary view
- Preview before sending
- Track delivery and viewing
- Follow up with one tap
- Convert accepted quote to job/invoice
- Record payments manually
- Void or refund
- Download PDF
- Email reminders
- Pull-to-refresh to update all stats
- Tap any card to drill into details
- Filter by date range, status, or type

**UI Components:** QuoteBuilder, InvoiceBuilder, LineItemEditor, PaymentWidget, PricingOptimizer, QuoteStatusBadge, InvoiceStatusBadge, AcceptanceWidget, FollowUpScheduler, StatusTracker, ReminderScheduler, ReceiptViewer, FinancialDashboard, RevenueChart, MetricCard

---

#### [Enhanced Addendum — New Module: Contacts/CRM]

### 3.6 Contacts / CRM (COMPLETE SPECIFICATION)

**Purpose:** Comprehensive contact relationship management with lifecycle tracking, segmentation, and 360° customer view.

### Contact Profile Management
- Complete contact records with name, email, phone(s), address, company, title
- Profile photo with automatic initial generation
- Custom fields per industry (license #, account #, membership level)
- Flexible tagging for categorization
- Source tracking (web form, referral, ad, walk-in)
- VIP/priority status flags

### Contact Lifecycle Stages
**Stages:** Lead → Prospect → Customer → Repeat Customer → Advocate → Inactive/Lost

**Stage Progression Rules:**
- Automatic: Lead → Prospect when quote sent
- Automatic: Prospect → Customer when first payment received
- Automatic: Customer → Repeat when 2nd job completed
- Manual override with reason tracking
- Stage changes trigger notifications and automations

### 360° Activity Timeline
Unified view of ALL interactions:
- Messages across all channels (SMS, WhatsApp, email, social)
- Call history (duration, recordings, transcripts)
- Jobs/bookings with status and outcomes
- Quotes sent and their status
- Invoices and payment history
- Reviews given
- Notes from team members
- Email opens and link clicks
- Chronological with filtering by type

### Contact Scoring & Qualification
**Automatic Lead Scoring:**
- Points for engagement (email open: +5, reply: +10, booking: +50)
- Points for demographic fit (in service area: +15, target industry: +20)
- Points for intent (quote requested: +30, pricing page visited: +10)
- Hot/Warm/Cold classification

### Segmentation & Filtering
**Smart Segments:**
- Pre-built: New Leads (7 days), Hot Prospects (score >70), At-Risk (60 days inactive)
- Custom segments with boolean logic (AND/OR/NOT)
- Filter by: stage, source, tags, custom fields, behavior, location
- Save segments for reuse

### Duplicate Detection & Merge
- Match on phone, email, name similarity
- Fuzzy matching algorithm with confidence scores
- Review suggested duplicates
- Merge wizard preserves all history

### Bulk Import & Export
**Import Wizard:**
1. Upload CSV/Excel file
2. Auto-detect columns with AI
3. Manual field mapping
4. Validate data (phone format, email validity)
5. Preview first 10 rows
6. Choose: Create new, update, or skip duplicates
7. Background processing for large imports
8. Email notification with error report

**Export Options:**
- Export all or filtered segment
- Select fields to include
- Format: CSV, Excel, vCard

### Contact Notes & Collaboration
- Team notes visible to all
- Rich text formatting
- @mention team members (triggers notification)
- Attach files/photos
- Pin important notes
- Search notes across all contacts

### Custom Fields System
- Create unlimited custom fields
- Field types: Text, Number, Date, Dropdown, Multi-Select, Checkbox, URL
- Required vs optional
- Use in segmentation and reporting

**Backend Tables:**
- `contacts` *(enhanced with new fields)*
- `contact_custom_fields` *(new)*
- `contact_custom_field_values` *(new)*
- `contact_stages` *(new)*
- `contact_scores` *(new)*
- `contact_segments` *(new)*
- `contact_timeline` *(view)*
- `contact_notes` *(existing, enhanced)*
- `import_jobs` *(new)*

**Edge Functions:**
- `calculate-contact-score`
- `detect-duplicates`
- `merge-contacts`
- `import-contacts`
- `export-contacts`

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) via `_createPageRoute()` helper
- **Phase 2 - Intelligence:**
  - **Smart Prioritization:** Contacts sorted by VIP status → interaction frequency → score → recency
  - **Contextual Hiding:** Hides contacts with score <30 and inactive >90 days (unless recently opened)
  - **AI Insight Banners:** Contextual suggestions (e.g., "5 cold contacts - re-engage?")
  - **Interaction Tracking:** Tracks `_contactTapCounts` and `_contactLastOpened` for adaptive ordering
- **Phase 3 - Delight:**
  - **Celebration Banners:** Milestone celebrations (1st, 10th, 25th, 50th, 100th contact) with elastic bounce
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K, Cmd+N, Cmd+R, Esc)
  - **Staggered Animations:** Contact cards fade-in + slide-up with staggered delays (300ms + index * 50ms)

---

#### [Enhanced Addendum — New Module: Reviews]

### 3.7 Reviews (COMPLETE SPECIFICATION)

**Purpose:** Comprehensive review management and reputation tracking across multiple platforms with automated request workflows and response management.

### Review Aggregation
**Multi-Platform Support:**
- **Google Reviews:** Sync from Google Business Profile
- **Facebook Reviews:** Import from Facebook Business Page
- **Yelp Reviews:** Connect Yelp Business account
- **Internal Reviews:** Collect reviews directly in-app
- Automatic sync on configurable schedule (hourly, daily, weekly)
- Manual refresh option

### Review Dashboard
**Overview Metrics:**
- Average rating across all platforms
- Total review count
- Rating distribution (5-star breakdown)
- Recent reviews (last 7/30 days)
- Platform comparison (rating by source)
- Response rate percentage
- Trend indicators (up/down vs previous period)

**Quick Actions:**
- Request new reviews
- View pending responses
- Respond to reviews
- Export review data

### Review Requests
**Automated Request Workflows:**
- Trigger after job completion
- Trigger after payment received
- Trigger after quote acceptance
- Scheduled requests (e.g., 3 days after service)
- Custom trigger rules

**Request Channels:**
- Email with review link
- SMS with short link
- WhatsApp message
- In-app notification

**Request Templates:**
- Pre-built templates per trigger type
- Customizable messaging
- Personalization with merge fields (customer name, service type, job date)
- A/B testing support
- Template performance tracking

**Request Status Tracking:**
- Pending (sent, awaiting response)
- Sent (delivered, not yet reviewed)
- Received (review submitted)
- Responded (review responded to)
- Expired (request timed out)

### Review Management
**Review List View:**
- All reviews in chronological order
- Filter by platform (Google, Facebook, Yelp, Internal)
- Filter by rating (1-5 stars)
- Filter by status (pending response, responded)
- Filter by date range
- Search reviews by customer name or content
- Sort by date, rating, platform

**Review Details:**
- Full review text
- Customer information with link to contact
- Platform badge and direct link to review
- Rating stars display
- Review date and time
- Response history
- Associated job/booking (if applicable)

**Review Response:**
- Respond directly from Swiftlead
- Platform-specific response rules
- Character limits per platform
- Response templates
- AI-suggested responses
- Draft responses with auto-save
- Response scheduling
- Response analytics (views, helpful votes)

### Review Analytics
**Performance Metrics:**
- Average rating trend over time
- Review volume by period
- Platform performance comparison
- Rating distribution charts
- Response time metrics
- Response rate by platform
- Sentiment analysis (positive/neutral/negative)
- Keyword analysis (most mentioned topics)

**Reports:**
- Monthly review summary
- Year-over-year comparison
- Platform-specific reports
- Export to PDF/CSV
<!-- REMOVED: Scheduled email reports - Removed per decision matrix 2025-11-05 -->

### Net Promoter Score (NPS)
**NPS Surveys:**
- Create NPS surveys with custom questions
- Send via email/SMS/WhatsApp
- Track response rates
- Calculate NPS score (0-10 scale)
- Categorize: Promoters (9-10), Passives (7-8), Detractors (0-6)

**NPS Dashboard:**
- Current NPS score
- Score trend over time
- Promoter/Passive/Detractor breakdown
- Response rate tracking
- Historical NPS data
- Industry benchmarking

**NPS Management:**
- Active surveys list
- Survey results view
- Response history
- Follow-up workflows for detractors
- Thank you messages for promoters

### Review Settings
**Platform Integrations:**
- Google Business Profile connection
- Facebook Business Page connection
- Yelp Business account connection
- API key management
- Sync frequency configuration
- Manual sync option

**Request Automation:**
- Enable/disable auto-requests
- Configure trigger rules
- Set request delays
- Choose request channels
- Select request templates
- Exclude certain customer segments

**Response Settings:**
- Default response templates
- Auto-response rules (for 5-star reviews)
- Response approval workflow
- Response character limits
- Response scheduling rules

**Notification Preferences:**
- New review alerts
- Low rating alerts (< 3 stars)
- Response reminders
- Weekly summary emails

### Review Widgets & Embedding
**Review Display Widgets:**
- Star rating widget
- Review carousel
- Recent reviews list
- Average rating badge
- Customizable styling
- Embed code generation

**Website Integration:**
- WordPress plugin
- HTML embed codes
- API for custom integrations
- Mobile-responsive widgets

### Review Moderation
**Review Filtering:**
- Flag inappropriate reviews
- Hide specific reviews from display
- Report fake reviews to platforms
- Review verification
- Spam detection

**Response Moderation:**
- Review responses before publishing
- Draft and approval workflow
- Response templates approval
- Compliance checking

### Review Insights
**AI-Powered Insights:**
- Sentiment analysis
- Topic extraction
- Improvement suggestions
- Competitor comparison
- Trend predictions
- Customer satisfaction scoring

**Actionable Recommendations:**
- Areas for improvement
- Response suggestions
- Request timing optimization
- Platform focus recommendations

**Backend Tables:**
- `reviews`
- `review_requests`
- `review_responses`
- `review_platforms`
- `nps_surveys`
- `nps_responses`
- `review_templates`
- `review_analytics`

**Edge Functions:**
- `sync-reviews`
- `send-review-request`
- `post-review-response`
- `calculate-nps`
- `analyze-review-sentiment`
- `generate-review-widget`

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) via `_createPageRoute()` helper
- **Phase 2 - Intelligence:**
  - **Progressive Disclosure:** Collapsible sections for Recent, This Month, Older reviews
  - **Celebration Tracking:** Framework for milestone celebrations (ready for future implementation)
- **Phase 3 - Delight:**
  - **Celebration Banners:** Framework for milestone celebrations (ready for future implementation)
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K, Cmd+R, Esc)
  - **Smooth Animations:** All navigation uses consistent page transitions

---

#### [Enhanced Addendum — Enhanced Module: Notifications]

### 3.8 Notifications System (ENHANCED SPECIFICATION)

**Purpose:** Intelligent multi-channel notification delivery with granular preferences and smart batching.

### Notification Channels
- **Push:** Mobile app + web push with rich notifications
- **Email:** Instant, daily digest, weekly digest
- **SMS:** Critical alerts only (opt-in)
- **In-App:** Notification center with history

### Granular Preference Management
**Per Notification Type Control:**
- Enable/disable entirely
- Choose channels (push, email, SMS, in-app)
- Set priority (instant, batched, digest-only)

**Per Channel Control:**
- Push: Enable/disable per device
- Email: Choose address if multiple
- SMS: Enable only for critical

**UI: Settings → Notifications → Grid**
- Toggle switches for each type×channel
- Preview notifications
- Reset to defaults

### Smart Batching
- Group similar notifications
- Batch intervals: 5 min, 15 min, 1 hour, digest-only
- Exclude critical from batching
- User-configurable per type

<!-- REMOVED: Digest Emails - Removed per decision matrix 2025-11-05 -->

<!-- REMOVED: Do-Not-Disturb - Removed per decision matrix 2025-11-05 -->

### Rich Notifications
**Interactive Push:**
- Reply button
- Mark Complete button (updates without opening app)
- View button (deep link)

**Images & Media:**
- Contact profile photo
- Preview attached images
- Job site photo

**Progress Indicators:**
- Job completion %
- Booking countdown
- Invoice payment status

**Backend Tables:**
- `notification_preferences` *(enhanced)*
- `notification_delivery_log` *(new)*
- `notification_templates` *(new)*
- `notification_schedules` *(new)*
- `notification_batches` *(new)*

**Edge Functions:**
- `send-notification`
- `process-notification-queue`
- `send-daily-digest`
- `send-weekly-digest`
- `track-notification-engagement`

---

#### [Enhanced Addendum — New Module: Import/Export]

### 3.9 Data Import / Export (COMPLETE SPECIFICATION)

**Purpose:** Bulk data operations for migration, backups, and integrations.

### Bulk Import
**5-Step Import Wizard:**
1. Upload file (CSV, Excel, vCard, max 50 MB)
2. Map fields (AI auto-detect + manual mapping)
3. Configure (handle duplicates, validation, tagging)
4. Review & validate (preview 10 samples)
5. Process & results (success count, error report, undo option)

**Supported Data:** Contacts, Jobs, Bookings, Invoices, Payments

<!-- REMOVED: Import Templates - Removed per decision matrix 2025-11-05 -->

### Bulk Export
**5-Step Export Builder:**
1. Select data type
2. Filter data (date range, status, segment)
3. Select fields (drag to reorder)
4. Choose format (CSV, Excel, PDF, JSON)
5. Generate & download (background processing)

<!-- REMOVED: Scheduled Exports - Removed per decision matrix 2025-11-05 -->

<!-- REMOVED: Backups & Restore - Removed per decision matrix 2025-11-05 -->

### GDPR Data Requests
**Right to Portability:** Complete data export in JSON

**Right to Erasure:** Secure deletion with audit trail

**Backend Tables:**
- `import_jobs`
- `import_errors`
- `export_jobs`
- `gdpr_requests`
- <!-- REMOVED: `export_templates`, `scheduled_exports` - Removed per decision matrix 2025-11-05 -->

**Edge Functions:**
- `import-data`
- `export-data`
- <!-- REMOVED: `process-scheduled-export` - Removed per decision matrix 2025-11-05 -->
- `generate-gdpr-export`
- `process-gdpr-deletion`

---

### 3.10 Dashboard (Home Screen)
**Purpose:** At-a-glance business health overview with actionable insights and quick access to key metrics.

**Core Capabilities:**
- **Quick Stats Cards:**
  - Today's Schedule (bookings count + first appointment time)
  - Unread Messages (count with channel breakdown)
  - Pending Quotes (count + value)
  - Overdue Invoices (count + total amount)
  - Active Jobs (count + next due)
- **Revenue Analytics:**
  - This week vs last week
  - This month vs last month
  - Year-to-date revenue
  - Revenue by service type (chart)
  - Average job value
- **Activity Feed:**
  - Recent messages
  - New bookings
  - Quote acceptances
  - Payments received
  - Job completions
  - Review notifications
  - Real-time updates
- **Smart Insights (AI-Powered):**
  - Booking trends ("20% more bookings this week")
  - Revenue anomalies ("Revenue down 15% vs last week")
  - Lead response time ("Average 2h response time, industry avg 4h")
  - Top services ("Boiler repairs up 40%")
  - Client satisfaction ("4.8★ average from 15 reviews this month")
  - Action suggestions ("5 quotes expiring soon - follow up?")
- **Quick Actions:**
  - Compose new message
  - Create quote
  - Add job
  - Schedule booking
  - Record payment
- **Team Performance:**
  - Jobs completed per team member
  - Revenue generated per team member
  - Average customer rating per team member
  - Utilization rate
- **Upcoming Schedule:**
  - Next 3 bookings with client names and times
  - Travel time to first appointment
  - Conflicts or double-bookings flagged

**🆕 v2.5.1 Enhancements (10/10 Premium Features):**
- **Interactive Metrics:** All metrics tappable → detailed breakdown sheets with charts, comparisons, export/share options
- **Animated Counters:** Numbers animate from 0 on load (easeOutQuint, 800ms) for premium visual polish
- **Time Range Selector:** 7D/30D/90D segmented control affects all metrics with smooth loading transitions
- **Progressive Disclosure:** Collapsible sections (Weather, Goals, Schedule) with smooth SizeTransition animations
- **Context Menus:** Long-press any metric → context menu (View Details, Compare Periods, Export, Share)
- **Smart Prioritization:** Tracks user interactions, adapts metric order based on usage patterns
- **Predictive Insights:** AI-powered forecast banners ("Based on current trends, you're on track for £X this month")
- **Comparison Views:** All metrics show "vs. last period" with trend percentages and color-coded indicators
- **Contextual Hiding:** Weather widget intelligently hides when not relevant (evening hours, no outdoor jobs)
- **Smart Defaults:** Framework for role-based adaptation (ready for future enhancement)
- **Rich Tooltips:** Info icons on all metrics, long-press for detailed breakdown tooltips
- **Smooth Animations:** Page transitions (fade + slide), animated page indicators, smooth chart updates
- **Haptic Feedback:** Consistent haptic on all interactions (light/medium/heavy based on action type)
- **Progress Celebrations:** Milestone celebration banners with elastic bounce animation (e.g., "🎉 You hit £10k revenue!")
- **Progressive Loading:** 3-phase loading (critical metrics → charts → feed) for instant perceived speed
- **Keyboard Shortcuts (Web):** Framework in place (Ctrl+R for refresh, extensible for power users)
- **Parallax Effects:** Structure in place for scroll-based depth (can be enabled)
- **Swipeable Automation Cards:** Today's Summary hero card + 4 automation insight cards in swipeable PageView
- **Goal Tracking:** Set revenue/booking goals and track progress with visual progress bars
- **Weather Widget:** Weather forecast for outdoor job planning (contextually shown/hidden)
- **Offline Mode:** View cached dashboard data when offline

**Interactions (v2.5.1 - 10/10 Features):**
- **Interactive Metrics:** Tap any metric → detailed breakdown sheet with charts, comparisons, export/share
- **Context Menus:** Long-press any metric → context menu (View Details, Compare Periods, Export, Share)
- **Animated Counters:** All numbers animate from 0 on load and when period changes
- **Collapsible Sections:** Tap section headers to expand/collapse (Weather, Goals, Schedule)
- **Swipeable Cards:** Swipe left/right through Today's Summary + 4 Automation Insight cards
- **Time Range Selection:** Tap 7D/30D/90D to change period, affects all metrics
- **Haptic Feedback:** Consistent haptic on all interactions (light/medium/heavy)
- **Celebrations:** Milestone achievements trigger celebration banners with elastic bounce
- **Pull-to-refresh** to update all stats
- **Swipe activity feed** to view more items
- **Tap insight** to view supporting data
- **Tap quick action button** to launch workflow with smooth page transitions
- Tap team member to view individual dashboard

**UI Components:** MetricCard, RevenueChart, ActivityFeed, InsightCard, QuickActionButton, GoalProgressBar

---

### 3.11 AI Hub
**Purpose:** Central configuration and monitoring for all AI-powered features in Swiftlead.

**Core Capabilities:**
- **AI Receptionist Configuration:**
  - Enable/disable auto-reply (Note: Backend verification needed once backend is wired)
  - Configure tone (Formal / Friendly / Concise / Custom)
  - Set response delay (instant / 30s / 1min) (Note: Backend verification needed once backend is wired)
  - Customize greeting messages
  - Define escalation rules (Note: Backend verification needed once backend is wired)
  - Business hours configuration
  - FAQ management
  - Test AI responses
  - Configure booking assistance (Note: Backend verification needed once backend is wired)
  - Configure lead qualification (Note: Backend verification needed once backend is wired)
  - Configure smart handover (Note: Backend verification needed once backend is wired)
  - Configure response delay (Note: Backend verification needed once backend is wired)
  - Configure confidence threshold (Note: Backend verification needed once backend is wired)
  - Configure fallback responses (Note: Backend verification needed once backend is wired)
  <!-- REMOVED: Configure multi-language support - Removed per decision matrix 2025-11-05 -->
  - Configure custom response overrides (Note: Backend verification needed once backend is wired)
  - Enable two-way confirmations (Note: Backend verification needed once backend is wired)
  - Enable context retention (Note: Backend verification needed once backend is wired)
- **AI Quote Assistant:**
  - Enable/disable smart pricing
  - Configure pricing rules
  - Historical pricing analysis
  - Approval thresholds
  - Competitor pricing data
- **AI Review Reply:**
  - Auto-respond to reviews
  - Tone customization
  - Response templates
  - Approval workflow
  - Performance tracking
- **AI Learning Center:**
  - View what AI has learned from conversations
  - Correct AI mistakes
  - Add training examples
  - Performance metrics per AI feature
- **AI Usage & Credits:**
  - Monthly credit allocation
  - Credits used vs remaining
  - Usage breakdown by feature
  - Cost per interaction
  - Add-on credit purchases
- **AI Insights:**
  - Top AI-handled conversations
  - Handover reasons and frequency
  - Client satisfaction with AI interactions
  - Time saved by automation
  - Conversion rates (AI → human → booking)

**🆕 v2.5.1 Enhancements:**
- **Conversation Simulator:** Preview AI responses before enabling (Test Mode)
- **Custom Training:** Upload conversation examples to improve AI (Test Mode)
- **Confidence Thresholds:** Set minimum confidence before AI responds
- **Fallback Rules:** Define what happens when AI is uncertain
<!-- REMOVED: Multi-Language - Removed per decision matrix 2025-11-05 -->
- **Sentiment Analysis:** Monitor emotional tone of AI interactions
- **Smart Scheduling:** AI learns optimal response times

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) via `_createPageRoute()` helper
- **Phase 2 - Intelligence:**
  - **Celebration Tracking:** Framework for milestone celebrations (ready for future implementation)
  - **Progressive Disclosure:** Collapsible sections for status, performance, and configuration
  - **AI Insight Banners:** Contextual AI status and performance insights
- **Phase 3 - Delight:**
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K, Cmd+R, Esc)
  - **Smooth Animations:** All navigation uses consistent page transitions

**Interactions:**
- Toggle AI features on/off
- Adjust settings with sliders and dropdowns
- View real-time AI performance metrics
- Test AI responses with sample queries
- Review and approve AI suggestions
- Export AI interaction logs

**UI Components:** AIToggle, ToneSelector, ConfidenceSlider, ConversationSimulator, UsageGauge, InsightCards

---

### 3.12 Settings & Configuration
**Purpose:** Organization-wide settings, team management, integrations, and preferences.

**Core Capabilities:**
- **Profile & Organization:**
  - Business name, logo, brand colors
  - Contact information
  - Industry/profession selection
  - Service area (postcode/city radius)
  - Business hours
  - Timezone
  - Currency
- **Team Management:**
  - Add/remove team members
  - Role assignment (Owner / Admin / Member / Viewer)
  - Permission management per role
  - User activity tracking
  - Session management
- **Integrations:**
  - **Calendar:** Google Calendar, Apple Calendar
  <!-- REMOVED: Outlook sync - Removed per decision matrix 2025-11-05 -->
  - **Email:** IMAP/SMTP configuration for inbox
  - **Messaging:** SMS (Twilio), WhatsApp Business API
  - **Social:** Facebook Pages, Instagram Business
  - **Payments:** Stripe Connect setup
  <!-- REMOVED: Cloud Storage (Google Drive, Dropbox) - Removed per decision matrix 2025-11-05 -->
  - **Accounting:** Xero, QuickBooks (future)
- **Billing & Subscription:**
  - View current plan
  - Usage summary (messages, automation credits)
  - Add-on purchases (extra numbers, message bundles, seats)
  - Payment method management
  - Billing history and invoices
  - Upgrade/downgrade plan
- **Notifications:**
  - Global notification preferences
  - Email digest schedule
  - Push notification settings
  - SMS alert preferences
  - In-app notification rules
- **Security:**
  - Two-factor authentication (2FA)
  - Password change
  - Active sessions
  - Login history
  - API keys management
  - Audit logs
- **Data & Privacy:**
  - GDPR compliance settings
  - Data retention policies
  - Export all data
  - Delete account
  - Privacy policy
  - Terms of service
- **Customization:**
  - Custom fields configuration
  - Service types and categories
  - Tax rates
  - Invoice templates
  - Email signatures
  - Quick reply templates
- **Workflows & Automation:**
  - Automated reminder settings
  - Follow-up sequences
  - Booking confirmation templates
  - Payment reminder schedules
  - Review request timing

**🆕 v2.5.1 Enhancements:**
- **Quick Setup Wizard:** Guided onboarding for first-time setup
- **Settings Search:** Find any setting quickly
- **Bulk Configuration:** Apply settings across team members
- **Template Library:** Pre-built configurations for common professions
- **Import/Export Settings:** Transfer configuration between organizations
- **Dark Mode:** Toggle light/dark theme
- **Accessibility:** Font size, contrast adjustments, screen reader mode
- **Keyboard Shortcuts:** View and customize shortcuts

**🚀 Phase 1-3 Premium Features (10/10 Implementation):**
- **Phase 1 - Foundation:**
  - **Custom Page Transitions:** Smooth fade + slide transitions (300ms) via `_createPageRoute()` helper
- **Phase 2 - Intelligence:**
  - **Celebration Tracking:** Framework for milestone celebrations (ready for future implementation)
- **Phase 3 - Delight:**
  - **Keyboard Shortcuts:** Shortcuts + Actions wrapper (Cmd+K for search, Cmd+R for refresh, Esc)
  - **Smooth Animations:** All navigation uses consistent page transitions

**Interactions:**
- Navigate settings via sidebar menu
- Search settings with instant results
- Toggle switches for binary options
- Edit text fields inline
- Save changes with confirmation
- Preview changes before applying
- Reset to defaults option

**UI Components:** SettingsSidebar, ToggleSwitch, ColorPicker, FileUploader, IntegrationCard, TeamMemberList

---

### 3.13 Adaptive Profession System
**Purpose:** Configure Swiftlead to match industry-specific terminology and workflows.

**Core Capabilities:**
- **Profession Selection:**
  - Trades (Plumber, Electrician, HVAC, Roofer, Builder, Landscaper)
  - Home Services (Cleaner, Pest Control, Locksmith, Handyman)
  - Professional Services (Salon, Spa, Clinic, Consultant, Therapist)
  - Auto Services (Mobile Mechanic, Detailer, Towing)
  - Custom (define own labels)
- **Adaptive Terminology:**
  - Jobs vs Appointments vs Sessions
  - Clients vs Customers vs Patients
  - Quotes vs Estimates vs Proposals
  - Invoices vs Bills vs Statements
- **Module Visibility:**
  - Show/hide features not relevant to profession
  - E.g., Parts tracking for trades, Treatment notes for clinics
- **Custom Fields:**
  - Pre-configured fields per profession
  - E.g., License # for contractors, Insurance policy for clinics
- **Workflow Defaults:**
  - Booking duration defaults
  - Payment terms
  - Quote expiry periods
  - Reminder timing
- **Template Library:**
  - Email templates
  - Message templates

**🆕 v2.5.1 Enhancements:**
- **Smart Recommendations:** AI suggests optimal settings based on profession
- **Industry Benchmarks:** Compare performance to industry averages
- **Multi-Profession Support:** Manage multiple service types in one account
- **Clone Configuration:** Duplicate settings for franchise/multi-location

**Interactions:**
- Select profession during onboarding
- Change profession in Settings
- Preview how UI changes with different professions
- Customize labels and fields
- Enable/disable modules

**UI Components:** ProfessionSelector, TerminologyMapper, ModuleToggle, TemplateLibrary

---

### 3.14 Onboarding Flow
**Purpose:** Seamless setup wizard for new users to get started quickly.

**Core Capabilities:**
- **Step 1: Welcome & Value Prop**
  - Brief introduction to Swiftlead
  - Key benefits highlighted
  - Skip option for experienced users
- **Step 2: Profession Selection**
  - Choose industry/profession
  - Explain how it affects the app
- **Step 3: Business Details**
  - Business name, logo upload
  - Service area configuration
  - Business hours
- **Step 4: Team Members**
  - Invite team (optional)
  - Skip for solo users
- **Step 5: Integrations**
  - Connect calendar (Google/Apple)
  <!-- REMOVED: Outlook - Removed per decision matrix 2025-11-05 -->
  - Connect payment processor (Stripe)
  - Connect messaging channels (SMS, WhatsApp, Email)
  - Skip for later option
- **Step 6: AI Configuration**
  - Enable AI Receptionist
  - Set tone and greeting
  - Test AI response
- **Step 7: Booking Setup**
  - Define services offered
  - Set availability
  - Create booking link
- **Step 8: Final Checklist**
  - Review all settings
  - Launch app or continue customizing

**🆕 v2.5.1 Enhancements:**
- **Progress Indicator:** Visual progress through onboarding
- **Save & Continue Later:** Pause onboarding and resume
- **Smart Defaults:** AI suggests settings based on profession
- **Import Data:** Migrate from competitors during onboarding
- **Video Tutorials:** Inline help videos per step
- **Skip All:** Quick start with defaults, customize later

**Interactions:**
- Tap "Next" to proceed to next step
- Tap "Back" to revisit previous step
- Tap "Skip" to defer optional steps
- Drag-and-drop to upload logo
- Toggle switches for features
- Progress bar shows completion

**UI Components:** OnboardingCarousel, ProgressStepper, ProfessionPicker, IntegrationConnector, PreviewCard

---

### 3.15 Platform Integrations
**Purpose:** Connect Swiftlead with essential external services for seamless workflow.

**Core Capabilities:**
- **Calendar Integrations:**
  - **Google Calendar:** Two-way sync, prevent double-booking
  - **Apple Calendar:** CalDAV sync for iOS/macOS users
  <!-- REMOVED: Outlook Calendar (Microsoft 365 integration) - Removed per decision matrix 2025-11-05 -->
- **Messaging Integrations:**
  - **SMS:** Twilio for text messaging
  - **WhatsApp Business API:** Official WhatsApp integration
  - **Facebook Messenger:** Meta Business integration
  - **Instagram Direct:** Meta Business integration
  - **Email:** IMAP/SMTP for custom email addresses
- **Payment Integrations:**
  - **Stripe:** Credit/debit card processing, subscriptions, invoicing
  - **Stripe Terminal:** In-person contactless payments (optional)
<!-- REMOVED: Cloud Storage (Google Drive, Dropbox) - Removed per decision matrix 2025-11-05 -->
- **Accounting (Future):**
  - **Xero:** Sync invoices and payments
  - **QuickBooks:** Sync financial data
- **Ad Platforms (Future):**
  - **Google Ads:** Lead form sync
  - **Facebook/Instagram Lead Ads:** Automatic lead import
- **Review Platforms:**
  - **Google Business Profile:** Sync and respond to reviews
  - **Trustpilot:** Review monitoring
  - **Call Tracking:**
  - **Twilio Voice:** Call forwarding, recording, transcription

**🆕 v2.5.1 Enhancements:**
- **Integration Marketplace:** Browse and enable integrations
- **One-Click Connect:** OAuth for easy authorization
- **Sync Status Dashboard:** Monitor integration health
- **Webhook Support:** Custom integrations via webhooks
- **Zapier Integration:** Connect to 1000+ apps
- **API Access:** Developer API for custom integrations

**Interactions:**
- Browse available integrations
- Click "Connect" to authorize
- Configure sync settings
- Test connection
- Monitor sync status
- Disconnect or reconnect

**UI Components:** IntegrationCard, ConnectionStatus, SyncSettings, OAuthFlow, WebhookBuilder

---

### 3.16 Reports & Analytics
**Purpose:** Comprehensive business intelligence with customizable reports and data visualization.

**Core Capabilities:**
- **Pre-Built Reports:**
  - Revenue by period (daily, weekly, monthly, quarterly, annually)
  - Revenue by service type
  - Revenue by team member
  - Jobs completed by status
  - Booking sources and conversion rates
  - Quote acceptance rates
  - Invoice aging report
  - Client lifetime value
  - Client acquisition cost
  - Payment method breakdown
  - Team performance metrics
  - Response time analytics
  - No-show rates
  - Review ratings over time
<!-- REMOVED: Custom Report Builder - Removed per decision matrix 2025-11-05 -->
- **Visualizations:**
  - Line charts for trends
  - Bar charts for comparisons
  - Pie charts for distribution
  - Tables with sorting and filtering
  - Heatmaps for time-based data
  - Funnel charts for conversion tracking
<!-- REMOVED: Export Options - Removed per decision matrix 2025-11-05 -->
- **Dashboards:**
  - Executive summary dashboard
  - Operations dashboard
  - Financial dashboard
  - Customizable with widgets

**🆕 v2.5.1 Enhancements:**
- **AI Insights:** Automatic anomaly detection and insights
- **Predictive Analytics:** Forecast revenue and bookings
- **Cohort Analysis:** Track client retention over time
- **Benchmark Comparisons:** Compare to industry standards
- **Mobile Reports:** Full reporting on mobile devices
- **Real-Time Data:** Live dashboards with auto-refresh
- **Data Warehouse:** Historical data retention for trend analysis

**Interactions:**
- Select report from library
- Customize date range and filters
- Drill down into specific metrics
<!-- REMOVED: Export or share report, Schedule recurring reports - Removed per decision matrix 2025-11-05 -->
- Create custom dashboards

**UI Components:** ChartWidget, DataTable, FilterPanel, DateRangePicker
<!-- REMOVED: ReportBuilder, ExportButton - Removed per decision matrix 2025-11-05 -->

---

## 4️⃣ Adaptive Profession Configuration (One Codebase, Industry Fit)
**Purpose:** Serve multiple industries without rebuilding by adapting labels and modules to profession.

| Config | Trades | Home Services | Professional Services |
|--------|--------|---------------|----------------------|
| Job label | Job | Service | Appointment |
| Client label | Customer | Client | Patient / Client |
| Quote label | Quote | Estimate | Proposal |
| Navigation | All modules | All modules | Hide Parts tracking |
| Custom fields | License #, Permit # | Insurance policy | Treatment notes, consent |
| Lead speed | High urgency | High urgency | Pre-scheduled |

Profession selected at onboarding → labels applied instantly.

✅ Single codebase – industry-specific experience.

---

## 5️⃣ Security & Compliance
**Purpose:** Enterprise-grade security and regulatory compliance features.

**Core Capabilities:**
- **GDPR Compliance:**
  - GDPR-compliant data storage and processing
  - Consent tracking and management per contact
  - Right to be forgotten implementation with secure data deletion
  - Data processing agreements and privacy policy templates
- **Data Retention:**
  - Configurable data-retention periods per organisation
  - Automatic deletion of expired records (with admin override)
  - Retention policy enforcement and audit trails
- **Authentication & Access Control:**
  - 2-Factor Authentication (2FA) for all users
  - Role-based Row-Level Security (RLS) in Supabase
  - Password reset and recovery workflows
  - Active session management and revocation
- **Audit Trails:**
  - Complete audit logs for all key actions
  - Tracks user, action, timestamp, and data changes
  - Exportable audit logs for compliance reviews
- **Backups & Recovery:**
  - Daily automated backups of all data
  - Point-in-time restore capability
  - Backup verification and testing procedures
- **Monitoring & Alerts:**
  - Security event monitoring and alerting
  - Suspicious activity detection
  - Failed login attempt tracking
  - Data access anomaly alerts

**Interactions:**
- Configure GDPR settings from Settings
- Set data-retention periods per data type
- Enable 2FA for account security
- View audit logs and export for compliance
- Request data deletion for GDPR compliance
- Monitor security events and alerts

---

## 6️⃣ Non-Functional Requirements
**Purpose:** Performance, reliability, and accessibility standards.

**Core Capabilities:**
- **Uptime & Reliability:**
  - 99.9% uptime target with SLA guarantees
  - Redundant infrastructure and failover systems
  - Health monitoring and automatic recovery
- **Offline-First Architecture:**
  - Offline caching for Inbox and Jobs data
  - Queue actions for sync when connection restored
  - Conflict resolution for concurrent edits
- **Accessibility:**
  - WCAG AA contrast compliance
  - Full keyboard navigation support
  - Screen reader compatibility
  - Accessible form labels and error messages
- **Responsive Design:**
  - Mobile-first responsive layout
  - Tablet-optimized views
  - Web app support with desktop layouts
  - Adaptive UI for different screen sizes
- **Error Handling:**
  - Error logging via Sentry integration
  - User-friendly error messages
  - Automatic error reporting and monitoring
  - Graceful degradation for service outages
- **Performance:**
  - Fast page load times (< 2s initial load)
  - Smooth animations and transitions
  - Efficient data loading and pagination
  - Optimized image and media delivery

---

#### [Enhanced Addendum — Enhanced Value Proposition]

## Enhanced Value Proposition

**Before:** "Never miss a job again"  

**After:** "Capture leads, nurture relationships, automate follow-ups, and grow your business — all in one AI-powered platform"

### Pricing Justification

**£199/mo replaces:**
- Job management (£89)
- CRM (£49)
- SMS messaging (£25)
- **Total: £163/mo in separate tools**

Plus superior AI and all-in-one convenience.

**ROI:** Book 1 extra job/month from better follow-ups = platform pays for itself

---



---

## 6️⃣bis Code Examples & Implementation Patterns

**Purpose:** Developer-ready code patterns for critical implementations.

### Authentication Flow Example

```dart
// Supabase authentication with error handling
Future<void> signInWithEmail(String email, String password) async {
  try {
    final response = await supabase.auth.signIn(
      email: email,
      password: password,
    );
    if (response.error != null) {
      throw AuthException(response.error!.message);
    }
    // Store session and navigate to home
    await _sessionManager.storeSession(response.user!);
    navigationService.pushReplacementNamed('/home');
  } on AuthException catch (e) {
    _showErrorToast('Login failed: ${e.message}');
  } catch (e) {
    _showErrorToast('Unexpected error. Please try again.');
    logError(e, StackTrace.current);
  }
}
```

### Real-Time Subscription Pattern

**Note:** This pattern will be implemented once the backend is wired. Current MVP uses pull-based approach.

```dart
// Subscribe to real-time message updates
StreamSubscription? _messageSubscription;

void subscribeToMessages() {
  _messageSubscription = supabase
    .from('messages')
    .on(SupabaseEventTypes.insert, (payload) {
      final newMessage = Message.fromJson(payload.new);
      _handleNewMessage(newMessage);
    })
    .on(SupabaseEventTypes.update, (payload) {
      final updatedMessage = Message.fromJson(payload.new);
      _handleMessageUpdate(updatedMessage);
    })
    .subscribe();
}

@override
void dispose() {
  _messageSubscription?.cancel();
  super.dispose();
}
```

### Error Handling Pattern with Retry Logic

```dart
// Resilient API call with exponential backoff
Future<T> callWithRetry<T>(
  Future<T> Function() operation, {
  int maxAttempts = 3,
  Duration initialDelay = const Duration(seconds: 1),
}) async {
  int attempt = 0;
  while (true) {
    try {
      return await operation();
    } catch (e) {
      attempt++;
      if (attempt >= maxAttempts) {
        rethrow;
      }
      final delay = initialDelay * pow(2, attempt - 1);
      await Future.delayed(delay);
    }
  }
}

// Usage
final jobs = await callWithRetry(() => fetchJobs());
```

### Offline Sync Pattern

```dart
// Queue actions when offline, sync when connected
class OfflineSyncManager {
  final _queue = <SyncAction>[];
  
  Future<void> queueAction(SyncAction action) async {
    _queue.add(action);
    await _persistQueue();
    if (await isOnline()) {
      await _processQueue();
    }
  }
  
  Future<void> _processQueue() async {
    while (_queue.isNotEmpty) {
      final action = _queue.first;
      try {
        await action.execute();
        _queue.removeAt(0);
        await _persistQueue();
      } catch (e) {
        if (e is NetworkException) {
          break; // Stop processing if offline
        }
        // Remove failed action after max retries
        if (action.retries >= 3) {
          _queue.removeAt(0);
        }
      }
    }
  }
}
```

---

## 6️⃣ter Success Metrics & KPIs

**Purpose:** Measurable indicators of product success post-launch.

### Activation Metrics (First 7 Days)
| Metric | Definition | Target | Measurement |
|--------|------------|--------|-------------|
| **First Job Created** | User creates their first job | 70% within 24h | Track via `jobs` table `created_at` |
| **First Payment Received** | User receives their first payment | 40% within 7d | Track via `payments` table where `status='succeeded'` |
| **AI Receptionist Enabled** | User activates AI auto-reply | 60% within 48h | Track via `ai_config.enabled=true` |
| **Calendar Connected** | User connects Google/Apple Calendar | 50% within 3d | Track via `calendar_integrations` table |
| **First Invoice Sent** | User sends their first invoice | 55% within 5d | Track via `invoices` table |

### Engagement Metrics (Ongoing)
| Metric | Definition | Target | Measurement |
|--------|------------|--------|-------------|
| **Daily Active Users (DAU)** | Users who open app daily | 60% of MAU | Session starts per day / Monthly active users |
| **Feature Adoption Rate** | % using each module | Inbox 95%, Jobs 85%, AI 60% | Track screen views and actions |
| **Session Duration** | Average time in app per session | 12+ minutes | Track session_start to session_end |
| **Messages Sent** | Average messages per org per day | 15+ | Count from `messages` table |
| **Jobs Completed** | Average jobs completed per month | 20+ | Count from `jobs` where `status='completed'` |

### Retention Metrics
| Period | Definition | Target | Measurement |
|--------|------------|--------|-------------|
| **Day 1 Retention** | Users who return on day 2 | 65% | Sessions on D1 / Signups on D0 |
| **Week 1 Retention** | Users active in week 2 | 55% | Active W1 / Active W0 |
| **Month 1 Retention** | Users active in month 2 | 85% | Active M1 / Active M0 |
| **Month 3 Retention** | Users active in month 4 | 70% | Active M3 / Active M0 |
| **Month 6 Retention** | Users active in month 7 | 60% | Active M6 / Active M0 |

### Revenue Metrics
| Metric | Definition | Target | Measurement |
|--------|------------|--------|-------------|
| **MRR (Monthly Recurring Revenue)** | Total monthly subscription revenue | 15% MoM growth | Sum of active subscriptions |
| **ARPU (Average Revenue Per User)** | Average monthly revenue per org | £199+ | MRR / Active organizations |
| **Churn Rate** | % of customers who cancel | <5% monthly | Cancellations / Total customers |
| **CAC (Customer Acquisition Cost)** | Cost to acquire one customer | <£400 | Total acquisition spend / New customers |
| **LTV (Lifetime Value)** | Total revenue per customer | £4,500+ (24+ months) | ARPU × Average customer lifetime |
| **COGS per Org** | Variable costs per organization | <£55 | Sum of API costs / Active orgs |

### Quality Metrics
| Metric | Definition | Target | Measurement |
|--------|------------|--------|-------------|
| **App Crash Rate** | % of sessions with crashes | <0.5% | Sentry crash reports / Total sessions |
| **API Error Rate** | % of API calls that fail | <2% | Failed API calls / Total API calls |
| **Uptime** | System availability | 99.9% | Uptime monitoring service |
| **P95 Load Time** | 95th percentile page load time | <2 seconds | Performance monitoring |
| **Support Ticket Rate** | Tickets per active organization | <0.3/month | Support tickets / Active orgs |

### AI Performance Metrics
| Metric | Definition | Target | Measurement |
|--------|------------|--------|-------------|
| **AI Auto-Reply Rate** | % of messages AI can handle | 40%+ | AI replies / Total inbound messages |
| **AI Accuracy** | % of AI replies rated helpful | 85%+ | Positive feedback / Total AI interactions |
| **AI Handover Rate** | % of conversations transferred to human | <30% | Handovers / Total AI conversations |
| **Quote Generation Time** | Avg time AI generates quote | <30 seconds | Track via `ai_interactions` timestamps |

---

## 6️⃣quad Developer Environment Setup

**Purpose:** Quick-start guide for local development environment.

### Prerequisites Checklist
- ✅ Flutter SDK 3.35.6+ installed
- ✅ Dart 3.0+ installed
- ✅ Xcode 15+ (required for Flutter iOS builds)
- ✅ Android Studio with SDK 33+ (required for Flutter Android builds)
- ✅ Flutter SDK 3.0+ with Dart 3.0+
- ✅ Supabase CLI installed (`npm install -g supabase`)
- ✅ Git configured with SSH keys
- ✅ VS Code or Android Studio with Flutter/Dart extensions

### Environment Variables Required

```bash
# .env file (DO NOT COMMIT)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key-here
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key-here

# Twilio
TWILIO_ACCOUNT_SID=your-account-sid
TWILIO_AUTH_TOKEN=your-auth-token
TWILIO_PHONE_NUMBER=+44XXXXXXXXXX

# Stripe
STRIPE_SECRET_KEY=sk_test_xxxxx
STRIPE_PUBLISHABLE_KEY=pk_test_xxxxx
STRIPE_WEBHOOK_SECRET=whsec_xxxxx

# OpenAI
OPENAI_API_KEY=sk-xxxxx

# Meta (Facebook/Instagram)
META_APP_ID=your-app-id
META_APP_SECRET=your-app-secret

# Google
GOOGLE_OAUTH_CLIENT_ID=your-client-id.apps.googleusercontent.com

# Apple
APPLE_CLIENT_ID=your-bundle-id
```

### Local Development Quickstart

```bash
# 1. Clone repository
git clone git@github.com:yourorg/swiftlead.git
cd swiftlead

# 2. Install Flutter dependencies
flutter pub get

# 3. Start Supabase local development
supabase start

# 4. Run database migrations
supabase db reset

# 5. Start the app
flutter run

# 6. Run Edge Functions locally (separate terminal)
supabase functions serve

# 7. Run tests
flutter test
```

### Testing Strategy Overview

**Unit Tests** — Individual functions and classes
```bash
flutter test test/unit/
```

**Widget Tests** — UI components in isolation
```bash
flutter test test/widgets/
```

**Integration Tests** — End-to-end user flows
```bash
flutter test integration_test/
```

**Test Coverage Target:** 80%+ for critical modules (Inbox, Jobs, Payments, AI)

---
## 7️⃣ Pricing & Plans (One Simple Tier)
| Plan | Monthly | What You Get |
|------|---------|--------------|
| Swiftlead Pro | £199 / mo | All features above + full support + unlimited automation credits. |
| Add-ons | £10 per extra number • £15 / 1k messages • £15 per seat | Flexible scaling. |
| Annual Billing | 2 months free (≈ 17% discount) | Encourages commitment. |

COGS Target: £40–£55 / org → ≈ 75–80% margin.  
Positioning: "Everything included — no hidden tiers."

---

## 8️⃣ Design & UX Principles
- Premium but simple — Revolut-style frost only on cards and modals.
- Brand accent: signature teal + neutral palette.
- Unified spacing & typography (Inter / SF Pro).
- Accessible light/dark themes with full contrast.
- Fluid animations & haptics for native feel.

---

## 9️⃣ MVP Definition (Launch Complete = Ready for Backend)
✅ All core modules functional end-to-end.

✅ Adaptive profession system active.

✅ Payments & analytics connected to live data.

✅ AI Receptionist + AI Quote Assistant + Review Reply Assistant + Smart Availability operational.

✅ Teams & permissions working.

✅ Daily digest & AI insights notifications delivering.

✅ Supabase ↔ Stripe ↔ Twilio ↔ Google / Apple Calendar ↔ Meta ↔ Email integrations stable.

✅ Security & compliance features implemented.

✅ Build passes Flutter 3.35.6 stable.

---

## 🔟 Reserved Future Modules
<!-- Reserved for future premium modules – not in v1 build -->
<!-- Call Tracking & Attribution: Twilio sub-numbers, call recording, attribution analytics -->
<!-- Ad Platform Sync: Google / Meta Lead Ads automatic import -->
<!-- Accounting Integration: Xero / QuickBooks sync, automatic transaction import, reconciliation -->
<!-- Franchise Dashboard: Multi-location management, aggregated reporting, central billing -->

---

#### [Enhanced Addendum — Implementation Priority]

## Implementation Priority

**Phase 1 (Months 1-2):** Core modules (Inbox, AI, Jobs, Bookings, Quotes, Invoices, Payments) — *already fully specified in v2.5.1 Final*

**Phase 2 (Months 3-4):** Enhanced modules (Contacts/CRM, Notifications) — *Enhanced addenda*

**Phase 3 (Month 5):** Data & Polish (Import/Export, Teams, Settings) — *v2.5.1 Final*

**Phase 4 (Month 6):** Launch prep (Analytics, Reports, Security audit)

---

## 1️⃣1️⃣ Vision Statement
Swiftlead gives every service business the power and polish of an enterprise system in one mobile app — powered by AI and built for speed.

---

## 6️⃣ bis Non-Functional / Accessibility (Addendum for Cross-Reference)

**Purpose:** Aligns Product Definition with UI Inventory §17 for complete v2.5 matrix coverage.

**Core Standards:**
- **Offline Caching:** All critical data (Inbox & Jobs) cached locally with background sync.
- **Accessibility:** WCAG AA contrast, keyboard navigation, screen-reader labels, focus order.
- **Error Handling:** Sentry logging, graceful recovery, user-friendly error UI.
- **Performance:** <2 s initial load, async lazy loads for media, cached metrics cards.
- **Responsive Design:** Optimised layouts for mobile, tablet, desktop.
- **Reliability:** 99.9 % uptime target, health checks, auto-failover.

*This completes Non-Functional / Accessibility section for cross-reference alignment.*

---

*All other modules (§3.1 Inbox, §3.2 AI, §3.3 Jobs, §3.4 Bookings, §3.5 Money, §3.6 Contacts, §3.7 Reviews, §3.8 Notifications, §3.9 Data Import/Export, §3.10 Dashboard, §3.11 AI Hub, §3.12 Settings, §3.13 Adaptive Profession, §3.14 Onboarding, §3.15 Integrations, §3.16 Reports & Analytics) remain as fully specified and are production-ready.*

*Version 2.5.1 Master — Merged November 2025 (Complete Specification with enhancements + Enhanced addenda integrated)*

---

**Product_Definition_v2.5.1_10of10.md — Complete 10/10 Specification**
