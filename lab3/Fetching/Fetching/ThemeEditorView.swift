import SwiftUI

struct ThemeEditorView: View {
    @Binding var theme: ThemeModel
    let onSave: () -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var bgR = 0.11
    @State private var bgG = 0.11
    @State private var bgB = 0.12
    @State private var accentR = 1.0
    @State private var accentG = 0.58
    @State private var accentB = 0.0

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: bgR, green: bgG, blue: bgB).ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Background")
                                .font(.headline)
                                .foregroundColor(.white)
                            ColorSlider(value: $bgR, color: .red)
                            ColorSlider(value: $bgG, color: .green)
                            ColorSlider(value: $bgB, color: .blue)
                        }

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Accent")
                                .font(.headline)
                                .foregroundColor(.white)
                            ColorSlider(value: $accentR, color: .red)
                            ColorSlider(value: $accentG, color: .green)
                            ColorSlider(value: $accentB, color: .blue)
                        }

                        Button("Save to Cloud") {
                            commitThemeFromSliders()
                            onSave()
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                        .frame(maxWidth: .infinity)
                    }
                    .padding()
                }
            }
            .navigationTitle("Theme")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.white.opacity(0.9))
                }
            }
            .onAppear {
                syncFromTheme()
            }
        }
    }

    private func syncFromTheme() {
        bgR = theme.bgR
        bgG = theme.bgG
        bgB = theme.bgB
        accentR = theme.accentR
        accentG = theme.accentG
        accentB = theme.accentB
    }

    private func commitThemeFromSliders() {
        theme = ThemeModel(
            bgR: bgR, bgG: bgG, bgB: bgB,
            accentR: accentR, accentG: accentG, accentB: accentB,
            textR: theme.textR, textG: theme.textG, textB: theme.textB
        )
    }
}

private struct ColorSlider: View {
    @Binding var value: Double
    let color: Color

    var body: some View {
        HStack {
            Text(String(format: "%.2f", value))
                .frame(width: 40)
                .foregroundColor(.white)
            Slider(value: $value, in: 0...1)
                .tint(color)
        }
    }
}
