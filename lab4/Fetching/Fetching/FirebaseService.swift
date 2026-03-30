import Foundation
import FirebaseFirestore

final class FirebaseService {
    static let shared = FirebaseService()
    private let db = Firestore.firestore()

    private var deviceId: String {
        if let id = UserDefaults.standard.string(forKey: "fetching_device_id") {
            return id
        }
        let id = UUID().uuidString
        UserDefaults.standard.set(id, forKey: "fetching_device_id")
        return id
    }

    private var themeRef: DocumentReference {
        db.collection("users").document(deviceId).collection("settings").document("theme")
    }

    private var historyRef: CollectionReference {
        db.collection("users").document(deviceId).collection("history")
    }

    func saveTheme(_ theme: ThemeModel) {
        let data: [String: Any] = [
            "bgR": theme.bgR, "bgG": theme.bgG, "bgB": theme.bgB,
            "accentR": theme.accentR, "accentG": theme.accentG, "accentB": theme.accentB,
            "textR": theme.textR, "textG": theme.textG, "textB": theme.textB,
            "updatedAt": Timestamp(date: Date())
        ]
        themeRef.setData(data) { error in
            if let error = error { print("Theme save error: \(error)") }
        }
    }

    func loadTheme(completion: @escaping (ThemeModel?) -> Void) {
        themeRef.getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                completion(nil)
                return
            }
            let theme = ThemeModel(
                bgR: data["bgR"] as? Double ?? 0.11,
                bgG: data["bgG"] as? Double ?? 0.11,
                bgB: data["bgB"] as? Double ?? 0.12,
                accentR: data["accentR"] as? Double ?? 1.0,
                accentG: data["accentG"] as? Double ?? 0.58,
                accentB: data["accentB"] as? Double ?? 0.0,
                textR: data["textR"] as? Double ?? 1.0,
                textG: data["textG"] as? Double ?? 1.0,
                textB: data["textB"] as? Double ?? 1.0
            )
            completion(theme)
        }
    }

    func saveHistoryItem(_ item: HistoryItem) {
        let data: [String: Any] = [
            "expression": item.expression,
            "result": item.result,
            "timestamp": Timestamp(date: item.timestamp)
        ]
        historyRef.document(item.id).setData(data) { error in
            if let error = error { print("History save error: \(error)") }
        }
    }

    func loadHistory(completion: @escaping ([HistoryItem]) -> Void) {
        historyRef.order(by: "timestamp", descending: true).limit(to: 100).getDocuments { snapshot, error in
            guard let docs = snapshot?.documents, error == nil else {
                completion([])
                return
            }
            let items = docs.compactMap { doc -> HistoryItem? in
                let data = doc.data()
                guard let expr = data["expression"] as? String,
                      let result = data["result"] as? String,
                      let ts = data["timestamp"] as? Timestamp else { return nil }
                return HistoryItem(id: doc.documentID, expression: expr, result: result, timestamp: ts.dateValue())
            }
            completion(items)
        }
    }
}
