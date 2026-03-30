import SwiftUI

struct SplashView: View {
    @State private var showCalculator = false
    @State private var theme: ThemeModel = .default

    var body: some View {
        ZStack {
            theme.backgroundColor.ignoresSafeArea()

            Group {
                if showCalculator {
                    ContentView()
                } else {
                    VStack(spacing: 24) {
                        Image(systemName: "function")
                            .font(.system(size: 80))
                            .foregroundColor(theme.accentColor)
                        Text("Calculator")
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundColor(theme.textColor)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onAppear {
            loadThemeThenShow()
        }
    }

    private func loadThemeThenShow() {
        FirebaseService.shared.loadTheme { loaded in
            if let t = loaded {
                theme = t
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showCalculator = true
                }
            }
        }
    }
}
