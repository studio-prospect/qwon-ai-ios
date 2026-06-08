# QWON — App Store G3 プライバシー回答フォーム（日本語）

**最終更新:** 2026-06-08（G3 privacy worksheet 追加 — intake **Unanswered**）
**状態:** **共有用 worksheet** — [intake ledger](./qwon_app_store_public_readiness_intake.md) の **Q-AS-07 … Q-AS-08** は **Unanswered** のまま。**App Store privacy nutrition label の final 回答ではない**。**App Store 公開承認ではない**。**Build `4` 承認ではない**。**TestFlight upload / tag / version bump / ASC submission 承認ではない**。
**目的:** **Legal / Product** が **G3 — Privacy nutrition labels** に回答し、別 docs-only PR で intake に記録する前の合意形成用日本語フォーム。

English worksheet: [G3 Privacy Worksheet](./qwon_app_store_g3_privacy_worksheet.md)

関連: [Intake ledger — G3](./qwon_app_store_public_readiness_intake.md#g3--privacy-nutrition-labels) · [Checklist — G3](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [M3 network memo](./qwon_m3_network_device_expectation_memo.md) · [M3 distribution compliance memo](./qwon_m3_model_distribution_compliance_memo.md) · [M2 guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement) · [M3 Option A](./qwon_m3_spike_outcome_decision.md#decision-record)

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
| **推奨案は draft** | **draft / not approved** — Legal / Product が差し替え・却下するまで intake **Answered** にしない |
| **記録** | Legal / Product **明示承認** 後に **別 docs-only PR** で intake を **Answered** に更新 |

---

## 現状エビデンス

| 項目 | 値 |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **Checklist gate G2** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)) |
| **Intake ledger total** | **24 questions · 18 Unanswered · 6 Answered** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · **M3 downloader UI なし** |
| **M3 posture** | **Option A** — compile-gated **default-off**；M3 lane **closed** |
| **Tester-visible model path** | M2 **Place GGUF via Mac** + USB — [guided placement](./qwon_model_download_gguf_ux_plan.md#m2-guided-external-placement)；build `3` では in-app GGUF download なし |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |

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
| **Intake 状態** | **Unanswered** |

### 質問

TestFlight 上 **M3 downloader UI なし** の現行 build **`3`** posture で、オンデバイス LLM 推論に対する **ASC privacy nutrition label** 回答は何か？

### Legal / Product 記入欄

| 項目 | 記入 |
| --- | --- |
| **承認回答** | |
| **ASC データ種別** | |
| **ユーザーに紐づくか** | |
| **トラッキングに使用するか** | |
| **cloud optional 経路（あれば）** | |
| **Diagnostics / crash データ** | |
| **判断 owner** | Legal |
| **出典** | |
| **制約** | ASC 公開確定ではない；follow-up PR まで intake **Answered** にしない |

### 推奨回答案（draft / not approved）

> **Build `3` ベースライン（計画 draft）:**
> - TestFlight **`0.1.0 (3)`** に **M3 in-app model download なし**；M2 **Place GGUF via Mac** + USB が tester-visible path。
> - **ローカル推論:** ローカルモデル利用時はユーザーチャット/コンテンツを **オンデバイス処理** — Legal が ASC カテゴリにマッピング（例: **User Content** — オンデバイス処理；第三者広告用ではない）。
> - **第三者 analytics / 広告（draft）:** build `3` に **第三者 analytics / 広告 SDK なし** を前提 — **RE/Legal が実 binary で検証**。
> - **ネットワーク（build `3`）:** in-app model HTTPS fetch なし；**optional cloud LLM escalation**（存在する場合）は別途開示 — Legal が実挙動を確認。
> - **Diagnostics:** build `3` の in-app runtime diagnostics は **local-only** 想定；crash-analytics SDK なし — **RE 検証**。
> - **サポート連絡:** in-app PII 収集は想定しない — [Q-AS-13](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy) に委譲。

Legal が編集・差し替え・却下すること。**final privacy label ではない。**

---

## Q-AS-08 — model download / cloud / diagnostics の privacy label 影響

| 項目 | 値 |
| --- | --- |
| **Gate** | G3 |
| **Owner** | Legal |
| **Intake 状態** | **Unanswered** |

### 質問

将来の **public build** に in-app model download（M3 または後続）が含まれる場合、build **`3`** と比べて privacy label にどの変更が必要か？

### Legal / Product 記入欄

| 項目 | 記入 |
| --- | --- |
| **承認回答** | |
| **build `3` から変わるカテゴリ** | |
| **ネットワーク開示要件** | |
| **model download の影響** | |
| **cloud optional の影響** | |
| **Diagnostics / support の影響** | |
| **判断 owner** | Legal |
| **出典** | |
| **制約** | [Q-AS-11](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy) に依存；follow-up PR まで intake **Answered** にしない |

### 推奨回答案（draft / not approved）

> **in-app download あり将来 build（計画 draft）:**
> - **ユーザー起点 HTTPS model fetch**（~400 MB クラス）は build `3` より **privacy label 更新が必要** — ネットワークは **取得** 用で、メッセージ毎の chat 送信ではない · [M3 network memo Gate 6](./qwon_m3_network_device_expectation_memo.md#gate-6--privacy--network-disclosure-copy)。
> - **影響しうるカテゴリ（draft）:** Legal がマッピング — ネットワーク関連・product interaction・diagnostics 等；**final リストではない**。
> - **インストール後も local-first:** download がある場合 **完全オフライン** と謳わない；推論はインストール後オンデバイス。
> - **Cloud optional:** optional cloud LLM 経路（出荷時）は local 経路・download 取得と **別開示**。
> - **Diagnostics / support:** crash analytics や support 連絡先収集の追加は **別途** label 更新 — build `3` baseline の範囲外。
> - **依存:** [Q-AS-11](./qwon_app_store_public_readiness_intake.md#g5--model-distribution-policy)；download build 前に **release-time ASC/privacy 再確認**（[M3 gate answers](./qwon_m3_gate_answer_intake.md)）。
> - **build `3` の回答は自動的に引き継がれない** — 別 Legal レビューが必要。

Legal が編集・差し替え・却下すること。**privacy label 確定承認ではない。**

---

## G3 完了チェックリスト（gate sign-off ではない）

| 項目 | 状態 |
| --- | --- |
| Q-AS-07 worksheet draft 準備 | **Done** |
| Q-AS-08 worksheet draft 準備 | **Done** |
| Legal / Product **明示承認** | **Pending** |
| follow-up docs-only PR で intake **Answered** | **Pending** |
| checklist G3 Closed/Ready | **No** |
| Public release approved | **No** |
| Build `4` / ASC privacy label publish | **No** |

---

## Agent note

**Legal / Product** 共有用。推奨 draft を intake **Answered** にコピーしたり ASC privacy label を公開したりしない。Stay 下の docs hygiene のみ。
