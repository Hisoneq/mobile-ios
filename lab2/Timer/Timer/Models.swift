import Foundation
import SwiftUI

enum PhaseKind: String, Codable, CaseIterable {
    case warmup
    case work
    case rest
    case cooldown
}

struct PhaseItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var kind: PhaseKind
    var durationSeconds: Int
}

struct TimerSequence: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var colorHex: String
    var phases: [PhaseItem]
    var repetitions: Int
    var restBetweenRepsSeconds: Int

    var color: Color {
        Color(hex: colorHex) ?? .blue
    }

    init(name: String, colorHex: String = "0000FF", phases: [PhaseItem] = Self.defaultPhases(), repetitions: Int = 3, restBetweenRepsSeconds: Int = 60) {
        self.name = name
        self.colorHex = colorHex
        self.phases = phases
        self.repetitions = repetitions
        self.restBetweenRepsSeconds = restBetweenRepsSeconds
    }

    static func defaultPhases() -> [PhaseItem] {
        [
            PhaseItem(kind: .warmup, durationSeconds: 60),
            PhaseItem(kind: .work, durationSeconds: 300),
            PhaseItem(kind: .rest, durationSeconds: 60),
            PhaseItem(kind: .work, durationSeconds: 300),
            PhaseItem(kind: .rest, durationSeconds: 60),
            PhaseItem(kind: .cooldown, durationSeconds: 60)
        ]
    }
}

extension Color {
    init?(hex: String) {
        var h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if h.hasPrefix("#") { h.removeFirst() }
        if h.count != 6 { return nil }
        let r = Double(Int(h.prefix(2), radix: 16) ?? 0) / 255
        let g = Double(Int(h.dropFirst(2).prefix(2), radix: 16) ?? 0) / 255
        let b = Double(Int(h.suffix(2), radix: 16) ?? 0) / 255
        self.init(red: r, green: g, blue: b)
    }

}

enum PresetColors {
    static let all: [(hex: String, name: String)] = [
        ("FF0000", "Red"), ("00FF00", "Green"), ("0000FF", "Blue"),
        ("FF8800", "Orange"), ("8800FF", "Purple")
    ]
}
