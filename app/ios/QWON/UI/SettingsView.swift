import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: AppSettingsStore
    @ObservedObject var memoryLibrary: MemoryLibraryViewModel
    @ObservedObject var runtimeDiagnostics: RuntimeDiagnosticsStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                header

                Form {
                    Section {
                        summarySurface
                            .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 8, trailing: 0))
                            .listRowBackground(Color.clear)
                    }

                    Section {
                        NavigationLink {
                            RuntimeDiagnosticsView(diagnostics: runtimeDiagnostics)
                        } label: {
                            settingsNavigationRow(
                                title: "Recent Runtime Decisions",
                                subtitle: "Inspect recent route and execution outcomes.",
                                value: "\(runtimeDiagnostics.entries.count)"
                            )
                        }
                        .accessibilityIdentifier(QWONAccessibilityID.Settings.openDiagnostics)

                        NavigationLink {
                            MemoryLibraryView(viewModel: memoryLibrary)
                        } label: {
                            settingsNavigationRow(
                                title: "Stored Episodes",
                                subtitle: "Review compact local memory snapshots.",
                                value: "\(memoryLibrary.memories.count)"
                            )
                        }
                        .accessibilityIdentifier(QWONAccessibilityID.Settings.openMemory)
                    } header: {
                        QWONFormSectionHeader(
                            title: "Workspace",
                            detail: "Inspect the local runtime history QWON keeps on device."
                        )
                    } footer: {
                        Text("QWON keeps local-only summaries for memory and runtime inspection, and trims older diagnostics automatically.")
                    }

                    Section {
                        settingSummaryRow(
                            "Escalation",
                            subtitle: "Controls whether QWON may leave the on-device runtime.",
                            accessory: AnyView(
                                QWONStatusChip(
                                    settings.config.allowsCloudEscalation ? "Enabled" : "Local Only",
                                    tint: settings.config.allowsCloudEscalation ? .blue : .secondary
                                )
                            )
                        )

                        settingSummaryRow(
                            "Restricted Mode",
                            subtitle: restrictedProviderSummary,
                            accessory: AnyView(
                                QWONStatusChip(
                                    settings.config.approvedProvidersForRestrictedMode.isEmpty ? "Local fallback" : "Allowlist active",
                                    tint: settings.config.approvedProvidersForRestrictedMode.isEmpty ? .orange : .green
                                )
                            )
                        )

                        settingSummaryRow(
                            "Cloud-Ready Providers",
                            subtitle: readyProviderSummary,
                            accessory: AnyView(
                                QWONStatusChip(readyProviderCountLabel, tint: readyProviderCount > 0 ? .green : .secondary)
                            )
                        )
                    } header: {
                        QWONFormSectionHeader(
                            title: "Routing Policy",
                            detail: "Define when QWON may escalate beyond the on-device runtime."
                        )
                    } footer: {
                        Text("Cloud escalation must be enabled before QWON can leave the local runtime. Provider Restricted turns may use only the approved providers below, and providers without valid keys still fall back to local execution.")
                    }

                    Section {
                        Toggle("Allow Cloud Escalation", isOn: $settings.config.allowsCloudEscalation)

                        Stepper(
                            "Max Cloud Context Tokens: \(settings.config.maxCloudContextTokens)",
                            value: $settings.config.maxCloudContextTokens,
                            in: 256...8192,
                            step: 256
                        )

                        TextField("OpenAI Model", text: $settings.config.openAIModel)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    } header: {
                        QWONFormSectionHeader(
                            title: "Cloud",
                            detail: "Configure the default cloud routing budget and primary OpenAI model."
                        )
                    }

                    Section {
                        ForEach(CloudProvider.allCases, id: \.self) { provider in
                            Toggle(
                                provider.displayLabel,
                                isOn: Binding(
                                    get: { settings.isApprovedForRestrictedMode(provider) },
                                    set: { settings.setApprovedForRestrictedMode($0, provider: provider) }
                                )
                            )
                        }
                    } header: {
                        QWONFormSectionHeader(
                            title: "Provider-Restricted Mode",
                            detail: "Limit restricted turns to an explicit provider allowlist."
                        )
                    } footer: {
                        Text("These providers are the only cloud targets allowed when a turn uses Provider Restricted sensitivity. If none are approved, QWON keeps the turn local.")
                    }

                    Section {
                        providerAvailabilityRow("OpenAI", provider: .openAI)
                        providerAvailabilityRow("Anthropic", provider: .anthropic)
                        providerAvailabilityRow("Gemini", provider: .gemini)
                    } header: {
                        QWONFormSectionHeader(
                            title: "Provider Availability",
                            detail: "See which providers are actually ready for cloud execution."
                        )
                    } footer: {
                        Text("When a provider is not ready, QWON keeps the request on the local runtime instead of attempting cloud escalation.")
                    }

                    Section {
                        Picker("Backend", selection: $settings.config.localModelBackend) {
                            ForEach(availableLocalModelBackends, id: \.self) { backend in
                                Text(backend.displayName).tag(backend)
                            }
                        }
                    } header: {
                        QWONFormSectionHeader(
                            title: "Local Runtime",
                            detail: "Select the on-device backend QWON should favor locally."
                        )
                    } footer: {
                        Text("Automatic uses a simulator stub on Simulator and llama.cpp on A17 Pro-class iPhones when a GGUF model is present.")
                    }

                    #if DEBUG && PREXUS_LITERT_LM_PROTOTYPE
                    litertPrototypeSection
                    #endif

                    Section {
                        SecureField("OpenAI API Key", text: $settings.openAIKey)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        SecureField("Anthropic API Key", text: $settings.anthropicKey)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        SecureField("Gemini API Key", text: $settings.geminiKey)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                    } header: {
                        QWONFormSectionHeader(
                            title: "API Keys",
                            detail: "Store provider credentials locally so QWON can verify cloud readiness."
                        )
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Color(uiColor: .systemGroupedBackground))
            }
            .toolbar(.hidden, for: .navigationBar)
            .background(Color(uiColor: .systemGroupedBackground))
            .accessibilityIdentifier(QWONAccessibilityID.Settings.screen)
        }
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text("Settings")
                    .font(.largeTitle.weight(.semibold))
                    .tracking(-0.8)

                Text("Runtime control")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 0)

            Button("Done") {
                dismiss()
            }
            .font(.headline.weight(.medium))
            .foregroundStyle(.blue)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                Capsule(style: .continuous)
                    .fill(.thinMaterial)
            )
            .accessibilityIdentifier(QWONAccessibilityID.Settings.done)
        }
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 8)
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private var summarySurface: some View {
        VStack(alignment: .leading, spacing: 12) {
            settingsIntroCard

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 12) {
                    summaryCard(
                        title: "Diagnostics",
                        value: "\(runtimeDiagnostics.entries.count)",
                        caption: "Recent route decisions",
                        tint: .blue
                    )
                    summaryCard(
                        title: "Memory",
                        value: "\(memoryLibrary.memories.count)",
                        caption: "Stored local episodes",
                        tint: .purple
                    )
                }

                VStack(spacing: 12) {
                    summaryCard(
                        title: "Diagnostics",
                        value: "\(runtimeDiagnostics.entries.count)",
                        caption: "Recent route decisions",
                        tint: .blue
                    )
                    summaryCard(
                        title: "Memory",
                        value: "\(memoryLibrary.memories.count)",
                        caption: "Stored local episodes",
                        tint: .purple
                    )
                }
            }

            summaryCard(
                title: "Routing",
                value: settings.config.allowsCloudEscalation ? "Cloud available" : "Local only",
                caption: settings.config.approvedProvidersForRestrictedMode.isEmpty
                    ? "Restricted turns currently fall back to local."
                    : "Restricted turns may use \(restrictedProviderSummary.lowercased()).",
                tint: settings.config.allowsCloudEscalation ? .green : .secondary
            )
        }
        .accessibilityIdentifier(QWONAccessibilityID.Settings.summarySurface)
    }

    private var settingsIntroCard: some View {
        QWONSurfaceCard(borderTint: Color.blue.opacity(0.16)) {
            VStack(alignment: .leading, spacing: 12) {
                QWONScreenIntro(
                    eyebrow: "Runtime control",
                    title: "Settings",
                    message: "Tune how QWON routes work between the on-device runtime, approved cloud providers, diagnostics, and local memory."
                )

                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 8) {
                        QWONStatusChip(settings.config.allowsCloudEscalation ? "Cloud available" : "Local only", tint: settings.config.allowsCloudEscalation ? .blue : .secondary)
                        QWONStatusChip(settings.config.approvedProvidersForRestrictedMode.isEmpty ? "Restricted → Local" : "Restricted allowlist", tint: settings.config.approvedProvidersForRestrictedMode.isEmpty ? .orange : .green)
                        QWONStatusChip(readyProviderCountLabel, tint: readyProviderCount > 0 ? .green : .secondary)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            QWONStatusChip(settings.config.allowsCloudEscalation ? "Cloud available" : "Local only", tint: settings.config.allowsCloudEscalation ? .blue : .secondary)
                            QWONStatusChip(readyProviderCountLabel, tint: readyProviderCount > 0 ? .green : .secondary)
                        }

                        QWONStatusChip(settings.config.approvedProvidersForRestrictedMode.isEmpty ? "Restricted → Local" : "Restricted allowlist", tint: settings.config.approvedProvidersForRestrictedMode.isEmpty ? .orange : .green)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
    }

    private func summaryCard(title: String, value: String, caption: String, tint: Color) -> some View {
        QWONSurfaceCard(borderTint: tint.opacity(0.18)) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(value)
                    .font(.headline)
                    .foregroundStyle(.primary)
                Text(caption)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
    }

    private func settingsNavigationRow(title: String, subtitle: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 12) {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer(minLength: 0)
                QWONStatusChip(value, tint: .secondary)
            }

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func settingSummaryRow(_ title: String, subtitle: String, accessory: AnyView) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 12) {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer(minLength: 0)
                accessory
            }

            Text(subtitle)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.vertical, 4)
    }

    #if DEBUG && PREXUS_LITERT_LM_PROTOTYPE
    @ViewBuilder
    private var litertPrototypeSection: some View {
        Section {
            Toggle(
                "Use LiteRT eval backend (A17 Pro+ only)",
                isOn: Binding(
                    get: { settings.litertPrototypeEnabled },
                    set: { settings.setLitertPrototypeEnabled($0) }
                )
            )

            Text(litertPrototypeAvailabilityText)
                .font(.caption)
                .foregroundStyle(.secondary)
        } header: {
            QWONFormSectionHeader(
                title: "LiteRT-LM Prototype (Debug)",
                detail: "Off by default. Does not change production automatic routing."
            )
        } footer: {
            Text("Requires prexus-eval-gemma4-e2b.litertlm in Documents/Models. On failure, QWON falls back to Qwen llama.cpp, then embedded heuristics.")
        }
    }

    private var litertPrototypeAvailabilityText: String {
        if LiteRTPrototypeSettings.isRuntimeAvailable {
            return "Prototype path is active for local turns when enabled."
        }
        if !settings.litertPrototypeEnabled {
            return "Enable the toggle on A17 Pro+ with the eval .litertlm artifact present."
        }
        if !LiteRTModelPlacement.isModelAvailable {
            return "Push the eval artifact: ./tools/scripts/push_litert_lm_model_to_device.sh"
        }
        return "Requires A17 Pro-class hardware."
    }
    #endif

    private var availableLocalModelBackends: [LocalModelBackend] {
        #if targetEnvironment(simulator)
        LocalModelBackend.allCases
        #else
        LocalModelBackend.allCases.filter { $0 != .simulatorMock }
        #endif
    }

    @ViewBuilder
    private func providerAvailabilityRow(_ title: String, provider: CloudProvider) -> some View {
        let status = settings.availabilityStatus(for: provider)
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 12) {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer(minLength: 0)
                QWONStatusChip(status.label, tint: color(for: status))
            }

            Text(providerAvailabilityDescription(for: status))
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private func providerAvailabilityDescription(for status: ProviderAvailabilityStatus) -> String {
        switch status {
        case .cloudReady:
            return "Ready for cloud execution when policy allows it."
        case .localPrimary:
            return "No valid API key is available, so QWON stays local."
        case .disabled:
            return "Cloud escalation is disabled at the policy level."
        }
    }

    private func color(for status: ProviderAvailabilityStatus) -> Color {
        switch status {
        case .cloudReady:
            return .green
        case .localPrimary:
            return .orange
        case .disabled:
            return .secondary
        }
    }

    private var restrictedProviderSummary: String {
        let approved = CloudProvider.allCases.filter(settings.isApprovedForRestrictedMode)
        guard !approved.isEmpty else {
            return "No approved providers"
        }

        return approved.map(\.displayLabel).joined(separator: ", ")
    }

    private var readyProviderSummary: String {
        let ready = CloudProvider.allCases.filter { settings.availabilityStatus(for: $0) == .cloudReady }
        guard !ready.isEmpty else {
            return settings.config.allowsCloudEscalation ? "None" : "Disabled"
        }

        return ready.map(\.displayLabel).joined(separator: ", ")
    }

    private var readyProviderCount: Int {
        CloudProvider.allCases.filter { settings.availabilityStatus(for: $0) == .cloudReady }.count
    }

    private var readyProviderCountLabel: String {
        readyProviderCount == 1 ? "1 ready" : "\(readyProviderCount) ready"
    }
}

