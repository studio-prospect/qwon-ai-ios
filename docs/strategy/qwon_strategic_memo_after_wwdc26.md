# QWON Strategic Memo after WWDC26

**Document type:** Strategy memo / RFC
**Version:** 0.1
**Date:** 2026-06-09
**Status:** Working Draft — **not** implementation approval, product gate, Stay lift, or App Store / Build authorization.

Related RFCs: [Node Architecture v0.1](./qwon_node_architecture_v0.1.md) · [Job Scheduler v0.1](./job_scheduler_architecture_v0.1.md) · [Agent Mailbox Protocol v0.1](./agent_mailbox_protocol_v0.1.md) · [QIL Specification v0.1](./QIL_specification_v0.1.md)

---

## Document boundaries (read first)

| Boundary | Meaning |
| --- | --- |
| **Strategy RFC ≠ implementation approval** | This memo does **not** authorize app, runtime, orchestrator, or model-integration code changes |
| **Strategy RFC ≠ product / release gate** | Does **not** approve public release, Build `4`, TestFlight upload, M3 reopen, or ASC submission |
| **Official facts ≠ QWON inference** | Sections below are explicitly labeled. **Do not** treat QWON inference as Apple-confirmed fact |
| **Stay selected** | Strategy doc maintenance does **not** lift Stay or select an implementation lane |
| **Working draft** | Conclusions may change as Apple documentation, betas, and QWON experiments evolve |

---

## Apple primary sources (WWDC26)

Consult these Apple Developer / Apple Newsroom pages before citing platform capabilities in product or implementation docs.

