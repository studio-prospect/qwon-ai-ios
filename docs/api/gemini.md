# Gemini

## Role in PREXUS

Gemini is a planned Tier 3 cloud inference target and may also inform local-model strategy depending on on-device options available to the product. In PREXUS, Gemini should be considered for tasks where its reasoning or multimodal strengths are a good match and where local execution is insufficient.

Typical target use cases:

- structured reasoning
- mathematical or analytical tasks
- multimodal escalation scenarios
- long-context assistance, if enabled in product scope

Gemini should remain an optional route in early phases unless it is explicitly prioritized for MVP.

## Product Positioning

Within PREXUS routing, Gemini is generally a candidate for:

- reasoning-focused tasks
- multimodal cloud escalation
- workloads that benefit from Google ecosystem alignment if relevant later

This should remain heuristic-driven rather than hardcoded.

## Relationship to Local Strategy

Gemini matters to PREXUS in two separate ways:

1. As a cloud provider candidate
2. As part of the broader local-model strategy through small on-device model exploration

These concerns must remain separate in implementation. Cloud Gemini integration should not be coupled to local model execution design.

## Integration Principles

- keep provider-specific logic inside adapters
- route to Gemini only after local scoring and policy checks
- compress context before transmission
- treat multimodal payloads carefully and minimally
- preserve the local-first default

## Required Capabilities

The Gemini integration path should support:

- authenticated requests
- normalized request building
- response normalization
- error handling compatible with cloud fallback logic

If product scope includes it, also support:

- multimodal escalation packaging
- streaming-compatible UX path

## Adapter Design

Suggested PREXUS responsibilities:

- orchestrator evaluates Gemini as a route candidate
- cloud layer handles transport execution
- Gemini adapter maps route packages to provider-ready requests
- normalized output returns to the runtime pipeline

The adapter input should be a compact route package containing:

- intent summary
- compressed history
- recalled memory subset
- selected retrieval evidence
- modality-derived structured artifacts

## Context and Payload Policy

Gemini requests must follow the same PREXUS constraints as other providers:

- avoid raw full-history forwarding
- reduce payload size before transmission
- filter by sensitivity class
- keep multimodal uploads minimal and targeted

If multimodal escalation is used, PREXUS should prefer sending narrowed crops, extracted text, or scene summaries over unfiltered raw capture when feasible.

## Security Requirements

- API keys must be user-supplied
- Keys belong in Keychain
- Sensitive local memory must not be transmitted unless policy explicitly allows it
- Provider-specific restrictions must be enforced before execution

## Failure Handling

If Gemini execution fails, PREXUS should:

- normalize the failure for the orchestrator
- decide between retry, reroute, or local fallback
- preserve user-visible continuity where possible

## MVP Scope

Gemini may be:

- deferred from MVP
- included as an optional provider
- added immediately after MVP as a Phase 1.5 or Phase 2 target

If included early, minimum expectations are:

- API key configuration
- authenticated request execution
- adapter-based routing integration
- compact context packaging

MVP does not require:

- full multimodal provider exploitation
- broad provider-specific optimization
- tight coupling with local-model experiments
