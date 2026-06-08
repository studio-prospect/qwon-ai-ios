# QWON — App Store G2 メタデータ回答フォーム（日本語）

**最終更新:** 2026-06-08
**状態:** **記入フォームのみ** — [intake ledger](./qwon_app_store_public_readiness_intake.md) の **Q-AS-04 … Q-AS-06** は **Unanswered** のまま。**App Store 公開承認ではない**。**Build `4` 承認ではない**。**TestFlight upload / tag / version bump 承認ではない**。
**目的:** Product が **G2 — App Store メタデータ / スクリーンショット / ローカライズ** の 3 問に記入し、合意形成に使う日本語フォーム。

English worksheet: [G2 Metadata Worksheet](./qwon_app_store_g2_metadata_worksheet.md)

関連: [Intake ledger — G2](./qwon_app_store_public_readiness_intake.md#g2--app-store-metadata--screenshots--localization) · [Checklist — G2](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [G1 sign-off](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) · [G1 intake 回答](./qwon_app_store_public_readiness_intake.md#g1-product-answer-details-2026-06-07)

---

## 明示的な境界

| 境界 | 意味 |
| --- | --- |
| **G2 worksheet ≠ 公開承認** | 本フォームは App Store 公開 go-live を承認しない |
| **G2 worksheet ≠ Build `4` 承認** | TestFlight upload / tag / version bump なし |
| **G2 worksheet ≠ メタデータ upload** | ASC への metadata / screenshot upload なし |
| **Stay selected** | Stay 解除・実装承認にはならない |
| **推奨案は draft** | **draft / not approved** — intake **Answered** にしない |

---

## 現状エビデンス

| 項目 | 値 |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **G1 intake** | **Q-AS-01 … Q-AS-03** — **Answered** ([#129](https://github.com/studio-prospect/qwon-ai-ios/pull/129)) |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha |
| **G2 intake** | **Q-AS-04 … Q-AS-06** — **Unanswered** |
| **Checklist gate G2** | **Open** |
| **Public release approved?** | **No** |

### G1 入力（G2 参照用）

| Question ID | 要約 |
| --- | --- |
| **Q-AS-01** | iPhone 向け local-first cognitive runtime — 原則オンデバイス推論 |
| **Q-AS-02** | 主要: プライバシー重視の早期採用者；副次: 開発者・パワーユーザー |
| **Q-AS-03** | 価格 **TBD** |

全文: [G1 Product answer details](./qwon_app_store_public_readiness_intake.md#g1-product-answer-details-2026-06-07)

---

## Q-AS-04 — タイトル / サブタイトル / 説明文

| 項目 | 値 |
| --- | --- |
| **Gate** | G2 |
| **Owner** | Product |
| **Intake 状態** | **Unanswered** |

### 質問

初回公開向けの **App Store タイトル・サブタイトル・説明文** は何を承認しますか？

### Product 記入欄

| 項目 | 記入 |
| --- | --- |
| **タイトル** | |
| **サブタイトル** | |
| **説明文** | |
| **判断 owner** | |
| **出典** | |
| **制約** | |

### 推奨回答案（draft / not approved）

| 項目 | 草案 |
| --- | --- |
| **タイトル** | QWON |
| **サブタイトル** | Local-first AI on your iPhone |
| **説明文** | QWON is a local-first cognitive runtime for iPhone. Keep inference and context on-device by default — not a cloud-only chat wrapper. Built for privacy-conscious users who want on-device AI assistance without default cloud dependency. |

Product が編集・差し替え・却下すること。**承認済み App Store 文案ではない。**

---

## Q-AS-05 — スクリーンショットセット / デバイスサイズ

| 項目 | 値 |
| --- | --- |
| **Gate** | G2 |
| **Owner** | Product |
| **Intake 状態** | **Unanswered** |

### 質問

初回公開に必要な **スクリーンショットセットとデバイスサイズ**（機種・向き）は何ですか？

### Product 記入欄

| 項目 | 記入 |
| --- | --- |
| **必要デバイスサイズ** | |
| **向き** | |
| **枚数 / 訴求内容** | |
| **判断 owner** | |
| **出典** | |
| **制約** | |

### 推奨回答案（draft / not approved）

> **デバイスサイズ:** iPhone 6.7" / 6.5" クラス（提出時点の ASC 必須サイズ要確認）。
> **向き:** v1 は縦のみ。
> **セット:** 3–5 枚 — (1) チャット/ホーム、(2) オンデバイス/ローカル訴求、(3) プライバシー/local-first 価値。本 worksheet から ASC upload は行わない。

---

## Q-AS-06 — メタデータ / スクリーンショットのロケール

| 項目 | 値 |
| --- | --- |
| **Gate** | G2 |
| **Owner** | Product |
| **Intake 状態** | **Unanswered** |

### 質問

初回公開で **メタデータとスクリーンショット** の対象 **ロケール** はどれですか？

### Product 記入欄

| 項目 | 記入 |
| --- | --- |
| **主要ロケール** | |
| **延期ロケール** | |
| **判断 owner** | |
| **出典** | |
| **制約** | |

### 推奨回答案（draft / not approved）

> **主要:** English (U.S.) — `en-US` の metadata / screenshots。
> **延期:** 日本語（`ja`）および追加ロケール — **TBD**。

---

## G2 完了チェックリスト（gate sign-off ではない）

| 項目 | 状態 |
| --- | --- |
| Q-AS-04 Product 回答記入 | **Pending** |
| Q-AS-05 Product 回答記入 | **Pending** |
| Q-AS-06 Product 回答記入 | **Pending** |
| Product 明示承認 | **Pending** |
| follow-up PR で intake **Answered** | **Pending** |
| checklist G2 Closed/Ready | **No** |
| Public release approved | **No** |

---

## Agent note

推奨案を intake **Answered** にコピーしないこと。Product 明示承認後に別 docs-only PR で反映。
