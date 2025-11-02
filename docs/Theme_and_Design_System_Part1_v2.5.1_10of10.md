<!-- Split version for AI readability. Original structure preserved. -->
<!--
⚠️ IMPLEMENTATION LOCK — DO NOT DEVIATE ⚠️
Every blur, gradient, shadow, and token here is canonical.
Cursor or any developer must not simplify, replace, or ignore them.
If Material defaults conflict, override them with these values.

❌ Never:
• Replace gradients with solids
• Change opacity, blur, or shadow
• Add or remove containers not described
• Swap fonts, spacings, or elevations

✅ Always:
• Follow code samples verbatim
• Preserve FrostedContainer usage
• Keep token values identical
-->

# Swiftlead Theme & Design System – v2.5.1 Enhanced (2025-11-02)

> **v2.5.1 Enhancement:** Added comprehensive global component tokens, state-specific design tokens (loading/empty/error), micro-interaction specifications, accessibility tokens, skeleton loader patterns, toast/snackbar specifications, badge variants, and enhanced responsive behavior. Synchronized with screen layout enhancements.

> Premium Revolut × iOS Visual System with enhanced component library. Enhanced depth, gradients, shadows, and luxurious glass effects while preserving Swiftlead's teal identity.

## Purpose

Defines the visual and interactive language for the Swiftlead app across all devices.
This document establishes a single source of truth for color, typography, surfaces, motion, and component styling.
Target look: **Revolut × iOS hybrid** — clean, premium, translucent, and modern.

### 🔹 Swiftlead v2.5 Design Tokens (Revolut × iOS Hybrid)
These tokens define every parameter required to render the premium Swiftlead aesthetic.

| Category | Token | Light | Dark | Notes |
|----------|-------|-------|------|-------|
| **Primary Color** | `--color-primary` | `#00C6A2` | `#00C6A2` | Teal accent, consistent branding |
| **Secondary Accent** | `--color-accent` | `#00DDB0` | `#00DDB0` | Used in gradients & highlights |
| **Background Gradient** | `--background-gradient` | `#FFFFFF → #F6FAF8` | `#0B0D0D → #131516` | Subtle diagonal ambient gradient |
| **Surface Opacity** | `--surface-opacity` | `0.88` | `0.78` | Applied to glass layers |
| **Blur Strength (sigma)** | `--blur-strength` | `24 px` | `26 px` | For AppBar, Drawer, Cards |
| **Border Radius** | `--radius-global` | `20 px` | `20 px` | Rounded soft corners |
| **Shadow** | `--shadow` | `rgba(0,0,0,0.06)` | `rgba(0,0,0,0.25)` | Depth & elevation definition |
| **Inner Glow (dark)** | `--inner-glow` | `rgba(255,255,255,0.03)` | `rgba(255,255,255,0.04)` | Subtle reflection edge |
| **Radial Halo** | `--halo` | `rgba(0,198,162,0.05)` | `rgba(0,198,162,0.08)` | Ambient teal glow behind surfaces |
| **Typography LetterSpacing** | `--letter-tight` | `-0.2 %` | `-0.2 %` | Denser premium typography |
| **Modal Blur** | `--modal-blur` | `28 px` | `28 px` | Frosted sheet overlay |
| **Transition Duration** | `--transition-fast` | `250 ms` | `250 ms` | Button/hover animations |
| **Animation Curve** | `--curve-standard` | `easeOutQuart` | `easeOutQuart` | Smooth Apple-style transitions |

---

## 🆕 v2.5.1 Global Component Tokens

### State-Specific Component Tokens

