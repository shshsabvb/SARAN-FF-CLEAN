import SwiftUI

struct ActivationView: View {
    @State private var key = ""
    @State private var message = "Enter your activation key to continue."
    @State private var loading = false
    @State private var activated = false

    var body: some View {
        ZStack {
            Color(red: 0.035, green: 0.055, blue: 0.10).ignoresSafeArea()
            VStack(spacing: 22) {
                Spacer()
                Image(systemName: "shield.lefthalf.filled").font(.system(size: 54)).foregroundStyle(.cyan)
                Text("SARAN FF").font(.system(size: 32, weight: .bold, design: .rounded)).foregroundStyle(.white)
                if activated {
                    Image(systemName: "checkmark.seal.fill").font(.system(size: 48)).foregroundStyle(.green)
                    Text("Activation successful").foregroundStyle(.white)
                } else {
                    Text("ACTIVATE YOUR DEVICE").font(.headline).foregroundStyle(.white)
                    TextField("Enter activation key", text: $key)
                        .textInputAutocapitalization(.characters).autocorrectionDisabled()
                        .padding(16).background(.white).clipShape(RoundedRectangle(cornerRadius: 12))
                    Button { Task { await activate() } } label: {
                        HStack { if loading { ProgressView().tint(.black) }; Text(loading ? "Checking..." : "ACTIVATE").bold() }
                            .frame(maxWidth: .infinity).padding(16).background(.cyan)
                            .foregroundStyle(.black).clipShape(RoundedRectangle(cornerRadius: 12))
                    }.disabled(loading || key.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                Text(message).font(.footnote).multilineTextAlignment(.center).foregroundStyle(.white.opacity(0.75))
                Spacer()
                Text("Version 1.1.1").font(.caption).foregroundStyle(.white.opacity(0.45))
            }.padding(28)
        }
    }

    @MainActor private func activate() async {
        loading = true
        defer { loading = false }
        do {
            activated = try await ActivationService.activate(key: key)
            message = activated ? "Your key was accepted." : "The server did not confirm this key."
        } catch { message = error.localizedDescription }
    }
}
