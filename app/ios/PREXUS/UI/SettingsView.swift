import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: AppSettingsStore
    @ObservedObject var memoryLibrary: MemoryLibraryViewModel
    @ObservedObject var runtimeDiagnostics: RuntimeDiagnosticsStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
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

                    NavigationLink {
                        MemoryLibraryView(viewModel: memoryLibrary)
                    } label: {
                        settingsNavigationRow(
                            title: "Stored Episodes",
                            subtitle: "Review compact local memory snapshots.",
                            value: "\(memoryLibrary.memories.count)"
                        )
                    }
                } header: {
                    Text("Workspace")
                } footer: {
                    Text("PREXUS keeps local-only summaries for memory and runtime inspection, and trims older diagnostics automatically.")
                }

                Section {
                    settingSummaryRow(
                        "Escalation",
                        subtitle: "Controls whether PREXUS may leave the on-device runtime.",
                        accessory: AnyView(
                            PREXUSStatusChip(
                                settings.config.allowsCloudEscalation ? "Enabled" : "Local Only",
                                tint: settings.config.allowsCloudEscalation ? .blue : .secondary
                            )
                        )
                    )

                    settingSummaryRow(
                        "Restricted Mode",
                        subtitle: restrictedProviderSummary,
                        accessory: AnyView(
                            PREXUSStatusChip(
                                settings.config.approvedProvidersForRestrictedMode.isEmpty ? "Local fallback" : "Allowlist active",
                                tint: settings.config.approvedProvidersForRestrictedMode.isEmpty ? .orange : .green
                            )
                        )
                    )

                    settingSummaryRow(
                        "Cloud-Ready Providers",
                        subtitle: readyProviderSummary,
                        accessory: AnyView(
                            PREXUSStatusChip(readyProviderCountLabel, tint: readyProviderCount > 0 ? .green : .secondary)
                        )
                    )
                } header: {
                    Text("Routing Policy")
                } footer: {
                    Text("Cloud escalation must be enabled before PREXUS can leave the local runtime. Provider Restricted turns may use only the approved providers below, and providers without valid keys still fall back to local execution.")
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
                    Text("Cloud")
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
                    Text("Provider-Restricted Mode")
                } footer: {
                    Text("These providers are the only cloud targets allowed when a turn uses Provider Restricted sensitivity. If none are approved, PREXUS keeps the turn local.")
                }

                Section {
                    providerAvailabilityRow("OpenAI", provider: .openAI)
                    providerAvailabilityRow("Anthropic", provider: .anthropic)
                    providerAvailabilityRow("Gemini", provider: .gemini)
                } header: {
                    Text("Provider Availability")
                } footer: {
                    Text("When a provider is not ready, PREXUS keeps the request on the local runtime instead of attempting cloud escalation.")
                }

                Section {
                    Picker("Backend", selection: $settings.config.localModelBackend) {
                        ForEach(LocalModelBackend.allCases, id: \.self) { backend in
                            Text(backend.displayName).tag(backend)
                        }
                    }
                } header: {
                    Text("Local Runtime")
                } footer: {
                    Text("Automatic uses a simulator stub on Simulator and the device runtime bridge on hardware.")
                }

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
                    Text("API Keys")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
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
    }

    private var settingsIntroCard: some View {
        PREXUSSurfaceCard(borderTint: Color.blue.opacity(0.16)) {
            VStack(alignment: .leading, spacing: 12) {
                PREXUSScreenIntro(
                    eyebrow: "Runtime control",
                    title: "Settings",
                    message: "Tune how PREXUS routes work between the on-device runtime, approved cloud providers, diagnostics, and local memory."
                )

                ViewThatFits(in: .horizontal) {
                    HStack(spacing: 8) {
                        PREXUSStatusChip(settings.config.allowsCloudEscalation ? "Cloud available" : "Local only", tint: settings.config.allowsCloudEscalation ? .blue : .secondary)
                        PREXUSStatusChip(settings.config.approvedProvidersForRestrictedMode.isEmpty ? "Restricted → Local" : "Restricted allowlist", tint: settings.config.approvedProvidersForRestrictedMode.isEmpty ? .orange : .green)
                        PREXUSStatusChip(readyProviderCountLabel, tint: readyProviderCount > 0 ? .green : .secondary)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 8) {
                            PREXUSStatusChip(settings.config.allowsCloudEscalation ? "Cloud available" : "Local only", tint: settings.config.allowsCloudEscalation ? .blue : .secondary)
                            PREXUSStatusChip(readyProviderCountLabel, tint: readyProviderCount > 0 ? .green : .secondary)
                        }

                        PREXUSStatusChip(settings.config.approvedProvidersForRestrictedMode.isEmpty ? "Restricted → Local" : "Restricted allowlist", tint: settings.config.approvedProvidersForRestrictedMode.isEmpty ? .orange : .green)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
    }

    private func summaryCard(title: String, value: String, caption: String, tint: Color) -> some View {
        PREXUSSurfaceCard(borderTint: tint.opacity(0.18)) {
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
                PREXUSStatusChip(value, tint: .secondary)
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

    @ViewBuilder
    private func providerAvailabilityRow(_ title: String, provider: CloudProvider) -> some View {
        let status = settings.availabilityStatus(for: provider)
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .center, spacing: 12) {
                Text(title)
                    .foregroundStyle(.primary)
                Spacer(minLength: 0)
                PREXUSStatusChip(status.label, tint: color(for: status))
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
            return "No valid API key is available, so PREXUS stays local."
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

struct PREXUSSurfaceCard<Content: View>: View {
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

struct PREXUSStatusChip: View {
    let title: String
    let systemImage: String?
    let tint: Color

    init(_ title: String, systemImage: String? = nil, tint: Color) {
        self.title = title
        self.systemImage = systemImage
        self.tint = tint
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
        .background(
            Capsule(style: .continuous)
                .fill(tint.opacity(0.12))
        )
    }
}

struct PREXUSEmptyState: View {
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
        PREXUSSurfaceCard(borderTint: tint.opacity(0.18)) {
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

                        Text("PREXUS surface")
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

struct PREXUSScreenIntro: View {
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
        let suiteName = "PREXUS.SettingsPreview.\(UUID().uuidString)"
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