| Component State | Token | Light Value | Dark Value | Usage |
|----------------|-------|-------------|------------|-------|
| **Loading Skeleton** | `--skeleton-base` | `rgba(0,0,0,0.08)` | `rgba(255,255,255,0.08)` | Base skeleton color |
| **Loading Skeleton** | `--skeleton-highlight` | `rgba(255,255,255,0.4)` | `rgba(255,255,255,0.15)` | Shimmer highlight |
| **Empty State** | `--empty-icon-color` | `rgba(0,0,0,0.3)` | `rgba(255,255,255,0.3)` | Empty state icon tint |
| **Empty State** | `--empty-text-color` | `rgba(0,0,0,0.6)` | `rgba(255,255,255,0.6)` | Empty state text |
| **Error State** | `--error-icon-color` | `#EF4444` | `#F87171` | Error icon color |
| **Error State** | `--error-bg` | `rgba(239,68,68,0.08)` | `rgba(248,113,113,0.12)` | Error background tint |
| **Success State** | `--success-icon-color` | `#22C55E` | `#4ADE80` | Success icon color |
| **Success State** | `--success-bg` | `rgba(34,197,94,0.08)` | `rgba(74,222,128,0.12)` | Success background tint |
| **Warning State** | `--warning-icon-color` | `#F59E0B` | `#FCD34D` | Warning icon color |
| **Warning State** | `--warning-bg` | `rgba(245,158,11,0.08)` | `rgba(252,211,77,0.12)` | Warning background tint |
| **Info State** | `--info-icon-color` | `#3B82F6` | `#60A5FA` | Info icon color |
| **Info State** | `--info-bg` | `rgba(59,130,246,0.08)` | `rgba(96,165,250,0.12)` | Info background tint |
| **Disabled State** | `--disabled-opacity` | `0.4` | `0.35` | Disabled element opacity |
| **Disabled State** | `--disabled-bg` | `rgba(0,0,0,0.04)` | `rgba(255,255,255,0.04)` | Disabled background |
| **Focus State** | `--focus-ring-color` | `#00C6A2` | `#00DDB0` | Focus ring color |
| **Focus State** | `--focus-ring-width` | `2px` | `2px` | Focus ring thickness |
| **Focus State** | `--focus-ring-offset` | `2px` | `2px` | Focus ring offset |

### Micro-Interaction Tokens

| Interaction | Token | Value | Platform | Notes |
|-------------|-------|-------|----------|-------|
| **Haptic - Light** | `--haptic-light` | Light impact | iOS/Android | Chip selection, toggle |
| **Haptic - Medium** | `--haptic-medium` | Medium impact | iOS/Android | Button tap, swipe action |
| **Haptic - Heavy** | `--haptic-heavy` | Heavy impact | iOS/Android | Destructive action confirmation |
| **Haptic - Success** | `--haptic-success` | Notification success | iOS/Android | Successful action completion |
| **Haptic - Warning** | `--haptic-warning` | Notification warning | iOS/Android | Warning or error state |
| **Animation - Press Scale** | `--press-scale` | `0.95` | All | Button press scale down |
| **Animation - Hover Scale** | `--hover-scale` | `1.02` | Web | Hover scale up |
| **Animation - Pulse** | `--pulse-duration` | `1200ms` | All | Badge/notification pulse |

### Badge Component Tokens

| Badge Variant | Background Light | Background Dark | Text Color | Size | Border Radius |
|--------------|------------------|-----------------|------------|------|---------------|
| **Count Badge** | `#EF4444` | `#DC2626` | `#FFFFFF` | 18×18px | 10px (pill) |
| **Dot Badge** | `#00C6A2` | `#00DDB0` | N/A | 8×8px | 4px (circle) |
| **Status - Success** | `#22C55E` | `#16A34A` | `#FFFFFF` | Auto | 12px |
| **Status - Warning** | `#F59E0B` | `#D97706` | `#FFFFFF` | Auto | 12px |
| **Status - Error** | `#EF4444` | `#DC2626` | `#FFFFFF` | Auto | 12px |
| **Status - Info** | `#3B82F6` | `#2563EB` | `#FFFFFF` | Auto | 12px |
| **Status - Neutral** | `rgba(0,0,0,0.08)` | `rgba(255,255,255,0.12)` | Text primary | Auto | 12px |

### Toast / Snackbar Tokens

