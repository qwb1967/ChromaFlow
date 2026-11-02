# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目概述

ChromaFlow（正念壁纸）是一个 macOS 动态壁纸应用，提供带有漂浮气泡效果的舒缓动画背景。应用作为菜单栏工具运行，支持多种颜色主题和外观模式。

## 构建和运行

### 使用 Xcode 构建
```bash
# 打开项目
open ChromaFlow.xcodeproj

# 或使用命令行构建
xcodebuild -project ChromaFlow.xcodeproj -scheme ChromaFlow -configuration Debug
xcodebuild -project ChromaFlow.xcodeproj -scheme ChromaFlow -configuration Release
```

### 运行应用
- 在 Xcode 中按 ⌘R 运行
- 应用将作为菜单栏工具启动（不会出现在 Dock 中）
- 通过状态栏图标访问主界面

## 核心架构

### 应用结构模式
应用采用 SwiftUI + MVVM 架构，核心组件之间的关系：

1. **ChromaFlowApp** → **AppDelegate** → 创建和管理窗口
2. **ContentView** → 主界面，包含动画预览和主题选择
3. **WallpaperManager** → 处理系统壁纸设置（单例模式）
4. **ThemeManager** → 管理主题和外观模式（单例模式）

### 动画系统架构
气泡动画通过以下组件协作实现：

- **Ball 模型**：管理单个气泡的位置、速度、颜色、生命周期
- **DisplayLinkController**：控制动画帧率（60fps 或 30fps）
- **BubblesView**：渲染所有气泡的 SwiftUI 视图
- 生命周期：气泡有淡入(20%) → 正常(60%) → 淡出(20%)三个阶段

### 壁纸系统集成
应用通过两种方式设置壁纸：

1. **静态壁纸**：生成当前主题的静态图片并设置
2. **动态壁纸窗口**：创建透明窗口覆盖在桌面上实现动画效果

关键实现在 `WallpaperManager.swift` 中，使用 NSWorkspace API 设置壁纸。

## 关键功能实现

### 主题系统
- 9 种预设主题：多彩、绿色、黄色、橙色、红色、紫色、蓝色、暖银、冷银
- 主题定义在 `ContentView.swift` 的 `WallpaperTheme` 枚举中
- 每个主题包含渐变背景色和气泡颜色生成逻辑

### 外观模式
- 自动模式：跟随系统
- 浅色模式：明亮背景
- 深色模式：降低亮度 60%
- 黑色模式：纯黑背景，适合 OLED 屏幕
- 自动黑色模式：根据系统自动切换黑色/浅色

### 性能优化
- **省电模式**：通过 `ThemeManager.powerSaveMode` 控制
  - 正常模式：60fps，15-30 个气泡
  - 省电模式：30fps，10-20 个气泡
- **缓存机制**：Ball 模型中缓存计算结果避免重复计算
- **生命周期管理**：自动清理死亡的气泡，控制内存使用

## 重要文件路径

- 主入口：`ChromaFlow/ChromaFlowApp.swift`
- 主界面：`ChromaFlow/ContentView.swift`
- 核心模型：`ChromaFlow/Models/Ball.swift`
- 主题管理：`ChromaFlow/Models/ThemeManager.swift`
- 壁纸管理：`ChromaFlow/Utils/WallpaperManager.swift`
- 窗口管理：`ChromaFlow/AppDelegate.swift`

## 系统权限要求

应用需要以下权限（已在 Info.plist 和 entitlements 中配置）：
- Apple Events（用于控制 Finder 隐藏/显示桌面图标）
- 文件系统访问（沙盒环境下的用户选择文件、下载、图片、桌面文件夹）

## 开发注意事项

1. **窗口管理**：应用使用 LSUIElement=true 作为菜单栏工具，主窗口通过 AppDelegate 管理
2. **内存管理**：注意在窗口关闭时清理动画资源（见 `ContentView.cleanup()` 方法）
3. **坐标系统**：SwiftUI 坐标系原点在左上角，注意边界碰撞检测的实现
4. **主题切换**：更新主题时需要同时更新静态壁纸和所有活动气泡的颜色
5. **单例模式**：ThemeManager 和 WallpaperManager 使用单例模式确保全局状态一致