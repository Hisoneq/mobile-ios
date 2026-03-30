# Лаба 3 — Fetching (Step 3)

## Соответствие ТЗ

### 1. Theme customisation (параметры в облаке) ✅
- Тема: фон, акцент, текст (RGB)
- Сохранение в Firestore: `users/{deviceId}/settings/theme`
- Status bar: `UIStatusBarStyleLightContent` + фон темы через `ignoresSafeArea`

### 2. Push Notifications ✅
- Firebase Cloud Messaging (FCM)
- `UNUserNotificationCenter` + `registerForRemoteNotifications`
- `UIBackgroundModes: remote-notification`

### 3. Action history (load/save) ✅
- Сохранение в Firestore при каждом `=`
- Загрузка в History при открытии
- `users/{deviceId}/history`

---

## Настройка Firebase (обязательно)

### Шаг 1: Firebase Console

1. Открой [Firebase Console](https://console.firebase.google.com/)
2. Создай проект (или выбери существующий)
3. Добавь **iOS app**:
   - Bundle ID: `lab3.Fetching`
   - App nickname: Fetching
4. Скачай **GoogleService-Info.plist**
5. Перетащи `GoogleService-Info.plist` в папку `Fetching` в Xcode (в Project Navigator)
6. При добавлении отметь **Copy items if needed** и выбери target **Fetching**

### Шаг 2: Firestore

1. В Firebase Console: **Build → Firestore Database**
2. **Create database** (режим test для разработки)
3. Выбери регион (europe-west1 или ближайший)
4. **Rules** — для теста можно временно:
   ```
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId}/{document=**} {
         allow read, write: if true;
       }
     }
   }
   ```

### Шаг 3: Cloud Messaging (Push)

1. В Firebase Console: **Project Settings** (шестерёнка)
2. Вкладка **Cloud Messaging**
3. **Apple app configuration**:
   - Загрузи **APNs Authentication Key** (.p8) из Apple Developer
   - Или **APNs Certificates** (.p12)

#### Как получить APNs Key (рекомендуется)

1. [Apple Developer](https://developer.apple.com/account/) → **Certificates, Identifiers & Profiles**
2. **Keys** → **+** (Create a key)
3. Имя: `Fetching Push`
4. Включи **Apple Push Notifications service (APNs)**
5. **Continue** → **Register**
6. Скачай `.p8` (один раз, потом недоступен)
7. Запомни **Key ID**
8. В Firebase: **Upload** → выбери `.p8`, укажи Key ID и Team ID

### Шаг 4: Xcode — Firebase SDK

1. **File → Add Package Dependencies...**
2. URL: `https://github.com/firebase/firebase-ios-sdk`
3. **Add Package** → выбери:
   - **FirebaseFirestore**
   - **FirebaseMessaging**
   - **FirebaseAnalytics** (опционально, но часто нужен для Firebase)
4. Target: **Fetching**

### Шаг 5: Push Notifications capability

1. Выбери target **Fetching**
2. **Signing & Capabilities**
3. **+ Capability** → **Push Notifications**
4. **+ Capability** → **Background Modes** → включи **Remote notifications**

---

## Структура проекта

```
lab3/Fetching/
├── Fetching.xcodeproj
├── Fetching/
│   ├── FetchingApp.swift      # @main, Firebase init, FCM
│   ├── SplashView.swift
│   ├── ContentView.swift
│   ├── CalculatorViewModel.swift
│   ├── DisplayView.swift
│   ├── KeyboardView.swift
│   ├── Calculator.swift
│   ├── ThemeModel.swift
│   ├── ThemeEditorView.swift
│   ├── HistoryView.swift
│   ├── HistoryItem.swift
│   ├── FirebaseService.swift
│   ├── GoogleService-Info.plist  ← скачать из Firebase
│   └── Assets.xcassets
└── README.md
```

---

## Firestore структура

```
users/
  {deviceId}/
    settings/
      theme: { bgR, bgG, bgB, accentR, accentG, accentB, textR, textG, textB, updatedAt }
    history/
      {docId}: { expression, result, timestamp }
```

---

## Тестирование Push

1. Собери и запусти на **реальном устройстве** (симулятор не поддерживает push)
2. Разреши уведомления при запросе
3. В Firebase Console: **Engage → Messaging → Create your first campaign**
4. Или через REST API с FCM Server Key (в Project Settings → Cloud Messaging)

---

## Открытие в Xcode

File → Open → `lab3/Fetching/Fetching.xcodeproj`
