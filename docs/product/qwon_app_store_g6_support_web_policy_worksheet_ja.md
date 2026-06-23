# QWON — App Store G6 サポート・Web・ポリシー回答フォーム（日本語）

**最終更新:** 2026-06-22（G6 worksheet 準備 — intake **Unanswered**）
**状態:** **Working Draft / Awaiting Product + Legal answers** — [intake ledger](./qwon_app_store_public_readiness_intake.md) の **Q-AS-13 … Q-AS-15** は **Unanswered** のまま。checklist gate **G6** は **Open**。**G6 Closed/Ready ではない**。**App Store 公開承認ではない**。**Build `4` 承認ではない**。**TestFlight upload / tag / version bump / ASC submission 承認ではない**。
**目的:** **Product** と **Legal** 向け — **G6 — サポート連絡先 / website / terms / privacy policy** の回答収集用 **現行 worksheet**（collection surface）。**正本の gate 状態は** [intake ledger — G6](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy) を参照。intake **Answered** 記録は **別 docs-only PR**。**G6 gate sign-off** は回答確定後の **さらに別 docs-only PR**（worksheet prep [#163](https://github.com/studio-prospect/qwon-ai-ios/pull/163) では行わない）。

English worksheet: [G6 Support / Website / Terms / Privacy Policy Worksheet](./qwon_app_store_g6_support_web_policy_worksheet.md)

関連: [Intake ledger — G6](./qwon_app_store_public_readiness_intake.md#g6--support--website--terms--privacy-policy) · [Checklist — G6](./qwon_app_store_public_readiness_checklist.md#3-public-readiness-gates) · [G5 gate sign-off](./qwon_app_store_g5_gate_signoff_worksheet.md#sign-off-record-legal-product) · [G3 privacy worksheet](./qwon_app_store_g3_privacy_worksheet.md) · [G3 intake — Q-AS-07](./qwon_app_store_public_readiness_intake.md#g3--privacy-nutrition-labels) · [Post-M3 decision record](./qwon_post_m3_next_lane_decision.md#decision-record)

---

## 明示的な境界

| 境界 | 意味 |
| --- | --- |
| **G6 worksheet ≠ 公開承認** | 本フォーム記入は App Store 公開 go-live を承認しない |
| **G6 worksheet ≠ Build `4` 承認** | TestFlight upload / tag / **`CFBundleVersion` bump なし** |
| **G6 worksheet ≠ ASC submission** | App Store Connect の policy URL 公開・submission ops なし |
| **G6 worksheet ≠ G6 Closed/Ready** | worksheet 準備は gate **G6** を閉じない — sign-off は回答確定後の **別 docs-only PR** |
| **G6 worksheet ≠ website / hosting / domain 実装** | website デプロイ、domain 取得、email 設定、app コード変更なし |
| **G6 worksheet ≠ 法務文案 final 承認** | privacy policy / terms の最終文面は本フォームで承認されない |
| **Stay selected** | Stay 解除・実装承認にはならない |
| **推測禁止** | URL・連絡先・hosted policy 場所・Legal 結論を **推測して記入しない** — stakeholder 回答まで空欄 |
| **記録** | Product / Legal の **明示承認後**、**別 docs-only PR** で intake を **Answered** に更新 → その後 **G6 gate sign-off worksheet** を別 PR で準備 |

---

## Worksheet 状態

| 項目 | 値 |
| --- | --- |
| **準備日** | 2026-06-22 — Stay 下 docs-only hygiene |
| **Intake ledger** | **Q-AS-13 … Q-AS-15** — **Unanswered**（follow-up answer-recording PR まで変更なし） |
| **Checklist gate G6** | **Open** |
| **Gate sign-off** | **未着手** — intake **Answered** 確定後の **別 docs-only PR** |
| **次の段階** | Product / Legal が下記 stakeholder answer 欄を記入 → follow-up docs-only PR で [intake ledger](./qwon_app_store_public_readiness_intake.md) に **Answered** 記録 |

---

## 現状エビデンス

| 項目 | 値 |
| --- | --- |
| **Checklist gate G1** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g1_gate_signoff_worksheet.md#sign-off-record-product) ([#131](https://github.com/studio-prospect/qwon-ai-ios/pull/131)) |
| **Checklist gate G2** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g2_gate_signoff_worksheet.md#sign-off-record-product) ([#136](https://github.com/studio-prospect/qwon-ai-ios/pull/136)) |
| **Checklist gate G3** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g3_gate_signoff_worksheet.md#sign-off-record-legal) ([#141](https://github.com/studio-prospect/qwon-ai-ios/pull/141)) |
| **Checklist gate G4** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g4_gate_signoff_worksheet.md#sign-off-record-legal-re) ([#146](https://github.com/studio-prospect/qwon-ai-ios/pull/146)) |
| **Checklist gate G5** | **Closed/Ready** — [sign-off Approved](./qwon_app_store_g5_gate_signoff_worksheet.md#sign-off-record-legal-product) ([#157](https://github.com/studio-prospect/qwon-ai-ios/pull/157)) |
| **Checklist gate G6** | **Open** |
| **Intake ledger total** | **24 questions · 12 Unanswered · 12 Answered** |
| **Active TestFlight** | **QWON `0.1.0 (3)`** — stable alpha · ASC **`6775685841`** |
| **G6 intake** | **Q-AS-13 … Q-AS-15 Unanswered** |
| **Public release approved?** | **No** |
| **Build `4` approved?** | **No** |

### G1–G5 入力（G6 参照用）

| 出典 | 要約 |
| --- | --- |
| **G3 Q-AS-07** | build `3` privacy nutrition label 計画 — サポート連絡先は G6 に委譲 |
| **G3 Q-AS-08** | 将来 in-app download の label 更新 — G6 policy URL posture とは別 |
| **G5 Q-AS-11 … Q-AS-12** | **Option A Mac+USB** interim — in-app download / hosted distribution **未承認** |

---

## 回答フォーマット（各質問でコピー可）

```text
Question ID:
Stakeholder answer:
Decision owner:
Source / evidence (meeting / email / memo / PR):
Review notes (Product / Legal / RE):
Constraints or deferrals:
```

---

<a id="q-as-13--public-support-contact"></a>

## Q-AS-13 — Public support contact

| 項目 | 値 |
| --- | --- |
| **Gate** | G6 |
| **Owner** | Product |
| **Intake 状態** | **Unanswered**（follow-up PR まで変更なし） |

### 質問

App Store listing / review 向けに承認される **public support contact**（email、URL、in-app path）は何か？

### Stakeholder 記入欄

| 項目 | 記入 |
| --- | --- |
| **Stakeholder answer** | — |
| **Contact type** | — *（email / URL / in-app path / 組み合わせ — Product が指定）* |
| **App Store listing での使い方** | — |
| **判断 owner** | Product |
| **Source / evidence** | — |
| **Review notes** | — |
| **制約** | **公開承認ではない**；**G6 Closed/Ready ではない**；follow-up PR まで intake **Answered** にしない |

---

<a id="q-as-14--privacy-policy-and-terms-urls"></a>

## Q-AS-14 — Privacy policy and terms of service URLs

| 項目 | 値 |
| --- | --- |
| **Gate** | G6 |
| **Owner** | Legal |
| **Intake 状態** | **Unanswered**（follow-up PR まで変更なし） |

### 質問

App Review 向け **hosted privacy policy / terms of service** の URL はどこに置くか — コンテンツ更新 owner は誰か？

### Stakeholder 記入欄

| 項目 | 記入 |
| --- | --- |
| **Stakeholder answer** | — |
| **Privacy policy URL** | — *（Legal が供給 — 推測しない）* |
| **Terms of service URL** | — *（Legal が供給 — 推測しない）* |
| **Hosting / domain owner** | — |
| **Content update owner** | — |
| **G3 Q-AS-07 との関係** | — *（privacy nutrition label 整合 — Legal が確認）* |
| **判断 owner** | Legal |
| **Source / evidence** | — |
| **Review notes** | — |
| **制約** | **final 法務文案ではない**；**ASC policy 公開ではない**；**G6 Closed/Ready ではない** |

---

<a id="q-as-15--marketing-or-product-website-url"></a>

## Q-AS-15 — Marketing or product website URL

| 項目 | 値 |
| --- | --- |
| **Gate** | G6 |
| **Owner** | Product |
| **Intake 状態** | **Unanswered**（follow-up PR まで変更なし） |

### 質問

App Store listing からリンクする **marketing / product website URL**（あれば）は何か — submit 前に live か？

### Stakeholder 記入欄

| 項目 | 記入 |
| --- | --- |
| **Stakeholder answer** | — |
| **Website URL（あれば）** | — *（Product が供給 — 推測しない）* |
| **Submit 前に live?** | — *（yes / no / deferred — Product が指定）* |
| **ASC listing link の使い方** | — |
| **判断 owner** | Product |
| **Source / evidence** | — |
| **Review notes** | — |
| **制約** | **website 実装承認ではない**；**domain / hosting ops ではない**；**G6 Closed/Ready ではない** |

---

## G6 完了チェックリスト（gate sign-off ではない）

| 項目 | 状態 |
| --- | --- |
| Q-AS-13 stakeholder answer 欄 | **Open** — Product が記入 |
| Q-AS-14 stakeholder answer 欄 | **Open** — Legal が記入 |
| Q-AS-15 stakeholder answer 欄 | **Open** — Product が記入 |
| Product / Legal **明示承認**（intake 記録用） | **未着手** |
| follow-up docs-only PR で intake **Answered** | **未着手** |
| **G6 gate sign-off worksheet** | **未着手** — intake **Answered** 後の別 PR |
| checklist G6 Closed/Ready | **No** |
| Public release approved | **No** |
| Build `4` / TestFlight upload / ASC submission | **No** |

---

## Agent note

**Product / Legal** 向け **G6 intake 回答収集** のみ。worksheet 準備だけで **G6 Closed/Ready**、URL / 連絡先の推測、policy 文案公開、**公開 / Build `4`** を承認しない。gate sign-off は回答確定後の **別 docs-only PR**。Stay 下 hygiene のみ。
