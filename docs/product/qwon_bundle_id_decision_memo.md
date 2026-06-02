# QWON Bundle ID — Decision Memo

**Status:** Approved for **repo Phase 2** (scripts + Xcode project generation). ASC app record and provisioning profile names are **operator-filled** after Apple gate.
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

## Apple gate (operator — before Phase 3 upload)

| Step | Status | Notes |
| --- | --- | --- |
| Register App ID `jp.studio-prospect.qwon.ios` | _pending_ | Apple Developer → Identifiers |
| Development provisioning profile | _pending_ | e.g. `DevelopmentQWON_YYYYMMDD` (name TBD) |
| App Store / Distribution provisioning profile | _pending_ | e.g. `AppStoreQWON_YYYYMMDD` (name TBD) |
| New ASC app record (QWON) | _pending_ | **Do not** reuse PREXUS ASC app (`6775110218`) |
| ASC Apple ID for QWON app | _pending_ | Record here when issued |
| Distribution archive validates for QWON bundle | _pending_ | Phase 3 gate |

**Historical PREXUS:** `jp.studio-prospect.prexus.ios` remains on its existing ASC record; uploaded builds are **not** migrated in place.

---

## Repo Phase 2 scope (this memo)

| In scope | Out of scope |
| --- | --- |
| `generate_xcodeproj.rb` + shell `BUNDLE_ID` defaults | TestFlight upload / git tag (Phase 3) |
| Regenerated `project.pbxproj` bundle identifiers | Target rename `PREXUS` → `QWON` (Phase 4) |
| Non-historical dev docs (this memo, migration plan, models README eval bundle) | [Qwen alpha docs](./qwen_text_only_alpha_docs_index.md) — PREXUS-era |
| | [bundle_id_decision_memo.md](./bundle_id_decision_memo.md) rows |

---

## Sign-off (repo)

- [x] Bundle ID string approved: `jp.studio-prospect.qwon.ios`
- [ ] Apple gate steps complete (operator)
- [ ] Phase 3 upload authorized (separate PR)
