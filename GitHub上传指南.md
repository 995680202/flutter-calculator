# GitHub上传指南

## 方法一：使用脚本（推荐）

1. 双击 `upload_to_github.bat`
2. 按照提示输入GitHub仓库URL
3. 脚本会自动上传所有文件

## 方法二：手动上传

### 步骤1：创建GitHub仓库
1. 访问 https://github.com
2. 登录你的账号
3. 点击右上角 **+** → **New repository**
4. 填写：
   - Repository name: `flutter-calculator` (建议)
   - Description: "修复了所有bug的计算器应用"
   - 选择 **Public**
   - 不要勾选 "Add a README file"
5. 点击 **Create repository**

### 步骤2：上传文件
创建后，你会看到上传页面：

**选项A：拖拽上传（最简单）**
1. 打开文件资源管理器，导航到 `C:\flutter_calculator`
2. 选择所有文件和文件夹
3. 拖拽到GitHub页面的文件区域
4. 点击 **Commit changes**

**选项B：使用Git命令**
```bash
# 1. 安装Git（如果还没安装）
# 下载: https://git-scm.com/downloads

# 2. 打开命令提示符，导航到项目
cd C:\flutter_calculator

# 3. 初始化Git
git init

# 4. 添加所有文件
git add .

# 5. 提交
git commit -m "初始提交：修复了所有bug的计算器"

# 6. 添加远程仓库（替换URL）
git remote add origin https://github.com/你的用户名/flutter-calculator.git

# 7. 推送
git branch -M main
git push -u origin main
```

**选项C：使用GitHub Desktop**
1. 下载GitHub Desktop: https://desktop.github.com/
2. 登录你的GitHub账号
3. 点击 **File** → **Add Local Repository**
4. 选择 `C:\flutter_calculator`
5. 点击 **Publish repository**

## 方法三：压缩包上传

1. 右键点击 `C:\flutter_calculator` 文件夹
2. 选择 **发送到** → **压缩(zipped)文件夹**
3. 在GitHub仓库页面，点击 **Add file** → **Upload files**
4. 拖拽或选择压缩包
5. 点击 **Commit changes**

## 上传后

上传完成后，请告诉我：
1. **你的GitHub用户名**
2. **仓库名称**

例如：
- 用户名: `zhangsan`
- 仓库名: `flutter-calculator`

## 我会为你做什么

收到信息后，我会：
1. ✅ 配置GitHub Actions自动构建
2. ✅ 设置APK自动发布
3. ✅ 提供APK下载链接
4. ✅ 确保每次代码更新都自动构建新APK

## 验证上传

上传成功后，你的仓库应该包含以下文件：
- `lib/` - 源代码
- `pubspec.yaml` - 依赖配置
- `build_apk.bat` - 构建脚本
- `.github/workflows/build-apk.yml` - 自动构建配置（我添加的）

## 问题解决

### Q: 上传失败，显示权限错误
**A**: 可能需要GitHub身份验证。使用GitHub Desktop或生成Personal Access Token。

### Q: 文件太大上传失败
**A**: 确保没有上传 `build/`、`.dart_tool/` 等临时文件夹。

### Q: 不知道GitHub仓库URL
**A**: 格式是：`https://github.com/用户名/仓库名.git`

## 下一步

上传完成后，APK将在几分钟内自动构建。你可以在仓库的 **Actions** 标签页查看构建进度，在 **Releases** 标签页下载APK。

**现在开始上传吧！完成后告诉我你的GitHub信息。**