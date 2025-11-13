# Fidi - Snake Game 🐍

A complete cross-platform classic Snake game built with Flutter and Flame. Play on Android, iOS, Web, and Windows with the same codebase!

## Features

### Core Gameplay

- Classic snake mechanics on a 20x20 grid
- Automatic snake movement with configurable speed
- Fruit collection for growth and scoring
- Collision detection (walls and self-collision)
- Game over with score tracking

### Cross-Platform Support

- ✅ **Android** - Touch controls (swipe or buttons)
- ✅ **iOS** - Touch controls (swipe or buttons)
- ✅ **Web** - Keyboard controls (Arrow keys or WASD)
- ✅ **Windows** - Keyboard controls (Arrow keys or WASD)

### Customization

- **Snake Colors**: 4 themes (Green, Blue, Orange, Purple)
- **Background Colors**: 4 themes (Dark Gray, Dark Blue, Dark Teal, Light Gray)
- **Game Speed**: 4 levels (Slow, Normal, Fast, Insane)
- All settings saved locally with shared_preferences

### Responsive Design

- Adapts to portrait and landscape orientations
- Square game board with responsive scaling
- Touch controls for mobile devices (portrait mode)
- Swipe gestures for landscape mobile mode
- Keyboard support for tablets with external keyboards
- Material 3 UI with light/dark theme support

### Local Persistence

- High score tracking
- Last 5 game scores
- Settings persistence across sessions
- Works 100% offline - no internet required

## Privacy

Fidi respects your privacy. The app:

- Does **NOT** collect any personal data
- Does **NOT** require internet connection
- Stores all data locally on your device
- See our [Privacy Policy](PRIVACY_POLICY.md) for details

## Project Structure

```
lib/
├── main.dart                          # App entry point and routing
├── game/
│   ├── snake_game.dart               # Main Flame game class
│   ├── snake.dart                    # Snake logic and rendering
│   ├── fruit.dart                    # Fruit component
│   └── snake_board.dart              # Grid and board calculations
├── models/
│   └── game_settings.dart            # Settings data model
├── services/
│   └── preferences_service.dart      # Local storage service
├── screens/
│   ├── home_screen.dart              # Main menu
│   ├── game_screen.dart              # Game hosting screen
│   ├── settings_screen.dart          # Settings customization
│   └── scores_screen.dart            # Leaderboard display
└── widgets/
    └── overlays/
        ├── score_bar.dart            # Top score display
        ├── pause_overlay.dart        # Pause menu
        └── game_over_overlay.dart    # Game over screen
```

## Running the Project

### Prerequisites

- Flutter SDK 3.0 or newer
- For Windows: Visual Studio with C++ development tools
- For Web: Chrome browser
- For Android: Android Studio and SDK
- For iOS: Xcode (macOS only)

### Install Dependencies

```bash
flutter pub get
```

### Run on Different Platforms

#### Web (Chrome)

```bash
flutter run -d chrome
```

#### Windows

```bash
flutter run -d windows
```

#### Android

```bash
flutter run -d android
```

Or use Android Studio to run on emulator/device.

#### iOS (macOS only)

```bash
flutter run -d ios
```

Or use Xcode to run on simulator/device.

### Build for Production

#### Web

```bash
flutter build web
```

Output: `build/web/`

#### Windows

```bash
flutter build windows
```

Output: `build/windows/runner/Release/`

#### Android APK

For development/testing:

```bash
flutter build apk
```

For production release with signing:

1. Create `android/key.properties` (never commit this file):

```properties
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=upload
storeFile=../upload-keystore.jks
```

2. Generate your keystore:

