import Foundation
import Security

enum PassKeyStoreError: Error {
    case invalidPinFormat
    case keychain(OSStatus)
}

enum PassKeyStore {
    private static let service = "lab4.Fetching.passkey"
    private static let hashAccount = "passkey.hash"
    private static let saltAccount = "passkey.salt"

    /// Hash + salt live in Keychain; use only for UX (e.g. skip setup screen) once Keychain seeded.
    static var isConfigured: Bool {
        loadHash() != nil && loadSalt() != nil
    }

    static func saveNewPassKey(_ pin: String) throws {
        guard let normalized = PassKeyHasher.normalize(pin) else { throw PassKeyStoreError.invalidPinFormat }
        let salt = PassKeyHasher.randomSalt()
        let hash = PassKeyHasher.hash(pin: normalized, salt: salt)
        try setData(hash, account: hashAccount)
        try setData(salt, account: saltAccount)
    }

    static func verifyPin(_ pin: String) -> Bool {
        guard let salt = loadSalt(), let hash = loadHash(),
              let normalized = PassKeyHasher.normalize(pin) else { return false }
        return PassKeyHasher.verify(pin: normalized, salt: salt, storedHash: hash)
    }

    static func clear() throws {
        try deleteItem(account: hashAccount)
        try deleteItem(account: saltAccount)
    }

    private static func loadHash() -> Data? { getData(account: hashAccount) }
    private static func loadSalt() -> Data? { getData(account: saltAccount) }

    private static func setData(_ data: Data, account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data,
            // Device-only, not iCloud-synced. Unlocked state avoids Keychain failures on simulators without a device passcode.
            kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        ]
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw PassKeyStoreError.keychain(status) }
    }

    private static func getData(account: String) -> Data? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var out: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &out)
        guard status == errSecSuccess, let data = out as? Data else { return nil }
        return data
    }

    private static func deleteItem(account: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw PassKeyStoreError.keychain(status)
        }
    }
}
