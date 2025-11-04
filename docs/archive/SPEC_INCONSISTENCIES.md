# Spec Inconsistencies Tracker

**Date Created:** 2025-01-XX  
**Last Updated:** 2025-01-XX  
**Status:** In Progress

This document tracks inconsistencies, conflicts, and contradictions between spec documents that need resolution before finalizing the gap analysis.

---

## Inconsistency Categories

### 1. Naming Conflicts
Different names for the same feature across spec documents.

| Feature | Product Definition | Screen Layouts | UI Inventory | Backend Spec | Current Code | Resolution Needed |
|---------|-------------------|----------------|--------------|--------------|--------------|-------------------|
| [Example] Message Thread | "Conversation Thread" | "Message Thread" | "Thread View" | `message_threads` | `thread_screen` | Standardize to "Message Thread" |

---

### 2. Contradictory Specifications
Same feature described differently in different specs.

| Feature | Spec A Says | Spec B Says | Impact | Current Implementation | Resolution |
|---------|-------------|-------------|--------|------------------------|------------|
| [Example] Email Composer | "Modal bottom sheet" | "Full screen editor" | Medium | Bottom sheet | Follow Product Definition (modal) |

---

### 3. Missing References
Feature exists in one spec but not mentioned in others where it should be.

| Feature | Present In | Missing From | Priority | Current Status | Resolution |
|---------|-----------|--------------|----------|----------------|------------|
| Tasks & Reminders | Backend Spec §8 | Product Definition, UI Inventory | High | Not implemented | Decide: Add to Product Def or remove from Backend Spec |
| [Example] Quote Variations | Product Definition | Screen Layouts, UI Inventory | Medium | Not implemented | Add to Screen Layouts or remove from Product Def |

---

### 4. Version/Date Mismatches
Different version numbers or update dates for same document.

| Document | Version | Last Updated | Expected Version | Notes |
|----------|---------|--------------|------------------|-------|
| Product Definition | v2.5.1 | 2025-11-02 | v2.5.1 | ✅ Match |
| Screen Layouts | v2.5.1 | 2025-11-02 | v2.5.1 | ✅ Match |
| UI Inventory | v2.5.1 | 2025-11-02 | v2.5.1 | ✅ Match |
| Backend Spec | v2.5.1 | 2025-11-02 | v2.5.1 | ✅ Match |

---

### 5. Scope Differences
Feature scope differs between specs.

| Feature | Product Def Scope | Screen Layouts Scope | UI Inventory Scope | Backend Spec Scope | Resolution |
|---------|------------------|----------------------|-------------------|-------------------|------------|
| [Example] Rich Text Editor | Full formatting toolbar | Basic editor | Rich text mentions | No schema | Define exact feature set |

---

### 6. Component Specification Mismatches
Component described differently across specs.

| Component | Product Def | Screen Layouts | UI Inventory | Design System | Current Code | Resolution |
|-----------|------------|----------------|--------------|---------------|--------------|------------|
| [Example] Tooltip | "Contextual help" | "Long-press tooltip" | Not mentioned | "Hover tooltip" | Not found | Define exact behavior |

---

### 7. Data Model Conflicts
Database schema vs. UI expectations mismatch.

| Feature | Backend Spec Schema | UI Inventory Data Source | Product Def Behavior | Current Code | Resolution |
|---------|-------------------|--------------------------|---------------------|--------------|------------|
| [Example] Message Reactions | `message_reactions` table | Not specified | "Emoji reactions" | Not implemented | Clarify if feature is required |

---

### 8. Navigation Structure Differences
Navigation paths differ between specs.

| Screen | Product Def Path | Screen Layouts Path | UI Inventory Path | Current Code | Resolution |
|--------|-----------------|---------------------|------------------|--------------|------------|
| [Example] Quotes List | Drawer → Quotes | Money tab → Quotes | Money tab → Quotes tab | Money tab → Quotes tab | ✅ All agree (except Product Def) |

---

## Resolution Status

### Pending Decisions
- [ ] Tasks & Reminders: Add to Product Definition or remove from Backend Spec?
- [ ] Email Composer: Modal vs full screen?
- [ ] Rich Text Editor: Full toolbar vs basic?
- [ ] [Add more as found]

### Resolved
- [ ] [Document resolved items here]

---

## Resolution Process

1. **Identify** inconsistency during per-document analysis
2. **Document** in this tracker
3. **Prioritize** based on impact (High/Medium/Low)
4. **Decide** resolution (follow one spec, merge, clarify)
5. **Update** all affected spec documents
6. **Mark** as resolved in this tracker

---

## Notes

- **High Priority:** Affects core functionality or user experience
- **Medium Priority:** Affects specific features or workflows
- **Low Priority:** Minor inconsistencies or documentation only

---

**Document Version:** 1.0  
**Last Updated:** 2025-01-XX

