import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    private let onOpenSettings: () -> Void

    init(viewModel: ChatViewModel, onOpenSettings: @escaping () -> Void = {}) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onOpenSettings = onOpenSettings
    }

    var body: some View {
        VStack(spacing: 0) {
            header

            if viewModel.isSending, let stateSummary = viewModel.sendStateSummary {
                turnStateBanner(stateSummary)
            } else if let execution = viewModel.latestExecution {
                runtimeStatusBanner(execution)
            }

            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(viewModel.messages.enumerated()), id: \.element.id) { index, message in
                        messageBubble(message)
                            .padding(.bottom, spacingAfterMessage(at: index))
                    }
                }
                .padding()
            }

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                if let route = viewModel.displayedRoute {
                    previewRouteBanner(route)
                }

                composerCard
            }
            .padding()
            .background(.bar)
        }
        .navigationBarBackButtonHidden()
        .accessibilityIdentifier(PREXUSAccessibilityID.Chat.screen)
    }

    @ViewBuilder
    private var sensitivityPicker: some View {
        ViewThatFits(in: .horizontal) {
            sensitivitySegmentedPicker(useCompactLabels: false)

            sensitivitySegmentedPicker(useCompactLabels: true)

            sensitivityMenuPicker
        }
    }

    private var sensitivityMenuPicker: some View {
        Picker("Sensitivity", selection: $viewModel.selectedSensitivity) {
            ForEach(SensitivityLevel.allCases, id: \.self) { level in
                Text(level.displayLabel).tag(level)
            }
        }
        .pickerStyle(.menu)
        .padding(.horizontal, 2)
    }

    private var sensitivityDescription: LocalizedStringKey {
        LocalizedStringKey(viewModel.displayedSensitivity.helperDescription)
    }

    private var composerCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Sensitivity")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                sensitivityPicker

                Text(sensitivityDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            HStack(alignment: .bottom, spacing: 12) {
                TextField("Ask PREXUS", text: $viewModel.draftText, axis: .vertical)
                    .font(.body)
                    .lineLimit(1...6)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.background)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(.quaternary, lineWidth: 1)
                    )
                    .disabled(viewModel.isSending)

                Button {
                    let text = viewModel.draftText.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !text.isEmpty else { return }
                    viewModel.send(text: text)
                } label: {
                    Group {
                        if viewModel.isSending {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                        } else {
                            Text("Send")
                                .fontWeight(.medium)
                        }
                    }
                    .frame(minWidth: 74)
                    .frame(height: 44)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isSending)
            }
        }
        .padding(14)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(.quaternary.opacity(0.6), lineWidth: 1)
        )
        .accessibilityIdentifier(PREXUSAccessibilityID.Chat.composer)
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text("PREXUS")
                    .font(.largeTitle.weight(.semibold))
                    .tracking(-0.8)

                Text("Local-first runtime")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Button(action: onOpenSettings) {
                Image(systemName: "gearshape")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(.blue)
                    .frame(width: 40, height: 40)
                    .background(
                        Circle()
                            .fill(.thinMaterial)
                    )
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Open Settings")
            .accessibilityIdentifier(PREXUSAccessibilityID.Chat.openSettings)
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }

    @ViewBuilder
    private func messageBubble(_ message: ChatMessage) -> some View {
        VStack(alignment: bubbleAlignment(for: message.role), spacing: 4) {
            if message.role == .system {
                Text(message.role.label)
                    .font(.caption)
                    .foregroundStyle(roleLabelStyle(for: message.role))
            }

            Text(message.content)
                .font(font(for: message.role))
                .foregroundStyle(messageTextStyle(for: message.role))
                .textSelection(.enabled)
        }
        .frame(maxWidth: bubbleMaxWidth(for: message.role), alignment: containerAlignment(for: message.role))
        .frame(
            maxWidth: .infinity,
            alignment: containerAlignment(for: message.role)
        )
        .padding(bubblePadding(for: message.role))
        .background(bubbleBackground(for: message.role))
    }

    @ViewBuilder
    private func turnStateBanner(_ summary: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ProgressView()
                    .controlSize(.small)
                    .tint(.blue)

                PREXUSStatusChip("Turn In Progress", tint: .blue)
                PREXUSStatusChip(viewModel.displayedSensitivity.compactDisplayLabel, tint: .secondary)
            }

            Text(summary)
                .font(.footnote)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.bar)
    }

    @ViewBuilder
    private func runtimeStatusBanner(_ execution: RuntimeExecutionMetadata) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Runtime Status")
                .font(.caption)
                .foregroundStyle(.secondary)

            runtimeBadgeRow(for: execution)

            if let detail = runtimeDetailSummary(for: execution) {
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.bar)
    }

    @ViewBuilder
    private func previewRouteBanner(_ route: RouteDecision) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.routeBannerTitle)
                .font(.caption)
                .foregroundStyle(.secondary)

            routeBadgeRow(for: route)

            Text(route.displayReasonSummary)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.thinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(.quaternary.opacity(0.7), lineWidth: 1)
        )
        .accessibilityIdentifier(PREXUSAccessibilityID.Chat.routePreview)
    }

    private func sensitivitySegmentedPicker(useCompactLabels: Bool) -> some View {
        Picker("Sensitivity", selection: $viewModel.selectedSensitivity) {
            ForEach(SensitivityLevel.allCases, id: \.self) { level in
                Text(useCompactLabels ? level.compactDisplayLabel : level.displayLabel)
                    .tag(level)
            }
        }
        .pickerStyle(.segmented)
        .disabled(viewModel.isSending)
    }

    private func containerAlignment(for role: ChatMessage.Role) -> Alignment {
        switch role {
        case .assistant, .system:
            return .leading
        case .user:
            return .trailing
        }
    }

    private func bubbleAlignment(for role: ChatMessage.Role) -> HorizontalAlignment {
        switch role {
        case .assistant, .system:
            return .leading
        case .user:
            return .trailing
        }
    }

    private func bubblePadding(for role: ChatMessage.Role) -> EdgeInsets {
        switch role {
        case .system:
            return EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        case .assistant, .user:
            return EdgeInsets(top: 12, leading: 14, bottom: 12, trailing: 14)
        }
    }

    @ViewBuilder
    private func bubbleBackground(for role: ChatMessage.Role) -> some View {
        switch role {
        case .system:
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.thinMaterial)
        case .assistant:
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(.regularMaterial)
        case .user:
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.primary.opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(.quaternary, lineWidth: 1)
                )
        }
    }

    private func roleLabelStyle(for role: ChatMessage.Role) -> AnyShapeStyle {
        switch role {
        case .system:
            return AnyShapeStyle(.tertiary)
        case .assistant, .user:
            return AnyShapeStyle(.secondary)
        }
    }

    private func messageTextStyle(for role: ChatMessage.Role) -> AnyShapeStyle {
        switch role {
        case .system, .assistant, .user:
            return AnyShapeStyle(.primary)
        }
    }

    private func font(for role: ChatMessage.Role) -> Font {
        switch role {
        case .system:
            return .headline
        case .assistant, .user:
            return .body
        }
    }

    private func bubbleMaxWidth(for role: ChatMessage.Role) -> CGFloat? {
        switch role {
        case .system:
            return nil
        case .assistant, .user:
            return 320
        }
    }

    private func spacingAfterMessage(at index: Int) -> CGFloat {
        guard index < viewModel.messages.count - 1 else { return 0 }

        let currentRole = viewModel.messages[index].role
        let nextRole = viewModel.messages[index + 1].role

        switch (currentRole, nextRole) {
        case (.system, _), (_, .system):
            return 18
        case let (lhs, rhs) where lhs == rhs:
            return 8
        default:
            return 12
        }
    }

    private func iconName(for mode: RuntimeExecutionMode) -> String {
        switch mode {
        case .local:
            return "iphone"
        case .cloud:
            return "cloud"
        case .fallback:
            return "arrow.trianglehead.clockwise"
        }
    }

    private func accentColor(for mode: RuntimeExecutionMode) -> Color {
        switch mode {
        case .local:
            return .green
        case .cloud:
            return .blue
        case .fallback:
            return .orange
        }
    }

    private func runtimeBadgeRow(for execution: RuntimeExecutionMetadata) -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) {
                PREXUSStatusChip(executionModeLabel(for: execution.mode), systemImage: iconName(for: execution.mode), tint: accentColor(for: execution.mode))

                if let provider = execution.provider?.rawValue {
                    PREXUSStatusChip(provider, tint: .secondary)
                }

                if let model = execution.model, !model.isEmpty {
                    PREXUSStatusChip(model, tint: .secondary)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                PREXUSStatusChip(executionModeLabel(for: execution.mode), systemImage: iconName(for: execution.mode), tint: accentColor(for: execution.mode))

                HStack(spacing: 8) {
                    if let provider = execution.provider?.rawValue {
                        PREXUSStatusChip(provider, tint: .secondary)
                    }

                    if let model = execution.model, !model.isEmpty {
                        PREXUSStatusChip(model, tint: .secondary)
                    }
                }
            }
        }
    }

    private func routeBadgeRow(for route: RouteDecision) -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) {
                PREXUSStatusChip(route.targetLabel, systemImage: route.target == .local ? "arrow.triangle.branch" : "arrow.up.right.square", tint: route.target == .local ? .green : .blue)
                PREXUSStatusChip(route.tierLabel, tint: .secondary)
                PREXUSStatusChip(viewModel.displayedSensitivity.compactDisplayLabel, tint: .secondary)

                if let primaryReason = RouteDecision.primaryReasonCode(from: route.reasonCodes) {
                    PREXUSStatusChip(RouteDecision.displayLabel(forReasonCode: primaryReason), tint: .secondary)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    PREXUSStatusChip(route.targetLabel, systemImage: route.target == .local ? "arrow.triangle.branch" : "arrow.up.right.square", tint: route.target == .local ? .green : .blue)
                    PREXUSStatusChip(route.tierLabel, tint: .secondary)
                }

                HStack(spacing: 8) {
                    PREXUSStatusChip(viewModel.displayedSensitivity.compactDisplayLabel, tint: .secondary)

                    if let primaryReason = RouteDecision.primaryReasonCode(from: route.reasonCodes) {
                        PREXUSStatusChip(RouteDecision.displayLabel(forReasonCode: primaryReason), tint: .secondary)
                    }
                }
            }
        }
    }

    private func runtimeDetailSummary(for execution: RuntimeExecutionMetadata) -> String? {
        guard let detail = execution.detail, !detail.isEmpty else { return nil }
        return detail
    }

    private func executionModeLabel(for mode: RuntimeExecutionMode) -> String {
        switch mode {
        case .local:
            return "Local runtime"
        case .cloud:
            return "Cloud"
        case .fallback:
            return "Fallback"
        }
    }
}

#if DEBUG
#Preview("Planned Route") {
    NavigationStack {
        ChatView(viewModel: .previewPlannedRoute())
    }
}

#Preview("Turn In Progress") {
    NavigationStack {
        ChatView(viewModel: .previewInFlight())
    }
}

#Preview("Conversation") {
    NavigationStack {
        ChatView(viewModel: .previewConversation())
    }
}

#Preview("Compact Conversation") {
    NavigationStack {
        ChatView(viewModel: .previewConversation())
    }
    .frame(width: 320, height: 760)
}
#endif
