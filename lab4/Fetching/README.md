# Lab 4 — Fetching + Pass Key & Biometrics (Step 4)

Отдельный проект от lab3: тот же калькулятор и Firebase, плюс Pass Key (PIN 4–6 цифр), Keychain, Face ID / Touch ID.

## Acceptance criteria

1. **Setup** — первый запуск после сплэша: создание и подтверждение Pass Key, сохранение в Keychain (хеш SHA256 + соль, не plaintext).
2. **Неверный / забыли** — сообщения при неверном PIN; «Forgot pass key?» → биометрия → установка нового PIN.
3. **Доступ** — калькулятор только после успешного unlock (PIN или биометрия).
4. **Смена** — меню **⋯ → Change pass key**: текущий PIN или биометрия, затем новый PIN дважды.
5. **Хранение** — `Security` Keychain, `kSecAttrAccessibleWhenUnlockedThisDeviceOnly`, только хеш + соль.
6. **Биометрия** — `LocalAuthentication`, ключ `NSFaceIDUsageDescription` в `Info.plist`.

## Открыть в Xcode

`lab4/Fetching/Fetching.xcodeproj`

## Bundle ID и Firebase

- **Bundle ID:** `lab4.Fetching` (в настройках target).
- В Firebase Console добавь **отдельное** iOS-приложение с этим bundle id и скачай **новый** `GoogleService-Info.plist` в папку `Fetching/` (замени файл; `GOOGLE_APP_ID` должен соответствовать приложению lab4, а не lab3).

## Тест биометрии (симулятор)

**Features → Face ID → Enrolled**, затем при запросе используй **Matching Face** / **Non-matching Face**.

## Структура (новые файлы)

- `PassKeyHasher.swift` — соль, SHA256, нормализация PIN.
- `PassKeyStore.swift` — Keychain read/write.
- `PassKeyBiometry.swift` — обёртка над `LAContext`.
- `PassKeySetupView.swift` / `PassKeyUnlockView.swift` / `PassKeyChangeView.swift`.

Остальное — как в lab3 (Firestore theme/history, FCM). См. исходный README lab3 для настройки Firestore и push.
