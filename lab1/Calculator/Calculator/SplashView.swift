import SwiftUI

struct SplashView: View {
    @State private var showCalculator = false

    var body: some View {
        Group {
            if showCalculator {
                ContentView()
                    .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            } else {
                VStack(spacing: 24) {
                    Image(systemName: "function")
                        .font(.system(size: 80))
                        .foregroundColor(.orange)
                    Text("Calculator")
                        .font(.largeTitle)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(red: 0.11, green: 0.11, blue: 0.12))
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showCalculator = true
                }
            }
        }
    }
}
