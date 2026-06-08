# QWON — App Store G4 輸出コンプライアンス回答フォーム（日本語）

**最終更新:** 2026-06-08（G4 Legal/RE decision draft 準備済 — intake **Unanswered**）
**状態:** **Legal/RE decision draft / awaiting explicit approval 付き worksheet** — [intake ledger](./qwon_app_store_public_readiness_intake.md) の **Q-AS-09 … Q-AS-10** は **Unanswered** のまま。**export compliance final submission ではない**。**App Store 公開承認ではない**。**Build `4` 承認ではない**。**TestFlight upload / tag / version bump / ASC submission 承認ではない**。
**目的:** **Legal / Release Engineering** が **G4 — Export compliance / encryption declaration** に回答し、別 docs-only PR で intake に記録する前の合意形成用日本語フォーム。

English worksheet: [G4 Export Compliance Worksheet](./qwon_app_store_g4_export_compliance_worksheet.md)

関連: [Intake ledger — G4](./qwon_app_store_public_readiness_intake.md#g4--export-compliance--encryption-declaration) · [Checklist — G4](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [TestFlight prep — export compliance gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [G3 gate sign-off](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## 明示的な境界

| 境界 | 意味 |
| --- | --- |
| **G4 worksheet ≠ export compliance final submission** | 本フォームは ASC 輸出コンプライアンス / 暗号化回答の **確定提出** ではない |
| **G4 worksheet ≠ 公開承認** | App Store 公開 go-live を承認しない |
| **G4 worksheet ≠ Build `4` 承認** | TestFlight upload / tag / version bump なし |
| **G4 worksheet ≠ ASC submission** | App Store Connect upload / compliance 提出 ops なし |
| **Stay selected** | Stay 解除・実装承認にはならない |
| **コード変更なし** | app コード・暗号化挙動・compliance plist の変更なし |
| **推奨案は draft** | **draft / not approved** — Legal / RE が差し替え・却下するまで intake **Answered** にしない |
| **記録** | Legal / RE **明示承認** 後に **別 docs-only PR** で intake を **Answered** に更新 |

---

<a id="legal-re-decision-draft--awaiting-explicit-approval"></a>

## Legal / Release Engineering decision draft — **awaiting explicit approval（明示承認待ち）**

**ラベル:** **Legal/RE decision draft / awaiting explicit Legal/RE approval** — 推奨案・TestFlight export compliance 履歴・build `3` エビデンスをベースに整理。**intake Answered ではない**。**G4 Closed/Ready ではない**。**export compliance final submission / 公開承認ではない**。

| 項目 | 値 |
| --- | --- |
| **準備日** | 2026-06-08 — Stay 下 docs-only hygiene（[#142](https://github.com/studio-prospect/qwon-ai-ios/pull/142)） |
| **Intake ledger** | **Q-AS-09 … Q-AS-10** は Legal / RE 明示承認 + follow-up PR まで **Unanswered** |
| **次の段階** | Legal / RE が各 draft を確認・編集・却下 → docs-only PR で [intake ledger](./qwon_app_store_public_readiness_intake.md) を **Answered** に更新 |

### Q-AS-09 — TestFlight build `2` attestation との export compliance 差分

| 項目 | Legal/RE decision draft |
| --- | --- |
| **Question ID** | Q-AS-09 |
| **承認回答（draft）** | **Yes — public App Store submit 前に updated export compliance / encryption declaration レビューが必要** — TestFlight build **`2`** attestation だけに依存不可。public release は **public submission binary** を出荷 — 暗号化 use が TestFlight **`0.1.0 (3)`** と同一でも **新規 compliance イベント** として扱う。Legal が standard exemption（exempt encryption / HTTPS-only 等）と build `2` 回答の **再利用 vs 再 attestation** を確認。 |
| **暗号化 posture 変更（draft）** | **計画前提:** TestFlight **`0.1.0 (3)`** クラス binary で material change なし — **RE/Legal が public-release candidate で検証**；build **`3`** export compliance **docs 未再検証** は submit 前に解消。 |
| **build `3` doc gap（draft）** | doc gap を解消 — 候補 binary の encryption use を RE/Legal が検証；installability から compliance を推論しない。 |
| **public-release binary vs TestFlight（draft）** | submit binary は TestFlight **`0.1.0 (3)`** と異なる場合あり — compliance 回答は **submit binary** を参照。 |
| **判断 owner** | Legal（draft — **明示承認待ち**） |
| **出典** | 推奨案 § Q-AS-09 · [TestFlight prep export compliance gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) |
| **制約** | **compliance 提出ではない**；follow-up PR まで intake **Answered** にしない |

### Q-AS-10 — ASC export compliance sign-off owner と re-verification

| 項目 | Legal/RE decision draft |
| --- | --- |
| **Question ID** | Q-AS-10 |
| **承認回答（draft）** | **Release Engineering** が **public submission build** の ASC export compliance questionnaire を完了；**Legal** が App Store submit 前に回答を review/approve。TestFlight build **`2`** attestation と一致しても re-verification 必須。 |
| **Sign-off owner（draft）** | **Release Engineering**（primary）· **Legal**（ASC 回答 review/approve） |
| **Re-verification steps（draft）** | (1) public-release candidate binary 特定 · (2) encryption use 検証（app、llama.cpp、HTTPS/TLS、non-exempt crypto）· (3) TestFlight build **`2`** attestation と比較 · (4) **public submission build** 向け ASC export compliance 完了 — TestFlight 自動引き継ぎ想定しない · (5) attestation audit trail 記録 · (6) submit 前 Legal sign-off |
| **Pre-submit checklist（draft）** | [TestFlight prep operator checklist](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) を **App Store public submit** 向けに適応 — internal TestFlight upload ops とは別 |
| **Documentation location（draft）** | 承認後 intake + 本 worksheet；ASC attestation evidence は ops record（git 外） |
| **判断 owner** | Release Engineering（draft — **明示承認待ち**） |
| **出典** | 推奨案 § Q-AS-10 |
| **制約** | **ASC compliance 提出ではない**；**G4 Closed/Ready ではない** |

---

## 現状エビデンス

| 項目 | 値 |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **Checklist gate G2** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)) |
| **Checklist gate G3** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) ([#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)) |
| **Intake ledger total** | **24 questions · 16 Unanswered · 8 Answered** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** |
| **G4 intake** | **Q-AS-09 … Q-AS-10** — **Unanswered** |
| **Checklist gate G4** | **Partial** |
| **TestFlight export compliance 実績** | [TestFlight prep — export compliance operator gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) — build `1` upload 時完了；build `2` **re-submission 必要** → 2026-06-02 提出；build `3` **docs 上未再検証** |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |

### G1 + G2 + G3 入力（G4 参照用）

| 出典 | 要約 |
| --- | --- |
| **G1 Q-AS-01** | local-first cognitive runtime — 原則オンデバイス推論 |
| **G3 Q-AS-07** | build `3` posture: オンデバイス LLM 推論；TestFlight 上 in-app model HTTPS download なし |
| **TestFlight prep** | export compliance は **upload 毎の operator gate** — upload 成功 ≠ installable |
| **M3 compliance memo** | 将来 in-app download は **export / ASC 開示の更新** が必要な可能性 — TestFlight build `2` baseline とは別 |

---

## Q-AS-09 — TestFlight build `2` attestation との export compliance 差分

| 項目 | 値 |
| --- | --- |
| **Gate** | G4 |
| **Owner** | Legal |
| **Intake 状態** | **Unanswered** |

### 質問

**public release** には、TestFlight build `2` attestation（[TestFlight prep](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) 記載）と比べ **updated export compliance / encryption declaration** が必要か？

### Legal 記入欄

**[Legal/RE decision draft](#legal-re-decision-draft--awaiting-explicit-approval)** を参照 — **draft / awaiting explicit Legal/RE approval**；intake は **Unanswered** のまま。

| 項目 | 記入 |
| --- | --- |
| **承認回答** | **Yes** — public submit 前に updated export compliance / encryption declaration レビュー必要；TestFlight build **`2`** attestation のみに依存不可。（*draft — 明示承認待ち*） |
| **暗号化 posture 変更** | TestFlight **`0.1.0 (3)`** 対比 material change なし想定 — **RE/Legal 検証**。（*draft*） |
| **build `3` doc gap 影響** | doc gap 解消 — 候補 binary 検証；installability から推論しない。（*draft*） |
| **public-release binary vs TestFlight** | submit binary は異なる場合あり — submit binary を参照。（*draft*） |
| **判断 owner** | Legal（draft） |
| **出典** | [Legal/RE decision draft § Q-AS-09](#legal-re-decision-draft--awaiting-explicit-approval) |
| **制約** | compliance **提出** ではない |

### 推奨回答案（draft / not approved）

> **public release vs TestFlight build `2` attestation（計画 draft）:**
> - TestFlight build **`2`** export compliance は 2026-06-02 **re-submission 後完了**（[operator gate](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate)）；build **`3`** compliance は **docs 上未再検証**（Wang installable だが public-readiness 用に **未文書化**）。
> - **Public App Store release** は **public submission binary** を出荷 — 暗号化 use が TestFlight **`0.1.0 (3)`** と同一でも **新規 compliance イベント** として扱う。
> - **計画 draft 回答:** **Yes — public submit 前に updated export compliance / encryption declaration レビューが必要** — Legal が standard exemption（exempt encryption / HTTPS-only 等）の適用可否と build `2` TestFlight 回答の **再利用 vs 再 attestation** を確認。
> - **build `3` gap:** 候補 binary の encryption use を RE/Legal が検証し、過去 TestFlight attestation への依存を文書化する。
> - **final Legal 結論ではない**；**ASC submission ではない**。

Legal が編集・差し替え・却下すること。**export compliance final submission ではない。**

---

## Q-AS-10 — ASC export compliance sign-off owner と re-verification

| 項目 | 値 |
| --- | --- |
| **Gate** | G4 |
| **Owner** | Release Engineering |
| **Intake 状態** | **Unanswered** |

### 質問

public App Store submission の **ASC export compliance sign-off** owner は誰か？submit 前 **re-verification steps** は何か？

### RE / Legal 記入欄

**[Legal/RE decision draft](#legal-re-decision-draft--awaiting-explicit-approval)** を参照 — **draft / awaiting explicit Legal/RE approval**；intake は **Unanswered** のまま。

| 項目 | 記入 |
| --- | --- |
| **Sign-off owner** | **Release Engineering**（primary）；**Legal** が ASC 回答 review/approve。（*draft — 明示承認待ち*） |
| **Legal レビュー役割** | submit 前 Legal が final ASC export compliance 回答を approve。（*draft*） |
| **Re-verification steps** | 候補 binary 特定 → encryption use 検証 → build **`2`** attestation 比較 → public submit 向け ASC 完了 → audit trail → Legal sign-off。（*draft*） |
| **Pre-submit checklist** | TestFlight operator checklist を App Store public submit 向けに適応。（*draft*） |
| **Documentation location** | 承認後 intake + worksheet；ASC evidence は ops record。（*draft*） |
| **判断 owner** | Release Engineering（draft） |
| **出典** | [Legal/RE decision draft § Q-AS-10](#legal-re-decision-draft--awaiting-explicit-approval) |
| **制約** | ASC compliance **提出** ではない |

### 推奨回答案（draft / not approved）

> **ASC export compliance sign-off（計画 draft）:**
> - **Primary owner（draft）:** **Release Engineering** が **public submission build** の ASC export compliance questionnaire を完了；**Legal** が App Store submit 前に回答を review/approve。
> - **Re-verification steps（draft）:**
>   1. **public-release candidate binary** を特定（TestFlight **`0.1.0 (3)`** と異なる場合あり）。
>   2. encryption use を検証 — app binary、linked libraries（llama.cpp 等）、HTTPS/TLS、non-exempt crypto — [TestFlight prep operator checklist](./qwon_text_alpha_testflight_prep.md#export-compliance-operator-gate) に沿って。
>   3. TestFlight build **`2`** attestation と比較 — delta 記録または reuse 理由を文書化。
>   4. **public submission build** 向け ASC **輸出コンプライアンス / encryption** を完了 — TestFlight compliance の **自動引き継ぎを想定しない**。
>   5. attestation 出典（PR、memo、ASC 参照）を audit trail 用に記録。
>   6. submit 前 **Legal sign-off**。
> - **build `3` note:** doc gap を解消 — build `3` encryption posture が build `2` と planning 上一致するか formalize。
> - **submit 実行ではない**；worksheet から compliance **提出** ではない。

RE/Legal が編集・差し替え・却下すること。**ASC compliance final 承認ではない。**

---

## G4 完了チェックリスト（gate sign-off ではない）

| 項目 | 状態 |
| --- | --- |
| Q-AS-09 Legal/RE decision draft 準備 | **Done** — [明示承認待ち](#legal-re-decision-draft--awaiting-explicit-approval) |
| Q-AS-10 Legal/RE decision draft 準備 | **Done** — 明示承認待ち |
| Legal / RE **明示承認** | **Pending** |
| follow-up docs-only PR で intake **Answered** | **Pending** |
| checklist G4 Closed/Ready | **No** |
| Export compliance final submission | **No** |
| Public release approved | **No** |
| Build `4` / TestFlight upload / ASC submission | **No** |

---

## Agent note

**Legal / Release Engineering** 向け **明示承認** 用。**Legal/RE decision draft を intake Answered にコピーしたり ASC export compliance を提出したりしない** — 明示承認 + follow-up docs-only PR まで **Unanswered** を維持すること。