```bash
keytool -genkey -v -keystore android/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

3. Build signed APK:

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

**⚠️ Security Note**: Never commit `key.properties` or `.jks` files to version control! These files are already in `.gitignore`.

#### iOS (macOS only)

```bash
flutter build ios
```

Then archive and export from Xcode.

## Controls

### Desktop/Web (Keyboard)

- **Arrow Keys**: ↑ ↓ ← → for direction
- **WASD**: Alternative keyboard controls
- **Pause Button**: Click to pause game

### Mobile (Touch)

- **Swipe**: Swipe in any direction to move snake
- **Direction Buttons**: Tap on-screen buttons
- **Pause Button**: Tap to pause game

## Tech Stack

- **Flutter**: 3.9.2+ (null-safety enabled)
- **Flame**: ^1.17.0 (2D game engine)
- **shared_preferences**: ^2.3.2 (local storage)
- **Material 3**: Modern UI design

## Platform-Specific Improvements

### Web-Specific UX Enhancements 🌐

1. **Larger Game Board**: The web version automatically scales to take advantage of larger screens, making the game board more visible and easier to play.

2. **Keyboard-Only Controls**: No touch controls shown on web - clean interface optimized for keyboard input with both Arrow keys and WASD support.

3. **Keyboard Hint Overlay**: Added subtle keyboard control hints for first-time players:

   - Could be enhanced with a "Press any arrow key or WASD to start" overlay
   - Visual indicator showing Arrow keys and WASD options

4. **Side Panel Layout**: In landscape mode on web, the score bar is optimized for wide screens with better spacing.

5. **Mouse Hover Effects**: All buttons have hover states for better desktop interaction feedback.

6. **Browser Performance**: Optimized frame rate for smooth 60fps gameplay in browser.

**Recommended Web Enhancement** (not yet implemented):

```dart
// Add keyboard shortcut hints on first load
// Display: "Use ↑↓←→ or WASD to play"
// Press 'P' to pause, 'R' to restart
```

### Mobile-Specific UX Enhancements 📱

1. **Dual Control System**:

   - Swipe gestures for quick, natural movement
   - Large (60x60) directional buttons for precision control
   - Players can choose their preferred method

2. **Thumb-Friendly Button Layout**: Direction buttons positioned for easy thumb reach in portrait mode, moved to side panel in landscape.

3. **Responsive Touch Targets**: All interactive elements (buttons, menu items) are minimum 44x44 points for comfortable tapping.

4. **Visual Feedback**:

   - Buttons use FilledButton style with clear press states
   - High contrast colors for visibility on small screens
   - Larger font sizes for readability

5. **Orientation Support**: Seamlessly adapts between portrait and landscape with optimized layouts for each.

6. **Native Feel**: Material 3 design follows platform conventions for Android/iOS.

**Recommended Mobile Enhancement** (not yet implemented):

```dart
// Add haptic feedback on events
import 'package:flutter/services.dart';

// On fruit collection:
HapticFeedback.lightImpact();

// On game over:
HapticFeedback.heavyImpact();

// On direction change:
HapticFeedback.selectionClick();
```

To add haptic feedback, update `game_screen.dart`:

```dart
// In _handleSwipe and button press methods:
HapticFeedback.selectionClick();
```

## Development Notes

- **Null-Safety**: Entire codebase is null-safe
- **No External Assets**: Uses colored shapes only (easy to customize)
- **Well-Commented**: All files include explanatory comments
- **Modular Architecture**: Clean separation of game logic, UI, and services
- **Type-Safe**: Strong typing throughout with proper models

## Future Enhancements

Possible additions you could implement:

1. **Sound Effects**: Add package `audioplayers` for eating, game over sounds
2. **Multiplayer**: Add Firebase for online leaderboards
3. **Power-ups**: Special fruits with temporary abilities
4. **Obstacles**: Static barriers on the board
5. **Themes**: More visual themes and snake skins
6. **Achievements**: Milestone-based rewards
7. **Tutorial**: First-time player guidance

## License

This project is open source and available for educational purposes.

## Credits

**Developer:** Zarabanda Dev  
**Website:** https://zarabanda-dev.web.app/  
**Built with:** Flutter + Flame game engine

© 2025 Zarabanda Dev. All rights reserved.

---

**Enjoy playing Fidi!** 🐍🎮
