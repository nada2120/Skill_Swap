# SkillSwap

**SkillSwap** is a cross-platform skill-sharing and mentorship application built with Flutter. It connects users who want to exchange knowledge through text chats, video calls, and scheduled sessions. The app features real-time messaging (via Pusher), AI-powered skill verification quizzes (via Google Gemini), session booking & management, a gamified leaderboard, an in-app store, push notifications, and multi-language support.

---

## Repository Structure

```
/
├── src/           → Full Flutter source code (all platform targets)
├── exe/           → Pre-built executable files (Windows installer)
├── .gitignore
└── README.md
```

---

## Table of Contents

- [Prerequisites and Dependencies](#prerequisites-and-dependencies)
- [Installation Steps (Source Code)](#installation-steps)
- [Compilation Steps](#compilation-steps)
- [Run Instructions](#run-instructions)
- [Environment Setup & Configuration](#environment-setup--configuration)
- [Pre-Built Executable Setup](#pre-built-executable-setup)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)

---

## Prerequisites and Dependencies

### Programming Languages & Versions

| Language   | Version                |
|------------|------------------------|
| **Dart**   | `>= 3.3.0 < 4.0.0`   |
| **Kotlin** | JDK 8 target (Android) |

### Frameworks

| Framework       | Version                                   |
|-----------------|-------------------------------------------|
| **Flutter SDK** | `>= 3.19.0` (stable channel recommended) |

> **Verify with:** `flutter --version` and `dart --version`

### Required Software & Tools

| Tool                              | Purpose                                   | Download                                                                   |
|-----------------------------------|-------------------------------------------|----------------------------------------------------------------------------|
| **Flutter SDK**                   | Core framework                            | [flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) |
| **Android Studio**                | Android build toolchain & emulators       | [developer.android.com/studio](https://developer.android.com/studio)       |
| **Android SDK**                   | Compile SDK 36, NDK `28.2.13676358`       | Installed via Android Studio SDK Manager                                   |
| **Visual Studio** *(Windows only)* | Windows desktop builds (C++ workload)    | [visualstudio.microsoft.com](https://visualstudio.microsoft.com/)          |
| **Git**                           | Version control                           | [git-scm.com](https://git-scm.com/)                                       |
| **Firebase CLI**                  | Firebase project management               | `npm install -g firebase-tools`                                            |
| **FlutterFire CLI**               | Firebase configuration for Flutter        | `dart pub global activate flutterfire_cli`                                 |

### System Requirements

| Platform    | Minimum Requirements                                    |
|-------------|--------------------------------------------------------|
| **Windows** | Windows 10 or later, 8 GB RAM, 1 GB disk space        |
| **Android** | Min SDK set by Flutter (API 21+), Target SDK 36        |

### External Services & APIs

| Service                   | Purpose                                                            | Required |
|---------------------------|--------------------------------------------------------------------|----------|
| **SkillSwap Backend API** | Core REST API (`https://skill-swaapp.vercel.app`)                  | ✅ Yes   |
| **Firebase**              | Authentication, Cloud Firestore (WebRTC signaling), Push Notifications (FCM) | ✅ Yes   |
| **Pusher Channels**       | Real-time messaging (App Key: configured in code, Cluster: `mt1`) | ✅ Yes   |
| **Google Gemini AI**      | AI-powered skill verification quizzes                              | ✅ Yes   |

### Key Flutter Packages

<details>
<summary>Click to expand full dependency list</summary>

**State Management:**
- `flutter_bloc` / `bloc` — BLoC pattern
- `get` — Navigation & state (GetX)
- `get_it` — Dependency injection
- `equatable` — Value equality

**Networking:**
- `dio` — HTTP client
- `retrofit` — Type-safe REST API layer
- `json_annotation` / `json_serializable` — JSON serialization
- `jwt_decoder` — JWT token parsing
- `connectivity_plus` / `internet_connection_checker_plus` — Network monitoring
- `pusher_channels_flutter` — Real-time Pusher integration

**Local Storage:**
- `hive` / `hive_flutter` — NoSQL local database
- `get_storage` — Key-value storage

**Firebase:**
- `firebase_core` — Firebase initialization
- `firebase_messaging` — Push notifications (FCM)
- `cloud_firestore` — Firestore (video call signaling)
- `flutter_local_notifications` — Local notification display

**Video Call:**
- `jitsi_meet_flutter_sdk` — Video calling

**AI:**
- `google_generative_ai` / `flutter_gemini` — Google Gemini integration

**UI Libraries:**
- `smooth_page_indicator`, `carousel_slider_plus`, `iconsax_flutter`, `lottie`, `table_calendar`, `font_awesome_flutter`, and more

</details>

---

## Installation Steps

### 1. Clone the Repository

```bash
git clone https://github.com/KareemMohamed124/skill_swap.git
cd skill_swap
```

### 2. Navigate to the Source Directory

```bash
cd src
```

> All Flutter commands below must be run from the `src/` directory.

### 3. Verify Flutter Installation

```bash
flutter doctor -v
```

Ensure there are **no critical issues** for your target platform (Android / Windows).

### 4. Install Flutter Dependencies

```bash
flutter pub get
```

### 5. Configure Firebase

The project already includes pre-configured Firebase options in `lib/firebase_options.dart`. If you need to reconfigure for your own Firebase project:

```bash
# Install FlutterFire CLI (if not installed)
dart pub global activate flutterfire_cli

# Log in to Firebase
firebase login

# Configure Firebase for the project
flutterfire configure --project=skill-swap-e1a3d
```

This generates/updates:
- `lib/firebase_options.dart`
- `android/app/google-services.json`

### 6. Generate Code (Retrofit, JSON Serialization)

The project uses `build_runner` for code generation (Retrofit API clients, JSON models):

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## Compilation Steps

> **Important:** Run all commands below from the `src/` directory.

### Android (APK)

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release
```

**Output:** `src/build/app/outputs/flutter-apk/app-release.apk`

### Windows Desktop

```bash
flutter build windows --release
```

**Output:** `src/build/windows/x64/runner/Release/`

### Generate Native Splash Screen

```bash
dart run flutter_native_splash:create
```

---

## Run Instructions

> **Important:** Run all commands below from the `src/` directory.

### Run in Debug Mode (Development)

```bash
# Auto-detect connected device
flutter run

# Specify a target device
flutter devices                  # List available devices
flutter run -d <device-id>       # Run on specific device

# Run on Windows Desktop
flutter run -d windows

# Run on Android Emulator
flutter run -d emulator-5554
```

### Run with Hot Reload

Once the app is running in debug mode, press:
- **`r`** — Hot reload (preserves state)
- **`R`** — Hot restart (resets state)
- **`q`** — Quit

### Run Release Mode (Optimized)

```bash
flutter run --release
```

---

## Environment Setup & Configuration

### API Configuration

The backend API base URL is hardcoded across the API service files. The primary endpoint is:

```
https://skill-swaapp.vercel.app
```

This is referenced in the following files (inside `src/lib/`):
- `shared/data/web_services/user/user_api.dart`
- `shared/data/web_services/chat/chat_api_service.dart`
- `shared/data/web_services/store/store_api_service.dart`
- `shared/data/web_services/skills/skills_api_services.dart`
- `shared/data/web_services/booking/booking_api.dart`
- `shared/data/web_services/notification/notification_api.dart`
- `shared/data/web_services/report/report_api.dart`

> **To change the API endpoint**, update the `baseUrl` / `_baseUrl` constant in each of these files.

### Pusher (Real-time Messaging)

Pusher is configured in `src/lib/shared/core/network/pusher_service.dart`:

```dart
static const String _appKey = 'e3ac92c762aaed1a23ae';
static const String _cluster = 'mt1';
```

If using your own Pusher account, update these values with your own App Key and Cluster.

### Google Gemini AI (Skill Quizzes)

The Gemini API key is configured in `src/lib/shared/data/quiz/quiz_controller.dart`:

```dart
static const apiKey = "AIzaSyCNE3eSwqFxqijj5KCA3aEaydNA4buFSPs";
```

To use your own key:
1. Go to [Google AI Studio](https://aistudio.google.com/app/apikey)
2. Generate a new API key
3. Replace the value in `quiz_controller.dart`

### Firebase Configuration

Firebase is auto-configured via `src/lib/firebase_options.dart` for the following platforms:

| Platform | Status         |
|----------|----------------|
| Android  | ✅ Configured  |
| Windows  | ✅ Configured  |

**Firebase Project ID:** `skill-swap-e1a3d`

The project uses:
- **Cloud Firestore** — Video call signaling (WebRTC)
- **Firebase Cloud Messaging (FCM)** — Push notifications

### Local Storage

The app uses **Hive** for local storage (tokens, user preferences, onboarding state). Data is stored in the application documents directory and initialized at app startup:

```dart
final dir = await getApplicationDocumentsDirectory();
await Hive.initFlutter(dir.path);
await Hive.openBox('appBox');
```

No manual database setup is needed — Hive creates its storage files automatically on first run.

### Authentication

The app uses **JWT-based authentication**. Tokens are stored locally via Hive and automatically attached to API requests through `AuthInterceptor` (`src/lib/shared/core/network/auth_interceptor.dart`):

```
Authorization: skill-swap <token>
```

The interceptor handles:
- Token expiration → auto-logout
- Duplicate login detection → force logout
- Account blocking → force logout

### Android-Specific Configuration

**`src/android/app/build.gradle.kts`:**
- `compileSdk = 36` / `targetSdk = 36`
- `minSdk` = Flutter default (API 21)
- ProGuard enabled for release builds
- Core library desugaring enabled

**Required `google-services.json`:** Must be placed at `src/android/app/google-services.json` (generated by FlutterFire CLI).

---

## Pre-Built Executable Setup

If you just want to **install and use the app** without building from source, pre-built installers are available in the [`exe/`](exe/) directory.

---

### 🖥️ Windows — Run EXE

#### Download Instructions

1. **Clone this repository** or download it directly from GitHub.
2. **Navigate to** the [`exe/`](exe/) directory.

#### Prerequisites

- **Windows 10** or later (64-bit)
- No additional software dependencies required

#### Run Instructions

1. **Navigate to the executable:**
   ```
   exe/skill_swap.exe
   ```
2. **Double-click `skill_swap.exe`** to launch the application.
   - If Windows SmartScreen shows a warning:
     - Click **"More info"**
     - Then click **"Run anyway"**

---

### 🤖 Android — Install APK

To obtain the Android APK, build it from source using the [Compilation Steps](#compilation-steps) above.

#### Prerequisites

- An Android phone or tablet running **Android 5.0 (Lollipop)** or later
- **Enable "Install from Unknown Sources"** on your device

#### Steps

1. **Transfer the APK file** to your Android device:
   - Copy `app-release.apk` to your phone via USB cable, Google Drive, Telegram, or any file-sharing method.

2. **Enable Unknown Sources** (if not already enabled):
   - Go to **Settings → Security** (or **Settings → Apps → Special access**).
   - Enable **"Install unknown apps"** for your file manager or browser.
   - On newer Android versions, you'll be prompted automatically when opening the APK.

3. **Open the APK file** on your device:
   - Use a file manager app to navigate to where you saved the APK.
   - Tap the APK file.

4. **Tap "Install"** when the installation prompt appears.

5. **Tap "Open"** after installation completes, or find **SkillSwap** in your app drawer.

> **Note:** If Google Play Protect shows a warning, tap **"Install anyway"** — this is normal for apps not published on the Play Store.

---

## Project Structure

```
src/
├── pubspec.yaml                     # Flutter project configuration & dependencies
├── lib/
│   ├── main.dart                    # App entry point
│   ├── firebase_options.dart        # Firebase config (auto-generated)
│   ├── mobile/                      # Mobile-specific UI
│   │   └── presentation/           # Screens (22 feature modules)
│   │       ├── home/                # Home screen
│   │       ├── chat_channel/        # Public chat channels
│   │       ├── prv_chat/            # Private chat
│   │       ├── video_call/          # Video call (WebRTC)
│   │       ├── book_session/        # Session booking
│   │       ├── sessions/            # Session management
│   │       ├── search/              # Mentor search
│   │       ├── profile/             # User profile
│   │       ├── setting/             # App settings
│   │       ├── sign/                # Sign in / Sign up
│   │       ├── skill_verification/  # AI quiz verification
│   │       ├── game_part/           # Gamification
│   │       ├── game_stor/           # In-app store
│   │       └── ...                  # Other feature modules
│   ├── desktop/                     # Desktop-specific UI (Windows)
│   │   └── presentation/           # Desktop screens (18 feature modules)
│   └── shared/                      # Shared code (cross-platform)
│       ├── bloc/                    # BLoC/Cubit state management
│       ├── core/
│       │   ├── network/             # Dio interceptor, Pusher service
│       │   ├── services/            # Notification service
│       │   ├── theme/               # Theme management
│       │   ├── localization/        # Multi-language support
│       │   └── utils/               # Utilities
│       ├── data/
│       │   ├── models/              # Data models
│       │   ├── repositories/        # Repository implementations
│       │   ├── web_services/        # API service layers (Retrofit)
│       │   └── quiz/                # Gemini AI quiz controller
│       ├── domain/
│       │   └── repositories/        # Repository interfaces
│       ├── dependency_injection/    # GetIt DI setup
│       ├── helper/                  # Local storage helper
│       ├── common_ui/               # Shared UI components
│       ├── constants/               # App constants & static data
│       └── lang/                    # Language files
├── android/                         # Android platform code
├── windows/                         # Windows platform code
├── assets/                          # App assets (images, animations, icons)
└── test/                            # Unit & widget tests

exe/
├── skill_swap.exe                   # Windows installer
└── desktop_inno_script.iss          # Inno Setup script (used to build the installer)
```

---

## Troubleshooting

| Issue                          | Solution                                                                |
|--------------------------------|-------------------------------------------------------------------------|
| `flutter pub get` fails        | Run `flutter clean` then `flutter pub get` (from `src/` directory)     |
| Build runner errors            | `dart run build_runner build --delete-conflicting-outputs`             |
| Firebase init fails            | Ensure `google-services.json` exists in `src/android/app/`            |
| Android build fails (SLF4J)    | Already fixed — SLF4J dependencies included in `build.gradle.kts`     |
| Pusher not connecting          | Verify network connectivity and Pusher credentials                     |
| WebRTC crash on desktop        | `WebRTC.initialize()` is called in `main.dart` — ensure it runs before camera access |

---

## License

This project is developed as a graduation project and is not currently published under a specific open-source license.
