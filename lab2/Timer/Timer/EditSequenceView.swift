import SwiftUI

struct EditSequenceView: View {
    let sequence: TimerSequence?
    let onSave: (TimerSequence) -> Void
    let onCancel: () -> Void

    @AppStorage("fontScale") private var fontScale = 1.0
    @State private var name: String
    @State private var colorHex: String
    @State private var phases: [PhaseItem]
    @State private var repetitions: Int
    @State private var restBetweenReps: Int

    init(sequence: TimerSequence?, onSave: @escaping (TimerSequence) -> Void, onCancel: @escaping () -> Void) {
        self.sequence = sequence
        self.onSave = onSave
        self.onCancel = onCancel
        _name = State(initialValue: sequence?.name ?? "")
        _colorHex = State(initialValue: sequence?.colorHex ?? "0000FF")
        _phases = State(initialValue: sequence?.phases ?? TimerSequence.defaultPhases())
        _repetitions = State(initialValue: sequence?.repetitions ?? 3)
        _restBetweenReps = State(initialValue: sequence?.restBetweenRepsSeconds ?? 60)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    nameBlock
                    colorBlock
                    phasesBlock
                    numbersBlock
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationTitle(sequence == nil ? L10n.str("new_sequence") : L10n.str("edit"))
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(L10n.str("cancel")) { onCancel() }
                        .foregroundColor(.accentColor)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(L10n.str("save")) { doSave() }
                        .foregroundColor(.accentColor)
                        .fontWeight(.semibold)
                }
            }
            #if os(iOS)
            .toolbarBackground(.visible, for: .navigationBar)
            #endif
        }
        .foregroundColor(.primary)
    }

    private var nameBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(L10n.str("name"))
                .font(.system(size: 17 * fontScale, weight: .semibold))
                .foregroundColor(.primary)
            TextField("", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
        }
    }

    private var colorBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.str("color"))
                .font(.system(size: 17 * fontScale, weight: .semibold))
                .foregroundColor(.primary)
            HStack(spacing: 12) {
                ForEach(PresetColors.all, id: \.hex) { item in
                    let isSelected = colorHex == item.hex
                    Button {
                        colorHex = item.hex
                    } label: {
                        Circle()
                            .fill(Color(hex: item.hex) ?? .blue)
                            .frame(width: 40, height: 40)
                            .overlay(Circle().stroke(isSelected ? Color.accentColor : Color.clear, lineWidth: 3))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var phasesBlock: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(L10n.str("phases"))
                .font(.system(size: 17 * fontScale, weight: .semibold))
                .foregroundColor(.primary)
            VStack(spacing: 0) {
                ForEach(0..<phases.count, id: \.self) { i in
                    PhaseRowView(
                        phase: phases[i],
                        fontScale: fontScale,
                        duration: Binding(
                            get: { phases[i].durationSeconds },
                            set: { newVal in
                                var copy = phases
                                copy[i].durationSeconds = newVal
                                phases = copy
                            }
                        )
                    )
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    if i < phases.count - 1 {
                        Divider().padding(.leading, 12)
                    }
                }
            }
        }
    }

    private var numbersBlock: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(L10n.str("repetitions"))
                    .font(.system(size: 15 * fontScale))
                    .foregroundColor(.primary)
                Spacer()
                TextField("", value: $repetitions, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 70)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
            }
            .padding(12)

            HStack {
                Text(L10n.str("rest_between"))
                    .font(.system(size: 15 * fontScale))
                    .foregroundColor(.primary)
                Spacer()
                TextField("", value: $restBetweenReps, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 70)
                    #if os(iOS)
                    .keyboardType(.numberPad)
                    #endif
            }
            .padding(12)
        }
    }

    private func doSave() {
        var s = TimerSequence(
            name: name.isEmpty ? L10n.str("new_sequence") : name,
            colorHex: colorHex,
            phases: phases,
            repetitions: repetitions,
            restBetweenRepsSeconds: restBetweenReps
        )
        if let existing = sequence { s.id = existing.id }
        onSave(s)
    }
}

private struct PhaseRowView: View {
    let phase: PhaseItem
    let fontScale: Double
    @Binding var duration: Int

    var body: some View {
        HStack {
            Text(phaseKindName(phase.kind))
                .font(.system(size: 15 * fontScale))
                .foregroundColor(.primary)
            Spacer()
            TextField("", value: $duration, format: .number)
                .textFieldStyle(.roundedBorder)
                .frame(width: 60)
                #if os(iOS)
                .keyboardType(.numberPad)
                #endif
            Text(L10n.str("sec"))
                .foregroundColor(.secondary)
        }
    }
}
