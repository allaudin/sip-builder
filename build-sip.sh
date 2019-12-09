#!/bin/bash

# Author		: M. Allaudin (mallaudinqazi@gmail.com)
# Description	: Build pjsip
# Date			: 06-Dec-2019

# args: arch, ndk-root-dir, sip-root-dir, sip-android-config-file, ssl-root-dir

export TARGET_ABI=$1
export ANDROID_NDK_ROOT=$2
export APP_PLATFORM=android-19
export NDK_TOOLCHAIN_VERSION=4.9

SIP_ROOT=$3
SIP_ANDROID_CONFIG=$4
SSL_ROOT_DIR=$5


cd ${SIP_ROOT} && ${SIP_ANDROID_CONFIG} --use-ndk-cflags --with-ssl=${SSL_ROOT_DIR} && make dep && make && cd -