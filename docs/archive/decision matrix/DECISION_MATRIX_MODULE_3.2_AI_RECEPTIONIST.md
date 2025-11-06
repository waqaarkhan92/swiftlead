# Decision Matrix: Module 3.2 — AI Receptionist

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

| Feature | Product Def §3.2 | UI Inventory §2 | Screen Layouts §6 | Backend Spec §2 | Code Implementation | Decision Needed |
|---------|------------------|-----------------|-------------------|------------------|---------------------|----------------|
| **Instant Auto-Reply** | ✅ Responds within seconds (Note: Backend verification needed) | ✅ Auto-reply toggle in AI Config | ✅ Auto-reply configured | ✅ `ai-auto-reply` function, `auto_reply_enabled` field | ✅ AIConfigurationScreen has auto-reply toggle, AutoReplyTemplateEditorSheet exists | ✅ **ALIGNED** — UI exists, backend verification needed |
| **Branded Missed Call Text-Back** | ✅ Professional follow-up within 30s (Note: Backend verification needed) | ✅ Auto-reply template editor | ✅ Missed call responses configured | ✅ `send-missed-call-text` function, `missed_call_text_template` field | ✅ AutoReplyTemplateEditorSheet exists, MissedCallNotification component (from Module 3.1) | ✅ **ALIGNED** — UI exists, backend verification needed |
| **Smart FAQs** | ✅ AI-powered FAQ responses | ✅ FAQ Management Screen | ✅ FAQ Manager tile | ✅ `ai_faqs` table, `match-faq` function | ✅ FAQManagementScreen exists with full CRUD | ✅ **ALIGNED** |
| **Booking Assistance** | ✅ Offers available time slots (Note: Backend verification needed) | ✅ BookingAssistanceConfigSheet | ✅ Booking Assistant config | ✅ `booking_assistance_enabled` field, booking logic in `ai-auto-reply` | ✅ BookingAssistanceConfigSheet exists, integrated in AIConfigurationScreen | ✅ **ALIGNED** — UI exists, backend verification needed |
| **Lead Qualification** | ✅ Collects essential info before handover (Note: Backend verification needed) | ✅ LeadQualificationConfigSheet | ✅ Lead qualification config | ✅ `lead_qualification` interaction type in `ai_interactions` | ✅ LeadQualificationConfigSheet exists, integrated in AIConfigurationScreen | ✅ **ALIGNED** — UI exists, backend verification needed |
| **After-Hours Handling** | ✅ Automated responses outside business hours | ✅ After-Hours Response Editor | ✅ After-hours config | ✅ `after_hours_message` field | ✅ AfterHoursResponseEditorSheet exists (imported in AIConfigurationScreen) | ✅ **ALIGNED** |
| **AI Tone Customisation** | ✅ Formal/Friendly/Concise/Custom | ✅ AI Tone Selector Sheet | ✅ Tone Selector in config | ✅ `tone` field (formal/friendly/concise) | ✅ AIToneSelectorSheet exists, used in AIConfigurationScreen | ✅ **ALIGNED** |
| **AI Call Transcription & Summary** | ✅ Automatic transcription + AI summary | ✅ Call Transcript View | ✅ Call transcript mentioned | ✅ `call_transcriptions` table, `ai-transcribe-call` function | ✅ CallTranscriptScreen exists | ✅ **ALIGNED** |
| **Two-Way Confirmations** | ✅ Handles YES/NO confirmations (Note: Backend verification needed) | ✅ Toggle in AIConfigurationScreen | ✅ Two-way confirmations config | ⚠️ Backend logic implied in `ai-auto-reply` | ✅ Toggle exists in AIConfigurationScreen | ✅ **ALIGNED** — UI exists, backend verification needed |
| **Smart Handover** | ✅ Transfers with full context (Note: Backend verification needed) | ✅ SmartHandoverConfigSheet | ✅ Smart handover config | ✅ `handover_triggered` field in `ai_interactions` | ✅ SmartHandoverConfigSheet exists, integrated in AIConfigurationScreen | ✅ **ALIGNED** — UI exists, backend verification needed |
| **Interaction Logging** | ✅ Records all AI interactions | ✅ AI Interactions List | ✅ AI Activity Log | ✅ `ai_interactions` table | ✅ AIActivityLogScreen exists | ✅ **ALIGNED** |
| **Multi-Language Support** | ✅ Detects client language (Note: Backend verification needed) | ✅ MultiLanguageConfigSheet | ✅ Multi-language config | ✅ `supported_languages` field, `language_detected` in interactions | ✅ MultiLanguageConfigSheet exists, integrated in AIConfigurationScreen | ✅ **ALIGNED** — UI exists, backend verification needed |
| **Confidence Scoring** | ✅ AI reports confidence per response (Note: Backend verification needed) | ✅ ConfidenceThresholdConfigSheet | ✅ Confidence threshold config | ✅ `confidence_score` field in `ai_interactions`, `min_confidence_threshold` in config | ✅ ConfidenceThresholdConfigSheet exists, integrated in AIConfigurationScreen | ✅ **ALIGNED** — UI exists, backend verification needed |

