# Battery Strategy

## Purpose

Battery efficiency is a product feature for PREXUS, not a secondary optimization. Because the product aspires to become an always-available intelligence layer, energy behavior must influence architecture from the start.

## Core Principle

Every feature should be evaluated not only by quality and latency, but also by:

- average energy cost
- wake frequency
- sustained thermal impact
- background execution pressure

If a feature requires constant heavy inference to feel useful, it is likely the wrong design for MVP.

## Primary Battery Risks

- always-on wake pipelines
- repeated short inference bursts
- large model residency
- frequent model switching
- continuous sensor capture
- cloud retry loops
- aggressive background maintenance tasks

## Strategy Pillars

### 1. Event-driven activation

Prefer:

- wake-word exploration with strict cost bounds
- explicit user-triggered capture
- sensor-triggered lightweight gating

Avoid:

- continuous heavy model polling
- constant camera analysis
- unnecessary periodic jobs

### 2. Small-on-by-default model policy

The default active stack should be as small as possible.

Implications:

- use tiny classifiers for low-cost decisions
- load larger local models only when the task justifies them
- unload or idle heavy resources promptly after use

### 3. Compression before cloud

Battery strategy is not only about local compute. Large cloud interactions also cost energy through network use and repeated serialization work.

Reducing payloads helps by:

- shortening request time
- lowering network activity
- reducing repeated processing

### 4. Bounded background work

Background tasks should exist only when they deliver clear user value.

Candidates for bounded background behavior:

- lightweight memory maintenance
- deferred indexing under safe conditions
- limited cache cleanup

These should be interruptible and low priority.

## Runtime Tactics

### Model loading

- avoid keeping multiple heavy models resident
- prefer one active model path at a time in MVP
- cache only what has measurable reuse value

### Audio

- keep always-listening ambitions constrained early
- separate low-cost wake detection from heavier ASR
- stop transcription quickly when intent is not present

### Vision

- process on capture or explicit analysis trigger
- prefer single-frame or narrowed-region analysis
- avoid continuous real-time pipelines unless heavily gated

### Memory and indexing

- write only high-value memories
- defer non-urgent embedding work where possible
- suppress duplicates aggressively

## Measurement Areas

Battery strategy should be informed by actual measurement.

Track at minimum:

- idle drain impact
- cost per local inference turn
- cost per OCR event
- cost per voice turn
- cost of model switch
- thermal rise under repeated task loops

## User Experience Tradeoffs

Battery-aware design may require tradeoffs such as:

- slightly slower background updates
- reduced always-on ambition in MVP
- smaller default local model
- limited continuous multimodal monitoring

These tradeoffs are acceptable if they preserve trust and usability over time.

## MVP Recommendation

For MVP:

- prioritize explicit user-triggered interaction over autonomous background behavior
- keep the always-on layer minimal or experimental
- avoid multiple concurrent heavy inference paths
- measure energy cost early before expanding features

Battery-friendly behavior should be treated as a release gate, not a cleanup task.
