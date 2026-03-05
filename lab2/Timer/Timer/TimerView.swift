import SwiftUI
import Combine

struct TimerView: View {
    let sequence: TimerSequence
    let onExit: () -> Void

    @State private var flatPhases: [(phase: PhaseItem, label: String)] = []
    @State private var currentIndex: Int = 0
    @State private var remainingSeconds: Int = 0
    @State private var isPaused: Bool = false
    @State private var phaseEndDate: Date?
    @State private var timerSubscription: AnyCancellable?
    @Environment(\.scenePhase) private var scenePhase
    @AppStorage("fontScale") private var fontScale = 1.0

    private var currentPhase: PhaseItem? {
        guard currentIndex >= 0, currentIndex < flatPhases.count else { return nil }
        return flatPhases[currentIndex].phase
    }

    var body: some View {
        VStack(spacing: 24) {
            Text(sequence.name)
                .font(.system(size: 22 * fontScale))
                .foregroundColor(.primary)

            if currentPhase != nil {
                Text(L10n.str("remaining"))
                    .font(.system(size: 14 * fontScale))
                    .foregroundColor(.primary)
                Text("\(remainingSeconds) \(L10n.str("sec"))")
                    .font(.system(size: 48 * fontScale))
                    .foregroundColor(.primary)
                Text(flatPhases[currentIndex].label)
                    .font(.system(size: 17 * fontScale))
                    .foregroundColor(.primary)
            }

            Divider()

            Text(L10n.str("upcoming"))
                .font(.system(size: 17 * fontScale))
                .foregroundColor(.primary)
            List {
                ForEach(Array(flatPhases.enumerated().dropFirst(currentIndex + 1)), id: \.offset) { _, item in
                    Text("\(item.label) — \(item.phase.durationSeconds) \(L10n.str("sec"))")
                        .font(.system(size: 15 * fontScale))
                        .foregroundColor(.primary)
                }
            }
            .frame(maxHeight: 200)

            HStack(spacing: 16) {
                Button(L10n.str("prev")) {
                    goPrev()
                }
                .disabled(currentIndex <= 0)

                if isPaused {
                    Button(L10n.str("resume")) {
                        startPhaseCountdown()
                        isPaused = false
                    }
                } else {
                    Button(L10n.str("pause")) {
                        timerSubscription?.cancel()
                        phaseEndDate = nil
                        isPaused = true
                    }
                }

                Button(L10n.str("next")) {
                    goNext()
                }
                .disabled(currentIndex >= flatPhases.count - 1)

                Button(L10n.str("exit_cancel")) {
                    timerSubscription?.cancel()
                    onExit()
                }
                .foregroundColor(.red)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.96))
        .onAppear {
            flatPhases = buildFlatPhases(from: sequence)
            if flatPhases.isEmpty { return }
            currentIndex = 0
            remainingSeconds = flatPhases[0].phase.durationSeconds
            startPhaseCountdown()
        }
        .onDisappear {
            timerSubscription?.cancel()
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background { saveState() }
            if newPhase == .active { restoreState() }
        }
    }

    private func saveState() {
        guard !isPaused, let end = phaseEndDate else { return }
        UserDefaults.standard.set(end.timeIntervalSince1970, forKey: "timer_phase_end")
        UserDefaults.standard.set(currentIndex, forKey: "timer_phase_index")
        UserDefaults.standard.set(sequence.id.uuidString, forKey: "timer_sequence_id")
    }

    private func restoreState() {
        guard sequence.id.uuidString == UserDefaults.standard.string(forKey: "timer_sequence_id") else { return }
        let end = Date(timeIntervalSince1970: UserDefaults.standard.double(forKey: "timer_phase_end"))
        let idx = UserDefaults.standard.integer(forKey: "timer_phase_index")
        guard end > Date(), idx >= 0, idx < flatPhases.count else { return }
        currentIndex = idx
        remainingSeconds = max(0, Int(end.timeIntervalSince(Date())))
        phaseEndDate = end
        if !isPaused { startPhaseCountdown() }
    }

    private func startPhaseCountdown() {
        timerSubscription?.cancel()
        let end = Date().addingTimeInterval(TimeInterval(remainingSeconds))
        phaseEndDate = end
        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                let left = max(0, Int(end.timeIntervalSince(Date())))
                remainingSeconds = left
                if left <= 0 {
                    timerSubscription?.cancel()
                    playPhaseChangeSound()
                    goNext()
                }
            }
    }

    private func goNext() {
        timerSubscription?.cancel()
        if currentIndex < flatPhases.count - 1 {
            currentIndex += 1
            remainingSeconds = flatPhases[currentIndex].phase.durationSeconds
            if !isPaused { startPhaseCountdown() }
            playPhaseChangeSound()
        } else {
            onExit()
        }
    }

    private func goPrev() {
        timerSubscription?.cancel()
        if currentIndex > 0 {
            currentIndex -= 1
            remainingSeconds = flatPhases[currentIndex].phase.durationSeconds
            if !isPaused { startPhaseCountdown() }
            playPhaseChangeSound()
        }
    }
}
