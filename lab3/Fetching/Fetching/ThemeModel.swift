import SwiftUI

struct ThemeModel: Codable, Equatable {
    var bgR: Double
    var bgG: Double
    var bgB: Double
    var accentR: Double
    var accentG: Double
    var accentB: Double
    var textR: Double
    var textG: Double
    var textB: Double

    static let `default` = ThemeModel(
        bgR: 0.11, bgG: 0.11, bgB: 0.12,
        accentR: 1.0, accentG: 0.58, accentB: 0.0,
        textR: 1.0, textG: 1.0, textB: 1.0
    )

    var backgroundColor: Color {
        Color(red: bgR, green: bgG, blue: bgB)
    }

    var accentColor: Color {
        Color(red: accentR, green: accentG, blue: accentB)
    }

    var textColor: Color {
        Color(red: textR, green: textG, blue: textB)
    }
}
