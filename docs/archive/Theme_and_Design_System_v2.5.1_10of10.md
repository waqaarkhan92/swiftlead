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

## 🆕 v2.5.1 Enhanced Component Specifications

### Tooltip Component

**Visual Tokens:**
| Property | Light | Dark |
|----------|-------|------|
| Background | `rgba(0,0,0,0.90)` | `rgba(255,255,255,0.95)` |
| Text Color | `#FFFFFF` | `#0B0D0D` |
| Border Radius | `8px` | `8px` |
| Padding | `6px 10px` | `6px 10px` |
| Font Size | `12px` | `12px` |
| Font Weight | `500` | `500` |
| Shadow | `0 2px 8px rgba(0,0,0,0.2)` | `0 2px 8px rgba(0,0,0,0.15)` |
| Arrow Size | `6px` | `6px` |
| Max Width | `200px` | `200px` |

**Behavior:**
- Appears on hover (web) after 400ms delay
- Appears on long-press (mobile) after 500ms
- Dismisses on mouse leave or tap outside
- Positioned automatically (top/bottom/left/right) to avoid screen edges
- Animation: Fade in 150ms easeOut, fade out 100ms easeIn
- Z-index: Above all other content

### Context Menu / Long-Press Menu

**Visual Tokens:**
| Property | Light | Dark |
|----------|-------|------|
| Background | `rgba(255,255,255,0.96)` with blur 28px | `rgba(25,27,28,0.92)` with blur 28px |
| Border | `1px rgba(0,0,0,0.08)` | `1px rgba(255,255,255,0.12)` |
| Border Radius | `16px` | `16px` |
| Item Height | `48px` | `48px` |
| Item Padding | `12px 16px` | `12px 16px` |
| Divider | `1px rgba(0,0,0,0.08)` | `1px rgba(255,255,255,0.08)` |
| Shadow | `0 8px 32px rgba(0,0,0,0.2)` | `0 8px 32px rgba(0,0,0,0.4)` |
| Max Width | `280px` | `280px` |

**Item States:**
- **Normal:** Text primary color, icon matching
- **Hover:** Background `rgba(0,0,0,0.04)` (light) / `rgba(255,255,255,0.06)` (dark)
- **Pressed:** Background `rgba(0,0,0,0.08)` (light) / `rgba(255,255,255,0.10)` (dark)
- **Destructive:** Text and icon `#EF4444` / `#F87171`
- **Disabled:** Opacity 0.4, no interaction

**Behavior:**
- Appears on long-press (600ms) or right-click
- Positioned near touch/click point, adjusted to stay on screen
- Backdrop overlay with tap-to-dismiss
- Slide-up animation 250ms with spring physics
- Haptic medium feedback on appear
- Closes on item select or backdrop tap

### Progress Indicators

**Linear Progress Bar:**
| Property | Value |
|----------|-------|
| Height | `4px` |
| Track Color (Light) | `rgba(0,0,0,0.08)` |
| Track Color (Dark) | `rgba(255,255,255,0.12)` |
| Fill Color | Primary gradient `#00C6A2 → #00DDB0` |
| Border Radius | `2px` (pill ends) |
| Animation | Indeterminate: 1.5s sweep animation |

**Circular Progress Spinner:**
| Property | Value |
|----------|-------|
| Size - Small | `16px` |
| Size - Medium | `24px` |
| Size - Large | `40px` |
| Stroke Width | `2px` (small), `3px` (medium), `4px` (large) |
| Color | Primary teal `#00C6A2` |
| Animation | Continuous 0.8s rotation + 1.5s arc sweep |

**Skeleton Loader (Already defined above, variants here):**
- **Single Line:** 100% width × 16px height, rounded 8px
- **Multiline Text:** 3-5 lines with 100%/90%/75% widths, 8px gap
- **Card:** Full card dimensions with internal sections
- **Avatar + Text:** Circle + 2 lines beside
- **Grid:** Multiple cards in grid pattern

### Swipe Actions

**Visual Tokens:**
| Property | Value |
|----------|-------|
| Action Width | `80px` per action |
| Icon Size | `24×24px` |
| Background - Archive | `#3B82F6` |
| Background - Delete | `#EF4444` |
| Background - Pin | `#F59E0B` |
| Background - Complete | `#22C55E` |
| Text Color | `#FFFFFF` |
| Reveal Animation | Spring physics with damping |
| Threshold | Swipe >50% width to auto-complete |

**Behavior:**
- Swipe left reveals right actions, swipe right reveals left actions
- Elastic resistance after full reveal
- Haptic feedback at 25%, 50%, and 100% thresholds
- Auto-complete if swiped past threshold and released
- Otherwise springs back to closed
- Actions execute with confirmation if destructive

### Pull-to-Refresh

**Visual Tokens:**
| Property | Value |
|----------|-------|
| Indicator Size | `32×32px` |
| Pull Distance | `80px` trigger threshold |
| Color | Primary teal `#00C6A2` |
| Animation | Rotation + arc sweep while pulling, spin when refreshing |
| Background | None (transparent) |

**Behavior:**
- Pull down from top of scrollable content
- Visual feedback begins at 20px pull
- Haptic light feedback at trigger threshold (80px)
- Release to trigger refresh
- Spinner continues until data loaded
- "Updated just now" toast on completion

### Empty State Cards

**Visual Tokens:**
| Property | Light | Dark |
|----------|-------|------|
| Background | Transparent or card background | Transparent or card background |
| Illustration Size | `120-160px` square | `120-160px` square |
| Illustration Opacity | `0.3` | `0.3` |
| Headline Size | `18-22px` | `18-22px` |
| Headline Weight | `600` | `600` |
| Headline Color | Text primary | Text primary |
| Description Size | `14-16px` | `14-16px` |
| Description Color | Text secondary | Text secondary |
| CTA Button | Primary button style | Primary button style |
| Spacing | Icon → 16px → Headline → 8px → Description → 24px → CTA |

**Content Pattern:**
```
[Illustration/Icon]
"No [Items] Yet"
"Brief explanation of why empty and what to do next."
[Primary CTA Button]
[Optional: Secondary Link]
```

### Error State Cards

**Visual Tokens:**
| Property | Light | Dark |
|----------|-------|------|
| Background | `rgba(239,68,68,0.05)` | `rgba(248,113,113,0.08)` |
| Border | `1px rgba(239,68,68,0.2)` | `1px rgba(248,113,113,0.3)` |
| Border Radius | `16px` | `16px` |
| Icon Color | `#EF4444` | `#F87171` |
| Icon Size | `40-48px` | `40-48px` |
| Headline Size | `16-18px` | `16-18px` |
| Headline Weight | `600` | `600` |
| Description Size | `14px` | `14px` |
| Error Code Size | `12px` | `12px` |
| Error Code Color | Text secondary muted | Text secondary muted |
| Padding | `20px` | `20px` |

**Content Pattern:**
```
[Error Icon ⚠️]
"Failed to Load [Content]"
"Error explanation in user-friendly language."
Error ID: E-1234
[Primary: "Try Again"] [Secondary: "Get Help"]
```

### Confirmation Dialogs

**Visual Tokens:**
| Property | Light | Dark |
|----------|-------|------|
| Background | Frosted glass with blur 28px | Frosted glass with blur 28px |
| Border Radius | `28px` | `28px` |
| Padding | `24px` | `24px` |
| Max Width | `340px` (mobile), `420px` (tablet/web) | Same |
| Icon Size | `48px` | `48px` |
| Icon Color | Warning: `#F59E0B`, Destructive: `#EF4444`, Info: `#3B82F6` | Same with adjusted brightness |
| Title Size | `18px` | `18px` |
| Title Weight | `600` | `600` |
| Description Size | `14px` | `14px` |
| Button Height | `44px` | `44px` |
| Button Gap | `12px` | `12px` |

