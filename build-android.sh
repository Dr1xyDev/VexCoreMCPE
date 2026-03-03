#!/bin/bash
set -e

PHP_VERSION=8.0.24
NDK_VERSION=26.1.10909125
API=21

wget https://www.php.net/distributions/php-$PHP_VERSION.tar.gz
tar -xf php-$PHP_VERSION.tar.gz
cd php-$PHP_VERSION

export ANDROID_NDK=$ANDROID_NDK_ROOT
export TOOLCHAIN=$ANDROID_NDK/toolchains/llvm/prebuilt/linux-x86_64
export TARGET=aarch64-linux-android
export API=$API

export CC=$TOOLCHAIN/bin/${TARGET}${API}-clang
export CXX=$TOOLCHAIN/bin/${TARGET}${API}-clang++
export AR=$TOOLCHAIN/bin/llvm-ar
export LD=$TOOLCHAIN/bin/ld
export RANLIB=$TOOLCHAIN/bin/llvm-ranlib
export STRIP=$TOOLCHAIN/bin/llvm-strip

./configure \
  --host=$TARGET \
  --enable-cli \
  --enable-zts \
  --enable-pthreads \
  --disable-cgi \
  --disable-phpdbg \
  --without-pear \
  --enable-mbstring \
  --enable-sockets \
  --enable-pcntl \
  --enable-phar \
  --enable-bcmath \
  --enable-ctype \
  --enable-shmop \
  --enable-calendar \
  --enable-static \
  --disable-shared

make -j$(nproc)

mkdir -p ../output
cp sapi/cli/php ../output/php
