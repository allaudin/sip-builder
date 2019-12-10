#!/bin/bash

# Author		: M. Allaudin (mallaudinqazi@gmail.com)
# Description	: Generates openssl for sip
# Date			: 06-Dec-2019

export ANDROID_NDK_HOME=$1
ARCH=$2
ARCH_PREFIX=$3
SSL_ROOT=$4

API_LEVEL=21
ARCH_NAME=""

case "${ARCH}" in
    "x86")
        API_LEVEL=19
        ARCH_NAME=android-x86
        ;;
    "x86_64")
        ARCH_NAME=android-x86_64
        ;;
    "arm64-v8a")
        ARCH_NAME=android-arm64
        ;;
    "armeabi-v7a")
        API_LEVEL=19
        ARCH_NAME=android-arm
        ;;
    *)
        echo "Invalid architecture ${ARCH} for building openssl !!!"
        exit 1
        ;;
esac



TOOLCHAINS=$ANDROID_NDK_HOME/toolchains/${ARCH_PREFIX}-4.9/prebuilt/linux-x86_64/bin
export PATH=$TOOLCHAINS:$PATH

cd ${SSL_ROOT} && chmod +x ./Configure
./Configure ${ARCH_NAME} -D__ANDROID_API__=${API_LEVEL} && make
mkdir lib && mv *.a lib
