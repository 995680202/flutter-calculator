@echo off
echo ========================================
echo GitHub上传脚本
echo ========================================
echo.
echo 请按照以下步骤操作：
echo.
echo 1. 首先在GitHub创建仓库：
echo    1) 登录 https://github.com
echo    2) 点击右上角 + → New repository
echo    3) 输入仓库名（如 flutter-calculator）
echo    4) 点击 Create repository
echo.
echo 2. 复制仓库URL（格式如：https://github.com/用户名/仓库名.git）
echo.
set /p repo_url="请输入GitHub仓库URL: "

echo.
echo 3. 正在初始化Git并上传...
echo.

:: 初始化Git
git init
if errorlevel 1 (
    echo 错误: Git未安装或未添加到PATH
    echo 请先安装Git: https://git-scm.com/downloads
    pause
    exit /b 1
)

:: 添加文件
git add .
if errorlevel 1 (
    echo 错误: 添加文件失败
    pause
    exit /b 1
)

:: 提交
git commit -m "初始提交：修复了所有bug的计算器应用"
if errorlevel 1 (
    echo 错误: 提交失败
    pause
    exit /b 1
)

:: 设置远程仓库
git remote add origin "%repo_url%"
if errorlevel 1 (
    echo 错误: 设置远程仓库失败
    echo 请检查URL是否正确
    pause
    exit /b 1
)

:: 推送
git branch -M main
git push -u origin main
if errorlevel 1 (
    echo.
    echo 错误: 推送失败
    echo.
    echo 可能的原因：
    echo 1. 需要GitHub身份验证
    echo 2. URL错误
    echo 3. 网络问题
    echo.
    echo 解决方案：
    echo 1. 使用GitHub Desktop客户端
    echo 2. 或手动压缩文件夹上传
    pause
    exit /b 1
)

echo.
echo ========================================
echo 上传成功！
echo ========================================
echo.
echo 接下来：
echo 1. 打开仓库页面: %repo_url%
echo 2. 告诉我你的GitHub用户名和仓库名
echo 3. 我会为你配置自动构建
echo.
echo 完成后，APK将自动构建并可下载
echo.
pause