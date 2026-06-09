# QIL Specification v0.1

## Overview

QIL (QWON Intermediate Language) は、人間の自然言語を AI が実行可能な構造化タスクへ変換するための中間表現である。

QWON内部の全AgentはQILを介して通信する。

---

## Design Goals

* 人間の曖昧な指示を正規化する
* Agent間通信を構造化する
* モデル非依存とする
* 将来的なFine Tuningなしで運用可能とする

---

## Core Structure

```yaml
version: 1

intent: implement_feature

goal:
  ユーザー登録機能追加

constraints:
  - 既存UI維持
  - DB変更最小

outputs:
  - implementation
  - tests

success_criteria:
  - registration_success
  - duplicate_prevention

priority: medium
```

---

## Intent Types

* implement_feature
* fix_bug
* review_code
* write_document
* create_design
* investigate_issue
* execute_workflow

---

## Lifecycle

Human Language
↓
QIL Generator
↓
Validator
↓
Agent Assignment
↓
Agent Execution

---

## Validation Rules

必須項目

* intent
* goal
* outputs

不足時はAgent実行禁止

---

## Future Extensions

* confidence score
* cost estimation
* execution budget
* security classification
* multi-language support