struct QWONSurfaceCard<Content: View>: View {
    let borderTint: Color
    @ViewBuilder let content: () -> Content

    init(borderTint: Color = Color(uiColor: .quaternaryLabel), @ViewBuilder content: @escaping () -> Content) {
        self.borderTint = borderTint
        self.content = content
    }

    var body: some View {
        content()
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(.thinMaterial)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(borderTint, lineWidth: 1)
            )
    }
}

enum QWONChipAppearance {
    case standard
    case controlSurface
}

struct QWONStatusChip: View {
    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    let title: String
    let systemImage: String?
    let tint: Color
    let appearance: QWONChipAppearance

    init(
        _ title: String,
        systemImage: String? = nil,
        tint: Color,
        appearance: QWONChipAppearance = .standard
    ) {
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
        self.appearance = appearance
    }

    var body: some View {
        Group {
            if let systemImage {
                Label(title, systemImage: systemImage)
                    .labelStyle(.titleAndIcon)
            } else {
                Text(title)
            }
        }
        .font(.caption.weight(.medium))
        .foregroundStyle(tint)
        .lineLimit(1)
        .minimumScaleFactor(0.82)
        .allowsTightening(true)
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(chipBackground)
    }

    @ViewBuilder
    private var chipBackground: some View {
        switch appearance {
        case .standard:
            Capsule(style: .continuous)
                .fill(tint.opacity(0.12))
        case .controlSurface:
            if reduceTransparency {
                Capsule(style: .continuous)
                    .fill(Color(uiColor: .secondarySystemFill))
                    .overlay(
                        Capsule(style: .continuous)
                            .strokeBorder(tint.opacity(0.22), lineWidth: 0.5)
                    )
            } else if #available(iOS 26.0, *) {
                Capsule(style: .continuous)
                    .fill(.clear)
                    .glassEffect(in: .capsule)
            } else {
                Capsule(style: .continuous)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule(style: .continuous)
                            .strokeBorder(tint.opacity(0.18), lineWidth: 0.5)
                    )
            }
        }
    }
}

