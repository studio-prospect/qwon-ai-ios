# Qwen Text-Only Alpha — Release Notes

**Release candidate:** Qwen + llama.cpp text-only alpha
**Target window:** 2026-06 mid-month (internal / TestFlight)
**Main reference:** [qwen_text_only_alpha_release.md](./qwen_text_only_alpha_release.md) · **Current status:** [status summary](./qwen_text_only_alpha_status_summary.md) · **Doc index:** [qwen_text_only_alpha_docs_index.md](./qwen_text_only_alpha_docs_index.md)

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

Alpha doc navigation: [documentation index](./qwen_text_only_alpha_docs_index.md).

| Artifact | Location |
| --- | --- |
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
Triage: no open Release blocker on build 1 (see Known issues triage for build 1).
Planned trigger: <fill when implementation PR is ready — e.g. runtime fix, UI fix, signing/asset change>
```

Until this block is filled with an approved binary change, **recommendation: maintain TestFlight build `1`.**

### Known issues triage for build 1

Inventory for **TestFlight `0.1.0 (1)`** (tag `qwen-text-alpha-0.1.0-rc1`, commit `a021475`). Used to decide whether [Binary respin reason](#binary-respin-reason-required-before-cut) should be approved. Evidence baseline: [frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) (Wang + Matisse **pass**, 2026-05-31).

**Triage outcome (2026-05-31):** **No `Release blocker` open.** **Do not approve build `2` yet** — continue internal alpha on build `1`; use **Docs/ops only** for remaining friction.

#### Release blocker

*None open.* Build `1` meets [alpha release blockers](./qwen_text_only_alpha_release.md#release-blockers) for the two-device lab:

| Check | Build `1` status |
| --- | --- |
| Launch + first text turn without crash | Pass — Wang / Matisse TestFlight + smoke lineage |
| Qwen path on Wang (A17 Pro+) after GGUF push | Pass — `answered_by=llama.cpp On-Device Runtime` (ops + verification) |
| Missing GGUF / llama failure | Pass — embedded heuristic fallback, no crash (`no_model` smoke) |
| Bundle ID / Distribution signing | Pass — `jp.studio-prospect.prexus.ios`, upload 2026-05-31 |
| Sensitivity regression (Wang) | Pass — `sensitivity_matrix` smoke on lab device |
| Diagnostics unusable for validation | Pass — Runtime Diagnostics captured; Matisse heuristic path documented |

Add a row here only if a **new** issue reproduces on **TestFlight build `1`** and blocks the checks above.

#### Build 2 candidate

Binary change **may help** but **build `1` internal distribution can continue**:

| Issue | Notes | Suggested action |
| --- | --- | --- |
| Local Qwen **hallucination / weak reasoning** | Documented [known limitation](#known-limitations); 0.5B demo model | **Post-alpha** model/prompt work — not a respin unless product changes bundled model |
| **Slow first response** after cold GGUF load | Thermal/load expectation for on-device Qwen | Note in tester comms; monitor — **not** blocking build `1` |
| **First turn before GGUF push** shows Fallback / heuristic | Expected; onboarding requires dev Mac push | **Docs/ops** — already in What to Test / onboarding |
| Chat **keyboard / composer** friction (historical) | iPhone 17 feedback during dev; layout/keyboard fixes landed **before** `a021475` (PRs #6–#9) | If **not** repro on TestFlight `0.1.0 (1)`, treat as **closed**; if repro, move to **Release blocker** and approve build `2` |
| **Strict JSON / markdown fences** in eval | Evidence-only eval concern, not Chat UX | **Post-alpha** / eval harness — not build `2` for text-only alpha |

#### Docs / ops only

**Do not** cut build `2` for these alone:

| Item | Resolution path |
| --- | --- |
| GGUF not in IPA; requires `push_local_model_to_device.sh` | Onboarding + [tester instructions](./qwen_text_only_alpha_tester_instructions.md) |
| Runtime Diagnostics entry path (**Recent Runtime Decisions**) | Docs + onboarding copy ([prep](./qwen_text_only_alpha_testflight_prep.md#tester-onboarding-message)) |
| Matisse: **Embedded Heuristic** despite GGUF (A12 gate) | Lab evidence + ASC copy — **not** failure |
| `internal_tester` **0 builds** / export compliance / invite confusion | Resolved in ASC ops 2026-05-31 ([prep](./qwen_text_only_alpha_testflight_prep.md#testflight-に-prexus-が出ないとき)) |
| Ops screenshot naming / frozen ledger / two-device lab policy | [Lab evidence](./qwen_text_only_alpha_lab_evidence.md); PRs #31–#33 |
| ASC **What to Test** / onboarding wording updates | Edit ASC in place against build `1` |
| Feedback channel undefined (Slack vs issue template) | **Docs/ops** — pick channel; not IPA |
| Optional: full **sensitivity matrix** on Matisse | **Wang-only** during lab phase ([tester instructions](./qwen_text_only_alpha_tester_instructions.md)) |

#### Post-alpha

Out of [text-only alpha scope](./qwen_text_only_alpha_release.md); **not** build `2` drivers:

| Item | Track |
| --- | --- |
| LiteRT production default / L2 backend selector | Policy + eval sign-off |
| OCR, compression v1, audio, live camera | Phase 1+ roadmap |
| In-app **model download** UX | Post-alpha |
| Public **App Store** listing | Explicitly out of scope |
| Real Qwen on **pre–A17 Pro** hardware (e.g. Matisse) | Hardware gate — not fixable by respin alone |
| Cloud provider matrix / escalation quality with live keys | Optional RC item; not alpha blocker |
| PREXUSLiteRTEval (`com.prexus.ios.literteval`) | Separate eval app |

#### Feedback intake processing (build 1)

Release engineering workflow for **one incoming report** on TestFlight **`0.1.0 (1)`**. **Build `2` is not approved** by this process alone.

| Step | Action |
| --- | --- |
| 1 | Accept only the [tester feedback report template](./qwen_text_only_alpha_tester_instructions.md#tester-feedback-report-template). Informal chat → **needs evidence**; do not log as triage input. |
| 2 | Store ops PNGs under `~/PREXUS-alpha-evidence/qwen-text-0.1.0-build1/` — cite **filenames only** in docs (never commit PNG/JPEG/log/GGUF/IPA/MANIFEST). |
| 3 | Assign **final** class (tester guess is non-binding). |
| 4 | Append or **update** one row in [tester feedback log (build 1)](#tester-feedback-log-build-1) per [log row format](#log-row-format-new-reports) (same row when **needs evidence** → complete). |
| 5 | If **Release blocker:** add a row under [Release blocker](#release-blocker) and draft [Binary respin reason](#binary-respin-reason-required-before-cut) — still **no** archive/upload/tag until explicitly approved. |
| 6 | If **Docs/ops only:** edit docs or ASC copy in place on build `1` — **no** `CFBundleVersion` bump. |

**needs evidence — re-request**

Ask the tester to complete only what is missing:

- `TestFlight version/build: 0.1.0 (1)` (or explain mismatch)
- `Device lab name: Wang | Matisse`
- Full **Runtime Diagnostics** block (execution mode, backend/model, `answered_by`, `primary_failure`, `fallback_reason` as applicable)
- Ops screenshot **filename** (e.g. `wang-0.1.0-1-diagnostics.png`), not a binary attachment in git

Keep class **needs evidence** until template-complete. Does **not** approve build `2`.

**Docs/ops only — handling**

- Update [tester instructions](./qwen_text_only_alpha_tester_instructions.md), [TestFlight prep](./qwen_text_only_alpha_testflight_prep.md) onboarding/What to Test, or ASC text — **against build `1`**
- **Do not** edit [build 1 frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) rows
- **Do not** cut build `2` for copy-only fixes

**Build 2 candidate vs Release blocker**

| Class | Meaning | Approves build `2`? |
| --- | --- | --- |
| **Build 2 candidate** | Real bug or UX issue on build `1`; Wang + Matisse can keep testing on build `1` | **No** — log only unless promoted |
| **Release blocker** | Template-complete repro on **`0.1.0 (1)`** that blocks launch, first text turn, Wang llama path after GGUF, no-model fallback safety, signing, or Diagnostics validation baseline | **Not by default** — requires new [Release blocker](#release-blocker) row + approved [Binary respin reason](#binary-respin-reason-required-before-cut) + minimal fix PR |

Promote **Build 2 candidate** → **Release blocker** only with template-complete repro on **`0.1.0 (1)`**. **Matisse without `answered_by=llama.cpp` is expected** — not a blocker, not build `2` justification.

**Build `2` remains not approved when**

- Class is **needs evidence**, **Docs/ops only**, **Post-alpha**, or **Build 2 candidate** alone
- Issue is Matisse “missing Qwen/llama” on A12 (Embedded Heuristic path)
- Only docs/ASC/onboarding changed; IPA unchanged
- [Binary respin reason](#binary-respin-reason-required-before-cut) is empty
- No open [Release blocker](#release-blocker) row for the issue on build `1`

#### Tester feedback log (build 1)

**Template policy:** New rows come from the [tester feedback report template](./qwen_text_only_alpha_tester_instructions.md#tester-feedback-report-template) only. Informal chat without Diagnostics summary + ops screenshot **filename** stays **needs evidence** until completed — it does **not** approve build `2`. Release engineering assigns the final class in the triage tables above.

**Scope:** Per-report **intake history** on build `1`. **Not** a substitute for the [build 1 frozen ledger](./qwen_text_only_alpha_lab_evidence.md#frozen-ledger-010-build-1) (two-device lab sign-off). **Build `2` remains not approved** until a **Release blocker** exists on **`0.1.0 (1)`** with template-complete evidence per [intake processing](#feedback-intake-processing-build-1).

##### Baseline log (closed — build 1 sign-off)

Do **not** edit these rows. They record 2026-05-31 lab sign-off, not open tester issues.

| Source | Summary | Classification |
| --- | --- | --- |
| Wang TestFlight verification (2026-05-31) | Install OK; llama path after GGUF; local reply | **Closed — pass** |
| Matisse TestFlight (2026-05-31, iOS 18.7.9) | Embedded Heuristic + Diagnostics pass; no crash | **Closed — pass** (not llama.cpp) |
| Wang device smoke (2026-05-31) | `with_model`, `no_model`, `sensitivity_matrix` pass | **Closed — pass** |
| Historical Wang UI (pre-upload dev) | Letterboxing / keyboard — addressed in PRs #6–#9 before `a021475` | **Closed in build `1` lineage** unless reopened on TF `0.1.0 (1)` |

##### Log row format (new reports)

Append **below** the baseline table when the first real template-based report arrives. Use this header (seven columns):

| Date | Device | Scenario | Summary | Final class | Evidence filename | Next action |
| --- | --- | --- | --- | --- | --- | --- |

| Column | Required | Content |
| --- | --- | --- |
| **Date** | Yes | Report **received** date, ISO `YYYY-MM-DD` |
| **Device** | Yes | `Wang` or `Matisse` only |
| **Scenario** | Yes | From template (`launch`, `first chat`, `GGUF push`, `Runtime Diagnostics`, `sensitivity`, `other`, …) |
| **Summary** | Yes | One line: actual vs expected (or pass note) |
| **Final class** | Yes | `needs evidence` · `Docs/ops only` · `Build 2 candidate` · `Release blocker` · `Post-alpha` |
| **Evidence filename** | Yes when class is not incomplete | Ops PNG name only (e.g. `wang-0.1.0-1-diagnostics.png`); use `—` while **needs evidence** and filename not yet provided |
| **Next action** | Yes | e.g. `Re-request Diagnostics + filename`, `ASC copy PR`, `Monitor on build 1`, `Promote → Release blocker; triage row` |

**Do not** add placeholder or sample rows before a real report exists.

##### needs evidence — same row, then update

| Situation | Log action | Build `2` input? |
| --- | --- | --- |
| First incomplete template | Append **one** row: Final class **needs evidence**; Evidence filename `—`; Next action lists missing fields | **No** |
| Same report becomes template-complete | **Update that same row** (do not append a duplicate). Set Final class, Summary, Evidence filename, Next action | **No**, unless Final class becomes **Release blocker** |
| Template-complete with repro on **`0.1.0 (1)`** | Row may use **Build 2 candidate**, **Docs/ops only**, **Post-alpha**, or **Release blocker** per [intake processing](#feedback-intake-processing-build-1) | **Release blocker** only (after promotion + triage + Binary respin reason) |

##### Release blocker promotion — dual record

When a report is promoted to **Release blocker** (from **Build 2 candidate** or after template-complete review):

1. **Feedback log:** **Update** the original row — Final class → **Release blocker**; Next action → e.g. `Add triage row; draft Binary respin reason`.
2. **Known issues triage:** **Append** one new row under [Release blocker](#release-blocker) (promoted issue). Keep the feedback log row; do not delete it.
3. **Binary respin reason:** Fill [Binary respin reason](#binary-respin-reason-required-before-cut) in a separate edit — **build `2` still not approved** until reason is explicitly approved.

Do **not** promote for Matisse “missing llama.cpp” alone (Embedded Heuristic is **expected** on A12).

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
