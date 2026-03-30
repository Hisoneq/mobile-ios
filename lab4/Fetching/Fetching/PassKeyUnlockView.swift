import SwiftUI

struct PassKeyUnlockView: View {
    let theme: ThemeModel
    let onUnlocked: () -> Void
    let onForgotReset: () -> Void

    @State private var pin = ""
    @State private var errorMessage: String?
    @State private var attempts = 0
    @State private var showForgotConfirm = false
    @State private var biometricHint: String?

    var body: some View {
        ZStack {
            theme.backgroundColor.ignoresSafeArea()

            VStack(spacing: 24) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 56))
                    .foregroundColor(theme.accentColor)

                Text("Enter pass key")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.textColor)

                SecureField("Pass key", text: $pin)
                    .keyboardType(.numberPad)
                    .textContentType(.oneTimeCode)
                    .padding()
                    .background(theme.textColor.opacity(0.12))
                    .foregroundColor(theme.textColor)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .onSubmit { tryUnlockWithPin() }

                if let errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(theme.accentColor)
                }

                Button("Unlock") {
                    tryUnlockWithPin()
                }
                .buttonStyle(.borderedProminent)
                .tint(theme.accentColor)

                if PassKeyBiometry.canUseBiometrics() {
                    Button(PassKeyBiometry.biometryTitle) {
                        tryBiometricUnlock()
                    }
                    .buttonStyle(.bordered)
                    .tint(theme.textColor)
                } else if let biometricHint {
                    Text(biometricHint)
                        .font(.caption)
                        .foregroundColor(theme.textColor.opacity(0.6))
                }

                Button("Forgot pass key?") {
                    showForgotConfirm = true
                }
                .font(.subheadline)
                .foregroundColor(theme.accentColor)
            }
            .padding(28)
        }
        .alert("Reset pass key?", isPresented: $showForgotConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Continue") { startForgotFlow() }
        } message: {
            Text("You must verify with Face ID / Touch ID to set a new pass key.")
        }
        .onAppear {
            if !PassKeyBiometry.canUseBiometrics() {
                biometricHint = "Biometrics unavailable — enter your pass key."
            }
        }
    }

    private func tryUnlockWithPin() {
        errorMessage = nil
        guard PassKeyStore.verifyPin(pin) else {
            attempts += 1
            pin = ""
            errorMessage = "Incorrect pass key."
            if attempts >= 5 {
                errorMessage = "Incorrect pass key. Tap Forgot if you need to reset (requires biometrics)."
            }
            return
        }
        pin = ""
        onUnlocked()
    }

    private func tryBiometricUnlock() {
        errorMessage = nil
        PassKeyBiometry.authenticate(reason: "Unlock Calculator") { success in
            if success {
                pin = ""
                onUnlocked()
            } else {
                errorMessage = "Biometric authentication failed."
            }
        }
    }

    private func startForgotFlow() {
        errorMessage = nil
        guard PassKeyBiometry.canUseBiometrics() else {
            errorMessage = "Biometrics not available. Reinstall the app or restore access on a device with Face ID / Touch ID."
            return
        }
        PassKeyBiometry.authenticate(reason: "Verify your identity to reset your pass key") { success in
            if success {
                onForgotReset()
            } else {
                errorMessage = "Could not verify identity."
            }
        }
    }
}