| Source | URL | Use for |
| --- | --- | --- |
| **WWDC26 Apple Intelligence guide** | [developer.apple.com/wwdc26/guides/apple-intelligence/](https://developer.apple.com/wwdc26/guides/apple-intelligence/) | WWDC26 overview — Foundation Models framework updates, Dynamic Profiles, Evaluations, PCC access terms |
| **Apple Intelligence (Developer)** | [developer.apple.com/apple-intelligence/](https://developer.apple.com/apple-intelligence/) | Apple Intelligence system scope, App Intents, Foundation Models framework positioning |
| **Foundation Models — generating content** | [developer.apple.com/documentation/foundationmodels/generating-content-and-performing-tasks-with-foundation-models](https://developer.apple.com/documentation/foundationmodels/generating-content-and-performing-tasks-with-foundation-models) | `SystemLanguageModel`, `LanguageModelSession`, guided generation, tool calling |
| **LanguageModelSession** | [developer.apple.com/documentation/foundationmodels/languagemodelsession](https://developer.apple.com/documentation/foundationmodels/languagemodelsession) | Session lifecycle, transcript, context limits |
| **WWDC26 — Bring an LLM provider** | [developer.apple.com/videos/play/wwdc2026/339/](https://developer.apple.com/videos/play/wwdc2026/339/) | Language Model protocol, third-party / local / server model integration |
| **WWDC25 — Meet the Foundation Models framework** | [developer.apple.com/videos/play/wwdc2025/286/](https://developer.apple.com/videos/play/wwdc2025/286/) | Original on-device FM framework introduction (baseline before WWDC26 expansion) |
| **Apple Newsroom (WWDC26)** | [apple.com/newsroom/2026/06/apple-aids-app-development-with-new-intelligence-frameworks-and-advanced-tools/](https://www.apple.com/newsroom/2026/06/apple-aids-app-development-with-new-intelligence-frameworks-and-advanced-tools/) | Press-level summary of framework and developer-program announcements |

**Note:** Platform availability, model capabilities, and API surfaces are defined by Apple documentation and shipping OS versions — not by this memo.

---

## 概要

WWDC26 で Apple は Apple Intelligence および Foundation Models framework の開発者向け surface を拡張した（[WWDC26 guide](https://developer.apple.com/wwdc26/guides/apple-intelligence/) · [Newsroom](https://www.apple.com/newsroom/2026/06/apple-aids-app-development-with-new-intelligence-frameworks-and-advanced-tools/)）。

本メモは、**Apple 公式に確認できる事実**と **QWON 側の仮説・推論**を分離し、後者に基づく今後の方向性を Strategy RFC として記録する。実装承認ではない。

---

# Apple 公式に確認できる事実（Primary sources）

> **Label:** Facts traceable to Apple Developer / Apple Newsroom at WWDC26 timeframe. Verify against current docs before implementation.

## Apple Intelligence（開発者向け）

* Apple Intelligence は Apple Foundation Models を核とした personal intelligence system として位置づけられ、iPhone / iPad / Mac / Apple Watch / Apple Vision Pro 向けに説明されている（[Apple Intelligence — Developer](https://developer.apple.com/apple-intelligence/)）。
* 開発者は **App Intents** でアプリのコンテンツとアクションを Siri およびシステム横断で統合できる（同上 · [Newsroom](https://www.apple.com/newsroom/2026/06/apple-aids-app-development-with-new-intelligence-frameworks-and-advanced-tools/)）。

## Foundation Models framework（WWDC26 時点）

* **Native Swift API** として、Apple Intelligence を支える on-device モデルへのアクセスを提供する（[WWDC26 guide](https://developer.apple.com/wwdc26/guides/apple-intelligence/) · [Documentation](https://developer.apple.com/documentation/foundationmodels/generating-content-and-performing-tasks-with-foundation-models)）。
* WWDC25 で導入された framework を **WWDC26 で拡張** — より強力な on-device モデル、画像入力、server models、custom skills 等（[Newsroom](https://www.apple.com/newsroom/2026/06/apple-aids-app-development-with-new-intelligence-frameworks-and-advanced-tools/)）。
* **Language Model protocol** に conform する任意のモデル（Apple Foundation Models、Claude / Gemini 等の cloud models、その他 provider）を **同一 Swift API surface** で扱える（[WWDC26 guide](https://developer.apple.com/wwdc26/guides/apple-intelligence/) · [Session 339](https://developer.apple.com/videos/play/wwdc2026/339/)）。
* **Multimodal prompts** — テキストに加え画像を渡し visual content を reasoning 可能（[WWDC26 guide](https://developer.apple.com/wwdc26/guides/apple-intelligence/)）。
* **Dynamic Profiles** — continuous session 内で models / tools / instructions を swap し adaptive behavior を実現（同上）。
* **Evaluations framework** — dynamic conditions 下で AI feature の振る舞いを検証（同上）。
* **`LanguageModelSession`** — session が context を保持し、`respond` / guided generation / tool calling を提供（[LanguageModelSession](https://developer.apple.com/documentation/foundationmodels/languagemodelsession) · [Documentation](https://developer.apple.com/documentation/foundationmodels/generating-content-and-performing-tasks-with-foundation-models)）。
* **Private Cloud Compute（PCC）** — next-generation Apple Foundation Models への access 経路として言及；App Store Small Business Program 等の条件付き no cloud API cost 枠が Newsroom / guide に記載（[WWDC26 guide](https://developer.apple.com/wwdc26/guides/apple-intelligence/) · [Newsroom](https://www.apple.com/newsroom/2026/06/apple-aids-app-development-with-new-intelligence-frameworks-and-advanced-tools/)）。**最終条件は Apple 公式 terms を参照。**

## Apple が提供するもの（公式カテゴリ — 要約）

| Category | Official reference |
| --- | --- |
| Foundation Models framework | [Apple Intelligence — Developer](https://developer.apple.com/apple-intelligence/) |
| Apple Intelligence system | 同上 |
| App Intents | 同上 · [Newsroom](https://www.apple.com/newsroom/2026/06/apple-aids-app-development-with-new-intelligence-frameworks-and-advanced-tools/) |
| Private Cloud Compute | [WWDC26 guide](https://developer.apple.com/wwdc26/guides/apple-intelligence/) |

---

# QWON側の仮説・推論（Not Apple-confirmed）

> **Label:** QWON strategic inference and design direction. **Not** Apple official statements. **Not** implementation approval.

## WWDC26以前の仮説

QWON は複数の LLM を統合するプラットフォームである。

* OpenAI
* Claude
* Gemini
* Local LLM

を横断的に利用する。

## WWDC26後の仮説

**推論:** モデル統合そのものの相対的価値は低下する方向にある。

**根拠（QWON解釈）:** Apple が Foundation Models framework および Language Model protocol を通じて **複数 provider への抽象化**を platform 側で進めているため（[Session 339](https://developer.apple.com/videos/play/wwdc2026/339/) を QWON 戦略文脈で解釈）。

**推論:** 今後 QWON が差別化しうる軸は、

> どのモデルを使うか

だけでなく、

> どの仕事を誰に任せるか

にある。

---

## QWONの再定義（推論）

QWON は AI チャットアプリではない。

QWON は AI ワーカー管理システムである。

人間のチームを管理するマネージャーのように、複数の AI ワーカーへジョブを分配し、進捗を監視し、成果物を統合する。

---

## 目指す世界観（推論 · 設計スケッチ）

ユーザーは自然言語で目的を伝えるだけでよい。

例：

> ユーザー登録機能を追加して

QWON は内部で以下を実行する（**例示 — 未実装 · 未承認**）。

```text
Architect
    ↓
Reviewer
    ↓
Coder
    ↓
Tester
```

各 Agent は最適なモデルで実行される（**例示**）。

* Architect → Apple Foundation Model
* Reviewer → Claude
* Coder → Codex
* Tester → Apple Foundation Model

ユーザーはモデルを意識しない。

---

## QWONのコア価値（推論 · RFC 候補）

### AIオーケストレーション

複数 Agent による協調作業。Agent 同士が成果物を受け渡しながら仕事を進める。

### ジョブ管理

ジョブは永続化される。

例：

```text
Feature #312
├─ Design
├─ Implementation
├─ Review
├─ Test
└─ Pull Request
```

ユーザーが離席しても処理は継続される。

### Agent Mailbox

Agent 間通信を自由文ではなく構造化データとして扱う — 詳細は [Agent Mailbox Protocol v0.1](./agent_mailbox_protocol_v0.1.md)。

例：

```yaml
status: needs_revision

reason:
  - validation_missing
  - edge_case_uncovered

next_action:
  assignee: coder
  task: add_validation_tests
```

---

## QWON Intermediate Language (QIL)（推論 · RFC 候補）

QWON の最重要技術候補 — 詳細は [QIL Specification v0.1](./QIL_specification_v0.1.md)。

### 目的

人間の曖昧な依頼を AI が実行可能な形式へ変換する。

### 変換モデル

```text
Human Language
        ↓
       QIL
        ↓
Agent Prompt
```

### QILの役割

* 目的の定義
* 制約条件の明確化
* 成功条件の定義
* 成果物の定義
* Agent へのタスク分割

---

## Fine Tuningに対する考え方（推論）

初期段階では Fine Tuning を前提としない。

優先順位は以下（**QWON 方針案 — 未検証**）。

1. Structured Output
2. QIL
3. Validator
4. Few-shot Examples
5. Adapter Training
6. Fine Tuning

まずは構造化と検証により品質を確保する。

### 基本方針

QWON のコア技術は Fine Tuning ではない。

重要なのは、

```text
LLM
 +
QIL
 +
Validator
```

である。

---

## Appleとの関係（推論）

**推論:** Apple は QWON の直接競合アプリではなく、**実行基盤（platform layer）** として位置づけうる。

上記は [Apple 公式事実](#apple-公式に確認できる事実primary-sources) の framework / protocol 拡張を QWON 戦略文脈で解釈したものであり、Apple の公式競合戦略声明ではない。

### QWONが提供するもの（推論 · 未実装）

| QWON layer (inference) | Notes |
| --- | --- |
| Agent Team | RFC — not shipped |
| Job Scheduler | [Job Scheduler v0.1](./job_scheduler_architecture_v0.1.md) |
| Workflow Engine | Future RFC |
| QIL | [QIL v0.1](./QIL_specification_v0.1.md) |
| Agent Mailbox | [Mailbox v0.1](./agent_mailbox_protocol_v0.1.md) |

---

## 将来構想（推論 · 未承認）

### QWON Mobile

iPhone 上で動作する指揮官 — ジョブ投入 / 監視 / 通知 / 軽量推論。

### QWON Desktop

Mac 上で動作する AI 実行ノード — Agent 実行 / ローカル推論 / 長時間ジョブ。

### QWON Network

複数デバイスを統合 — 詳細は [Node Architecture v0.1](./qwon_node_architecture_v0.1.md)。

```text
iPhone
   ↓
MacBook
   ↓
Mac Studio
   ↓
Cloud LLM
```

---

## 長期ビジョン（推論）

QWON は AI を提供するプロダクトではなく、AI チームを提供するプロダクトである。

ユーザーは個々のモデルを意識しない。必要なのは **仕事を依頼すること** だけ。

QWON は最適な Agent を編成し、実行し、監視し、成果物を返却する。

---

## 現時点での結論（推論 · Working Draft）

**推論:** Apple Intelligence / Foundation Models framework の platform 化は、QWON が **model plumbing** ではなく **orchestration / job delegation** に集中する余地を広げうる。

**推論:** QWON が解決すべき問題は、

> どの AI を使うか

だけでなく、

> 複数の知能をどのように組織化して仕事を完遂させるか

である。

これを実現する中核技術候補が、

* QIL (QWON Intermediate Language)
* Agent Orchestration
* Job Scheduling
* Agent Mailbox

である — いずれも **RFC / 未実装**。

---

## Agent note

Maintain **official fact vs QWON inference** separation when linking from product docs, intake, or implementation plans. Re-verify Apple APIs against [Apple Developer documentation](https://developer.apple.com/apple-intelligence/) before any runtime adapter work. **Do not** treat this memo as Stay lift or implementation authorization.
