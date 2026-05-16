# Design System Specification: High-End Cultural Editorial

## 1. Overview & Creative North Star
**Creative North Star: The Modern Sanctuary**

This design system is a rejection of the "transactional" nature of modern apps. Instead of a rigid grid of utilitarian buttons, we aim for a **Digital Sanctuary**—an experience that feels curated, breathable, and deeply resonant with cultural heritage. 

To achieve this, we move beyond "standard" UI through **High-End Editorial** principles:
*   **Intentional Asymmetry:** Break the monotony of centered grids. Use off-center typography and staggered image placements to evoke the feel of a premium travel journal.
*   **Layered Tactility:** We treat the screen not as a flat surface, but as a series of physical materials—fine parchment, silk overlays, and honed stone.
*   **Atmospheric Breathing Room:** Space is not "empty"; it is "serene." We use generous padding to allow the content to radiate importance.

---

## 2. Colors & Surface Philosophy
The palette is grounded in the earth and the sun. It balances the weight of tradition (`primary` Saffron and `tertiary` Terracotta) with the lightness of spiritual clarity (`background` Cream).

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders for sectioning or containment. Boundaries must be defined solely through:
1.  **Tonal Shifts:** Placing a `surface-container-low` card against a `surface` background.
2.  **Negative Space:** Using the spacing scale to create psychological boundaries.

### Surface Hierarchy & Nesting
Treat the UI as a series of stacked sheets.
*   **Base:** `surface` (#faf9f6) is your canvas.
*   **Lower Elevation:** Use `surface-container-low` for large, non-interactive background areas.
*   **Active Elevation:** Use `surface-container-lowest` (#ffffff) for primary cards to create a subtle, natural "pop" against the cream base.

### The Glass & Gradient Rule
To move beyond a flat appearance:
*   **CTAs:** Use a subtle linear gradient from `primary` (#a14009) to `primary-container` (#ff9768) at a 135-degree angle to give buttons a "glowing" soul.
*   **Overlays:** Use **Glassmorphism** for floating navigation bars or top headers. Apply `surface` at 80% opacity with a `20px` backdrop-blur. This ensures the earthy colors of the content bleed through, maintaining a sense of place.

---

## 3. Typography
We pair the timeless authority of a Serif with the modern efficiency of a Geometric Sans-Serif.

*   **Display & Headline (Noto Serif):** These are our "Voice of Tradition." Use `display-lg` for hero cultural insights and `headline-sm` for temple titles. The generous x-height and elegant serifs provide the "soul."
*   **Body & Labels (Manrope):** Our "Voice of Clarity." `manrope` provides a high-legibility contrast. Use `body-lg` for storytelling and `label-sm` for functional metadata.
*   **Editorial Scaling:** Do not be afraid of the contrast between a `display-md` headline and a `body-sm` caption. This high-contrast ratio is what creates the "premium magazine" feel.

---

## 4. Elevation & Depth
Depth in this system is organic, not artificial.

### The Layering Principle
Hierarchy is achieved by "stacking" container tiers. Place a `surface-container-highest` element (like a featured search bar) over a `surface-container` background to create a soft, tactile lift.

### Ambient Shadows
If a "floating" effect is mandatory (e.g., a Bottom Sheet or a floating Action Button):
*   **Color:** Shadow must be a tinted version of `on-surface` (e.g., `#1a1c1a` at 6% opacity).
*   **Blur:** Minimum `32px` blur with a `12px` Y-offset. Shadows should feel like ambient light hitting a physical object, not a digital drop shadow.

### The "Ghost Border" Fallback
If accessibility requires a container definition in low-contrast scenarios, use a **Ghost Border**:
*   Token: `outline-variant` (#dbc2b0)
*   Opacity: **Strictly 15%**. It should be felt, not seen.

---

## 5. Components

### Buttons
*   **Primary:** Rounded `lg` (1rem). Gradient fill (`primary` to `primary-container`). Typography: `label-md` in `on-primary` (#ffffff), all-caps with 0.05em letter spacing.
*   **Secondary:** No fill. `Ghost Border` (15% opacity `outline-variant`). Typography: `primary` (#a14009).
*   **Tertiary:** Text-only with a subtle `primary` underline that expands on hover.

### Cards & Discovery Tiles
*   **Rule:** Forbid divider lines.
*   **Style:** Use `surface-container-lowest` with a `xl` (1.5rem) corner radius. 
*   **Imagery:** Use a subtle `inner-shadow` or a 5% black overlay on images to ensure `headline-sm` text (in `surface`) is readable when overlaid on photography.

### The "Cultural Scroll" (Custom Component)
A horizontal list of temple highlights using `surface-container-low`. Instead of standard scrollbars, use a thin `secondary` (Gold) progress indicator at the bottom to mirror a traditional scroll.

### Input Fields
*   **Style:** Minimalist. No bottom line or box. Use a `surface-container-highest` background with a `md` (0.75rem) radius.
*   **Focus:** Transition the background to `primary-fixed` (#ffdbcd) to signal warmth and attention.

---

## 6. Do’s and Don’ts

### Do:
*   **Use High-Resolution Photography:** The system relies on the colors within the photos to "bleed" through the glassmorphic elements.
*   **Embrace White Space:** If a screen feels "empty," it’s likely working. Avoid the urge to fill it with "engagement" modules.
*   **Soft Corners:** Use the `xl` (1.5rem) radius for major containers to evoke the softness of silk and organic stone.

### Don’t:
*   **No Pure Black:** Never use #000000. Use `on-surface` (#1a1c1a) for text to maintain a "printed on paper" look.
*   **No Rigid Grids:** Avoid perfectly symmetrical 2x2 grids. Try 1.5x scaling or staggered masonry for image galleries to feel more "soulful."
*   **No High-Contrast Dividers:** If you need to separate content, use a 24px-48px gap or a subtle shift from `surface` to `surface-container-low`. Never a grey line.