struct QWONEmptyState: View {
    let title: String
    let systemImage: String
    let message: String
    let tint: Color

    init(title: String, systemImage: String, message: String, tint: Color = .blue) {
        self.title = title
        self.systemImage = systemImage
        self.message = message
        self.tint = tint
    }

    var body: some View {
        QWONSurfaceCard(borderTint: tint.opacity(0.18)) {
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 10) {
                    Image(systemName: systemImage)
                        .font(.title3.weight(.semibold))
                        .foregroundStyle(tint)
                        .frame(width: 36, height: 36)
                        .background(
                            Circle()
                                .fill(tint.opacity(0.12))
                        )

                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(.headline)
                            .foregroundStyle(.primary)

                        Text("QWON surface")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct QWONScreenIntro: View {
    let eyebrow: String
    let title: String
    let message: String

    init(eyebrow: String, title: String, message: String) {
        self.eyebrow = eyebrow
        self.title = title
        self.message = message
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(eyebrow)
                .font(.caption)
                .foregroundStyle(.secondary)

            Text(title)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)

            Text(message)
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct QWONFormSectionHeader: View {
    let title: String
    let detail: String

    init(title: String, detail: String) {
        self.title = title
        self.detail = detail
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)
                .textCase(nil)

            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
                .textCase(nil)
        }
        .padding(.top, 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#if DEBUG
#Preview {
    SettingsView.preview()
}

#Preview("Compact") {
    SettingsView.preview()
        .frame(width: 320, height: 760)
}

private extension SettingsView {
    static func preview() -> SettingsView {
        let suiteName = "QWON.SettingsPreview.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)

        let apiKeyStore = InMemoryAPIKeyStore()
        apiKeyStore.setAPIKey("preview-openai-key", for: .openAI)
        apiKeyStore.setAPIKey("preview-gemini-key", for: .gemini)

        let settings = AppSettingsStore(defaults: defaults, apiKeyStore: apiKeyStore)
        settings.config.allowsCloudEscalation = true
        settings.config.approvedProvidersForRestrictedMode = [.openAI, .gemini]

        let memoryStore = InMemoryEpisodicMemoryStore()
        memoryStore.save(
            EpisodicMemory(
                id: UUID(),
                summary: "Summarized routing policy notes for the current release.",
                sensitivity: .localPreferred,
                createdAt: .now
            )
        )
        let memoryLibrary = MemoryLibraryViewModel(memoryStore: memoryStore)

        let diagnostics = RuntimeDiagnosticsStore(defaults: defaults)
        diagnostics.record(
            route: RouteDecision(tier: .tier3, target: .openAI, reasonCodes: ["codeAnalysis", "provider_restricted"]),
            execution: RuntimeExecutionMetadata(mode: .cloud, provider: .openAI, model: "gpt-5-mini", detail: "Preview cloud path"),
            userText: "Review this routing implementation."
        )

        return SettingsView(
            settings: settings,
            memoryLibrary: memoryLibrary,
            runtimeDiagnostics: diagnostics
        )
    }
}
#endif
