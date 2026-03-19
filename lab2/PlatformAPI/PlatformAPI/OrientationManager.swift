import Foundation
import UIKit

final class OrientationManager: ObservableObject {
    @Published var orientationName: String = "Unknown"
    @Published var changeCount: Int = 0

    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    private var lastOrientation: UIDeviceOrientation = .unknown
    private var observer: NSObjectProtocol?

    func start() {
        impactFeedback.prepare()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        updateOrientation(UIDevice.current.orientation)

        observer = NotificationCenter.default.addObserver(
            forName: UIDevice.orientationDidChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.handleOrientationChange()
        }
    }

    func stop() {
        UIDevice.current.endGeneratingDeviceOrientationNotifications()
        if let o = observer {
            NotificationCenter.default.removeObserver(o)
        }
    }

    private func handleOrientationChange() {
        let orientation = UIDevice.current.orientation
        guard orientation != lastOrientation, orientation != .unknown else { return }
        lastOrientation = orientation
        changeCount += 1
        impactFeedback.impactOccurred()
        updateOrientation(orientation)
    }

    private func updateOrientation(_ orientation: UIDeviceOrientation) {
        orientationName = name(for: orientation)
    }

    private func name(for orientation: UIDeviceOrientation) -> String {
        switch orientation {
        case .portrait: return "Portrait"
        case .portraitUpsideDown: return "Portrait\nUpside Down"
        case .landscapeLeft: return "Landscape\nLeft"
        case .landscapeRight: return "Landscape\nRight"
        case .faceUp: return "Face Up"
        case .faceDown: return "Face Down"
        default: return "Unknown"
        }
    }
}
