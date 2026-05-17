# Memory Design

## Objective

PREXUS memory is a local-first long-term context system. Its purpose is not to log everything forever, but to preserve useful personal context in a compact, searchable, and user-controllable form.

Core goals:

- local storage by default
- compact semantic retention
- selective recall
- deletable and inspectable memory
- bounded growth

## Memory Roles

The memory system supports:

- recalling prior conversations
- preserving user preferences
- retaining durable project context
- reducing repeated cloud token usage
- enriching local and cloud responses with relevant history

Memory should improve continuity without turning every request into a full-history replay.

## Conceptual Flow

```text
Raw Interaction
  ↓
Episode Extraction
  ↓
Semantic Compression
  ↓
Embedding Generation
  ↓
Vector Storage
  ↓
Selective Recall
  ↓
Context Injection
```

## Memory Types

### 1. Ephemeral session context

Purpose:

- maintain immediate conversational coherence
- keep active turn context lightweight

Characteristics:

- short retention window
- fast access
- aggressively pruned

### 2. Episodic memory

Purpose:

- capture meaningful user interactions and outcomes
- retain specific events, tasks, or decisions

Examples:

- project goals
- prior troubleshooting steps
- confirmed user preferences
- important extracted facts

### 3. Semantic long-term memory

Purpose:

- retain compressed, durable knowledge about the user and their work
- support retrieval by semantic similarity

Examples:

- recurring interests
- stable preferences
- project-level summaries
- reusable technical context

## Storage Principles

- Store memory locally by default
- Keep raw data retention narrower than compressed memory retention
- Favor structured summaries over unbounded transcripts
- Separate content storage from embedding indexes
- Allow deletion and future reindexing

Suggested responsibility split:

- `episodic/`: event extraction and episodic records
- `compression/`: summary and distillation pipeline
- `embeddings/`: vector generation interfaces and caches
- `vector_store/`: indexing and retrieval layer

## Memory Write Pipeline

Memory writes should be deliberate, not automatic for every token.

Suggested pipeline:

1. Detect candidate interaction
2. Determine whether it has long-term value
3. Compress into a structured memory item
4. Generate embedding
5. Store content and metadata
6. Update vector index

Candidate signals:

- explicit user preference
- durable project information
- repeated pattern
- completed task outcome
- user-pinned or user-saved content

Avoid storing:

- low-value chatter
- duplicate summaries
- transient errors with no future value
- highly sensitive data unless policy permits

## Memory Record Shape

Each memory item should be compact and structured.

Suggested fields:

- `memoryId`
- `type`
- `summary`
- `sourceRef`
- `embeddingRef`
- `tags`
- `createdAt`
- `lastUsedAt`
- `sensitivity`
- `retentionPolicy`
- `deletionState`

This keeps memory inspectable and maintainable.

## Retrieval Strategy

Memory retrieval should be selective and cheap.

Suggested retrieval stages:

1. Determine whether memory is needed for the current task
2. Query vector store with compressed intent or task summary
3. Rank by relevance, recency, and sensitivity
4. Limit to a small top-k result set
5. Compress results again before prompt injection if needed

Retrieval should avoid:

- injecting raw historical dumps
- retrieving too many loosely related memories
- mixing incompatible sensitivity classes

## Sensitivity and Privacy

Every memory item should carry a privacy classification:

- `device_only`
- `local_preferred`
- `cloud_allowed`
- `restricted_provider`

Rules:

- `device_only` memories never leave the device
- cloud-bound memory injection must respect provider restrictions
- users must be able to delete memory records
- API keys and secrets are never memory items

## Compression Strategy

Compression is fundamental to memory quality.

The system should favor:

- concise factual summaries
- deduplication of repeated facts
- extraction of stable user preferences
- conversion of long histories into compact episodes

The memory system should work with the routing system so that recalled memories reduce token load instead of increasing it.

## Bounded Growth

Memory growth must be controlled to fit iPhone constraints.

Mechanisms:

- write thresholds
- duplicate suppression
- retention classes
- stale memory compaction
- lazy loading of heavy indexes
- embedding cache limits

Possible retention classes:

- short-lived
- standard
- pinned
- archive-candidate

## User Controls

Memory must remain user-controllable.

Minimum controls:

- inspect stored memory
- delete selected memory
- clear memory by scope
- disable specific memory categories
- choose whether cloud escalation may use recalled memory

## Offline Behavior

Memory retrieval and storage should remain functional offline for:

- local conversations
- local search
- preference recall
- project continuity

Cloud access should not be required for core memory features.

## MVP Scope

MVP memory should include:

- local episodic storage
- basic embedding generation
- local vector retrieval
- user-deletable memory items
- compressed recall for chat and routing

MVP does not need:

- full life-logging
- complex relationship graphs
- heavy cross-device sync
- automatic storage of every interaction

## Integration With Routing

Memory is not a standalone subsystem. The router should decide:

- whether memory is needed
- which memory classes are eligible
- how many items may be injected
- whether recalled items can leave the device

This ensures memory improves response quality without undermining latency, privacy, or token efficiency.
