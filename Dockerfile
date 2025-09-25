FROM rust:1.90-slim-trixie

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
    protobuf-compiler \
    ninja-build \
    libgbm-dev \
    libxcb1 \
    libxdo-dev \
    libwayland-dev \
    libpipewire-0.3-dev \
    libegl-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavfilter-dev \
    libavformat-dev \
    libavutil-dev \
    libswresample-dev \
    libswscale-dev \
    libdbus-1-3 \

    && apt-get clean \
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
RUN rustup target add x86_64-unknown-linux-gnu aarch64-linux-android armv7-linux-androideabi wasm32-unknown-unknown
RUN cargo install cargo-ndk wasm-bindgen-cli wasm-pack cargo-cache && cargo cache --remove-dir all

CMD ["bash"]
