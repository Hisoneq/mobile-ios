import SwiftUI

struct PassKeyChangeView: View {
    let theme: ThemeModel
    @Environment(\.dismiss) private var dismiss

    @State private var currentPin = ""
    @State private var newPin = ""
    @State private var confirmPin = ""
    @State private var phase: Phase = .verifyCurrent
    @State private var errorMessage: String?

    private enum Phase {
        case verifyCurrent
        case setNew
    }

    var body: some View {
        NavigationStack {
            ZStack {
                theme.backgroundColor.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        if phase == .verifyCurrent {
                            Text("Enter your current pass key or use biometrics.")
                                .font(.subheadline)
                                .foregroundColor(theme.textColor.opacity(0.85))

                            SecureField("Current pass key", text: $currentPin)
                                .keyboardType(.numberPad)
                                .textContentType(.oneTimeCode)
                                .padding()
                                .background(theme.textColor.opacity(0.12))
                                .foregroundColor(theme.textColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            Button("Verify") {
                                verifyCurrent()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(theme.accentColor)
                            .frame(maxWidth: .infinity)

                            if PassKeyBiometry.canUseBiometrics() {
                                Button(PassKeyBiometry.biometryTitle) {
                                    verifyWithBiometrics()
                                }
                                .buttonStyle(.bordered)
                                .tint(theme.textColor)
                                .frame(maxWidth: .infinity)
                            }
                        } else {
                            SecureField("New pass key", text: $newPin)
                                .keyboardType(.numberPad)
                                .textContentType(.oneTimeCode)
                                .padding()
                                .background(theme.textColor.opacity(0.12))
                                .foregroundColor(theme.textColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            SecureField("Confirm new pass key", text: $confirmPin)
                                .keyboardType(.numberPad)
                                .textContentType(.oneTimeCode)
                                .padding()
                                .background(theme.textColor.opacity(0.12))
                                .foregroundColor(theme.textColor)
                                .clipShape(RoundedRectangle(cornerRadius: 12))

                            Button("Save new pass key") {
                                saveNew()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(theme.accentColor)
                            .frame(maxWidth: .infinity)
                        }

                        if let errorMessage {
                            Text(errorMessage)
                                .font(.footnote)
                                .foregroundColor(theme.accentColor)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Change pass key")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(theme.backgroundColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(theme.accentColor)
                }
            }
        }
    }

    private func verifyCurrent() {
        errorMessage = nil
        guard PassKeyStore.verifyPin(currentPin) else {
            errorMessage = "Current pass key is incorrect."
            currentPin = ""
            return
        }
        currentPin = ""
        phase = .setNew
    }

    private func verifyWithBiometrics() {
        errorMessage = nil
        PassKeyBiometry.authenticate(reason: "Confirm identity to change your pass key") { success in
            if success {
                phase = .setNew
            } else {
                errorMessage = "Biometric authentication failed."
            }
        }
    }

    private func saveNew() {
        errorMessage = nil
        guard newPin == confirmPin else {
            errorMessage = "New pass keys do not match."
            return
        }
        guard PassKeyHasher.normalize(newPin) != nil else {
            errorMessage = "Use 4–6 digits for the new pass key."
            return
        }
        do {
            try PassKeyStore.saveNewPassKey(newPin)
            newPin = ""
            confirmPin = ""
            dismiss()
        } catch {
            errorMessage = "Could not save. Try again."
        }
    }
}
