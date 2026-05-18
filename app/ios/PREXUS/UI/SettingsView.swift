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
                    NavigationLink {
                        RuntimeDiagnosticsView(diagnostics: runtimeDiagnostics)
                    } label: {
                        LabeledContent("Recent Runtime Decisions") {
                            Text("\(runtimeDiagnostics.entries.count)")
                                .foregroundStyle(.secondary)
                        }
                    }
                } header: {
                    Text("Diagnostics")
                } footer: {
                    Text("PREXUS keeps a small local-only diagnostics history for route inspection and trims older entries automatically.")
                }

                Section("Memory") {
                    NavigationLink {
                        MemoryLibraryView(viewModel: memoryLibrary)
                    } label: {
                        LabeledContent("Stored Episodes") {
                            Text("\(memoryLibrary.memories.count)")
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section {
                    LabeledContent("Escalation") {
                        Text(settings.config.allowsCloudEscalation ? "Enabled" : "Local Only")
                            .foregroundStyle(settings.config.allowsCloudEscalation ? .primary : .secondary)
                    }

                    LabeledContent("Restricted Mode") {
                        Text(restrictedProviderSummary)
                            .foregroundStyle(.secondary)
                    }

                    LabeledContent("Cloud-Ready Providers") {
                        Text(readyProviderSummary)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Routing Policy")
                } footer: {
                    Text("Cloud escalation must be enabled before PREXUS can leave the local runtime. Provider Restricted turns may use only the approved providers below, and any provider without a valid key still falls back to local execution.")
                }

                Section("Cloud") {
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

                Section("API Keys") {
                    SecureField("OpenAI API Key", text: $settings.openAIKey)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    SecureField("Anthropic API Key", text: $settings.anthropicKey)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()

                    SecureField("Gemini API Key", text: $settings.geminiKey)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
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

    @ViewBuilder
    private func providerAvailabilityRow(_ title: String, provider: CloudProvider) -> some View {
        LabeledContent(title) {
            Text(settings.availabilityStatus(for: provider).label)
                .foregroundStyle(color(for: settings.availabilityStatus(for: provider)))
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
}