| Toast Type | Background Light | Background Dark | Icon | Duration | Position |
|-----------|------------------|-----------------|------|----------|----------|
| **Success Toast** | `rgba(34,197,94,0.95)` with blur 24px | `rgba(22,163,74,0.90)` with blur 26px | ✓ | 3s | Bottom (60px from bottom nav) |
| **Error Toast** | `rgba(239,68,68,0.95)` with blur 24px | `rgba(220,38,38,0.90)` with blur 26px | ✕ | 4s | Bottom (60px from bottom nav) |
| **Info Toast** | `rgba(59,130,246,0.95)` with blur 24px | `rgba(37,99,235,0.90)` with blur 26px | ℹ | 3s | Bottom (60px from bottom nav) |
| **Warning Toast** | `rgba(245,158,11,0.95)` with blur 24px | `rgba(217,119,6,0.90)` with blur 26px | ⚠ | 4s | Bottom (60px from bottom nav) |
| **Action Toast** | Frosted glass with primary gradient border | Frosted glass with primary gradient border | Custom | 6s (dismissible) | Bottom (60px from bottom nav) |

**Toast Specifications:**
- Border radius: 16px
- Padding: 12px horizontal, 10px vertical
- Text: 14px, medium weight
- Shadow: 0 4px 12px rgba(0,0,0,0.15) (light) / rgba(0,0,0,0.30) (dark)
- Slide-up animation: 300ms easeOutQuart
- Dismissible: Swipe down or tap X icon
- Max width: 340px (mobile), 420px (tablet/web)
- Stacks vertically if multiple (8px gap)

### Skeleton Loader Specifications

**Base Skeleton:**
```dart
Container(
  decoration: BoxDecoration(
    color: Theme.of(context).brightness == Brightness.light
        ? const Color.fromRGBO(0, 0, 0, 0.08)
        : const Color.fromRGBO(255, 255, 255, 0.08),
    borderRadius: BorderRadius.circular(12),
  ),
)
```

**Shimmer Animation:**
```dart
AnimatedContainer(
  duration: const Duration(milliseconds: 1200),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.transparent,
        Theme.of(context).brightness == Brightness.light
            ? Colors.white.withOpacity(0.4)
            : Colors.white.withOpacity(0.15),
        Colors.transparent,
      ],
      stops: const [0.0, 0.5, 1.0],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
)
```

**Skeleton Patterns:**
- **Card Skeleton:** Rectangle with rounded corners matching card radius
- **Text Skeleton:** Lines with heights matching text size (12px/16px/20px)
- **Avatar Skeleton:** Circle (40px/48px/56px diameter)
- **Button Skeleton:** Pill shape matching button dimensions
- **Chart Skeleton:** Wavy line or bar pattern suggesting data visualization
- **Minimum Display Time:** 300ms (prevents flash on fast loads)

### Accessibility Tokens

| Property | Light Value | Dark Value | WCAG Level | Notes |
|----------|-------------|------------|------------|-------|
| **Text on Background** | `#1A1C1E` on `#F9FAFB` | `#F5F5F5` on `#0B0D0D` | AAA (8.2:1) | Body text |
| **Text on Primary** | `#FFFFFF` on `#00C6A2` | `#FFFFFF` on `#00C6A2` | AA (4.5:1) | Button text |
| **Text Secondary** | `#4B5563` on `#F9FAFB` | `#9CA3AF` on `#0B0D0D` | AA (4.8:1) | Secondary text |
| **Link Color** | `#00C6A2` on `#F9FAFB` | `#00DDB0` on `#0B0D0D` | AA (4.6:1) | Interactive links |
| **Focus Ring** | `2px solid #00C6A2` | `2px solid #00DDB0` | High contrast | Keyboard navigation |
| **Touch Target Min** | `44×44pt` | `44×44pt` | WCAG 2.5.5 | Minimum tap area |
| **Text Size Min** | `14px` | `14px` | AA | Minimum readable size |
| **Line Height Min** | `1.5` | `1.5` | AA | Minimum line spacing |
| **Reduced Motion** | Respects `prefers-reduced-motion` | Respects `prefers-reduced-motion` | WCAG 2.3.3 | Animation alternatives |

### Responsive Breakpoints & Behavior

| Breakpoint | Width Range | Layout Density | Touch Targets | Font Scale | Grid Columns |
|-----------|-------------|----------------|---------------|------------|--------------|
| **Mobile** | 0-599px | Comfortable | 44×44pt min | 100% (base) | 1 column |
| **Tablet** | 600-1023px | Comfortable | 44×44pt min | 100% | 2 columns |
| **Desktop** | 1024-1439px | Compact | 40×40pt min | 95% | 3 columns |
| **Large Desktop** | 1440px+ | Compact | 40×40pt min | 90% | 3-4 columns |

