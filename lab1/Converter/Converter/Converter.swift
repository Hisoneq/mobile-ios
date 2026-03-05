import Foundation

// Категория единиц
enum UnitCategory: String, CaseIterable {
    case distance = "Расстояние"
    case weight = "Вес"
    case currency = "Валюта"
}

// Единица измерения (название и коэффициент к базовой)
struct UnitItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let toBase: Double  // множитель к базовой единице (м, кг, USD)
    func hash(into hasher: inout Hasher) { hasher.combine(id) }
    static func == (lhs: UnitItem, rhs: UnitItem) -> Bool { lhs.id == rhs.id }
}

struct Converter {
    static let distanceUnits: [UnitItem] = [
        UnitItem(name: "м", toBase: 1),
        UnitItem(name: "км", toBase: 1000),
        UnitItem(name: "миля", toBase: 1609.34)
    ]

    static let weightUnits: [UnitItem] = [
        UnitItem(name: "кг", toBase: 1),
        UnitItem(name: "г", toBase: 0.001),
        UnitItem(name: "фунт", toBase: 0.453592)
    ]

    static let currencyUnits: [UnitItem] = [
        UnitItem(name: "USD", toBase: 1),
        UnitItem(name: "EUR", toBase: 1.08),
        UnitItem(name: "RUB", toBase: 0.011)
    ]

    static func units(for category: UnitCategory) -> [UnitItem] {
        switch category {
        case .distance: return distanceUnits
        case .weight: return weightUnits
        case .currency: return currencyUnits
        }
    }

    /// Конвертация: значение из единицы from в единицу to
    static func convert(value: Double, from: UnitItem, to: UnitItem, category: UnitCategory) -> Double {
        let units = units(for: category)
        guard units.contains(where: { $0.id == from.id }),
              units.contains(where: { $0.id == to.id }) else { return value }
        let inBase = value * from.toBase
        return inBase / to.toBase
    }
}