---

## v2.5.1 Enhancements

| Feature | Product Def §3.2 | UI Inventory §2 | Screen Layouts §6 | Backend Spec §2 | Code Implementation | Decision Needed |
|---------|------------------|-----------------|-------------------|------------------|---------------------|----------------|
| **Conversation Examples** | ✅ Preview scenarios before live | ✅ AI Response Preview | ✅ Conversation Examples enhancement | ✅ `ai_test_conversations` table | ⚠️ AIReceptionistThread exists for simulation, but test scenarios UI not found | ❓ **VERIFY** — Component exists, but test scenarios feature needs verification |
| **Custom Response Override** | ✅ Set responses for keywords/phrases (Note: Backend verification needed) | ✅ CustomResponseOverrideSheet | ✅ Custom Responses override | ✅ `escalation_keywords` field in config | ✅ CustomResponseOverrideSheet exists, integrated in AIConfigurationScreen | ✅ **ALIGNED** — UI exists, backend verification needed |
| **Escalation Rules** | ✅ Smart handover based on sentiment/complexity (Note: Backend verification needed) | ✅ EscalationRulesConfigSheet | ✅ Escalation rules config | ✅ `escalation_keywords` field, `escalation_reason` in interactions | ✅ EscalationRulesConfigSheet exists, integrated in AIConfigurationScreen | ✅ **ALIGNED** — UI exists, backend verification needed |
| **AI Performance Analytics** | ✅ Track response time, qualification rate, booking conversion | ✅ AI Performance Metrics Screen | ✅ AIPerformanceMetrics dashboard | ✅ `ai_performance_metrics` table, `get-ai-performance` function | ✅ AIPerformanceScreen exists | ✅ **ALIGNED** |
| **Test Mode** | ✅ Test in sandbox before enabling | ✅ AI Training Mode | ✅ Test Mode mentioned | ✅ `test_mode` field in `ai_config` | ✅ AITrainingModeScreen exists | ✅ **ALIGNED** |
| **Fallback Responses** | ✅ Graceful handling when uncertain (Note: Backend verification needed) | ✅ FallbackResponseConfigSheet | ✅ Fallback response config | ✅ `fallback_response` field in `ai_config` | ✅ FallbackResponseConfigSheet exists, integrated in AIConfigurationScreen | ✅ **ALIGNED** — UI exists, backend verification needed |
| **Context Retention** | ✅ AI remembers previous conversations (Note: Backend verification needed) | ✅ Toggle in AIConfigurationScreen | ✅ Context retention config | ✅ `context_retained` field in `ai_interactions` | ✅ Toggle exists in AIConfigurationScreen | ✅ **ALIGNED** — UI exists, backend verification needed |

---

## Configuration & Settings

| Feature | Product Def §3.2 | UI Inventory §2 | Screen Layouts §6 | Backend Spec §2 | Code Implementation | Decision Needed |
|---------|------------------|-----------------|-------------------|------------------|---------------------|----------------|
| **Business Hours Config** | ✅ Set active times | ✅ Business Hours Editor | ✅ Business hours config | ✅ `business_hours` jsonb field | ✅ BusinessHoursEditorSheet exists (imported in AIConfigurationScreen) | ✅ **ALIGNED** |
| **Response Delay** | ✅ Configure delay (0s/30s/60s) (Note: Backend verification needed) | ✅ ResponseDelayConfigSheet | ✅ Response delay config | ✅ `response_delay_seconds` field | ✅ ResponseDelayConfigSheet exists, integrated in AIConfigurationScreen | ✅ **ALIGNED** — UI exists, backend verification needed |

