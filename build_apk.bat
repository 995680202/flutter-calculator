@echo off
echo ========================================
echo 计算器APK构建脚本
echo ========================================
echo.

echo 步骤1: 检查Flutter环境
flutter --version
if errorlevel 1 (
    echo 错误: Flutter未安装或未添加到PATH
    pause
    exit /b 1
)

echo.
echo 步骤2: 获取依赖
flutter pub get
if errorlevel 1 (
    echo 错误: 获取依赖失败
    pause
    exit /b 1
)

echo.
echo 步骤3: 检查Android许可证
echo 注意: 如果这是第一次构建，需要接受Android许可证
echo 请按Y接受所有许可证
flutter doctor --android-licenses
if errorlevel 1 (
    echo 警告: 许可证接受失败，但继续尝试构建...
)

echo.
echo 步骤4: 构建调试版APK
echo 正在构建APK，这可能需要几分钟...
flutter build apk --debug
if errorlevel 1 (
    echo.
    echo 错误: APK构建失败
    echo.
    echo 可能的解决方案:
    echo 1. 确保Android Studio已安装并配置了Android SDK
    echo 2. 运行: flutter doctor --android-licenses 接受所有许可证
    echo 3. 检查Android SDK路径是否正确
    echo 4. 确保项目路径不包含中文字符
    pause
    exit /b 1
)

echo.
echo 步骤5: 构建发布版APK
echo 正在构建发布版APK...
flutter build apk --release
if errorlevel 1 (
    echo 警告: 发布版构建失败，但调试版已成功
    echo 你可以使用调试版APK进行测试
)

echo.
echo ========================================
echo 构建完成!
echo ========================================
echo.
echo 生成的APK文件位置:
echo 调试版: %CD%\build\app\outputs\flutter-apk\app-debug.apk
echo 发布版: %CD%\build\app\outputs\flutter-apk\app-release.apk
echo.
echo 将APK文件复制到Android手机安装即可使用
echo.
pause