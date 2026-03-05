import SwiftUI

struct SettingsView: View {
    @AppStorage("isDark") private var isDark = false
    @AppStorage("fontScale") private var fontScale = 1.0
    @AppStorage("appLocale") private var appLocaleRaw = "ru"
    @EnvironmentObject var storage: TimerStorage
    @Environment(\.dismiss) private var dismiss

    private var appLocale: AppLocale {
        get { AppLocale(rawValue: appLocaleRaw) ?? .ru }
        set { appLocaleRaw = newValue.rawValue }
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text(L10n.str("theme")).font(.system(size: 15 * fontScale))) {
                    Picker("", selection: $isDark) {
                        Text(L10n.str("light")).tag(false)
                        Text(L10n.str("dark")).tag(true)
                    }
                    .pickerStyle(.segmented)
                }
                Section(header: Text(L10n.str("font_size")).font(.system(size: 15 * fontScale))) {
                    Slider(value: $fontScale, in: 0.7...1.8, step: 0.1)
                    Text("\(Int(fontScale * 100))%")
                    .font(.system(size: 15 * fontScale))
                }
                Section(header: Text(L10n.str("language")).font(.system(size: 15 * fontScale))) {
                    Picker("", selection: $appLocaleRaw) {
                        Text("English").tag("en")
                        Text("Русский").tag("ru")
                    }
                    .pickerStyle(.segmented)
                }
                Section {
                    Button(L10n.str("clear_data")) {
                        storage.clearAll()
                        dismiss()
                    }
                    .foregroundColor(.red)
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(L10n.str("settings"))
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.str("save")) { dismiss() }
                }
            }
        }
    }
}
