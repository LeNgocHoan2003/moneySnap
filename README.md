# Money Snap

Track your expenses by capturing receipts. A Flutter app with camera capture, local storage (Hive), and multi-language support.

---

## Prerequisites

- **Flutter SDK** (>=3.0.0). Install from [flutter.dev](https://flutter.dev/docs/get-started/install)
- **Android Studio** or **Xcode** (for mobile)
- **Java JDK** (for Android release builds; `keytool` must be on PATH)

Check Flutter:

```bash
flutter doctor
```

---

## Steps to Run the App

### 1. Clone and open the project

```bash
git clone <your-repo-url> moneySnap
cd moneySnap/money_snap
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate code (MobX, Hive)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run the app

**Debug (default):**

```bash
flutter run
```

Use `flutter run -d <device_id>` to pick a device. List devices with `flutter devices`.

**Android release** (optional) needs a keystore first — see [Android release build](#android-release-build) below.

---

## Optional: Android release build

To build a signed release AAB/APK you need a keystore and `key.properties`. These files are **not** in the repo.

1. **Create `key.properties`** in `money_snap/android/`:

   ```properties
   storePassword=<your-store-password>
   keyPassword=<your-key-password>
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```

2. **Generate the keystore** (from repo root):

   ```bash
   cd money_snap/android
   chmod +x generate-keystore.sh
   ./generate-keystore.sh
   ```

   On Windows (no bash), use `keytool` to create `app/upload-keystore.jks` and set the same alias/passwords as in `key.properties`.

3. **Build the bundle:**

   ```bash
   cd money_snap
   flutter build appbundle
   ```

   Output: `build/app/outputs/bundle/release/app-release.aab`

---

## Optional: Regenerate assets

- **Splash screen:** `dart run flutter_native_splash:create`
- **App icons:** `dart run flutter_launcher_icons`

---

## Project structure

| Path              | Description                    |
|-------------------|--------------------------------|
| `money_snap/`     | Flutter app (main package)     |
| `money_snap/lib/` | App source (features, core)   |
| `money_snap/assets/` | Icons and static assets   |
