# QWON — M3 Network Disclosure + Device Expectation Memo (Gates 6 & 7)

**Last updated:** 2026-06-06 (Batch C answers recorded — Gates 6–7 still Pending)
**Status:** **Evidence memo** — Batch C answers recorded; **not** M3 implementation approval, **not** Gates 6/7 **Ready**, **not** Build `4` approval.
**Purpose:** Document open **privacy / network disclosure copy** (Gate 6) and **Wang / Matisse behavior expectation** (Gate 7) for a future **M3 in-app download** spike of `prexus-local-mvp.gguf`.

Related: [M3 readiness checklist — Gates 6 & 7](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Batch C review](./qwon_m3_gate_readiness_review_plan.md#batch-c-review-session-2026-06-05) · [Settings / Diagnostics copy plan](./qwon_model_download_gguf_ux_plan.md#settings--diagnostics-copy-plan) · [Device expectations](./qwon_model_download_gguf_ux_plan.md#device-expectations) · [M2 guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement) · [Gate 3 compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [Gate 4/5 storage memo](./qwon_m3_storage_integrity_memo.md)

---

## Baseline artifact (unchanged)

| Field | Value |
| --- | --- |
| **On-device filename** | `prexus-local-mvp.gguf` — preserved |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — **no in-app download** today |
| **M2 alpha copy** | Settings → **Place GGUF via Mac** — USB ops; **QWON does not download the GGUF in-app** |
| **Build `4`** | **Not approved** |

---

## Why Gates 6 and 7 are paired

| Gate | Question | Depends on |
| --- | --- | --- |
| **Gate 6** | What does the user see **before** network use for model fetch? | Product privacy/App Store posture; Gate 3 legal review |
| **Gate 7** | What runtime behavior and copy does the user see **after** fetch/placement by device tier? | M1/M2 status UX; integrity states ([Gate 5 memo](./qwon_m3_storage_integrity_memo.md)) |

Network disclosure without device-tier clarity risks Matisse users interpreting heuristic runtime as a failed download. Device copy without network disclosure risks surprise fetch and local-first positioning drift.

---

## Current M2 copy anchor (must stay consistent)

M3 candidate copy must **extend**, not contradict, merged M1/M2 surfaces. Current alpha strings (Swift `QWONUILabelCopy` — **not** final M3 UI):

| Surface | Current M2-relevant copy (paraphrased) |
| --- | --- |
| **Guided placement nav** | USB push from Mac — **QWON does not download the GGUF in-app** |
| **Guided placement intro** | Cannot download/install inside app in this alpha; Mac ops + USB + verify in Settings |
| **Wang expectation** | After placement → llama.cpp On-Device Runtime; missing/corrupt → fallback without crash |
| **Matisse expectation** | Embedded Heuristic Runtime expected; GGUF optional, **not required for pass** |
| **Support detail** | Do **not** tell testers to tap download — in-app download **not available** |
| **Model status (M1)** | Wang/Matisse tier chips; Present (unverified); Matisse missing GGUF **not a failure** |

When M3 adds download UX, M2 **Place GGUF via Mac** remains ([Gate 8](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist)) — copy must present download as **optional advanced path on supported hardware**, not replacement of USB guidance.

---

## Gate 6 — Privacy / network disclosure copy

### Requirements (answered direction — not Ready)

| Requirement | Status |
| --- | --- |
| **Disclose network use** before model HTTPS fetch | **Answered direction** — disclose one-time ~400 MB model download before fetch |
| **No surprise background fetch** | **Answered** — user-initiated foreground only for M3 |
| **Local-first positioning** | Answers run on-device **after** model is installed; network is for **acquisition**, not every chat turn |
| **Not offline-only claim** | Must **not** say “fully offline” or imply QWON never uses network if download exists |
| **App Store privacy label** | **Answered direction** — release-time ASC/privacy-label re-check required before any download build |
| **TestFlight tester notes** | **Answered direction** — optional ~400 MB user-initiated local model download; Build `4` separately gated |
| **Settings / onboarding strings** | **Answered direction** — Settings-first; no persistent first-launch onboarding by default |

### Surfaces to cover (when M3 exists)

| Surface | Gate 6 open question |
| --- | --- |
| **Settings → Local Runtime** | Pre-download disclosure + link to Mac fallback |
| **Download confirmation** | One-tap consent before URLSession/fetch starts |
| **In-progress download** | Visible progress; no hidden retry loops |
| **Privacy policy / ASC** | Product/legal — not decided in this memo |
| **Onboarding (if shown)** | Reuse Settings tone; avoid duplicate conflicting claims |

### Candidate copy — **answered direction (not Swift approval)**

> **Label:** These strings record Product/Codex direction for Gate **6**. They still require a separate Gates **6–7** Ready sign-off before any M3 spike plan.

**Settings — before download (Wang-class, optional feature framing):**

- *Draft A:* “Install the local model (~400 MB) over Wi‑Fi or cellular. After install, chat runs on this device without sending messages to a cloud model for the local path.”
- *Draft B:* “Download uses your network once. QWON stores the model on this device only.”

**Avoid:**

- “Fully offline assistant”
- “No network required” (after download feature exists)
- “Tap to download” in **current** build `3` / M2-only builds

**Surprise-fetch prohibition (product rule):**

- No download on first launch without explicit user action
- No background URLSession for model fetch unless Gate 6 + Product approve separate background policy
- No model fetch while user is on Matisse-only heuristic path without tier-appropriate copy

### Gate 6 disposition

| Field | Value |
| --- | --- |
| **Recommended status** | **Pending** |
| **Ready?** | **No** — Batch C answers recorded; separate Gate 6 Ready sign-off still required |
| **Blocked by** | Gate **6** Ready sign-off |

---

## Gate 7 — Wang / Matisse behavior expectation

### Runtime expectations (required direction — implementation not approved)

| Tier | Hardware | GGUF / download | Expected `answered_by` | Missing / corrupt GGUF |
| --- | --- | --- | --- | --- |
| **Wang** | A17 Pro+ | Optional; enables llama.cpp path | **`llama.cpp On-Device Runtime`** when verified file loads | **Embedded Heuristic Runtime** fallback — **no crash** |
| **Matisse** | A12 | **Optional**; **not required** | **`Embedded Heuristic Runtime`** — **expected alpha path** | Same — missing GGUF **not a failure** |
| **Simulator** | — | N/A | Stub/fallback | No GGUF proof required |

Verified GGUF semantics tie to Gate 2/5 ([integrity states](./qwon_model_download_gguf_ux_plan.md#integrity-and-storage-requirements)). Until verified, M1 **Present (unverified)** copy remains valid.

### Copy requirements (directional)

| Requirement | Wang | Matisse |
| --- | --- | --- |
| Download availability | **Wang-primary** optional model install | Must **not** pressure install; heuristic is **expected** |
| Device failure framing | Missing model ≠ broken phone | Heuristic runtime ≠ failed download or unsupported device error |
| Diagnostics | `primary_failure=model_asset_unavailable` + `fallback_reason=embedded_heuristic` explained plainly | `answered_by=Embedded Heuristic Runtime` = **normal** |
| Post-download | llama.cpp when load succeeds | Download success must **not** imply Matisse “graduated” to llama.cpp if hardware unsupported |

### Candidate copy — **answered direction (not Swift approval)**

**Settings — Wang (aligned with M1/M2):**

- *Draft:* “Wang-class devices can use llama.cpp On-Device Runtime after `prexus-local-mvp.gguf` is installed and verified. Until then, Embedded Heuristic fallback runs without crashing.”

**Settings — Matisse (aligned with M1/M2):**

- *Draft:* “Matisse-class devices use Embedded Heuristic Runtime as the expected local path for this alpha. Installing the GGUF is optional — not required for pass.”

**Download prompt — Matisse (if download UI is reachable):**

- *Draft:* “This device uses Embedded Heuristic Runtime by default. Downloading the model is optional and may not enable llama.cpp on this hardware tier.”
- **Avoid:** “Install required,” “Fix your device,” “Upgrade to unlock QWON”

**Download prompt — Wang:**

- *Draft:* “Optional: download the local model for on-device Qwen inference. You can also use Place GGUF via Mac.”

**Chat / fallback strip (missing model on Wang):**

- *Draft:* “Local model not available — answered with built-in fallback. See Settings → Local Runtime.”

### Diagnostic mapping (unchanged contract)

| Diagnostic | Plain meaning (Gate 7) |
| --- | --- |
| `answered_by=llama.cpp On-Device Runtime` | Local GGUF path used (Wang + verified file) |
| `answered_by=Embedded Heuristic Runtime` | Built-in fallback — **expected on Matisse**; also Wang when GGUF missing/corrupt |
| `primary_failure=model_asset_unavailable` | No usable GGUF at expected path |
| `fallback_reason=embedded_heuristic` | Fallback after primary local runtime could not run |

### Gate 7 disposition

| Field | Value |
| --- | --- |
| **Recommended status** | **Pending** |
| **Ready?** | **No** — Batch C answers recorded; separate Gate 7 Ready sign-off still required |
| **Blocked by** | Gate **7** Ready sign-off |

---

## M2 ↔ M3 copy transition (answered direction)

| M2 today | M3 must preserve |
| --- | --- |
| “QWON does not download in-app” | True for build `3`; when download ships, replace with Gate 6 disclosure — **do not** leave contradictory strings |
| **Place GGUF via Mac** | Remains visible as fallback ([Gate 8](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist)) |
| Matisse “not a failure” | Must survive download feature — heuristic still expected |

Batch C answers record the migration direction: retire “does not download in-app” only in builds that ship download UX, keep **Place GGUF via Mac**, and preserve Matisse “not a failure” copy. A later implementation PR may polish exact strings but must preserve this meaning.

---

## Cross-gate dependencies

| Gate | Relationship |
| --- | --- |
| **Gate 3** | Privacy label / redistribution may constrain network copy |
| **Gate 5** | Partial/corrupt states affect Settings/Diagnostics strings |
| **Gate 8** | Mac + USB copy remains; download is additive |
| **Gate 9** | TestFlight notes for any build shipping download UX — **not approved** |

---

## Batch C review status (2026-06-05)

**Review:** [Batch C session](./qwon_m3_gate_readiness_review_plan.md#batch-c-review-session-2026-06-05) documented open items; [answer intake](./qwon_m3_gate_answer_intake.md#batch-c-network-disclosure-and-device-expectation-answer-details-2026-06-06) records Q-C-01…Q-C-14. Gates **6–7** remain **Pending** until separate Ready sign-off.

### Gate 6 — answered, Ready sign-off pending (summary)

| Topic | Status |
| --- | --- |
| Network disclosure copy | One-time ~400 MB model download disclosed before fetch |
| No surprise background fetch | Foreground user-initiated only for M3 |
| Privacy label / ASC impact | Release-time ASC/privacy-label re-check required before any download build |
| TestFlight tester notes | Optional ~400 MB user-initiated local model download; Build `4` separately gated |
| Settings / onboarding strings | Settings-first; no persistent first-launch onboarding by default |

Full item list: [G6-1 … G6-12](./qwon_m3_gate_readiness_review_plan.md#gate-6--open-items-privacy--network-disclosure-copy)

### Gate 7 — answered, Ready sign-off pending (summary)

| Topic | Status |
| --- | --- |
| Wang optional download framing | Wang-primary optional local model download |
| Matisse heuristic expected copy | Embedded Heuristic Runtime expected, not failure |
| Download visibility by tier | Wang-primary; Matisse de-emphasized if visible |
| Diagnostics mapping (partial/corrupt) | `partial` not installed; `corrupt` verification failed; fallback remains available |
| Fallback / chat strip copy | Local model not ready; answered with built-in fallback; see Settings |
| Verified vs unverified copy | Gate 2/5 verification states define the semantics |

Full item list: [G7-1 … G7-12](./qwon_m3_gate_readiness_review_plan.md#gate-7--open-items-wang--matisse-device-expectation)

---

## Recommended Product / Codex actions before Gates 6/7 Ready sign-off

1. Open a docs-only Gates **6–7** Ready sign-off PR if Product/Codex accepts the recorded Batch C answers.
2. Keep final UI implementation and copy polish out of scope until all gates are Ready and a separate M3 spike plan exists.
3. Preserve release-time ASC/privacy/export re-check under Gate **9** before any TestFlight binary with download UX.

---

## Checklist disposition (Gates 6 & 7)

| Gate | Recommended status | M3 implementation | Build `4` |
| --- | --- | --- | --- |
| **6 — Privacy / network disclosure** | **Pending** | **Not approved** | **Not approved** |
| **7 — Wang / Matisse expectation** | **Pending** | **Not approved** | **Not approved** |

Gates **1–5** are Ready; Gates **6–9** remain **Pending** until individually marked **Ready**. **Do not open M3 spike** until **all** gates are Ready.

---

## Evidence boundaries (this PR)

| Included | Excluded |
| --- | --- |
| Gate 6/7 open questions and M2 alignment | Final UI copy approval |
| Gate 6/7 answer direction and candidate copy | Swift / UI implementation |
| Diagnostic mapping reference | Privacy label final decision |
| Links from M3 checklist | Gate Ready sign-off |
| — | Network fetch prototype; GGUF commit |
