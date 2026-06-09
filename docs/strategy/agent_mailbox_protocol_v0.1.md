# Agent Mailbox Protocol v0.1

## Overview

Agent MailboxはAgent間通信を行うためのメッセージングプロトコルである。

自然言語ではなく構造化データで通信する。

---

## Message Structure

```yaml
message_id: uuid

sender:
  architect

receiver:
  coder

job_id:
  feature_312

type:
  task_assignment

payload:
  specification_ref:
    design_doc_001
```

---

## Message Types

### task_assignment

作業依頼

### status_update

進捗通知

### review_result

レビュー結果

### clarification_request

質問

### completion

完了通知

### failure

失敗通知

---

## Review Example

```yaml
type: review_result

status: rejected

issues:
  - validation_missing
  - edge_case_uncovered

next_action:
  assignee: coder
```

---

## Design Principle

Agent同士は自由文で会話しない。

すべてMailbox経由で通信する。
