# Context Compression

## Purpose

Context compression is one of PREXUS's core differentiators. The goal is not merely to summarize conversation, but to reduce cloud-bound context while preserving enough semantic value for good downstream answers.

## Why It Matters

Without compression, a multi-model orchestration app quickly becomes:

- expensive
- slow
- privacy-heavy
- difficult to scale across long conversations

PREXUS depends on compression to make cloud escalation selective and efficient.

## Compression Goals

- reduce token count before cloud calls
- preserve user intent
- preserve critical recent context
- remove duplicates and low-value turns
- extract reusable task state
- improve memory and retrieval packaging

## Compression Targets

PREXUS can compress several things, not just chat history.

### Conversation history

Compress:

- long exchanges
- repeated clarifications
- prior solution attempts
- stale context

### Memory recall bundles

Compress:

- multiple similar memories
- overlapping preferences
- repeated project facts

### Retrieved documents

Compress:

- large passages into task-relevant snippets
- repeated sections
- low-relevance chunks

### Multimodal outputs

Compress:

- OCR text into task-focused extracts
- image understanding into scene summaries
- transcripts into actionable intent blocks

## Compression Stages

Suggested PREXUS pipeline:

1. Detect task intent
2. Identify required context classes
3. Remove obvious duplicates
4. Summarize recent dialogue
5. Extract durable task state
6. Select top-value memory or retrieval evidence
7. Build final compact prompt package

Compression should be incremental rather than reconstructing everything from scratch on every request.

## What Must Be Preserved

Compression quality depends on preserving the right things:

- current user goal
- unresolved constraints
- relevant prior decisions
- required technical facts
- privacy classification
- provider-relevant formatting hints

Losing these can make a shorter prompt much worse than a longer one.

## What Should Be Removed

- repeated acknowledgements
- duplicated facts
- stale branches of conversation
- low-value filler language
- raw logs or full transcripts when structured summary is enough

## Compression Forms

PREXUS may use several compression forms:

- short running summary
- task-state extraction
- bullet fact block
- structured routing packet
- memory recall digest

Different routes may need different output forms. A code-analysis escalation packet should not look the same as a creative-writing packet.

## Relationship With Routing

Compression is tightly coupled to routing.

Routing should decide:

- whether compression is needed
- how aggressive it should be
- whether memory or RAG should be merged before final packaging
- whether the task can stay local after compression

Compression is not a passive post-processing step. It is part of route construction.

## Relationship With Memory

Compression and memory should reinforce each other.

- memory writes should store compressed semantic value
- memory reads should return compact evidence
- repeated history should become stable memory instead of bloating prompts

This is how PREXUS avoids paying for the same context repeatedly.

## Failure Modes

Common compression risks:

- deleting crucial constraints
- over-summarizing technical nuance
- mixing contradictory facts
- preserving too much and saving little
- producing generic summaries that are poor prompt inputs

Compression quality should be judged by downstream task success, not only by token count reduction.

## Evaluation Criteria

Measure:

- token reduction ratio
- downstream answer quality after compression
- routing quality after compression
- preservation of key facts
- memory retrieval usefulness after compression

Target direction from requirements:

- meaningful reduction relative to naive full-history cloud prompting
- aspirational range of 1/10 to 1/50 for selected escalation scenarios

## MVP Recommendation

For MVP, keep compression practical:

- summarize recent dialogue
- extract current task state
- deduplicate obvious repeats
- narrow memory and retrieval payloads

Do not start with overly complex learned compression systems if a deterministic structured approach gets most of the value.
