import SwiftUI

/// Клавиатура как у калькулятора: цифры, точка, сброс, backspace.
struct KeyboardView: View {
    var onKey: (String) -> Void
    var onBackspace: () -> Void
    var onClear: () -> Void

    private let rows: [[String]] = [
        ["7", "8", "9"],
        ["4", "5", "6"],
        ["1", "2", "3"],
        [".", "0", "⌫"]
    ]

    var body: some View {
        VStack(spacing: 12) {
            ForEach(0..<rows.count, id: \.self) { rowIndex in
                HStack(spacing: 12) {
                    ForEach(rows[rowIndex], id: \.self) { key in
                        if key == "⌫" {
                            keyButton(key) { onBackspace() }
                        } else {
                            keyButton(key) { onKey(key) }
                        }
                    }
                }
            }
            Button("C") {
                onClear()
            }
            .font(.title2)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
            .background(Color.orange.opacity(0.8))
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding(8)
        .background(Color(white: 0.9))
    }

    private func keyButton(_ label: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.title2)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
