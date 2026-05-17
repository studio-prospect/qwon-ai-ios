# Multimodal Strategy

## Objective

PREXUS treats iPhone as a mobile sensor platform, not just a text terminal. Multimodal strategy exists to capture richer context locally, preprocess it efficiently on-device, and hand the orchestrator structured signals instead of raw high-cost payloads whenever possible.

Primary goals:

- local-first multimodal processing
- low-latency capture and interpretation
- privacy-preserving sensor use
- battery-aware continuous readiness
- compact outputs for routing and cloud escalation

## Role of Multimodal Processing

The multimodal layer supports:

- text extraction from camera input
- scene and object understanding
- voice-driven interaction
- environmental and device context awareness
- structured inputs for routing, memory, and RAG

This layer is a preprocessing and interpretation layer. It should reduce cloud dependence, not amplify it.

## Supported Modalities

### Text

Use cases:

- standard chat interaction
- command-like requests
- editing and summarization flows

Output to runtime:

- normalized user request
- intent candidates
- context update

### Audio

Use cases:

- voice input
- wake-word-triggered activation
- hands-free assistant behavior

Required capabilities:

- local ASR
- wake word detection
- low-latency turn capture
- streaming transcription when feasible

Future capabilities:

- speaker recognition
- emotion estimation
- translation

Output to runtime:

- transcript
- confidence score
- timing metadata
- optional speech event markers

### Camera / Vision

Use cases:

- OCR
- document capture
- UI understanding
- object recognition
- technical inspection such as boards, components, and diagrams

Required capabilities:

- image ingestion
- OCR extraction
- basic vision interpretation
- real-time analysis path

Output to runtime:

- extracted text
- bounding or layout structure
- scene summary
- detected objects or entities
- confidence metadata

### Sensors

Use cases:

- context-aware task handling
- motion or environment state awareness
- future event-triggered assistant behavior

Potential signals:

- motion state
- orientation
- device activity context
- temporal cues

Output to runtime:

- lightweight structured context flags
- event hints for routing or activation

## Multimodal Processing Principles

### 1. Local-first interpretation

All feasible preprocessing should happen on-device first:

- OCR
- ASR
- image downselection
- feature extraction
- event detection

Raw sensor data should not be shipped to cloud providers unless the task explicitly requires it and policy allows it.

### 2. Structured outputs over raw payloads

The multimodal layer should provide compact structured artifacts to the orchestrator, such as:

- transcript
- extracted text
- scene summary
- object list
- confidence and modality metadata

This keeps routing and prompt construction small and deterministic.

### 3. Event-driven activation

Always-on multimodal behavior must be lightweight. PREXUS should prefer:

- wake-word activation
- event-triggered analysis
- on-demand camera processing
- bounded background work

Avoid continuous heavy inference loops.

### 4. Compression before escalation

Before cloud vision or cloud reasoning is used, the local multimodal stack should try:

- OCR extraction
- cropping or region narrowing
- frame or image selection
- summary generation
- duplicate filtering

The goal is to send only the minimum data necessary for the remote task.

## Pipeline Overview

```text
Modality Capture
  ↓
Normalization
  ↓
Local Modality-Specific Processing
  ├─ Audio -> ASR / event detection
  ├─ Vision -> OCR / scene extraction
  ├─ Text -> normalization
  └─ Sensors -> event summarization
  ↓
Structured Multimodal Output
  ↓
Routing / Memory / RAG / LLM
```

## Integration With Routing

The multimodal layer should not pick providers directly. It should provide compact evidence for the router to decide:

- whether local processing is sufficient
- whether cloud escalation is justified
- whether additional memory or RAG is needed
- whether the task is privacy-sensitive

Examples:

- OCR result with high confidence may stay local
- a complex diagram understanding task may escalate
- a camera frame containing sensitive information may be marked local-only

## Integration With Memory

Multimodal outputs may become memory candidates when they are durable and useful.

Examples:

- extracted project notes from a whiteboard
- recognized preferences from spoken setup
- recurring device or workflow context

Memory writes should store compressed semantic results, not raw sensor streams by default.

## Performance Constraints

Multimodal strategy must account for iPhone limits:

- battery usage
- thermal limits
- RAM constraints
- intermittent connectivity
- camera and microphone permission boundaries

Implementation guidance:

- use small local models first
- prefer incremental and streaming processing
- avoid keeping large multimodal models always loaded
- release heavy resources aggressively after use

## Privacy and Security

Multimodal data is often highly sensitive. The system must:

- default to local preprocessing
- minimize external transmission
- respect per-provider escalation rules
- allow user control over modality permissions
- store sensitive derived data locally

API keys must never be embedded in multimodal artifacts and should remain in Keychain-managed configuration.

## MVP Scope

MVP multimodal support should include:

- text input
- local voice input with ASR
- wake word exploration path
- camera capture
- OCR
- basic vision input pipeline
- routing integration for text, audio, and image tasks

MVP does not need:

- advanced speaker identity modeling
- continuous world-state tracking
- heavy background sensor fusion
- broad autonomous environment monitoring

## Success Metrics

Multimodal quality should be evaluated by:

- local OCR usability
- voice input latency
- percentage of multimodal tasks handled without cloud
- token reduction from local extraction and summarization
- battery impact during voice and camera flows
- routing accuracy for image and audio tasks
