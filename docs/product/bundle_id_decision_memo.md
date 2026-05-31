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

Apple expects Bundle IDs to follow **reverse-DNS** under a domain the team controls (`com.<registrant>.<product>`).

| Question | Status | Gate |
| --- | --- | --- |
| Primary marketing / legal domain for PREXUS (e.g. `prexus.com`, `prexus.app`, studio domain) | **studio-prospect** (via `jp.studio-prospect.prexus.ios`) | Recorded in approved Bundle ID |
| Apple Developer Program legal entity matches domain registrant (or documented subsidiary relationship) | Confirm with owner | Required for long-lived ASC app |
| Trademark / app name “PREXUS” vs bundle string | Align in ASC app name separately | Not blocking ID format choice |

Until the domain gate closes, treat all candidates below as **provisional**.

---

## Formal Bundle ID candidates

| ID | Style | Pros | Cons |
| --- | --- | --- | --- |
| `com.prexus.ios` | Reverse-DNS (current placeholder) | Already wired in repo; zero migration for dev | Suffix `ios` is platform hint, not product; reads as internal/sketch ID; weak if domain is not `prexus.com` |
| `app.prexus.ios` | Host-style segment order | Memorable string | **Not** standard reverse-DNS; Apple/Developer convention is `com.*` first; easy ASC/provisioning confusion; **not recommended** |
| `com.prexus.app` | Reverse-DNS | Matches usual `com.<brand>.<product>` pattern; stable for TestFlight and future App Store; clear upgrade from placeholder | Requires `prexus.*` (or agreed registrant domain) ownership confirmation |
| `com.<studio>.prexus` | Reverse-DNS under studio domain | Fits monorepo org (e.g. if product ships under studio legal entity) | Ties brand to studio domain; marketing may prefer `com.prexus.*` later |

**Not proposed:** bare `prexus.ios` (invalid format), random suffixes per engineer, or per-alpha IDs (TestFlight should reuse one main app ID).

---

## Recommendation

**Primary recommendation:** `com.prexus.app`

**Reasoning:**

1. Follows Apple’s reverse-DNS convention (`com` → registrant → product).
2. Avoids platform suffix (`ios`) in the bundle string while remaining obviously the main PREXUS iOS app in ASC.
3. Safer long-term than `app.prexus.ios`, which inverts segment order and does not match typical Team ID / provisioning documentation.
4. Cleaner public identity than keeping the dev placeholder `com.prexus.ios` for TestFlight.

**Conditions before adopting:**

- [ ] Domain gate closed: document which FQDN the team owns and will use for ASC / privacy policy URLs.
- [ ] Product owner explicitly approves `com.prexus.app` (or records an alternate from the table with rationale).
- [ ] No conflicting existing ASC app or enterprise profile already using the chosen ID.

**If domain is not `prexus.*`:** prefer `com.<owned-domain-registrant>.prexus` (e.g. studio domain) and record the choice in this memo’s sign-off section.

**Fallback for alpha-only impatience:** keep `com.prexus.ios` only if legal/product accepts a non-marketing internal ID for TestFlight — still requires explicit sign-off; not the default recommendation.

---

## Impact when the ID changes

Apply in a **follow-up implementation PR** after this memo is signed — not in the memo PR itself.

| Area | Files / systems | Notes |
| --- | --- | --- |
| Xcode project generation | `tools/scripts/generate_xcodeproj.rb` | `PRODUCT_BUNDLE_IDENTIFIER` for PREXUS, tests, UI tests; regenerate `project.pbxproj` |
| Device install / smoke | `tools/scripts/install_on_device.sh`, `alpha_smoke_wang.sh`, `push_local_model_to_device.sh`, `eval_strict_json_on_device.sh`, `compare_local_backends_on_device.sh`, `fetch_device_eval_log.sh`, `eval_gemma4_on_device.sh` | `BUNDLE_ID` and `--console` / log domain identifiers |
| LiteRT eval (prototype) | `com.prexus.ios.literteval` scripts + docs | Consider `com.prexus.app.literteval` or keep eval suffix pattern consistent with main ID |
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
| ASC app name (display) | `PREXUS` |
| Apple ID | `6775110218` |
| SKU | `jp.studio-prospect.prexus.ios` |
| Owned domain / registrant | `studio-prospect` (Japan reverse-DNS prefix `jp`) |
| Repo migration PR | `chore/alpha-bundle-id-migration` |
| Approved by / date | Product ops (2026-05) |

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
- [ ] Provisioning profile updates for all engineers (manual Developer portal)
- [ ] Distribution signing validation / Release archive
- [ ] Git release tag (`qwen-text-alpha-*`)
- [ ] TestFlight upload

---

## Closing section G

[TestFlight prep](./qwen_text_only_alpha_testflight_prep.md) section G is **fully closed** when:

1. Sign-off table is filled (**done**), **and**
2. Repo + scripts use `jp.studio-prospect.prexus.ios` (**done** after migration PR), **and**
3. Distribution signing + Release archive validate for that ID (**open**).

Until (3), alpha remains **not upload-ready** for TestFlight upload regardless of simulator or Debug device smoke.
