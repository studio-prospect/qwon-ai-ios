# QWON Text Alpha — Two-Device Lab Evidence

**Build line:** TestFlight `0.1.0` (build `1` baseline · build `2` active) · tag `qwon-text-alpha-0.1.0-rc1` on build `1` archive commit `d4f2a0b`

**Bundle ID:** `jp.studio-prospect.qwon.ios` · ASC **QWON** (`6775685841`)

**Lab policy:** [QWON prep — tier policy](./qwon_text_alpha_testflight_prep.md#physical-device-lab-tier-policy) — **Wang primary + Matisse secondary**; same two physical devices as PREXUS alpha. Do not widen ASC `internal_tester` without product decision.

**Historical PREXUS ledger:** [PREXUS frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) on `jp.studio-prospect.prexus.ios` — **immutable**; do not edit or merge into this file.

Related: [QWON TestFlight prep](./qwon_text_alpha_testflight_prep.md) · [PREXUS lab evidence](./qwen_text_only_alpha_lab_evidence.md) (field definitions) · [Tester instructions](./qwen_text_only_alpha_tester_instructions.md) (feedback template until QWON-specific copy exists)

---

## Retention rules (do not commit binaries)

Same rules as [PREXUS lab evidence](./qwen_text_only_alpha_lab_evidence.md#retention-rules-do-not-commit-binaries). **QWON ops root:**

```text
~/QWON-alpha-evidence/qwon-text-0.1.0-build1/
  wang-qwon-testflight-chat-2026-06-02.png
  matisse-qwon-testflight-chat-2026-06-02.png
  (optional diagnostics PNGs — on file (ops) when captured)
```

Build `2` keyboard verification: verbal / spot-check on device; no new frozen ledger required per [secondary tier](./qwon_text_alpha_testflight_prep.md#physical-device-lab-tier-policy).

Never add PNG, IPA, GGUF, or raw logs under `docs/`.

---

## Evidence fields

Use the field list in [PREXUS lab evidence § fields](./qwen_text_only_alpha_lab_evidence.md#evidence-fields-every-lab-device-every-capture). Expected outcomes per tier: [QWON prep § tier policy](./qwon_text_alpha_testflight_prep.md#physical-device-lab-tier-policy) and [PREXUS expected outcomes](./qwen_text_only_alpha_lab_evidence.md#expected-outcomes-wang-vs-matisse) (runtime labels unchanged).

---

## Frozen ledger: QWON 0.1.0 build 1

Baseline captured **2026-06-02** after TestFlight install on **QWON** bundle. Aligns with [Wang](./qwon_text_alpha_testflight_prep.md#wang-testflight-verification-2026-06-02) and [Matisse](./qwon_text_alpha_testflight_prep.md#matisse-testflight-verification-2026-06-02) verification sections in prep doc.

**Ops filing status (2026-06-02):** Wang and Matisse Chat PNGs on file under `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/`.

### Wang

| Field | Value |
| --- | --- |
| Lab name | Wang |
| Device model | iPhone 17 (`iPhone18,3`) |
| iOS version | **26.5** (same lab device as [PREXUS Wang row](./qwen_text_only_alpha_lab_evidence.md#wang)) |
| TestFlight build | `0.1.0 (1)` — `jp.studio-prospect.qwon.ios` |
| ASC app | **QWON** (`6775685841`) |
| GGUF pushed | yes — `prexus-local-mvp.gguf` (required for llama.cpp on TestFlight) |
| Chat result | pass — prompt: *6月最初の満月は何日？*; **Local runtime** + **llama.cpp On-Device Runtime** |
| Diagnostics expectation | **Local runtime** + `answered_by=llama.cpp On-Device Runtime` in **Runtime Diagnostics** |
| Diagnostics screenshot | `on file (ops)` — optional; Chat corroboration filed |
| Chat screenshot | `on file (ops)` — `wang-qwon-testflight-chat-2026-06-02.png` |
| Known deviation | none for QWON `0.1.0 (1)` baseline |

### Matisse

| Field | Value |
| --- | --- |
| Lab name | Matisse |
| Device model | iPhone XS Max (`iPhone11,6`) |
| iOS version | **18.7.9** (same lab device as [PREXUS Matisse row](./qwen_text_only_alpha_lab_evidence.md#matisse)) |
| TestFlight build | `0.1.0 (1)` — `jp.studio-prospect.qwon.ios` |
| ASC app | **QWON** (`6775685841`) |
| GGUF pushed | yes — acceptable; A12 does not enable llama.cpp |
| Chat result | pass — prompt: *6月最初の満月は何日？*; **Local runtime** + **Embedded Heuristic Runtime** |
| Diagnostics expectation | **Local runtime** + *Local lightweight fallback path without a packaged LLM.* — **not** llama.cpp |
| Diagnostics screenshot | `on file (ops)` — optional |
| Chat screenshot | `on file (ops)` — `matisse-qwon-testflight-chat-2026-06-02.png` |
| Known deviation | GGUF present but **no llama.cpp** (A12 gate) — **accepted pass**, not failure |

---

## Build 2 spot check (2026-06-02) — not frozen ledger

UX-only build ([prep § build 2](./qwon_text_alpha_testflight_prep.md#testflight-build-2-2026-06-02)). **Secondary tier:** no new Diagnostics ledger; install + feature check only.

| Device | TestFlight build | Check | Result |
| --- | --- | --- | --- |
| Wang | `0.1.0 (2)` | Return key in Chat | **Pass** — sends (not newline) |
| Matisse | `0.1.0 (2)` | Return key in Chat | **Pass** — sends (not newline); launch crash-free |

Full frozen ledger rows apply on **baseline / runtime-change** builds only — see [tier table](./qwon_text_alpha_testflight_prep.md#per-build-verification-tiers).

---

## Adding a new ledger subsection

When `CFBundleVersion` increments with **runtime or routing changes** (not minor UX-only):

1. Create ops folder, e.g. `~/QWON-alpha-evidence/qwon-text-0.1.0-build3/`.
2. Capture per [PREXUS adding subsection steps](./qwen_text_only_alpha_lab_evidence.md#adding-a-new-ledger-subsection) — use **QWON** bundle paths and this file.
3. Append `### Frozen ledger: QWON 0.1.0 build N` below — **do not** edit [build 1 rows](#frozen-ledger-qwon-010-build-1).
4. Docs PR: metadata only; `git diff --check` before merge.

For **UX-only** builds, append a [spot-check table](#build-2-spot-check-2026-06-02--not-frozen-ledger) instead of full frozen rows.

---

## Consistency with ASC copy

| ASC / onboarding statement | Evidence alignment |
| --- | --- |
| QWON bundle, not PREXUS TestFlight app | Ledger rows reference `jp.studio-prospect.qwon.ios` + ASC `6775685841` |
| Wang primary: llama.cpp after GGUF | [Wang build 1 row](#wang) |
| Matisse secondary: Embedded Heuristic acceptable | [Matisse build 1 row](#matisse) |
| Return sends on build `2` | [Build 2 spot check](#build-2-spot-check-2026-06-02--not-frozen-ledger) |

If [ASC What to Test](./qwon_text_alpha_testflight_prep.md#asc-what-to-test-copy) changes, update this table and the prep copy block together.
