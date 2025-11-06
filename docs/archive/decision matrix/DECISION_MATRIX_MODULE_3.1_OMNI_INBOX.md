# Decision Matrix: Module 3.1 — Omni-Inbox

**Date:** 2025-01-XX  
**Purpose:** Compare all specifications against code implementation to identify gaps, inconsistencies, and decisions needed

---

## Matrix Legend

| Status | Meaning |
|--------|---------|
| ✅ | Fully Implemented |
| ⚠️ | Partially Implemented |
| ❌ | Not Implemented |
| 🔄 | Intentional Deviation |
| ❓ | Needs Verification |
| 📝 | Documented but Different Implementation |

---

## Core Features

| Feature | Product Def §3.1 | UI Inventory §1 | Screen Layouts §2 | Backend Spec §1 | Code Implementation | Decision Needed |
|---------|------------------|------------------|-------------------|-----------------|---------------------|----------------|
| **Unified Message View** | ✅ All channels (SMS, WhatsApp, Email, Facebook, Instagram) | ✅ Inbox List View | ✅ InboxScreen with channel support | ✅ `messages` table with channel enum | ✅ InboxScreen with multi-channel support | ✅ **ALIGNED** |
| **Message Threading** | ✅ Group by contact, maintain history | ✅ Thread grouping | ✅ Thread view | ✅ `message_threads` table | ✅ MessageThread model with contact grouping | ✅ **ALIGNED** |
| **Real-time Updates** | ✅ Push notifications, badges | ✅ Real-time updates | ✅ Live updates | ✅ Real-time subscriptions | ⚠️ Partial: SupabaseService has channel() but not used, no push packages, inbox uses _loadMessages() only | ✅ **DECISION MADE** — Needs backend first. Deferred until backend is wired. Current pull-based approach acceptable for MVP. |
| **Internal Notes** | ✅ Private notes, @mentions, timestamps | ✅ Internal Notes Modal | ✅ Notes functionality | ✅ `message_notes` table with mentions | ✅ InternalNotesModal component exists | ✅ **ALIGNED** |
| **Pinning** | ✅ Pin to top | ✅ Pin Conversation Action | ✅ Pin functionality | ✅ `pinned` field in `message_threads` | ✅ isPinned property, pin/unpin actions | ✅ **ALIGNED** |
| **Snooze** | ❌ REMOVED | ❌ Not mentioned | ❌ REMOVED | ⚠️ Field/function exist but deprecated | ❌ Not found in code | ✅ **DECISION MADE** — Removed from Product Def and Screen Layouts. Backend fields deprecated but kept for compatibility. |
| **Follow-up Flags** | ❌ REMOVED | ❌ Not mentioned | ❌ REMOVED | ⚠️ Fields/function exist but deprecated | ❌ Not found in code | ✅ **DECISION MADE** — Removed from Product Def and Screen Layouts. Backend fields deprecated but kept for compatibility. |
| **Archive** | ✅ Move to archive, undo | ✅ Archive Conversation Action | ✅ Archive with undo | ✅ `archived` field, `archive-thread` function | ✅ archiveThread/unarchiveThread methods | ✅ **ALIGNED** |
| **Batch Actions** | ✅ Select multiple, bulk actions | ❌ Not explicitly mentioned | ❌ Not mentioned | ✅ Batch operations support | ✅ Batch mode with selection, batch archive/read/pin/delete | ✅ **ALIGNED** (code has more than spec) |
| **AI Message Summarisation** | ✅ Auto-summarize threads | ✅ AI Summary Card | ✅ AI summary | ✅ `ai_summary` field, `ai-summarize-thread` function | ✅ AISummaryCard component | ✅ **ALIGNED** |
| **Quick Reply Templates** | ✅ Pre-written templates, shortcuts | ✅ Quick Reply Templates Sheet | ❌ Not mentioned | ✅ `quick_replies` table | ✅ Quick reply templates in MessageComposerBar (line 274) | ✅ **ALIGNED** |
| **Canned Responses** | ✅ Library organized by category | ✅ Canned Responses Library (Settings) | ❌ Not mentioned | ✅ `canned_responses` table | ✅ CannedResponsesScreen (standalone in Settings) | ✅ **ALIGNED** |
| **Smart Reply Suggestions** | ✅ AI suggests 3 contextual replies | ✅ Smart Reply Suggestions | ✅ Smart suggestions | ❌ Not in backend spec | ✅ SmartReplySuggestionsSheet component | ✅ **ALIGNED** |
| **Rich Media Support** | ✅ Attachments, photos, voice, documents | ✅ Media Preview Modal | ✅ Media support | ✅ `media_urls` jsonb field | ✅ Verified: Message model has hasAttachment/attachmentUrl, MediaThumbnail/MediaPreviewModal integrated, attachments display in message bubbles with tap-to-preview (tested and working) | ✅ **ALIGNED** — Implemented, documented, and verified working |
| **Voice Note Player** | ✅ Inline player with waveform | ✅ VoiceNotePlayer component | ✅ Voice note preview | ❌ Not explicitly mentioned | ✅ VoiceNotePlayer component | ✅ **ALIGNED** |
| **Link Previews** | ✅ Rich previews with thumbnail | ✅ LinkPreviewCard | ✅ Link previews | ❌ Not explicitly mentioned | ✅ LinkPreviewCard component | ✅ **ALIGNED** |
| **Search & Filters** | ✅ Full-text search, filters by contact/date/channel/status/source | ✅ Message Search Screen, Filter Sheet | ✅ Search and filtering | ✅ `search_vector` tsvector, full-text search | ✅ MessageSearchScreen, ThreadSearchScreen, InboxFilterSheet | ✅ **ALIGNED** |
| **Advanced Filters** | ✅ Combine filters (e.g., "Unread WhatsApp this week") | ✅ Filter Sheet with combinations | ✅ Smart filtering | ❌ Not explicitly mentioned | ✅ InboxFilters with channel, status, date range combinations | ✅ **ALIGNED** |
| **Lead Source Tagging** | ✅ Auto-tag with marketing attribution (Google Ads/Facebook Ads/Website/Referral/Direct) | ❌ Not mentioned | ❌ Not mentioned | ✅ `lead_source` enum field (google_ads/facebook_ads/website/referral/direct) | ✅ LeadSource field in MessageThread model, distinct from message channel, UI filter supports it | ✅ **ALIGNED** — Updated to be distinct from message channels (marketing attribution vs communication platform) |
| **Typing Indicators** | ✅ Real-time typing status | ✅ TypingIndicator component | ✅ Typing indicator | ❌ Not explicitly mentioned | ✅ TypingIndicator component | ✅ **ALIGNED** |
| **Read Receipts** | ✅ Visual confirmation of delivery/read | ✅ ReadReceiptIcon component | ✅ Read receipts | ✅ `status` field (sent/delivered/read) | ✅ ReadReceiptIcon component exists | ✅ **ALIGNED** |
| **Missed-Call Integration** | ✅ Display missed calls inline | ✅ MissedCallNotification component | ✅ Inline missed call notification | ✅ `missed_calls` table, `process-missed-call`, `send-text-back` functions | ✅ MissedCallNotification component, integrated in InboxThreadScreen | ✅ **ALIGNED** — Implemented and documented in all specs |
| **Message Actions** | ✅ Reply, forward, mark read/unread, archive, delete, assign, convert | ✅ Message Actions Sheet | ✅ Context menu actions | ✅ Various edge functions | ✅ MessageActionsSheet, context menu | ✅ **ALIGNED** |
| **Scheduled Messages** | ✅ Schedule to send at specific time | ✅ Scheduled Messages Screen | ✅ Long-press send for schedule | ✅ `scheduled_messages` table, `scheduled_for` field | ✅ ScheduledMessagesScreen (full screen) | ✅ **ALIGNED** — Documented as hybrid pattern (sheet for quick schedule, full screen for management) |
| **Message Reactions** | ✅ Emoji reactions | ✅ ReactionPicker component | ✅ Tap-hold for reactions | ✅ `message_reactions` table | ✅ ReactionPicker component | ✅ **ALIGNED** |

