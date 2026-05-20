# Local Inference MVP (P1-1)

## Decision record (Codex)

| Topic | Decision |
| --- | --- |
| Backend | **llama.cpp** (production path on iOS) |
| MLX | Research only; not in runtime shipping path |
| Device class | **A17 Pro generation and newer** (iPhone 15 Pro / 16 / 17 families) |
| Merge order | **P1-1 before compression/OCR** |
| OCR | Stays in Phase 1 but **after** P1-1/P1-2/P1-3 |

## Architecture

```
AppEnvironment
  └─ AppLocalModelFactory
        └─ FallbackLocalModelClient
              ├─ primary: LlamaCppLocalModelClient (app/ios)
              │     └─ LlamaCppInferenceEngine → PREXUSLlamaBridge (ObjC++)
              └─ fallback: EmbeddedHeuristicLocalModelClient (runtime/)
```

Simulator continues to use `SimulatorMockLocalModelClient` via `AppLocalModelFactory`.

On device, `PREXUSLlamaBridge` applies the GGUF chat template (SmolLM2 ChatML) via `llama_chat_apply_template` before tokenization. Raw runtime routing prompts are not fed directly into the model.

## Cancellation and single-flight

- `LocalModelGenerationCoordinator` serializes overlapping `generate` calls.
- `ChatViewModel` task cancellation propagates through `withTaskCancellationHandler` into `PREXUSLlamaCancellationToken`.
- A new send cancels the prior local decode loop without breaking routing/diagnostics.

## Asset policy

- No large GGUF files in git.
- See `models/README.md` and `tools/scripts/fetch_local_model.sh`.

## Related docs

- `docs/design/device_install_and_screenshot_workflow.md`
- `docs/product/phase1_remaining_tasks_design_memo.md`
- `docs/research/local_llm_notes.md`
