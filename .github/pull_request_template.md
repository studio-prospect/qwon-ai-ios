## Summary

<!-- What changed and why -->

## Test plan

- [ ] `ruby tools/scripts/generate_xcodeproj.rb` (if iOS targets, scheme, or compiled sources changed)
- [ ] `xcodebuild -project app/ios/PREXUS.xcodeproj -scheme PREXUS -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' test`

### Results

<!-- Paste commands run, pass/fail counts, and any relevant notes -->

```text

```

### Manual checks (if applicable)

- [ ] Chat route preview and execution banners still behave as expected
- [ ] Settings > Stored Episodes and Recent Runtime Decisions still load

## Review notes

<!-- Optional: known follow-ups, deferred items, or risks for Codex review -->
