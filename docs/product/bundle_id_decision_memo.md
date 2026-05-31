# PREXUS Bundle ID — Decision Memo

**Status:** Approved. Repo migration tracked in `chore/alpha-bundle-id-migration` (Xcode + scripts).
**Purpose:** Close [TestFlight prep section G](./qwen_text_only_alpha_testflight_prep.md#g-bundle-id-and-signing-blocking-upload--section-ae-and-smoke-alone-are-insufficient) (Bundle ID + signing gate) for the Qwen text-only alpha.
**Scope:** Distribution signing, archive validation, tag, and TestFlight upload remain separate manual steps.

Related: [qwen_text_only_alpha_testflight_prep.md](./qwen_text_only_alpha_testflight_prep.md)

---

## Approved identifiers (repo)

| Field | Value |
| --- | --- |
| Main app | `jp.studio-prospect.prexus.ios` |
| Unit tests | `jp.studio-prospect.prexus.ios.tests` |
| UI tests | `jp.studio-prospect.prexus.ios.uitests` |
| LiteRT eval app (optional target) | `jp.studio-prospect.prexus.ios.literteval` |
| Keychain service (API keys) | `com.prexus.api-keys` (unchanged; independent of Bundle ID) |

Set in `tools/scripts/generate_xcodeproj.rb` and device scripts after bundle-id migration PR.

### Migration note (previous dev placeholder)

| Field | Previous value |
| --- | --- |
| Main app | `com.prexus.ios` |
| Unit tests | `com.prexus.ios.tests` |
| UI tests | `com.prexus.ios.uitests` |
| LiteRT eval | `com.prexus.ios.literteval` |

Uninstall builds signed with the old ID before device smoke. Keychain data under the old app container does not migrate automatically.

---

## Prerequisite gate: owned domain

Bundle IDs should follow **reverse-DNS** under a domain the team controls (for example, `jp.<registrant>.<product>` for a `.jp` domain).

| Question | Status | Gate |
| --- | --- | --- |
| Primary marketing / legal domain for PREXUS | `prexus.studio-prospect.jp` | Recorded for alpha Bundle ID decision |
| Apple Developer Program legal entity matches domain registrant (or documented subsidiary relationship) | Confirm with owner | Required for long-lived Distribution signing |
| Trademark / app name “PREXUS” vs bundle string | Align in ASC app name separately | Not blocking ID format choice |

The domain gate is closed for the alpha naming decision. Distribution signing still needs to verify that the Apple Developer account can use the selected identifier end to end.

---

## Formal Bundle ID candidates

| ID | Style | Pros | Cons |
| --- | --- | --- | --- |
| `com.prexus.ios` | Reverse-DNS (current placeholder) | Already wired in repo; zero migration for dev | Suffix `ios` is platform hint, not product; reads as internal/sketch ID; weak if domain is not `prexus.com` |
| `app.prexus.ios` | Host-style segment order | Memorable string | **Not** standard reverse-DNS; Apple/Developer convention is `com.*` first; easy ASC/provisioning confusion; **not recommended** |
| `com.prexus.app` | Reverse-DNS | Matches usual `com.<brand>.<product>` pattern; stable for TestFlight and future App Store; clear upgrade from placeholder | Requires `prexus.*` (or agreed registrant domain) ownership confirmation |
| `jp.studio-prospect.prexus.ios` | Reverse-DNS under `studio-prospect.jp` | Matches the recorded marketing/legal domain; clearly scoped to PREXUS iOS; suitable for ASC once signing is configured | Requires migration from dev placeholder across scripts/project generation |
| `com.<studio>.prexus` | Reverse-DNS under studio domain | Fits monorepo org (e.g. if product ships under studio legal entity) | Not aligned with the selected `studio-prospect.jp` domain |

**Not proposed:** bare `prexus.ios` (invalid format), random suffixes per engineer, or per-alpha IDs (TestFlight should reuse one main app ID).

---

## Recommendation

**Approved Bundle ID:** `jp.studio-prospect.prexus.ios`

**Prior recommendation superseded:** `com.prexus.app`

**Reasoning:**

1. Follows reverse-DNS convention for the owned domain `prexus.studio-prospect.jp` (`jp` -> `studio-prospect` -> `prexus`).
2. Keeps the public/legal identity under the studio-controlled domain rather than an unverified `prexus.*` domain.
3. Retains an explicit `ios` suffix for the main iPhone app while leaving room for future platform-specific app identifiers if needed.
4. Replaces the dev placeholder `com.prexus.ios` with a traceable production/TestFlight identity.

**Conditions before adopting:**

- [x] Domain gate closed: `prexus.studio-prospect.jp` is recorded as the primary marketing/legal domain for PREXUS.
- [x] Product owner approves `jp.studio-prospect.prexus.ios` as the Main app Bundle ID for the Qwen text-only alpha.
- [ ] No conflicting existing ASC app or enterprise profile already using the chosen ID.

**If ASC or provisioning rejects the selected ID:** return to this memo and record a replacement under the same owned-domain rule before changing Xcode or scripts.

**Fallback for alpha-only impatience:** keep `com.prexus.ios` only if legal/product accepts a non-marketing internal ID for TestFlight — still requires explicit sign-off; not the default recommendation.

---

## Impact when the ID changes

Apply in a **follow-up implementation PR** after this memo is signed — not in the memo PR itself.

| Area | Files / systems | Notes |
| --- | --- | --- |
| Xcode project generation | `tools/scripts/generate_xcodeproj.rb` | `PRODUCT_BUNDLE_IDENTIFIER` for PREXUS, tests, UI tests; regenerate `project.pbxproj` |
| Device install / smoke | `tools/scripts/install_on_device.sh`, `alpha_smoke_wang.sh`, `push_local_model_to_device.sh`, `eval_strict_json_on_device.sh`, `compare_local_backends_on_device.sh`, `fetch_device_eval_log.sh`, `eval_gemma4_on_device.sh` | `BUNDLE_ID` and `--console` / log domain identifiers |
| LiteRT eval (prototype) | `com.prexus.ios.literteval` scripts + docs | Consider `jp.studio-prospect.prexus.ios.literteval` or keep eval suffix pattern consistent with main ID |
| Workflow docs | `docs/design/device_install_and_screenshot_workflow.md`, research eval docs | Update examples |
| App Store Connect | New or updated app record | Bundle ID immutable after creation — choose correctly once |
| Provisioning | Apple Developer portal | Development + Distribution profiles for new ID; `DEVELOPMENT_TEAM` unchanged but profiles must be recreated |
| TestFlight / release docs | `qwen_text_only_alpha_testflight_prep.md`, `qwen_text_only_alpha_release_readiness.md` | Close section G; record final ID in prep doc or sign-off table below |
| Installed devices | Physical devices | Uninstall old `com.prexus.ios` build before testing new ID (Keychain entries under old app container do not migrate automatically) |
| CI / future automation | Not wired today | Any future upload pipeline must use finalized ID |

---

## Sign-off

| Field | Value |
| --- | --- |
| Approved Bundle ID | `jp.studio-prospect.prexus.ios` |
| Owned domain | `prexus.studio-prospect.jp` |
| ASC app name (display) | `PREXUS` |
| ASC Apple ID | `6775110218` |
| ASC SKU | `jp.studio-prospect.prexus.ios` |
| ASC primary language | English (U.S.) |
| ASC subtitle | `Local-first AI Runtime` |
| ASC categories | Primary: Utilities; Secondary: Productivity |
| Repo migration PR | `chore/alpha-bundle-id-migration` |
| App Store provisioning profile | `AppStorePREXUS_20260531` (expires 2026-10-07) |
| Development provisioning profile | `DevelopmentPREXUS_20260531` (expires 2027-05-31) |
| Approved by / date | Product owner decision, 2026-05-31 |

---

## Steps after decision (execution checklist)

Run only after the sign-off table is complete.

1. **Record** approved ID in team tracker (issue/wiki) and update [TestFlight prep](./qwen_text_only_alpha_testflight_prep.md) section G checklist.
2. **Apple Developer:** register App ID for the new Bundle ID; create Development and Distribution provisioning as needed.
3. **App Store Connect:** create app with **exact** Bundle ID (or confirm existing app matches).
4. **Repo PR:** update `generate_xcodeproj.rb` and scripts; run `ruby tools/scripts/generate_xcodeproj.rb`; commit `project.pbxproj`; update affected docs.
5. **Verify:** Distribution archive succeeds; `alpha_smoke_wang.sh` (or install script) against new ID on one device.
6. **TestFlight:** follow [upload outline](./qwen_text_only_alpha_testflight_prep.md#testflight-upload-outline-not-executed-here) (version bump, smoke, tag, upload).

---

## Explicitly not executed in bundle-id migration PR

- [x] Final Bundle ID in `generate_xcodeproj.rb`, device scripts, and regenerated `project.pbxproj`
- [x] ASC app record documented (created outside repo)
- [x] Provisioning profiles registered locally: `AppStorePREXUS_20260531`, `DevelopmentPREXUS_20260531`
- [x] Distribution signing validation / Release archive (2026-05-31; [record](./qwen_text_only_alpha_testflight_prep.md#distribution-archive-validation-2026-05-31))
- [ ] Git release tag (`qwen-text-alpha-*`)
- [ ] TestFlight upload

---

## Closing section G

[TestFlight prep](./qwen_text_only_alpha_testflight_prep.md) section G is **fully closed** when:

1. Sign-off table is filled (**done**), **and**
2. Repo + scripts use `jp.studio-prospect.prexus.ios` (**done** after migration PR), **and**
3. Provisioning profiles are registered for that ID (**done locally**), **and**
4. Distribution signing + Release archive validate for that ID (**done** 2026-05-31).

Upload-ready still requires Wang/device smoke and TestFlight internal group per [TestFlight prep](./qwen_text_only_alpha_testflight_prep.md#sign-off).
