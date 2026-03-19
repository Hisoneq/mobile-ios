import SwiftUI

struct SplashView: View {
    @State private var showMain = false

    private let bgColor = Color(red: 0.11, green: 0.12, blue: 0.15)
    private let titleColor = Color.white
    private let subtitleColor = Color(red: 0.7, green: 0.72, blue: 0.76)

    var body: some View {
        Group {
            if showMain {
                OrientationMonitorView()
            } else {
                VStack(spacing: 20) {
                    Text("Platform API")
                        .font(.largeTitle)
                        .foregroundColor(titleColor)
                    Text("Orientation")
                        .font(.title2)
                        .foregroundColor(subtitleColor)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(bgColor)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation { showMain = true }
            }
        }
    }
}