**Adaptive Behaviors:**
- **Mobile:** Single column, floating bottom nav, swipe gestures primary
- **Tablet:** Two-column hybrid, drawer always visible, hybrid touch/mouse
- **Desktop:** Multi-column grid, keyboard shortcuts enabled, hover states active, smaller touch targets acceptable
- **Density Modes:** User can override (Compact/Comfortable/Spacious) affecting padding and sizing

---

## 1. Design Philosophy

Swiftlead's design conveys trust, focus, and sophistication.
It borrows Revolut's glassmorphism and gradient light with Apple's clarity, spacing, and motion fluency.

| Principle | Description |
|-----------|-------------|
| **Depth with Restraint** | Layers use subtle transparency and blur to create hierarchy without clutter. Surfaces feel translucent, not solid. |
| **Consistency across Channels** | UI tokens remain identical across mobile, web, and tablet. |
| **Functional Elegance** | Every decorative element reinforces usability or hierarchy. Every elevation layer has either a blur, glow, or subtle gradient. |
| **Adaptive Minimalism** | Colors, spacing, and motion adapt dynamically to theme brightness. Avoid pure black or pure white—always tinted by theme gradient. |

## 2. Color System

### Primary Palette

| Role | Hex | Usage |
|------|-----|-------|
| Primary | `#14B8A6` (Teal) / Gradient `#00C6A2 → #00DDB0` | Buttons, key accents, links |
| Secondary | `#5ED1CE` (Aqua) | Highlights, gradients, badges |
| Success | `#22C55E` | Positive indicators |
| Warning | `#FACC15` | Alerts and reminders |
| Error | `#EF4444` | Critical errors |
| Info | `#3B82F6` | Secondary informational accents |

### Neutral Greys

| Name | Light | Dark |
|------|-------|------|
| Background Base | `#F9FAFB` | `#0B0D0D` |
| Surface | `#FFFFFF` (0.92 opacity) | `#131516` (0.85 opacity) |
| Text Primary | `#1A1C1E` | `#F5F5F5` |
| Text Secondary | `#4B5563` | `#9CA3AF` |
| Divider | `#E5E7EB` (light 0.08) | `#374151` (dark 0.08) |

### Gradients

| Type | Light | Dark |
|------|-------|------|
| Brand Gradient | Teal → Aqua (linear 45°) | Teal → Aqua (same, reduced opacity) |
| Ambient Background | `#FFFFFF → #F6FAF8` (2% teal hue) | `#0B0D0D → #131516` with teal-tinted vignette `rgba(10,255,230,0.03)` |
| CTA Glow | `rgba(20,184,166,0.2)` radial | `rgba(20,184,166,0.15)` radial |

### 2.1 Color & Surface Implementation

Use these colors and gradients in Flutter:

```dart
// Premium background gradient
BoxDecoration(
  gradient: LinearGradient(
    colors: [
      Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFFFFFFF)  // #FFFFFF
          : const Color(0xFF0B0D0D), // #0B0D0D
      Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF6FAF8)  // #F6FAF8 (2% teal hue)
          : const Color(0xFF131516), // #131516
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ),
)

// Add teal vignette overlay for dark mode
if (brightness == Brightness.dark)
  Container(
    decoration: BoxDecoration(
      gradient: RadialGradient(
        center: Alignment.topLeft,
        colors: [
          const Color.fromRGBO(10, 255, 230, 0.03), // Teal vignette
          Colors.transparent,
        ],
      ),
    ),
  ),

// Soft teal radial glow behind metric cards and primary buttons
BoxShadow(
  color: const Color(0xFF00C6A2).withOpacity(0.08),
  blurRadius: 48,
  spreadRadius: -8,
),
```

### 🔹 Light Theme Enhancements (Refinement Patch)

To achieve Revolut-class warmth and depth while retaining clarity:

**1️⃣ Background Tint Gradient**
Replace the base gradient `#FFFFFF → #F6FAF8` with:
`linear-gradient(135°, #F9FBFB 0%, #EEF9F8 100%)`
→ Adds subtle teal warmth and depth.

