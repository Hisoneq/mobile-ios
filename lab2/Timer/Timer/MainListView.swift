import SwiftUI

struct MainListView: View {
    @EnvironmentObject var storage: TimerStorage
    @AppStorage("fontScale") private var fontScale = 1.0
    @State private var showAdd = false
    @State private var editingSequence: TimerSequence?
    @State private var runningSequence: TimerSequence?

    var body: some View {
        NavigationStack {
            List {
                ForEach(storage.sequences) { seq in
                    SequenceRowView(
                        seq: seq,
                        fontScale: fontScale,
                        onEdit: { editingSequence = seq },
                        onDelete: { storage.delete(seq) },
                        onStart: { runningSequence = seq }
                    )
                }
                }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .navigationTitle(L10n.str("sequences"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(L10n.str("add")) { showAdd = true }
                }
                ToolbarItem(placement: .cancellationAction) {
                    NavigationLink(destination: SettingsView()) {
                        Text(L10n.str("settings"))
                    }
                }
            }
            .sheet(isPresented: $showAdd) {
                EditSequenceView(sequence: nil) { newSeq in
                    storage.add(newSeq)
                    showAdd = false
                } onCancel: { showAdd = false }
            }
            .sheet(item: $editingSequence) { seq in
                EditSequenceView(sequence: seq) { updated in
                    storage.update(updated)
                    editingSequence = nil
                } onCancel: { editingSequence = nil }
            }
            .sheet(item: $runningSequence) { seq in
                TimerView(sequence: seq) {
                    runningSequence = nil
                }
            }
        }
        .foregroundColor(.primary)
    }
}

private struct SequenceRowView: View {
    let seq: TimerSequence
    let fontScale: Double
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onStart: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(seq.color)
                .frame(width: 14, height: 14)
            Text(seq.name.isEmpty ? L10n.str("new_sequence") : seq.name)
                .font(.system(size: 17 * fontScale))
                .foregroundColor(.primary)
            Spacer(minLength: 8)
            Button(L10n.str("start")) { onStart() }
                .buttonStyle(.borderedProminent)
            Button(L10n.str("edit")) { onEdit() }
                .buttonStyle(.bordered)
            Button(L10n.str("delete")) { onDelete() }
                .buttonStyle(.bordered)
                .tint(.red)
        }
        .padding(.vertical, 4)
    }
}

extension TimerSequence: Hashable {
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
}