---

## v2.5.1 Enhancements

| Feature | Product Def §3.1 | UI Inventory §1 | Screen Layouts §2 | Backend Spec §1 | Code Implementation | Decision Needed |
|---------|------------------|------------------|-------------------|-----------------|---------------------|----------------|
| **Smart Sorting** | ✅ Pinned → Unread → Recent → Archived, customizable | ❌ Not mentioned | ❌ Not mentioned | ✅ Indexes support sorting | ✅ Sorting: Pinned → Unread → Recent (lines 101-108) | ✅ **ALIGNED** (customizable order not implemented) |
| **Conversation Preview** | ✅ Long-press for preview without opening | ✅ ConversationPreviewSheet component | ✅ Preview sheet on long-press | ❌ Not mentioned | ✅ ConversationPreviewSheet, integrated in InboxScreen | ✅ **ALIGNED** — Implemented and documented |
| **Export Conversations** | ❌ REMOVED | ❌ Not mentioned | ❌ REMOVED | ❌ Not mentioned | ❌ Not found | ✅ **DECISION MADE** — Removed from Product Def and Screen Layouts. |
| **Search in Thread** | ✅ Find messages/media within thread | ❌ Not mentioned | ✅ Search in Thread | ❌ Not mentioned | ✅ ThreadSearchScreen exists | ✅ **ALIGNED** |
| **Media Compression** | ❌ REMOVED | ❌ Not mentioned | ❌ REMOVED | ❌ Not mentioned | ❌ Not found | ✅ **DECISION MADE** — Removed from Product Def and Screen Layouts. |
| **Offline Queue** | ✅ Queue when offline, auto-send when connected | ✅ Offline mode banner | ✅ Offline queue | ❌ Not explicitly mentioned | ✅ OfflineQueueManager, OfflineBanner, integrated in InboxThreadScreen | ✅ **ALIGNED** — Implemented and documented |
| **Keyboard Shortcuts (Web)** | ✅ Future: Web-only (moved to Future Features) | ❌ Not mentioned | ✅ Keyboard shortcuts documented | ❌ Not mentioned | ❌ Not found | ✅ **DECISION MADE** — Marked as future feature (post-v2.5.1) |
| **Swipe Customization** | ❌ REMOVED | ❌ Not mentioned | ❌ REMOVED | ❌ Not mentioned | ✅ Swipe actions exist (hardcoded Archive/Delete) | ✅ **DECISION MADE** — Removed from Product Def and Screen Layouts. Swipe actions work but are hardcoded (not customizable). |
| **Notification Grouping** | ✅ Group by conversation | ✅ GroupedNotificationCard component | ✅ Grouped notifications in Center tab | ❌ Not mentioned | ✅ GroupedNotificationCard, NotificationGrouping helper | ✅ **ALIGNED** — Implemented and documented |
| **Priority Inbox** | ✅ AI identifies important conversations | ✅ PriorityBadge component | ✅ Priority badge in list, priority filter, sorting | ✅ `priority` enum field in `message_threads` | ✅ PriorityBadge, priority sorting, priority filter | ✅ **ALIGNED** — Implemented and documented |

