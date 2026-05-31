# Qwen Text-Only Alpha — Internal Operations Handoff

**Last updated:** 2026-05-31 (post PR #38 on `main`)
**Audience:** Internal operators, release engineering, Cursor/Codex agents — **not** a public or App Store release document.
**Purpose:** Short **handoff memo** for stable build `1` TestFlight alpha: what to do next, what to avoid, and how to react if a **Release blocker** appears.

**Current state snapshot:** [status summary](./qwen_text_only_alpha_status_summary.md) (**read first**)

**Doc index:** [qwen_text_only_alpha_docs_index.md](./qwen_text_only_alpha_docs_index.md) — all alpha docs and canonical sections (navigation only).

**Not executed here:** `CFBundleVersion` bump, archive, TestFlight upload, git tag, app code, or edits to the [build 1 frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1).

---

## Current baseline

| Item | Value |
| --- | --- |
| **Active TestFlight** | `0.1.0` (build `1`) |
| **Git tag (build 1 IPA)** | `qwen-text-alpha-0.1.0-rc1` → commit `a021475` |
| **Bundle ID** | `jp.studio-prospect.prexus.ios` |
| **Lab devices** | **Wang** + **Matisse** only (`internal_tester`) |
| **Build 2** | **Not approved** — [plan only](./qwen_text_only_alpha_release_notes.md#build-2-plan-not-executed) |
| **Scope** | Qwen + **llama.cpp** text-only alpha |

**Device expectations:** Wang uses **llama.cpp** after GGUF push; Matisse uses **Embedded Heuristic** on A12 — **missing llama.cpp on Matisse is expected**, not a failure.

---

## Normal operating loop

0. **Start from** [status summary](./qwen_text_only_alpha_status_summary.md) (current state) and [docs index](./qwen_text_only_alpha_docs_index.md) (navigation); use this handoff for day-to-day ops.
1. **Collect feedback** using the [tester feedback report template](./qwen_text_only_alpha_tester_instructions.md#tester-feedback-report-template) only (no informal-only intake for triage decisions). Process per [feedback intake processing](./qwen_text_only_alpha_release_notes.md#feedback-intake-processing-build-1); append or update one row per [feedback log format](./qwen_text_only_alpha_release_notes.md#log-row-format-new-reports) (same row when **needs evidence** completes).
2. **Classify** each report (release engineering assigns final class):
   - **needs evidence** — missing Diagnostics fields and/or ops screenshot **filename**
   - **Docs/ops only** — onboarding, What to Test, GGUF push steps, ASC copy, ops naming
   - **Build 2 candidate** — real issue on build `1` but lab can continue on build `1` for now (**does not** approve build `2`)
   - **Release blocker** — reproducible on `0.1.0 (1)` with template-complete evidence; blocks alpha ops baseline
   - **Post-alpha** — OCR, camera, audio, LiteRT production, model download, etc.
3. **Docs/ops path:** Update docs and/or ASC copy in place — **no** new TestFlight build.
4. **Needs evidence path:** Ask tester to complete Diagnostics summary + ops screenshot filename (e.g. `wang-0.1.0-1-diagnostics.png`) — **do not** treat as build `2` approval.
5. **Release blocker path:** Add row to [known issues triage](./qwen_text_only_alpha_release_notes.md#known-issues-triage-for-build-1), fill [Binary respin reason](./qwen_text_only_alpha_release_notes.md#binary-respin-reason-required-before-cut), then open a **minimal implementation PR that fixes only the verified Release blocker** — **only after that** consider `CFBundleVersion = 2`, archive, upload, tag.

Classification detail: [tester instructions](./qwen_text_only_alpha_tester_instructions.md#classification-guidance-testers) · [TestFlight prep feedback section](./qwen_text_only_alpha_testflight_prep.md).

---

## Do not do (stable build `1` phase)

| Rule | Rationale |
| --- | --- |
| Do **not** widen `internal_tester` beyond Wang + Matisse | Two-device lab policy |
| Do **not** cut build `2` for docs/ops/ASC-only changes | [Next build gate](./qwen_text_only_alpha_release_readiness.md#next-build-gate-before-build-2) |
| Do **not** expand scope (LiteRT production, L2 selector, model download UX, OCR/camera/audio/compression) | [Alpha scope](./qwen_text_only_alpha_release.md) |
| Do **not** commit PNG/JPEG, device logs, GGUF, IPA, or ops `MANIFEST.txt` | Artifacts live under `~/PREXUS-alpha-evidence/` — docs cite `on file (ops)` only |
| Do **not** edit [build 1 frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) rows | Immutable sign-off record for `0.1.0 (1)` |
| Do **not** treat Matisse missing `answered_by=llama.cpp` as failure | A12 Embedded Heuristic path is the pass criteria |

---

## If a Release blocker appears

1. Confirm report is **template-complete** (Diagnostics fields + ops screenshot filename) and reproduces on TestFlight **`0.1.0 (1)`**.
2. Add or update a row in [known issues triage](./qwen_text_only_alpha_release_notes.md#known-issues-triage-for-build-1).
3. Fill **[Binary respin reason](./qwen_text_only_alpha_release_notes.md#binary-respin-reason-required-before-cut)** in release notes (required before any build `2` work).
4. Prepare a **minimal implementation PR that fixes only the verified Release blocker** (not docs-only; no unrelated scope).
5. **Only then** consider, in a separate ops PR: `CFBundleVersion = 2`, archive, TestFlight upload, tag `qwen-text-alpha-0.1.0-build2`, new ops evidence folder `~/PREXUS-alpha-evidence/qwen-text-0.1.0-build2/`, and a **new** ledger subsection (build `1` ledger stays frozen).

Until steps 1–3 are satisfied, **build 2 remains not approved**.

---

## If no Release blocker

- Keep TestFlight **`0.1.0 (1)`** active.
- Continue collecting template-based feedback; log rows in [tester feedback log](./qwen_text_only_alpha_release_notes.md#tester-feedback-log-build-1) when actionable.
- Update [status summary](./qwen_text_only_alpha_status_summary.md) **only when operational state changes** (new build shipped, blocker opened/closed, lab device policy change, explicit build `2` approval).

---

## Agent and operator roles

| Role | Responsibility |
| --- | --- |
| **Cursor** | Prepare docs-only and implementation PRs; run local validation; avoid policy invention in routing/memory/privacy |
| **Codex** | Review policy-sensitive changes and merge readiness; own architecture-sensitive decisions |
| **Product / operator** | ASC, TestFlight, provisioning, manual device ops, GGUF push, ops evidence filenames, tester comms |

Workflow reference: [agent collaboration](./agent_collaboration_workflow.md).

---

## Related docs

Full navigation: [documentation index](./qwen_text_only_alpha_docs_index.md). **Prerequisite:** [status summary](./qwen_text_only_alpha_status_summary.md) (current state).
