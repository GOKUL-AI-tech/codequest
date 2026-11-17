# CodeQuest - Setup Guide

## Prerequisites
- Flutter SDK >= 3.3.0
- Dart SDK >= 3.3.0
- Supabase account (free tier works)
- Firebase project (for push notifications)

---

## Step 1: Supabase Setup

1. Go to [supabase.com](https://supabase.com) and create a new project
2. Go to SQL Editor and run these migrations in order:
   - `supabase/migrations/001_initial_schema.sql`
   - `supabase/migrations/002_rls_policies.sql`
   - `supabase/migrations/003_seed_data.sql`

3. Enable OAuth providers in **Authentication > Providers**:
   - Enable Google OAuth (add your Client ID & Secret)
   - Enable GitHub OAuth (add your Client ID & Secret)

4. Copy your project URL and anon key from **Settings > API**

---

## Step 2: Configure the App

Open `lib/core/constants/app_constants.dart` and replace:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
static const String aiMentorApiKey = 'YOUR_OPENAI_OR_GEMINI_KEY';
```

---

## Step 3: Firebase Setup (Push Notifications)

1. Create a Firebase project at [console.firebase.google.com](https://console.firebase.google.com)
2. Add Android and iOS apps to your Firebase project
3. Download `google-services.json` → place in `android/app/`
4. Download `GoogleService-Info.plist` → place in `ios/Runner/`
5. Run `flutterfire configure` if not done already

---

## Step 4: Fonts Setup

Download and add these fonts to `assets/fonts/`:
- **Orbitron** - [Google Fonts](https://fonts.google.com/specimen/Orbitron)
- **Rajdhani** - [Google Fonts](https://fonts.google.com/specimen/Rajdhani)  
- **Share Tech Mono** - [Google Fonts](https://fonts.google.com/specimen/Share+Tech+Mono)

Required files:
```
assets/fonts/Orbitron-Regular.ttf
assets/fonts/Orbitron-Bold.ttf
assets/fonts/Orbitron-ExtraBold.ttf
assets/fonts/Rajdhani-Regular.ttf
assets/fonts/Rajdhani-SemiBold.ttf
assets/fonts/Rajdhani-Bold.ttf
assets/fonts/ShareTechMono-Regular.ttf
```

---

## Step 5: Run the App

```bash
# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run on device
flutter run
```

---

## Step 6: Configure Deep Links (OAuth Redirect)

### Android (`android/app/src/main/AndroidManifest.xml`):
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data android:scheme="io.supabase.codequest" />
</intent-filter>
```

### iOS (`ios/Runner/Info.plist`):
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>io.supabase.codequest</string>
    </array>
  </dict>
</array>
```

---

## Architecture Overview

```
lib/
├── core/
│   ├── constants/     # App constants, colors, game config
│   ├── theme/         # Dark cyberpunk theme
│   └── router/        # GoRouter navigation
├── domain/
│   └── entities/      # Pure Dart models
├── data/
│   ├── models/        # JSON serializable models
│   ├── datasources/   # Supabase API calls
│   └── repositories/  # Repository implementations
└── presentation/
    ├── screens/       # All UI screens
    ├── widgets/       # Reusable components
    └── providers/     # Riverpod state management
```

---

## Supabase Realtime Setup

Enable Realtime for these tables in **Database > Replication**:
- `profiles`
- `coding_battles`
- `battle_participants`
- `chat_messages`
- `leaderboard_snapshots`

---

## AI Mentor Integration

The AI mentor uses OpenAI GPT-4o-mini by default. To use Google Gemini instead, update `lib/core/constants/app_constants.dart`:

```dart
static const String aiMentorBaseUrl = 'https://generativelanguage.googleapis.com/v1beta';
static const String aiMentorModel = 'gemini-1.5-flash';
```

---

## Production Checklist

- [ ] Replace all placeholder API keys
- [ ] Run all SQL migrations on Supabase
- [ ] Configure OAuth providers
- [ ] Set up Firebase
- [ ] Add real font files
- [ ] Add app icons (`flutter_launcher_icons`)
- [ ] Add splash screen (`flutter_native_splash`)
- [ ] Run `flutter build apk --release` or `flutter build ios --release`
- [ ] Set up App Store / Play Store listings
