# QWON Text Alpha — Feedback Intake (Build `2`)

**Last updated:** 2026-06-02
**Status:** **Intake template + triage rules only** — no open reports logged yet.
**Active build:** TestFlight **QWON `0.1.0 (2)`** · ASC **`6775685841`** · Bundle **`jp.studio-prospect.qwon.ios`**

Related: [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) · [QWON next work queue](./qwon_next_work_queue.md) · [QWON lab evidence](./qwon_text_alpha_lab_evidence.md) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

**Historical PREXUS alpha:** [PREXUS feedback log](./qwen_text_only_alpha_release_notes.md#tester-feedback-log-build-1) and [PREXUS template](./qwen_text_only_alpha_tester_instructions.md#tester-feedback-report-template) remain frozen — **do not edit**; use this doc for QWON build `2` onward.

---

## Scope

| Field | Value |
| --- | --- |
| **Purpose** | Tester feedback report template + triage classification for QWON text alpha |
| **Lab devices** | **Wang** (A17 Pro+, llama.cpp path) · **Matisse** (A12, Embedded Heuristic path) |
| **Build** | **`0.1.0 (2)`** only — reports must cite this build unless explicitly noting a mismatch |
| **Not in scope** | Build `3` approval · archive/upload/tag · bugfix implementation · fake log rows |

This document **prepares intake**. A **Release blocker** or **minimal fix PR** requires real template-complete reports, Codex/Product sign-off, and a **separate** implementation PR.

---

## Tester feedback report template

Use this form for **every** issue or pass report on TestFlight **`0.1.0 (2)`**. Send to release engineering (Slack/issue channel — team choice).

**Wang and Matisse:** Use the **same** template. On Matisse, **Embedded Heuristic** without `llama.cpp` is **expected**, not a failure.

**Do not** attach PNG/JPEG to git or commit binaries to the repo. Save screenshots under `~/QWON-alpha-evidence/qwen-text-0.1.0-build2/` and list **filenames only** below.

### Copy-paste template

```text
Device lab name: Wang | Matisse
Device model:
iOS version:
TestFlight build: 0.1.0 (2)  (required — say if ASC shows different)

GGUF pushed: yes | no | not applicable

Scenario: launch | first chat | GGUF push | Runtime Diagnostics | sensitivity | keyboard | other
Expected result:
Actual result:

Runtime Diagnostics (Settings → Recent Runtime Decisions):
  execution mode:
  backend/model:
  answered_by:
  primary_failure:
  fallback_reason:

Ops artifacts (filenames only — stored outside git):
  diagnostics: e.g. wang-0.1.0-2-diagnostics.png
  chat (optional):
  log (optional):
  other:

Repro rate: once | intermittent | always

Initial classification candidate (tester guess):
  Release blocker | Build 2 watch | Docs/ops only | Post-alpha | Needs evidence

Suggested next action:
```

### Device expectations (quick reference)

| Lab device | Diagnostics expectation | `llama.cpp` required? |
| --- | --- | --- |
| **Wang** | **Local runtime** + `answered_by=llama.cpp On-Device Runtime` (after GGUF push) | **Yes** |
| **Matisse** | **Local runtime** badge + **Embedded Heuristic Runtime** backend/detail | **No** — missing llama.cpp is **not** a failure |

---

## Classification rules

Release engineering assigns the **final** class after intake. Tester **Initial classification candidate** is a hint only.

| Class | When to use | Approves build `3`? | Allows code PR? |
| --- | --- | --- | --- |
| **Release blocker** | Reproducible on **`0.1.0 (2)`** and blocks launch, first text turn, Wang llama path after GGUF, no-model fallback safety, install/signing, Wang sensitivity smoke, or Diagnostics validation | **No** — triage alone does not approve build `3` | **Only** after Codex/Product sign-off on a **minimal fix** scoped to the blocker |
| **Build 2 watch** | Real bug or UX issue on build `2`, but internal testing can continue on build `2` for now | **No** | **No** — log and monitor unless promoted |
| **Docs/ops only** | Onboarding, What to Test, GGUF push steps, Diagnostics navigation, ops filename confusion | **No** | **No** — docs/ASC copy PR only |
| **Post-alpha** | OCR, camera, audio, LiteRT production, model download UX, cloud quality, Qwen on A12 hardware | **No** | **No** — defer to [next work queue](./qwon_next_work_queue.md) |
| **Needs evidence** | Missing Diagnostics fields, no screenshot/log filename, unclear build number, or incomplete template | **No** | **No** — re-request fields; update same log row when complete |

### Promotion rules

| From | To | Requirement |
| --- | --- | --- |
| **Needs evidence** | Any other class | Template-complete report on **`0.1.0 (2)`** |
| **Build 2 watch** | **Release blocker** | Template-complete repro; blocks alpha lab checks; **not** Matisse missing llama alone |
| **Build 2 watch** | **Docs/ops only** | Issue is copy/onboarding only |
| Any class | **Release blocker** | Dual record: update triage log row + follow [next work queue — minimal fix](./qwon_next_work_queue.md#minimal-fix-pr-verified-release-blocker-only) |

**Build `3` is not approved by triage alone.** Even **Release blocker** opens a **fix** path on build `2` first; a new binary requires [4E gate](./qwon_phase4_target_rename_plan.md#pr-4e--optional-archive-smoke-decision-gate) + explicit product approval — see [TestFlight prep](./qwon_text_alpha_testflight_prep.md#phase-4-build-3-decision-gate).

---

## Intake processing (release engineering)

1. Receive template (or mark **Needs evidence** and re-request missing fields).
2. Confirm **TestFlight build: `0.1.0 (2)`** (or note mismatch — may stay **Needs evidence**).
3. Assign **final classification** using the table above.
4. Append or **update** one row in [Triage log](#triage-log-build-2) — never duplicate the same report.
5. If **Release blocker:** record decision + evidence; **do not** start implementation until Codex/Product sign-off.
6. If **Docs/ops only:** docs PR or ASC copy edit — **no** `CFBundleVersion` bump.
7. Store PNG/log artifacts under `~/QWON-alpha-evidence/` — **never** commit binaries to git.

**Matisse / A12:** Embedded Heuristic fallback without `answered_by=llama.cpp` is **expected** — not **Release blocker**, not build `3` justification.

---

## Triage log (build `2`)

**Policy:** Append rows only when **real** template-based reports arrive. **Do not** add placeholder, sample, or synthetic rows.

| ID | Date | Device | Build | Summary | Classification | Evidence | Decision | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |

### Column definitions

| Column | Required | Content |
| --- | --- | --- |
| **ID** | Yes | Monotonic `QWON-FB-001`, `QWON-FB-002`, … |
| **Date** | Yes | Report **received** date, ISO `YYYY-MM-DD` |
| **Device** | Yes | `Wang` or `Matisse` |
| **Build** | Yes | **`0.1.0 (2)`** (or note mismatch) |
| **Summary** | Yes | One line: actual vs expected |
| **Classification** | Yes | Final class from [Classification rules](#classification-rules) |
| **Evidence** | When not **Needs evidence** | Ops filename(s) only, e.g. `wang-0.1.0-2-diagnostics.png`; `—` while incomplete |
| **Decision** | Yes | e.g. `Monitor on build 2`, `Re-request Diagnostics`, `Codex review for blocker`, `Docs PR` |
| **Follow-up PR** | When known | GitHub PR link or `—` / `pending` |

**Update-in-place:** If a report starts as **Needs evidence**, **update the same row** when the template is completed — do not append a duplicate.

---

## Rules (agents and release engineering)

| Rule | Detail |
| --- | --- |
| **Release blocker evidence** | Reproducible issue on **`0.1.0 (2)`** + template-complete Diagnostics + ops filename(s) |
| **Minimal fix PR** | Only after Codex/Product sign-off; scoped to verified blocker — see [agent workflow](./agent_collaboration_workflow.md) |
| **Build `3`** | **Not approved** by this intake doc or triage alone |
| **Matisse heuristic path** | Expected on A12 — **not** failure by itself |
| **PREXUS historical logs** | **Do not edit** [PREXUS feedback log](./qwen_text_only_alpha_release_notes.md#tester-feedback-log-build-1) or frozen ledger rows |
| **No fake rows** | Empty triage table until first real report |
| **No implementation in intake PRs** | Intake docs only; fixes are separate PRs after real data |

---

## Quick routing

| I need to… | Go to |
| --- | --- |
| Submit feedback (tester) | [Copy-paste template](#copy-paste-template) |
| Process a report (ops) | [Intake processing](#intake-processing-release-engineering) → [Triage log](#triage-log-build-2) |
| Ship a fix | [Next work queue — minimal fix](./qwon_next_work_queue.md#minimal-fix-pr-verified-release-blocker-only) — **after** blocker sign-off |
| Ship build `3` | [4E gate](./qwon_phase4_target_rename_plan.md#pr-4e--optional-archive-smoke-decision-gate) — **not approved** today |
| PREXUS build `1` history | [PREXUS release notes log](./qwen_text_only_alpha_release_notes.md#tester-feedback-log-build-1) — read-only |
