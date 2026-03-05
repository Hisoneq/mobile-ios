import SwiftUI

struct SplashView: View {
    @State private var showMain = false

    var body: some View {
        Group {
            if showMain {
                MainListView()
            } else {
                VStack(spacing: 20) {
                    Text(L10n.str("app_name"))
                        .font(.largeTitle)
                        .foregroundColor(.primary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(white: 0.95))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation { showMain = true }
            }
        }
    }
}
