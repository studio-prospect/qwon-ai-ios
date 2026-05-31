# Qwen Text-Only Alpha — Documentation Index

**Last updated:** 2026-05-31 (post PR #39 on `main`)
**Purpose:** **Information architecture only** — where to start reading and what each doc owns. Does **not** change release state, scope, decision rules, or build `2` approval.

**Release state (unchanged):** TestFlight `0.1.0 (1)` · tag `qwen-text-alpha-0.1.0-rc1` · build `2` **not approved** · lab **Wang + Matisse** only.

**Last validation:** 2026-05-31 — relative link / anchor validation passed after PR #41. **Docs setup:** complete; start from [status summary](./qwen_text_only_alpha_status_summary.md) then this index.

---

## Start here (reading order)

| Order | Document | Why first |
| --- | --- | --- |
| **1** | [qwen_text_only_alpha_status_summary.md](./qwen_text_only_alpha_status_summary.md) | **Current state** — one page: active build, completed baseline, open/watch, decision rules |
| **2** | [qwen_text_only_alpha_handoff.md](./qwen_text_only_alpha_handoff.md) | **Internal ops handoff** — operating loop, do-not rules, Release blocker response (not public-facing) |

Then open the doc for your task using the table below.

---

## Document responsibilities (one line each)

| Document | Responsibility |
| --- | --- |
| [qwen_text_only_alpha_status_summary.md](./qwen_text_only_alpha_status_summary.md) | **Current state / first read** — stable build `1` snapshot and when to revisit |
| [qwen_text_only_alpha_handoff.md](./qwen_text_only_alpha_handoff.md) | **Internal ops handoff** — next steps, do-not rules, minimal blocker PR scope |
| [qwen_text_only_alpha_release.md](./qwen_text_only_alpha_release.md) | **Scope / non-goals** — what the alpha includes and excludes |
| [qwen_text_only_alpha_release_notes.md](./qwen_text_only_alpha_release_notes.md) | **Known limitations / build 2 plan / triage / feedback log** — canonical policy tables |
| [qwen_text_only_alpha_release_readiness.md](./qwen_text_only_alpha_release_readiness.md) | **Gates / checklists** — RC criteria, next build gate, build `2` triage decision |
| [qwen_text_only_alpha_tester_instructions.md](./qwen_text_only_alpha_tester_instructions.md) | **Tester flow / feedback template** — lab steps and report format |
| [qwen_text_only_alpha_lab_evidence.md](./qwen_text_only_alpha_lab_evidence.md) | **Evidence fields / frozen ledger** — ops filenames, retention, build `1` sign-off record |
| [qwen_text_only_alpha_testflight_prep.md](./qwen_text_only_alpha_testflight_prep.md) | **ASC / TestFlight ops** — upload history, onboarding copy, lab policy |
| [bundle_id_decision_memo.md](./bundle_id_decision_memo.md) | **Bundle ID decision** — `jp.studio-prospect.prexus.ios`, ASC app, signing gates |
| [agent_collaboration_workflow.md](./agent_collaboration_workflow.md) | **Codex / Cursor roles** — planning vs implementation vs merge readiness |

**Related (outside this index):** [models/README.md](../../models/README.md) (GGUF placement) · [local_inference_mvp.md](../requirements/local_inference_mvp.md) (P1-1 architecture)

---

## Read by task

| You need to… | Open |
| --- | --- |
| See if build `2` is allowed yet | [status summary](./qwen_text_only_alpha_status_summary.md) → [readiness: next build gate](./qwen_text_only_alpha_release_readiness.md#next-build-gate-before-build-2) |
| Run day-to-day alpha ops | [handoff](./qwen_text_only_alpha_handoff.md) |
| File or check lab screenshots | [lab evidence](./qwen_text_only_alpha_lab_evidence.md) — **do not** duplicate [frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) rows elsewhere |
| Submit tester feedback | [feedback template](./qwen_text_only_alpha_tester_instructions.md#tester-feedback-report-template) only |
| Intake / triage one report (build `1`) | [status summary § feedback intake](./qwen_text_only_alpha_status_summary.md#feedback-intake-readiness) → [processing rules](./qwen_text_only_alpha_release_notes.md#feedback-intake-processing-build-1) → [feedback log](./qwen_text_only_alpha_release_notes.md#tester-feedback-log-build-1) |
| Triage an issue | [release notes: known issues](./qwen_text_only_alpha_release_notes.md#known-issues-triage-for-build-1) · [feedback log](./qwen_text_only_alpha_release_notes.md#tester-feedback-log-build-1) |
| Prepare ASC / TestFlight / GGUF push | [TestFlight prep](./qwen_text_only_alpha_testflight_prep.md) |
| Confirm alpha scope | [release scope](./qwen_text_only_alpha_release.md) |
| Ship a fix after Release blocker | [handoff: if blocker](./qwen_text_only_alpha_handoff.md#if-a-release-blocker-appears) → minimal implementation PR → then ops steps in [readiness](./qwen_text_only_alpha_release_readiness.md) |

---

## Canonical content (link here; do not copy)

Keep a **single source** for these sections. Other docs should link, not restate tables or templates.

| Content | Canonical location |
| --- | --- |
| Build `1` frozen ledger rows | [lab evidence § frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) |
| Known issues triage | [release notes § triage](./qwen_text_only_alpha_release_notes.md#known-issues-triage-for-build-1) |
| Tester feedback template | [tester instructions § template](./qwen_text_only_alpha_tester_instructions.md#tester-feedback-report-template) |
| Feedback intake processing (build `1`) | [release notes § intake processing](./qwen_text_only_alpha_release_notes.md#feedback-intake-processing-build-1) |
| Release blocker / build `2` decision rules | [status summary § decision rules](./qwen_text_only_alpha_status_summary.md#decision-rules) · [readiness § build 2 decision](./qwen_text_only_alpha_release_readiness.md#build-2-binary-respin-decision-triage) |
| TestFlight upload history (2026-05-31) | [TestFlight prep § upload](./qwen_text_only_alpha_testflight_prep.md#testflight-upload-2026-05-31) |
| Binary respin reason (before build `2`) | [release notes § binary respin](./qwen_text_only_alpha_release_notes.md#binary-respin-reason-required-before-cut) |

---

## Duplicate link lists

Several alpha docs previously repeated the same doc table. Prefer **this index** for navigation; individual docs keep task-specific links and anchors only.
