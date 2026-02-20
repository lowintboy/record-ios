# CLAUDE.md

## Project Overview
RECORD - iOS 음악 플레이어 앱. 사용자가 mp3/m4a/wav 등 음악 파일을 임포트하여 재생할 수 있다.

## Tech Stack
- Platform: iOS 17.0+
- Language: Swift 6 (strict concurrency)
- UI: SwiftUI
- Architecture: MV + Service (no ViewModel layer)
- Project generation: XcodeGen (`project.yml` → `xcodegen generate`)

## Build Commands
```bash
# Generate Xcode project (required after cloning or modifying project.yml)
xcodegen generate

# Build
xcodebuild -project Record.xcodeproj -scheme Record \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build
```

## Project Structure
```
Record/
├── App/RecordApp.swift           # @main, environment injection
├── Models/Track.swift            # Track data model (Codable, Identifiable)
├── Services/
│   ├── MusicLibrary.swift        # @Observable — track list CRUD, JSON persistence
│   ├── AudioPlayer.swift         # @Observable — AVAudioPlayer wrapper, playback state
│   └── FileManagerService.swift  # File copy/delete utilities
├── Views/
│   ├── ContentView.swift         # NavigationStack + MiniPlayerBar
│   ├── LibraryView.swift         # Track list + .fileImporter() + empty state
│   ├── NowPlayingView.swift      # Fullscreen playback controls
│   └── MiniPlayerBar.swift       # Bottom mini player bar
└── Resources/Assets.xcassets/
```

## Development Guidelines
- Follow Swift naming conventions
- Use SwiftUI for UI development
- `.xcodeproj` is gitignored — always regenerate with `xcodegen generate`
- Services (`MusicLibrary`, `AudioPlayer`) are `@Observable` and injected via `.environment()`
- Use `@Environment(ServiceType.self)` to access services in views
