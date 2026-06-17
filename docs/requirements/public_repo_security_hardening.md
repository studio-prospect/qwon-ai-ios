# QWON Public Repository Security Hardening

**Status:** Working note - public-repo hygiene and pre-release security follow-up.
**Last updated:** 2026-06-17

## Scope

This note records security hygiene items that matter because `studio-prospect/qwon-ai-ios` is public. It does not approve App Store release, Build `4`, model hosting rollout, or new implementation lanes.

## Current hardening

| Area | Current posture |
| --- | --- |
| API keys | Runtime provider keys are stored through Keychain, not committed config. |
| Local env | `.env` and `.env.*` are ignored. |
| Model binaries | `.gguf`, `.litertlm`, eval model directories, and generated vendor artifacts are ignored. |
| Xcode build outputs | `DerivedData/`, `.derivedData*/`, `*.xcresult`, user data, and build outputs are ignored. |
| Signing team | Device scripts require `DEVELOPMENT_TEAM`; real Apple Developer Team IDs stay out of git. |
| M3 hosted object identity | Concrete bucket identity stays in ops evidence outside git; public docs retain only endpoint class, object path class, byte size, and SHA-256 where needed for reproducible verification. |

## Public-repo rules

- Do not commit `.env`, provisioning profiles, certificates, p12 files, private keys, API keys, device logs, `.xcresult`, DerivedData, GGUF, LiteRT-LM artifacts, IPA/archive outputs, screenshots, or raw ops manifests.
- Keep concrete Apple Developer Team IDs in local shell environment, local export option plists, or ops evidence, not tracked scripts or docs.
- Keep concrete object storage bucket/account identifiers in ops evidence. Public docs may reference approved HTTPS endpoints only when Product/Legal/Release Engineering intentionally treat them as public development endpoints.
- Run a secret scanner such as `gitleaks` or `trufflehog` before public-release PRs when available; regex-only scans are a fallback, not a substitute.

## Pre-release follow-ups

| Item | Risk | Required before public release |
| --- | --- | --- |
| Runtime diagnostics storage | `RuntimeDiagnosticsStore` persists recent `userText` values in `UserDefaults`. | Minimize or redact stored text, or move diagnostics into protected local storage with an explicit retention policy. |
| Episodic memory storage | `PersistentMemoryStore` stores memory summaries in `UserDefaults`. | Confirm summaries are compact/non-secret, add stronger storage protection if retained after alpha, and keep delete/clear controls visible. |
| Model endpoint exposure | `models.qwon.dev` development URL is public in code/docs for compile-gated M3 spike verification. | Confirm CDN/object ACL, rate limiting, cost controls, attribution/licensing, and privacy/export implications before enabling any product-facing download build. |
| Historical docs | Some historical records intentionally preserve release evidence. | Keep sensitive identifiers redacted while preserving audit meaning. |
