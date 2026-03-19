import SwiftUI

struct OrientationMonitorView: View {
    @StateObject private var orientationManager = OrientationManager()

    private let bgColor = Color(red: 0.11, green: 0.12, blue: 0.15)
    private let titleColor = Color.white
    private let accentColor = Color(red: 0.4, green: 0.7, blue: 1.0)
    private let subtitleColor = Color(red: 0.7, green: 0.72, blue: 0.76)

    var body: some View {
        VStack(spacing: 32) {
            Text("Orientation")
                .font(.title)
                .foregroundColor(titleColor)

            Text(orientationManager.orientationName)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(accentColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Text("Rotate device to see changes")
                .font(.subheadline)
                .foregroundColor(subtitleColor)

            Text("Changes: \(orientationManager.changeCount)")
                .font(.caption)
                .foregroundColor(subtitleColor.opacity(0.9))

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(bgColor)
        .onAppear {
            orientationManager.start()
        }
        .onDisappear {
            orientationManager.stop()
        }
    }
}
