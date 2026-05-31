# Qwen Text-Only Alpha — Two-Device Lab Evidence

**Build line:** TestFlight `0.1.0` (build `1`) · tag `qwen-text-alpha-0.1.0-rc1`

**Lab policy:** [Physical device lab](./qwen_text_only_alpha_testflight_prep.md#physical-device-lab-ops-policy) — **Wang + Matisse only**; do not widen ASC `internal_tester` until a third physical device is added.

This doc fixes **what to collect**, **expected outcomes per device**, and **where to store artifacts** (outside git). It does not change app behavior.

Related: [docs index](./qwen_text_only_alpha_docs_index.md) · [TestFlight prep](./qwen_text_only_alpha_testflight_prep.md) · [Tester instructions](./qwen_text_only_alpha_tester_instructions.md) · [ASC What to Test](./qwen_text_only_alpha_testflight_prep.md#asc-what-to-test-copy) · [Onboarding message](./qwen_text_only_alpha_testflight_prep.md#tester-onboarding-message)

---

## Retention rules (do not commit binaries)

| Artifact type | Store in git? | Where ops keeps files |
| --- | --- | --- |
| Runtime Diagnostics screenshots | **No** | Team ops storage only (see [naming](#filename-and-path-placeholders)) |
| Chat screenshots (optional) | **No** | Same ops folder |
| `alpha_smoke_wang.sh` JSON | **No** | `.eval-logs/` (repo-local, [gitignored](../../.gitignore)) |
| Device syslog / crash reports | **No** | Ops folder or Apple crash portal; reference filename in ledger only |
| GGUF (`prexus-local-mvp.gguf`) | **No** | `models/` (gitignored) |
| This evidence ledger (text) | **Yes** | This file — **metadata and pass/fail only** |

**In git docs, record either:**

- `on file (ops)` — artifact exists in team storage, or
- **filename placeholder** below (not the image itself).

Never add PNG/JPEG, IPA, `.gguf`, or raw device logs under `docs/` for alpha evidence.

---

## Evidence fields (every lab device, every capture)

Collect one row per device per **build number** (re-run when `CFBundleVersion` changes).

| Field | Description | Example |
| --- | --- | --- |
| **Lab name** | Devicectl / USB name substring | `Wang`, `Matisse` |
| **Device model** | Marketing or machine id | `iPhone 17`, `iPhone XS Max (iPhone11,6)` |
| **iOS version** | Settings → General | `18.x` |
| **TestFlight build** | Marketing + build | `0.1.0 (1)` |
| **GGUF pushed** | `push_local_model_to_device.sh` run for this build | `yes` / `no` |
| **Chat result** | One short prompt + assistant reply | `pass` / `fail` + one-line note |
| **Diagnostics expectation** | What a reviewer should see (device-specific — below) | see Wang / Matisse tables |
| **Diagnostics screenshot** | Ops filename only or `on file (ops)` | `wang-0.1.0-1-diagnostics.png` |
| **Known deviation** | Intentional or accepted difference | `none` or free text |

Optional (Wang only, before respin): `alpha_smoke_wang.sh` log → `.eval-logs/wang-alpha-smoke-<timestamp>.json` (gitignored).

---

## Expected outcomes (Wang vs Matisse)

### Wang — primary Qwen path (A17 Pro+)

| Surface | Pass criteria |
| --- | --- |
| **Chat** | Primary chip **Local runtime**; backend/model includes **llama.cpp On-Device Runtime** (after GGUF push) |
| **Runtime Diagnostics** | Latest entry: **Local runtime** badge; detail includes **`answered_by=llama.cpp On-Device Runtime`** |
| **Failure** | Missing llama.cpp after confirmed GGUF push on this device |

### Matisse — secondary heuristic path (A12)

| Surface | Pass criteria |
| --- | --- |
| **Chat** | Primary chip **Local runtime** (not **Fallback** for routine post-GGUF chat); secondary chip **Embedded Heuristic Runtime**; caption may be *Local lightweight fallback path without a packaged LLM.* |
| **Runtime Diagnostics** | **Local runtime** badge; same embedded-heuristic backend/detail as Chat |
| **Not a failure** | **No** `answered_by=llama.cpp` — hardware gate; GGUF on device does not enable llama on A12 |

**UI reference:** primary chip = `executionMode` (`ChatView`); backend/model = `execution.model` (`runtimeBadgeRow`). See [Matisse UI note](./qwen_text_only_alpha_testflight_prep.md#matisse-testflight-verification-2026-05-31) in prep doc.

---

## Filename and path placeholders

**Canonical ops root (outside git):** `~/PREXUS-alpha-evidence/qwen-text-0.1.0-build1/`

Team drive equivalents are fine; keep the same filenames. See `MANIFEST.txt` in that folder (ops-only, not committed).

```text
~/PREXUS-alpha-evidence/qwen-text-0.1.0-build1/
  MANIFEST.txt                     # ops index (optional, not in git)
  wang-0.1.0-1-diagnostics.png     # Settings → Runtime Diagnostics
  matisse-0.1.0-1-diagnostics.png
  wang-0.1.0-1-chat.png            # optional corroboration
  matisse-0.1.0-1-chat.png
```

**Docs convention:** list filenames in the [ledger](#frozen-ledger-010-build-1) only. Do not copy images into `docs/product/` or `docs/design/screenshots/` for TestFlight lab evidence (`docs/design/screenshots/` is for XCTest surface spec, not alpha ops).

**Smoke logs (Wang):** `.eval-logs/wang-alpha-smoke-*.json` — local machine, gitignored; optional cross-reference in `Known deviation` if a manual run disagrees with TestFlight UI.

---

## Frozen ledger: 0.1.0 build 1

Baseline captured **2026-05-31** after TestFlight install + GGUF push on both lab devices. Aligns with [Wang](./qwen_text_only_alpha_testflight_prep.md#wang-testflight-verification-2026-05-31) and [Matisse](./qwen_text_only_alpha_testflight_prep.md#matisse-testflight-verification-2026-05-31) verification sections.

**Ops filing status (2026-05-31):** Wang and Matisse diagnostics + chat PNGs filed under `~/PREXUS-alpha-evidence/qwen-text-0.1.0-build1/` (see rows below).

### Wang

| Field | Value |
| --- | --- |
| Lab name | Wang |
| Device model | iPhone 17 (`iPhone18,3`) |
| iOS version | **26.5** (`osBuildUpdate` 23F77, devicectl 2026-05-31) |
| TestFlight build | `0.1.0 (1)` — `jp.studio-prospect.prexus.ios` installed |
| GGUF pushed | yes — `prexus-local-mvp.gguf` in Documents/Models (verified on device) |
| Chat result | pass — TestFlight chat; **Local runtime** + **llama.cpp On-Device Runtime** strip |
| Diagnostics expectation | **Local runtime** + `answered_by=llama.cpp On-Device Runtime` in **Runtime Diagnostics** |
| Diagnostics screenshot | `on file (ops)` — `wang-0.1.0-1-diagnostics.png` (2026-05-31) |
| Chat screenshot (optional) | `on file (ops)` — `wang-0.1.0-1-chat.png` |
| Known deviation | none for alpha 0.1.0 (1) baseline |

### Matisse

| Field | Value |
| --- | --- |
| Lab name | Matisse |
| Device model | iPhone XS Max (`iPhone11,6`) |
| iOS version | **18.7.9** |
| TestFlight build | `0.1.0 (1)` — `jp.studio-prospect.prexus.ios` installed |
| GGUF pushed | yes — `push_local_model_to_device.sh "Matisse"` |
| Chat result | pass — `Hello PREXUS`; **Local runtime** primary chip + **Embedded Heuristic Runtime** backend |
| Diagnostics expectation | **Local runtime** badge + *Local lightweight fallback path without a packaged LLM.* — **not** llama.cpp |
| Diagnostics screenshot | `on file (ops)` — `matisse-0.1.0-1-diagnostics.png` |
| Chat screenshot (optional) | `on file (ops)` — `matisse-0.1.0-1-chat.png` |
| Known deviation | GGUF present but **no llama.cpp** (A12 gate) — **accepted pass**, not failure |

---

## Consistency with ASC copy

| ASC / onboarding statement | Evidence doc alignment |
| --- | --- |
| Two-device lab only; do not install without dev Mac | Ledger covers **Wang + Matisse** only; no third row until hardware added |
| A17 Pro+: `answered_by=llama.cpp` after GGUF | **Wang** row |
| Older iPhones: Local runtime chip + Embedded Heuristic backend/detail | **Matisse** row; missing llama.cpp = pass |
| Runtime Diagnostics via Settings → Recent Runtime Decisions | Screenshot field targets that screen |
| Do not widen `internal_tester` | Same as [prep sign-off](./qwen_text_only_alpha_testflight_prep.md#sign-off) |

If ASC What to Test text is edited, update this table and the [prep copy blocks](./qwen_text_only_alpha_testflight_prep.md#asc-what-to-test-copy) together.

---

## When to refresh evidence

Refresh on every TestFlight **`CFBundleVersion`** increase (respins under `0.1.0` or a new marketing version such as `0.1.1`). Also refresh after runtime/routing changes that alter Chat or Diagnostics labels, even if the build number is unchanged (note the reason in `Known deviation`).

---

## Adding a new ledger subsection

Use this when moving from build `1` to build `2` (or `0.1.1` build `1`). **Do not** modify or delete [Frozen ledger: 0.1.0 build 1](#frozen-ledger-010-build-1) rows.

### Steps (short)

1. **Record the change** in [release notes](./qwen_text_only_alpha_release_notes.md) and [next build gate](./qwen_text_only_alpha_release_readiness.md#next-build-gate-before-build-2).
2. **Ops folder** — create a build-specific directory (do not reuse build `1` files):

   ```text
   ~/PREXUS-alpha-evidence/qwen-text-0.1.0-build2/
   ```

   Pattern: `qwen-text-<CFBundleShortVersionString>-build<CFBundleVersion>/`. Keep `MANIFEST.txt` in ops only (not in git).

3. **Screenshots** — per device, after TestFlight install + GGUF push:

   | File | Screen |
   | --- | --- |
   | `wang-0.1.0-2-diagnostics.png` | Settings → Recent Runtime Decisions |
   | `matisse-0.1.0-2-diagnostics.png` | same |
   | `wang-0.1.0-2-chat.png` | optional |
   | `matisse-0.1.0-2-chat.png` | optional |

   Adjust semver/build in filenames when marketing version changes (e.g. `wang-0.1.1-1-diagnostics.png`).

4. **Ledger** — append a new heading, e.g. `### Frozen ledger: 0.1.0 build 2`, with full Wang and Matisse tables (copy [template](#copy-paste-template-new-capture)).
5. **Wang pass:** `answered_by=llama.cpp On-Device Runtime` after GGUF push.
6. **Matisse pass:** **Local runtime** + **Embedded Heuristic Runtime** — not llama.cpp.
7. **Docs PR:** metadata only; `git diff --check` before merge.

Optional: Wang pre-upload `alpha_smoke_wang.sh` → reference `.eval-logs/wang-alpha-smoke-*.json` in `Known deviation` (gitignored).

---

## Copy-paste template (new capture)

```text
Lab name:
Device model:
iOS version:
TestFlight build: 0.1.0 (1)
GGUF pushed: yes / no
Chat result: pass / fail —
Diagnostics expectation: (Wang: llama.cpp | Matisse: Local runtime + Embedded Heuristic)
Diagnostics screenshot: on file (ops) — <filename>.png
Known deviation: none |
```
