import SwiftUI

struct ActivationView: View {
    @State private var activationKey = ""
    @State private var message = ""
    @State private var isLoading = false
    @State private var isActivated = false
    @State private var expiryDate: String?

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "lock.shield.fill")
                    .font(.system(size: 65))
                    .foregroundColor(.cyan)

                Text("SARAN FF")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Text("VERSION 1.1.1")
                    .foregroundColor(.gray)

                Text("ACTIVATE YOUR ACCESS")
                    .font(.headline)
                    .foregroundColor(.white)

                TextField("Enter activation key", text: $activationKey)
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)

                Button(action: activate) {
                    HStack {
                        if isLoading {
                            ProgressView().tint(.white)
                        } else {
                            Text("ACTIVATE")
                                .bold()
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                }
                .disabled(isLoading || activationKey.isEmpty)

                if !message.isEmpty {
                    Text(message)
                        .foregroundColor(isActivated ? .green : .red)
                        .multilineTextAlignment(.center)
                }

                Spacer()

                Text("SARAN FF • SECURE ACTIVATION")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(28)
        }
    }

    private func activate() {
        guard !activationKey.trimmingCharacters(in: .whitespaces).isEmpty else {
            message = "Please enter your activation key."
            return
        }

        isLoading = true
        message = ""
        isActivated = false

        Task {
            do {
                let result = try await ActivationService.shared.activate(
                    key: activationKey.trimmingCharacters(in: .whitespaces)
                )

                await MainActor.run {
                    isActivated = true
                    message = result.message
                    expiryDate = result.expires
                    isLoading = false
                }
            } catch {
                await MainActor.run {
                    message = error.localizedDescription
                    isLoading = false
                }
            }
        }
    }
}
