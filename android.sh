#!/usr/bin/env bash

DIR=$(
  cd "$(dirname "$0")"
  pwd
)
set -ex
cd $DIR

rustup +nightly target add aarch64-linux-android
#export NDK=$DIR/../android-ndk-r21e

export API=30

export NDK_VERSION=24.0.8215888

export TARGET=aarch64-linux-android

export os=$(uname -s | awk '{ print tolower($0) }')
export NDK=$HOME/Library/Android/sdk/ndk/$NDK_VERSION
export ANDROID_NDK_HOME=$NDK
export TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$os-x86_64
export PATH=$TOOLCHAIN/bin:$PATH
export AR=$TOOLCHAIN/bin/$TARGET-ar
export AS=$TOOLCHAIN/bin/$TARGET-as
export CC=$TOOLCHAIN/bin/$TARGET$API-clang
export CXX=$TOOLCHAIN/bin/$TARGET$API-clang++
export LD=$TOOLCHAIN/bin/$TARGET-ld
export RANLIB=$TOOLCHAIN/bin/$TARGET-ranlib
export STRIP=$TOOLCHAIN/bin/$TARGET-strip

# 根据 TARGET 修改
export CARGO_TARGET_AARCH64_LINUX_ANDROID_LINKER=$CC

echo 'AR = '$AR
echo 'AS = '$AS
echo 'CC = '$CC
echo 'CXX = '$CXX
echo 'LD = '$LD
echo 'RANLIB = '$RANLIB
echo 'STRIP = '$STRIP

#V8_FROM_SOURCE=1
#GN_ARGS='target_os="android" target_cpu="arm"'
#RUSTFLAGS="-C target-feature=+aes" \

#RUSTFLAGS="-Clink-arg=-Wl,--allow-multiple-definition" \
RUSTFLAGS="-C target-feature=+crt-static" \
  RUST_BACKTRACE=1 \
  cargo +nightly build --release --target aarch64-linux-android

ls -alh ./target/aarch64-linux-android/release/rg
