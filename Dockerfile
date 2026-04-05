# 使用官方Flutter Docker镜像
FROM cirrusci/flutter:3.41.6

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY . .

# 接受Android许可证
RUN yes | flutter doctor --android-licenses

# 获取依赖
RUN flutter pub get

# 构建APK
RUN flutter build apk --release

# 将APK复制到输出目录
RUN mkdir -p /output
RUN cp build/app/outputs/flutter-apk/app-release.apk /output/calculator.apk

# 输出APK位置
CMD ["echo", "APK built at /output/calculator.apk"]