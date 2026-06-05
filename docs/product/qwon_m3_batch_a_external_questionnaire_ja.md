# QWON — M3 Batch A 外部共有用質問票

**最終更新:** 2026-06-05
**状態:** **質問票のみ** — **回答は未記録**、**Gate Ready サインオフなし**、**M3 実装承認ではない**、**Build `4` 承認ではない**。
**目的:** M3 Batch A: Gates **1–3**（ホスティング、チェックサム、コンプライアンス）について、Product / Legal / Codex が回答しやすい共有用質問票として整理する。

English version: [M3 Batch A External Questionnaire](./qwon_m3_batch_a_external_questionnaire.md)

関連: [Gate answer intake ledger](./qwon_m3_gate_answer_intake.md) · [Batch A review session](./qwon_m3_gate_readiness_review_plan.md#batch-a-review-session-2026-06-05) · [Hosting + checksum memo](./qwon_m3_model_hosting_checksum_memo.md) · [Compliance memo](./qwon_m3_model_distribution_compliance_memo.md)

---

## 回答者向けルール

自分が owner になっている質問だけ回答してください。Gate を **Pending** から **Ready** に進めるには、書面での回答が必要です。

| ルール | 内容 |
| --- | --- |
| **Question ID を残す** | 回答には必ず `Q-A-##` を含めてください。intake ledger に対応付けるためです。 |
| **出典を示す** | memo、meeting notes、email thread、legal note、PR、decision record など、判断の出典をリンクしてください。 |
| **推測しない** | 沈黙や部分的な同意は承認ではありません。未回答行は `Unanswered` のままにします。 |
| **実装承認ではない** | この回答は M3 spike、Swift 実装、Build `4`、TestFlight upload、tag、GGUF artifact 変更を承認しません。 |
| **Ready サインオフではない** | 回答済みになっても、別の Ready sign-off PR までは Gate は **Pending** のままです。 |

### 回答フォーマット

```text
Question ID:
回答:
判断 owner:
出典 / link:
制約:
追加対応:
```

---

## 要約

Batch A は、QWON が in-app model download spike に進むための前提条件を確認するものです。後続 Gate に必要な最低限の policy input を決める段階であり、実装詳細を決めるものではありません。

| Gate | 項目 | 現状 | 必要な結果 |
| --- | --- | --- | --- |
| **1** | Hosting / URL ownership | **Pending** | Product が owner、hosting model、artifact identity を決める。 |
| **2** | SHA-256 / byte size | **Pending** | Product/Codex が Gate 1 artifact の正確な byte size と SHA-256 policy を公開する。 |
| **3** | License / redistribution / export | **Pending** | Legal/Product が in-app model download と distribution path の可否を確認する。 |

---

## Gate 1 — Hosting と artifact に関する質問

Owner: **Product**

| ID | 質問 | 必要な回答 |
| --- | --- | --- |
| **Q-A-01** | model hosting の named owner は誰ですか？ | URL availability、object update、rollback、incident response に責任を持つ team または role。 |
| **Q-A-02** | 承認する hosting model はどれですか？ | QWON-owned CDN/object storage、pinned Hugging Face URL、QWON-built artifact hosting、または M3 download defer のいずれか。 |
| **Q-A-03** | M3 で配布する正確な artifact は何ですか？ | bartowski `Q4_K_M` GGUF をそのまま使うのか、QWON-hosted mirror か、QWON-built/repackaged blob かを明記。 |
| **Q-A-04** | artifact を再現可能に pin する方法は何ですか？ | immutable revision、object key、etag/version ID、または同等の artifact identity。 |
| **Q-A-05** | tester-facing build で第三者の Hugging Face URL を使ってよいですか？ | Product の yes/no。yes の場合は Legal dependency も明記。 |

### Gate 1 回答チェックリスト

| Gate 1 Ready 前に必要なもの | 状態 |
| --- | --- |
| Hosting owner が決まっている | Pending |
| Hosting model が選択されている | Pending |
| Product URL または artifact object identity が記録されている | Pending |
| Artifact pinning policy が記録されている | Pending |
| Third-party URL の扱いが記録されている | Pending |

---

## Gate 2 — Checksum と byte size に関する質問

Owner: **Product + Codex**

Gate 2 は Gate 1 で正確な artifact が特定されるまで確定できません。Product/Codex が Gate 1 source として明示的に承認しない限り、ops-only の hash を final として公開しないでください。

| ID | 質問 | 必要な回答 |
| --- | --- | --- |
| **Q-A-06** | Gate 1 artifact の正確な expected byte size は何ですか？ | approximate MB や range ではなく、単一の integer byte count。 |
| **Q-A-07** | Gate 1 artifact の SHA-256 は何ですか？ | 承認済み artifact identity に紐づく final checksum。 |
| **Q-A-08** | hash が一致しない既存 USB-placed GGUF はどう扱いますか？ | `present-unverified` 継続、再取得必須、または別の migration policy を明記。 |

### Gate 2 回答チェックリスト

| Gate 2 Ready 前に必要なもの | 状態 |
| --- | --- |
| Gate 1 の exact artifact が選択されている | Pending |
| Exact byte size が公開されている | Pending |
| SHA-256 が公開されている | Pending |
| Verification failure policy が合意されている | Pending |
| Legacy USB file policy が合意されている | Pending |

---

## Gate 3 — Legal / compliance に関する質問

Owner: **Legal via Product**

これらの回答は Product/legal source から出る必要があります。Engineering は public model metadata だけから license、redistribution、export、App Store posture を推測しないでください。

| ID | 質問 | 必要な回答 |
| --- | --- | --- |
| **Q-A-09** | Qwen base model license は、QWON アプリ経由で user device へ model download を促すことを許可しますか？ | Legal の yes/no と必要条件。 |
| **Q-A-10** | QWON は bartowski GGUF quant を end users に再配布できますか？ | direct hosting、mirroring、third-party URL use それぞれに対する Legal/Product の yes/no。 |
| **Q-A-11** | 必要な attribution / NOTICE text は何ですか？ | in-app、docs、Settings、legal notice に必要な copy。 |
| **Q-A-12** | in-app model download は export compliance または App Store privacy label の回答を変えますか？ | download UX を含む TestFlight build 前に必要な ASC/export/privacy action。 |
| **Q-A-13** | Gate 1 で Hugging Face URL を選ぶ場合、production app fetch に関する Hugging Face ToS 制約はありますか？ | Legal の yes/no と third-party URL fetch の制約。 |

### Gate 3 回答チェックリスト

| Gate 3 Ready 前に必要なもの | 状態 |
| --- | --- |
| Qwen base license が app-facilitated download 向けに確認されている | Pending |
| bartowski GGUF redistribution/mirroring が確認されている | Pending |
| Attribution / NOTICE requirement が記録されている | Pending |
| Export compliance と privacy label への影響が記録されている | Pending |
| 必要な場合、Hugging Face ToS stance が記録されている | Pending |

---

## 依頼文（コピー用）

関係者に回答依頼する際は、このブロックを使ってください。

```text
QWON M3 Batch A について、in-app model download spike を scope する前に書面回答が必要です。

docs/product/qwon_m3_batch_a_external_questionnaire_ja.md のうち、担当する Question ID に回答してください。

Scope:
- Gate 1: hosting / URL ownership
- Gate 2: checksum / byte size
- Gate 3: license / redistribution / export compliance

重要:
- これは M3 実装承認ではありません。
- これは Build 4 承認ではありません。
- 回答だけでは Gate は Ready になりません。
- 実回答だけを docs/product/qwon_m3_gate_answer_intake.md に記録し、Batch が揃った場合のみ別途 Ready sign-off PR を開きます。

推奨回答フォーマット:
Question ID:
回答:
判断 owner:
出典 / link:
制約:
追加対応:
```

---

## 回答が届いた後

| Step | Action |
| --- | --- |
| 1 | [answer intake ledger](./qwon_m3_gate_answer_intake.md) の回答済み `Q-A-##` 行だけを更新する。 |
| 2 | 未回答行は変更しない。 |
| 3 | Answer source と Follow-up PR をリンクする。 |
| 4 | 別の Batch A Ready sign-off PR までは Gates 1–3 を **Pending** のままにする。 |
| 5 | 質問票への回答だけを理由に M3 spike や Build `4` 作業を開始しない。 |
