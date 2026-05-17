# Routing Design

## Objective

Routing is the core product capability of PREXUS. The system should decide, with minimal user involvement, which execution path is best for a given request while balancing:

- latency
- privacy
- cost
- battery
- model quality
- offline availability

The routing layer exists to avoid naive behavior such as sending every request and the full conversation history to a cloud LLM.

## Routing Responsibilities

The router must decide:

1. Whether the request can remain local
2. Whether multimodal preprocessing is required
3. Whether memory recall is necessary
4. Whether RAG is useful
5. Whether escalation is required
6. Which provider or local model is the best target
7. How much context should be attached

## Input Signals

Routing decisions should use a compact set of signals:

- input modality: text, voice, image, sensor
- detected intent
- complexity estimate
- privacy sensitivity
- online/offline state
- battery / thermal state
- latency target
- token budget estimate
- user policy overrides

These signals should be derived locally whenever possible.

## Routing Pipeline

```text
Incoming Event
  ↓
Normalization
  ↓
Intent Classification
  ↓
Complexity / Sensitivity Scoring
  ↓
Policy Evaluation
  ↓
Route Candidate Selection
  ├─ Local only
  ├─ Local + memory
  ├─ Local + RAG
  ├─ Local + multimodal preprocessing
  └─ Cloud escalation
  ↓
Context Compression
  ↓
Execution
  ↓
Response + Routing Telemetry
```

## Route Classes

### 1. Local-only route

Use when:

- task is simple or moderate
- privacy is high
- network is unavailable
- latency must be low

Examples:

- short conversation
- summarization
- OCR extraction
- intent detection
- local memory lookup

### 2. Local plus memory route

Use when:

- current task depends on prior user context
- recall can be handled from local vector memory
- cloud escalation is not required yet

Examples:

- continuing a previous project discussion
- recalling preferences
- finding a prior note

### 3. Local plus RAG route

Use when:

- task depends on indexed local documents
- retrieval can narrow context significantly
- full document injection would be too expensive

### 4. Cloud escalation route

Use when:

- complexity exceeds local model capability
- task quality target is high
- context length exceeds local budget
- specialized provider strength is relevant

Examples:

- large code analysis
- deep reasoning
- long-form writing
- high-precision vision

## Routing Heuristics

### Primary heuristic order

When signals conflict, prioritize roughly in this order:

1. Privacy and user policy
2. Offline capability
3. Feasibility on local hardware
4. Latency target
5. Battery / thermal limits
6. Cost
7. Quality optimization

### Example default mapping

| Task type | Preferred route |
|---|---|
| Intent classification | Tier 1 or Tier 2 local |
| Basic chat | Tier 2 local |
| OCR | Local multimodal |
| Voice transcription | Local audio |
| Sensitive content | Local-only if feasible |
| Math / structured reasoning | Gemini candidate |
| Code analysis | GPT candidate |
| Creative writing | Claude candidate |
| Large document analysis | Cloud with compression + RAG |

These are defaults, not hardcoded absolutes. Policy and device state can override them.

## Sensitivity Policy

The router should assign a sensitivity label before escalation:

- `local_only`
- `local_preferred`
- `escalation_allowed`
- `provider_restricted`

Examples:

- personal notes may be `local_preferred` or `local_only`
- code from a confidential repo may be `provider_restricted`
- generic public questions may be `escalation_allowed`

In the current iOS scaffold, sensitivity is also exposed as a per-turn user override so routing behavior can be tested explicitly without changing the global runtime policy.

## Complexity Scoring

The router should estimate request complexity using lightweight local analysis.

Suggested dimensions:

- prompt length
- reasoning depth needed
- modality count
- expected output length
- tool or document dependency
- ambiguity level

Suggested result classes:

- `low`
- `medium`
- `high`
- `specialized`

## Escalation Gates

Cloud escalation should happen only if all gates pass:

1. Local route judged insufficient
2. User policy allows transmission
3. Network available
4. Battery / thermal state acceptable
5. Context compressed to acceptable budget
6. Provider selected successfully

If any gate fails, the runtime should fall back to the best available local response rather than failing silently.

In the current scaffold, provider availability includes API key presence. If a cloud provider is selected but the corresponding user key is unavailable, PREXUS should reroute to local execution before making a cloud request attempt.

## Context Packaging

Before executing a cloud route, the router should produce a compact package:

- current user intent
- compressed dialogue summary
- selected memory recalls
- selected retrieved documents
- modality-derived structured results
- provider-specific instruction block

The router should avoid attaching:

- raw full conversation history by default
- irrelevant memory records
- duplicate OCR or transcript chunks
- large documents without narrowing

## Output Contract

Each routing decision should emit a structured record such as:

```text
route_id
selected_tier
selected_target
reason_codes
sensitivity_level
compression_applied
memory_used
rag_used
fallback_plan
```

This enables debugging, evaluation, and future model tuning.

## Failure and Fallback Strategy

Routing must degrade gracefully.

Fallback examples:

- cloud unavailable -> local summary with escalation notice
- local model overloaded -> cheaper local classifier + deferred execution
- high thermal state -> lower-frequency inference or smaller local model
- provider error -> alternative provider if policy allows

## MVP Scope

MVP routing should support:

- local vs cloud selection
- OpenAI and Anthropic provider choice
- sensitivity-aware routing
- basic complexity estimation
- context compression before cloud calls
- simple per-task heuristics for text, OCR, and vision

MVP does not need:

- learned router training pipeline
- highly dynamic multi-hop planning
- fully autonomous agent routing

## Success Metrics

Routing quality should be evaluated by:

- percentage of tasks handled locally
- average cloud token reduction
- median response latency
- escalation precision for complex tasks
- privacy policy compliance
- battery impact of always-on routing components
