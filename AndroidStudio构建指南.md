# 计算器APK - Android Studio构建指南

## 项目概述
这是一个修复了所有bug的计算器应用，基于HTML参考版本重新设计，包含：
- ✅ 括号功能（智能插入）
- ✅ 百分比功能（智能计算）
- ✅ 历史记录（美观格式）
- ✅ 键盘支持（完整键盘输入）
- ✅ 现代UI设计（磨砂效果）

## 第一步：打开项目

### 方法A：通过Android Studio打开
1. 启动 **Android Studio**
2. 点击 **Open** 按钮
3. 导航到 `C:\flutter_calculator`
4. 点击 **OK** 打开项目

### 方法B：直接双击打开
1. 打开文件资源管理器
2. 导航到 `C:\flutter_calculator`
3. 双击 `flutter_calculator.iml` 文件
4. Android Studio会自动打开

## 第二步：等待项目同步

打开项目后：
1. Android Studio会自动开始 **Gradle Sync**
2. 等待右下角的进度条完成
3. 如果提示安装缺失组件，点击 **Install** 安装

## 第三步：配置Android SDK（如果未配置）

### 检查Android SDK配置：
1. 点击 **File** → **Settings** (Windows) 或 **Android Studio** → **Preferences** (Mac)
2. 导航到 **Appearance & Behavior** → **System Settings** → **Android SDK**
3. 确保已安装：
   - ✅ Android SDK Build-Tools (最新版本)
   - ✅ Android SDK Platform-Tools
   - ✅ Android SDK Command-line Tools

### 如果缺少组件：
1. 在 **SDK Platforms** 标签页，选择最新的Android版本（如Android 14）
2. 在 **SDK Tools** 标签页，勾选缺失的工具
3. 点击 **Apply** 安装

## 第四步：接受Android许可证（重要！）

### 方法A：通过Android Studio
1. 在Android Studio中，点击 **Tools** → **SDK Manager**
2. 点击 **SDK Tools** 标签页
3. 如果看到警告图标，点击修复链接接受许可证

### 方法B：通过命令行（推荐）
1. 打开 **命令提示符** 或 **PowerShell**
2. 运行以下命令：
   ```cmd
   cd C:\flutter_calculator
   flutter doctor --android-licenses
   ```
3. 出现提示时，按 `y` 然后回车接受所有许可证

## 第五步：构建APK

### 方法A：使用Android Studio图形界面
1. 点击右侧的 **Gradle** 面板（如果没有显示，点击 View → Tool Windows → Gradle）
2. 展开项目树：`flutter_calculator` → `Tasks` → `build`
3. 双击以下任务之一：
   - `assembleDebug` - 构建调试版APK
   - `assembleRelease` - 构建发布版APK

### 方法B：使用终端
1. 在Android Studio中，点击底部的 **Terminal** 标签
2. 运行以下命令：
   ```bash
   # 获取依赖
   flutter pub get
   
   # 构建调试版APK
   flutter build apk --debug
   
   # 或构建发布版APK
   flutter build apk --release
   ```

### 方法C：使用我提供的批处理脚本
1. 打开文件资源管理器，导航到 `C:\flutter_calculator`
2. 双击 `build_apk.bat`
3. 按照脚本提示操作

## 第六步：找到生成的APK

构建完成后，APK文件位于：
```
C:\flutter_calculator\build\app\outputs\flutter-apk\
```

具体文件：
- **调试版**: `app-debug.apk` (用于测试)
- **发布版**: `app-release.apk` (用于分发)

## 第七步：安装到手机

### 方法A：通过USB连接
1. 用USB线连接Android手机到电脑
2. 在手机上启用 **USB调试**：
   - 设置 → 关于手机 → 连续点击版本号7次启用开发者选项
   - 返回设置 → 开发者选项 → 启用USB调试
3. 在Android Studio中运行应用：
   - 点击顶部工具栏的 **Run** 按钮（绿色三角形）
   - 选择你的手机设备
   - 应用会自动安装并运行

### 方法B：手动安装APK
1. 将APK文件复制到手机（通过USB、微信、QQ等）
2. 在手机上找到APK文件
3. 点击安装（可能需要允许"未知来源"安装）

## 故障排除

### 问题1：Gradle Sync失败
**解决方案：**
1. 点击 **File** → **Invalidate Caches and Restart**
2. 选择 **Invalidate and Restart**
3. 等待Android Studio重启

### 问题2：缺少依赖
**解决方案：**
1. 在终端运行：`flutter pub get`
2. 或点击Android Studio右上角的 **Pub get** 按钮

### 问题3：Android许可证未接受
**解决方案：**
```cmd
flutter doctor --android-licenses
```
出现提示时，一直按 `y` 然后回车

### 问题4：构建失败，显示"cmdline-tools missing"
**解决方案：**
1. 打开Android Studio的SDK Manager
2. 在 **SDK Tools** 标签页，勾选 **Android SDK Command-line Tools (latest)**
3. 点击 **Apply** 安装

### 问题5：路径包含中文字符
**解决方案：**
项目已经在 `C:\flutter_calculator`，不包含中文字符，不会有此问题。

## 快速检查清单

在开始构建前，请确认：
- ✅ 项目位置：`C:\flutter_calculator` (无中文字符)
- ✅ Android Studio已安装
- ✅ Flutter插件已安装（Android Studio会自动提示安装）
- ✅ Android SDK已配置
- ✅ Android许可证已接受

## 技术支持

如果遇到任何问题：
1. 查看 `C:\flutter_calculator\build_apk.bat` 运行输出
2. 检查Android Studio的 **Build** 输出窗口
3. 运行 `flutter doctor` 检查环境

## 项目特点

你即将构建的计算器包含以下修复和改进：

### 已修复的bug：
1. **括号功能** - 添加了智能括号插入
2. **百分比功能** - 改进百分比计算逻辑
3. **历史记录** - 美观的格式和交互
4. **键盘支持** - 完整的键盘输入
5. **UI设计** - 现代磨砂效果设计

### 技术改进：
- 使用Provider进行状态管理
- 支持复杂表达式计算
- 响应式UI设计
- 键盘事件处理

祝你构建成功！