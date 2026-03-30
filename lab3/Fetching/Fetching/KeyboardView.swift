import SwiftUI

struct KeyboardView: View {
    var onKey: (String) -> Void
    let theme: ThemeModel

    private let rows: [[String]] = [
        ["C", "⌫", "÷", "×"],
        ["7", "8", "9", "−"],
        ["4", "5", "6", "+"],
        ["1", "2", "3", "="],
        [".", "0", "", ""]
    ]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                HStack(spacing: 10) {
                    ForEach(Array(rows[rowIndex].enumerated()), id: \.offset) { _, key in
                        if key.isEmpty {
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                        } else {
                            calcButton(key, row: rowIndex)
                        }
                    }
                }
            }
        }
        .padding(12)
        .background(theme.backgroundColor)
    }

    private func calcButton(_ label: String, row: Int) -> some View {
        let isOp = ["+", "−", "×", "÷", "="].contains(label)
        let isAction = ["C", "⌫"].contains(label)

        return Button {
            onKey(label)
        } label: {
            Text(label)
                .font(.system(size: 24, weight: isOp ? .medium : .regular))
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(backgroundColor(isOp: isOp, isAction: isAction))
                .foregroundColor(foregroundColor(isOp: isOp, isAction: isAction))
                .cornerRadius(12)
        }
        .buttonStyle(.plain)
    }

    private func backgroundColor(isOp: Bool, isAction: Bool) -> Color {
        if isAction { return Color(red: 0.65, green: 0.65, blue: 0.65) }
        if isOp { return theme.accentColor }
        return Color(red: 0.2, green: 0.2, blue: 0.2)
    }

    private func foregroundColor(isOp: Bool, isAction: Bool) -> Color {
        if isAction { return .black }
        return theme.textColor
    }
}
