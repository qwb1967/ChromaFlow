# Contributing

Build steps are in the README. Before the first build, choose your own Apple team in Signing & Capabilities.

Add each new string to `Localizable.strings` in every language listed in [LOCALIZATION.md](LOCALIZATION.md), then run:

```bash
./verify_localization.sh
./test_localization.sh
```

Main UI: `ChromaFlow/ContentView.swift`. Wallpaper and the status-bar menu: `ChromaFlow/Utils/WallpaperManager.swift`.
