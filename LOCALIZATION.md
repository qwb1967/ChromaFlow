# ChromaFlow 本地化指南

## 已完成的本地化配置

### 支持的语言
- **英文 (en)**: 默认语言
- **简体中文 (zh-Hans)**: 已完全本地化
- **繁体中文 (zh-Hant)**: 已完全本地化
- **日文 (ja)**: 已完全本地化
- **韩文 (ko)**: 已完全本地化
- **德文 (de)**: 已完全本地化

### 本地化文件结构

```
ChromaFlow/
├── en.lproj/
│   ├── Localizable.strings    # 英文字符串资源
│   └── InfoPlist.strings      # 英文应用信息
├── zh-Hans.lproj/
│   ├── Localizable.strings    # 简体中文字符串资源
│   └── InfoPlist.strings      # 简体中文应用信息
├── zh-Hant.lproj/
│   ├── Localizable.strings    # 繁体中文字符串资源
│   └── InfoPlist.strings      # 繁体中文应用信息
├── ja.lproj/
│   ├── Localizable.strings    # 日文字符串资源
│   └── InfoPlist.strings      # 日文应用信息
├── ko.lproj/
│   ├── Localizable.strings    # 韩文字符串资源
│   └── InfoPlist.strings      # 韩文应用信息
└── de.lproj/
    ├── Localizable.strings    # 德文字符串资源
    └── InfoPlist.strings      # 德文应用信息
```

### 已本地化的内容

#### 1. 主题名称
- 多彩 / 多彩 / Colorful / カラフル / 다채로운 / Bunt
- 绿色 / 綠色 / Green / グリーン / 초록색 / Grün
- 黄色 / 黃色 / Yellow / イエロー / 노란색 / Gelb
- 橙色 / 橙色 / Orange / オレンジ / 주황색 / Orange
- 红色 / 紅色 / Red / レッド / 빨간색 / Rot
- 紫色 / 紫色 / Purple / パープル / 보라색 / Lila
- 蓝色 / 藍色 / Blue / ブルー / 파란색 / Blau
- 暖银 / 暖銀 / Warm Silver / ウォームシルバー / 따뜻한 실버 / Warmes Silber
- 冷银 / 冷銀 / Cool Silver / クールシルバー / 차가운 실버 / Kühles Silber

#### 2. 外观模式
- 自动 / 自動 / Auto / 自動 / 자동 / Automatisch
- 自动(黑色) / 自動(黑色) / Auto (Black) / 自動（ブラック） / 자동 (블랙) / Automatisch (Schwarz)
- 浅色 / 淺色 / Light / ライト / 라이트 / Hell
- 深色 / 深色 / Dark / ダーク / 다크 / Dunkel
- 深色(黑色) / 深色(黑色) / Dark (Black) / ダーク（ブラック） / 다크 (블랙) / Dunkel (Schwarz)

#### 3. UI 元素
- 设置为壁纸 / 設定為桌布 / Set as Wallpaper / 壁紙に設定 / 배경화면으로 설정 / Als Hintergrundbild festlegen
- 打开主界面 / 開啟主介面 / Open Main Window / メインウィンドウを開く / 메인 창 열기 / Hauptfenster öffnen
- 省电模式 / 省電模式 / Power Save Mode / 省電力モード / 절전 모드 / Energiesparmodus
- 开机启动 / 開機啟動 / Launch at Login / ログイン時に起動 / 로그인 시 실행 / Bei Anmeldung starten
- 退出 / 結束 / Quit / 終了 / 종료 / Beenden

#### 4. 提示信息
- 权限请求提示
- 错误提示
- 设置失败提示

### 代码更改

#### 已修改的文件
1. **ContentView.swift**
   - WallpaperTheme 枚举添加了 `localizedName` 属性
   - 按钮文本使用 NSLocalizedString

2. **AppearanceMode.swift**
   - 添加了 `localizedName` 属性
   - 菜单显示使用本地化名称

3. **WallpaperManager.swift**
   - 所有用户提示文本已本地化
   - 菜单项使用本地化字符串

4. **NSApplication+Extensions.swift**
   - 错误提示已本地化

5. **AppDelegate.swift**
   - 窗口标题使用本地化字符串

### 新增文件
- **Localization+Extensions.swift**: 本地化辅助扩展

### 如何添加新的本地化字符串

1. 在 `Localizable.strings` 文件中添加键值对：
   ```
   // en.lproj/Localizable.strings
   "key.name" = "English Text";

   // zh-Hans.lproj/Localizable.strings
   "key.name" = "中文文本";
   ```

2. 在代码中使用：
   ```swift
   Text(NSLocalizedString("key.name", comment: ""))
   ```

### 测试本地化

1. **在 Xcode 中测试**：
   - Product → Scheme → Edit Scheme
   - Run → Options → Application Language
   - 选择不同语言进行测试（English、简体中文、繁體中文、日本語、한국어、Deutsch）

2. **在系统中测试**：
   - 系统偏好设置 → 语言与地区
   - 将首选语言改为英文、简体中文、繁体中文、日文、韩文或德文
   - 重新启动应用

### 注意事项

1. 所有新增的用户界面文本都应该进行本地化
2. 使用格式化字符串时，确保参数顺序在不同语言中保持一致
3. 定期检查本地化文件的完整性
4. 测试所有支持的语言以确保显示正确

## 下一步

如需添加更多语言支持：
1. 在 Xcode 项目设置中添加新语言
2. 创建对应的 `.lproj` 文件夹
3. 翻译所有 `.strings` 文件
4. 测试新语言的显示效果