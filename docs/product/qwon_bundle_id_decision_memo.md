# QWON Bundle ID — Decision Memo

**Status:** **Distribution archive validated** (2026-06-02). TestFlight upload remains **pending** ([Phase 3 prep](./qwon_text_alpha_testflight_prep.md)).
**Purpose:** Canonical Bundle IDs for **QWON** (`jp.studio-prospect.qwon.ios`). Does **not** replace [PREXUS bundle memo](./bundle_id_decision_memo.md) (historical alpha on `jp.studio-prospect.prexus.ios`).
**Migration plan:** [qwon_rename_migration_plan.md](./qwon_rename_migration_plan.md)

---

## Approved identifiers (QWON app line)

| Field | Value |
| --- | --- |
| Main app | `jp.studio-prospect.qwon.ios` |
| Unit tests | `jp.studio-prospect.qwon.ios.tests` |
| UI tests | `jp.studio-prospect.qwon.ios.uitests` |
| LiteRT eval app (optional target) | `jp.studio-prospect.qwon.ios.literteval` |
| Keychain service (API keys) | `com.prexus.api-keys` (**unchanged** — independent of Bundle ID) |

Set in `tools/scripts/generate_xcodeproj.rb` and device scripts after Phase 2 merge. Regenerate `app/ios/PREXUS.xcodeproj` with `ruby tools/scripts/generate_xcodeproj.rb` (no-llama checkout policy unchanged).

---

## ASC app record (QWON)

| Field | Value |
| --- | --- |
| ASC app name | **QWON** (display; confirm in ASC UI) |
| ASC Apple ID | `6775685841` |
| Bundle ID | `jp.studio-prospect.qwon.ios` |
| Primary category | ユーティリティ |
| Secondary category | 仕事効率化 |
| Historical PREXUS ASC Apple ID | `6775110218` — **do not** upload QWON builds there |

---

## Apple gate (operator — before Phase 3 upload)

| Step | Status | Notes |
| --- | --- | --- |
| Register App ID `jp.studio-prospect.qwon.ios` | **Done** (2026-06-02) | Apple Developer → Identifiers |
| Development provisioning profile | **Done** (2026-06-02) | `DevelopmentQWON_20260602` — expires **2026-10-07** |
| App Store / Distribution provisioning profile | **Done** (2026-06-02) | `AppStoreQWON_20260602` — expires **2026-10-07** |
| New ASC app record (QWON) | **Done** (2026-06-02) | Apple ID `6775685841` — **not** PREXUS (`6775110218`) |
| ASC Apple ID for QWON app | **Done** | `6775685841` |
| Distribution archive validates for QWON bundle | **Done** (2026-06-02) | [Validation record](./qwon_text_alpha_testflight_prep.md#distribution-archive-validation-2026-06-02) — export succeeded; **upload not executed** |

**Historical PREXUS:** `jp.studio-prospect.prexus.ios` remains on its existing ASC record; uploaded builds are **not** migrated in place.

---

## Repo Phase 2 scope (this memo)

| In scope | Out of scope |
| --- | --- |
| `generate_xcodeproj.rb` + shell `BUNDLE_ID` defaults | TestFlight upload / git tag — [Phase 3 prep](./qwon_text_alpha_testflight_prep.md) |
| Regenerated `project.pbxproj` bundle identifiers | Target rename `PREXUS` → `QWON` (Phase 4) |
| Non-historical dev docs (this memo, migration plan, models README eval bundle) | [Qwen alpha docs](./qwen_text_only_alpha_docs_index.md) — PREXUS-era |
| | [bundle_id_decision_memo.md](./bundle_id_decision_memo.md) rows |

---

## Sign-off (repo + operator)

- [x] Bundle ID string approved: `jp.studio-prospect.qwon.ios`
- [x] Apple gate: App ID, ASC app `6775685841`, profiles `DevelopmentQWON_20260602` / `AppStoreQWON_20260602` (expiry 2026-10-07)
- [x] Distribution archive validation for QWON bundle (2026-06-02 — archive + export on `d4f2a0b`)
- [ ] Phase 3 TestFlight upload (IPA exported locally; not uploaded to ASC `6775685841`)
