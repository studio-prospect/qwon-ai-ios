# QWON Strategic Memo after WWDC26

## 概要

WWDC26において Apple は Apple Intelligence および Foundation Models Framework を大幅に強化した。

当初は Apple Intelligence が QWON と競合する可能性を懸念していたが、発表内容を分析した結果、Apple は AI アプリケーションではなく AI 実行基盤の提供を目指していると判断した。

QWON は Apple Intelligence と競争するのではなく、その上位レイヤーで動作する AI オーケストレーションプラットフォームとして進化するべきである。

---

# 基本認識

## WWDC26以前の仮説

QWON は複数の LLM を統合するプラットフォームである。

* OpenAI
* Claude
* Gemini
* Local LLM

を横断的に利用する。

## WWDC26後の仮説

モデル統合そのものは価値が低下する。

Apple 自身が Foundation Models Framework を通じて複数モデルへの抽象化を進めているためである。

今後価値を持つのは、

> どのモデルを使うか

ではなく、

> どの仕事を誰に任せるか

である。

---

# QWONの再定義

QWON は AI チャットアプリではない。

QWON は AI ワーカー管理システムである。

人間のチームを管理するマネージャーのように、複数の AI ワーカーへジョブを分配し、進捗を監視し、成果物を統合する。

---

# 目指す世界観

ユーザーは自然言語で目的を伝えるだけでよい。

例：

> ユーザー登録機能を追加して

QWON は内部で以下を実行する。

```text
Architect
    ↓
Reviewer
    ↓
Coder
    ↓
Tester
```

各 Agent は最適なモデルで実行される。

例：

* Architect → Apple Foundation Model
* Reviewer → Claude
* Coder → Codex
* Tester → Apple Foundation Model

ユーザーはモデルを意識しない。

---

# QWONのコア価値

## AIオーケストレーション

複数 Agent による協調作業。

Agent 同士が成果物を受け渡しながら仕事を進める。

## ジョブ管理

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

## Agent Mailbox

Agent 間通信を自由文ではなく構造化データとして扱う。

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

これにより誤解や情報損失を最小化する。

---

# QWON Intermediate Language (QIL)

QWON の最重要技術候補。

## 目的

人間の曖昧な依頼を AI が実行可能な形式へ変換する。

## 変換モデル

```text
Human Language
        ↓
       QIL
        ↓
Agent Prompt
```

## QILの役割

* 目的の定義
* 制約条件の明確化
* 成功条件の定義
* 成果物の定義
* Agent へのタスク分割

## QILの例

```yaml
intent: implement_feature

goal:
  ユーザー登録機能追加

constraints:
  - 既存UIを維持
  - DB変更最小

outputs:
  - implementation
  - tests
  - review_notes

success_criteria:
  - 正常登録
  - 重複登録防止
```

---

# Fine Tuningに対する考え方

初期段階では Fine Tuning を前提としない。

優先順位は以下。

1. Structured Output
2. QIL
3. Validator
4. Few-shot Examples
5. Adapter Training
6. Fine Tuning

まずは構造化と検証により品質を確保する。

## 基本方針

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

# Appleとの関係

Apple は競合ではなく実行基盤である。

## Appleが提供するもの

* Foundation Models
* Apple Intelligence
* App Intents
* Private Cloud Compute

## QWONが提供するもの

* Agent Team
* Job Scheduler
* Workflow Engine
* QIL
* Agent Mailbox

---

# 将来構想

## QWON Mobile

iPhone 上で動作する指揮官。

* ジョブ投入
* 監視
* 通知
* 軽量推論

を担当する。

## QWON Desktop

Mac 上で動作する AI 実行ノード。

* Agent 実行
* ローカル推論
* 長時間ジョブ

を担当する。

## QWON Network

複数デバイスを統合する。

```text
iPhone
   ↓
MacBook
   ↓
Mac Studio
   ↓
Cloud LLM
```

タスク特性に応じて最適なノードへ振り分ける。

---

# 長期ビジョン

QWON は AI を提供するプロダクトではない。

QWON は AI チームを提供するプロダクトである。

ユーザーは個々のモデルを意識しない。

必要なのは、

> 仕事を依頼すること

だけである。

QWON は最適な Agent を編成し、実行し、監視し、成果物を返却する。

---

# 現時点での結論

Apple Intelligence は QWON の価値を奪わない。

むしろ Apple が AI 実行基盤を整備することで、QWON はその上位レイヤーに集中できる。

QWON が解決すべき問題は、

> どの AI を使うか

ではなく、

> 複数の知能をどのように組織化して仕事を完遂させるか

である。

これを実現する中核技術が、

* QIL (QWON Intermediate Language)
* Agent Orchestration
* Job Scheduling
* Agent Mailbox

である。

---

**Version:** 0.1
**Date:** 2026-06-09
**Status:** Working Draft
