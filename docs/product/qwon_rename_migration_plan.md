# QWON Rename Migration Plan

**Last updated:** 2026-05-31 (docs-first plan on `main`)
**Status:** **Phase 0 — plan only.** No code, signing, ASC, or provisioning changes in this document’s landing PR.
**Audience:** Product, release engineering, Cursor/Codex agents.

**Purpose:** Migrate the product from **PREXUS** to **QWON** without a blind mass-replace. Fix impact scope, execution order, and Apple-side gates before implementation PRs.

---

## Naming decision

| Field | Value | Notes |
| --- | --- | --- |
| **Display name (product)** | **QWON** | User-facing name going forward |
| **Historical product name** | **PREXUS** | Preserved in historical alpha docs, tags, and ops evidence |
| **GitHub repository** | [https://github.com/studio-prospect/qwon-ai-ios](https://github.com/studio-prospect/qwon-ai-ios) | Target repo after migration |
| **Repo name** | `qwon-ai-ios` | Not `PREXUS` |
| **Bundle ID (new app)** | `jp.studio-prospect.qwon.ios` | **New** App ID — not a rename of uploaded bundle |
| **Website** | [https://qwon.ai](https://qwon.ai) | Marketing / product URL |
| **Previous Bundle ID (historical alpha)** | `jp.studio-prospect.prexus.ios` | TestFlight `0.1.0 (1)` alpha under PREXUS naming |

**Competition note:** An existing product used the **PREXUS** name in an AI-related category. **QWON** is the chosen display and repo identity to avoid collision.

---

## Apple gate (must complete before Phase 2+)

**Critical:** If an App Store Connect app record already has **uploaded builds**, the **Bundle ID cannot be changed** on that record. The historical PREXUS alpha (`jp.studio-prospect.prexus.ios`) therefore stays as-is in ASC and docs.

QWON ships as a **new** identifier and app record, not an in-place Bundle ID edit.

| Step | Owner | Action |
| --- | --- | --- |
| 1 | Product / release engineering | Register **App ID** / Bundle ID `jp.studio-prospect.qwon.ios` in Apple Developer |
| 2 | Release engineering | Create **Development** and **App Store** (Distribution) provisioning profiles for `jp.studio-prospect.qwon.ios` |
| 3 | Release engineering | Create a **new ASC app record** for QWON if the old PREXUS bundle already has uploaded builds |
| 4 | Release engineering | Note the **new Apple ID** (ASC app id) issued for the QWON app record — do not assume it matches the PREXUS record |
| 5 | Release engineering | Confirm signing, archive, and TestFlight upload target the **QWON** record only after profiles exist |

**Do not claim** that `jp.studio-prospect.prexus.ios` can be retargeted to QWON after upload. **Do not** upload QWON builds to the PREXUS ASC app without an explicit product decision to retire that line.

---

## Historical PREXUS alpha (preserve)

The following remain **historical** — do not rewrite in place for naming hygiene:

| Artifact | Historical value | Policy |
| --- | --- | --- |
| Product name in docs | PREXUS | [Qwen text-only alpha](./qwen_text_only_alpha_docs_index.md) doc set is **PREXUS-era** |
| Bundle ID | `jp.studio-prospect.prexus.ios` | Frozen in [bundle ID memo](./bundle_id_decision_memo.md) and alpha prep |
| TestFlight build | `0.1.0 (1)`, tag `qwen-text-alpha-0.1.0-rc1` | [Status summary](./qwen_text_only_alpha_status_summary.md) — build `2` **not approved** for PREXUS alpha |
| Ops evidence | `~/PREXUS-alpha-evidence/qwen-text-0.1.0-build1/` | Filenames and ledger rows stay as captured |
| Git tags / commits | `qwen-text-alpha-*` on PREXUS lineage | No forced rename |

**Do not** invent “build 2” semantics for the old PREXUS alpha as part of the QWON rename. QWON TestFlight numbering starts fresh under the new bundle when Phase 3 executes.

---

## Repo migration phases

Execute in order. Each phase is a **separate PR** unless explicitly combined in a written plan update.

### Phase 0: Docs-only rename plan (this document)

- Publish `qwon_rename_migration_plan.md`.
- Add pointers from alpha docs index / status summary.
- **No** app code, scripts, `project.pbxproj`, website, Bundle ID, or provisioning references.

### Phase 1: User-facing product name and website URL

**Status:** Executed in repo via Phase 1 PR (user-facing rename only).

- Display strings, marketing copy, `https://qwon.ai` as canonical website.
- **Scope PR explicitly** — no Bundle ID change in the same PR unless Phase 2 is approved and gates are done.
- Historical PREXUS strings in [Qwen text-only alpha](./qwen_text_only_alpha_docs_index.md) docs, frozen ledger, and TestFlight upload history **unchanged** (audit trail).
- `CFBundleDisplayName` = **QWON** allowed; `PRODUCT_BUNDLE_IDENTIFIER` remains `jp.studio-prospect.prexus.ios` until Phase 2.

### Phase 2: Bundle ID / signing / scripts / Xcode project generation

**Prerequisites:** Apple gate (App ID, profiles, new ASC app record) complete.

- Update `tools/scripts/generate_xcodeproj.rb` and related scripts to `jp.studio-prospect.qwon.ios`.
- Regenerate Xcode project; update `ExportOptions` / signing docs.
- Match test bundle IDs (`*.tests`, `*.uitests`, eval targets) under consistent `jp.studio-prospect.qwon.ios.*` naming in a dedicated decision table PR if needed.
- **No** upload in the same PR unless Phase 3 is explicitly authorized.

### Phase 3: TestFlight rebuild under QWON bundle

**Prerequisites:** Phase 2 merged; Distribution profile validated for `jp.studio-prospect.qwon.ios`.

- Archive and upload to the **new** ASC app record.
- New git tag lineage (e.g. `qwon-text-alpha-*` — exact naming in a follow-up ops doc).
- New ops evidence folder (e.g. under `~/PREXUS-alpha-evidence/` or a new `~/QWON-alpha-evidence/` path — decide in Phase 3 PR, do not rewrite old PNG filenames).
- Wang + Matisse lab policy carries forward unless product changes device policy.

### Phase 4: Optional internal target / module / path rename

**Optional and explicitly scoped.** Default: **defer**.

- Swift module name, Xcode target `PREXUS` → `QWON`, directory renames.
- High churn; only after Phase 3 smoke passes.
- Not required for App Store identity if display name and Bundle ID are correct.

---

## Do-not rules

| Rule | Rationale |
| --- | --- |
| Do **not** mass-replace **PREXUS** in historical alpha evidence, frozen ledger, or closed feedback log baseline rows | Audit trail and TestFlight history |
| Do **not** rename Swift module / Xcode target unless Phase 4 is explicitly approved | Avoid mixed signing + module drift |
| Do **not** change Bundle ID in code without matching App ID, profiles, and ASC app record | Upload failures and signing errors |
| Do **not** treat QWON rename as approval for PREXUS alpha **build `2`** | Separate products/records |
| Do **not** commit PNG/JPEG/log/GGUF/IPA/MANIFEST as part of rename docs | Ops storage only |
| Do **not** rewrite `jp.studio-prospect.prexus.ios` upload history in TestFlight prep upload sections | Historical record |

---

## Where to read next

| Topic | Document |
| --- | --- |
| PREXUS alpha (historical) | [qwen_text_only_alpha_docs_index.md](./qwen_text_only_alpha_docs_index.md) |
| PREXUS bundle decision | [bundle_id_decision_memo.md](./bundle_id_decision_memo.md) |
| QWON execution (future) | This plan — Phase 1+ PRs after Apple gate |

**Future release and rename implementation** start from this plan, not from ad hoc global find-replace.
