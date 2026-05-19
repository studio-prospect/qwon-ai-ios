# Agent Collaboration Workflow

## Purpose

This document defines how PREXUS work is split between the planning/review agent and the implementation agent.

The goal is to keep:

- architecture and product intent coherent
- implementation work fast
- PR quality consistently reviewed before merge

## Role Split

### Codex

Codex is responsible for:

- architecture and design decisions
- implementation planning
- task decomposition
- acceptance criteria
- PR review
- quality evaluation
- merge decisions and merge execution

Codex should act as the planning and governance lane, not the primary implementation lane.

### Cursor

Cursor is responsible for:

- implementing approved tasks
- applying code changes
- iterating on requested fixes
- updating the branch until the PR is ready for review

Cursor should treat Codex plans and review feedback as the source of truth for the current task.

## Default Delivery Flow

### 1. Task definition

The user brings a feature, bug, cleanup, or follow-up task to Codex.

Codex then produces:

- scope definition
- design guidance
- implementation plan
- risks
- validation steps

### 2. Implementation handoff

The approved plan is handed to Cursor.

Cursor performs:

- code changes
- local iteration
- branch updates
- PR creation

### 3. PR review

Once Cursor opens a PR, Codex reviews:

- correctness
- architecture fit
- regression risk
- test coverage
- documentation impact

Codex should call out:

- blocking issues that must be fixed before merge
- non-blocking follow-ups that can land later

### 4. Merge gate

Codex merges only when all of the following are true:

- blocking review items are resolved
- required tests or verification steps are reported
- the PR matches the agreed implementation plan, or deviations are explicitly accepted

### 5. Post-merge follow-up

If the PR exposes follow-up work, Codex should:

- identify the next task
- decide whether it is implementation work for Cursor
- or a planning / policy / review task for Codex

## Practical Rules

### Codex should own

- cross-file design changes
- runtime policy decisions
- routing / memory / privacy semantics
- PR quality judgment
- merge readiness

### Cursor should own

- day-to-day code edits
- patch application
- implementation iteration
- branch maintenance during active coding

### Escalation rule

If implementation reveals ambiguity that changes product behavior, Cursor should not invent policy. That decision returns to Codex.

Examples:

- a routing policy choice changes local vs cloud behavior
- a memory retention choice changes privacy behavior
- a UI behavior change creates a new product contract

## PR Review Standard

When Codex reviews a PR, the review should explicitly answer:

1. Is the implementation correct?
2. Does it match PREXUS architecture and local-first policy?
3. Are the tests and verification results sufficient?
4. Is the PR safe to merge now?
5. What, if anything, should be deferred into a follow-up?

## Merge Policy

Codex is the merge authority in this workflow.

That means:

- Cursor may prepare branches and PRs
- Codex decides whether the PR is ready
- Codex performs or authorizes the merge step

## Notes

- This workflow is intended to reduce design drift while keeping implementation throughput high.
- It is acceptable for Codex to make small repo-local documentation or planning edits directly.
- The default assumption is: **Codex plans and reviews, Cursor implements.**
