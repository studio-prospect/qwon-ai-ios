import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @FocusState private var isComposerFocused: Bool
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
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollDismissesKeyboard(.interactively)
            .contentShape(Rectangle())
            .onTapGesture {
                isComposerFocused = false
            }
            .simultaneousGesture(dismissKeyboardDragGesture)
            .background(Color(uiColor: .systemGroupedBackground))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationBarBackButtonHidden()
        .background(Color(uiColor: .systemGroupedBackground))
        .safeAreaInset(edge: .bottom, spacing: 0) {
            controlDock
        }
        .accessibilityIdentifier(PREXUSAccessibilityID.Chat.screen)
    }

    private var controlDock: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let route = viewModel.displayedRoute {
                previewRouteBanner(route)
            }

            composerCard
        }
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .background(.bar)
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
                    .font(.caption.weight(.semibold))
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
                    .focused($isComposerFocused)
                    .submitLabel(.send)
                    .onSubmit(submitDraftIfPossible)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color(uiColor: .secondarySystemGroupedBackground))
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(.quaternary.opacity(0.7), lineWidth: 0.5)
                    )
                    .disabled(viewModel.isSending)

                Button(action: submitDraftIfPossible) {
                    Group {
                        if viewModel.isSending {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.white)
                        } else {
                            Text("Send")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(minWidth: 72)
                    .frame(height: 44)
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isSending)
            }
        }
        .padding(14)
        .prexusControlGlass(shape: .roundedRect(cornerRadius: 20), fallbackMaterial: .thinMaterial)
        .accessibilityIdentifier(PREXUSAccessibilityID.Chat.composer)
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("PREXUS")
                    .font(.title2.weight(.semibold))
                    .tracking(-0.4)

                Text("Local-first runtime")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Button(action: onOpenSettings) {
                Image(systemName: "gearshape")
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                    .frame(width: 36, height: 36)
                    .prexusControlGlass(shape: .capsule, fallbackMaterial: .ultraThinMaterial)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Open Settings")
            .accessibilityIdentifier(PREXUSAccessibilityID.Chat.openSettings)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .prexusControlGlass(shape: .roundedRect(cornerRadius: 0), fallbackMaterial: .bar)
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
        PREXUSRuntimeStrip {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 8) {
                    ProgressView()
                        .controlSize(.small)
                        .tint(.blue)

                    PREXUSStatusChip("In Progress", tint: .blue, appearance: .controlSurface)
                    PREXUSStatusChip(viewModel.displayedSensitivity.compactDisplayLabel, tint: .secondary, appearance: .controlSurface)

                    Text(summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) {
                        ProgressView()
                            .controlSize(.small)
                            .tint(.blue)

                        PREXUSStatusChip("In Progress", tint: .blue, appearance: .controlSurface)
                        PREXUSStatusChip(viewModel.displayedSensitivity.compactDisplayLabel, tint: .secondary, appearance: .controlSurface)
                    }

                    Text(summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
    }

    @ViewBuilder
    private func runtimeStatusBanner(_ execution: RuntimeExecutionMetadata) -> some View {
        PREXUSRuntimeStrip {
            VStack(alignment: .leading, spacing: 8) {
                runtimeBadgeRow(for: execution)

                if let detail = runtimeDetailSummary(for: execution) {
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .textSelection(.enabled)
                }
            }
        }
    }

    @ViewBuilder
    private func previewRouteBanner(_ route: RouteDecision) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(viewModel.routeBannerTitle)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            routeBadgeRow(for: route)

            Text(route.displayReasonSummary)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .prexusControlGlass(shape: .roundedRect(cornerRadius: 16), fallbackMaterial: .ultraThinMaterial)
        .accessibilityElement(children: .contain)
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
                .fill(Color(uiColor: .tertiarySystemGroupedBackground))
        case .assistant:
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .secondarySystemGroupedBackground))
        case .user:
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(uiColor: .systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .strokeBorder(.quaternary.opacity(0.8), lineWidth: 0.5)
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
                PREXUSStatusChip(
                    executionModeLabel(for: execution.mode),
                    systemImage: iconName(for: execution.mode),
                    tint: accentColor(for: execution.mode),
                    appearance: .controlSurface
                )

                if let provider = execution.provider?.rawValue {
                    PREXUSStatusChip(provider, tint: .secondary, appearance: .controlSurface)
                }

                if let model = execution.model, !model.isEmpty {
                    PREXUSStatusChip(model, tint: .secondary, appearance: .controlSurface)
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                PREXUSStatusChip(
                    executionModeLabel(for: execution.mode),
                    systemImage: iconName(for: execution.mode),
                    tint: accentColor(for: execution.mode),
                    appearance: .controlSurface
                )

                HStack(spacing: 8) {
                    if let provider = execution.provider?.rawValue {
                        PREXUSStatusChip(provider, tint: .secondary, appearance: .controlSurface)
                    }

                    if let model = execution.model, !model.isEmpty {
                        PREXUSStatusChip(model, tint: .secondary, appearance: .controlSurface)
                    }
                }
            }
        }
    }

    private func routeBadgeRow(for route: RouteDecision) -> some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: 8) {
                PREXUSStatusChip(
                    route.targetLabel,
                    systemImage: route.target == .local ? "arrow.triangle.branch" : "arrow.up.right.square",
                    tint: route.target == .local ? .green : .blue,
                    appearance: .controlSurface
                )
                PREXUSStatusChip(route.tierLabel, tint: .secondary, appearance: .controlSurface)
                PREXUSStatusChip(viewModel.displayedSensitivity.compactDisplayLabel, tint: .secondary, appearance: .controlSurface)

                if let primaryReason = RouteDecision.primaryReasonCode(from: route.reasonCodes) {
                    PREXUSStatusChip(
                        RouteDecision.displayLabel(forReasonCode: primaryReason),
                        tint: .secondary,
                        appearance: .controlSurface
                    )
                }
            }

            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    PREXUSStatusChip(
                        route.targetLabel,
                        systemImage: route.target == .local ? "arrow.triangle.branch" : "arrow.up.right.square",
                        tint: route.target == .local ? .green : .blue,
                        appearance: .controlSurface
                    )
                    PREXUSStatusChip(route.tierLabel, tint: .secondary, appearance: .controlSurface)
                }

                HStack(spacing: 8) {
                    PREXUSStatusChip(viewModel.displayedSensitivity.compactDisplayLabel, tint: .secondary, appearance: .controlSurface)

                    if let primaryReason = RouteDecision.primaryReasonCode(from: route.reasonCodes) {
                        PREXUSStatusChip(
                            RouteDecision.displayLabel(forReasonCode: primaryReason),
                            tint: .secondary,
                            appearance: .controlSurface
                        )
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

    private func submitDraftIfPossible() {
        let text = viewModel.draftText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty, !viewModel.isSending else { return }
        viewModel.send(text: text)
        isComposerFocused = false
    }

    /// Dismisses the composer keyboard when the user swipes down on the message area
    /// (including when the transcript is too short to scroll).
    private var dismissKeyboardDragGesture: some Gesture {
        DragGesture(minimumDistance: 16, coordinateSpace: .local)
            .onEnded { value in
                let isDownward = value.translation.height > 28
                let isMostlyVertical = abs(value.translation.height) > abs(value.translation.width)
                guard isDownward, isMostlyVertical else { return }
                isComposerFocused = false
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
