import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

struct ContentView: View {
    @State private var category: UnitCategory = .distance
    @State private var sourceUnit: UnitItem = Converter.distanceUnits[0]
    @State private var resultUnit: UnitItem = Converter.distanceUnits[1]
    @State private var sourceText: String = ""

    private var unitList: [UnitItem] { Converter.units(for: category) }
    private var sourceValue: Double { Double(sourceText.replacingOccurrences(of: ",", with: ".")) ?? 0 }
    private var resultValue: Double {
        Converter.convert(value: sourceValue, from: sourceUnit, to: resultUnit, category: category)
    }
    private var resultText: String {
        if sourceText.isEmpty { return "" }
        let v = resultValue
        if v == floor(v) && abs(v) < 1e10 { return String(Int(v)) }
        return String(format: "%.4f", v)
    }

    var body: some View {
        GeometryReader { geo in
            let isPortrait = geo.size.height > geo.size.width
            if isPortrait {
                VStack(spacing: 0) {
                    dataBlock
                    keyboardBlock
                }
            } else {
                HStack(spacing: 0) {
                    dataBlock
                    keyboardBlock
                }
            }
        }
        .ignoresSafeArea(.keyboard)
    }

    private var dataBlock: some View {
        DataView(
            sourceText: sourceText,
            resultText: resultText,
            category: category,
            sourceUnit: sourceUnit,
            resultUnit: resultUnit,
            onCategoryChange: { newCat in
                category = newCat
                let u = Converter.units(for: newCat)
                sourceUnit = u[0]
                resultUnit = u.count > 1 ? u[1] : u[0]
            },
            onSourceUnitChange: { sourceUnit = $0 },
            onResultUnitChange: { resultUnit = $0 },
            onSwap: swapAction,
            onCopySource: copySourceAction,
            onCopyResult: copyResultAction
        )
    }

    private var keyboardBlock: some View {
        KeyboardView(
            onKey: { key in
                if key == "." {
                    if sourceText.contains(".") { return }
                    if sourceText.isEmpty { sourceText = "0."; return }
                }
                if sourceText == "0" && key != "." { sourceText = key; return }
                sourceText += key
            },
            onBackspace: {
                if !sourceText.isEmpty { sourceText.removeLast() }
            },
            onClear: { sourceText = "" }
        )
    }

#if PREMIUM
    private func swapAction() {
        let oldResult = resultText
        swap(&sourceUnit, &resultUnit)
        sourceText = oldResult
    }
    private func copySourceAction() {
        UIPasteboard.general.string = sourceText.isEmpty ? "0" : sourceText
    }
    private func copyResultAction() {
        UIPasteboard.general.string = resultText.isEmpty ? "0" : resultText
    }
#else
    private func swapAction() { }
    private func copySourceAction() { }
    private func copyResultAction() { }
#endif
}
