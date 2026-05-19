# Architecture

## Objective

PREXUS is not a generic chat client. It is a local-first cognitive runtime for iPhone that keeps a lightweight intelligence layer close to the user and escalates to cloud models only when necessary.

Primary architectural goals:

- Local-first execution
- Low latency interaction
- Privacy-preserving processing
- Battery-aware runtime behavior
- Bounded memory growth
- Minimal cloud token usage

## System View

```text
User Input
  ├─ Text
  ├─ Voice
  ├─ Camera
  └─ Sensors
      ↓
UI Layer
      ↓
Local Runtime Entry
      ↓
Orchestrator
  ├─ Intent Analysis
  ├─ Task Classification
  ├─ Policy Evaluation
  ├─ Context Compression
  ├─ Memory Recall
  ├─ Multimodal Preprocessing
  └─ Model Routing
      ├─ Tier 1: Always-on lightweight detection
      ├─ Tier 2: Local inference
      └─ Tier 3: Cloud escalation
              ├─ OpenAI
              ├─ Anthropic
              ├─ Gemini
              └─ LAN / external local models
```

## Runtime Layers

### 1. UI Layer

Responsibility:

- Capture user intent through text, voice, and camera
- Render streaming responses
- Expose memory and privacy controls
- Avoid containing orchestration logic

Constraints:

- UI remains thin
- Business logic stays in `runtime/`
- Model selection is mostly hidden from end users

### 2. Orchestrator Layer

Responsibility:

- Normalize incoming events
- Decide whether the request can be handled locally
- Build compact, structured context
- Route work to memory, multimodal, RAG, or LLM subsystems
- Enforce privacy and cost policies

This is the core of PREXUS. The orchestrator is the decision plane, not the UI.

### 3. Inference Layer

Responsibility:

- Execute local model inference for common tasks
- Escalate complex tasks to cloud providers
- Select the correct adapter and prompt shape per provider

The local model is not just a responder. It acts as a control model for classification, summarization, compression, and routing.

### 4. Memory Layer

Responsibility:

- Persist local-only user memory
- Convert relevant interaction fragments into embeddings
- Support selective recall for future requests
- Delete or prune memory under user control

### 5. Multimodal Layer

Responsibility:

- OCR
- Vision preprocessing
- Audio capture and transcription
- Sensor fusion for context-aware tasks

Multimodal processing should happen as close to the device as possible to reduce cloud payload size.

## Inference Tiers

### Tier 1: Always-on lightweight layer

Examples:

- Wake word detection
- Event detection
- Low-power intent detection

Requirements:

- Minimal energy usage
- Fast startup
- Small memory footprint

### Tier 2: Local inference layer

Examples:

- Basic conversation
- Summarization
- OCR post-processing
- Context compression
- Embeddings
- Lightweight RAG

Requirements:

- Default path for most user requests
- Works offline
- Supports streaming where possible

### Tier 3: Cloud inference layer

Examples:

- Deep reasoning
- Long-context analysis
- Large code analysis
- High-quality writing
- High-precision vision

Requirements:

- Enter only after routing and policy checks
- Send compressed and filtered context
- Use provider-specific adapters

## Core Modules

### `runtime/orchestrator/`

Decision engine for:

- intent detection
- route selection
- escalation decisions
- privacy and cost policy checks

### `runtime/memory/`

Local memory system for:

- episodic storage
- vector indexing
- retrieval
- semantic compression of past interactions

### `runtime/multimodal/`

Device-side multimodal stack for:

- audio
- vision
- OCR
- sensors

### `runtime/llm/`

Unified model access layer for:

- local models
- cloud providers
- prompt templates
- adapter interfaces

### `runtime/rag/`

Retrieval pipeline for:

- indexing
- retrieval
- ranking

## Data Flow Principles

### Event-driven execution

PREXUS should prefer:

- async streams
- incremental processing
- on-demand loading
- background work only when justified

Avoid request-response monoliths and continuous polling loops.

### Compression before escalation

Before a request reaches a cloud provider, the runtime should try:

- intent extraction
- duplicate removal
- recent history summarization
- memory recall filtering

