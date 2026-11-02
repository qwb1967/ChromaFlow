# Contributing

## Build

```bash
open ChromaFlow.xcodeproj
```

Select the `ChromaFlow` scheme and press ⌘R. Signing is automatic and the project does not set a development team. In Signing & Capabilities, choose your own Apple team before the first build.

Command-line builds:

```bash
xcodebuild -project ChromaFlow.xcodeproj -scheme ChromaFlow -configuration Debug
```

## Localization

Interface strings live in `ChromaFlow/<language>.lproj/Localizable.strings`. When you add a key, add it for every language directory listed in `LOCALIZATION.md`.

Before submitting, run:

```bash
./verify_localization.sh
./test_localization.sh
```

## Code

The main window, themes, and bubble preview are in `ChromaFlow/ContentView.swift`. Wallpaper and the status-bar menu are in `ChromaFlow/Utils/WallpaperManager.swift`.

The shipping app is [正念壁纸 on the Mac App Store](https://apps.apple.com/us/app/id6740222736).
