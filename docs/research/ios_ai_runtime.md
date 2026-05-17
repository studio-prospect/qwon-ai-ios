# iOS AI Runtime

## Purpose

This note frames PREXUS as an iPhone runtime problem, not just a model integration problem. The iOS environment shapes architecture decisions around memory, lifecycle, background behavior, permissions, and thermal constraints.

## Runtime Reality on iPhone

An iPhone AI runtime must assume:

- limited RAM compared with desktop environments
- thermal throttling under sustained inference
- strict app lifecycle constraints
- intermittent network conditions
- permission-gated access to microphone and camera
- user sensitivity to battery drain

Any PREXUS design that ignores these constraints will fail regardless of model quality.

## Architectural Implications

### 1. Runtime must stay modular

The iOS app shell should not own core orchestration logic. Runtime modules should stay separate so the app can:

- load only what is needed
- release heavy components aggressively
- evolve inference pipelines without UI coupling

### 2. Event-driven execution is mandatory

PREXUS should prefer:

- async streams
- bounded tasks
- on-demand model loading
- explicit lifecycle-aware activation

Avoid:

- continuous polling
- always-active heavy workers
- long-running monolithic pipelines

### 3. Dynamic resource management matters

The runtime should be designed around:

- model loading and unloading
- staged preprocessing
- cache bounds
- graceful degradation under pressure

Large models or indexes should not be kept alive without a strong reason.

## Runtime Subsystems on iOS

### UI runtime surface

Responsibilities:

- input capture
- response rendering
- permission onboarding
- settings and policy controls

Should not own:

- routing decisions
- memory logic
- provider selection logic

### Orchestrator runtime

Responsibilities:

- normalize input events
- evaluate route candidates
- coordinate compression, memory, and cloud escalation
- emit structured telemetry for decisions

This should remain lightweight enough to react quickly even when heavier modules are unloaded.

### Inference runtime

Responsibilities:

- local model lifecycle
- streaming output generation
- cloud adapter execution
- fallback handling

### Multimodal runtime

Responsibilities:

- ASR
- OCR
- basic vision preprocessing
- sensor signal summarization

It should produce compact structured outputs rather than heavy raw artifacts whenever possible.

## App Lifecycle Considerations

PREXUS should explicitly design for:

- foreground-first interaction
- careful handling of interruptions
- safe resumption after suspension
- minimal reliance on unrestricted background execution

Always-on intelligence should begin as a constrained architectural direction, not as an immediate heavy implementation.

## Permission Model

The runtime will depend on:

- microphone access
- camera access
- possibly notifications or shortcuts in later phases

Implication:

- capabilities must degrade gracefully when permissions are denied
- the app should still provide useful text-first functionality

## Storage Considerations

Likely local storage categories:

- API key references and secrets via Keychain
- memory and metadata in app-local persistent storage
- embeddings and indexes in bounded local storage
- cached model assets and intermediate artifacts with explicit cleanup strategy

Storage policy should prefer:

- compact representations
- explicit retention boundaries
- user-visible deletion paths

## Networking Considerations

PREXUS should assume the network may be:

- unavailable
- slow
- expensive
- unreliable

This reinforces the need for:

- local-first routing
- compact cloud requests
- local fallback behavior
- resumable and observable cloud execution paths

## Performance Research Topics

Areas worth measuring early:

- cold-start vs warm-start model latency
- first-token latency
- memory pressure during model switching
- OCR and ASR cost under repeated use
- UI responsiveness under streaming
- thermal behavior across short and long sessions

## MVP Recommendation

For MVP, favor a runtime shape that is:

- foreground-centric
- modular
- stream-capable
- conservative in background behavior
- robust under offline conditions

Do not design the initial runtime as if iPhone were a desktop-class always-on agent host.
