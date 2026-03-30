import Foundation

struct HistoryItem: Codable, Identifiable {
    var id: String
    var expression: String
    var result: String
    var timestamp: Date

    init(id: String = UUID().uuidString, expression: String, result: String, timestamp: Date = Date()) {
        self.id = id
        self.expression = expression
        self.result = result
        self.timestamp = timestamp
    }
}
