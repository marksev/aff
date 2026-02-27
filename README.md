# Daily Affirmations

A Flutter app with beautiful, swipeable affirmation cards across 10 categories. Save your favourites locally and revisit them any time.

## Features

- **10 categories** — Self Love, Confidence, Success, Wealth, Health, Motivation, Gratitude, Positivity, Relationships, Discipline
- **Swipeable cards** — scroll vertically through 10 affirmations per category on a gradient full-screen card
- **Favourites** — tap the heart icon to save any affirmation; view all saved ones on the Favourites tab
- **Share** — share any affirmation with one tap
- **Bottom navigation** — Home | Favourites

## Tech stack

| Layer | Choice |
|---|---|
| Framework | Flutter (stable channel) |
| State management | Provider (`ChangeNotifier`) |
| Persistence | `shared_preferences` |
| Sharing | `share_plus` |

## Folder structure

```
lib/
├── data/          # Hardcoded affirmations dataset
├── models/        # CategoryData model
├── providers/     # FavoritesProvider (ChangeNotifier)
├── screens/       # HomeScreen, AffirmationScreen, FavoritesScreen
├── services/      # PreferencesService (SharedPreferences wrapper)
├── widgets/       # CategoryCard, AffirmationCard
└── main.dart
```

## Running locally

```bash
# 1. Install Flutter (stable): https://docs.flutter.dev/get-started/install
# 2. Clone the repo
git clone <repo-url>
cd <repo-name>

# 3. Install dependencies
flutter pub get

# 4. Run on a connected device or emulator
flutter run
```

> `android/local.properties` is listed in `.gitignore` and is generated automatically by the Flutter toolchain — you do not need to create it manually.

## Downloading the APK from GitHub Actions

Every push to `main` (and every pull request targeting `main`) triggers the **Build Release APK** workflow:

1. Go to the **Actions** tab of this repository on GitHub.
2. Click the latest **Build Release APK** run.
3. Scroll to the **Artifacts** section at the bottom of the run summary.
4. Download **app-release** — it contains `app-release.apk`, which can be side-loaded on any Android device with "Install unknown apps" enabled.

## Building the APK locally

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```
