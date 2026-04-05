# 灵悦计算器 · 优化版

基于HTML参考版本完全重构的Flutter计算器应用，修复了所有已知bug。

## 🚀 快速开始

### 方法1：一键启动（推荐）
双击 `快速启动.bat`，选择相应选项。

### 方法2：手动构建
1. **打开项目**：双击 `flutter_calculator.iml` 在Android Studio中打开
2. **获取依赖**：运行 `flutter pub get`
3. **构建APK**：运行 `flutter build apk --release`
4. **安装APK**：将 `build/app/outputs/flutter-apk/app-release.apk` 复制到手机安装

## 📱 功能特性

### ✅ 已修复的bug
- **括号功能**：智能括号插入，支持复杂表达式
- **百分比功能**：智能百分比计算，支持括号内百分比
- **历史记录**：美观的格式，支持点击重用
- **键盘支持**：完整的键盘输入（数字、运算符、括号、回车等）
- **UI设计**：现代磨砂效果，匹配HTML参考设计

### 🎨 界面设计
- 亮色磨砂主题
- 渐变背景效果
- 圆角按钮设计
- 底部标签栏装饰
- 响应式布局

## 🛠️ 技术栈

- **Flutter 3.41.6** - 跨平台UI框架
- **Provider 6.1.2** - 状态管理
- **Material Design** - 设计语言
- **原生Android支持** - 完整的APK构建

## 📁 项目结构

```
C:\flutter_calculator\
├── lib/
│   ├── main.dart              # 应用入口
│   ├── screens/
│   │   └── calculator_screen.dart  # 主界面
│   └── providers/
│       └── calculator_provider.dart # 计算逻辑
├── android/                   # Android原生代码
├── ios/                      # iOS原生代码
├── build_apk.bat             # APK构建脚本
├── 快速启动.bat               # 快速启动脚本
└── AndroidStudio构建指南.md   # 详细构建指南
```

## 🔧 构建要求

### 必需软件
1. **Android Studio** (最新版本)
2. **Flutter SDK** (已包含在项目中)
3. **Android SDK** (通过Android Studio安装)

### 环境检查
运行以下命令检查环境：
```bash
flutter doctor
```

如果显示Android许可证问题，运行：
```bash
flutter doctor --android-licenses
```

## 🐛 常见问题

### Q1: Gradle同步失败
**解决方案**：
- 检查网络连接
- 在Android Studio中：File → Invalidate Caches and Restart
- 确保Android SDK已正确安装

### Q2: 缺少Android许可证
**解决方案**：
```bash
flutter doctor --android-licenses
```
出现提示时，按 `y` 接受所有许可证。

### Q3: 构建失败，显示"cmdline-tools missing"
**解决方案**：
1. 打开Android Studio → SDK Manager
2. 在SDK Tools标签页，勾选"Android SDK Command-line Tools (latest)"
3. 点击Apply安装

### Q4: 如何安装到手机？
**解决方案**：
1. 通过USB连接手机，启用USB调试
2. 在Android Studio中点击Run按钮
3. 或手动复制APK到手机安装

## 📞 支持

如果遇到问题：
1. 查看 `AndroidStudio构建指南.md` 获取详细步骤
2. 运行 `build_apk.bat` 查看具体错误信息
3. 检查Android Studio的Build输出窗口

## 🎯 构建成功标志

构建成功后，你将在以下位置找到APK：
```
C:\flutter_calculator\build\app\outputs\flutter-apk\
```

- `app-debug.apk` - 调试版本（用于测试）
- `app-release.apk` - 发布版本（用于分发）

## 📄 许可证

本项目基于MIT许可证开源。

---

**祝你构建成功！** 🎉