# QWON — App Store G5 モデル配布ポリシー回答フォーム（日本語）

**最終更新:** 2026-06-08（Stay selected — G5 worksheet 追加；intake **Unanswered**）
**状態:** **Worksheet only** — [intake ledger](./qwon_app_store_public_readiness_intake.md) の **Q-AS-11 … Q-AS-12** は **Unanswered** のまま。**final model distribution policy 承認ではない**。**in-app download / M3 reopen 承認ではない**。**App Store 公開承認ではない**。**Build `4` 承認ではない**。**TestFlight upload / tag / version bump / ASC submission 承認ではない**。
**目的:** **Legal / Product** が **G5 — Model distribution policy** に回答し、別 docs-only PR で intake に記録する前の合意形成用日本語フォーム。

English worksheet: [G5 Model Distribution Policy Worksheet](./qwon_app_store_g5_model_distribution_worksheet.md)

関連: [Intake ledger — G5](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) · [Checklist — G5](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [M3 hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) · [M2 guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement) · [M3 spike outcome — Option A](./qwon_m3_spike_outcome_decision.md#decision-record) · [G3 privacy worksheet](./qwon_app_store_g3_privacy_worksheet.md) · [G4 gate sign-off](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## 明示的な境界

| 境界 | 意味 |
| --- | --- |
| **G5 worksheet ≠ model distribution policy final 承認** | 本フォームは public model distribution policy または App Store go-live posture の **確定承認** ではない |
| **G5 worksheet ≠ in-app download / M3 reopen** | M3 in-app download 有効化、M3 lane 再開、Build `4` 承認にはならない |
| **G5 worksheet ≠ bundled weights 承認** | App Store binary 内 GGUF 同梱の **別 Product / Legal gate なし承認** ではない |
| **G5 worksheet ≠ 公開承認** | App Store 公開 go-live を承認しない |
| **G5 worksheet ≠ ASC submission** | App Store Connect upload / hosting ops / submission なし |
| **Stay selected** | Stay 解除・実装承認にはならない |
| **コード変更なし** | app コード、download UX、hosting pipeline、model bundling の変更なし |
| **推奨案は draft** | **draft / not approved** — Legal / Product が差し替え・却下するまで intake **Answered** にしない |
| **記録** | Legal / Product **明示承認** 後に **別 docs-only PR** で intake を **Answered** に更新 |

---

## 現状エビデンス

| 項目 | 値 |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **Checklist gate G2** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)) |
| **Checklist gate G3** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) ([#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)) |
| **Checklist gate G4** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |
| **Intake ledger total** | **24 questions · 14 Unanswered · 10 Answered** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** · shipped binary に **GGUF 同梱なし** |
| **M3 posture** | **Option A selected** — compile-gated **default-off**；M3 lane **closed** · [decision record](./qwon_m3_spike_outcome_decision.md#decision-record) |
| **Tester-visible model path** | M2 **Place GGUF via Mac** + USB — [guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement)；build `3` 上 in-app GGUF download なし |
| **G5 intake** | **Q-AS-11 … Q-AS-12** — **Unanswered** |
| **Checklist gate G5** | **Open** |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |

### G1–G4 + M3 入力（G5 参照用）

| 出典 | 要約 |
| --- | --- |
| **G1 Q-AS-01** | local-first cognitive runtime — 原則オンデバイス推論 |
| **G3 Q-AS-07** | build `3`: オンデバイス LLM 推論；TestFlight 上 in-app model HTTPS download なし |
| **G3 Q-AS-08** | 将来 in-app download build は privacy label 更新必要 — [Q-AS-11](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) に依存 |
| **G4 Q-AS-09 … Q-AS-10** | public submit 前 export compliance 再レビュー；候補 binary で RE/Legal re-verification |
| **M3 compliance memo** | M3 in-app download は QWON を third-party weights の **distribution channel** に — license / redistribution レビュー必要 |
| **M3 hosting memo** | ops 既定: bartowski Qwen2.5 Q4_K_M GGUF；QWON-hosted mirror は M3 spike 議論 — **public hosting URL 未承認** |
| **M3 Option A** | spike 完了；M2 **Place GGUF via Mac** が official acquisition path — M3 **default-on ではない** |

---

<a id="q-as-11--public-model-distribution-policy"></a>

## Q-AS-11 — Public model distribution policy

| 項目 | 値 |
| --- | --- |
| **Gate** | G5 |
| **Owner** | Legal, Product |
| **Intake 状態** | **Unanswered** |

### 質問

approved **public model distribution policy** は何か — Mac+USB **Place GGUF via Mac** only、in-app download、bundled weights、phased combination のいずれか？

### Legal / Product 記入欄

| 項目 | 記入 |
| --- | --- |
| **承認回答** | |
| **First public release posture** | |
| **Mac+USB Place GGUF via Mac** | |
| **In-app download（M3 or successor）** | |
| **Bundled weights in App Store binary** | |
| **Phased combination（if any）** | |
| **build `3` baseline 整合** | |
| **判断 owner** | Legal / Product |
| **出典** | |
| **制約** | final policy 承認ではない |

### 推奨回答案（draft / not approved）

> **Public model distribution policy（計画 draft）:**
>
> **判断オプション（未承認）:**
>
> | Option | 説明 | build `3` / TestFlight 今日 | public-release 計画メモ（draft） |
> | --- | --- | --- | --- |
> | **A. Mac+USB Place GGUF via Mac only** | Mac ops + USB で `prexus-local-mvp.gguf` 取得；Settings に M2 guided placement | **Yes** — **`0.1.0 (3)`** で tester-visible | 現 alpha と整合；App Review: optional on-device ML asset、user-managed side data、**IPA 非同梱** |
> | **B. In-app download** | HTTPS fetch → sandbox（`Documents/Models/…`） | build `3` **No**；M3 **Option A / default-off / lane closed** | M3 再開は別 Product gate；[G3 Q-AS-08](./qwon_app_store_public_readiness_intake.md#g3--privacy-nutrition-labels)、[G4 export compliance](./qwon_app_store_public_readiness_intake.md#g4--export-compliance--encryption-declaration)、hosting + checksum 連動 |
> | **C. Bundled weights** | App Store binary 内 GGUF 同梱 | **No** — build `3` は GGUF なし | IPA サイズ、更新 cadence、binary 内 license redistribution — **別 Legal / RE レビュー** |
> | **D. Phased combination** | 例: Phase 1 external placement only → 後から in-app download / bundled | 今日は A のみ | phase 境界、fallback（**Place GGUF via Mac** 維持）、release-time re-check gate を Product が定義 |
>
> **計画 draft 回答（仮説 — 未承認）:** **Phase 1 public-readiness planning は Option A（Mac+USB Place GGUF via Mac only）** を TestFlight **`0.1.0 (3)`** と整合 — **in-app download / bundled weights は defer** まで explicit Product / Legal gate。Product / Legal が確認・差し替え。
>
> **M3 reopen ではない**。**Build `4` ではない**。**公開承認ではない**。

Legal / Product が編集・差し替え・却下すること。**final model distribution policy ではない**。

---

<a id="q-as-12--license-and-redistribution-constraints"></a>

## Q-AS-12 — License and redistribution constraints

| 項目 | 値 |
| --- | --- |
| **Gate** | G5 |
| **Owner** | Legal |
| **Intake 状態** | **Unanswered** |

### 質問

**license / redistribution constraints**（bartowski GGUF、QWON-hosted mirror 等）を App Review / user-facing copy 向けに何を文書化すべきか？

### Legal 記入欄

| 項目 | 記入 |
| --- | --- |
| **承認回答** | |
| **Qwen base model license posture** | |
| **bartowski GGUF redistribution** | |
| **QWON-hosted mirror（if any）** | |
| **Attribution / notices required** | |
| **App Review narrative** | |
| **User-facing copy constraints** | |
| **判断 owner** | Legal |
| **出典** | |
| **制約** | final Legal 結論ではない |

### 推奨回答案（draft / not approved）

> **License / redistribution constraints（計画 draft）:**
>
> **Artifact stack（調査サマリ — Legal 確認必要）:**
>
> | Layer | Source | リンク | draft 制約メモ |
> | --- | --- | --- | --- |
> | **Qwen base model** | Qwen2.5-0.5B-Instruct | [Model card](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct) · [LICENSE](https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct/blob/main/LICENSE) | HF metadata **Apache-2.0** — attribution、mobile on-device use、notice 要件を Legal が確認 |
> | **bartowski GGUF quant** | Community repack | [bartowski model card](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF) | **Third-party repack** — end user への **redistribution 権**（app / QWON servers / embedded URL）**未確認** |
> | **Dev ops fetch URL** | `fetch_local_model.sh` 既定 | [HF resolve URL](https://huggingface.co/bartowski/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/Qwen2.5-0.5B-Instruct-Q4_K_M.gguf) | **developer convenience only** — product hosting URL **未承認** |
> | **QWON-hosted mirror** | M3 spike 計画で議論 | [M3 hosting memo — Gate 1](./qwon_m3_model_hosting_checksum_memo.md#gate-1--model-hosting-source--url-ownership) | public release 向け **未承認** — 採用する場合は Gate 1/2/3 sign-off stack 必要 |
>
> **Distribution path 含意（draft）:**
> - **Mac+USB only（Option A）:** GGUF は **user-managed side data** — app binary は weights を redistribute しない；compatible GGUF 取得 guidance と upstream license awareness の user-facing 開示は検討。
> - **In-app download / QWON-hosted mirror:** QWON が **distribution channel** — redistribution、hosting ToS、checksum 公開、App Review narrative（**optional ML asset**、binary 非同梱）を Legal が approve。
> - **Bundled weights:** 最強の redistribution イベント — IPA 同梱の別 license レビュー。
>
> **App Review / user-facing copy（draft checklist — 未承認）:**
> - bundled でない場合、local LLM に user-provided / separately acquired model file が必要である旨を開示。
> - Legal レビューなしに official Qwen / bartowski endorsement を claim しない。
> - redistribution 承認時は attribution / third-party notices セクションを計画。
> - [Q-AS-11](#q-as-11--public-model-distribution-policy) 決定後 [G8 Q-AS-19](./qwon_app_store_public_readiness_intake.md#g8--known-limitations--app-review-notes) と整合。
>
> **final Legal 結論ではない**。**approved hosting URL ではない**。**M3 実装ではない**。

Legal が編集・差し替え・却下すること。**final license sign-off ではない**。

---

## G5 完了チェックリスト（gate sign-off ではない）

| 項目 | 状態 |
| --- | --- |
| Q-AS-11 worksheet draft 準備 | **Done** — [推奨案 § Q-AS-11](#q-as-11--public-model-distribution-policy) |
| Q-AS-12 worksheet draft 準備 | **Done** — [推奨案 § Q-AS-12](#q-as-12--license-and-redistribution-constraints) |
| Legal / Product **明示承認** | **Pending** |
| follow-up docs-only PR で intake **Answered** | **Pending** |
| checklist G5 Closed/Ready | **No** |
| In-app download / M3 reopen | **No** |
| Public release approved | **No** |
| Build `4` / TestFlight upload / ASC submission | **No** |

---

## Agent note

**Legal / Product** 向け review / answer preparation 用。**推奨案を intake Answered にコピーしたり M3 を reopen したり in-app download を承認したりしない** — 明示承認 + follow-up docs-only PR まで **Unanswered** を維持すること。
