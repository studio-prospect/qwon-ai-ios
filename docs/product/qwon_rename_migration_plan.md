# QWON Rename Migration Plan

**Last updated:** 2026-06-02
**Status:** **Phase 1–2 merged** (#47, #48). **TestFlight upload complete** (2026-06-02, ASC `6775685841`). **Internal group / device installs / tag** pending — [prep doc](./qwon_text_alpha_testflight_prep.md).
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

**Repo status:** Phases **1–2** merged. **TestFlight upload** to QWON ASC **`6775685841`** succeeded (2026-06-02). Internal group, lab installs, and git tag remain pending.

**Critical:** If an App Store Connect app record already has **uploaded builds**, the **Bundle ID cannot be changed** on that record. The historical PREXUS alpha (`jp.studio-prospect.prexus.ios`) therefore stays as-is in ASC and docs.

QWON ships as a **new** identifier and app record, not an in-place Bundle ID edit.

| Step | Owner | Status (2026-06-02) |
| --- | --- | --- |
| 1 | Product / release engineering | **Done** — App ID / Bundle ID `jp.studio-prospect.qwon.ios` |
| 2 | Release engineering | **Done** — `DevelopmentQWON_20260602`, `AppStoreQWON_20260602` (expiry **2026-10-07**) |
| 3 | Release engineering | **Done** — new ASC app **QWON** (not PREXUS record) |
| 4 | Release engineering | **Done** — ASC Apple ID **`6775685841`** (PREXUS remains `6775110218`) |
| 5 | Release engineering | **Upload done** (2026-06-02) — internal group, installs, tag _pending_ |

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

**Status:** **TestFlight uploaded** (2026-06-02) — [prep doc](./qwon_text_alpha_testflight_prep.md). Internal group / Wang+Matisse install / tag **not complete**.

**Prerequisites met:** Apple gate; Distribution archive + export; Wang Debug smoke; upload to QWON ASC `6775685841`.

- Archive and upload to the **new** ASC app record (operator).
- Git tag lineage: `qwon-text-alpha-0.1.0-rc1` proposed for first build (see prep doc).
- Ops evidence: `~/QWON-alpha-evidence/qwon-text-0.1.0-build1/` — do not rewrite PREXUS build `1` artifacts.
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
| QWON bundle IDs (current repo) | [qwon_bundle_id_decision_memo.md](./qwon_bundle_id_decision_memo.md) |
| QWON TestFlight prep | [qwon_text_alpha_testflight_prep.md](./qwon_text_alpha_testflight_prep.md) |
| QWON execution | Internal group + lab installs + tag (post-upload) |

**Future release and rename implementation** start from this plan, not from ad hoc global find-replace.
