import SwiftUI
import Combine

@main
struct TimerApp: App {
    @AppStorage("isDark") private var isDark = false
    @AppStorage("fontScale") private var fontScale = 1.0
    @AppStorage("appLocale") private var appLocale = "ru"
    @StateObject private var storage = TimerStorage.shared

    var body: some Scene {
        WindowGroup {
            SplashView()
                .id(appLocale)
                .environmentObject(storage)
                .preferredColorScheme(isDark ? .dark : .light)
        }
    }
}
