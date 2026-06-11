# Job Scheduler Architecture v0.1

**Document type:** Strategy RFC
**Version:** 0.1
**Date:** 2026-06-09
**Status:** Working Draft — **not** implementation approval. Does **not** authorize orchestrator / runtime job pipeline code.

**Apple context:** [Strategic Memo — Apple primary sources](./qwon_strategic_memo_after_wwdc26.md#apple-primary-sources-wwdc26). This doc is **QWON-side design inference** only.

Related: [Strategic Memo after WWDC26](./qwon_strategic_memo_after_wwdc26.md) · [Node Architecture v0.1](./qwon_node_architecture_v0.1.md) · [Agent Mailbox Protocol v0.1](./agent_mailbox_protocol_v0.1.md)

---

## Document boundaries

| Boundary | Meaning |
| --- | --- |
| **RFC ≠ implementation** | Job model and scheduling policies are proposals — not production orchestrator behavior |
| **RFC ≠ product gate** | Does **not** approve M3 reopen, cloud escalation policy, or public release |
| **Stay selected** | RFC maintenance does **not** lift Stay |

---

## Overview

Job SchedulerはQWON全体の司令塔である。

ジョブ生成
ジョブ分割
Agent割当
再試行
進捗管理

を担当する。

---

## Job Model

```yaml
job:
  feature_312

stages:
  - design
  - implementation
  - review
  - test
  - delivery
```

---

## Scheduling Strategy

### Sequential

```text
Architect
↓
Coder
↓
Reviewer
↓
Tester
```

### Parallel

```text
Researcher A
Researcher B
Researcher C
↓
Synthesizer
```

---

## Retry Policy

review failed

↓

coder retry

↓

review again

---

## Future

* priority queue
* deadline aware scheduling
* cost optimization
* node affinity
* model affinity

---

## Agent note

QWON-side RFC only. Job scheduling semantics must be reconciled with PREXUS runtime boundaries in a separate Codex-scoped plan before implementation.
