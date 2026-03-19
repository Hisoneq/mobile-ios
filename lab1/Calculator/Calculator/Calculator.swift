import Foundation

enum Calculator {
    enum Error: LocalizedError {
        case divisionByZero
        case overflow
        case invalidInput

        var errorDescription: String? {
            switch self {
            case .divisionByZero: return "Деление на ноль"
            case .overflow: return "Переполнение"
            case .invalidInput: return "Ошибка ввода"
            }
        }
    }

    static func evaluate(left: Double, op: String, right: Double) -> Result<Double, Error> {
        switch op {
        case "+":
            let r = left + right
            guard r.isFinite else { return .failure(.overflow) }
            return .success(r)
        case "−", "-":
            let r = left - right
            guard r.isFinite else { return .failure(.overflow) }
            return .success(r)
        case "×", "*":
            let r = left * right
            guard r.isFinite else { return .failure(.overflow) }
            return .success(r)
        case "÷", "/":
            guard right != 0 else { return .failure(.divisionByZero) }
            let r = left / right
            guard r.isFinite else { return .failure(.overflow) }
            return .success(r)
        default:
            return .failure(.invalidInput)
        }
    }

    static func format(_ value: Double) -> String {
        if value.truncatingRemainder(dividingBy: 1) == 0, abs(value) < 1e12 {
            return String(Int(value))
        }
        return String(format: "%.6g", value)
    }
}
