# 本地化

文案在 `ChromaFlow/<语言>.lproj/`。每个目录有 `Localizable.strings` 和 `InfoPlist.strings`。

`en`（默认）、`zh-Hans`、`zh-Hant`、`ja`、`ko`、`de`、`es`、`fr`、`hi`、`it`、`pt-BR`、`ru`

新增一条文案时，上面每种语言都要有同一个 key。代码里用 `NSLocalizedString`。提交前运行 `verify_localization.sh` 和 `test_localization.sh`。

在 Xcode 里切换语言：Product → Scheme → Edit Scheme → Run → Options → Application Language。
