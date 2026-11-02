# ChromaFlow

A macOS menu-bar app for animated desktop wallpaper. The main window previews floating bubbles; once a theme is chosen, the current frame can be set as the desktop wallpaper.

The on-screen name is 正念壁纸. The Xcode project name is ChromaFlow. The marketing version is 1.1.

## Features

- Nine color themes: Colorful, Green, Yellow, Orange, Red, Purple, Blue, Warm Silver, and Cool Silver
- Five appearance modes: Auto, Auto (Black), Light, Dark, and Dark (Black)
- Runs from the menu bar. Closing the main window leaves the app in the status bar
- Status-bar menu: Open Main Window, Power Save Mode, Launch at Login, and Quit
- Power Save Mode lowers the animation frame rate and reduces how many bubbles are on screen
- Setting the wallpaper asks for Automation permission so the app can hide desktop icons through Finder
- Interface strings are localized. See the language list below

## Requirements

- macOS 14.0 or later (`MACOSX_DEPLOYMENT_TARGET` on the Xcode target)
- Xcode with Swift 5
- Automatic signing, currently set to development team `B86WA58GRJ`. On another Mac, switch Signing & Capabilities to your own team

## Build and run

```bash
open ChromaFlow.xcodeproj
```

In Xcode, select the `ChromaFlow` scheme and press ⌘R.

Command-line builds:

```bash
xcodebuild -project ChromaFlow.xcodeproj -scheme ChromaFlow -configuration Debug
xcodebuild -project ChromaFlow.xcodeproj -scheme ChromaFlow -configuration Release
```

The app starts as a menu-bar agent (`LSUIElement`) and does not stay in the Dock. Use the status-bar icon to open the menu.

## Usage

1. Choose Open Main Window from the status bar.
2. Pick a theme and an appearance mode, and preview the bubbles.
3. Click Set as Wallpaper.
4. If macOS asks for permission, open System Settings > Privacy & Security > Automation and allow 正念壁纸 to control Finder.
5. After closing the window, turn Power Save Mode or Launch at Login on or off from the status bar.

## Project layout

```
ChromaFlow.xcodeproj/          Xcode project
ChromaFlow/
  ChromaFlowApp.swift          App entry point
  AppDelegate.swift            Main window and menu-bar lifecycle
  ContentView.swift            Main UI, themes, and bubble preview
  Models/                      Bubbles, themes, and appearance modes
  Utils/WallpaperManager.swift Wallpaper, status-bar menu, desktop icons
  Services/                    Launch at login
  *.lproj/                     Localized strings
LOCALIZATION.md                Localization notes (the language list may be incomplete; trust the *.lproj directories)
```

## Localization

These language directories are already in `ChromaFlow/`:

`en`, `zh-Hans`, `zh-Hant`, `ja`, `ko`, `de`, `es`, `fr`, `hi`, `it`, `pt-BR`, `ru`

Strings live in each `Localizable.strings` file. `verify_localization.sh` and `test_localization.sh` in the repo can check them.

## License

There is no `LICENSE` file yet. The license is not set.

## Contributing

Edit the matching `Localizable.strings` files, or start from the main window, wallpaper, and status-bar code. Before submitting, run the localization scripts above and check that new strings exist for every language.
