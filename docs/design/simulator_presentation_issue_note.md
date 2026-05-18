# PREXUS Simulator Presentation Issue Note

## Issue

During iPhone SE (3rd generation) live screenshot capture on 2026-05-18, the rendered PREXUS app surface appeared with black bands above and below the visible content.

## What Was Observed

- PREXUS itself launched successfully
- compact-width Chat layout remained readable
- the header, system bubble, sensitivity control, helper text, input field, and send button all fit
- despite that, screenshots still showed black bands outside the rendered content region

## What Was Already Checked

- a temporary full-height `ChatView` adjustment was tested
- that adjustment did **not** remove the black bands
- the experiment was reverted immediately

## Current Interpretation

Treat this as a **simulator/runtime presentation issue** until proven otherwise.

Reasons:

- the actual PREXUS UI components fit within compact width
- the behavior did not respond to a direct top-level `ChatView` sizing adjustment
- the problem appeared during screenshot/live presentation rather than as a normal layout overflow symptom

## Non-Goal

Do not use this note to justify unrelated Chat or Settings layout changes.

This issue should remain separate from:

- ordinary visual polish work
- card/chip hierarchy changes
- surface consistency work
- compact-width readability work

## Follow-up Trigger

Investigate this note further only if one of the following becomes true:

- the same black-band behavior appears on other surfaces or device classes
- the behavior appears in contexts other than the current simulator capture path
- visual documentation requires pixel-accurate full-frame screenshots

## Suggested Next Investigation

If the issue needs deeper work later, check:

- simulator display scaling / window presentation behavior
- screenshot capture path assumptions
- container / safe-area behavior at the root view level
- whether the issue reproduces outside the current capture workflow
