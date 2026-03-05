import Foundation
import Combine

/// Строит плоский список фаз с учётом повторений и отдыха между ними.
func buildFlatPhases(from sequence: TimerSequence) -> [(phase: PhaseItem, label: String)] {
    var result: [(PhaseItem, String)] = []
    for rep in 0..<sequence.repetitions {
        for (_, p) in sequence.phases.enumerated() {
            result.append((p, "\(phaseKindName(p.kind)) \(rep + 1)"))
        }
        if rep < sequence.repetitions - 1 {
            result.append((PhaseItem(kind: .rest, durationSeconds: sequence.restBetweenRepsSeconds), L10n.str("rest")))
        }
    }
    return result
}

import AudioToolbox

func playPhaseChangeSound() {
    AudioServicesPlaySystemSound(1057)
}
