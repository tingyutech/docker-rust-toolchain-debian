FROM rust:1.86-slim-bookworm

# 设置工作目录
WORKDIR /build

# 安装必要的工具
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    pkg-config \
    cmake \
    build-essential \
    curl \
    git \
    clang \
    lld \
    && rm -rf /var/lib/apt/lists/*

# 安装Android NDK
ARG NDK_VERSION=r28
ENV ANDROID_NDK_HOME=/opt/android-ndk
ENV ANDROID_NDK=/opt/android-ndk

# 下载并设置 Android NDK
RUN mkdir -p ${ANDROID_NDK_HOME} \
    && cd /tmp \
    && wget -q https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux.zip \
    && unzip -q android-ndk-${NDK_VERSION}-linux.zip \
    && mv android-ndk-${NDK_VERSION}/* ${ANDROID_NDK_HOME}/ \
    && rm -rf android-ndk-${NDK_VERSION} android-ndk-${NDK_VERSION}-linux.zip

# 配置 Rust 工具链
RUN rustup target add aarch64-linux-android armv7-linux-androideabi x86_64-linux-android

# 创建 .cargo/config.toml 文件
RUN mkdir -p /root/.cargo
COPY docker/cargo-config.toml /root/.cargo/config.toml

# 设置环境变量
ENV PATH=$PATH:${ANDROID_NDK_HOME}/toolchains/llvm/prebuilt/linux-x86_64/bin

CMD ["bash"]
