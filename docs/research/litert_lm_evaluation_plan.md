# LiteRT-LM Evaluation Plan

## Purpose

This document defines the PREXUS evaluation lane for LiteRT-LM / Google AI Edge after the Gemma-4-E2B-it GGUF evaluation showed that Gemma can load through the current llama.cpp path but does not produce usable output.

LiteRT-LM is an evaluation candidate only. It is not the PREXUS production runtime, and it must not replace the current Qwen2.5-0.5B-Instruct Q4_K_M MVP default without a later adoption decision.

## Current Decision

| Area | Decision |
| --- | --- |
| Production local runtime | Keep the existing llama.cpp path |
| Production local model | Keep Qwen2.5-0.5B-Instruct Q4_K_M as `prexus-local-mvp.gguf` |
| LiteRT-LM role | Backend feasibility evaluation candidate |
| First target | iOS Swift API + Metal path |
| Model target | Gemma 4 E2B / E4B `.litertlm` artifacts if available and distributable |
| Implementation owner | Cursor |
| Planning / review owner | Codex |

## Why Evaluate LiteRT-LM

Official Google AI Edge docs position LiteRT as Google's on-device framework for high-performance ML and GenAI deployment across Android, iOS, web, desktop, and edge devices. The LiteRT GenAI docs describe LiteRT-LM as the orchestration layer for LLM-specific concerns such as session cloning, KV-cache management, prompt caching, and stateful inference.

Official LiteRT-LM docs now expose a Swift API for iOS and macOS with Metal GPU acceleration. The LiteRT-LM repository lists Swift as Early Preview as of v0.12.0, so this path is promising but still requires PREXUS-specific validation before any architecture shift.

Google's May 19, 2026 LiteRT-LM announcement reports Gemma 4 E2B decode performance on iPhone 17 Pro through the iOS Metal path, plus session management, constrained decoding, tool-use, and multimodal support. These claims map well to PREXUS' long-term needs, but they do not prove that LiteRT-LM is a better default for the current MVP.

Sources:

- LiteRT overview: https://ai.google.dev/edge/litert/overview
- LiteRT GenAI deployment overview: https://ai.google.dev/edge/litert/genai/overview
- LiteRT-LM Swift API: https://ai.google.dev/edge/litert-lm/swift
- LiteRT-LM GitHub repository: https://github.com/google-ai-edge/LiteRT-LM
- Google Developers Blog: https://developers.googleblog.com/blazing-fast-on-device-genai-with-litert-lm/

## Non-Goals

- Do not replace `LocalGGUFModelPlacement`.
- Do not switch `prexus-local-mvp.gguf` away from Qwen.
- Do not replace the P1-1 llama.cpp production backend.
- Do not add large model files or generated LiteRT artifacts to git.
- Do not redesign routing, memory, or chat UI as part of this evaluation.
- Do not introduce multimodal runtime work in the first LiteRT-LM slice.
- Do not require Google AI Edge Gallery behavior as a product dependency.

## Evaluation Questions

1. Can PREXUS integrate LiteRT-LM's Swift package in an isolated iOS spike without destabilizing the committed Xcode project?
2. Can an iPhone target load a `.litertlm` model artifact from app Documents or another reviewable non-git model location?
3. Does the iOS Swift API work with Metal on a supported device in a way that can be measured from PREXUS?
4. Does Gemma 4 E2B or E4B produce coherent Japanese short-form answers where the GGUF llama.cpp path failed?
5. Can LiteRT-LM produce deterministic compact JSON for routing/control-plane prompts?
6. What are the cold load, first-token, decode throughput, memory, thermal, and package-size costs?
7. What are the model license, artifact distribution, App Store, and binary-size implications?
8. What runtime abstraction would be required if LiteRT-LM later becomes a second backend?

## Required Measurements

Any implementation PR must include concrete test-plan results for:

- LiteRT-LM version or commit
- Swift package version
- model artifact name, source, quantization, and file size
- device model and OS version
- backend used (`.gpu` / Metal or `.cpu`)
- cold load time
- first-token latency
- decode tokens/sec on at least one short and one medium prompt
- peak memory or best available proxy
- thermal / battery observation for a bounded session
- Japanese short-answer transcript
- routing JSON transcript
- failure mode if a step cannot run

## Acceptance Criteria

### Successful feasibility result

- LiteRT-LM can be integrated in an isolated spike or sample path without changing the production local backend.
- A `.litertlm` model can be loaded on an iPhone target.
- At least one Japanese answer and one routing JSON response are coherent enough to justify deeper evaluation.
- Performance and memory numbers are captured and compared against the existing Qwen MVP baseline and Gemma GGUF evaluation.
- The PR keeps generated artifacts and large model files out of git.

### Valid blocked result

A blocked result is acceptable if the PR documents the blocker precisely. Valid blocker categories:

- Swift package or binary integration issue
- iOS deployment target mismatch
- Metal backend unavailable or unstable
- `.litertlm` model artifact unavailable or not distributable
- model license or redistribution constraint
- memory, thermal, or startup cost too high for PREXUS MVP
- output quality still unusable for Japanese or routing JSON

## Cursor Task

### Title

`P1-4: Evaluate LiteRT-LM backend feasibility`

### Instructions

1. Keep the current Qwen + llama.cpp MVP path untouched.
2. Start with an isolated integration plan or spike, not a production runtime rewrite.
3. Prefer a separate sample target, local script, or compile-gated path if code is needed.
4. Do not commit model artifacts, `.litertlm` files, DerivedData, screenshots, or generated local logs.
5. If iOS project files change, regenerate the Xcode project with `ruby tools/scripts/generate_xcodeproj.rb`.
6. Record exact test-plan results in the PR body using the repository PR template.

## Codex Review Gate

Codex should reject the PR if it:

- changes the default local model away from Qwen,
- replaces the production llama.cpp backend,
- commits model binaries or generated local artifacts,
- introduces broad runtime abstractions before feasibility is proven,
- omits test-plan results for the actual device/backend path attempted.

Merge readiness is based on evidence quality, not adoption. The desired outcome is a reliable decision record: continue LiteRT-LM, block it with evidence, or scope a deeper backend prototype.
