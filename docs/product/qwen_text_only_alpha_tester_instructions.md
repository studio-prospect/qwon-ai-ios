# Qwen Text-Only Alpha — Tester Instructions

For internal / TestFlight testers validating the **text-only** local runtime slice.

Related: [docs index](./qwen_text_only_alpha_docs_index.md) · [status summary](./qwen_text_only_alpha_status_summary.md) · [release notes](./qwen_text_only_alpha_release_notes.md) · [TestFlight prep](./qwen_text_only_alpha_testflight_prep.md) · **[Lab evidence](./qwen_text_only_alpha_lab_evidence.md)**

Release status: internal TestFlight alpha `0.1.0 (1)` is for the **two-device lab** only (Wang + Matisse). **Build `2` is not approved.** See [Physical device lab](./qwen_text_only_alpha_testflight_prep.md#physical-device-lab-ops-policy), [evidence retention](./qwen_text_only_alpha_lab_evidence.md#retention-rules-do-not-commit-binaries), and the [feedback report template](#tester-feedback-report-template). Use [onboarding](./qwen_text_only_alpha_testflight_prep.md#tester-onboarding-message) and [What to Test](./qwen_text_only_alpha_testflight_prep.md#asc-what-to-test-copy).

## Lab devices (ops)

| Device | Use for |
| --- | --- |
| **Wang** (iPhone 17, A17 Pro+) | Real Qwen — `llama.cpp` after GGUF push; full smoke optional |
| **Matisse** (iPhone XS Max, A12) | Embedded Heuristic path — stable Chat + Diagnostics; **not** llama.cpp |

Do not join `internal_tester` without coordinating with release engineering (GGUF requires USB + dev Mac).

## Before you start

1. **Device:** A17 Pro-class (iPhone 15 Pro / 16 / 17) **recommended** for real Qwen; older iPhones (e.g. XS Max) stay on **Embedded Heuristic** even with GGUF.
2. **Model:** Developer runs `./tools/scripts/push_local_model_to_device.sh "<DeviceName>"` — not bundled in TestFlight IPA.
3. **Build:** TestFlight `0.1.0 (1)`.
4. **Unlock** the device and keep USB connected during GGUF push.

## When the TestFlight build number changes

Applies when ASC shows a new **build** (e.g. `0.1.0 (2)` or `0.1.1 (1)`). See [next build gate](./qwen_text_only_alpha_release_readiness.md#next-build-gate-before-build-2).

1. Install the **new** TestFlight build on your lab device (Wang or Matisse only).
2. Ask release engineering to run `push_local_model_to_device.sh "<DeviceName>"` again for that build.
3. Force-quit PREXUS, send one short Chat message, open **Settings → Recent Runtime Decisions**.
4. **Wang:** confirm `answered_by=llama.cpp On-Device Runtime`.
5. **Matisse:** confirm **Local runtime** + **Embedded Heuristic Runtime** — **not** a failure if llama.cpp is absent.
6. Return screenshot filenames; ops stores PNGs outside git ([ledger subsection](./qwen_text_only_alpha_lab_evidence.md#adding-a-new-ledger-subsection)).

Update the **Build:** line in your report to the new marketing version and build number.

## Quick automated smoke (developers)

```bash
./tools/scripts/alpha_smoke_wang.sh "Wang"
```

This runs:

- **with_model** — expects `llama.cpp On-Device Runtime`, `executionMode=local`
- **no_model** — forced missing GGUF path; expects embedded heuristic + `fallback_reason=embedded_heuristic`
- **sensitivity_matrix** — four sensitivity modes, one turn each (GGUF present)

Results land in `.eval-logs/` (not committed).

## Manual tester flow

### 0. TestFlight install

1. Open the TestFlight invitation.
2. Install **PREXUS 0.1.0**.
3. Launch once, then close the app.
4. Ask a developer to run:

```bash
./tools/scripts/push_local_model_to_device.sh "<YourDeviceName>"
```

5. Reopen PREXUS before starting the checks below.

### 1. Launch and Chat

1. Open PREXUS.
2. Confirm Chat loads (header, composer, sensitivity control).
3. Send: `Hello PREXUS — one sentence reply please.`
4. Expect an assistant reply within ~30s (first load may be slower).

### 2. With model — Qwen path (A17 Pro+ lab devices, e.g. Wang)

1. Confirm developer pushed GGUF.
2. Send a short message.
3. Open **Settings** (gear on Chat) → **Recent Runtime Decisions** (navigation title: **Runtime Diagnostics**).
4. Latest entry should show:
   - Execution: **Local runtime**
   - Detail includes `answered_by=llama.cpp On-Device Runtime`

### 2b. With model — heuristic path (A12 lab devices, e.g. Matisse)

1. Developer may still push GGUF (optional for ops); hardware gate uses **Embedded Heuristic Runtime** as the answering backend only.
2. Send a short message (e.g. `Hello PREXUS`).
3. In **Chat**, confirm the primary chip is **Local runtime** (not Fallback) and a secondary chip shows **Embedded Heuristic Runtime**; caption may read *Local lightweight fallback path without a packaged LLM.*
4. In **Runtime Diagnostics**, confirm **Local runtime** on the entry and the same embedded-heuristic backend/detail — **pass** if stable (missing llama.cpp is expected on A12).

### 3. Without model (fallback path)

Only if instructed by developers (they remove or omit the GGUF):

1. Send a short message.
2. Expect a reply (embedded heuristic wording), **not** a crash.
3. Diagnostics should show:
   - **Fallback** execution mode
   - `primary_failure` mentioning `model_asset_unavailable`
   - `fallback_reason=embedded_heuristic`

### 4. Four sensitivity modes

For each mode in the Chat sensitivity control, send **one** short message and note the planned/executed route banner:

| Mode | Suggested prompt | What to verify |
| --- | --- | --- |
| Local Only | `Analyze this private note briefly.` | Stays local; no cloud escalation |
| Local Preferred | `Hello PREXUS.` | Local reply; routine chat |
| Escalation Allowed | `Review this Swift code for a bug.` | Without API keys: reroutes local; with keys: may use cloud |
| Provider Restricted | `Extract text from this receipt with OCR.` | Stays local when providers not approved |

After four sends, open **Recent Runtime Decisions** (**Runtime Diagnostics**) — four entries with route + execution detail. **Wang only** for this matrix during the two-device lab phase.

### 5. Settings sanity

- Provider key section loads (keys optional for local-only testing).
- Sensitivity descriptions match the selected mode.

## Tester feedback report template

Use this form for **every** issue or pass report on TestFlight **`0.1.0 (1)`**. Send to release engineering (Slack/issue channel — team choice). **Build `2` is not approved** — feedback does not by itself request a new TestFlight binary.

**Do not** attach PNG/JPEG to git or email binaries into the repo. Save screenshots under `~/PREXUS-alpha-evidence/qwen-text-0.1.0-build1/` and list **filenames only** below.

### Copy-paste template

```text
Device lab name: Wang | Matisse
iPhone model:
iOS version:
TestFlight version/build: 0.1.0 (1)  (expected — say if different)
GGUF pushed: yes | no | unknown

Scenario: launch | first chat | GGUF push | Runtime Diagnostics | sensitivity | other
Expected result:
Actual result:

Runtime Diagnostics (latest entry on Settings → Recent Runtime Decisions):
  execution mode (badge):
  backend/model label:
  answered_by:
  primary_failure:
  fallback_reason:

Ops screenshots (filenames only, not attached to git):
  diagnostics: e.g. wang-0.1.0-1-diagnostics.png
  chat (optional):
  other:

Reproducibility: once | intermittent | always

Classification candidate (tester guess):
  Release blocker | Build 2 candidate | Docs/ops only | Post-alpha | needs evidence

Suggested next action:
```

### Classification guidance (testers)

| Class | When to use | Notes |
| --- | --- | --- |
| **Release blocker** | Reproducible on build `1` and blocks launch, first text turn, Wang llama path after GGUF, no-model fallback safety, install/signing, Wang sensitivity smoke, or Diagnostics validation | **Matisse missing llama.cpp is not a failure** |
| **Build 2 candidate** | Real bug or UX issue on build `1`, but internal testing can continue on build `1` for now | Does **not** auto-approve build `2` |
| **Docs/ops only** | Confusing onboarding, What to Test, GGUF push steps, Diagnostics navigation, ops filename | **Must not** trigger build `2` |
| **Post-alpha** | OCR, camera, audio, LiteRT production, model download, cloud quality, Qwen on A12 hardware | **Must not** trigger build `2` |
| **needs evidence** | Missing Diagnostics fields, no screenshot filename, or unclear build number | Release engineering reclassifies — **do not** treat as build `2` approval |

Release engineering maps your report to [Known issues triage](./qwen_text_only_alpha_release_notes.md#known-issues-triage-for-build-1) and the [tester feedback log](./qwen_text_only_alpha_release_notes.md#tester-feedback-log-build-1). Only **template-complete** reports with repro on **`0.1.0 (1)`** count toward a **Release blocker** decision.

### Device expectations (quick reference)

| Lab device | Diagnostics expectation | llama.cpp required? |
| --- | --- | --- |
| **Wang** | **Local runtime** + `answered_by=llama.cpp On-Device Runtime` | **Yes** (after GGUF push) |
| **Matisse** | **Local runtime** badge + **Embedded Heuristic Runtime** backend/detail | **No** — missing llama.cpp is **not** a failure |

### Baseline evidence (release engineering)

For scheduled lab sign-off (not per-issue), use the shorter [ledger copy-paste template](./qwen_text_only_alpha_lab_evidence.md#copy-paste-template-new-capture) and [frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1).

Sensitivity matrix and missing-model fallback are **Wang-only** optional scenarios during the two-device lab phase (see [expected outcomes](./qwen_text_only_alpha_lab_evidence.md#expected-outcomes-wang-vs-matisse)).

## Out of scope for this alpha

Do not file as alpha blockers: missing OCR, compression, audio, camera, LiteRT default backend, or in-app model store.
