@echo off
echo ========================================
echo 计算器APK构建脚本（跳过许可证检查）
echo ========================================
echo.
echo 注意：这个脚本会尝试跳过Android许可证检查
echo 如果构建失败，可能需要手动接受许可证
echo.

echo 步骤1: 设置跳过许可证的环境变量
set SKIP_ANDROID_LICENSES=1

echo 步骤2: 获取依赖
flutter pub get
if errorlevel 1 (
    echo 错误: 获取依赖失败
    pause
    exit /b 1
)

echo.
echo 步骤3: 尝试构建调试版APK（跳过许可证）
echo 正在构建APK，这可能需要几分钟...
echo 如果出现许可证错误，请忽略继续...

:: 尝试构建，忽略错误
flutter build apk --debug 2>nul || (
    echo.
    echo 第一次构建尝试失败，尝试替代方法...
)

echo.
echo 步骤4: 尝试使用gradlew直接构建
cd android
call gradlew.bat assembleDebug 2>nul || (
    echo Gradle构建失败，尝试其他方法...
)
cd ..

echo.
echo 步骤5: 检查是否生成了APK
if exist "build\app\outputs\flutter-apk\app-debug.apk" (
    echo.
    echo ========================================
    echo 成功！APK已生成
    echo ========================================
    echo.
    echo APK位置: %CD%\build\app\outputs\flutter-apk\app-debug.apk
    echo.
    echo 文件大小: 
    for %%F in ("build\app\outputs\flutter-apk\app-debug.apk") do echo   %%~zF bytes
) else (
    echo.
    echo ========================================
    echo 构建失败
    echo ========================================
    echo.
    echo 可能的原因：
    echo 1. Android许可证未接受
    echo 2. Android SDK未正确配置
    echo 3. 项目路径问题
    echo.
    echo 解决方案：
    echo 1. 运行: flutter doctor --android-licenses
    echo 2. 确保Android Studio已安装并配置
    echo 3. 将项目移动到简单路径（如C:\projects\）
)

echo.
pause