import Foundation
import LocalAuthentication

enum PassKeyBiometry {
    static var biometryTitle: String {
        let context = LAContext()
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        switch context.biometryType {
        case .faceID: return "Use Face ID"
        case .touchID: return "Use Touch ID"
        case .none: return "Use Biometrics"
        @unknown default: return "Use Biometrics"
        }
    }

    static func authenticate(reason: String, completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            DispatchQueue.main.async { completion(false) }
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, _ in
            DispatchQueue.main.async {
                completion(success)
            }
        }
    }

    static func canUseBiometrics() -> Bool {
        let context = LAContext()
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}
