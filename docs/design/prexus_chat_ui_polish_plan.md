# PREXUS Chat UI Polish Plan

## Purpose

This document turns the current wireframe concept into an implementation-ready UI refinement plan for the PREXUS chat surface.

Reference wireframe:

- `docs/design/prexus-chat-wireframe-v1.png`

The goal is not decorative redesign. The goal is to make the current routing-aware chat UI feel:

- calmer
- more product-like
- more legible
- more Apple-like
- more coherent with PREXUS as a runtime, not a generic chat app

## Design Intent

The polished chat surface should communicate three layers clearly:

1. **Conversation**
   - the main focus
2. **Runtime state**
   - visible, but compact
3. **Composer / control surface**
   - unified and low-friction

The screen should feel precise and quiet rather than dashboard-like.

## Target Structure

### 1. Header

Current state:

- large `PREXUS` title
- settings icon

Polish direction:

- keep strong branding, but reduce visual heaviness
- align title and settings icon in a more compact top bar
- avoid oversized dead space above the first message

Implementation notes:

- reduce vertical empty space before conversation content
- keep the gear icon, but align spacing and touch target to match the title rhythm

### 2. Runtime Status

Current state:

- route/runtime information appears as textual banners

Polish direction:

- convert status information into compact badges or chips
- keep state visible without feeling like a debug console

Desired content:

- execution mode badge
- route tier badge
- optional restricted/fallback badge when relevant

Implementation notes:

- prefer short labels such as:
  - `Local runtime`
  - `Cloud`
  - `Fallback`
  - `Tier 2`
  - `Restricted`
- avoid long stacked paragraphs in the status area

### 3. Message Area

Current state:

- all messages share similar visual weight

Polish direction:

- create clearer distinction between:
  - system
  - user
  - assistant

Desired hierarchy:

- system message: light, almost informational
- user message: slightly stronger anchoring
- assistant message: primary response surface

Implementation notes:

- preserve calm monochrome styling
- use spacing, bubble density, and alignment rather than loud color
- keep text selection enabled for useful outputs

### 4. Route Preview Card

Current state:

- planned/executing route appears in a banner with text summaries

Polish direction:

- make this feel like a compact planning card
- group route, tier, and sensitivity into a coherent block

Desired structure:

- title: `Planned Route` or `Executing Route`
- small badges:
  - route target
  - tier
  - sensitivity
- short reason summary beneath

Implementation notes:

- chips should carry the scan value
- reason text should remain secondary
- the card should feel integrated with the composer, not like a detached debug panel

### 5. Composer Card

Current state:

- sensitivity control, helper text, text field, and send button are separate pieces

Polish direction:

- unify them into one rounded composer card
- make the lower area feel intentional and premium

Desired structure:

- sensitivity control at top of card
- one-line helper text under it
- multiline input area
- send button aligned inside the same overall card group

Implementation notes:

- keep the current menu fallback for narrow layouts
- maintain accessibility and tap comfort
- sending state should animate naturally through button/progress replacement

### 6. Typography and Spacing

Polish direction:

- tighten vertical rhythm
- reduce abrupt jumps between large title text and small captions
- standardize spacing between:
  - sections
  - cards
  - labels
  - helper copy

Implementation notes:

- prefer fewer text sizes used more consistently
- captions should explain, not dominate
- primary content should stay dense but breathable

## Implementation Phases

### Phase 1 — Composer consolidation

Scope:

- wrap sensitivity control, helper text, text field, and send button into a single composer card
- normalize padding, corner radius, and spacing

Expected outcome:

- bottom control surface feels intentionally designed

### Phase 2 — Message hierarchy

Scope:

- restyle system / user / assistant messages
- tune alignment and weight differences

Expected outcome:

- conversation becomes easier to scan

### Phase 3 — Runtime and route chips

Scope:

- refactor status and route banners into chip-based summaries
- reduce debug-like text density

Expected outcome:

- routing awareness remains visible without feeling technical

### Phase 4 — Final spacing pass

Scope:

- tune header spacing
- tune section gaps
- check iPhone 16 and narrow-layout behavior

Expected outcome:

- the whole screen feels cohesive

## Constraints

- keep routing transparency
- do not hide sensitivity state
- do not move routing logic into UI
- preserve local-first product framing
- preserve narrow-width fallback behavior
- avoid decorative gradients, noisy shadows, or gamified styling

## Acceptance Criteria

The polish pass is successful when:

- the screen reads as a product UI, not a debug surface
- routing state is still understandable at a glance
- the composer feels like a single control surface
- system / user / assistant messages are visually distinguishable
- iPhone 16 layout remains clean
- narrow-width fallback still works

## Suggested Next Step

Implement **Phase 1 — Composer consolidation** first.

That gives the highest visual improvement with the lowest architectural risk.
