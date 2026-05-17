# Requirements v0.1

## Objective

This document defines the v0.1 product and runtime requirements for PREXUS. It translates the high-level concept into implementation-focused MVP requirements.

PREXUS is a local-first AI runtime for iPhone centered on:

- local inference
- semantic routing
- multimodal preprocessing
- context compression
- selective memory
- cloud escalation only when necessary

## Product Definition

PREXUS is not a generic chat app. It is a persistent cognitive runtime layer that uses a local model as a control plane and inference path, while selectively orchestrating cloud models for tasks that exceed local capability.

The product should optimize for:

- low latency
- privacy
- offline utility
- battery efficiency
- low token usage
- minimal user model-management burden

## Primary Users

v0.1 targets advanced users, especially:

- software developers
- AI power users
- researchers
- creators
- users comfortable with API keys and model workflows

It does not target beginner or zero-config casual users in the initial phase.

## Platform Scope

Initial platform:

- iPhone
- recent iOS devices with sufficient RAM and Neural Engine capability

Out of scope for v0.1:

- broad legacy device support
- desktop-first product behavior
- cross-platform parity

## Core Product Requirements

### 1. Local-first runtime

The system must:

- handle common requests locally by default
- support offline basic usage
- avoid unnecessary cloud calls
- keep local inference as the default execution path

### 2. Semantic routing

The system must:

- classify requests locally
- choose local or cloud execution automatically
- account for privacy, latency, and complexity
- route to the most suitable provider when escalation is needed

### 3. Context compression

The system must:

- reduce cloud token usage before escalation
- summarize or filter conversation history
- deduplicate repeated content
- convert large local context into compact prompt blocks

Target direction:

- meaningful token reduction relative to naive full-history forwarding

### 4. Multimodal input

The system must support:

- text input
- voice input
- camera input
- OCR
- basic vision-driven tasks

### 5. Local memory

The system must:

- store useful memory locally
- retrieve relevant prior context
- allow user deletion and control
- avoid storing everything indiscriminately

### 6. Cloud provider integration

The system must support user-configured API access for:

- OpenAI
- Anthropic
- Gemini, if integrated in the selected milestone

Security requirements:

- API keys stored in Keychain
- external transmission controlled by runtime policy

## Functional Requirements

### Text Interaction

Required:

- chat-style input UI
- Markdown-capable rendering
- conversation history
- streaming response rendering

### Audio Interaction

Required:

- local ASR
- low-latency voice capture
- wake-word-oriented architecture path

Deferred:

- speaker recognition
- emotional inference
- translation

### Vision Interaction

Required:

- image input
- OCR
- basic image understanding
- real-time analysis path for selected use cases

### Model Routing

Required:

- local classification
- local vs cloud decision
- provider-specific routing heuristics
- privacy-aware escalation gates

### Memory

Required:

- episodic memory creation
- local embeddings
- vector retrieval
- deletable memory records

### Offline Capability

Required offline baseline:

- basic conversation
- OCR
- voice input
- local search and recall
- memory-backed continuity where possible

## Non-Functional Requirements

### Latency

The product should prioritize:

- fast local response
- immediate wake response characteristics
- reduced wait time for common tasks

### Battery

The runtime must:

- keep always-on layers lightweight
- use event-driven activation
- control inference frequency
- avoid unnecessary background loops

### Memory Footprint

The runtime must:

- dynamically load heavy models
- avoid permanently loaded large assets
- bound caches
- keep embeddings and indexes manageable on-device

### Privacy

The system must:

- prefer local execution for sensitive tasks
- minimize cloud transmission
- expose controllable escalation boundaries
- treat stored user data as sensitive

## Architectural Requirements

The implementation should preserve clear separation across:

- UI
- orchestrator
- memory
- multimodal
- LLM adapters
- RAG

The product should avoid:

- giant manager classes
- UI-owned orchestration logic
- blind prompt forwarding to cloud

## MVP Scope

v0.1 MVP should include:

- iPhone app shell
- local inference path
- automatic routing between local and cloud
- OpenAI and Anthropic connectivity
- context compression
- local memory baseline
- OCR and basic vision input
- API key configuration

Optional in MVP depending on execution cost:

- Gemini integration
- wake word beyond prototype quality

## MVP Success Criteria

v0.1 should be considered successful when:

- iPhone-only local conversation is usable
- routing works without frequent manual model selection
- cloud escalation is selective rather than default
- token reduction is measurable
- offline baseline is practical
- OCR and image input are useful
- latency feels materially better than cloud-only flows

## Known Risks

Key risks for v0.1:

- iPhone RAM pressure
- thermal throttling
- battery drain from always-on features
- model switching overhead
- local model quality limits
- App Store policy constraints

## v0.1 Non-Goals

The following are explicitly out of scope for v0.1:

- generic social AI features
- desktop-centric architecture
- full autonomous agent platform
- cloud-first conversation model
- storing all user activity indefinitely

## Implementation Priorities

Priority order for execution:

1. Local inference foundation
2. Routing and escalation policy
3. Context compression
4. API key management
5. Battery-aware runtime behavior
6. Vision baseline
7. Voice baseline
8. RAG and deeper memory behavior