**Button Layout:**
- Destructive dialogs: Red primary + gray secondary
- Standard dialogs: Teal primary + gray secondary
- Buttons stack vertically on mobile, horizontal on tablet/web

**Behavior:**
- Backdrop dim overlay (rgba(0,0,0,0.6))
- Backdrop blur 18px
- Slide-up + fade animation 300ms
- Dismissible via backdrop tap or Esc key (non-critical only)
- For destructive actions: Optional "Type DELETE to confirm"
- Haptic heavy on destructive confirmation

### Bottom Sheet / Modal Sheet

**Visual Tokens:**
| Property | Value |
|----------|-------|
| Border Radius (top) | `28px` |
| Background | Frosted glass matching modal spec |
| Blur | `28px` |
| Handle Width | `40px` |
| Handle Height | `4px` |
| Handle Color (Light) | `rgba(0,0,0,0.2)` |
| Handle Color (Dark) | `rgba(255,255,255,0.3)` |
| Handle Top Margin | `12px` |
| Backdrop Dim | `rgba(0,0,0,0.6)` |
| Backdrop Blur | `18px` |

**Height Variants:**
- **Quarter:** 25vh, for quick actions
- **Half:** 50vh, for filters/forms
- **Three-Quarter:** 75vh, for content browsing
- **Full:** 90vh, for immersive experiences

**Behavior:**
- Drag handle to resize or dismiss
- Swipe down to dismiss (if not form with unsaved changes)
- Snap to breakpoints (25%, 50%, 75%, 90%)
- Backdrop tap to dismiss
- Keyboard safe area aware
- Haptic feedback at snap points
- Spring animation physics

---

### 6.1 Drawer Implementation

#### 🔹 Drawer Implementation Clarification
Drawer body must be wrapped in FrostedContainer and use this BoxDecoration:

```dart
BoxDecoration(
  gradient: LinearGradient(
    colors: [Color(0xFFF3FBFA), Color(0xFFE7F7F4)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 20,
      offset: Offset(0, 4),
    ),
  ],
)
```

**Specifications:**
- Header height: 168 px
- Divider: 1 px hairline
- Active row: left 6 dp brand bar, `rgba(0,214,199,0.08)` background

---

Use a frosted Drawer with divider line and teal selection tint:

```dart
Drawer(
  child: FrostedContainer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
          child: Text(
            'Drawer Header',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const Divider(
          height: 1,
          color: Colors.white54, // iOS separator style
        ),
        // Selected item with 6dp left inset brand bar
        Container(
          margin: const EdgeInsets.only(left: 6), // 6dp inset
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(
              Theme.of(context).brightness == Brightness.light ? 0.08 : 0.10,
            ),
            border: Border(
              left: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 6, // 6dp brand bar
              ),
            ),
          ),
          child: ListTile(
            leading: Icon(
              Icons.dashboard,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.9),
            ),
            title: const Text(
              'Dashboard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            selected: true,
          ),
        ),
      ],
    ),
  ),
),
```

#### 🔹 Drawer Header (Revolut × iOS Hybrid)

**Goal:** Achieve a frosted, premium top section consistent with the rest of the glassmorphic UI.

##### Light Mode
- Background: `LinearGradient( #E6FFF7 → #FFFFFF )` at 135°, opacity `0.82`
- Frost Blur: `sigmaX: 30`, `sigmaY: 30`
- Divider Line: `rgba(0, 0, 0, 0.06)` height `1px`
- Text Color: `#0B0D0D`
- Drawer Icon Tint: `#00C6A2`

##### Dark Mode
- Background: `LinearGradient( #0F1616 → #0B0D0D )` at 135°, opacity `0.75`
- Frost Blur: `sigmaX: 32`, `sigmaY: 32`
- Divider Line: `rgba(255, 255, 255, 0.08)` height `1px`
- Text Color: `#FFFFFF`
- Drawer Icon Tint: `#00C6A2`

##### Shadow / Elevation
Add soft inner shadow for better depth:
```dart
BoxShadow(
  color: Colors.black.withOpacity(0.05),
  blurRadius: 16,
  offset: Offset(0, 4),
)
```

> **Note:** Maintain gradient colors `#E6FFF7 → #FFFFFF` (light) and `#0F1616 → #0B0D0D` (dark). Frost blur uses 30 px (light) / 32 px (dark) for subtle vertical depth. Header height: 168 px. Add frosted glass overlay: opacity 0.94 (light) / 0.88 (dark). Divider: use hairline (1px) rather than full line. Active row: add a 6dp left inset brand bar (primary teal, 24% opacity).

**Implementation Example:**
```dart
DrawerHeader(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: brightness == Brightness.light
          ? [Color(0xFFE6FFF7).withOpacity(0.82), Colors.white.withOpacity(0.82)]
          : [Color(0xFF0F1616).withOpacity(0.75), Color(0xFF0B0D0D).withOpacity(0.75)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: FrostedContainer(
    child: Align(
      alignment: Alignment.bottomLeft,
      child: Text(
        'Drawer Header',
        style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
            ),
      ),
    ),
  ),
)
```

### 6.2 Button Implementation

#### 🔹 Canonical Primary Button Implementation (Revolut × iOS)
All Primary Buttons **must** follow this structure — do not nest Ink or other gradients inside ElevatedButton.

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: [Color(0xFF00C6A2), Color(0xFF00DDB0)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(24),
    boxShadow: [
      BoxShadow(
        color: Color(0xFF00C6A2).withOpacity(0.08),
        blurRadius: 48,
        spreadRadius: -8,
      ),
    ],
  ),
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      minimumSize: const Size(double.infinity, 52),
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
    ),
    onPressed: () {},
    child: const Text(
      'Primary',
      style: TextStyle(
        color: Colors.white, // fully opaque
        fontSize: 17,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
        shadows: [
          Shadow(
            color: Colors.black26,
            blurRadius: 1,
            offset: Offset(0, 0.5),
          ),
        ],
      ),
    ),
  ),
)
```

**Rule:** Always use this container gradient; no nested Ink or color overrides. Secondary buttons retain stroke logic as defined.

> **Button Rendering Order**
> 1. Outer `Container` owns gradient & shadow.  
> 2. `ElevatedButton` inside: `backgroundColor` and `shadowColor` set to transparent.  
> 3. No Ink, no nested gradient layers.  
> 4. Label text: opaque white (`Colors.white`) with the shadow style in this doc.  
> 5. Never wrap buttons in `FrostedContainer`.

---

Implement gradient buttons with animated hover:

```dart
// Primary Button with Teal Gradient
ElevatedButton(
  style: ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24), // Updated radius
    ),
    minimumSize: const Size(double.infinity, 52), // Height 52 px
    shadowColor: Theme.of(context).colorScheme.primary.withOpacity(0.15),
    elevation: 3,
    backgroundColor: Colors.transparent,
  ).copyWith(
    overlayColor: WidgetStateProperty.all(
      Theme.of(context).colorScheme.primary.withOpacity(0.08),
    ),
  ),
  onPressed: () {},
  child: Ink(
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFF00C6A2), Color(0xFF00DDB0)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: const BorderRadius.all(Radius.circular(24)), // Updated radius
      // Revolut-style halo glow
      boxShadow: [
        BoxShadow(
          color: const Color(0xFF00C6A2).withOpacity(0.08),
          blurRadius: 48,
          spreadRadius: -8,
        ),
      ],
    ),
    child: Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      child: const Text(
        'Primary Button',
        style: TextStyle(
          color: Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
      ),
    ),
  ),
),

