import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: AppSettingsStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Cloud") {
                    Toggle("Allow Cloud Escalation", isOn: $settings.config.allowsCloudEscalation)

                    Stepper(
                        "Max Cloud Context Tokens: \(settings.config.maxCloudContextTokens)",
                        value: $settings.config.maxCloudContextTokens,
                        in: 256...8192,
                        step: 256
                    )
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
}