---

## Summary Statistics

| Category | Count | Status |
|----------|-------|--------|
| **✅ Fully Aligned** | 20 | AI Tone, After-Hours, Call Transcription, Interaction Logging, Performance Analytics, Test Mode, Business Hours, FAQs, Booking Assistance, Lead Qualification, Smart Handover, Two-Way Confirmations, Multi-Language, Confidence Scoring, Response Delay, Fallback Responses, Context Retention, Custom Response Override, Escalation Rules, Instant Auto-Reply, Missed Call Text-Back |
| **⚠️ Partial/Needs Backend** | 20 | All features have UI implemented, but need backend verification once backend is wired |
| **🔴 Missing from Code** | 0 | All features have UI implementation |
| **📝 Removed from Specs** | 6 | A/B Testing, Learning Dashboard, Manual Override, Response Templates Library, Conversation Examples (test scenarios), Per-Channel Enable/Disable |

---

## Critical Decisions Needed

### High Priority (Core Features)

1. **Instant Auto-Reply** — ❓ **NEEDS DECISION**
   - UI exists: AIConfigurationScreen toggle, AutoReplyTemplateEditorSheet
   - Backend: `ai-auto-reply` function exists
   - Missing: Backend integration verification (needs backend wired)
   - **Options:**
     - A) Mark as "needs backend first" (deferred until backend is wired)
     - B) Keep UI as-is, document backend integration needed
     - C) Remove from spec if not needed

2. **Branded Missed Call Text-Back** — ❓ **NEEDS DECISION**
   - UI exists: AutoReplyTemplateEditorSheet
   - Backend: `send-missed-call-text` function exists
   - Missing: Automatic trigger verification (needs backend wired)
   - **Options:**
     - A) Mark as "needs backend first" (deferred until backend is wired)
     - B) Keep UI as-is, document backend integration needed
     - C) Remove from spec if not needed

### Medium Priority (Core Features Missing UI)

3. **Booking Assistance** — ❓ **NEEDS DECISION**
   - Backend: `booking_assistance_enabled` field exists
   - Missing: UI/flow not found in code
   - **Options:**
     - A) Build UI for booking assistance configuration and flow
     - B) Mark as "needs backend first" (deferred until backend is wired)
     - C) Remove from spec if not needed

4. **Lead Qualification** — ❓ **NEEDS DECISION**
   - Backend: `lead_qualification` interaction type exists
   - Missing: UI/flow not found in code
   - **Options:**
     - A) Build UI for lead qualification flow
     - B) Mark as "needs backend first" (deferred until backend is wired)
     - C) Remove from spec if not needed

5. **Smart Handover** — ❓ **NEEDS DECISION**
   - Backend: `handover_triggered` field exists
   - Missing: UI/flow not found in code
   - **Options:**
     - A) Build UI for handover configuration and flow
     - B) Mark as "needs backend first" (deferred until backend is wired)
     - C) Remove from spec if not needed

### Low Priority (Enhancements Missing)

6. **Two-Way Confirmations** — ❓ **NEEDS DECISION**
   - Backend: Logic implied in `ai-auto-reply`
   - Missing: Explicit UI/flow not found
   - **Options:**
     - A) Build UI for two-way confirmation handling
     - B) Mark as "handled by backend automatically" (no UI needed)
     - C) Remove from spec if not needed

7. **Multi-Language Support** — ❓ **NEEDS DECISION**
   - Backend: `supported_languages` field, `language_detected` in interactions
   - Missing: UI for language configuration/display
   - **Options:**
     - A) Build UI for language selection and display
     - B) Mark as "needs backend first" (deferred until backend is wired)
     - C) Remove from spec if not needed

8. **Confidence Scoring** — ❓ **NEEDS DECISION**
   - Backend: `confidence_score` field, `min_confidence_threshold` in config
   - Missing: UI display of confidence scores
   - **Options:**
     - A) Build UI to display confidence scores in interactions/performance
     - B) Mark as "needs backend first" (deferred until backend is wired)
     - C) Remove from spec if not needed

