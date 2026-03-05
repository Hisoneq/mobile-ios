import SwiftUI

struct DataView: View {
    let sourceText: String
    let resultText: String
    let category: UnitCategory
    let sourceUnit: UnitItem
    let resultUnit: UnitItem
    let onCategoryChange: (UnitCategory) -> Void
    let onSourceUnitChange: (UnitItem) -> Void
    let onResultUnitChange: (UnitItem) -> Void
    var onSwap: (() -> Void)?
    var onCopySource: (() -> Void)?
    var onCopyResult: (() -> Void)?

    private let units = Converter.self

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Категория")
                .font(.headline)
                .foregroundColor(.black)
            HStack(spacing: 8) {
                ForEach(UnitCategory.allCases, id: \.self) { cat in
                    Button(cat.rawValue) {
                        onCategoryChange(cat)
                    }
                    .buttonStyle(.bordered)
                    .tint(category == cat ? .blue : .gray)
                }
            }

            Text("Перевод: из \(sourceUnit.name) в \(resultUnit.name)")
                .font(.subheadline)
                .foregroundColor(.black.opacity(0.8))

            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Исходное")
                        .font(.caption)
                        .foregroundColor(.black)
                    HStack {
                        Text(sourceText.isEmpty ? "0" : sourceText)
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(Color(white: 0.95))
                            .cornerRadius(8)
#if PREMIUM
                        if let copy = onCopySource {
                            Button(action: copy) {
                                Image(systemName: "doc.on.doc")
                            }
                        }
#endif
                    }
                    Picker("", selection: Binding(
                        get: { sourceUnit },
                        set: { onSourceUnitChange($0) }
                    )) {
                        ForEach(units.units(for: category)) { u in
                            Text(u.name).tag(u)
                        }
                    }
                    .pickerStyle(.menu)
                }

#if PREMIUM
                if onSwap != nil {
                    Button(action: { onSwap?() }) {
                        Image(systemName: "arrow.left.arrow.right")
                    }
                    .font(.title2)
                }
#endif

                VStack(alignment: .leading, spacing: 4) {
                    Text("Результат")
                        .font(.caption)
                        .foregroundColor(.black)
                    HStack {
                        Text(resultText.isEmpty ? "0" : resultText)
                            .font(.title2)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(8)
                            .background(Color(white: 0.95))
                            .cornerRadius(8)
#if PREMIUM
                        if let copy = onCopyResult {
                            Button(action: copy) {
                                Image(systemName: "doc.on.doc")
                            }
                        }
#endif
                    }
                    Picker("", selection: Binding(
                        get: { resultUnit },
                        set: { onResultUnitChange($0) }
                    )) {
                        ForEach(units.units(for: category)) { u in
                            Text(u.name).tag(u)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
        }
        .foregroundColor(.black)
        .padding()
        .background(Color(white: 1))
    }
}
