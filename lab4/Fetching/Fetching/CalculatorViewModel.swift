import SwiftUI

final class CalculatorViewModel: ObservableObject {
    @Published var displayText: String = ""
    @Published var resultText: String = "0"
    @Published var errorMessage: String?
    @Published var theme: ThemeModel = .default
    @Published var showHistory = false
    @Published var showTheme = false

    private var pendingOp: String?
    private var pendingValue: Double?

    init() {
        loadTheme()
    }

    private var currentDisplayValue: Double {
        Double(displayText.replacingOccurrences(of: ",", with: ".")) ?? 0
    }

    func handleKey(_ key: String) {
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
            let formatted = Calculator.format(v)
            resultText = formatted
            displayText = ""
            pendingValue = v
            pendingOp = nil
            let expr = "\(Calculator.format(left)) \(op) \(Calculator.format(right))"
            saveHistoryItem(expression: expr, result: formatted)
        case .failure(let err):
            errorMessage = err.localizedDescription
        }
    }

    private func updateResultFromDisplay() {
        if displayText.isEmpty {
            resultText = "0"
        } else if let v = Double(displayText.replacingOccurrences(of: ",", with: ".")) {
            resultText = Calculator.format(v)
        }
    }

    private func saveHistoryItem(expression: String, result: String) {
        let item = HistoryItem(expression: expression, result: result)
        FirebaseService.shared.saveHistoryItem(item)
    }

    func saveTheme() {
        FirebaseService.shared.saveTheme(theme)
    }

    private func loadTheme() {
        FirebaseService.shared.loadTheme { [weak self] loaded in
            DispatchQueue.main.async {
                self?.theme = loaded ?? .default
            }
        }
    }
}
