import SwiftUI

struct ContentView: View {
    @State private var displayText: String = ""
    @State private var resultText: String = "0"
    @State private var errorMessage: String?
    @State private var pendingOp: String?
    @State private var pendingValue: Double?

    var body: some View {
        GeometryReader { geo in
            let isPortrait = geo.size.height > geo.size.width
            let compactHeight = geo.size.height < 500
            Group {
                if isPortrait {
                    VStack(spacing: 0) {
                        displayBlock
                            .frame(maxHeight: compactHeight ? 100 : .infinity)
                        keyboardBlock
                            .frame(maxHeight: .infinity)
                    }
                } else {
                    HStack(spacing: 0) {
                        displayBlock
                            .frame(maxWidth: .infinity)
                        keyboardBlock
                            .frame(maxWidth: min(geo.size.width * 0.55, 360))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.11, green: 0.11, blue: 0.12))
        }
        .ignoresSafeArea(.keyboard)
    }

    private var displayBlock: some View {
        DisplayView(
            displayText: displayText,
            resultText: resultText,
            errorMessage: errorMessage
        )
    }

    private var keyboardBlock: some View {
        KeyboardView(onKey: handleKey)
    }

    private func handleKey(_ key: String) {
        errorMessage = nil

        switch key {
        case "C":
            displayText = ""
            resultText = "0"
            pendingOp = nil
            pendingValue = nil

        case "⌫":
            if !displayText.isEmpty {
                displayText.removeLast()
                updateResultFromDisplay()
            }

        case "+", "−", "×", "÷":
            handleOperator(key)

        case "=":
            handleEquals()

        case ".", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            if key == "." {
                if displayText.contains(".") { return }
                if displayText.isEmpty { displayText = "0" }
            }
            if displayText == "0" && key != "." { displayText = "" }
            displayText += key
            updateResultFromDisplay()

        default:
            break
        }
    }

    private func handleOperator(_ op: String) {
        let val = currentDisplayValue
        if let pending = pendingOp, let left = pendingValue {
            let result = Calculator.evaluate(left: left, op: pending, right: val)
            switch result {
            case .success(let v):
                resultText = Calculator.format(v)
                pendingValue = v
                displayText = ""
            case .failure(let err):
                errorMessage = err.localizedDescription
                return
            }
        } else {
            pendingValue = val
            displayText = ""
        }
        pendingOp = op
    }

    private func handleEquals() {
        guard let op = pendingOp, let left = pendingValue else {
            resultText = displayText.isEmpty ? "0" : displayText
            return
        }
        let right = currentDisplayValue
        let result = Calculator.evaluate(left: left, op: op, right: right)
        switch result {
        case .success(let v):
            resultText = Calculator.format(v)
            displayText = ""
            pendingValue = v
            pendingOp = nil
        case .failure(let err):
            errorMessage = err.localizedDescription
        }
    }

    private var currentDisplayValue: Double {
        Double(displayText.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    private func updateResultFromDisplay() {
        if displayText.isEmpty {
            resultText = "0"
        } else if let v = Double(displayText.replacingOccurrences(of: ",", with: ".")) {
            resultText = Calculator.format(v)
        }
    }
}
