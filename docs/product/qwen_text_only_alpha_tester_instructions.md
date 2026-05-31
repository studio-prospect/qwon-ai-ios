# Qwen Text-Only Alpha — Tester Instructions

For internal / TestFlight testers validating the **text-only** local runtime slice.

Related: [release notes](./qwen_text_only_alpha_release_notes.md) · [RC checklist](./qwen_text_only_alpha_release_readiness.md) · [TestFlight prep](./qwen_text_only_alpha_testflight_prep.md)

Release status: internal TestFlight alpha `0.1.0 (1)` is available for `internal_tester`. Release engineers can use the [onboarding copy](./qwen_text_only_alpha_testflight_prep.md#tester-onboarding-message) and [What to Test copy](./qwen_text_only_alpha_testflight_prep.md#asc-what-to-test-copy).

## Before you start

1. **Device:** iPhone 15 Pro / 16 / 17 class (A17 Pro+) recommended for real Qwen output.
2. **Model:** Ensure `prexus-local-mvp.gguf` is on the device under `Documents/Models/` (developers use `./tools/scripts/push_local_model_to_device.sh "YourDeviceName"`).
3. **Build:** TestFlight `0.1.0 (1)` or a Debug build with llama.cpp linked.
4. **Unlock** the device and keep it connected while developers push the model.

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

### 2. With model (Qwen path)

1. Confirm GGUF is installed (developer-provided).
2. Send a short message.
3. Open **Settings → Runtime diagnostics**.
4. Latest entry should show:
   - Execution: **Local runtime**
   - Detail includes `answered_by=llama.cpp On-Device Runtime`

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

After four sends, open **Runtime diagnostics** — four entries with route + execution detail.

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
