import SwiftUI

struct PassKeySetupView: View {
    let isReset: Bool
    let theme: ThemeModel
    let onComplete: () -> Void

    @State private var pass1 = ""
    @State private var pass2 = ""
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            theme.backgroundColor.ignoresSafeArea()

            VStack(spacing: 24) {
                Text(isReset ? "Set a new pass key" : "Create your pass key")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.textColor)

                Text("4–6 digits. Stored securely (hashed) in the Keychain.")
                    .font(.subheadline)
                    .foregroundColor(theme.textColor.opacity(0.75))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                SecureField("Pass key", text: $pass1)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .padding()
                    .background(theme.textColor.opacity(0.12))
                    .foregroundColor(theme.textColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                SecureField("Confirm pass key", text: $pass2)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .padding()
                    .background(theme.textColor.opacity(0.12))
                    .foregroundColor(theme.textColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(theme.accentColor)
                        .multilineTextAlignment(.center)
                }

                Button("Save") {
                    save()
                }
                .buttonStyle(.borderedProminent)
                .tint(theme.accentColor)
                .controlSize(.large)
                .disabled(!isValidPair)
            }
            .padding(28)
        }
    }

    private var isValidPair: Bool {
        pass1 == pass2 && PassKeyHasher.normalize(pass1) != nil
    }

    private func save() {
        errorMessage = nil
        guard pass1 == pass2 else {
            errorMessage = "Pass keys do not match."
            return
        }
        guard PassKeyHasher.normalize(pass1) != nil else {
            errorMessage = "Use 4–6 digits only."
            return
        }
        do {
            try PassKeyStore.saveNewPassKey(pass1)
            pass1 = ""
            pass2 = ""
            onComplete()
        } catch {
            errorMessage = "Could not save. Try again."
        }
    }
}