---

## Interactions

| Interaction | Product Def §3.1 | UI Inventory §1 | Screen Layouts §2 | Code Implementation | Decision Needed |
|-------------|------------------|------------------|-------------------|---------------------|----------------|
| **Tap to expand thread** | ✅ Expand to view full thread | ✅ Tap thread | ✅ Tap message | ✅ Tap opens InboxThreadScreen | ✅ **ALIGNED** |
| **Swipe actions** | ✅ Quick reply, archive, pin, delete (customizable) | ✅ SwipeAction components | ✅ Swipe gestures | ✅ Swipe actions implemented | ✅ **ALIGNED** |
| **Long-press options** | ✅ Forward, assign, add note, batch select | ✅ Context menu | ✅ Long-press menu | ✅ Context menu with options | ✅ **ALIGNED** (snooze and flag removed per decisions) |
| **Pull-to-refresh** | ✅ Sync latest messages | ✅ PullToRefresh | ✅ Pull-to-refresh | ✅ Pull-to-refresh implemented | ✅ **ALIGNED** |
| **Infinite scroll** | ✅ Load history on scroll | ❌ Not mentioned | ✅ Infinite scroll | ❌ Not explicitly mentioned | ✅ Implemented with ScrollController, pagination, loading indicator | ✅ **ALIGNED** — Implemented and documented |
| **Filter by lead source** | ✅ Filter by source | ❌ Not mentioned | ✅ Filter by source | ✅ `lead_source` enum field in `message_threads` | ✅ Lead Source filter in InboxFilterSheet, filtering logic in InboxScreen | ✅ **ALIGNED** — Implemented and documented |
| **Search with highlights** | ✅ Instant results, highlighted matches | ✅ Search Screen | ✅ Search | ✅ MessageSearchScreen exists | ✅ RichText highlighting in MessageSearchScreen and ThreadSearchScreen, matches highlighted with bold + background color | ✅ **ALIGNED** — Implemented and documented |
| **Tap-hold for reactions** | ✅ Reactions or context menu | ✅ ReactionPicker | ✅ Tap-hold reactions | ✅ ReactionPicker on long-press | ✅ **ALIGNED** |
| **Drag-select (web/tablet)** | ✅ Future: Web/tablet drag-select (moved to Future Features) | ❌ Not mentioned | ❌ Not mentioned | ❌ Not mentioned | ✅ Batch operations exist (tap/checkbox selection), drag-select not implemented | ✅ **DECISION MADE** — Marked as future feature (post-v2.5.1). Batch operations work via tap/checkbox selection. |

---

## Summary Statistics

