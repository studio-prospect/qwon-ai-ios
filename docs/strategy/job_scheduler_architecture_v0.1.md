# Job Scheduler Architecture v0.1

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
