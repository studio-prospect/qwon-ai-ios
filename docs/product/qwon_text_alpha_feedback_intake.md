# QWON Text Alpha — Feedback Intake (Build `3`)

**Last updated:** 2026-06-03 (post QWON-FB-001 / QWON-FB-002 pass intake)
**Status:** **Live intake** — Wang + Matisse **operational pass** logged; build `3` active; **no blockers**.
**Active build:** TestFlight **QWON `0.1.0 (3)`** · ASC **`6775685841`** · Bundle **`jp.studio-prospect.qwon.ios`**

Related: [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) · [Tier policy (Wang/Matisse)](./qwon_text_alpha_testflight_prep.md#physical-device-lab-tier-policy) · [QWON next work queue](./qwon_next_work_queue.md) · [QWON lab evidence — build `3`](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03) · [Agent collaboration workflow](./agent_collaboration_workflow.md)

**Previous active:** build **`0.1.0 (2)`** (keyboard fix) — historical for intake; new reports target **`0.1.0 (3)`**.

**Historical PREXUS alpha:** [PREXUS feedback log](./qwen_text_only_alpha_release_notes.md#tester-feedback-log-build-1) and [PREXUS template](./qwen_text_only_alpha_tester_instructions.md#tester-feedback-report-template) remain frozen — **do not edit**.

---

## Scope

| Field | Value |
| --- | --- |
| **Purpose** | Tester feedback report template + triage classification for QWON text alpha |
| **Lab devices** | **Wang** (primary — A17 Pro+, llama.cpp after GGUF) · **Matisse** (secondary — A12, Embedded Heuristic) — [tier policy](./qwon_text_alpha_testflight_prep.md#physical-device-lab-tier-policy) |
| **Build** | **`0.1.0 (3)`** — reports must cite this build unless explicitly noting a mismatch |
| **Wang GGUF (baseline)** | **Present** on Wang as of **2026-06-03** — re-pushed; [lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03). Re-verify after TestFlight reinstall or if Fallback returns. |
| **Not in scope** | Build `4` approval · bugfix implementation · fake log rows |

This document **prepares intake**. A **Release blocker** or **minimal fix PR** requires real template-complete reports, Codex/Product sign-off, and a **separate** implementation PR.

---

## Tester feedback report template

Use this form for **every** issue or pass report on TestFlight **`0.1.0 (3)`**. Send to release engineering (Slack/issue channel — team choice).

**Wang and Matisse:** Use the **same** template. On Matisse, **Embedded Heuristic** without `llama.cpp` is **expected**, not a failure.

**Do not** attach PNG/JPEG to git or commit binaries to the repo. Save screenshots under ops storage and list **filenames only** in the template.

**Ops folder (build `3`):** prefer `~/QWON-alpha-evidence/qwon-text-0.1.0-build3/`. Lab verification PNGs from **2026-06-03** live under legacy `~/QWON-alpha-evidence/qwen-text-0.1.0-build3/` — [lab evidence](./qwon_text_alpha_lab_evidence.md#build-3-lab-verification-2026-06-03). Unify `qwen-text` / `qwon-text` prefix in a future ops-only rename; do not move files as part of intake docs PRs.

### Copy-paste template

```text
Device lab name: Wang | Matisse
Device model:
iOS version:
TestFlight build: 0.1.0 (3)  (required — say if ASC shows different)

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
  diagnostics: e.g. wang-0.1.0-3-diagnostics.png
  chat (optional):
  log (optional):
  other:

Repro rate: once | intermittent | always

Initial classification candidate (tester guess):
  Release blocker | Build 3 watch | Docs/ops only | Post-alpha | Needs evidence

Suggested next action:
```

### Device expectations (quick reference)

| Lab device | Diagnostics expectation | `llama.cpp` required? |
| --- | --- | --- |
| **Wang** | **Local runtime** + `answered_by=llama.cpp On-Device Runtime` (after GGUF push) | **Yes** |
| **Matisse** | **Local runtime** badge + **Embedded Heuristic Runtime** backend/detail | **No** — missing llama.cpp is **not** a failure |

**Wang Fallback note:** If `GGUF pushed: no` or file missing at `Documents/Models/prexus-local-mvp.gguf`, Fallback is **expected** until ops push — classify as **Docs/ops only** unless push confirmed and llama path still fails.

---

## Classification rules

Release engineering assigns the **final** class after intake. Tester **Initial classification candidate** is a hint only.

| Class | When to use | Approves build `4`? | Allows code PR? |
| --- | --- | --- | --- |
| **Release blocker** | Reproducible on **`0.1.0 (3)`** and blocks launch, first text turn, Wang llama path **after confirmed GGUF push**, no-model fallback safety, install/signing, Wang sensitivity smoke, or Diagnostics validation | **No** | **Only** after Codex/Product sign-off on a **minimal fix** scoped to the blocker |
| **Build 3 watch** | Real bug or UX issue on build `3`, but internal testing can continue on build `3` for now | **No** | **No** — log and monitor unless promoted |
| **Docs/ops only** | Onboarding, What to Test, GGUF push steps, Diagnostics navigation, ops filename confusion; **Wang Fallback before GGUF push** | **No** | **No** — docs/ASC copy or ops push only |
| **Post-alpha** | OCR, camera, audio, LiteRT production, model download UX, cloud quality, Qwen on A12 hardware | **No** | **No** — defer to [next work queue](./qwon_next_work_queue.md) |
| **Operational pass** | Template-complete pass on **`0.1.0 (3)`**; expected device path (Wang llama after GGUF / Matisse Embedded Heuristic); no defect reported | **No** | **No** — monitor on build `3` |
| **Needs evidence** | Missing Diagnostics fields, no screenshot/log filename, unclear build number, or incomplete template | **No** | **No** — re-request fields; update same log row when complete |

### Promotion rules

| From | To | Requirement |
| --- | --- | --- |
| **Needs evidence** | Any other class | Template-complete report on **`0.1.0 (3)`** |
| **Build 3 watch** | **Release blocker** | Template-complete repro; blocks alpha lab checks; **not** Matisse missing llama alone; Wang requires **confirmed GGUF push** before llama-path blocker |
| **Build 3 watch** | **Docs/ops only** | Issue is copy/onboarding only |
| Any class | **Release blocker** | Dual record: update triage log row + follow [next work queue — minimal fix](./qwon_next_work_queue.md#minimal-fix-pr-verified-release-blocker-only) |

**Build `4` is not approved by triage alone.** Even **Release blocker** opens a **fix** path on build `3` first; a new binary requires explicit product approval — see [TestFlight prep](./qwon_text_alpha_testflight_prep.md#phase-4-build-3-decision-gate).

---

## Intake processing (release engineering)

1. Receive template (or mark **Needs evidence** and re-request missing fields).
2. Confirm **TestFlight build: `0.1.0 (3)`** (or note mismatch — may stay **Needs evidence**).
3. For Wang llama-path issues: confirm **`Documents/Models/prexus-local-mvp.gguf`** or `GGUF pushed: yes` before **Release blocker**.
4. Assign **final classification** using the table above.
5. Append or **update** one row in [Triage log](#triage-log-build-3) — never duplicate the same report.
6. If **Release blocker:** record decision + evidence; **do not** start implementation until Codex/Product sign-off.
7. If **Docs/ops only:** docs PR, ASC copy edit, or GGUF push — **no** `CFBundleVersion` bump without product gate.
8. Store PNG/log artifacts under `~/QWON-alpha-evidence/` — **never** commit binaries to git.

**Matisse / A12:** Embedded Heuristic without `answered_by=llama.cpp` is **expected** — not **Release blocker**, not build `4` justification. Matisse reports still use the **same template**; full Diagnostics ledger is optional on secondary tier unless runtime changes.

---

## Operational handoff (when a real report arrives)

1. Tester sends [copy-paste template](#copy-paste-template) (or mark **Needs evidence** and re-request missing fields).
2. Confirm **TestFlight build `0.1.0 (3)`** and device lab name (**Wang** or **Matisse**).
3. Assign **final classification** — see [classification rules](#classification-rules).
4. **Append one row** to [triage log](#triage-log-build-3) — or **update the same row** if completing **Needs evidence**.
5. Store PNG/log under `~/QWON-alpha-evidence/` — **never** commit binaries to git.
6. **Release blocker:** record decision; wait for Codex/Product sign-off before implementation PR — [next work queue](./qwon_next_work_queue.md#minimal-fix-pr-verified-release-blocker-only).

**Do not:** add placeholder rows; approve build `4`; edit [PREXUS feedback log](./qwen_text_only_alpha_release_notes.md#tester-feedback-log-build-1).

---

## Triage log (build `3`)

**Policy:** Append rows only when **real** template-based reports arrive. **Do not** add placeholder, sample, or synthetic rows.

| ID | Date | Device | Build | Summary | Classification | Evidence | Decision | Follow-up PR |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **QWON-FB-001** | 2026-06-03 | Wang | `0.1.0 (3)` | Pass — general chat (18:31): expected Local + llama.cpp after GGUF; got **Local runtime** + **llama.cpp On-Device Runtime**, 6月最終日 Q answered, no Fallback | **Operational pass** | `wang-0.1.0-3-chat-pass.png`, `wang-0.1.0-3-diagnostics-pass.png`, `wang-0.1.0-3-testflight.png` | Monitor on build 3 — Wang primary pass, no blocker | `—` |
| **QWON-FB-002** | 2026-06-03 | Matisse | `0.1.0 (3)` | Pass — general chat (18:34): expected Embedded Heuristic on A12; got **Local runtime** + embedded heuristic reply, detail *without a packaged LLM* | **Operational pass** | `matisse-0.1.0-3-chat-pass.png`, `matisse-0.1.0-3-diagnostics-pass.png`, `matisse-0.1.0-3-testflight.png` | Monitor on build 3 — Matisse secondary pass, no blocker | `—` |

### QWON-FB-001 (2026-06-03) — Wang pass

```text
Device lab name: Wang
Device model: iPhone 17 (iPhone18,3)
iOS version: 26.5
TestFlight build: 0.1.0 (3)

GGUF pushed: yes

Scenario: first chat
Expected result: Local runtime + llama.cpp On-Device Runtime; chat turn answered
Actual result: Pass — Local runtime + llama.cpp badges; 6月の最終日は何曜？ answered; no Fallback badge

Runtime Diagnostics (Settings → Recent Runtime Decisions):
  execution mode: Local
  backend/model: llama.cpp On-Device Runtime (detail: llama.cpp GGUF inference on A17 Pro-class hardware)
  answered_by: llama.cpp On-Device Runtime
  primary_failure: (none)
  fallback_reason: (none)

Ops artifacts (filenames only — stored outside git):
  chat: wang-0.1.0-3-chat-pass.png
  diagnostics: wang-0.1.0-3-diagnostics-pass.png
  other: wang-0.1.0-3-testflight.png

Repro rate: once

Initial classification candidate (tester guess): pass — no issue; monitor only
Final classification: Operational pass

Suggested next action: Monitor on build 3 — Wang primary pass, no blocker
```

**Ops path:** `~/QWON-alpha-evidence/qwon-text-0.1.0-build3/`

### QWON-FB-002 (2026-06-03) — Matisse pass

```text
Device lab name: Matisse
Device model: iPhone XS Max (iPhone11,6)
iOS version: 18.7.9
TestFlight build: 0.1.0 (3)

GGUF pushed: not applicable

Scenario: first chat
Expected result: Local runtime + Embedded Heuristic on A12 (no llama.cpp required)
Actual result: Pass — Local runtime; embedded heuristic response for 北海道札幌市の6月平均気温は？; detail "Local lightweight fallback path without a packaged LLM"

Runtime Diagnostics (Settings → Recent Runtime Decisions):
  execution mode: Local
  backend/model: Embedded Heuristic Runtime (compact on-device heuristics)
  answered_by: Embedded Heuristic Runtime
  primary_failure: (none)
  fallback_reason: N/A — expected Matisse path, not llama failure

Ops artifacts (filenames only — stored outside git):
  chat: matisse-0.1.0-3-chat-pass.png
  diagnostics: matisse-0.1.0-3-diagnostics-pass.png
  other: matisse-0.1.0-3-testflight.png

Repro rate: once

Initial classification candidate (tester guess): pass — no issue; monitor only
Final classification: Operational pass

Suggested next action: Monitor on build 3 — Matisse secondary pass, no blocker
```

**Ops path:** `~/QWON-alpha-evidence/qwon-text-0.1.0-build3/`

### Column definitions

| Column | Required | Content |
| --- | --- | --- |
| **ID** | Yes | Monotonic `QWON-FB-001`, `QWON-FB-002`, … |
| **Date** | Yes | Report **received** date, ISO `YYYY-MM-DD` |
| **Device** | Yes | `Wang` or `Matisse` |
| **Build** | Yes | **`0.1.0 (3)`** (or note mismatch) |
| **Summary** | Yes | One line: actual vs expected |
| **Classification** | Yes | Final class from [Classification rules](#classification-rules) |
| **Evidence** | When not **Needs evidence** | Ops filename(s) only, e.g. `wang-0.1.0-3-diagnostics.png`; `—` while incomplete |
| **Decision** | Yes | e.g. `Monitor on build 3`, `Re-request Diagnostics`, `GGUF push`, `Codex review for blocker`, `Docs PR` |
| **Follow-up PR** | When known | GitHub PR link; `—` when **Operational pass** / no follow-up required; `pending` only when a fix/docs PR is expected |

**Update-in-place:** If a report starts as **Needs evidence**, **update the same row** when the template is completed — do not append a duplicate.

---

## Rules (agents and release engineering)

| Rule | Detail |
| --- | --- |
| **Release blocker evidence** | Reproducible issue on **`0.1.0 (3)`** + template-complete Diagnostics + ops filename(s); Wang llama failures require **confirmed GGUF** |
| **Minimal fix PR** | Only after Codex/Product sign-off; scoped to verified blocker — see [agent workflow](./agent_collaboration_workflow.md) |
| **Build `4`** | **Not approved** by this intake doc or triage alone |
| **Matisse heuristic path** | Expected on A12 — **not** failure by itself |
| **PREXUS historical logs** | **Do not edit** [PREXUS feedback log](./qwen_text_only_alpha_release_notes.md#tester-feedback-log-build-1) or frozen ledger rows |
| **No fake rows** | Real pass reports: **QWON-FB-001** (Wang), **QWON-FB-002** (Matisse) — 2026-06-03 |
| **No implementation in intake PRs** | Intake docs only; fixes are separate PRs after real data |

---

## Quick routing

| I need to… | Go to |
| --- | --- |
| Submit feedback (tester) | [Copy-paste template](#copy-paste-template) |
| Process a report (ops) | [Intake processing](#intake-processing-release-engineering) → [Triage log](#triage-log-build-3) |
| Ship a fix | [Next work queue — minimal fix](./qwon_next_work_queue.md#minimal-fix-pr-verified-release-blocker-only) — **after** blocker sign-off |
| Ship build `4` | **Not approved** — product gate required |
| PREXUS build `1` history | [PREXUS release notes log](./qwen_text_only_alpha_release_notes.md#tester-feedback-log-build-1) — read-only |
