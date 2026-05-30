import SwiftUI

struct LiteRTEvalRootView: View {
    @State private var status = "Waiting for model…"

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("PREXUS LiteRT-LM Eval")
                .font(.title2.bold())
            Text("Evaluation-only spike. Production PREXUS keeps Qwen + llama.cpp.")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text(status)
                .font(.body.monospaced())
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding()
        .onAppear {
            if let path = LiteRTModelPlacement.resolvedModelPath {
                status = "Model found. Running smoke eval…\n\(path)"
                LiteRTDeviceEvalRunner.runIfNeeded()
            } else {
                status = """
                Missing model.
                Push: ./tools/scripts/push_litert_lm_model_to_device.sh "Wang"
                File: Documents/Models/\(LiteRTModelPlacement.evaluationModelFileName)
                """
            }
        }
    }
}
