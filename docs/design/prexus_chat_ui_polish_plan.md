# PREXUS Chat UI Polish Plan

## Purpose

This document turns the current wireframe concept into an implementation-ready UI refinement plan for the PREXUS chat surface.

Reference wireframe:

- `docs/design/prexus-chat-wireframe-v1.png`
- Liquid Glass adoption strategy: `docs/design/liquid_glass_adoption_strategy.md`
- operational verification notes: `docs/design/runtime_surface_verification_notes.md`
- capture workflow note: `docs/design/runtime_surface_capture_workflow.md`
- capture index: `docs/design/runtime_surface_capture_index.md`
- simulator presentation issue note: `docs/design/simulator_presentation_issue_note.md`
- current exported runtime captures:
  - `docs/design/runtime-surface-captures/iphone16/`
  - `docs/design/runtime-surface-captures/iphonese3/`

The goal is not decorative redesign. The goal is to make the current routing-aware chat UI feel:

- calmer
- more product-like
- more legible
- more Apple-like
- more coherent with PREXUS as a runtime, not a generic chat app

## Current Implementation Status

As of 2026-05-19, the current iOS scaffold has completed the first wave of polish work:

- chat composer consolidated into a single control surface
- system / user / assistant conversation hierarchy tuned
- runtime status and route preview converted to chip-based summaries
- custom chat header added to reduce dead space and strengthen branding
- shared `PREXUSSurfaceCard` / `PREXUSStatusChip` primitives adopted across Chat, Settings, Diagnostics, and Memory
- compact-width fallbacks added for summary cards and previews
- branded empty states added for Diagnostics and Memory
- secondary runtime surfaces now begin with a screen intro instead of raw card lists
- Settings now opens with a branded runtime intro, descriptive PREXUS section headers, and a custom PREXUS-owned header
- live compact-width verification completed on iPhone SE (3rd generation)
- exported runtime-surface captures now exist for both iPhone 16 and iPhone SE (3rd generation)

This means the original Phase 1–4 chat polish scope is functionally complete, and the current work has expanded into app-level surface consistency.

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

Status:

- completed

### Phase 2 — Message hierarchy

Scope:

- restyle system / user / assistant messages
- tune alignment and weight differences

Expected outcome:

- conversation becomes easier to scan

Status:

- completed

### Phase 3 — Runtime and route chips

Scope:

- refactor status and route banners into chip-based summaries
- reduce debug-like text density

Expected outcome:

- routing awareness remains visible without feeling technical

Status:

- completed

### Phase 4 — Final spacing pass

Scope:

- tune header spacing
- tune section gaps
- check iPhone 16 and narrow-layout behavior

Expected outcome:

- the whole screen feels cohesive

Status:

- completed for the current iPhone 16-targeted scaffold
- compact-width code fallbacks are implemented
- live SE-class simulator verification completed on 2026-05-18

### Phase 5 — Cross-surface consistency

Scope:

- unify card, chip, empty-state, and intro patterns across Settings, Diagnostics, and Memory
- reduce “mixed system UI vs product UI” feel in secondary surfaces

Expected outcome:

- the app feels like one product instead of one polished chat screen plus utility screens

Status:

- largely completed in the current scaffold
- Settings has also been pulled closer to the shared product language through a branded intro card, descriptive section headers, and a custom header that matches Chat more closely

### Phase 6 — Visual verification and final tuning

Scope:

- re-run live simulator checks once CoreSimulatorService is stable
- validate compact layouts on SE-class devices
- capture final screenshots for design docs if needed

Expected outcome:

- implementation evidence matches the intended polish direction across device sizes

Status:

- compact-width live verification completed on iPhone SE (3rd generation)
- automated runtime-surface capture is now in place for both iPhone 16 and iPhone SE (3rd generation)
- additional devices remain optional unless a new layout class needs dedicated evidence

## Live Verification Notes

For current operational details, use:

- `docs/design/runtime_surface_verification_notes.md`
- `docs/design/runtime_surface_capture_workflow.md`
- `docs/design/simulator_presentation_issue_note.md`

Verified on 2026-05-19:

- iPhone 16 simulator regression checks remained green through the full polish pass
- iPhone SE (3rd generation) live and automated captures confirmed that the chat header, system bubble, sensitivity control, helper text, input field, and send button fit without layout breakage
- compact-width fallback behavior is now backed by both code paths and exported simulator captures
- Settings has been further polished with a branded runtime intro, descriptive PREXUS section headers, and a custom header, with code validation complete

Observed note:

- the SE simulator screenshots showed black bands above and below the rendered app surface during this session
- a temporary full-height `ChatView` experiment did not change that behavior and was reverted
- treat that as a separate simulator/runtime presentation issue rather than a blocker on the current UI polish pass
- secondary-surface live screenshots are now covered by XCTest UI automation for iPhone 16 and iPhone SE (3rd generation)

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

Additional current criteria:

- Settings, Diagnostics, and Memory should share the same visual language as Chat
- empty states should feel branded rather than default-system
- secondary surfaces should explain their purpose before showing raw runtime data

## Suggested Next Step

1. use `runtime_surface_capture_workflow.md` to refresh exported screenshots whenever a surface materially changes
2. if a new device class matters, extend the current UI smoke rather than reintroducing ad-hoc manual capture steps
3. if the black-band simulator behavior recurs, investigate it through `simulator_presentation_issue_note.md` rather than mixing it into UI polish work
4. keep this plan focused on design state, and move operational verification detail into dedicated notes
