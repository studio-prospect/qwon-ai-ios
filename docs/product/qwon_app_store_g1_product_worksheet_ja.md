# QWON — App Store G1 Product 回答フォーム（日本語）

**最終更新:** 2026-06-07（G1 Product decision draft 準備済 — intake は **Unanswered** のまま）
**状態:** **Product decision draft / awaiting explicit approval 付き worksheet** — [intake ledger](./qwon_app_store_public_readiness_intake.md) の **Q-AS-01 … Q-AS-03** は **Unanswered** のまま。**App Store 公開承認ではない**。**Build `4` 承認ではない**。**TestFlight upload / tag / version bump 承認ではない**。
**目的:** Product が **G1 — プロダクトポジショニング / 価値提案** の 3 問に直接記入し、外部共有・合意形成に使うための日本語フォーム。

English worksheet: [G1 Product Answer Worksheet](./qwon_app_store_g1_product_worksheet.md)

関連: [App Store readiness intake — G1](./qwon_app_store_public_readiness_intake.md#g1--product-positioning--value-proposition) · [Public readiness checklist](./qwon_app_store_public_readiness_checklist.md) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## 回答者向けルール

| ルール | 内容 |
| --- | --- |
| **Stay selected** | 本フォームへの記入は Stay を解除せず、実装・ASC 操作を承認しません |
| **公開承認ではない** | 記入内容は **入力素材** です。intake ledger への **Answered** 反映は Product **明示承認** 後の **別 PR** で行います |
| **Question ID を残す** | 各回答に **Q-AS-01** など ID を明記してください |
| **推奨案は draft** | 下記「推奨回答案（draft / not approved）」は **未承認のたたき台** です。そのまま App Store 文案や intake の Answered にしないでください |
| **ASC 操作禁止** | 本タスクから submission・メタデータ upload・スクリーンショット・新ビルドは行いません |

### 記入フォーマット（コピー用）

```text
Question ID:
承認回答:
判断 owner:
出典（会議 / メール / メモ / PR）:
制約・保留事項:
```

---

<a id="product-decision-draft--awaiting-explicit-approval"></a>

## Product decision draft — **awaiting explicit approval（明示承認待ち）**

**ラベル:** **Product decision draft / awaiting explicit approval** — 推奨案をベースに Product レビュー用に整理。**intake Answered ではない**。**G1 Closed/Ready ではない**。**公開承認ではない**。

| 項目 | 値 |
| --- | --- |
| **準備日** | 2026-06-07 — Stay 下の docs-only hygiene |
| **Intake ledger** | **Q-AS-01 … Q-AS-03** は Product 明示承認 + follow-up PR まで **Unanswered** |
| **次の段階** | Product が各 draft を確認・編集・却下 → docs-only PR で [intake ledger](./qwon_app_store_public_readiness_intake.md) を **Answered** に更新 |

### Q-AS-01 — 公開ポジショニング（1 文）

| 項目 | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-01 |
| **承認回答（draft）** | QWON は、推論とコンテキストを原則オンデバイスに保つ iPhone 向け local-first cognitive runtime です — クラウド前提のチャットラッパーではありません。 |
| **判断 owner** | Product（draft — **明示承認待ち**） |
| **出典** | [推奨案 § Q-AS-01](#q-as-01--公開ポジショニング1-文) · [AGENTS.md](../../AGENTS.md) |
| **制約** | **承認済み App Store 文案ではない**；follow-up PR まで intake **Answered** にしない |

### Q-AS-02 — 主要オーディエンス

| 項目 | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-02 |
| **承認回答（draft）** | **主要:** デフォルトのクラウド依存を避けたい **プライバシー意識の高い iPhone ユーザーと早期採用者**。**副次:** ローカル LLM ワークフローを評価する開発者・パワーユーザー。 |
| **判断 owner** | Product（draft — **明示承認待ち**） |
| **出典** | [推奨案 § Q-AS-02](#q-as-02--主要オーディエンス) |
| **制約** | メタデータ（Q-AS-04）前にオーディエンスを絞る可能性あり |

### Q-AS-03 — 価格モデル

| 項目 | Product decision draft |
| --- | --- |
| **Question ID** | Q-AS-03 |
| **価格モデル（draft）** | 初回公開計画時点では **TBD** |
| **判断理由（draft）** | text-alpha で runtime コアは検証済み。monetization はサポートコスト・モデル配布方針・App Store カテゴリ期待値の **別 Product 判断** が必要。 |
| **判断 owner** | Product（draft — **明示承認待ち**） |
| **出典** | [推奨案 § Q-AS-03](#q-as-03--価格モデル) |
| **制約** | 価格 **未決定**；有料/サブスク承認と読ませない |

---

## 前提（Product 向けコンテキスト）

| 項目 | 値 |
| --- | --- |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha |
| **プロダクト方向性（エンジニアリング docs）** | ローカルファーストの cognitive runtime — 汎用チャットアプリのクローンではない · [AGENTS.md](../../AGENTS.md) |
| **テスター向けモデル取得** | M2 **Place GGUF via Mac** + USB（build `3` で変更なし） |
| **M3 downloader** | Option A — compile-gated **default-off** · lane **closed** |

---

## Q-AS-01 — 公開ポジショニング（1 文）

| 項目 | 値 |
| --- | --- |
| **Gate** | G1 |
| **Owner** | Product |
| **Intake 状態** | **Unanswered**（follow-up PR まで変更しない） |

### 質問

App Store 向けの **公開ポジショニング（1 文）** として何を承認しますか？ — **local-first cognitive runtime** と **汎用チャットアシスタント** のどちらに寄せるかを含めてください。

### Product 記入欄

**[Product decision draft](#product-decision-draft--awaiting-explicit-approval)** を参照 — **Product decision draft / awaiting explicit approval**；intake は **Unanswered** のまま。

| 項目 | 記入 |
| --- | --- |
| **承認回答** | QWON は、推論とコンテキストを原則オンデバイスに保つ iPhone 向け local-first cognitive runtime です — クラウド前提のチャットラッパーではありません。（*draft — 明示承認待ち*） |
| **判断 owner** | Product（draft） |
| **出典** | [Product decision draft § Q-AS-01](#product-decision-draft--awaiting-explicit-approval) |
| **制約・保留** | 承認済み App Store 文案ではない；intake **Answered** にしない |

### 推奨回答案（draft / not approved）

> QWON は、推論とコンテキストを原則オンデバイスに保つ iPhone 向け local-first cognitive runtime です — クラウド前提のチャットラッパーではありません。

Product が編集・差し替え・却下してください。**承認済み App Store 文案ではありません。**

### ブロック解除（intake 参照）

Q-AS-02、Q-AS-04（メタデータ文案）、G1 sign-off（本フォームとは別ゲート）

---

## Q-AS-02 — 主要オーディエンス

| 項目 | 値 |
| --- | --- |
| **Gate** | G1 |
| **Owner** | Product |
| **Intake 状態** | **Unanswered** |

### 質問

**初回の App Store 公開** の主要オーディエンスは誰ですか？（例: パワーユーザー、プライバシー重視、開発者、一般消費者）

### Product 記入欄

**[Product decision draft](#product-decision-draft--awaiting-explicit-approval)** を参照 — **Product decision draft / awaiting explicit approval**；intake は **Unanswered** のまま。

| 項目 | 記入 |
| --- | --- |
| **承認回答** | **主要:** デフォルトのクラウド依存を避けたい **プライバシー意識の高い iPhone ユーザーと早期採用者**。**副次:** ローカル LLM ワークフローを評価する開発者・パワーユーザー。（*draft — 明示承認待ち*） |
| **判断 owner** | Product（draft） |
| **出典** | [Product decision draft § Q-AS-02](#product-decision-draft--awaiting-explicit-approval) |
| **制約・保留** | intake **Answered** にしない |

### 推奨回答案（draft / not approved）

> **主要:** デフォルトのクラウド依存を避けたい **プライバシー意識の高い iPhone ユーザーと早期採用者**。
> **副次:** ローカル LLM ワークフローを評価する開発者・パワーユーザー。

### ブロック解除

Q-AS-04、Q-AS-05（スクリーンショットの訴求軸）、G1 sign-off

---

## Q-AS-03 — 価格モデル

| 項目 | 値 |
| --- | --- |
| **Gate** | G1 |
| **Owner** | Product |
| **Intake 状態** | **Unanswered** |

### 質問

初回公開の **価格モデル**（無料 / 有料 / サブスクリプション / TBD）は何ですか？ **判断理由** も記載してください。

### Product 記入欄

**[Product decision draft](#product-decision-draft--awaiting-explicit-approval)** を参照 — **Product decision draft / awaiting explicit approval**；intake は **Unanswered** のまま。

| 項目 | 記入 |
| --- | --- |
| **価格モデル** | TBD（*draft — 明示承認待ち*） |
| **判断理由** | text-alpha で runtime コアは検証済み。monetization はサポートコスト・モデル配布方針・App Store カテゴリ期待値の **別 Product 判断** が必要。 |
| **判断 owner** | Product（draft） |
| **出典** | [Product decision draft § Q-AS-03](#product-decision-draft--awaiting-explicit-approval) |
| **制約・保留** | 価格未決定；intake **Answered** にしない |

### 推奨回答案（draft / not approved）

> **価格モデル:** 初回公開計画時点では **TBD**。
> **理由（作業仮説）:** text-alpha で runtime コアは検証済み。monetization はサポートコスト・モデル配布方針・App Store カテゴリ期待値の **別 Product 判断** が必要。**未承認。**

### ブロック解除

Q-AS-04（ストア文案の経済面）、G1 sign-off

---

## G1 完了チェックリスト（フォーム — gate sign-off ではない）

| 項目 | 状態 |
| --- | --- |
| Q-AS-01 Product decision draft 準備 | **Done** — [明示承認待ち](#product-decision-draft--awaiting-explicit-approval) |
| Q-AS-02 Product decision draft 準備 | **Done** — 明示承認待ち |
| Q-AS-03 Product decision draft 準備 | **Done** — 明示承認待ち |
| Product **明示承認** | **Pending** |
| follow-up docs-only PR で intake を **Answered** に更新 | **Pending** |
| checklist G1 を Closed / Ready にした | **No** — 明示的 Product gate sign-off が必要 |

**Public release approved?** **No**

---

## Agent note

Product への外部共有は本フォーム（日本語）または [English worksheet](./qwon_app_store_g1_product_worksheet.md) を使用。**明示承認**後に follow-up PR で intake **Answered** へ反映。それまでは intake を **Unanswered** のまま維持すること。
