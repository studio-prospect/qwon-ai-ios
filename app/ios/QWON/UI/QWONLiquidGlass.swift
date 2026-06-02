import SwiftUI

enum QWONControlGlassShape {
    case roundedRect(cornerRadius: CGFloat)
    case capsule
}

private struct QWONControlGlassModifier: ViewModifier {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    let shape: QWONControlGlassShape
    let fallbackMaterial: Material

    func body(content: Content) -> some View {
        content
            .background {
                glassBackground
            }
    }

    @ViewBuilder
    private var glassBackground: some View {
        switch shape {
        case let .roundedRect(cornerRadius):
            if reduceTransparency {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(Color(uiColor: .separator), lineWidth: 0.5)
                    )
            } else if #available(iOS 26.0, *) {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(.clear)
                    .glassEffect(in: .rect(cornerRadius: cornerRadius))
            } else {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(fallbackMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                            .strokeBorder(.quaternary.opacity(0.55), lineWidth: 0.5)
                    )
            }
        case .capsule:
            if reduceTransparency {
                Capsule(style: .continuous)
                    .fill(Color(uiColor: .secondarySystemFill))
            } else if #available(iOS 26.0, *) {
                Capsule(style: .continuous)
                    .fill(.clear)
                    .glassEffect(in: .capsule)
            } else {
                Capsule(style: .continuous)
                    .fill(fallbackMaterial)
            }
        }
    }
}

extension View {
    func prexusControlGlass(
        shape: QWONControlGlassShape = .roundedRect(cornerRadius: 18),
        fallbackMaterial: Material = .thinMaterial
    ) -> some View {
        modifier(
            QWONControlGlassModifier(
                shape: shape,
                fallbackMaterial: fallbackMaterial
            )
        )
    }
}

struct QWONControlGlassBar<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .prexusControlGlass(shape: .roundedRect(cornerRadius: 0), fallbackMaterial: .bar)
    }
}

struct QWONRuntimeStrip<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        content()
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .prexusControlGlass(shape: .roundedRect(cornerRadius: 16), fallbackMaterial: .ultraThinMaterial)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
    }
}
