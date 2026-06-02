# Context Compression MVP (P1-2)

## Scope

Compression v0 replaces suffix-only transcript joining with structured, budgeted context blocks before local/cloud execution.

## Behavior

`StructuredContextCompressor`:

1. Normalizes and drops empty messages
2. Deduplicates identical role+content lines (including repeated system lines)
3. Keeps a recency window (default 12 messages)
4. Formats role-labeled blocks (`System:`, `User:`, `Assistant:`)
5. Enforces a hard estimated-token budget (newest messages win)

## Integration

- `RuntimeTurnExecutor` passes `maxCloudContextTokens / 2` as the compression budget
- Cloud execution metadata includes compression metrics (estimated tokens, message counts)
- P1-3 will add model-assisted summarization when local inference is available

## Tests

See `QWONTests` compression cases comparing structured output vs legacy suffix-4 baseline.