**2️⃣ Nav Bar Glass Adjustment**
Change translucent fill from `rgba(255,255,255,0.06)` → `rgba(255,255,255,0.12)`
for stronger glass separation against the bright background.

**3️⃣ Typography Tone**
Set default text color to `#1A1A1A` instead of pure black.
This reduces contrast harshness and mimics iOS typography tone.

**4️⃣ Card Sheen**
Confirm that radial highlight overlay is enabled:
`radial-gradient(40% at 85% 90%, rgba(15,214,199,0.05), transparent)`
for additional depth.

## 3. Typography

### Primary Typeface

**SF Pro Display / SF Pro Text** (fallback: Inter)

| Token | Size | Weight | Line Height | Letter-Spacing | Use |
|-------|------|--------|-------------|----------------|-----|
| Display XL | 40 | 800 | 48 | −0.5 | Dashboard stats, hero cards |
| Headline L | 28 | 700 | 34 | −0.2 | Screen titles |
| Headline M | 22 | 600 | 28 | −0.2 | Section headers |
| Headline S | 18 | 500 | 24 | −0.2 | Subsection headers |
| Body L | 16 | 400 | 24 | 0 | Paragraph text |
| Body S | 14 | 400 | 20 | 0 | Secondary text |
| Label | 13 | 500 | 16 | +0.02 (2% tracking) | Buttons, tags |
| Button Large | 17 | 600 | — | −0.2 | Primary button text |
| Caption | 12 | 500 | 14 | 0 | Sub-labels |

Letter-spacing: **−0.5** for Display XL, **−0.2** for all other headings, **+0.02** (2% tracking) for Label Medium, **0** for body.

### 3.1 Typography Implementation

Implement typography with tight kerning and consistent weights:

```dart
TextTheme(
  displayLarge: TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.5,
    height: 1.2,
  ),
  headlineLarge: TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.21,
  ),
  headlineMedium: TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    height: 1.27,
  ),
  headlineSmall: TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.2,
    height: 1.33,
  ),
  bodyLarge: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.1,
    height: 1.5,
  ),
  labelMedium: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.02, // 2% tracking
    height: 1.23,
  ),
),
```

## 4. Shape & Spacing System

| Token | Value | Usage |
|-------|-------|-------|
| Corner Radius | 20 px (cards), 16 px (buttons), 28 px (modals) | Premium rounded surfaces |
| Padding Grid | 4-pt increments (4 / 8 / 16 / 20 / 24 / 32) | Internal layout rhythm |
| Card Padding | 20 px | Standard container padding |
| Section Margin | 24 px mobile, 32 px web | |
| Elevation Levels | 0–4 dp (light), 0–2 dp (dark) | Controls shadow depth |

## 5. Surfaces & Glass Layers

### Light Mode ("Airy Glass")

| Layer | Color | Opacity | Blur | Effect |
|-------|-------|---------|------|--------|
| Base | Gradient `#FFFFFF → #F6FAF8` (2% teal hue) | 1.0 | 0 | Premium tinted backdrop |
| Card / Tile | Gradient `linear(180deg, #FFFFFF 0%, #F8FBFA 100%)` | 0.88 | 24 px | Frosted translucency with gradient fill |
| AppBar / BottomNav | `rgba(255,255,255,0.85)` | 0.85 | 26 px | Enhanced floating glass bar |
| Drawer | `#FFFFFF` | 0.88 | 22 px | Depth layer |
| Modal Sheet | `#FFFFFF` | 0.96 | 28 px | Emphasis layer |

### Dark Mode ("Matte Glass Glow")

| Layer | Color | Opacity | Blur | Effect |
|-------|-------|---------|------|--------|
| Base | Gradient `#0B0D0D → #131516` with teal vignette `rgba(10,255,230,0.03)` | 1.0 | 0 | Luxurious charcoal depth with subtle teal tint |
| Card / Tile | Gradient `linear(180deg, #141616 0%, #101111 100%)` + inner glow `rgba(255,255,255,0.04)` | 0.78 | 26 px | Subtle glass tint with sheen |
| AppBar / BottomNav | `rgba(19,21,22,0.90)` | 0.90 | 26 px | Enhanced translucent matte header |
| Drawer | `rgba(25,27,28,0.9)` | 0.9 | 26 px | Floating depth layer |
| Modal Sheet | `rgba(25,27,28,0.88)` | 0.88 | 28 px | Focused frosted overlay |