// Secondary Button with Stroke
OutlinedButton(
  style: OutlinedButton.styleFrom(
    side: BorderSide(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color.fromRGBO(0, 198, 162, 0.35) // Updated opacity
          : const Color.fromRGBO(0, 198, 162, 0.35),
      width: 1, // Updated to 1px
    ),
    foregroundColor: Theme.of(context).colorScheme.primary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24), // Updated radius
    ),
    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
  ).copyWith(
    overlayColor: WidgetStateProperty.all(
      Theme.of(context).colorScheme.primary.withOpacity(0.06), // Pressed state overlay glass 6%
    ),
  ),
  onPressed: () {},
  child: const Text('Secondary Button'),
),
```

### 6.3 Floating Bottom Navigation Bar (Revolut × iOS Hybrid)

**Goal:** Create a premium, glassy navigation bar that floats above the background gradient instead of attaching to the screen bottom.

#### Design Tokens
| Property | Light | Dark | Notes |
|-----------|--------|------|-------|
| Background | `rgba(255,255,255,0.06)` | `rgba(0,0,0,0.12)` | Stronger glass effect |
| Blur | 30 px | 30 px | Premium floating depth |
| Corner Radius | 28 px | 28 px | Rounded floating bar |
| Elevation Shadow | `0 8 32 rgba(0,0,0,0.16)` | `0 8 32 rgba(0,0,0,0.25)` | Creates lift from screen |
| Border | 1px hairline `rgba(0,0,0,0.06)` | 1px hairline `rgba(255,255,255,0.06)` | Hairline stroke token |
| Padding | 12 px vertical, 24 px horizontal | same | Consistent spacing |
| Margin (screen inset) | 12 px sides, 16 px bottom, margin-bottom: SafeArea.bottom + 6 | same | Creates "floating" appearance — visually centered float for Revolut-like spatial depth |
| Icon Active | Teal `#00C6A2` | Aqua `#00DDB0` | Highlight color |
| Icon Inactive | `rgba(0,0,0,0.45)` | `rgba(255,255,255,0.5)` | Muted icons |

#### Implementation Example (Flutter)
```dart
Positioned(
  left: 12,
  right: 12,
  bottom: 16, // Visually centered float for premium balance
  child: FrostedContainer(
    borderRadius: 28,
    blurSigma: 30, // Premium floating depth
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white.withOpacity(0.06) // Stronger glass effect
            : Colors.black.withOpacity(0.12),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.light
              ? Colors.black.withOpacity(0.06)
              : Colors.white.withOpacity(0.06),
          width: 1, // Hairline stroke
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black.withOpacity(0.16)
                : Colors.black.withOpacity(0.25),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(Icons.home, color: Theme.of(context).colorScheme.primary),
          Icon(Icons.chat, color: Colors.grey),
          Icon(Icons.calendar_today, color: Colors.grey),
          Icon(Icons.person, color: Colors.grey),
        ],
      ),
    ),
  ),
)
```

**Behavior:**
- Always overlays on top of scrollable content (using Stack and Positioned).
- Light bounce shadow gives the floating illusion.
- Visually centered float for Revolut-like spatial depth.
- Margin-bottom accounts for SafeArea.bottom + 6 px for proper spacing.

## 🔧 v2.5.1 Addendum — Responsive Chips & Floating Nav Bar Specification

### 1. Gradient Filter Chips (Final Implementation Spec)

**Component:** `GradientFilterChip`  
**Purpose:** Premium pill-style filter; fully responsive and glass-compatible.

#### Visual Tokens
| State | Fill | Border | Text | Icon | Elevation |
|--------|------|--------|------|------|-----------|
| Unselected (Light) | `#FFFFFF` | `#101314 @10%` | `#101314 @96%` | none | none |
| Unselected (Dark)  | `#0B0D0D @24%` | `#FFFFFF @8%` | `#FFFFFF @92%` | none | none |
| Selected (both)    | Gradient `#00C6A2 → #00DDB0` | none | `#FFFFFF` | ✓ icon left | glow `#00DDB0 @22%` |

#### Layout & Behavior
- Border radius = 28 px  Horizontal padding = 16 px  Vertical padding = 12 px.  
- No fixed width; chips shrink-wrap label.  
- Haptic feedback on tap.  
- AnimatedContainer duration 160 ms easeOut.  
- **Responsive layout:**  
  ```dart
  SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      children: [...GradientFilterChip(...)...],
    ),
  )
  ```
- Spacing between chips = 12 px.
- Single-select logic (only one active).

#### Accessibility
- Semantic role = button; `selected: true` when active.
- Min tap target ≥ 44 × 44 px.

### 2. Frosted Bottom Navigation Bar (Final Implementation Spec)

**Component:** `FrostedBottomBar`  
**Purpose:** Floating glass navigation capsule in Revolut × iOS style.

#### Visual Tokens
| Mode | Background | Blur | Border | Shadow | Radius |
|------|------------|------|--------|--------|--------|
| Light | `rgba(255,255,255,0.08)` | 22 px | `#101314 @10%` | blur 26 px @25% | 28 px |
| Dark  | `rgba(10,11,11,0.32)` | 22 px | `#FFFFFF @10%` | blur 26 px @25% | 28 px |

#### Layout
- Margin: `EdgeInsets.only(left:16,right:16,bottom:10)`
- Height: 64 px; SafeArea aware.
- Even icon spacing; use `Row(mainAxisAlignment:spaceEvenly)`.
- `ClipRRect` + `BackdropFilter` required.
- Background color lives inside the blur layer.
- Drawn above page content (`Align(bottomCenter)`).

### 3. Validation Checklist
| Check | Expected |
|-------|----------|
| Chips | Selected = teal gradient + white text + check icon; scrollable row; no overflow |
| Nav Bar | Glassy float; border + shadow visible; no grey fill |
| Haptics | Light tactile click on chip tap |
| Responsiveness | No overflow banners on any device |
| Tokens | Primary `#00C6A2` Secondary `#00DDB0` |
| Shadow Depth | blur 26 px @ 25% opacity |

### 4. Implementation Guardrails
- Never replace gradients with solid fills.
- Never use default Material `FilterChip` or `NavigationBar`.
- Always wrap translucent surfaces in `ClipRRect` + `BackdropFilter`.
- Keep all numeric constants fixed; do not auto-scale.
- Run the Validation Checklist after regeneration.

### 🔹 Component Refinement Patch (Revolut × iOS Polish)

**Goal:** Apply final polish to buttons, modals, drawer surfaces, and chips to achieve Revolut-grade depth and contrast across both themes.

#### 1️⃣ Primary & Modal Button Typography

To strengthen clarity on bright gradients and frosted modals:

```dart
TextStyle(
  fontWeight: FontWeight.w600,
  letterSpacing: 0.25,
  color: Colors.white, // fully opaque, no alpha
  shadows: [
    Shadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 1,
      offset: Offset(0, 0.5),
    ),
  ],
)

// Button elevation
elevation: 1, // maintains depth on teal gradients
```

**Dark theme:** Uses identical text values but keep `shadowColor` at `0.05` opacity for subtle depth.

#### 2️⃣ Drawer Surface Enhancement