9. **Response Delay** — ❓ **NEEDS DECISION**
   - Backend: `response_delay_seconds` field exists
   - Missing: UI for delay configuration
   - **Options:**
     - A) Build UI for response delay configuration
     - B) Mark as "needs backend first" (deferred until backend is wired)
     - C) Remove from spec if not needed

10. **Enable/Disable Per Channel** — ❓ **NEEDS DECISION**
    - Spec mentions per-channel configuration
    - Backend: Per-org config (not per-channel)
    - Missing: UI for per-channel configuration
    - **Options:**
      - A) Build UI for per-channel enable/disable
      - B) Mark as "not needed - per-org config is sufficient"
      - C) Remove from spec if not needed

### v2.5.1 Enhancements Missing

11. **A/B Testing** — ❓ **NEEDS DECISION**
    - Spec mentions A/B testing
    - Missing: Backend support and UI
    - **Options:**
      - A) Build A/B testing feature
      - B) Mark as "future feature"
      - C) Remove from spec if not needed

12. **Custom Response Override** — ❓ **NEEDS DECISION**
    - Backend: `escalation_keywords` field exists
    - Missing: UI for keyword/response override configuration
    - **Options:**
      - A) Build UI for custom response overrides
      - B) Mark as "needs backend first" (deferred until backend is wired)
      - C) Remove from spec if not needed

13. **Escalation Rules** — ❓ **NEEDS DECISION**
    - Backend: `escalation_keywords` field, `escalation_reason` in interactions
    - Missing: UI for escalation rules configuration
    - **Options:**
      - A) Build UI for escalation rules configuration
      - B) Mark as "needs backend first" (deferred until backend is wired)
      - C) Remove from spec if not needed

14. **Learning Dashboard** — ❓ **NEEDS DECISION**
    - Spec mentions learning dashboard
    - Missing: Backend support and UI
    - **Options:**
      - A) Build learning dashboard
      - B) Mark as "future feature"
      - C) Remove from spec if not needed

15. **Manual Override** — ❓ **NEEDS DECISION**
    - Spec mentions manual override
    - Missing: Backend support and UI
    - **Options:**
      - A) Build manual override feature
      - B) Mark as "future feature"
      - C) Remove from spec if not needed

16. **Response Templates Library** — ❓ **NEEDS DECISION**
    - Spec mentions templates library
    - Missing: Backend support and UI
    - **Options:**
      - A) Build templates library
      - B) Mark as "future feature"
      - C) Remove from spec if not needed

17. **Fallback Responses** — ❓ **NEEDS DECISION**
    - Backend: `fallback_response` field exists
    - Missing: UI for fallback response configuration
    - **Options:**
      - A) Build UI for fallback response configuration
      - B) Mark as "needs backend first" (deferred until backend is wired)
      - C) Remove from spec if not needed

18. **Context Retention** — ❓ **NEEDS DECISION**
    - Backend: `context_retained` field exists
    - Missing: UI for context retention display/configuration
    - **Options:**
      - A) Build UI for context retention
      - B) Mark as "handled by backend automatically" (no UI needed)
      - C) Remove from spec if not needed

19. **Conversation Examples** — ❓ **NEEDS DECISION**
    - Backend: `ai_test_conversations` table exists
    - Missing: UI for managing test scenarios
    - **Options:**
      - A) Build UI for test conversation management
      - B) Mark as "needs backend first" (deferred until backend is wired)
      - C) Remove from spec if not needed

---

## Recommended Actions

### Immediate (Next Sprint)
1. **Verify** all ❓ items (19 features) to confirm implementation status
2. **Decide** on high-priority missing features (Auto-Reply, Missed Call Text-Back, Booking Assistance, Lead Qualification, Smart Handover)
3. **Update** Product Definition to reflect actual implementation (remove or mark as "planned")

### Short-term (Next Month)
4. Build missing high-priority features OR remove from spec
5. Document implementation differences

### Long-term (Future Releases)
6. Build missing enhancements based on priority
7. Align all spec documents after code changes

---

**Document Version:** 1.0  
**Next Review:** After decisions are made

