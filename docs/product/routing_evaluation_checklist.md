# Routing Evaluation Checklist

## Purpose

This checklist defines the minimum repeatable evaluation loop for the current PREXUS MVP routing scaffold.

It is intentionally lightweight. The goal is not benchmark theater. The goal is to catch obvious regressions in:

- local-first behavior
- escalation correctness
- fallback behavior
- sensitivity-policy compliance
- prompt-budget discipline

## When To Run It

Run this checklist when:

- routing logic changes
- sensitivity policy changes
- provider fallback behavior changes
- multimodal routing behavior changes
- diagnostics or route summaries change in ways that could hide regressions

## Required Evidence

For the current MVP scaffold, collect:

1. Fresh `xcodebuild` test results
2. One manual iPhone 16 simulator spot check for chat UI if routing UX changed
3. A small route-behavior matrix covering the scenarios below

## Route-Behavior Matrix

### 1. Local-first default

Scenario:

- general local chat

Expected:

- route stays local
- reason includes `local_default`
- execution mode is `local`

### 2. Complex code escalation

Scenario:

- code review / bug analysis request with cloud enabled and OpenAI key available

Expected:

- route escalates to OpenAI
- reason includes `high_complexity`
- execution mode is `cloud`

### 3. Missing-key fallback

Scenario:

- cloud-eligible code request without the needed provider key

Expected:

- effective route falls back to local
- reason includes provider key unavailable code
- execution mode is local or fallback, never silent failure

### 4. Local-only sensitivity

Scenario:

- code or image request under `localOnly`

Expected:

- route remains local regardless of modality
- reason includes `local_only`
- turn is not auto-saved to episodic memory

### 5. Provider-restricted sensitivity

Scenario:

- cloud-eligible request under `providerRestricted`

Expected:

- route escalates only when the preferred provider is allowlisted
- otherwise fails closed to local
- reasons include `provider_restricted` and, when relevant, `provider_not_approved`
- turn is not auto-saved to episodic memory

### 6. OCR / local-default multimodal path

Scenario:

- OCR-style extraction request

Expected:

- route stays local by default unless future policy changes explicitly widen it
- reason includes `ocrExtraction`
- sensitivity policy still applies normally

### 7. Prompt-budget discipline

Scenario:

- cloud-eligible request with long transcript/context

Expected:

- prompt is trimmed to configured budget
- cloud route still succeeds or falls back cleanly

## Metrics To Record

For a lightweight MVP pass, record:

- **Local ratio:** among the checklist scenarios, how many stayed local
- **Fallback frequency:** how many scenarios required fallback because of missing keys or policy gates
- **Escalation correctness:** did cloud-eligible scenarios choose the expected provider/path
- **Sensitivity compliance:** did any `localOnly` or `providerRestricted` scenario violate policy

Do not optimize for a high cloud ratio. PREXUS should prefer correct local behavior over unnecessary escalation.

## Pass / Fail Rules

Pass when all of the following are true:

- all automated tests pass
- no scenario violates sensitivity policy
- no cloud-eligible scenario silently fails
- diagnostics still expose enough information to explain why a route was chosen
- prompt trimming still occurs for long cloud prompts

Fail when any of the following occurs:

- a `localOnly` turn escalates
- a `providerRestricted` turn escapes the allowlist
- key-unavailable scenarios attempt cloud execution instead of failing closed
- multimodal paths bypass the shared sensitivity contract
- diagnostics or route summaries become too ambiguous to debug regressions

## Current MVP Evidence Sources

- unit tests in `app/ios/QWONTests/QWONTests.swift`
- route contract docs in `docs/requirements/routing_design.md`
- memory retention docs in `docs/requirements/memory_design.md`
- multimodal routing docs in `docs/requirements/multimodal_strategy.md`

## Next-Step Evolution

After MVP, this checklist should evolve toward:

- measured local-vs-cloud latency
- token-usage deltas for compressed cloud prompts
- thermal/battery observations for multimodal flows
- curated scenario fixtures instead of ad hoc prompt examples
