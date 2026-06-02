# AGENTS.md

# QWON Development Guide

QWON is a local-first mobile AI runtime for iPhone. **Website:** https://qwon.ai — see [rename migration plan](docs/product/qwon_rename_migration_plan.md) for phased PREXUS → QWON rollout (Bundle ID unchanged until Phase 2).

The project focuses on:
- on-device intelligence
- semantic routing
- multimodal processing
- context compression
- cloud LLM orchestration

The primary goal is NOT to build a generic chat app.
The goal is to build a persistent cognitive runtime layer.

For multi-agent delivery (Codex plans/reviews, Cursor implements), follow [docs/product/agent_collaboration_workflow.md](docs/product/agent_collaboration_workflow.md).

---

# Core Philosophy

Always prioritize:

1. Local-first processing
2. Low latency
3. Privacy preservation
4. Battery efficiency
5. Small memory footprint
6. Clear runtime separation
7. Minimal token usage

Avoid unnecessary cloud usage whenever possible.

---

# Architectural Principles

## Runtime-centric design

Business value lives in:
- runtime/
- orchestrator/
- memory/
- multimodal/

Do NOT tightly couple runtime logic into UI code.

---

## Prefer composition over monoliths

Keep modules isolated:
- routing
- memory
- llm adapters
- vision
- audio
- rag

Avoid giant manager classes.

---

## Event-driven mindset

PREXUS is NOT request/response only.

Prefer:
- async streams
- event pipelines
- lightweight background processing
- reactive architecture

---

# Repository Structure

## Important directories

- app/ios/
  iOS application code

- runtime/
  Core orchestration runtime

- models/
  Local model assets and benchmarks

- experiments/
  Rapid prototyping and evaluation

- docs/
  Requirements and architecture

- website/
  Landing page and marketing assets

---

# Coding Conventions

## Swift

- Prefer Swift Concurrency
- Prefer structs over classes unless shared mutable state is required
- Keep files focused and small
- Avoid force unwraps
- Avoid singleton abuse

## Naming

- Types: PascalCase
- Variables/functions: camelCase
- Constants: lowerCamelCase
- File names should match primary type

---

# UI Principles

UI should feel:
- minimal
- calm
- low-friction
- Apple-like
- information-dense without clutter

Avoid:
- overly gamified UI
- excessive animations
- noisy gradients
- dashboard overload

---

# AI/LLM Guidelines

## Prompt Design

Prompts must be:
- deterministic
- compact
- structured
- reusable

Avoid giant prompts.

Prefer:
- routing policies
- structured context blocks
- layered prompting

---

## Token Usage

Minimize token consumption aggressively.

Always consider:
- summarization
- compression
- deduplication
- retrieval filtering
- semantic extraction

before sending data to cloud models.

---

## Routing

The local orchestrator should decide:
- whether cloud escalation is needed
- which model is best suited
- what context should be included

Do NOT blindly forward entire conversations.

---

# Multimodal Principles

PREXUS uses iPhone as a sensor platform.

Prioritize:
- realtime camera understanding
- low-latency audio handling
- OCR pipelines
- sensor fusion

Design for:
- intermittent connectivity
- offline-first behavior
- background execution constraints

---

# Performance Rules

Battery and thermal limits matter.

Always prefer:
- incremental processing
- lazy loading
- streaming
- lightweight embeddings
- bounded memory growth

Avoid:
- unnecessary background loops
- large always-loaded models
- excessive polling

---

# Security Rules

- Never hardcode API keys
- Use iOS Keychain
- Minimize external transmission
- Treat all user data as sensitive

Privacy is a product feature.

---

# Documentation Rules

When adding major functionality:
- update architecture docs
- document routing implications
- explain memory impact
- explain battery implications

---

# Testing Expectations

Before completing tasks:
- ensure project builds
- run relevant tests
- avoid introducing warnings
- verify no obvious memory regressions

When opening a PR, include concrete test-plan results in the PR body (see `.github/pull_request_template.md`).

If iOS source files or test targets change, regenerate the Xcode project with `ruby tools/scripts/generate_xcodeproj.rb` before review.

---

# Agent Collaboration

- Codex owns planning, architecture-sensitive decisions, PR review, and merge readiness.
- Cursor owns implementation, fix iteration, branch maintenance, and PR preparation.
- Escalate routing, memory retention, and privacy semantics to Codex instead of inventing policy in code.

Full workflow: [docs/product/agent_collaboration_workflow.md](docs/product/agent_collaboration_workflow.md).

---

# Non-Goals

PREXUS is NOT:
- a clone of ChatGPT
- a generic Electron wrapper
- a cloud-only assistant
- a social AI platform

Keep focus on:
local intelligence + orchestration.

---

# Preferred Technologies

- SwiftUI
- Swift Concurrency
- CoreML
- Metal
- MLX
- llama.cpp
- SQLite
- vector embeddings
- streaming inference

---

# Decision Heuristic

When uncertain, prefer:
- simpler architecture
- lower latency
- lower battery usage
- smaller prompts
- local execution
- modular runtime design

over feature complexity.
