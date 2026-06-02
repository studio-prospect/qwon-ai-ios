# QWON Rename Migration Plan

**Last updated:** 2026-06-02
**Status:** **Phase 3 build `1` complete**; **active TestFlight `0.1.0 (2)`** (keyboard fix, 2026-06-02) — [prep doc](./qwon_text_alpha_testflight_prep.md). Phase 4 **deferred**.
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

## Apple gate (operator — before Phase 3 upload)

**Repo status:** **QWON text alpha `0.1.0 (1)` on TestFlight** — upload, lab, tag complete (2026-06-02). See [QWON prep](./qwon_text_alpha_testflight_prep.md).

**Critical:** If an App Store Connect app record already has **uploaded builds**, the **Bundle ID cannot be changed** on that record. The historical PREXUS alpha (`jp.studio-prospect.prexus.ios`) therefore stays as-is in ASC and docs.

QWON ships as a **new** identifier and app record, not an in-place Bundle ID edit.

| Step | Owner | Status (2026-06-02) |
| --- | --- | --- |
| 1 | Product / release engineering | **Done** — App ID / Bundle ID `jp.studio-prospect.qwon.ios` |
| 2 | Release engineering | **Done** — `DevelopmentQWON_20260602`, `AppStoreQWON_20260602` (expiry **2026-10-07**) |
| 3 | Release engineering | **Done** — new ASC app **QWON** (not PREXUS record) |
| 4 | Release engineering | **Done** — ASC Apple ID **`6775685841`** (PREXUS remains `6775110218`) |
| 5 | Release engineering | **Done** (2026-06-02) — upload, lab, tag `qwon-text-alpha-0.1.0-rc1` |

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

**Status:** **Merged** (#47) — user-facing rename on `main`.

- Display strings, marketing copy, `https://qwon.ai` as canonical website.
- **Scope PR explicitly** — no Bundle ID change in the same PR unless Phase 2 is approved and gates are done.
- Historical PREXUS strings in [Qwen text-only alpha](./qwen_text_only_alpha_docs_index.md) docs, frozen ledger, and TestFlight upload history **unchanged** (audit trail).
- `CFBundleDisplayName` = **QWON** on `main`.

### Phase 2: Bundle ID / signing / scripts / Xcode project generation

**Status:** **Merged** (#48) — scripts + [QWON bundle memo](./qwon_bundle_id_decision_memo.md) + regenerated `project.pbxproj`.

- Update `tools/scripts/generate_xcodeproj.rb` and related scripts to `jp.studio-prospect.qwon.ios`.
- Regenerate Xcode project (`ruby tools/scripts/generate_xcodeproj.rb` on no-llama checkout).
- Test bundle IDs: `jp.studio-prospect.qwon.ios.tests`, `.uitests`, `.literteval` — see [QWON bundle memo](./qwon_bundle_id_decision_memo.md).
- **No** TestFlight upload or git tag in Phase 2 PR.

### Phase 3: TestFlight rebuild under QWON bundle

**Status:** **Complete** for build `1` (2026-06-02) — [prep doc](./qwon_text_alpha_testflight_prep.md).

**Delivered:** Archive/export/upload to ASC `6775685841`; Wang/Matisse lab build `1`; tag `qwon-text-alpha-0.1.0-rc1` on `d4f2a0b`. **Follow-up:** build `2` UX fix (#56) on TestFlight — see [build 2](./qwon_text_alpha_testflight_prep.md#testflight-build-2-2026-06-02).

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
| QWON bundle IDs (current repo) | [qwon_bundle_id_decision_memo.md](./qwon_bundle_id_decision_memo.md) |
| QWON TestFlight prep | [qwon_text_alpha_testflight_prep.md](./qwon_text_alpha_testflight_prep.md) |
| QWON execution | Phase 3 build `1` **complete** — Phase 4 optional |

**Future release and rename implementation** start from this plan, not from ad hoc global find-replace.