**Blur Strength:** 24 px (light) / 26 px (dark)

Borders use `rgba(255,255,255,0.05)` (dark) and `rgba(0,0,0,0.05)` (light) for glass edges. iOS separator style: 0.5 px divider line with 10% white opacity.

### 5.1 Glass / Blur Implementation

Create a reusable `FrostedContainer` widget for all translucent elements (AppBar, Drawer, Cards):

```dart
import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedContainer extends StatelessWidget {
  final Widget child;
  final double? borderRadius;
  
  const FrostedContainer({
    super.key,
    required this.child,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final radius = borderRadius ?? 20.0;
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: brightness == Brightness.light ? 24 : 26,
          sigmaY: brightness == Brightness.light ? 24 : 26,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: brightness == Brightness.light
                  ? [
                      const Color(0xFFFFFFFF),
                      const Color(0xFFF8FBFA),
                    ]
                  : [
                      const Color(0xFF141616),
                      const Color(0xFF101111),
                    ],
            ),
            color: brightness == Brightness.light
                ? Colors.white.withOpacity(0.88)
                : const Color(0xFF131516).withOpacity(0.78),
            border: Border.all(
              color: brightness == Brightness.light
                  ? Colors.black.withOpacity(0.05)
                  : Colors.white.withOpacity(0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(
                  brightness == Brightness.light ? 0.06 : 0.25,
                ),
                blurRadius: brightness == Brightness.light ? 10 : 16,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          // Inner glow for dark mode
          child: brightness == Brightness.dark
              ? Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(radius),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.04),
                      width: 2,
                    ),
                  ),
                  child: child,
                )
              : child,
        ),
      ),
    );
  }
}
```

**Usage:** All major surfaces (AppBar, Drawer, Cards, Modals) should wrap content in `FrostedContainer`.

### 5.2 Glass & Depth Parameters (Implementation Tokens)

