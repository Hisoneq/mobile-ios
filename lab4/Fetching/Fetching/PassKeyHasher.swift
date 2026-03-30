import CryptoKit
import Foundation
import Security

enum PassKeyHasher {
    static let pinLength = 4...6

    static func normalize(_ pin: String) -> String? {
        let digits = pin.filter(\.isNumber)
        guard pinLength.contains(digits.count) else { return nil }
        return digits
    }

    static func randomSalt() -> Data {
        var bytes = [UInt8](repeating: 0, count: 16)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        precondition(status == errSecSuccess)
        return Data(bytes)
    }

    static func hash(pin: String, salt: Data) -> Data {
        var combined = salt
        combined.append(Data(pin.utf8))
        return Data(SHA256.hash(data: combined))
    }

    static func verify(pin: String, salt: Data, storedHash: Data) -> Bool {
        hash(pin: pin, salt: salt) == storedHash
    }
}
