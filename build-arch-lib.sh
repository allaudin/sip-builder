#!/bin/bash

# Author		: M. Allaudin (mallaudinqazi@gmail.com)
# Description	: Generates .so libs for given architecture
# Date			: 06-Dec-2019

SIP_ROOT=$1
ARCH=$2
ARCH_PREFIX=$3
OUPUT_DIR=$4
NDK_ROOT=$5
STRIP_FILE=$6
LIB_NAME=libpjsua2.so

SWIG_PATH=$SIP_ROOT/pjsip-apps/src/swig
TARGET_PATH=$SWIG_PATH/java/android/app/src/main/jniLibs/${ARCH}

if [ -z `which swig`  ]; then sudo apt-get install swig; fi

cd $SWIG_PATH && make

if [ ! -d ${OUPUT_DIR} ]; then mkdir -p ${OUPUT_DIR}; fi

rsync -r $TARGET_PATH ${OUPUT_DIR} && echo "!!! generated lib for ${ARCH} in ${OUPUT_DIR}/${ARCH} !!!"


STRIP_TOOL=${NDK_ROOT}/toolchains/${ARCH_PREFIX}-4.9/prebuilt/linux-x86_64/bin/${STRIP_FILE}
$STRIP_TOOL ${OUPUT_DIR}/${ARCH}/${LIB_NAME}