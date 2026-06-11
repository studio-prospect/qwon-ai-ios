# QWON Node Architecture v0.1

**Document type:** Strategy RFC
**Version:** 0.1
**Date:** 2026-06-09
**Status:** Working Draft — **not** implementation approval. Does **not** authorize app, runtime, or node-integration code.

**Apple context:** Platform facts live in [Strategic Memo — Apple primary sources](./qwon_strategic_memo_after_wwdc26.md#apple-primary-sources-wwdc26). This doc is **QWON-side design inference** only.

Related: [Strategic Memo after WWDC26](./qwon_strategic_memo_after_wwdc26.md) · [Job Scheduler v0.1](./job_scheduler_architecture_v0.1.md)

---

## Document boundaries

| Boundary | Meaning |
| --- | --- |
| **RFC ≠ implementation** | Node roles and selection algorithm are design sketches — not shipped architecture |
| **RFC ≠ Apple API spec** | Apple Foundation Models / Language Model protocol behavior is defined by Apple docs, not this file |
| **Stay selected** | RFC maintenance does **not** lift Stay or approve Build / release gates |

---

## Overview

QWON NodeはAgent実行環境である。

Nodeは以下のいずれかで動作する。

* iPhone
* iPad
* MacBook
* Mac mini
* Mac Studio
* Cloud

---

## Node Roles

### Mobile Node

役割

* Job投入
* 通知
* 軽量推論

例

* iPhone 17
* iPad

---

### Worker Node

役割

* Agent実行
* ローカル推論
* 長時間処理

例

* MacBook Air
* Mac mini

---

### Compute Node

役割

* 高負荷Agent
* 並列処理

例

* Mac Studio

---

### Cloud Node

役割

* Claude
* OpenAI
* Gemini

利用条件

* ローカル実行不可
* ユーザー許可あり

---

## Node Selection Algorithm

評価軸

* latency
* cost
* privacy
* capability

例

```text
小タスク
↓
iPhone

開発作業
↓
Mac mini

巨大分析
↓
Claude Opus
```

---

## Long-Term Vision

QWON Network

```text
iPhone
 ↓
MacBook
 ↓
Mac Studio
 ↓
Cloud
```

を単一のAIチームとして扱う。

---

## Agent note

QWON-side RFC only. Verify Apple on-device / PCC / third-party model placement against [Apple Developer — Foundation Models](https://developer.apple.com/apple-intelligence/) before implementation.
