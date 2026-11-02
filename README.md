# ChromaFlow（正念壁纸）

macOS 菜单栏动态壁纸。主界面预览漂浮气泡动画，选定主题后可以把当前画面设为桌面壁纸。

显示名称是「正念壁纸」，工程名是 ChromaFlow。当前营销版本是 1.1。

## 功能

- 九种颜色主题：多彩、绿色、黄色、橙色、红色、紫色、蓝色、暖银、冷银
- 五种外观：自动、自动(黑色)、浅色、深色、深色(黑色)
- 菜单栏运行，关闭主窗口后留在状态栏，不退出
- 状态栏菜单：打开主界面、省电模式、开机启动、退出
- 省电模式降低动画帧率，并减少同时出现的气泡数量
- 设置壁纸时会请求自动化权限，以便通过 Finder 隐藏桌面图标
- 界面文案已本地化，见下方语言列表

## 环境

- macOS 14.0 及以上（Xcode 目标的 `MACOSX_DEPLOYMENT_TARGET`）
- Xcode，Swift 5
- 签名方式是 Automatic，使用开发团队 `B86WA58GRJ`。换一台电脑打开时，需要在 Signing & Capabilities 里改成自己的开发团队

## 构建与运行

```bash
open ChromaFlow.xcodeproj
```

在 Xcode 中选择 scheme `ChromaFlow`，按 ⌘R 运行。

命令行构建：

```bash
xcodebuild -project ChromaFlow.xcodeproj -scheme ChromaFlow -configuration Debug
xcodebuild -project ChromaFlow.xcodeproj -scheme ChromaFlow -configuration Release
```

应用以菜单栏工具启动（`LSUIElement`），不会停在 Dock 里。点击状态栏图标打开菜单。

## 使用

1. 从状态栏选择「打开主界面」。
2. 在主界面选择主题和外观，预览气泡动画。
3. 点击「设置为壁纸」。
4. 若系统提示需要权限，到「系统设置 > 隐私与安全性 > 自动化」，允许「正念壁纸」控制 Finder。
5. 关闭窗口后，从状态栏继续开关省电模式或开机启动。

## 项目结构

```
ChromaFlow.xcodeproj/          Xcode 工程
ChromaFlow/
  ChromaFlowApp.swift          应用入口
  AppDelegate.swift            主窗口与菜单栏生命周期
  ContentView.swift            主界面、主题与气泡预览
  Models/                      气泡、主题、外观模式
  Utils/WallpaperManager.swift 壁纸、状态栏菜单、桌面图标
  Services/                    开机启动
  *.lproj/                     各语言文案
LOCALIZATION.md                本地化说明（语言列表可能不全，以 *.lproj 为准）
```

## 本地化

`ChromaFlow/` 下已有这些语言目录：

`en`、`zh-Hans`、`zh-Hant`、`ja`、`ko`、`de`、`es`、`fr`、`hi`、`it`、`pt-BR`、`ru`

字符串在各自的 `Localizable.strings` 中。可用仓库里的 `verify_localization.sh` 和 `test_localization.sh` 做检查。

## 许可

仓库里还没有 `LICENSE` 文件，许可尚未确定。

## 贡献

直接改对应语言的 `Localizable.strings`，或从主界面、壁纸和状态栏相关文件入手。提交前用上面的本地化脚本看一眼新增文案是否各语言都有。