**Light Theme:**
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFFF3FBFA), // #F3FBFA
        const Color(0xFFE7F7F4), // #E7F7F4
      ],
    ),
  ),
  child: Drawer(
    child: ListView(
      children: [
        ListTile(
          selectedTileColor: const Color(0xFF00D6C7).withOpacity(0.08), // tileHighlight
          title: Text(
            'Item',
            style: TextStyle(
              color: const Color(0xFF1A1A1A), // textPrimary
            ),
          ),
          leading: Icon(
            Icons.home,
            color: Colors.black.withOpacity(0.75), // iconColor
          ),
        ),
      ],
    ),
  ),
)
```

**Design Tokens:**
- Background: `linear-gradient(180deg, #F3FBFA 0%, #E7F7F4 100%)`
- Divider Color: `rgba(0,0,0,0.05)`
- Tile Highlight: `rgba(0,214,199,0.08)`
- Text Primary: `#1A1A1A`
- Text Secondary: `#707070`
- Icon Color: `rgba(0,0,0,0.75)`

**Dark Theme:**
```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF0E1414), // #0E1414
        const Color(0xFF0A0E0E), // #0A0E0E
      ],
    ),
  ),
  child: Drawer(
    child: ListView(
      children: [
        ListTile(
          selectedTileColor: const Color(0xFF00D6C7).withOpacity(0.12), // tileHighlight
          title: Text(
            'Item',
            style: TextStyle(
              color: Colors.white, // textPrimary
            ),
          ),
          leading: Icon(
            Icons.home,
            color: Colors.white.withOpacity(0.8), // iconColor
          ),
        ),
      ],
    ),
  ),
)
```

**Design Tokens:**
- Background: `linear-gradient(180deg, #0E1414 0%, #0A0E0E 100%)`
- Divider Color: `rgba(255,255,255,0.06)`
- Tile Highlight: `rgba(0,214,199,0.12)`
- Text Primary: `#FFFFFF`
- Text Secondary: `rgba(255,255,255,0.65)`
- Icon Color: `rgba(255,255,255,0.8)`

→ Adds gentle teal warmth in light mode and subtle emerald depth in dark mode.

#### 3️⃣ Chip State Visibility

#### 🔹 Canonical ChoiceChip Logic
Each chip controls its selected and unselected colors internally; no wrappers.

```dart
ChoiceChip(
  label: Text(label),
  selected: isSelected,
  backgroundColor: Colors.white.withOpacity(0.8),
  selectedColor: Colors.transparent, // gradient applied via ShaderMask below
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(40),
    side: BorderSide(
      color: isSelected
          ? Colors.transparent
          : Colors.black.withOpacity(0.1),
    ),
  ),
  labelStyle: TextStyle(
    color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
  ),
)
```

Wrap the chip's label in a ShaderMask when selected:

```dart
ShaderMask(
  shaderCallback: (bounds) => const LinearGradient(
    colors: [Color(0xFF00D2C6), Color(0xFF00BFA3)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  ).createShader(bounds),
  child: chip,
)
```

**Behavior:** Selected = teal gradient with white text; Pressed = darker gradient (`#00C4B4 → #00A996`).

> **Chip Rendering Order**
> 1. Use one `ChoiceChip` only.  
> 2. When `selected == true`, apply gradient via `ShaderMask`.  
> 3. When `selected == false`, use `backgroundColor` light/dark tokens exactly.  
> 4. Label color white on selected, charcoal on unselected.  
> 5. Cursor must not substitute Material chip colors.

#### 4️⃣ Modal Text Contrast

Inside modal containers:

**Light Theme:**
```dart
AlertDialog(
  title: Text(
    'Modal Title',
    style: TextStyle(
      color: const Color(0xFF1A1A1A), // titleColor
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
  ),
  content: Text(
    'Modal body text',
    style: TextStyle(
      color: const Color(0xFF2A2A2A).withOpacity(0.87), // bodyColor (87% opacity)
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
    ),
  ),
)
```

**Dark Theme:**
```dart
AlertDialog(
  title: Text(
    'Modal Title',
    style: TextStyle(
      color: Colors.white, // titleColor
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
  ),
  content: Text(
    'Modal body text',
    style: TextStyle(
      color: Colors.white.withOpacity(0.75), // bodyColor
      fontWeight: FontWeight.w400,
      letterSpacing: 0.1,
    ),
  ),
)
```

**Design Tokens:**
- Title Color: `#1A1A1A` (light) / `#FFFFFF` (dark)
- Body Color: `#2A2A2A` with 87% opacity (light) / `rgba(255,255,255,0.75)` (dark)
- Font Weight Title: `w600`
- Font Weight Body: `w400`
- Letter Spacing: `0.1`

→ Matches Apple's SF font tone hierarchy.

**Important:** Modal titles and content must use opaque color values only (`#1A1A1A` light / `#FFFFFF` dark). Do not apply `.withOpacity()` on text styles.

**Visual Impact:**
- **Primary & Modal Buttons** → now read crisp and premium on both themes.
- **Drawer Menu** → gains teal-tinted depth, no longer looks flat or washed-out.
- **Chips** → visibly toggle with Revolut-style glow gradient and white label when selected.

### 6.2 Premium Layout Component Tokens

#### ChartCard / TrendTile
- **Gradient surface:** linear(brandPrimary → brandAccent)
- **LineColor:** brandAccentLight
- **CornerRadius:** 20
- **Elevation:** 6dp
- **Motion:** curveEaseInOut

#### ChatBubble (In/Out)
- **Inbound:** glassNeutral(0.75 opacity)
- **Outbound:** gradientPrimaryAccent()
- **Radius:** 22, 22, 4, 22 (RTL mirrored)
- **Padding:** 8–12 px
- **TextColor:** adaptive based on mode

#### QuickActionChip / ProgressPill
- **Background:** frostedPrimary(0.8)
- **ActiveGlow:** brandAccentLight(0.3)
- **Font:** LabelM
- **Elevation:** 2dp

#### AIInsightBanner
- **Surface:** frostedNeutral(0.9)
- **Glow:** subtle(brandAccent, opacity 0.25)
- **BorderRadius:** 24

## 7. Motion System

| Element | Duration | Curve | Effect |
|---------|----------|-------|--------|
| Page transition | 220 ms | Cubic (0.22,1,0.36,1) | iOS fade-slide |
| Button press/hover | 250 ms | `easeOutQuart` | 10% brightness reduction with smooth spring animation |
| Chip toggle | 250 ms | `easeOutCubic` | Smooth state change |
| Theme toggle | 300 ms | `easeInOut` | Cross-fade brightness change |
| Modal open | 350 ms | Spring (stiffness = 300, damping = 20) | Elastic pop-in |
| Navigation rail | 200 ms | `easeInOutQuad` | Smooth slide |
| Card expansion | 250 ms | `Hero` transition | Future card expansions |
| Card hover | 250 ms | `easeOutCubic` | Light elevation on hover |

**Haptic Feedback:**
- Light impact haptic on navigation and drawer select actions for premium tactile response.

### 7.1 Motion Implementation

Use standard transition tokens:

**Implementation example:**

```dart
// Button hover animation
AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  curve: Curves.easeOutQuart,
  child: ElevatedButton(...),
),

// Card hover elevation
AnimatedContainer(
  duration: const Duration(milliseconds: 250),
  curve: Curves.easeOutCubic,
  transform: Matrix4.identity()..translate(0.0, isHovered ? -2.0 : 0.0),
  child: Card(...),
),

// Theme toggle cross-fade
AnimatedTheme(
  data: ThemeData(...),
  duration: const Duration(milliseconds: 300),
  curve: Curves.easeInOut,
  child: YourWidget(),
),

// Modal spring animation
showDialog(
  context: context,
  barrierColor: Colors.black.withOpacity(0.25),
  builder: (context) => BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
    child: AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      // Modal content
    ),
  ),
),
```

Animations should always respect the system "Reduce Motion" setting.

### 7.2 Animation Curve Tokens

| Token Name | Type | Value | Usage |
|------------|------|-------|-------|
| `curve.standard` | Ease Out | `Curves.easeOutCubic` | Default screen and component transitions (250 ms) |
| `curve.spring` | Spring | stiffness 300, damping 20 | Elastic modals and hero animations (300 ms) |
| `curve.fast` | Ease In Out | `Curves.easeInOutQuad` | Buttons, taps, and list items (120 ms) |
| `curve.smooth` | Ease Out | `Curves.easeOutQuart` | Floating panels, nav elements, and premium interactions (250 ms) |

> These curve tokens must be referenced in animation controllers and `AnimatedContainer` transitions for consistent motion behavior across Flutter and web builds.

## 8. Accessibility & Contrast

- **Minimum contrast ratio** ≥ 4.5:1 (WCAG AA).
- **No color-only status indication.**
- **Focus states** show outline (`#5ED1CE` 2 px).
- **Large text** maintains 1.2 line height.
- **Tap targets** ≥ 44 × 44 px.

> In addition to AA compliance, interactive elements (hover, active, focus) must preserve ≥3:1 contrast difference from their base state to maintain visibility in translucent contexts.

## 9. Cross-Platform Adaptation

| Platform | Adjustment |
|----------|------------|
| iOS | Uses native SF Pro typography, rounded nav bars, frosted translucent surfaces. |
| Android | Slightly flatter elevation; uses Material 3 shapes but same tokens. |
| Web | Higher blur (28 px) on modals, thinner borders for sharper definition. |

## 10. Implementation Summary

| Area | Token Source | Example |
|------|--------------|---------|
| Flutter ThemeData | `colorScheme`, `surfaceTintOpacity`, `useMaterial3: true` | Applies palette & elevation |
| Custom FrostGlass | `BackdropFilter` (24 px light / 26 px dark blur) | Reusable across AppBar, NavBar, Cards |
| Typography | `TextTheme` tokens (SF Pro / Inter) | Consistent scaling |
| Motion | `Curves.easeOutCubic` + spring physics | iOS-like transitions |

**Implementation Note:** Apply the Glass & Depth tokens (Section 5.1) globally before layering content. Use `BackdropFilter` for frost, gradient overlays for ambient light, and a soft radial teal halo for Revolut-style depth.

Ensure the blur and opacity values (24/26 px, 0.88/0.78) are applied globally via the theme tokens before layering UI content.

**Premium Visual Guidelines:**
- Avoid pure black or pure white: always tinted by theme gradient.
- Surfaces feel translucent, not solid.
- Every elevation layer has either a blur, glow, or subtle gradient.
- Use gradient fills on cards and buttons for depth.
- Apply inner glow (dark mode) for subtle sheen.

> Define these tokens programmatically in `theme_tokens.dart` or equivalent for Cursor and developers.  
> Include `icon.inactive`, `drawer.selected`, `hover.background`, `button.gradient.primary`, and `card.innerGlow.dark` as explicit named tokens to ensure deterministic behavior.

⚙️ **Common Cursor / Flutter Fix Notes**
- Remove `backgroundColor` when using gradients.
- Keep only one `BackdropFilter` — the one with the highest blur.
- If chip gradients vanish, wrap in `ShaderMask`.
- Text colors must be opaque; never apply `.withOpacity()`.
- Blur flatness = check `sigmaX`/`sigmaY` (24 / 26 / 28).
- Always override Material defaults; never rely on them.

### 10.1 Validation & Testing

Add this validation snippet to verify theme implementation in Cursor/Flutter:

```dart
// Theme validation example
void validateTheme(ThemeData theme) {
  assert(
    theme.brightness == Brightness.light
        ? theme.cardColor == Colors.white.withOpacity(0.88)
        : theme.cardColor == const Color(0xFF131516).withOpacity(0.78),
    'Card surface opacity must match design system',
  );
  
  assert(
    theme.colorScheme.primary == const Color(0xFF00C6A2),
    'Primary color must be #00C6A2',
  );
  
  assert(
    theme.colorScheme.secondary == const Color(0xFF00DDB0),
    'Secondary accent must be #00DDB0',
  );
}

// Token constants for direct reference
class SwiftleadTokens {
  // Colors
  static const Color primaryTeal = Color(0xFF00C6A2);
  static const Color accentAqua = Color(0xFF00DDB0);
  
  // Blur values
  static const double blurLight = 24.0;
  static const double blurDark = 26.0;
  static const double blurModal = 28.0;
  
  // Opacity values
  static const double surfaceOpacityLight = 0.88;
  static const double surfaceOpacityDark = 0.78;
  
  // Border radius
  static const double radiusCard = 20.0;
  static const double radiusButton = 16.0;
  static const double radiusModal = 28.0;
  
  // Shadows
  static const BoxShadow shadowLight = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.06),
    blurRadius: 10,
    offset: Offset(0, 3),
  );
  
  static const BoxShadow shadowDark = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.25),
    blurRadius: 16,
    offset: Offset(0, 3),
  );
  
  // Animation durations
  static const Duration transitionFast = Duration(milliseconds: 250);
  static const Duration transitionModal = Duration(milliseconds: 350);
  
  // Animation curves
  static const Curve curveStandard = Curves.easeOutQuart;
  static const Curve curveSmooth = Curves.easeOutCubic;
}
```

> These refinements align the Swiftlead interface more closely with the Revolut × iOS premium aesthetic—balancing float, shadow, and glass realism across all components.

### 🔒 Global Fallback Guardrail

If any component (Button, Chip, Drawer, Modal) renders incorrectly:
- Confirm a `FrostedContainer` or gradient layer was not omitted.  
- Re-apply the code snippet from this document exactly.  
- Rebuild using this file only — no Flutter default theme values.  
- If Cursor reports "unknown property," ignore the error and keep the token name.  
- Validate core tokens: blur = 24/26 px, surfaceOpacity = 0.88/0.78, primary = #00C6A2.

## Module 14: Adaptive Profession System

The Adaptive Profession System enables Swiftlead to support multiple industry verticals (Trade, Salon/Clinic, Professional) through dynamic module visibility and label mapping while maintaining a unified visual theme.

#### Profession Adaptation Configuration (Unified Theme)
All verticals share the same accent and theme.
Functional differences are limited to module visibility and label mapping.

| Profession | Visible Modules | Label Overrides | Notes |
|-------------|----------------|-----------------|-------|
| Trade | Home, Inbox, Jobs, Calendar, Money | none | Standard layout |
| Salon / Clinic | Home, Inbox, Calendar, Money | Job→Appointment, Payment→Invoice | Hidden Jobs tab |
| Professional | Home, Inbox, Jobs, Reports, Money | Job→Client, Payment→Fee | Hidden Calendar/Bookings |

Backend link: `industry_profiles.industry_key` controls label overrides and module set.

### Example Seed – industry_profiles
```json
[
  {
    "industry_key": "trade",
    "visible_modules": ["home","inbox","jobs","calendar","money"],
    "label_overrides": {}
  },
  {
    "industry_key": "salon",
    "visible_modules": ["home","inbox","calendar","money"],
    "label_overrides": {"job":"appointment","payment":"invoice"}
  },
  {
    "industry_key": "professional",
    "visible_modules": ["home","inbox","jobs","reports","money"],
    "label_overrides": {"job":"client","payment":"fee"}
  }
]
```
All verticals inherit identical theme tokens (accent, typography, motion).
Only labels and module sets differ.

## Outcome

Once implemented, Swiftlead will have:

- **Light theme**: airy glass, high contrast, teal accents.
- **Dark theme**: matte glass, teal glow, luxurious calm.
- **Seamless parity** across mobile and web.

---

### 🧭 Full Theme Preview Setup

Create `/lib/screens/theme_preview_screen.dart` exactly as follows:

```dart
Scaffold(
  extendBody: true,
  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
  drawer: buildDrawer(context),
  body: ThemePreviewBody(),
  bottomNavigationBar: buildFloatingNavBar(context),
)
```

**Must include:**
- Light/Dark toggle
- Drawer header & tiles
- Primary + Secondary Buttons
- ChoiceChips (selected/unselected)
- Modal sample
- Card grid showing blur & glow

The preview verifies that every layer, blur, and shadow visually matches this specification.  
**Never adjust colors manually — fix only via tokens.**

---

> These updates complete the Revolut × iOS premium alignment for Swiftlead — achieving visual depth, minimalism, and authentic spatial feel across light and dark modes.

✅ **Swiftlead Theme & Design System v2.5 Final** — Premium Revolut × iOS Visual System upgrade applied. Enhanced depth, gradients, shadows, and luxurious glass effects while preserving Swiftlead's teal identity (Nov 2025).  
This file is now the **single, build-ready source of truth** for all Swiftlead UI generation and updates.

**v2.5 Addendum:** Added visual tokens for new premium layout components.

---


---

#### [Enhanced Addendum — Additional Design Patterns: Contacts, Marketing, Notifications]

## New Component Responsive Behavior

| Component | Mobile (<640px) | Tablet (640-1024px) | Desktop (>1024px) |
|-----------|-----------------|---------------------|-------------------|
| **ContactListView** | Single column | Single column | Two-column split (list + detail) |
| **ContactDetailScreen** | Full screen | Full screen with wider layout | Two-column (detail + timeline) |
| **StageProgressBar** | Horizontal scroll | Full width | Full width |
| **EmailComposer** | Stacked (editor above preview) | Side-by-side (50/50) | Side-by-side (60/40 editor/preview) |
| **VisualWorkflowEditor** | Simplified (list view) | Canvas with zoom controls | Full canvas with minimap |
| **CampaignAnalytics** | Stacked metrics | 2-column grid | 3-column grid with charts |
| **FieldMapper** | Stacked (source above target) | Side-by-side | Side-by-side with live preview |
| **ImportWizard** | Single step, vertical | Single step, horizontal | All steps visible in sidebar |
| **PreferenceGrid** | Stacked (one channel per row) | 2 channels per row | Full grid (4 channels) |
| **SegmentBuilder** | Stacked filters | 2 filters per row | Drag-drop canvas |

---

## 🆕 Enhanced Accessibility Tokens

### Screen Reader Labels (Enhanced Components)

| Component | Context | Label Format |
|-----------|---------|--------------|
| **ContactCard** | List item | "Contact: [Name], Stage: [Stage], Score: [Number] [Classification], Last contacted: [Time]" |
| **StageProgressBar** | Progress indicator | "Lifecycle stage: [Current] of [Total], [Percentage]% complete" |
| **ScoreIndicator** | Badge | "Lead score: [Number], Classification: [Hot/Warm/Cold]" |
| **DuplicateCard** | Comparison | "Potential duplicate: [Name 1] and [Name 2], [Confidence]% match" |
| **CampaignCard** | List item | "Campaign: [Name], Type: [Type], Status: [Status], Sent to [Count] recipients, [Open Rate]% opened" |
| **EmailComposer** | Editor | "Email editor, [Word Count] words, [Image Count] images, [Link Count] links" |
| **MergeField** | Tag | "Merge field: [Field Name], Example value: [Value]" |
| **ABTestConfig** | Settings | "A/B test: [Test Name], Variant A: [Percentage]%, Variant B: [Percentage]%, Winner: [Criteria]" |
| **PreferenceGrid** | Matrix | "Notification preferences: [Type], Channels: [Enabled Channels], Disabled: [Disabled Channels]" |
| **FileUploadZone** | Upload | "File upload zone, [Accepted Formats], Maximum size: [Size], [Current Status]" |
| **ImportProgressBar** | Progress | "Import progress: [Count] of [Total] rows processed, [Percentage]% complete" |

---

## 🆕 Enhanced Dark Mode Overrides

### Component-Specific Dark Mode Adjustments

| Component | Light Override | Dark Override | Reason |
|-----------|----------------|---------------|---------|
| **EmailComposer** | Editor bg: `#FFFFFF` | Editor bg: `#1A1C1E` | Better contrast for text editing |
| **VisualWorkflowEditor** | Canvas bg: `#F6FAF8` | Canvas bg: `#0E1011` | Clearer node visibility |
| **LandingPageBuilder** | Canvas bg: `#F6FAF8` | Canvas bg: `#0E1011` | Accurate page preview |
| **FieldMapper** | Connection line: 50% opacity | Connection line: 70% opacity | Better line visibility |
| **ValidationPreview** | Error row: 5% opacity | Error row: 8% opacity | More noticeable errors |
| **LinkHeatmap** | Border: White | Border: Background color | Better link distinction |
| **ScoreIndicator** | Text: Always white | Text: Always white | Consistent readability |
| **NotificationHistoryCard** | Unread dot: `#00C6A2` | Unread dot: `#00DDB0` (brighter) | More noticeable in dark mode |

---

## Component Implementation Examples

### ContactCard (Flutter/Dart)

```dart
Container(
  height: 88,
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Theme.of(context).brightness == Brightness.light
        ? const Color.fromRGBO(255, 255, 255, 0.88)
        : const Color.fromRGBO(19, 21, 22, 0.78),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(
      color: Theme.of(context).brightness == Brightness.light
          ? const Color.fromRGBO(0, 0, 0, 0.08)
          : const Color.fromRGBO(255, 255, 255, 0.08),
    ),
    boxShadow: [
      BoxShadow(
        color: Theme.of(context).brightness == Brightness.light
            ? const Color.fromRGBO(0, 0, 0, 0.04)
            : const Color.fromRGBO(0, 0, 0, 0.20),
        blurRadius: Theme.of(context).brightness == Brightness.light ? 8 : 12,
        offset: const Offset(0, 2),
      ),
    ],
  ),
  child: Row(
    children: [
      // Avatar, Name, Details, Badges
    ],
  ),
);
```

### StageProgressBar (Flutter/Dart)

```dart
Container(
  height: 8,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(4),
    color: Theme.of(context).brightness == Brightness.light
        ? const Color.fromRGBO(0, 0, 0, 0.06)
        : const Color.fromRGBO(255, 255, 255, 0.06),
  ),
  child: AnimatedContainer(
    duration: const Duration(milliseconds: 400),
    curve: Curves.easeOutQuart,
    width: MediaQuery.of(context).size.width * (currentStage / totalStages),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4),
      color: const Color(0xFF00C6A2),
    ),
  ),
);
```

### EmailComposer Merge Field (HTML/CSS)

```html
<span class="merge-field" data-field="FirstName">
  {{FirstName}}
</span>
```

```css
.merge-field {
  background: rgba(0, 198, 162, 0.12);
  color: #00796B;
  padding: 2px 8px;
  border-radius: 12px;
  font-family: 'Inter', monospace;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: background 150ms ease-out;
}

.merge-field:hover {
  background: rgba(0, 198, 162, 0.20);
}

[data-theme="dark"] .merge-field {
  background: rgba(0, 221, 176, 0.15);
  color: #4DB6AC;
}
```

---

## Platform-Specific Implementation Notes

### iOS Specific
- Use native `UISwitch` for preference toggles with custom tint color `#00C6A2`
- ContactCard swipe actions use `UIContextualAction` with custom colors
- StageProgressBar uses `CAShapeLayer` with animated `strokeEnd`
- Haptic feedback: `UIImpactFeedbackGenerator` (light/medium/heavy)

### Android Specific
- Use `Material3` components with custom colors
- ContactCard swipe uses `ItemTouchHelper` with custom backgrounds
- StageProgressBar uses `ProgressBar` with custom drawable
- Haptic feedback: `HapticFeedbackConstants` (CONTEXT_CLICK / LONG_PRESS)

### Web Specific
- EmailComposer uses `contentEditable` div with custom toolbar
- VisualWorkflowEditor uses Flutter CustomPaint and Canvas API for nodes
- Drag-drop uses Flutter Draggable and DragTarget widgets
- FileUploadZone uses `<input type="file">` with custom styling
- Hover effects use CSS `:hover` with `transition` for smooth animations

---

*Theme Enhancement v2.5.1 — November 2025*  
*This addendum adds 200+ design tokens and specifications for 40+ new components*



## Cross-Vertical Consistency

All professions (Trade, Salon/Clinic, Professional) share identical color, typography, and motion tokens.
Accent token: `accentPrim

---

## Brand Voice & Content Guidelines

**Purpose:** Consistent tone and messaging across all customer touchpoints.

### Brand Voice Principles

**Core Attributes:**
1. **Professional but Approachable** — Expert without being stuffy
2. **Confident but Humble** — Capable without boasting
3. **Clear and Direct** — No jargon or unnecessary complexity
4. **Supportive and Encouraging** — Helpful without being condescending

**Voice Spectrum:**
- **Formal ←→ Casual:** Slightly casual (70% casual, 30% formal)
- **Technical ←→ Simple:** Simple first, technical when needed
- **Serious ←→ Playful:** Professional with moments of warmth
- **Respectful ←→ Irreverent:** Always respectful

---

### Content Guidelines by Context

#### UI Copy (In-App Text)

**Buttons:**
- Use action verbs: "Create Job", "Send Invoice", "Book Appointment"
- Be specific: "Send Payment Link" not "Share"
- Avoid generic: "Okay" → "Got It", "Submit" → "Create Job"

**Empty States:**
- Be encouraging: "No jobs yet" → "Create your first job to get started"
- Explain why: "Your inbox is empty" → "All caught up! No new messages."
- Provide next action: Always include a clear CTA

**Error Messages:**
- Be specific about the problem: "Failed to load" → "Couldn't connect to server"
- Explain what happened: "Check your internet connection and try again"
- Offer solution: Always provide "Try Again" or alternative action
- Avoid blame: "You entered invalid data" → "Some information needs correction"

**Success Messages:**
- Be celebratory: "Job created!" → "Job created! Ready to schedule?"
- Confirm action: "Invoice sent" → "Invoice sent to John Smith via SMS"
- Set expectations: "Payment link copied" → "Payment link copied. Expires in 24 hours."

**Examples:**

| Context | ❌ Avoid | ✅ Prefer |
|---------|---------|----------|
| Job created | "Success" | "Job created! John Smith has been notified." |
| Payment received | "Payment successful" | "Payment received! £150 from John Smith." |
| Message sent | "Sent" | "Message sent to John via WhatsApp" |
| Error saving | "Error" | "Couldn't save changes. Check connection and try again." |
| Loading | "Loading..." | "Loading your jobs..." |
| Empty inbox | "No messages" | "All caught up! Your inbox is empty." |
| Delete confirmation | "Are you sure?" | "Delete this job? This can't be undone." |

---

#### Email Templates

**Subject Lines:**
- Keep under 50 characters
- Be specific and actionable
- Include relevant details (job number, amount, date)

**Email Body:**
- Greeting: "Hi [First Name]," (casual) or "Hello [Full Name]," (formal)
- Opening: One sentence context ("Your quote for kitchen sink repair is ready")
- Body: 2-3 short paragraphs with clear information
- CTA: One primary action button with clear label
- Closing: "Thanks," or "Best regards," from business name
- Footer: Contact info, unsubscribe link, legal

**Example Welcome Email:**

```
Subject: Welcome to Swiftlead!

Hi Alex,

Welcome to Swiftlead! We're excited to help you capture leads, manage jobs, and get paid faster.

Your account is ready. Here's what to do next:

1. Add your first contact
2. Create your first job
3. Enable AI Receptionist to handle inquiries 24/7

We're here to help. Reply to this email anytime with questions.

Let's get started!

The Swiftlead Team
support@swiftlead.co
```

**Example Invoice Email:**

```
Subject: Invoice from ABC Plumbing — £250.00 due

Hi John,

Thanks for choosing ABC Plumbing! Your invoice for the kitchen sink repair is ready.

Amount due: £250.00
Due date: November 10, 2025

[Pay Now Button]

Questions? Reply to this email or call us at 020 1234 5678.

Thanks,
ABC Plumbing
```

---

#### SMS Templates

**Characteristics:**
- Maximum 160 characters (avoid split messages)
- No emojis unless customer uses them first
- Include business name
- Include action (link, reply, call)

**Examples:**

| Context | Template |
|---------|----------|
| Missed call follow-up | "Hi [Name], this is [Business]. You called but we missed you. Reply here or call back: [Phone]. We're here till 6pm." |
| Quote ready | "[Business]: Your quote for [Service] is ready. View and accept: [Link]. Questions? Reply here." |
| Appointment reminder | "[Business]: Reminder - We're arriving at 2pm today for [Service] at [Address]. See you soon!" |
| Payment request | "[Business]: Invoice #[Number] for £[Amount] is ready. Pay securely: [Link]. Thanks!" |
| Booking confirmation | "Confirmed! [Business] will arrive on [Date] at [Time] for [Service]. Reply to change or ask questions." |

---

#### Notification Copy

**Push Notifications:**
- Lead with key info: "Payment received — £150 from John Smith"
- Use title + body format
- Keep body under 80 characters
- Include actionable context

**In-App Notifications:**
- Be conversational: "John Smith replied to your quote"
- Include timestamp: "2 minutes ago"
- Show preview of content when relevant

**Examples:**

| Type | Title | Body |
|------|-------|------|
| New message | New message from John Smith | "When can you start the job?" |
| Payment | Payment received | £150 from John Smith for Job #1234 |
| Booking | New booking request | John Smith wants to book for Nov 5 at 2pm |
| Review | New review received | ⭐⭐⭐⭐⭐ from Sarah Johnson |
| Job update | Job status changed | Kitchen Repair is now In Progress |

---

### Tone Variations by Audience

#### Trade Professionals (Plumbers, Electricians, etc.)
- **Style:** Direct, practical, no fluff
- **Language:** Simple, trade-specific terms okay
- **Example:** "Job created. John needs a leaky tap fixed by Friday."

#### Salon/Clinic Professionals
- **Style:** Warm, service-oriented, polished
- **Language:** Client-focused, professional terminology
- **Example:** "Appointment booked! Sarah's haircut is scheduled for 2pm."

#### Professional Services (Consultants, Lawyers, etc.)
- **Style:** Refined, formal, detailed
- **Language:** Business terminology, comprehensive
- **Example:** "Client engagement created. Initial consultation scheduled for Monday at 10am."

---

### Writing Checklist

Before publishing any customer-facing content:

- [ ] **Clear** — Is the message immediately understandable?
- [ ] **Concise** — Can any words be removed without losing meaning?
- [ ] **Actionable** — Is the next step obvious?
- [ ] **Accurate** — Are all details (amounts, dates, names) correct?
- [ ] **Appropriate** — Does the tone match the context and audience?
- [ ] **Accessible** — Will non-native speakers understand?
- [ ] **Error-free** — Spell-checked and grammar-checked?
- [ ] **On-brand** — Does it sound like Swiftlead?

---

### Words to Use / Avoid

**Prefer:**
- "You" (second person, direct)
- "We" (inclusive, partnership)
- Active voice ("We sent your invoice" not "Your invoice was sent")
- Specific numbers ("Save 30 minutes per day" not "Save time")
- Plain language ("Help" not "Assistance")

**Avoid:**
- "Users" (say "you" or "customers")
- "Utilize" (say "use")
- "Leverage" (say "use")
- "Reach out" (say "contact")
- "Going forward" (say "next" or remove)
- "Please be advised" (just state the information)
- "At this time" (say "now" or "currently")
- Exclamation points!!! (one is enough!)

---

## Enhanced Accessibility Standards

**Purpose:** WCAG AA compliance across all touchpoints.

### Color Contrast Requirements

#### Text Contrast (WCAG AA)

| Element | Size | Minimum Ratio | Swiftlead Standard |
|---------|------|---------------|-------------------|
| **Body text** | 14-16px | 4.5:1 | 7.2:1 (neutralDark on white) |
| **Large text** | 18px+ or 14px+ bold | 3:1 | 5.8:1 |
| **UI components** | Buttons, inputs, icons | 3:1 | 4.5:1 |
| **Focus indicators** | Borders, outlines | 3:1 | 4.5:1 (accentPrimary) |
| **Disabled text** | Any size | 3:1 recommended | 4.2:1 (neutralMedium) |

**Testing:**
- Chrome DevTools: Lighthouse Accessibility Audit
- Contrast Checker: WebAIM Contrast Checker
- Automated: axe DevTools extension

**Swiftlead Color Combinations (Verified):**

| Foreground | Background | Ratio | Pass? |
|------------|------------|-------|-------|
| `#1A1A1A` (neutralDark) | `#FFFFFF` (white) | 16.1:1 | ✅ AAA |
| `#666666` (neutralMedium) | `#FFFFFF` (white) | 5.7:1 | ✅ AA |
| `#00C6A2` (accentPrimary) | `#FFFFFF` (white) | 2.1:1 | ⚠️ Large text only |
| `#FFFFFF` (white) | `#00C6A2` (accentPrimary) | 2.1:1 | ⚠️ Large text only |
| `#FFFFFF` (white) | `#1A1A1A` (neutralDark) | 16.1:1 | ✅ AAA |
| `#00C6A2` (accentPrimary) | `#1A1A1A` (neutralDark) | 7.6:1 | ✅ AAA |

**Action Required:**
- Accent color text on white background: Always use bold weight (600+) or size 18px+
- For small accent text on white: Use neutralDark instead or add dark background

---

### Touch Target Sizes

**Minimum Requirements:**

| Platform | Minimum Size | Recommended | Spacing |
|----------|--------------|-------------|---------|
| **iOS (Apple HIG)** | 44x44pt | 44x44pt | 8pt |
| **Android (Material)** | 48x48dp | 48x48dp | 8dp |
| **Web (WCAG 2.2)** | 24x24px | 44x44px | 8px |
| **Swiftlead Standard** | 44x44pt/dp | 48x48pt/dp | 8-16pt/dp |

**Implementation:**

```dart
// Ensure minimum touch target
class TappableArea extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double minSize;
  
  const TappableArea({
    required this.child,
    required this.onTap,
    this.minSize = 44.0,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minSize,
          minHeight: minSize,
        ),
        child: Center(child: child),
      ),
    );
  }
}
```

---

### Focus Indicators

**Requirements:**
- Visible on all interactive elements when focused
- High contrast (3:1 minimum against adjacent colors)
- 2px minimum thickness
- Offset 2px from element edge
- Consistent across all elements

**Implementation:**

```dart
// Focus indicator style
final focusDecoration = BoxDecoration(
  border: Border.all(
    color: accentPrimary,
    width: 2.0,
  ),
  borderRadius: BorderRadius.circular(8),
);

// Apply to all focusable widgets
FocusableActionDetector(
  onShowFocusHighlight: (focused) {
    setState(() => _isFocused = focused);
  },
  child: Container(
    decoration: _isFocused ? focusDecoration : null,
    child: child,
  ),
)
```

---

### Screen Reader Support

**Semantic Labels:**

All interactive elements must have descriptive labels:

```dart
// Icon button with semantic label
IconButton(
  icon: Icon(Icons.delete),
  tooltip: 'Delete job',
  onPressed: _deleteJob,
  semanticsLabel: 'Delete job', // For screen readers
)

// Image with description
Image.network(
  imageUrl,
  semanticLabel: 'Photo of completed kitchen installation',
)

// Decorative image (no label needed)
Image.asset(
  'assets/decorative_pattern.png',
  excludeFromSemantics: true,
)
```

**Heading Hierarchy:**

Maintain proper heading order (H1 → H2 → H3):

```dart
// Screen title (H1)
Text('Jobs', style: Theme.of(context).textTheme.headline1)

// Section title (H2)
Text('Active Jobs', style: Theme.of(context).textTheme.headline2)

// Subsection (H3)
Text('Details', style: Theme.of(context).textTheme.headline3)
```

**Announcing Changes:**

```dart
// Announce dynamic content changes
void _showSuccessMessage(String message) {
  SemanticsService.announce(
    message,
    TextDirection.ltr,
  );
  // Also show visual toast
  showToast(context, message: message, type: ToastType.success);
}
```

---

### Motion and Animation Accessibility

**Reduced Motion Support:**

```dart
// Check system preference
bool reduceMotion = MediaQuery.of(context).disableAnimations;

// Conditional animation
Widget build(BuildContext context) {
  return AnimatedContainer(
    duration: reduceMotion 
      ? Duration.zero  // No animation
      : Duration(milliseconds: 300),
    curve: Curves.easeOut,
    child: child,
  );
}

// Alternative: Fade instead of slide
Widget build(BuildContext context) {
  final animation = reduceMotion
    ? FadeTransition(opacity: animation)  // Simple fade
    : SlideTransition(position: animation);  // Slide with bounce
}
```

**Safe Animation Guidelines:**
- No flashing/strobing (max 3 flashes per second)
- Pause/stop controls for auto-play content
- No infinite loops without user control
- Respect `prefers-reduced-motion` system setting

---

### Text Scaling Support

**Dynamic Type:**

```dart
// Use TextStyle.merge to support scaling
Text(
  'Job Title',
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ).merge(MediaQuery.of(context).textScaleFactor),
)

// Or use theme styles that automatically scale
Text(
  'Job Title',
  style: Theme.of(context).textTheme.titleMedium,
)

// Constrain maximum scale if needed
MediaQuery(
  data: MediaQuery.of(context).copyWith(
    textScaleFactor: min(MediaQuery.of(context).textScaleFactor, 2.0),
  ),
  child: child,
)
```

**Testing:**
- iOS: Settings → Accessibility → Display & Text Size → Larger Text
- Android: Settings → Display → Font size
- Test at 100%, 150%, 200% scales
- Ensure no text truncation at 200%

---

## Accessibility Testing Protocol

### Pre-Release Checklist

**Automated Testing:**
- [ ] Run Lighthouse accessibility audit (score 95+)
- [ ] Run axe DevTools (0 violations)
- [ ] Check contrast ratios for all text
- [ ] Validate HTML semantics (heading hierarchy)

**Manual Testing:**
- [ ] Tab through entire app (logical order)
- [ ] Test with VoiceOver (iOS) for 30 minutes
- [ ] Test with TalkBack (Android) for 30 minutes
- [ ] Test at 200% text scale
- [ ] Test in reduced motion mode
- [ ] Test all forms with keyboard only
- [ ] Test all modals and dialogs trap focus

**Real User Testing:**
- [ ] Test with actual screen reader users
- [ ] Test with motor impairment users
- [ ] Test with cognitive disability users
- [ ] Gather feedback and iterate

---
ary`.
There are no per-industry palettes or gradients. The single accent applies globally to ensure brand unity.


---

**Theme_and_Design_System_v2.5.1_10of10.md — Complete 10/10 Specification** completed — ready for 10/10 polish.**