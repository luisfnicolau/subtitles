# Subtitles - Multi-Language Media Player

A Flutter-based media player application that displays synchronized subtitles in multiple languages, designed to help users learn languages while enjoying their favorite music and media content.

## 🎯 Purpose

Subtitles is a mobile and desktop application that enhances media consumption by providing real-time synchronized subtitles in multiple languages. Perfect for:

- **Language Learning**: Compare lyrics in your native language with the language you're learning
- **Music Appreciation**: Better understand song lyrics with accurate translations
- **Accessibility**: Follow along with media content through text display
- **Multi-Language Support**: Switch between different subtitle languages on the fly

## ✨ Features

- **Multi-Language Subtitle Display**: View subtitles in two languages simultaneously (English + Portuguese/French)
- **Real-Time Synchronization**: Subtitles automatically highlight and scroll as the media plays
- **Media Library Management**: Import and organize your music with corresponding subtitle files
- **SRT File Support**: Standard SubRip (.srt) subtitle format compatibility
- **Audio Playback Controls**: Play, pause, and seek through your media
- **Beautiful UI**: Gradient-based design with smooth animations
- **Auto-Scroll**: Subtitles automatically scroll to keep the current line centered
- **Language Switching**: Toggle between different subtitle languages (Portuguese ↔ French)

## 📱 Screenshots

The app features:
- A media library page to browse your imported songs
- A player page with dual-language subtitle display
- Media controls for playback management
- Real-time subtitle highlighting

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (>=3.4.0)
- Dart SDK (>=3.4.0)
- For iOS: Xcode and CocoaPods
- For Android: Android Studio

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/subtitles.git
   cd subtitles
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **For iOS (if running on macOS)**
   ```bash
   cd ios
   pod install
   cd ..
   ```

### Running the App

#### Development Mode

**On iOS:**
```bash
flutter run -d ios
```

**On Android:**
```bash
flutter run -d android
```

**On macOS:**
```bash
flutter run -d macos
```

**On Windows:**
```bash
flutter run -d windows
```

**On Linux:**
```bash
flutter run -d linux
```

#### Release Mode

```bash
flutter run --release
```

## 📂 Project Structure

```
lib/
├── main.dart                          # App entry point
├── models/
│   ├── media_item.dart               # Media file data model
│   ├── subtitle_data.dart            # Subtitle line data model
│   └── subtitle_file.dart            # Subtitle file metadata
├── screens/
│   ├── home_page.dart                # Player screen with subtitles
│   └── media_list_page.dart          # Media library screen
├── services/
│   ├── media_library_service.dart    # Media file management
│   └── srt_parser.dart               # SRT subtitle parser
└── widgets/
    ├── import_media_dialog.dart      # Media import dialog
    ├── media_controls.dart           # Audio playback controls
    └── subtitle_line.dart            # Subtitle display widget

assets/
├── media/                            # Audio files (.mp3, .m4a, etc.)
└── subtitles/                        # Subtitle files (.srt)
```

## 🎵 Adding Media Files

### Option 1: Pre-bundled Media (Development)

1. Place your audio files in `assets/media/`
2. Place corresponding subtitle files in `assets/subtitles/`
3. Subtitle naming convention: `[Artist] - [Song Title].[language].srt`
   - Example: `Travis Scott - goosebumps.en.srt`
   - Example: `Travis Scott - goosebumps.pt.srt`
   - Example: `Travis Scott - goosebumps.fr.srt`

4. Update [`pubspec.yaml`](pubspec.yaml):
   ```yaml
   flutter:
     assets:
       - assets/media/
       - assets/subtitles/
   ```

### Option 2: Import at Runtime

1. Tap the **+** button in the media library
2. Select your audio file (.mp3, .m4a, .wav, etc.)
3. (Optional) Select subtitle files (.srt)
4. Fill in the song title and artist
5. Tap **Import**

## 📝 Subtitle Format

The app uses standard SRT (SubRip) subtitle format:

```srt
1
00:00:15,800 --> 00:00:17,000
First line of text

2
00:00:21,600 --> 00:00:24,000
Second line of text
```

## 🛠️ Dependencies

Key packages used:
- [`just_audio`](https://pub.dev/packages/just_audio) (^0.9.38) - Audio playback
- [`file_picker`](https://pub.dev/packages/file_picker) (^8.0.0+1) - File selection
- [`path_provider`](https://pub.dev/packages/path_provider) (^2.1.1) - Local storage paths
- [`permission_handler`](https://pub.dev/packages/permission_handler) (^11.1.0) - File permissions

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with Flutter
- Uses the SubRip (.srt) subtitle format
- Inspired by language learning and music appreciation apps

## 🐛 Known Issues

- iOS crash on initial launch with Dart VM (see troubleshooting section)
- Asset scanning may not work on all platforms (use import feature instead)

## 💡 Future Enhancements

- [ ] Auto fetch content from Youtube
- [ ] Auto fetch content from Spotify
- [ ] Support for more subtitle formats (ASS, VTT)
- [ ] Automatic subtitle synchronization
- [ ] Subtitle editing capabilities
- [ ] Export playlists
- [ ] Cloud storage integration
- [ ] More language support
- [ ] Offline lyrics downloading

---

Made with ❤️ using Flutter