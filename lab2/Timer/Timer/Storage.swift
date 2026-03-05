import Foundation
import Combine

final class TimerStorage: ObservableObject {
    static let shared = TimerStorage()
    private let key = "timer_sequences"

    @Published var sequences: [TimerSequence] = [] {
        didSet { save() }
    }

    private init() {
        load()
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([TimerSequence].self, from: data) else {
            sequences = []
            return
        }
        sequences = decoded
    }

    private func save() {
        guard let data = try? JSONEncoder().encode(sequences) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    func add(_ s: TimerSequence) {
        sequences.append(s)
    }

    func update(_ s: TimerSequence) {
        if let i = sequences.firstIndex(where: { $0.id == s.id }) {
            sequences[i] = s
        }
    }

    func delete(_ s: TimerSequence) {
        sequences.removeAll { $0.id == s.id }
    }

    func clearAll() {
        sequences = []
    }
}