## Current v0.1 Implementation Notes

The current iOS scaffold already reflects several runtime boundaries from this document:

- `AppEnvironment` owns configuration and secret wiring
- `RuntimeContainer` (in `runtime/orchestrator/`) builds the runtime graph from config, stores, and adapters
- `RuntimeTurnExecutor` (in `runtime/orchestrator/`) runs the turn pipeline outside the SwiftUI view layer
- `RuntimeMessage` is the neutral transcript type; `ChatMessage` converts at the app boundary
- `AppSettingsStore` persists runtime policy toggles in `UserDefaults`
- `KeychainAPIKeyStore` keeps provider secrets out of app config payloads
- chat UI exposes the latest runtime execution path so local, cloud, and fallback behavior is inspectable during development
- settings UI exposes provider availability so cloud-ready vs local-primary behavior is visible before a turn runs
- settings UI also keeps a lightweight recent diagnostics history for route and execution inspection
- diagnostics history is persisted locally with a bounded entry count and without storing raw cloud-side conversation state

This keeps model routing and persistence concerns out of `View` code while still allowing the UI to expose settings and state.

## Runtime Policy Surface

For v0.1, the user-configurable runtime policy surface is intentionally small:

- `allowsCloudEscalation`
- `maxCloudContextTokens`
- `openAIModel`
- `localModelBackend`
- `approvedProvidersForRestrictedMode`
- provider API key presence

If a route selects a cloud provider but the required key is missing, the runtime falls back to the local model instead of failing the turn. This preserves low-friction operation while keeping cloud access explicit.

The current OpenAI path also prefers privacy-preserving defaults by sending only the compressed runtime prompt and requesting stateless execution instead of relying on provider-side conversation storage.

For local execution, the current scaffold also exposes an explicit backend selection surface so Simulator, embedded heuristic fallback, and future device runtime integration can be separated cleanly.

Cloud-bound prompts are additionally trimmed against `maxCloudContextTokens` before execution so the runtime setting acts as an actual guardrail, not only a UI preference.
- RAG-based narrowing

### Sensitivity Policy Ownership

Sensitivity policy is split intentionally across three layers:

- `ChatView` and `ChatViewModel` expose a per-turn sensitivity override so routing behavior can be inspected and tested interactively
- `AppSettingsStore` owns persisted runtime policy such as cloud escalation, token budget, and the approved-provider allowlist used by restricted routing
- `RuntimeContainer` converts persisted settings into `ExecutionPolicy`, and `RoutingEngine` remains the final authority for route selection

This means the UI may select a sensitivity mode, but the runtime still decides the actual route after applying policy checks, provider restrictions, and fallback rules.

Current ownership rules:

- UI labels and picker affordances may describe sensitivity modes, but they must not define routing behavior on their own
- `providerRestricted` must be enforced by runtime policy, not by view-level conditionals
- if no approved provider matches a restricted turn, the runtime must fail closed to local execution

Cloud models should receive only the minimum context required.

### Privacy-first routing

Sensitive tasks should prefer local-only execution when possible. If a task requires network use, the orchestrator must be able to enforce provider restrictions and user-configured transmission policies.

## iOS-Specific Constraints

- Keep always-on components extremely lightweight
- Avoid large permanently loaded models
- Favor dynamic model loading and release
- Optimize for thermal and battery constraints
- Store secrets in Keychain
- Design for intermittent connectivity

## MVP Architecture Scope

MVP should include:

- Thin iOS chat UI
- Local orchestrator
- Tier 2 local inference path
- OpenAI and Anthropic cloud escalation
- Context compression pipeline
- API key management
- Vision input path

MVP should not depend on:

- full agent framework
- broad background automation
- desktop-first workflows
- large always-on memory graphs

## Architectural Non-Goals

- Cloud-only chat app structure
- Heavy UI-centric business logic
- Blind forwarding of full conversation history
- One giant runtime manager owning all responsibilities

## Recommended Implementation Shape

- Keep modules small and composable
- Prefer protocols and adapters over hard coupling
- Separate policy evaluation from provider execution
- Separate memory retrieval from conversation rendering
- Make every cloud-bound path observable and measurable
