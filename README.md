# ChromaFlow

macOS menu-bar app for animated bubble wallpaper. The main window previews a theme; Set as Wallpaper applies it to the desktop.

On-screen name: 正念壁纸. Version 1.1. [Mac App Store](https://apps.apple.com/us/app/id6740222736).

## Features

- Nine themes: Colorful, Green, Yellow, Orange, Red, Purple, Blue, Warm Silver, Cool Silver
- Five appearances: Auto, Auto (Black), Light, Dark, Dark (Black)
- Menu-bar app. Closing the window leaves it in the status bar: Open Main Window, Power Save Mode, Launch at Login, Quit
- Power Save Mode lowers the frame rate and the bubble count
- Setting the wallpaper needs Automation permission so the app can hide desktop icons through Finder
- Localized. Languages are listed in [LOCALIZATION.md](LOCALIZATION.md)

## Requirements

- macOS 14.0 or later
- Xcode, Swift 5
- Your own Apple team in Signing & Capabilities. This repo does not set one

## Build and run

```bash
open ChromaFlow.xcodeproj
```

Select the `ChromaFlow` scheme and press ⌘R. The app does not stay in the Dock.

```bash
xcodebuild -project ChromaFlow.xcodeproj -scheme ChromaFlow -configuration Release
```

## Usage

1. Open Main Window from the status bar.
2. Pick a theme and an appearance.
3. Click Set as Wallpaper.
4. If macOS asks, allow 正念壁纸 to control Finder under System Settings > Privacy & Security > Automation.

## Project layout

```
ChromaFlow.xcodeproj/
ChromaFlow/
  ChromaFlowApp.swift          Entry point
  AppDelegate.swift            Window and menu-bar lifecycle
  ContentView.swift            Main UI, themes, bubble preview
  Models/                      Bubbles, themes, appearance
  Utils/WallpaperManager.swift Wallpaper, status bar, desktop icons
  Services/                    Launch at login
  *.lproj/                     Strings
```

## License

[MIT](LICENSE). Copyright (c) 2026 钱文博.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).
