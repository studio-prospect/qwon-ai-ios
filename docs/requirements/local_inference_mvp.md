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

On device, `PREXUSLlamaBridge` applies the GGUF chat template via `llama_chat_apply_template` before tokenization. Raw runtime routing prompts are not fed directly into the model. The system prompt includes the device-local calendar date.

## Known limitations (P1-1 scope)

| Topic | Expectation |
| --- | --- |
| Proof target | llama.cpp loads GGUF on A17 Pro-class hardware and returns coherent text |
| Model class | Default `Qwen2.5-0.5B-Instruct` Q4_K_M (~400MB) — demo-grade, not encyclopedic |
| Factual QA | Historical/scientific facts may hallucinate; system prompt tells the model to say "I don't know" when unsure |
| Date questions | Grounded via injected local date in the system prompt |
| Production accuracy | Requires larger local models, retrieval (P1-2+), or cloud escalation — out of P1-1 scope |

## Cancellation and single-flight

- `LocalModelGenerationCoordinator` serializes overlapping `generate` calls.
- `ChatViewModel` task cancellation propagates through `withTaskCancellationHandler` into `PREXUSLlamaCancellationToken`.
- A new send cancels the prior local decode loop without breaking routing/diagnostics.

## Asset policy

- No large GGUF files in git.
- See `models/README.md` and `tools/scripts/fetch_local_model.sh`.

## Xcode project generation

The committed `app/ios/PREXUS.xcodeproj` is generated **without** `llama.xcframework` so reviewers can run `PREXUSTests` on a clean checkout. After `./tools/scripts/build_llama_xcframework.sh`, run `ruby tools/scripts/generate_xcodeproj.rb` again to link the framework for on-device builds.

LiteRT-LM eval is **not** in the default generated project. To build the isolated eval app only:

```bash
./tools/scripts/vendor_litert_lm.sh
PREXUS_LITERT_LM_EVAL=1 ruby tools/scripts/generate_xcodeproj.rb
```

See `docs/research/litert_lm_evaluation_plan.md`. This does not change the production `AppLocalModelFactory` path.

**P1-4b debug prototype** (optional, off by default): link LiteRT-LM into PREXUS for A17 Pro+ comparison only:

```bash
./tools/scripts/vendor_litert_lm.sh
PREXUS_LITERT_LM_PROTOTYPE=1 ruby tools/scripts/generate_xcodeproj.rb
```

Device comparison: `./tools/scripts/compare_local_backends_on_device.sh "Wang"`. Production automatic routing stays Qwen + llama.cpp unless the Debug Settings toggle is enabled.

## Related docs

- `docs/design/device_install_and_screenshot_workflow.md`
- `docs/product/phase1_remaining_tasks_design_memo.md`
- `docs/research/local_llm_notes.md`
- `docs/research/gemma4_e2b_evaluation_plan.md` (evaluation candidate #1; not default)
- `docs/research/litert_lm_evaluation_plan.md` (P1-4 feasibility lane; not production path)
- `docs/research/litert_lm_adoption_decision.md` (post-feasibility adoption conditions and P1-4b prototype scope)