| Property | Light Mode | Dark Mode | Applies To |
|----------|-----------|-----------|------------|
| **Glass Opacity** | 0.88 | 0.78 | Cards, modals, app bars |
| **Blur Strength (sigma)** | 24 px | 26 px | Frosted surfaces |
| **Border Color** | rgba(0,0,0,0.05) | rgba(255,255,255,0.06) | Card/surface edges |
| **Border Radius** | 20 px (cards), 16 px (buttons), 28 px (modals) | 20 px (cards), 16 px (buttons), 28 px (modals) | Premium rounded surfaces |
| **Shadow Elevation** | 0 3 10 rgba(0,0,0,0.06) blur 12 | 0 3 16 rgba(0,0,0,0.25) blur 16 | Enhanced floating surfaces |
| **Inner Glow (Dark)** | N/A | 2 px rgba(255,255,255,0.04) | Subtle sheen on dark cards |
| **Primary Glow (Accent)** | rgba(20,184,166,0.05) | rgba(20,184,166,0.08) | Buttons, highlights |
| **Ambient Gradient** | linear(135°, #FFFFFF → #F6FAF8) with 2% teal hue | linear(135°, #0B0D0D → #131516) with teal vignette rgba(10,255,230,0.03) | Premium tinted background base |
| **Radial Halo** | top-left radial teal 0.05 | top-left radial teal 0.08 | Ambient lighting |
| **Card Frost Depth** | Frosted + 24 px blur | Frosted + 26 px blur | Cards / sheets / modals |

Frosted surface opacity: 0.88 (light) / 0.78 (dark)  
Frosted blur strength: 24 px (light) / 26 px (dark)

### 5.3 Global Visual Refinements

- **Global blur consistency**: Use 24 px for standard glass, 28 px for modals, 30 px for bottom nav.
- **Soft global "hairline" shadow**: `rgba(0,0,0,0.06)` (light) / `rgba(255,255,255,0.06)` (dark) applied to all elevated surfaces.
- **Card corner radius**: 20 px (updated from 16 px for premium feel).
- **Radial highlight gradient**: Applied at bottom-right of cards and surfaces:
  - Light: `radial-gradient(40% at 85% 90%, rgba(15,214,199,0.08), transparent)`
  - Dark: Same gradient at 0.10 opacity
- **Typography letter-spacing**: −0.2 on all headings for premium compactness.
- **Safe-area bottom padding**: Content padding = nav height + 24 px.

## 6. Component Visual Tokens

| Component | Light Mode | Dark Mode |
|-----------|------------|-----------|
| AppBar | Frosted white `rgba(255,255,255,0.85)`, blur 26 px, 0.5 px divider with 10% white opacity (iOS separator) | Frosted charcoal `rgba(19,21,22,0.90)`, blur 26 px, 0.5 px divider |
| BottomNav | Translucent white bar, blur 26 px, floating illusion, soft ambient glow (teal 0.05–0.08 opacity) | Translucent matte, blur 26 px, teal icon highlight, soft ambient glow (teal 0.05–0.08 opacity) |
| Buttons – Primary | Teal gradient `#00C6A2 → #00DDB0`, white text, radius 24 px, height 52 px, letter-spacing −0.2, shadow opacity 0.15, Revolut glow `rgba(0,198,162,0.08) blur 48px spread -8px`, elevation 3, hover/press: 10% brightness reduction, spring animation 250ms easeOutQuart | Teal gradient `#00C6A2 → #00DDB0`, aqua hover glow, radius 24 px, height 52 px, letter-spacing −0.2, Revolut glow, shadow opacity 0.15, elevation 3 |
| Buttons – Secondary | Stroke 1px `rgba(0,198,162,0.35)`, transparent fill, teal text, pressed state overlay glass 6% opacity, hover/press: 10% brightness reduction | Stroke 1px `rgba(0,198,162,0.35)`, transparent fill, teal text, pressed state overlay glass 6% opacity |
| TextField | Glass background, inner shadow, radius 24 px, focus ring 2px #0FD6C7 | Frosted background, aqua focus ring 2px #0FD6C7, radius 24 px |
| Card | Gradient `linear(180deg, #FFFFFF 0%, #F8FBFA 100%)`, blur 24 px, border rgba(0,0,0,0.08) hairline, opacity 0.88, radius 20 px, shadow blur 10 px y-offset 3 px, padding 20 px, radial highlight gradient `radial-gradient(40% at 85% 90%, rgba(15,214,199,0.08), transparent)` | Gradient `linear(180deg, #141616 0%, #101111 100%)` + inner glow 2 px rgba(255,255,255,0.04), blur 26 px, border rgba(255,255,255,0.08) hairline, opacity 0.78, radius 20 px, shadow blur 16 px, radial highlight gradient at 0.10 opacity |
| Chip / Tag | Rounded 40 px pill, inactive fill rgba(0,0,0,0.03), active: stroke 1px brand teal #00C6A2, light fill overlay/glass, text weight 600, teal glow border `0 0 4 px rgba(0,198,162,0.35)` | Rounded 40 px pill, inactive fill rgba(255,255,255,0.08), active: stroke 1px brand teal, matte tint with soft glow, text weight 600 |
| Drawer | Frosted overlay + blur | Semi-opaque matte blur |
| Modals / Sheets | 28 px blur, 28 px radius, opacity 0.96 (light), backdrop blur 18 px + dim rgba(0,0,0,0.6), edge highlight 1px white@10%, comment: "Ensure modal glow feels lifted and glassy" | 28 px blur, 28 px radius, opacity 0.88 (dark), backdrop blur 18 px + dim rgba(0,0,0,0.6), edge highlight 1px black@20% |
| Icons | Line icons (SF Symbols style) | Aqua tint active state |
| **Drawer – Selected Item** | Teal tint `#14B8A6` background (0.08 opacity), bold label, icon tint teal (0.9 opacity). | Teal tint `#14B8A6` background (0.10 opacity), bold label, icon tint aqua (0.9 opacity). |
| **Hover / Pressed States** | Hover = background tint `rgba(0,0,0,0.04)`; Pressed = reduce opacity by 10%. | Hover = background tint `rgba(255,255,255,0.06)`; Pressed = reduce opacity by 10%. |
| **Icon Tint (Inactive)** | `rgba(0,0,0,0.45)` | `rgba(255,255,255,0.5)` |

---
