# Qwen Text-Only Alpha — Release Notes

**Release candidate:** Qwen + llama.cpp text-only alpha
**Target window:** 2026-06 mid-month (internal / TestFlight)
**Main reference:** [qwen_text_only_alpha_release.md](./qwen_text_only_alpha_release.md)

## What ships

- Text chat with local-first routing on supported iPhone hardware (A17 Pro-class+).
- Production local backend: **Qwen2.5-0.5B-Instruct Q4_K_M** via **llama.cpp** (`automatic` / `deviceRuntime`).
- Deterministic fallback to **embedded heuristic** when the GGUF is missing or llama.cpp fails (no crash).
- Four sensitivity modes: `localOnly`, `localPreferred`, `escalationAllowed`, `providerRestricted`.
- Runtime diagnostics: route, execution mode, `answered_by`, `primary_failure`, `fallback_reason` (when applicable).

## What does not ship

- LiteRT-LM as production behavior (eval/prototype only).
- L2 backend selector.
- OCR, compression v1, audio, live camera.
- In-app model download UX.
- Cloud-quality factual guarantees from the 0.5B local model.

## Known limitations

| Area | Limitation |
| --- | --- |
| Model size | ~400MB Q4_K_M; demo-grade, not encyclopedic |
| Facts / reasoning | May hallucinate; not a replacement for cloud models on hard tasks |
| Model install | Manual: `fetch_local_model.sh`, `push_local_model_to_device.sh`, or Documents placement — see [models/README.md](../../models/README.md) |
| Hardware | Real Qwen path requires A17 Pro-class+; other devices use embedded heuristic |
| Cloud keys | Without provider API keys, escalation routes reroute to local execution |
| Diagnostics | Stored locally on device (last 20 turns); not synced to cloud |
| Markdown fences | Local model output format varies; strict JSON eval is evidence-only, not chat UX |

## Upgrade path (post-alpha)

- Phase 1: OCR, compression v1, richer memory/RAG integration.
- LiteRT-LM: adoption only after policy/legal/thermal sign-off (see routing policy eval docs).
- Multimodal: Phase 2 (audio, camera).

## Verification artifacts

| Artifact | Location |
| --- | --- |
| RC checklist | [qwen_text_only_alpha_release_readiness.md](./qwen_text_only_alpha_release_readiness.md) |
| TestFlight prep | [qwen_text_only_alpha_testflight_prep.md](./qwen_text_only_alpha_testflight_prep.md) |
| Tester steps | [qwen_text_only_alpha_tester_instructions.md](./qwen_text_only_alpha_tester_instructions.md) |
| Automated Wang smoke | [`tools/scripts/alpha_smoke_wang.sh`](../../tools/scripts/alpha_smoke_wang.sh) → `.eval-logs/` (gitignored) |

## Build requirements (developers)

```bash
./tools/scripts/fetch_local_model.sh
./tools/scripts/build_llama_xcframework.sh   # once per machine
ruby tools/scripts/generate_xcodeproj.rb
```

Simulator-only checkouts without `llama.xcframework` can still run `PREXUSTests` on the default generated project; device builds need the framework.

---

## Build 2 plan (not executed)

**Status:** Planning only on `main` (post [next build gate](./qwen_text_only_alpha_release_readiness.md#next-build-gate-before-build-2), PR #34). **No** `Info.plist` bump, archive, TestFlight upload, or git tag has been cut for build `2` yet.

This section is for the **next app binary respin**, not a docs-only or evidence-only refresh. If the only changes are repository documentation, ASC copy, or ops screenshots for build `1`, **keep TestFlight `0.1.0 (1)`** and update docs / What to Test in place.

### Decision rule

| Situation | Action |
| --- | --- |
| **App/runtime binary changes** on the commit to archive (bugfix, routing, UI, llama linkage, etc.) | Proceed with build `2` per this plan after filling **Binary respin reason** below. |
| **Docs-only, ops evidence, or ASC text** with no IPA change | **Do not** create build `2`; stay on build `1` ([frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1)). |
| **Unclear** whether IPA changes | Default **no** new build until an implementation PR states the binary delta. |

### Planned versioning (when binary respin is approved)

| Field | Planned value | Notes |
| --- | --- | --- |
| Marketing version | `0.1.0` | Same line as build `1`; not `0.1.1` unless product explicitly reslices semver. |
| Build number | `2` | `CFBundleVersion` increment only. |
| Git tag (planned) | `qwen-text-alpha-0.1.0-build2` | Annotated tag on the **archived** commit; distinct from `qwen-text-alpha-0.1.0-rc1` (build `1`). |
| ASC / TestFlight label | `0.1.0 (2)` | Assign to **`internal_tester`** only (Wang + Matisse). |
| Ops folder (after evidence) | `~/PREXUS-alpha-evidence/qwen-text-0.1.0-build2/` | Create at evidence capture time; not in git. |
| Ledger | New subsection `### Frozen ledger: 0.1.0 build 2` | Append after upload + device evidence; [build 1 rows](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) stay **immutable**. |

### Binary respin reason (required before cut)

Record the **why** here (or link PR/issue) before bumping `CFBundleVersion`:

```text
Status: not approved — no binary respin queued on main as of 2026-05-31.
Planned trigger: <fill when implementation PR is ready — e.g. runtime fix, UI fix, signing/asset change>
```

Until this block is filled with an approved binary change, **recommendation: maintain TestFlight build `1`.**

### In scope (build 2 binary)

- Qwen + **llama.cpp** text-only alpha behavior only (same as build `1`).
- Two-device lab: **Wang** (llama.cpp path) + **Matisse** (Embedded Heuristic path).

### Out of scope (unchanged)

- LiteRT production, L2 backend selector, OCR, camera, audio, compression v1, in-app model download UX.
- Public App Store submission, pricing, or review for GA.
- Widening ASC `internal_tester` beyond Wang + Matisse.

### Required validation before upload (build 2)

Run in order; see [next build gate](./qwen_text_only_alpha_release_readiness.md#next-build-gate-before-build-2) and [TestFlight prep](./qwen_text_only_alpha_testflight_prep.md#testflight-upload-outline-not-executed-here).

1. **Simulator:** `PREXUSTests` green on the archive commit.
2. **Archive:** Distribution export for `jp.studio-prospect.prexus.ios` with **llama** linked.
3. **Upload:** TestFlight binary `0.1.0 (2)` to ASC; tag `qwen-text-alpha-0.1.0-build2` on archived commit.
4. **Wang:** TestFlight install → `push_local_model_to_device.sh "Wang"` → **Runtime Diagnostics** with `answered_by=llama.cpp On-Device Runtime`.
5. **Matisse:** TestFlight install → GGUF push → **Local runtime** + **Embedded Heuristic Runtime** (no llama.cpp — **pass**).
6. **Evidence:** New ops folder + new ledger subsection **after** steps 4–5; filenames e.g. `wang-0.1.0-2-diagnostics.png` — **never** commit PNG/logs/GGUF/IPA/MANIFEST to git.

Optional pre-upload: `./tools/scripts/alpha_smoke_wang.sh "Wang"` (gitignored `.eval-logs/`).