| Category | Count | Status |
|----------|-------|--------|
| **✅ Fully Aligned** | 28 | No action needed (Rich Media Support now aligned) |
| **⚠️ Partial/Deferred** | 1 | Real-time Updates (needs backend first - deferred until backend is wired) |
| **🔴 Missing from Code** | 0 | All resolved (features either implemented, removed, or marked as future) |
| **📝 Different Implementation** | 0 | All resolved (Scheduled Messages documented as hybrid pattern) |
| **Total Features** | 39 | |

---

## Critical Decisions Needed

### High Priority (Core Features Missing)

1. ~~**Snooze**~~ — ✅ **DECISION MADE: REMOVED** from Product Definition and Screen Layouts. Backend fields deprecated but kept for compatibility.

2. ~~**Follow-up Flags**~~ — ✅ **DECISION MADE: REMOVED** from Product Definition and Screen Layouts. Backend fields deprecated but kept for compatibility.

3. ~~**Missed-Call Integration**~~ — ✅ **DECISION MADE: IMPLEMENTED** — Built and integrated into all specs and codebase.

### Medium Priority (Enhancements Missing)

4. ~~**Conversation Preview**~~ — ✅ **DECISION MADE: IMPLEMENTED** — Built and integrated into InboxScreen with long-press gesture.

5. ~~**Export Conversations**~~ — ✅ **DECISION MADE: REMOVED** from Product Definition and Screen Layouts.

6. ~~**Priority Inbox**~~ — ✅ **DECISION MADE: IMPLEMENTED** — Built priority badges, sorting, and filtering. Integrated into InboxScreen and all specs.

### Low Priority (Nice-to-Have)

7. ~~**Media Compression**~~ — ✅ **DECISION MADE: REMOVED** from Product Definition and Screen Layouts.

8. ~~**Keyboard Shortcuts (Web)**~~ — ✅ **DECISION MADE: MARKED AS FUTURE** — Moved to "Future Features (Planned for Post-v2.5.1)" section in Product Definition.

9. ~~**Notification Grouping**~~ — ✅ **DECISION MADE: IMPLEMENTED** — Built grouped notification card with expand/collapse, integrated into NotificationsScreen Center tab.

### Implementation Differences

10. ~~**Scheduled Messages**~~ — ✅ **DECISION MADE: DOCUMENT AS HYBRID** — Implementation uses both patterns:
    - **Sheet** (`ScheduleMessageSheet`) for quick scheduling when composing/editing messages
    - **Full Screen** (`ScheduledMessagesScreen`) for viewing/managing all scheduled messages
    - This is the correct UX pattern (quick action = sheet, list management = full screen)

### Verification Needed (Infrastructure Exists but Not Fully Implemented)

11. ~~**Real-time Updates**~~ — ✅ **DECISION MADE: NEEDS BACKEND FIRST** — Partial implementation:
    - Infrastructure exists: `SupabaseService.channel()` for real-time subscriptions
    - Missing: No push notification packages (e.g., `firebase_messaging`)
    - Missing: Inbox screens don't subscribe to real-time updates (use `_loadMessages()` only)
    - **Status:** Deferred until backend is wired. Current pull-based approach (`_loadMessages()`) is acceptable for MVP.

12. ~~**Rich Media Support**~~ — ✅ **DECISION MADE: IMPLEMENTED & VERIFIED** — Full implementation:
    - Components exist: `MediaThumbnail`, `MediaPreviewModal`
    - Model support: `Message` has `hasAttachment` and `attachmentUrl` fields
    - **Implementation:** `InboxThreadScreen` displays attachment thumbnails above message bubbles
    - Tap thumbnail opens `MediaPreviewModal` for full-screen viewing
    - Supports images, videos, and documents with proper labeling
    - **Status:** ✅ **COMPLETED & VERIFIED** — Implemented, integrated, and tested working

---

## Recommended Actions

### Immediate (Next Sprint)
1. ~~**Verify** all ❓ items (2 features remaining)~~ — ✅ **COMPLETED**
   - ✅ Real-time Updates — VERIFIED: Needs backend first (deferred until backend is wired)
   - ✅ Rich Media Support — VERIFIED: IMPLEMENTED (attachment display integrated in message bubbles)
2. ~~**Decide** on 1 high-priority missing feature (Missed-Call)~~ — ✅ **COMPLETED** — Missed-Call Integration implemented and documented
3. ~~**Update** Product Definition to reflect actual implementation~~ — ✅ **COMPLETED** — All specs updated (including Real-time Updates deferral note)

### Short-term (Next Month)
4. Build missing high-priority features OR remove from spec
5. Document implementation differences (e.g., Scheduled Messages screen vs sheet)

### Long-term (Future Releases)
6. Build missing enhancements based on priority
7. Align all spec documents after code changes

---

**Document Version:** 1.0  
**Next Review:** After Module 3.2 (AI Receptionist) analysis

