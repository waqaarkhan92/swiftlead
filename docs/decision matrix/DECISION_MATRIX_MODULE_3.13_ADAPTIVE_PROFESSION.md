# Decision Matrix: Module 3.13 — Adaptive Profession System

**Date:** 2025-11-05  
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

| Feature | Product Def §3.13 | UI Inventory | Screen Layouts | Backend Spec | Code Implementation | Decision Needed |
|---------|-------------------|--------------|----------------|--------------|---------------------|----------------|
| **Profession Selection** | ✅ Trades, Home Services, Professional Services, Auto Services, Custom | ✅ Profession Selector | ✅ Onboarding profession selection | ✅ `industry_profiles` table | ✅ Profession selection in OnboardingScreen | ✅ **KEEP IN ONBOARDING** — Already implemented |
| **Adaptive Terminology** | ✅ Jobs vs Appointments, Clients vs Customers vs Patients, Quotes vs Estimates, Invoices vs Bills | ✅ Terminology mapping | ✅ Label overrides | ✅ `industry_profiles.label_overrides` | ❌ Not found in code | ✅ **KEEP** — To be implemented |
| **Module Visibility** | ✅ Show/hide features per profession | ✅ Module visibility | ✅ Module toggles | ✅ `industry_profiles.visible_modules` | ❌ Not found in code | ✅ **KEEP** — To be implemented |
| **Custom Fields** | ✅ Pre-configured fields per profession (License #, Insurance, etc.) | ✅ Custom Fields Manager | ✅ Custom fields | ✅ `custom_fields` table | ✅ CustomFieldsManagerScreen exists | ✅ **ALIGNED** (profession-specific defaults to be added) |
| **Workflow Defaults** | ✅ Booking duration, payment terms, quote expiry, reminder timing | ❌ Not mentioned | ❌ Not mentioned | ✅ Default settings per profession | ❌ Not found in code | ✅ **KEEP** — To be implemented |
| **Template Library** | ✅ Email templates, message templates per profession | ✅ Template system | ✅ Templates | ✅ Template system | ⚠️ Templates exist but profession-specific may need verification | ✅ **KEEP** — Profession-specific templates to be added |

---

## v2.5.1 Enhancements

| Feature | Product Def §3.13 | UI Inventory | Screen Layouts | Backend Spec | Code Implementation | Decision Needed |
|---------|-------------------|--------------|----------------|--------------|---------------------|----------------|
| **Smart Recommendations** | ✅ AI suggests optimal settings based on profession | ❌ Not mentioned | ❌ Not mentioned | ❌ Not mentioned | ❌ Not found in code | ❓ **DECISION NEEDED** — Is this a future feature? |
| **Industry Benchmarks** | ✅ Compare performance to industry averages | ❌ Not mentioned | ❌ Not mentioned | ❌ Not mentioned | ❌ Not found in code | ❓ **DECISION NEEDED** — Is this a future feature? |
| **Multi-Profession Support** | ✅ Manage multiple service types in one account | ❌ Not mentioned | ❌ Not mentioned | ✅ Multiple profession support | ❌ Not found in code | ❓ **DECISION NEEDED** — Is multi-profession a future feature? |
| **Clone Configuration** | ✅ Duplicate settings for franchise/multi-location | ❌ Not mentioned | ❌ Not mentioned | ❌ Not mentioned | ❌ Not found in code | ❓ **DECISION NEEDED** — Is clone configuration a future feature? |

---

## Summary Statistics

| Category | Count | Status |
|----------|-------|--------|
| **✅ Fully Aligned** | 2 | Profession selection (in Onboarding) and custom fields |
| **⚠️ Partial/Deferred** | 6 | Adaptive Terminology, Module Visibility, Service Type Templates, Custom Field Templates, Invoice Templates, Workflow Defaults, Template Library |
| **🔴 Missing from Code** | 0 | All features decided |
| **📝 Different Implementation** | 0 | - |
| **❓ Needs Verification** | 4 | Smart Recommendations, Industry Benchmarks, Multi-Profession Support, Clone Configuration |
| **Total Features** | 12 | (10 core + 2 from questionnaire) |

---

## User Decisions (2025-11-05)

### Batch 7: Adaptive Profession Decisions

1. **Profession Selection** — ✅ **KEEP IN ONBOARDING**
   - Decision: Profession selection already implemented in OnboardingScreen
   - Status: ✅ Confirmed in Onboarding (Step 2)

2. **Dynamic Labeling (Adaptive Terminology)** — ✅ **KEEP**
   - Decision: Implement dynamic terminology based on profession
   - Action: Apply label overrides throughout UI (Job → Appointment, Client → Patient, etc.)

3. **Module Visibility** — ✅ **KEEP**
   - Decision: Implement configurable module visibility per profession
   - Action: Show/hide modules based on profession selection

4. **Service Type Templates** — ✅ **KEEP**
   - Decision: Add profession-specific service type templates
   - Action: Pre-configure service types per profession (e.g., plumbing services for Trade, haircuts for Salon)

5. **Custom Field Templates** — ✅ **KEEP**
   - Decision: Add profession-specific custom field templates
   - Action: Pre-configure custom fields per profession (License # for Trade, etc.)

6. **Invoice Template Customization (Profession-Specific)** — ✅ **KEEP**
   - Decision: Make invoice templates profession-specific
   - Action: Add profession-specific invoice templates to InvoiceCustomizationScreen

7. **Workflow Defaults** — ✅ **KEEP**
   - Decision: Implement profession-specific workflow defaults
   - Action: Set default booking duration, payment terms, quote expiry, reminder timing per profession

8. **Template Library (Profession-Specific)** — ✅ **KEEP**
   - Decision: Make templates profession-specific
   - Action: Ensure email and message templates are profession-specific

### Low Priority (Nice-to-Have)

5. **Smart Recommendations** — ❓ **DECISION NEEDED**
   - Product Def v2.5.1 enhancement specifies AI-suggested settings
   - **Decision Needed:** Is this a future feature?

6. **Industry Benchmarks** — ❓ **DECISION NEEDED**
   - Product Def v2.5.1 enhancement specifies performance comparison
   - **Decision Needed:** Is this a future feature?

7. **Multi-Profession Support** — ❓ **DECISION NEEDED**
   - Product Def v2.5.1 enhancement specifies multiple service types
   - **Decision Needed:** Is this a future feature or should it be implemented now?

---

## Implementation Actions

### Immediate (Next Sprint)
1. ⏳ **Implement Adaptive Terminology** - Apply label overrides throughout UI based on profession
2. ⏳ **Implement Module Visibility** - Show/hide modules based on profession selection
3. ⏳ **Add Service Type Templates** - Pre-configure service types per profession
4. ⏳ **Add Custom Field Templates** - Pre-configure custom fields per profession
5. ⏳ **Make Invoice Templates Profession-Specific** - Add profession-specific invoice templates
6. ⏳ **Implement Workflow Defaults** - Set profession-specific defaults for booking duration, payment terms, etc.
7. ⏳ **Make Template Library Profession-Specific** - Ensure email and message templates are profession-specific

### Pending Decisions (v2.5.1 Enhancements)
8. **Smart Recommendations** — ❓ Decision needed (future feature?)
9. **Industry Benchmarks** — ❓ Decision needed (future feature?)
10. **Multi-Profession Support** — ❓ Decision needed (future feature?)
11. **Clone Configuration** — ❓ Decision needed (future feature?)

---

**Document Version:** 1.0  
**Next Review:** After Module 3.14 (Onboarding) analysis
