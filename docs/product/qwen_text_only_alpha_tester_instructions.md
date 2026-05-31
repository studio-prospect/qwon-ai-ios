# Qwen Text-Only Alpha — Tester Instructions

For internal / TestFlight testers validating the **text-only** local runtime slice.

Related: [release notes](./qwen_text_only_alpha_release_notes.md) · [RC checklist](./qwen_text_only_alpha_release_readiness.md) · [TestFlight prep](./qwen_text_only_alpha_testflight_prep.md)

Release status: internal TestFlight alpha `0.1.0 (1)` is for the **two-device lab** only (Wang + Matisse). See [Physical device lab](./qwen_text_only_alpha_testflight_prep.md#physical-device-lab-ops-policy). Use [onboarding](./qwen_text_only_alpha_testflight_prep.md#tester-onboarding-message) and [What to Test](./qwen_text_only_alpha_testflight_prep.md#asc-what-to-test-copy).

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

1. Developer may still push GGUF (optional for ops); hardware gate uses **Embedded Heuristic Runtime** only.
2. Send a short message (e.g. `Hello PREXUS`).
3. Same **Runtime Diagnostics** screen as above.
4. Expect Chat banner **Embedded Heuristic Runtime** and detail *Local lightweight fallback path without a packaged LLM.* — **pass** if no crash (not a llama.cpp failure).

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

## Report template

```
Device: <model, iOS version>
Build: 0.1.0 (1) / <git sha if known>
GGUF present: yes / no

Chat launch: pass / fail
Qwen path (answered_by llama.cpp): pass / fail / not tested
Missing-model fallback: pass / fail / not tested
Sensitivity matrix: pass / fail / not tested
Diagnostics screenshot captured: yes / no
Notes:
```

## Out of scope for this alpha

Do not file as alpha blockers: missing OCR, compression, audio, camera, LiteRT default backend, or in-app model store.
