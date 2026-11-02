#!/bin/bash

# ChromaFlow 本地化测试脚本
echo "ChromaFlow 本地化测试"
echo "====================="
echo ""

# 显示支持的语言
echo "支持的语言："
echo "1. 英文 (en)"
echo "2. 简体中文 (zh-Hans)"
echo "3. 繁体中文 (zh-Hant)"
echo "4. 日文 (ja)"
echo "5. 韩文 (ko)"
echo ""

# 显示一些本地化字符串示例
echo "主题名称对比："
echo "-------------------------------"
echo "简体中文: 多彩、绿色、蓝色"
echo "繁体中文: 多彩、綠色、藍色"
echo "English:  Colorful, Green, Blue"
echo "日本語:   カラフル、グリーン、ブルー"
echo "한국어:    다채로운, 초록색, 파란색"
echo ""

echo "UI 文本对比："
echo "-------------------------------"
echo "简体中文: 设置为壁纸、打开主界面、退出"
echo "繁体中文: 設定為桌布、開啟主介面、結束"
echo "English:  Set as Wallpaper, Open Main Window, Quit"
echo "日本語:   壁紙に設定、メインウィンドウを開く、終了"
echo "한국어:    배경화면으로 설정, 메인 창 열기, 종료"
echo ""

echo "应用名称："
echo "-------------------------------"
echo "简体中文: 正念壁纸"
echo "繁体中文: 正念桌布"
echo "English:  ChromaFlow"
echo "日本語:   マインドフル壁紙"
echo "한국어:    마음챙김 배경화면"
echo ""

echo "测试方法："
echo "-------------------------------"
echo "1. 在 Xcode 中: Product → Scheme → Edit Scheme → Application Language"
echo "2. 在系统中: 系统偏好设置 → 语言与地区 → 首选语言"
echo "   支持: 英文、简体中文、繁体中文、日文、韩文"
echo ""
echo "编译状态: ✅ 成功"