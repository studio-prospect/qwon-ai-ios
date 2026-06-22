# QWON — App Store G3 プライバシー回答フォーム（日本語）

**最終更新:** 2026-06-22（G3 historical intake source — Legal/Product **approved for intake recording** は [#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)；現在の gate sign-off は [#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141) で **Closed/Ready**）
**状態:** **Historical intake worksheet** — [intake ledger](./qwon_app_store_public_readiness_intake.md) の **Q-AS-07 … Q-AS-08** は **Answered**（[#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)）。現在の checklist gate **G3** は [G3 gate sign-off worksheet](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal)（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)）で **Closed/Ready**。**final privacy nutrition label ではない**。**ASC privacy label publish 承認ではない**。**App Store 公開承認ではない**。**Build `4` 承認ではない**。**TestFlight upload / tag / version bump 承認ではない**。
**目的:** **Legal / Product** 向け G3 intake 回答を記録した historical intake source。現在の gate 判断は [G3 gate sign-off](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal)（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)）を正本とする。

English worksheet: [G3 Privacy Worksheet](./qwon_app_store_g3_privacy_worksheet.md)

関連: [Intake ledger — G3](./qwon_app_store_public_readiness_intake.md#g3--privacy-nutrition-labels) · [Checklist — G3](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [M3 network memo](./qwon_m3_network_device_expectation_memo.md) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [M2 guided placement](./qwon_model_download_gguf_ux_plan.md#pr-m2-post-merge-verification-2026-06-04) · [M3 Option A](./qwon_m3_spike_outcome_decision.md#decision-record)


**履歴ソース注記:** 本 worksheet は G3 intake [#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139) の **historical intake source** です。現在の gate 判断の正本は [G3 gate sign-off worksheet](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal)（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)）で、checklist gate **G3** は **Closed/Ready** です。worksheet 当時の gate 状態は下記で **historical at worksheet time** と明示します。

---

## 明示的な境界

| 境界 | 意味 |
| --- | --- |
| **G3 worksheet ≠ privacy label final 回答** | 本フォームは ASC App Privacy / nutrition label の確定回答ではない |
| **G3 worksheet ≠ 公開承認** | App Store 公開 go-live を承認しない |
| **G3 worksheet ≠ Build `4` 承認** | TestFlight upload / tag / version bump なし |
| **G3 worksheet ≠ ASC submission** | App Store Connect への privacy label 公開・提出 ops なし |
| **Stay selected** | Stay 解除・実装承認にはならない |
| **コード / SDK 変更なし** | app コード・analytics SDK・データ収集挙動の変更なし |
| **推奨案は draft** | [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) に置換済 — 下記は履歴用 |
| **記録** | Legal / Product **approved for intake recording** 2026-06-08 — intake **Answered**（[#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)）；historical at worksheet time: sign-off 前は **Open**；現在は **G3 Closed/Ready**（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)） |

---

<a id="legal-product-decision-draft--awaiting-explicit-approval"></a>

## Legal/Product decision draft — **approved for intake recording（intake 記録承認済）**

**ラベル:** **Legal/Product decision draft — approved for intake recording (2026-06-08)** — [intake ledger — G3 answer details](./qwon_app_store_public_readiness_intake.md#g3-legalproduct-answer-details-2026-06-08) に記録（[#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)；worksheet prep [#138](https://github.com/studio-prospect/qwon-ai-ios/pull/138)）。historical at worksheet time: **G3 Closed/Ready ではない**；現在は **G3 Closed/Ready**（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)）。**final ASC privacy label publish ではない**。**公開 / Build `4` 承認ではない**。

| 項目 | 値 |
| --- | --- |
| **準備日** | 2026-06-08 — Stay 下 docs-only hygiene（[#137](https://github.com/studio-prospect/qwon-ai-ios/pull/137)；decision draft [#138](https://github.com/studio-prospect/qwon-ai-ios/pull/138)） |
| **Intake ledger** | **Q-AS-07 … Q-AS-08 Answered**（[#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)） |
| **Gate sign-off** | **Done** — 準備 [#140](https://github.com/studio-prospect/qwon-ai-ios/pull/140) から [G3 sign-off](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal)（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)）へ移行；checklist gate **G3 Closed/Ready** |

### Q-AS-07 — ASC privacy nutrition labels（build `3` posture）

| 項目 | Legal/Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-07 |
| **承認回答（draft）** | TestFlight **`0.1.0 (3)`**（M3 downloader UI なし）の public-readiness 計画: **オンデバイス LLM 推論**中心 — ローカルモデル利用時はユーザーチャット/コンテンツを **ローカル処理**；**in-app model HTTPS download なし**；M2 **Place GGUF via Mac** + USB が tester-visible path。 |
| **ASC データ種別（draft）** | Legal が **User Content**（または ASC 相当）をオンデバイス処理用にマッピング — 第三者広告用ではない；build `3` で contact info / location / browsing history / 広告識別子は **計画しない**。 |
| **ユーザー紐づけ（draft）** | 第三者広告/トラッキングカテゴリでは **No** — **RE/Legal が binary 検証**。 |
| **トラッキング（draft）** | build `3` に第三者 tracking SDK **なし** 想定。 |
| **cloud optional（draft）** | optional cloud LLM escalation（存在する場合）は **別途開示** — ASC 公開前に Legal が実挙動確認。 |
| **Diagnostics（draft）** | build `3` の runtime diagnostics は **local-only**；crash-analytics SDK **なし** — **RE 検証**。 |
| **判断 owner** | Legal（**approved for intake recording** — 2026-06-08） |
| **出典** | 推奨案 § Q-AS-07 · [G1/G2 入力](#g1--g2-入力g3-参照用) |
| **制約** | **final ASC privacy label ではない**；historical at worksheet time: **G3 Closed/Ready ではない**；現在は **G3 Closed/Ready**（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)） |

### Q-AS-08 — model download / cloud / diagnostics の privacy label 影響

| 項目 | Legal/Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-08 |
| **承認回答（draft）** | **ユーザー起点 in-app model download**（M3 または後続）を含む将来 build は build `3` より **privacy label 更新が必要** — ネットワークは **取得** 用でメッセージ毎 chat ではない；download build 出荷前に **release-time ASC/privacy 再確認** 必須。 |
| **build `3` から変わるカテゴリ（draft）** | Legal がネットワーク関連・product interaction 等をマッピング — **final リストではない**。 |
| **ネットワーク開示（draft）** | ユーザー起点 HTTPS model fetch（~400 MB クラス）を **download 開始前** に開示 · [M3 network memo Gate 6](./qwon_m3_network_device_expectation_memo.md#gate-6--privacy--network-disclosure-copy)。 |
| **model download 影響（draft）** | フォアグラウンド・ユーザー起点 fetch のみ；**インストール後 local-first** — download がある場合 **完全オフライン** と謳わない。 |
| **cloud optional 影響（draft）** | optional cloud LLM 経路（出荷時）は local 推論・download 取得と **別開示**。 |
| **Diagnostics / support 影響（draft）** | crash analytics や support PII 収集の追加は **別途** label 更新 — build `3` baseline の範囲外；[Q-AS-13](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy) に委譲。 |
| **依存（draft）** | [Q-AS-11](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy)；build `3` 回答は **自動引き継ぎ不可**。 |
| **判断 owner** | Legal（**approved for intake recording** — 2026-06-08） |
| **出典** | 推奨案 § Q-AS-08 · [M3 gate answers](./qwon_m3_gate_answer_intake.md) |
| **制約** | **final privacy label 承認ではない**；historical at worksheet time: **G3 Closed/Ready ではない**；現在は **G3 Closed/Ready**（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)） |

---

## 現状エビデンス

| 項目 | 値 |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **Checklist gate G2** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)) |
| **Intake ledger total** | **24 questions · 16 Unanswered · 8 Answered** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · **M3 downloader UI なし** |
| **M3 posture** | **Option A** — compile-gated **default-off**；M3 lane **closed** |
| **Tester-visible model path** | M2 **Place GGUF via Mac** + USB — [guided placement](./qwon_model_download_gguf_ux_plan.md#pr-m2-post-merge-verification-2026-06-04)；build `3` では in-app GGUF download なし |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |
| **ASC privacy label publish approved?** | **No** |
| **Checklist gate G3** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal)（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)） |
| **G3 intake** | **Q-AS-07 … Q-AS-08 Answered**（[#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)） |

### G1 + G2 入力（G3 参照用）

| 出典 | 要約 |
| --- | --- |
| **G1 Q-AS-01** | local-first cognitive runtime — 原則オンデバイス推論 |
| **G1 Q-AS-02** | 主要: プライバシー重視の早期採用者 |
| **G2 Q-AS-04** | App Store 文案は local-first / プライバシー訴求 |
| **M3 Gate 6 方向** | download 実装時は fetch 前開示 + release-time ASC/privacy 再確認 · [network memo](./qwon_m3_network_device_expectation_memo.md) |

---

## Q-AS-07 — ASC privacy nutrition labels（build `3` posture）

| 項目 | 値 |
| --- | --- |
| **Gate** | G3 |
| **Owner** | Legal |
| **Intake 状態** | **Answered**（[#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)） |

### 質問

TestFlight 上 **M3 downloader UI なし** の現行 build **`3`** posture で、オンデバイス LLM 推論に対する **ASC privacy nutrition label** 回答は何か？

### Legal / Product 記入欄

**[approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval)** を参照 — intake **Answered**（[#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)）；historical at worksheet time: sign-off 前は **Open**；現在は **G3 Closed/Ready**（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)）。

| 項目 | 記入 |
| --- | --- |
| **承認回答** | TestFlight **`0.1.0 (3)`**：オンデバイス LLM 推論；ローカル処理；in-app download なし；M2 Mac+USB path。（*approved for intake recording*） |
| **ASC データ種別** | User Content 等 — オンデバイス処理；第三者広告用ではない。（*approved for intake recording*） |
| **ユーザー紐づけ** | 第三者広告/トラッキングでは No — RE/Legal 検証。（*approved for intake recording*） |
| **トラッキング** | 第三者 tracking SDK なし。（*approved for intake recording*） |
| **cloud optional** | 存在する場合は別途開示。（*approved for intake recording*） |
| **Diagnostics** | local-only；crash-analytics SDK なし。（*approved for intake recording*） |
| **判断 owner** | Legal（approved for intake recording） |
| **出典** | [Intake ledger — G3 answer details](./qwon_app_store_public_readiness_intake.md#g3-legalproduct-answer-details-2026-06-08) |
| **制約** | final ASC 公開ではない；historical at worksheet time: G3 Closed/Ready ではない；現在は G3 Closed/Ready（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)） |

### 推奨回答案（superseded — 履歴）

> *Superseded by [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) — トレーサビリティ用に残す。*

> **Build `3` ベースライン（計画 draft）:**
> - TestFlight **`0.1.0 (3)`** に **M3 in-app model download なし**；M2 **Place GGUF via Mac** + USB が tester-visible path。
> - **ローカル推論:** ローカルモデル利用時はユーザーチャット/コンテンツを **オンデバイス処理** — Legal が ASC カテゴリにマッピング（例: **User Content** — オンデバイス処理；第三者広告用ではない）。
> - **第三者 analytics / 広告（draft）:** build `3` に **第三者 analytics / 広告 SDK なし** を前提 — **RE/Legal が実 binary で検証**。
> - **ネットワーク（build `3`）:** in-app model HTTPS fetch なし；**optional cloud LLM escalation**（存在する場合）は別途開示 — Legal が実挙動を確認。
> - **Diagnostics:** build `3` の in-app runtime diagnostics は **local-only** 想定；crash-analytics SDK なし — **RE 検証**。
> - **サポート連絡:** in-app PII 収集は想定しない — [Q-AS-13](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy) に委譲。

Historical at worksheet time: Legal が編集・差し替え・却下する必要があった。**final privacy label ではない。** Intake **Answered** ([#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139))；現行 G3 gate は [sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal)（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)）。

---

## Q-AS-08 — model download / cloud / diagnostics の privacy label 影響

| 項目 | 値 |
| --- | --- |
| **Gate** | G3 |
| **Owner** | Legal |
| **Intake 状態** | **Answered**（[#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)） |

### 質問

将来の **public build** に in-app model download（M3 または後続）が含まれる場合、build **`3`** と比べて privacy label にどの変更が必要か？

### Legal / Product 記入欄

**[approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval)** を参照 — intake **Answered**（[#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)）；historical at worksheet time: sign-off 前は **Open**；現在は **G3 Closed/Ready**（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)）。

| 項目 | 記入 |
| --- | --- |
| **承認回答** | in-app download あり将来 build は build `3` より label 更新必要；release-time 再確認必須。（*approved for intake recording*） |
| **build `3` から変わるカテゴリ** | Legal マッピング — final リストではない。（*approved for intake recording*） |
| **ネットワーク開示** | download 開始前に HTTPS fetch 開示。（*approved for intake recording*） |
| **model download 影響** | ユーザー起点 fetch；インストール後 local-first。（*approved for intake recording*） |
| **cloud optional 影響** | local / download と別開示。（*approved for intake recording*） |
| **Diagnostics / support 影響** | 追加機能は別途 label 更新。（*approved for intake recording*） |
| **判断 owner** | Legal（approved for intake recording） |
| **出典** | [Intake ledger — G3 answer details](./qwon_app_store_public_readiness_intake.md#g3-legalproduct-answer-details-2026-06-08) |
| **制約** | Q-AS-11 依存；historical at worksheet time: G3 Closed/Ready ではない；現在は G3 Closed/Ready（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)） |

### 推奨回答案（superseded — 履歴）

> *Superseded by [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) — トレーサビリティ用に残す。*

> **in-app download あり将来 build（計画 draft）:**
> - **ユーザー起点 HTTPS model fetch**（~400 MB クラス）は build `3` より **privacy label 更新が必要** — ネットワークは **取得** 用で、メッセージ毎の chat 送信ではない · [M3 network memo Gate 6](./qwon_m3_network_device_expectation_memo.md#gate-6--privacy--network-disclosure-copy)。
> - **影響しうるカテゴリ（draft）:** Legal がマッピング — ネットワーク関連・product interaction・diagnostics 等；**final リストではない**。
> - **インストール後も local-first:** download がある場合 **完全オフライン** と謳わない；推論はインストール後オンデバイス。
> - **Cloud optional:** optional cloud LLM 経路（出荷時）は local 経路・download 取得と **別開示**。
> - **Diagnostics / support:** crash analytics や support 連絡先収集の追加は **別途** label 更新 — build `3` baseline の範囲外。
> - **依存:** [Q-AS-11](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy)；download build 前に **release-time ASC/privacy 再確認**（[M3 gate answers](./qwon_m3_gate_answer_intake.md)）。
> - **build `3` の回答は自動的に引き継がれない** — 別 Legal レビューが必要。

Historical at worksheet time: Legal が編集・差し替え・却下する必要があった。**privacy label 確定承認ではない。** Intake **Answered** ([#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139))；現行 G3 gate は [sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal)（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)）。

---

## G3 完了チェックリスト（gate sign-off ではない）

| 項目 | 状態 |
| --- | --- |
| Q-AS-07 Legal/Product decision draft 準備 | **Done** — [approved for intake recording](#legal-product-decision-draft--awaiting-explicit-approval) |
| Q-AS-08 Legal/Product decision draft 準備 | **Done** — approved for intake recording |
| Legal / Product **approved for intake recording** | **Done** — 2026-06-08（[#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)） |
| follow-up docs-only PR で intake **Answered** | **Done** — [#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139) |
| **G3 gate sign-off worksheet** 準備 | **Done** — [#140](https://github.com/studio-prospect/qwon-ai-ios/pull/140) |
| checklist G3 Closed/Ready | **Done** — [#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141) |
| Public release approved | **No** |
| Build `4` / ASC privacy label publish | **No** |

---

## Agent note

Legal / Product 向け G3 intake の historical worksheet。intake **Answered**（[#139](https://github.com/studio-prospect/qwon-ai-ios/pull/139)）は ASC privacy label 公開・公開承認・Build `4`・ASC submission・TestFlight ops を承認せず、現在の checklist gate **G3 Closed/Ready** は gate sign-off（[#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)）のみを正本とする。
