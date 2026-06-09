# QWON Node Architecture v0.1

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
