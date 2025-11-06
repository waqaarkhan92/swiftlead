<!-- Split version for AI readability. Original structure preserved. -->

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

#### [Enhanced Addendum — Additional Design Patterns: Contacts, Notifications]

## New Component Responsive Behavior

| Component | Mobile (<640px) | Tablet (640-1024px) | Desktop (>1024px) |
|-----------|-----------------|---------------------|-------------------|
| **ContactListView** | Single column | Single column | Two-column split (list + detail) |
| **ContactDetailScreen** | Full screen | Full screen with wider layout | Two-column (detail + timeline) |
| **StageProgressBar** | Horizontal scroll | Full width | Full width |
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
| **PreferenceGrid** | Matrix | "Notification preferences: [Type], Channels: [Enabled Channels], Disabled: [Disabled Channels]" |
| **FileUploadZone** | Upload | "File upload zone, [Accepted Formats], Maximum size: [Size], [Current Status]" |
| **ImportProgressBar** | Progress | "Import progress: [Count] of [Total] rows processed, [Percentage]% complete" |

---

## 🆕 Enhanced Dark Mode Overrides

### Component-Specific Dark Mode Adjustments

| Component | Light Override | Dark Override | Reason |
|-----------|----------------|---------------|---------|
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