# QWON — M3 Model Distribution Compliance Memo (Gate 3)

**Last updated:** 2026-06-05 (Batch A review — Gate 3 still Pending)
**Status:** **Investigation memo only** — **not** M3 implementation approval, **not** Gate 3 **Ready**, **not** Build `4` approval.
**Purpose:** Document open **license / redistribution / export compliance** questions for a future **M3 in-app download** spike of `prexus-local-mvp.gguf`.

Related: [M3 readiness checklist — Gate 3](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) · [Batch A review](./qwon_m3_gate_readiness_review_plan.md#batch-a-review-session-2026-06-05) · [GGUF UX plan](./qwon_model_download_gguf_ux_plan.md) · [models/README.md](../../models/README.md) · [TestFlight prep — export compliance](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate)

---

## Baseline artifact (unchanged)

| Field | Value |
| --- | --- |
| **On-device filename** | `prexus-local-mvp.gguf` — preserved |
| **Suggested quant** | **Qwen2.5-0.5B-Instruct Q4_K_M** (~379–400 MB on Wang lab device) |
| **Placement contract** | `Documents/Models/prexus-local-mvp.gguf` (see [models/README.md](../../models/README.md)) |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — GGUF **not bundled** in shipped binary |
| **Build `4`** | **Not approved** |

---

## What QWON does today (M1/M2 — outside Gate 3 Ready)

| Activity | Who | Compliance character |
| --- | --- | --- |
| Developer runs `fetch_local_model.sh` on Mac | Release engineering / developers with repo access | **Out-of-app** download from a third-party Hugging Face URL into `models/` (gitignored) |
| USB push via `push_local_model_to_device.sh` | Same | **Manual sideload** into app sandbox — not App Store binary redistribution of weights |
| TestFlight testers use app **without** bundled GGUF | Internal testers | App binary does **not** currently ship model weights; M2 guides external Mac + USB ops |

**Inference (not legal advice):** today's alpha path treats the GGUF as **operator-managed side data**, not as **QWON-redistributed content inside the App Store artifact**. M3 would change that characterization if the app fetches and installs the file for users.

---

## What M3 would change (why Gate 3 matters)

| Today (M2) | M3 in-app download (hypothetical) |
| --- | --- |
| User obtains GGUF via Mac ops | App initiates **HTTPS fetch** and writes into sandbox |
| No QWON-owned hosting requirement | Requires **approved hosting source / URL ownership** (Gate 1 — still **Pending**) |
| No in-app redistribution claim | QWON becomes a **distribution channel** for third-party model weights |
| Manual integrity checks | Requires published **SHA-256 / size policy** (Gate 2 — still **Pending**) |

This memo addresses **Gate 3 only**. It does **not** mark Gates 1, 2, or 4+ **Ready**.

---

## Primary source links (Product / legal traceability)

Use these Hugging Face pages to review upstream license text and artifact provenance. Links are for **reference tracking only** — **not** approved product hosting URLs and **not** Gate 3 sign-off.

### Qwen2.5-0.5B-Instruct (base model)

| Resource | URL |
| --- | --- |
| **Model card** | [Qwen/Qwen2.5-0.5B-Instruct](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct) |
| **LICENSE file** | [Qwen/Qwen2.5-0.5B-Instruct — LICENSE](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct/blob/main/LICENSE) |
| **License tag (HF metadata)** | `apache-2.0` (on model card; **Product/legal must confirm** applicability) |

### bartowski GGUF quant (current ops default for `prexus-local-mvp.gguf`)

| Resource | URL |
| --- | --- |
| **Model card / README** | [bartowski/Qwen2.5-0.5B-Instruct-GGUF](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF) |
| **README metadata** (includes `license_link`, `base_model`, `quantized_by`) | [README.md](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF/blob/main/README.md) |
| **License link (README metadata)** | Points to [Qwen base LICENSE](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct/blob/main/LICENSE) — **no separate LICENSE file** in bartowski repo at time of memo |
| **Q4_K_M GGUF artifact (blob view)** | [Qwen2.5-0.5B-Instruct-Q4_K_M.gguf](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF/blob/main/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf) |
| **Dev ops fetch default (`fetch_local_model.sh`)** | [resolve/main/...Q4_K_M.gguf](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf) — **developer convenience only**, not approved M3 product URL |

---

## License stack (research summary — needs Product/legal confirmation)

| Layer | Source (current ops default) | Primary links | Notes for legal review |
| --- | --- | --- | --- |
| **Base model** | Qwen2.5-0.5B-Instruct (Alibaba / Qwen team) | [Model card](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct) · [LICENSE](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct/blob/main/LICENSE) | Public model cards commonly cite **Apache-2.0**; **Product/legal must confirm** license text, attribution requirements, and whether mobile on-device use + re-download UX is permitted without additional notices. |
| **GGUF quant artifact** | Community quant under `bartowski/Qwen2.5-0.5B-Instruct-GGUF` | [Model card](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF) · [Q4_K_M artifact](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF/blob/main/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf) | **Third-party repack**, not an official QWON-hosted build. README metadata cites base-model license link; rights to **redistribute this specific file** to end users via QWON servers or embedded URLs are **unconfirmed**. |
| **Fetch script default URL** | `fetch_local_model.sh` | [resolve URL](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf) | Documented as **developer convenience**, **not** an approved product hosting URL or stable checksum source. |
| **Runtime** | llama.cpp (local inference) | — | Separate from model **weight** redistribution; still relevant to encryption/export questionnaires only indirectly. |

**Do not treat this table as sign-off.** It records what engineering uses today so legal can review M3 implications.

---

## App Store / TestFlight / export compliance

| Topic | Current QWON alpha state | M3 open question |
| --- | --- | --- |
| **TestFlight export compliance (encryption)** | Documented operator gate for **HTTPS/TLS** in app binary — see [export compliance](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) | Adding **large model download** may require **updated ASC disclosures**, privacy labels, or export answers — **unreviewed** for M3. |
| **Bundled vs downloaded weights** | Build `3` ships **without** GGUF in IPA | In-app download stores weights in **Documents** — clarify App Store Review narrative: optional ML asset, not embedded in binary. |
| **Public App Store** | **Out of scope** for text-alpha | Public release would add support, nutrition labels, and regional policy review — **separate** from M3 spike gate. |
| **France / regional declarations** | Build `2` history noted export compliance re-submission | Any new network-heavy feature should re-check whether operator export answers still apply — **needs Product/ops confirmation**. |

---

## Redistribution and hosting ownership (open)

| Question | Status |
| --- | --- |
| May QWON **point the app** at a third-party Hugging Face URL for production testers? | **Unconfirmed** — unstable URL, no ownership, ToS not reviewed in this memo |
| Must QWON **self-host** or contract CDN hosting for `prexus-local-mvp.gguf`? | **Unconfirmed** — Gate 1 dependency |
| Is **re-packaging** under filename `prexus-local-mvp.gguf` allowed while upstream is bartowski quant? | **Unconfirmed** — attribution / NOTICE requirements unknown |
| Can testers **share** downloaded sandbox files off-device? | **Out of scope** for M3 design; sandbox file is user/container data — policy **unconfirmed** |
| Fallback if hosting URL breaks | M2 **Mac + USB guided placement** must remain — see [M3 checklist Gate 8](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) |

---

## Wang / Matisse expectation (compliance copy angle)

| Tier | Distribution expectation | Compliance-sensitive copy |
| --- | --- | --- |
| **Wang (A17 Pro+)** | Optional GGUF enables llama.cpp local runtime | Download UX must **not** imply Apple or QWON **warrant model quality**; optional advanced feature framing |
| **Matisse (A12)** | Embedded Heuristic expected; GGUF **not required** | Download prompts must **not** pressure Matisse installs or imply device failure — aligns with [M3 checklist Gate 7](./qwon_model_download_gguf_ux_plan.md#m3-readiness-gate-checklist) |

---

## Recommended Product / legal actions (before Gate 3 → Ready)

1. **Confirm base model license** for Qwen2.5-0.5B-Instruct on-device use and **re-distribution via app-initiated download**.
2. **Confirm third-party GGUF quant** (bartowski) is acceptable for end-user delivery or define an **official QWON-built/hosted artifact** with clear provenance.
3. **Decide hosting model** (self-host vs licensed CDN vs not proceeding with M3) — links to Gate 1.
4. **Review App Store / TestFlight** privacy label and export compliance impact if network download ships — even on internal TestFlight.
5. **Document attribution / NOTICE** requirements in app or Settings if required by upstream licenses.
6. **Record written sign-off** (Product + legal contact) in a future memo revision — this document alone is **not** sign-off.

---

## Gate 3 checklist disposition

| Field | Value |
| --- | --- |
| **Checklist row** | Gate 3 — License / redistribution / export compliance |
| **Recommended status** | **Pending** — **needs product/legal confirmation** |
| **Ready?** | **No** — open questions above remain |
| **M3 implementation** | **Not approved** |
| **Build `4` / TestFlight upload** | **Not approved** |

---

## Batch A review status (2026-06-05)

**Review:** [Batch A session](./qwon_m3_gate_readiness_review_plan.md#batch-a-review-session-2026-06-05) — Product/legal confirmation **incomplete**; Gate **3** remains **Pending — needs product/legal confirmation**.

### Gate 3 — unresolved (summary)

| Topic | Status |
| --- | --- |
| Qwen base license (on-device + re-download) | **Unconfirmed** |
| bartowski GGUF redistribution to end users | **Unconfirmed** |
| Attribution / NOTICE for in-app path | **Unknown** |
| Export compliance (model weights vs app TLS) | **Unreviewed** |
| App Store / privacy label for large download | **Unreviewed** |

Full item list: [G3-1 … G3-9](./qwon_m3_gate_readiness_review_plan.md#gate-3--open-items-compliance--productlegal-confirmation-incomplete) · **Questions for legal:** [Product / legal question list](./qwon_m3_gate_readiness_review_plan.md#product--legal-question-list-batch-a--answer-to-unblock-ready-sign-off)

---

## Evidence boundaries (this PR)

| Included | Excluded |
| --- | --- |
| Questions and current-alpha facts | Final SHA-256 publication |
| Link from M3 checklist | Approved hosting URL |
| Hugging Face model card / LICENSE / artifact links for Product/legal traceability | Gate 3 **Ready** sign-off |
| Ops script references as **dev default** | GGUF binary or PNG commit |
| | Gate 1/2/4+ marked **Ready** |
