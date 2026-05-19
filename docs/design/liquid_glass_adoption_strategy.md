# Liquid Glass Adoption Strategy

## Purpose

Define where PREXUS uses Liquid Glass and where it does not.

PREXUS is runtime-first. Glass is for **control surfaces**, not conversation content.

## Adopt

- Chat header
- Chat composer surface
- Route / runtime status chips and compact strips

## Do Not Adopt (yet)

- Message bubble full redesign
- Diagnostics / Memory / Settings surfaces
- Decorative motion or heavy custom shaders

## Implementation Rules

1. Prefer system SwiftUI (`glassEffect` on iOS 26+, Materials on earlier releases).
2. Respect `accessibilityReduceTransparency` with opaque grouped fills.
3. Preserve narrow-width layouts via `ViewThatFits` on chip rows.
4. Keep accessibility identifiers and test contracts stable.

## Verification

```bash
ruby tools/scripts/generate_xcodeproj.rb
xcodebuild -project app/ios/PREXUS.xcodeproj -scheme PREXUS \
  -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.4' test
```
