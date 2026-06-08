# QWON — App Store G2 メタデータ回答フォーム（日本語）

**最終更新:** 2026-06-08（G2 intake **Q-AS-04 … Q-AS-06 Answered** — This PR；gate sign-off **Open**）
**状態:** **Product decision draft 承認済** — [intake ledger](./qwon_app_store_public_readiness_intake.md) の **Q-AS-04 … Q-AS-06** を **Answered** に記録（This PR）。checklist gate **G2** は **Open** のまま。**App Store 公開承認ではない**。**Build `4` 承認ではない**。**TestFlight upload / tag / version bump 承認ではない**。
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
| **記録** | Product **intake 記録承認済**（2026-06-08）— intake **Answered**（This PR）；**G2 gate sign-off** は **Open** のまま |

---

<a id="product-decision-draft--awaiting-explicit-approval"></a>

## Product decision draft — **intake 記録承認済（approved for intake recording）**

**ラベル:** **Product decision draft — intake 記録承認済（2026-06-08）** — [intake ledger](./qwon_app_store_public_readiness_intake.md#g2-product-answer-details-2026-06-08) に記録（This PR）。**G2 Closed/Ready ではない**。**公開承認ではない**。**承認済み App Store 文案 / ASC upload ではない**。

| 項目 | 値 |
| --- | --- |
| **準備日** | 2026-06-08 — Stay 下の docs-only hygiene（[#133](https://github.com/studio-prospect/qwon-ai-ios/pull/133)） |
| **Product 明示承認** | **2026-06-08** — draft を intake 回答として受理 |
| **Intake ledger** | **Q-AS-04 … Q-AS-06** — **Answered**（This PR） |
| **次の段階** | **G2 gate sign-off worksheet** — checklist **Closed/Ready** は別 docs-only PR |

### Q-AS-04 — タイトル / サブタイトル / 説明文

| 項目 | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-04 |
| **タイトル（draft）** | QWON |
| **サブタイトル（draft）** | Local-first AI on your iPhone |
| **説明文（draft）** | QWON is a local-first cognitive runtime for iPhone. Keep inference and context on-device by default — not a cloud-only chat wrapper. Built for privacy-conscious users who want on-device AI assistance without default cloud dependency. |
| **判断 owner** | Product（**intake 記録承認済** — 2026-06-08） |
| **出典** | [推奨案 § Q-AS-04](#q-as-04--タイトル--サブタイトル--説明文) · [G1 回答](./qwon_app_store_public_readiness_intake.md#g1-product-answer-details-2026-06-07) |
| **制約** | **承認済み App Store 文案ではない**；intake **Answered**（This PR）；**G2 gate sign-off** は **Open** |

### Q-AS-05 — スクリーンショット / デバイスサイズ

| 項目 | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-05 |
| **承認回答（draft）** | **デバイスサイズ:** iPhone 6.7" / 6.5" クラス（提出時 ASC 必須サイズ要確認)。**向き:** v1 は縦のみ。**セット:** 3–5 枚 — (1) チャット/ホーム、(2) オンデバイス/ローカル訴求、(3) プライバシー/local-first 価値。 |
| **判断 owner** | Product（**intake 記録承認済** — 2026-06-08） |
| **出典** | [推奨案 § Q-AS-05](#q-as-05--スクリーンショットセット--デバイスサイズ) |
| **制約** | ASC screenshot upload なし；intake **Answered**（This PR）；**G2 gate sign-off** は **Open** |

### Q-AS-06 — ロケール

| 項目 | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-06 |
| **主要ロケール（draft）** | English (U.S.) — `en-US` metadata / screenshots |
| **延期ロケール（draft）** | 日本語（`ja`）および追加ロケール — **TBD** |
| **判断 owner** | Product（**intake 記録承認済** — 2026-06-08） |
| **出典** | [推奨案 § Q-AS-06](#q-as-06--メタデータ--スクリーンショットのロケール) |
| **制約** | ローカライズ資産の作成/upload 承認ではない；intake **Answered**（This PR） |

---

## 現状エビデンス

| 項目 | 値 |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **G1 intake** | **Q-AS-01 … Q-AS-03** — **Answered** ([#129](https://github.com/studio-prospect/qwon-ai-ios/pull/129)) |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha |
| **G2 intake** | **Q-AS-04 … Q-AS-06** — **Answered**（This PR） |
| **Checklist gate G2** | **Open** — gate sign-off 待ち |
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
| **Intake 状態** | **Answered**（This PR） |

### 質問

初回公開向けの **App Store タイトル・サブタイトル・説明文** は何を承認しますか？

### Product 記入欄

**[intake 記録承認済](#product-decision-draft--awaiting-explicit-approval)** を参照 — intake **Answered**（This PR）；**G2 gate sign-off** は **Open** のまま。

| 項目 | 記入 |
| --- | --- |
| **タイトル** | QWON（*intake 記録承認済*） |
| **サブタイトル** | Local-first AI on your iPhone（*intake 記録承認済*） |
| **説明文** | QWON is a local-first cognitive runtime for iPhone. Keep inference and context on-device by default — not a cloud-only chat wrapper. Built for privacy-conscious users who want on-device AI assistance without default cloud dependency.（*intake 記録承認済*） |
| **判断 owner** | Product |
| **出典** | [intake 記録承認済 § Q-AS-04](#product-decision-draft--awaiting-explicit-approval) · [intake 詳細](./qwon_app_store_public_readiness_intake.md#g2-product-answer-details-2026-06-08) |
| **制約** | 承認済み App Store 文案ではない；G2 Closed/Ready ではない |

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
| **Intake 状態** | **Answered**（This PR） |

### 質問

初回公開に必要な **スクリーンショットセットとデバイスサイズ**（機種・向き）は何ですか？

### Product 記入欄

**[intake 記録承認済](#product-decision-draft--awaiting-explicit-approval)** を参照 — intake **Answered**（This PR）；**G2 gate sign-off** は **Open** のまま。

| 項目 | 記入 |
| --- | --- |
| **必要デバイスサイズ** | iPhone 6.7" / 6.5" クラス（*intake 記録承認済 — 提出時 ASC 要確認*） |
| **向き** | v1 は縦のみ（*intake 記録承認済*） |
| **枚数 / 訴求内容** | 3–5 枚 — チャット/ホーム；オンデバイス/ローカル；プライバシー/local-first（*intake 記録承認済*） |
| **判断 owner** | Product |
| **出典** | [intake 記録承認済 § Q-AS-05](#product-decision-draft--awaiting-explicit-approval) · [intake 詳細](./qwon_app_store_public_readiness_intake.md#g2-product-answer-details-2026-06-08) |
| **制約** | ASC upload なし；G2 Closed/Ready ではない |

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
| **Intake 状態** | **Answered**（This PR） |

### 質問

初回公開で **メタデータとスクリーンショット** の対象 **ロケール** はどれですか？

### Product 記入欄

**[intake 記録承認済](#product-decision-draft--awaiting-explicit-approval)** を参照 — intake **Answered**（This PR）；**G2 gate sign-off** は **Open** のまま。

| 項目 | 記入 |
| --- | --- |
| **主要ロケール** | English (U.S.) — `en-US`（*intake 記録承認済*） |
| **延期ロケール** | 日本語（`ja`）および追加ロケール — **TBD**（*intake 記録承認済*） |
| **判断 owner** | Product |
| **出典** | [intake 記録承認済 § Q-AS-06](#product-decision-draft--awaiting-explicit-approval) · [intake 詳細](./qwon_app_store_public_readiness_intake.md#g2-product-answer-details-2026-06-08) |
| **制約** | ローカライズ資産 upload 承認ではない；G2 Closed/Ready ではない |

### 推奨回答案（draft / not approved）

> **主要:** English (U.S.) — `en-US` の metadata / screenshots。
> **延期:** 日本語（`ja`）および追加ロケール — **TBD**。

---

## G2 完了チェックリスト（gate sign-off ではない）

| 項目 | 状態 |
| --- | --- |
| Q-AS-04 Product decision draft 準備 | **Done** — [intake 記録承認済](#product-decision-draft--awaiting-explicit-approval) |
| Q-AS-05 Product decision draft 準備 | **Done** — intake 記録承認済 |
| Q-AS-06 Product decision draft 準備 | **Done** — intake 記録承認済 |
| Product **明示承認** | **Approved** — 2026-06-08 |
| follow-up docs-only PR で intake **Answered** | **Done** — This PR |
| checklist G2 Closed/Ready | **No** — gate sign-off 別 PR 待ち |
| Public release approved | **No** |

---

## Agent note

G2 intake **Answered**（This PR）。intake 記録だけでは checklist gate **G2 Closed/Ready** や公開承認にならない。Stay 下の docs hygiene のみ。
