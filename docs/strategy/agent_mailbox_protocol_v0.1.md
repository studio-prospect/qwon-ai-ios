# Agent Mailbox Protocol v0.1

**Document type:** Strategy RFC
**Version:** 0.1
**Date:** 2026-06-09
**Status:** Working Draft — **not** implementation approval. Does **not** authorize agent messaging or runtime IPC code.

**Apple context:** [Strategic Memo — Apple primary sources](./qwon_strategic_memo_after_wwdc26.md#apple-primary-sources-wwdc26). This doc is **QWON-side design inference** only.

Related: [Strategic Memo after WWDC26](./qwon_strategic_memo_after_wwdc26.md) · [QIL Specification v0.1](./QIL_specification_v0.1.md) · [Job Scheduler v0.1](./job_scheduler_architecture_v0.1.md)

---

## Document boundaries

| Boundary | Meaning |
| --- | --- |
| **RFC ≠ implementation** | Message types and payloads are protocol sketches — not wired agent transport |
| **RFC ≠ Apple API** | Apple `LanguageModelSession` / tool calling is separate from QWON Agent Mailbox |
| **Stay selected** | RFC maintenance does **not** lift Stay |

---

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

---

## Agent note

QWON-side RFC only. Distinct from Apple Foundation Models tool calling — see [Apple documentation](https://developer.apple.com/documentation/foundationmodels/generating-content-and-performing-tasks-with-foundation-models).
