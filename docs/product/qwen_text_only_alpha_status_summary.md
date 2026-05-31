# Qwen Text-Only Alpha — Status Summary (Build 1 Stable)

**Last updated:** 2026-05-31 (post PR #37 on `main`)
**Purpose:** One-page **current state** for Qwen text-only alpha operations. **Build 1 is in stable internal TestFlight operations** until a template-complete **Release blocker** opens build `2` approval.

**Operations handoff:** [internal handoff memo](./qwen_text_only_alpha_handoff.md) — next steps, do-not rules, blocker response (not public-facing).

**Not executed here:** `CFBundleVersion` bump, archive, TestFlight upload, git tag, or changes to the [build 1 frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1).

---

## Current state

| Item | Value |
| --- | --- |
| **Active TestFlight** | `0.1.0` (build `1`) |
| **Bundle ID** | `jp.studio-prospect.prexus.ios` |
| **Git tag (build 1 IPA)** | `qwen-text-alpha-0.1.0-rc1` → commit `a021475` |
| **Build 2** | **Not approved** — [plan only](./qwen_text_only_alpha_release_notes.md#build-2-plan-not-executed) |
| **Scope** | Qwen + **llama.cpp** text-only alpha |
| **Lab** | **Wang** + **Matisse** only (`internal_tester`) |
| **ASC group** | `internal_tester` — do not widen |

---

## Completed (build 1 baseline)

| Area | Status |
| --- | --- |
| Bundle ID / ASC app / provisioning | Complete — [bundle memo](./bundle_id_decision_memo.md) |
| Distribution archive + TestFlight upload | Complete 2026-05-31 — [prep](./qwen_text_only_alpha_testflight_prep.md#testflight-upload-2026-05-31) |
| Git tag `qwen-text-alpha-0.1.0-rc1` | Complete on `a021475` |
| Wang TestFlight | Install + GGUF + **llama.cpp** path pass |
| Matisse TestFlight | Install + **Embedded Heuristic** path pass (iOS 18.7.9) |
| Two-device ops evidence | Filed under `~/PREXUS-alpha-evidence/qwen-text-0.1.0-build1/` — [ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) |
| Next build gate | Documented — [readiness](./qwen_text_only_alpha_release_readiness.md#next-build-gate-before-build-2) |
| Build 1 issue triage | Complete — no open Release blocker — [triage](./qwen_text_only_alpha_release_notes.md#known-issues-triage-for-build-1) |
| Tester feedback template | Complete — [template](./qwen_text_only_alpha_tester_instructions.md#tester-feedback-report-template) |
| RC code criteria | Merged (PR #22); simulator + Wang smoke lineage documented |

---

## Open / watch

| Item | Owner / action |
| --- | --- |
| **Tester feedback** | Intake via [feedback template](./qwen_text_only_alpha_tester_instructions.md#tester-feedback-report-template) only |
| **Incomplete reports** | Classify as **needs evidence** — not build `2` approval |
| **Docs / ops / ASC copy** | Update in place against build `1` when needed |
| **Release blocker watch** | If reproduced on `0.1.0 (1)` with template-complete evidence → update [triage](./qwen_text_only_alpha_release_notes.md#known-issues-triage-for-build-1) and [Binary respin reason](./qwen_text_only_alpha_release_notes.md#binary-respin-reason-required-before-cut) |
| **Build 2** | Remains **not approved** until binary respin reason is filled and triage checklist passes |

---

## Explicit non-goals (unchanged)

- LiteRT production default
- L2 backend selector
- OCR, camera, audio, compression v1
- In-app model download UX
- Public App Store submission
- Widening `internal_tester` beyond Wang + Matisse

---

## Decision rules

1. **Keep build `1`** unless a **Release blocker** is reproduced on TestFlight `0.1.0 (1)` with [template-complete](./qwen_text_only_alpha_tester_instructions.md#tester-feedback-report-template) feedback (Diagnostics fields + ops screenshot filename).
2. **Docs / ops / ASC** text changes alone **do not** justify build `2`.
3. **Post-alpha** items **do not** justify build `2`.
4. **Matisse** without `answered_by=llama.cpp` is **expected** (A12 gate) — **not** a failure.
5. **Artifacts outside git:** PNG/JPEG, device logs, IPA, GGUF, ops `MANIFEST.txt` — metadata in docs only (`on file (ops)`).

---

## Link map (alpha docs)

| Topic | Document |
| --- | --- |
| **This summary** | `qwen_text_only_alpha_status_summary.md` (this file) |
| Internal handoff | [qwen_text_only_alpha_handoff.md](./qwen_text_only_alpha_handoff.md) |
| Release scope | [qwen_text_only_alpha_release.md](./qwen_text_only_alpha_release.md) |
| Release notes + build 2 plan + triage | [qwen_text_only_alpha_release_notes.md](./qwen_text_only_alpha_release_notes.md) |
| RC readiness + next build gate + build 2 decision | [qwen_text_only_alpha_release_readiness.md](./qwen_text_only_alpha_release_readiness.md) |
| Lab evidence + frozen ledger | [qwen_text_only_alpha_lab_evidence.md](./qwen_text_only_alpha_lab_evidence.md) |
| Tester flow + feedback template | [qwen_text_only_alpha_tester_instructions.md](./qwen_text_only_alpha_tester_instructions.md) |
| TestFlight prep + feedback classification | [qwen_text_only_alpha_testflight_prep.md](./qwen_text_only_alpha_testflight_prep.md) |
| Bundle ID / ASC / signing | [bundle_id_decision_memo.md](./bundle_id_decision_memo.md) |
| GGUF placement | [models/README.md](../../models/README.md) |

---

## When to revisit this summary

- A new TestFlight **build number** ships (after implementation + upload PR, not docs-only).
- A **Release blocker** is opened or closed on build `1`.
- Lab devices change (third physical iPhone added to policy).
- Product explicitly approves build `2` binary respin.

Until then, treat **build 1** as the stable internal alpha operations baseline.
