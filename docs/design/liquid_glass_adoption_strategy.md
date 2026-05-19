# PREXUS Liquid Glass Adoption Strategy

## Purpose

This document defines how PREXUS should adopt Apple’s Liquid Glass visual language on iPhone without losing:

- local-first product identity
- high information density
- calm readability
- runtime-first hierarchy

The goal is not to make PREXUS look flashy. The goal is to use Liquid Glass selectively where it improves hierarchy and touch affordance.

## Design Position

PREXUS should adopt **selective Liquid Glass**, not full-surface Liquid Glass.

The intended rule is:

- **controls and navigation may use Liquid Glass**
- **content surfaces should mostly avoid it**

This follows Apple’s current guidance that Liquid Glass works best as a functional layer above content, not as a material spread across the content layer itself.

## Product Fit

PREXUS is:

- iPhone-only
- Apple-like in interaction tone
- runtime-centric rather than chat-decorative
- dense in information, but expected to feel calm

Because of that, Liquid Glass is a good fit for:

- navigational chrome
- control surfaces
- transient runtime indicators

It is a poor fit for:

- long reading surfaces
- multi-card information walls
- persistent message backgrounds
- diagnostics-heavy screens with already high visual density

## Core Principle

Use Liquid Glass only where it helps separate **functional UI** from **content UI**.

For PREXUS, this means a two-layer model:

1. **Function layer**
   - header
   - toolbar
   - composer controls
   - route / runtime chips
   - settings entry surfaces

2. **Content layer**
   - conversation text
   - memory entries
   - diagnostics lists
   - long-form summaries

The function layer may adopt Liquid Glass. The content layer should stay simpler and more stable.

## Adoption Goals

### 1. Strengthen hierarchy

Liquid Glass should make PREXUS feel like:

- controls float above content
- navigation is lighter
- runtime actions feel tactile

### 2. Preserve readability

The user must still be able to:

- scan messages quickly
- read diagnostics and memory entries without visual noise
- distinguish response content from runtime chrome

### 3. Preserve calmness

PREXUS should not become glossy, animated, or ornamental.

The result should feel:

- restrained
- native
- low-friction
- precise

## Recommended Adoption Areas

### Priority 1 — Safe adoption

These are the best first targets.

#### Header / top navigation

Use Liquid Glass styling for:

- title bar treatment
- settings button container
- compact navigation chrome

Why:

- this is a standard functional layer
- it benefits from separation above scrolling content

#### Composer control surface

Use Liquid Glass styling for:

- sensitivity selector container
- send action area
- unified composer shell

Why:

- this is an interaction-heavy surface
- it should feel tactile and premium

#### Runtime / route chips

Use Liquid Glass selectively for:

- route badges
- execution state badges
- provider / fallback badges

Why:

- these are short-lived status indicators
- they benefit from looking interactive and distinct from content

### Priority 2 — Likely good

#### Settings intro / control summaries

Use Liquid Glass for:

- top-level settings summary panels
- high-priority controls

Why:

- these are still closer to navigation and policy controls than to reading content

### Priority 3 — Cautious experimentation

#### Temporary overlays

Examples:

- route preview overlays
- focused selection affordances
- contextual command surfaces

Why:

- transient surfaces often fit the material well
- but should be tested carefully for distraction

## Areas To Avoid

### Do not apply Liquid Glass broadly to:

- assistant message bubbles
- user message bubbles
- diagnostics rows
- memory entry cards
- long text cards
- full-screen backgrounds

Reason:

- these belong to the content layer
- glass in these surfaces increases visual complexity and reduces reading comfort

## Screen-by-Screen Guidance

### Chat

Recommended:

- header chrome
- composer chrome
- status chips
- route preview controls

Avoid:

- applying Liquid Glass to the whole conversation area
- glass-heavy message bubbles

### Settings

Recommended:

- custom header
- top summary surface
- control grouping accents

Avoid:

- every Form section becoming glass-like

### Diagnostics

Recommended:

- top summary indicators only

Avoid:

- glass on every row/card in the history list

### Memory

Recommended:

- top summary indicators only

Avoid:

- glass on each stored memory card

## Implementation Guidance

### Prefer system adoption first

PREXUS should first rely on:

- standard SwiftUI navigation elements
- standard bars and toolbars
- standard controls that automatically adopt the new material

Only after that should PREXUS add custom Liquid Glass treatments.

### Use custom glass sparingly

When PREXUS applies custom glass effects:

- apply them to the highest-value interactive surfaces only
- avoid stacking multiple glass layers in one viewport
- avoid combining glass, gradients, and heavy shadows together

### Respect accessibility adaptation

Any adoption must be checked with:

- Reduce Transparency
- Reduce Motion
- different contrast settings

If a PREXUS surface only looks correct when transparency is fully enabled, it is too dependent on the effect.

## Phased Adoption Plan

### Phase 1

Adopt Liquid Glass through standard system behavior and minimal custom styling on:

- header
- composer
- route/runtime chips

### Phase 2

Review Settings top surfaces and summary panels for selective adoption.

### Phase 3

Evaluate whether temporary overlays or command surfaces need custom glass effects.

## Acceptance Criteria

Liquid Glass adoption is successful when:

- PREXUS feels more native on the latest iPhone OS
- controls are more clearly separated from content
- reading comfort does not regress
- the interface still feels calm and runtime-focused
- compact-width layouts remain stable
- accessibility settings do not break hierarchy

## Decision Summary

PREXUS should use Liquid Glass as a **functional accent layer**, not as a global visual theme.

In short:

- **yes** to selective adoption
- **no** to full-surface adoption
- **yes** to headers, composer, and status surfaces
- **no** to message content and dense information cards
