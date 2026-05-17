# Anthropic

## Role in PREXUS

Anthropic is a Tier 3 cloud inference target in PREXUS. It should be used when a task benefits from high-quality long-form reasoning or writing and when local inference is not sufficient.

Typical target use cases:

- long-form writing
- high-quality summarization
- nuanced analysis
- creative generation
- complex dialogue continuation

As with all cloud providers in PREXUS, Anthropic must be reached only after local routing, privacy checks, and context reduction.

## Product Positioning

Within PREXUS routing, Anthropic is generally a candidate for:

- writing-heavy tasks
- nuanced explanation
- creative work
- extended reasoning where local output quality is insufficient

These are routing defaults, not rigid provider lock-in rules.

## Integration Principles

- Anthropic access must remain behind the cloud adapter layer
- Provider-specific formatting should stay isolated from core runtime logic
- PREXUS should send compact, curated context only
- Memory and retrieval injection must be filtered before transmission
- UI must not depend directly on Anthropic-specific behavior

## Required Capabilities

The Anthropic integration path should support:

- authenticated requests
- streaming responses
- provider-specific prompt construction
- normalized response handling
- adapter-level error mapping

Future support may include:

- richer multimodal escalation if product needs justify it
- specialized long-context workflows

## Adapter Design

Suggested PREXUS responsibilities:

- orchestrator decides whether Anthropic is an eligible route
- cloud layer performs execution
- Anthropic adapter maps normalized route packages to provider requests
- output is normalized before reaching UI or memory pipelines

The adapter should receive:

- intent summary
- compressed context
- selected recalls
- selected retrieved references
- execution policy metadata

## Context Policy

Anthropic-bound requests should follow the same PREXUS compression discipline:

- summarize recent history
- deduplicate context
- narrow retrieved documents
- inject only top-value memory

The goal is to preserve answer quality while minimizing token cost and privacy exposure.

## Security Requirements

- API keys are user-managed
- Keys must be stored in Keychain
- Sensitive local-only data must not leave the device
- Transmission policy must be enforced before request execution
- Provider restrictions should be respected per route

## Failure Handling

If Anthropic execution fails, PREXUS should:

- capture adapter-normalized error state
- decide whether retry is useful
- fall back locally if possible
- reroute only when policy and task type permit

## MVP Scope

For MVP, Anthropic integration should include:

- API key configuration
- authenticated request path
- streaming support
- orchestrator-driven routing
- compact context packaging

MVP does not need:

- full provider feature parity
- advanced background workflows
- specialized task-specific tuning beyond basic routing
