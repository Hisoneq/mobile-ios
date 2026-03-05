import Foundation

enum AppLocale: String, CaseIterable {
    case en = "en"
    case ru = "ru"
}

struct L10n {
    static var current: AppLocale {
        AppLocale(rawValue: UserDefaults.standard.string(forKey: "appLocale") ?? "ru") ?? .ru
    }

    static func set(_ locale: AppLocale) {
        UserDefaults.standard.set(locale.rawValue, forKey: "appLocale")
    }

    static func str(_ key: String) -> String {
        switch current {
        case .en: return en[key] ?? key
        case .ru: return ru[key] ?? key
        }
    }

    private static let en: [String: String] = [
        "app_name": "Timer",
        "sequences": "Sequences",
        "add": "Add",
        "edit": "Edit",
        "delete": "Delete",
        "name": "Name",
        "color": "Color",
        "phases": "Phases",
        "warmup": "Warmup",
        "work": "Work",
        "rest": "Rest",
        "cooldown": "Cooldown",
        "duration_sec": "Duration (sec)",
        "repetitions": "Repetitions",
        "rest_between": "Rest between (sec)",
        "remaining": "Remaining",
        "upcoming": "Upcoming",
        "pause": "Pause",
        "resume": "Resume",
        "start": "Start",
        "next": "Next",
        "prev": "Prev",
        "exit_cancel": "Exit & Cancel",
        "settings": "Settings",
        "theme": "Theme",
        "light": "Light",
        "dark": "Dark",
        "font_size": "Font size",
        "clear_data": "Clear all data",
        "language": "Language",
        "cancel": "Cancel",
        "save": "Save",
        "new_sequence": "New sequence",
        "sec": "sec"
    ]

    private static let ru: [String: String] = [
        "app_name": "Таймер",
        "sequences": "Последовательности",
        "add": "Добавить",
        "edit": "Изменить",
        "delete": "Удалить",
        "name": "Название",
        "color": "Цвет",
        "phases": "Фазы",
        "warmup": "Разминка",
        "work": "Работа",
        "rest": "Отдых",
        "cooldown": "Заминка",
        "duration_sec": "Длительность (сек)",
        "repetitions": "Повторения",
        "rest_between": "Отдых между (сек)",
        "remaining": "Осталось",
        "upcoming": "Далее",
        "pause": "Пауза",
        "resume": "Продолжить",
        "start": "Старт",
        "next": "Вперёд",
        "prev": "Назад",
        "exit_cancel": "Выход и отмена",
        "settings": "Настройки",
        "theme": "Тема",
        "light": "Светлая",
        "dark": "Тёмная",
        "font_size": "Размер шрифта",
        "clear_data": "Очистить все данные",
        "language": "Язык",
        "cancel": "Отмена",
        "save": "Сохранить",
        "new_sequence": "Новая последовательность",
        "sec": "сек"
    ]
}

func phaseKindName(_ k: PhaseKind) -> String {
    L10n.str(k.rawValue)
}
