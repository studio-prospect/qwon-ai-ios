import Foundation

/// User-facing copy for QWON text-alpha onboarding (PR UI-1).
/// Runtime routing and backend strings stay in `runtime/` — labels and helper text only.
enum QWONUILabelCopy {
    enum Chat {
        static let headerSubtitle = "Local-first runtime · text alpha"
        static let sensitivityFootnote = "Sensitivity controls cloud escalation — not which on-device backend runs. See Settings for device path notes."
        /// UI-only onboarding copy — not injected into chat transcript or runtime prompts.
        static let onboardingHint = "QWON answers locally first when a model path is available. Wang expects llama.cpp On-Device Runtime; Matisse may use Embedded Heuristic Runtime — see Settings."
        static let fallbackStatusHelper = "Fallback may mean the local model file is unavailable, or Embedded Heuristic is the expected path on older hardware."
        static let composerPlaceholder = "Ask QWON"
    }

    enum Settings {
        static let introMessage = "Tune routing, cloud policy, and on-device inspection. Wang (A17 Pro+) expects llama.cpp On-Device Runtime when the local model is present; Matisse (A12) uses Embedded Heuristic Runtime as the expected local path."
        static let workspaceDetail = "Inspect how recent turns were routed and answered on device."
        static let workspaceFooter = "Diagnostics shows answered_by, primary_failure, and fallback_reason for each turn. Embedded Heuristic on Matisse is expected for this alpha tier — not a lab failure."
        static let diagnosticsNavSubtitle = "How each turn was answered — route, backend, and fallback fields."
        static let routingPolicyFooter = "Cloud escalation must be enabled before QWON can leave the local runtime. Provider Restricted keeps turns local unless an approved provider is configured. Providers without valid keys still run locally."
        static let localRuntimeFooter = "Automatic uses a simulator stub on Simulator. When prexus-local-mvp.gguf is present on capable hardware, expect llama.cpp On-Device Runtime. On older devices, Embedded Heuristic Runtime is the expected local path when no packaged model is available."
        static let providerRestrictedFooter = "These providers are the only cloud targets allowed when a turn uses Provider Restricted sensitivity. If none are approved, QWON keeps the turn local."
    }

    enum Diagnostics {
        static let introMessage = "See how each turn was routed and executed. answered_by names the backend; primary_failure explains a local model miss; fallback_reason notes why the heuristic path ran."
        static let summaryDetail = "Entries list route target, execution mode, and detail. On Wang with a local model, answered_by should read llama.cpp On-Device Runtime. On Matisse, Embedded Heuristic Runtime with Local runtime is the expected alpha path."
        static let emptyMessage = "After your first chat turn, this screen shows how QWON answered — including local model, heuristic fallback, or cloud escalation."
    }
}
