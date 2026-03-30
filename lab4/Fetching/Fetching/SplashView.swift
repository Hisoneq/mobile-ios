import SwiftUI

struct SplashView: View {
    private enum LaunchPhase: Equatable {
        case splash
        case passKeySetup(isReset: Bool)
        case passKeyUnlock
        case main
    }

    @State private var phase: LaunchPhase = .splash
    @State private var theme: ThemeModel = .default

    var body: some View {
        ZStack {
            theme.backgroundColor.ignoresSafeArea()

            Group {
                switch phase {
                case .splash:
                    splashContent
                case .passKeySetup(let isReset):
                    PassKeySetupView(isReset: isReset, theme: theme) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            phase = .main
                        }
                    }
                case .passKeyUnlock:
                    PassKeyUnlockView(
                        theme: theme,
                        onUnlocked: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                phase = .main
                            }
                        },
                        onForgotReset: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                phase = .passKeySetup(isReset: true)
                            }
                        }
                    )
                case .main:
                    ContentView()
                }
            }
        }
        .onAppear {
            loadThemeThenProceed()
        }
    }

    private var splashContent: some View {
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

    private func loadThemeThenProceed() {
        FirebaseService.shared.loadTheme { loaded in
            if let t = loaded {
                DispatchQueue.main.async {
                    theme = t
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if PassKeyStore.isConfigured {
                        phase = .passKeyUnlock
                    } else {
                        phase = .passKeySetup(isReset: false)
                    }
                }
            }
        }
    }
}
