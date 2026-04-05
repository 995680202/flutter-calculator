@echo off
echo ========================================
echo 计算器项目快速启动
echo ========================================
echo.
echo 请选择操作：
echo.
echo 1. 打开项目文件夹
echo 2. 在Android Studio中打开项目
echo 3. 构建APK
echo 4. 查看构建指南
echo 5. 检查环境
echo.
set /p choice="请输入选项 (1-5): "

if "%choice%"=="1" (
    explorer "C:\flutter_calculator"
    goto :end
)

if "%choice%"=="2" (
    echo 正在启动Android Studio...
    start "" "C:\flutter_calculator\flutter_calculator.iml"
    goto :end
)

if "%choice%"=="3" (
    call build_apk.bat
    goto :end
)

if "%choice%"=="4" (
    start "" "C:\flutter_calculator\AndroidStudio构建指南.md"
    goto :end
)

if "%choice%"=="5" (
    echo 检查Flutter环境...
    flutter doctor
    pause
    goto :end
)

echo 无效选项
pause

:end
echo.
echo 操作完成！
pause