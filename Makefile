# Author		: M. Allaudin (mallaudinqazi@gmail.com)
# Description	: Generates sip binaries for android
# Version		: 1.0.0   
# Date			: 01-June-2019
# Usage		 	: make {arch}
# Bash Version	: 4.4.20(1)-release (x86_64-pc-linux-gnu)
# Dependencies	: build-openssl.sh build-sip.sh 
#				  build-arch-lib.sh

#=========================================================

WORKING_DIR=$(shell pwd)

SIP_VERSION=2.9
SIP_ROOT=${WORKING_DIR}/pjproject-${SIP_VERSION}
SIP_ARCHIVE=pjproject-${SIP_VERSION}.zip
SIP_DOWNLOAD_LINK=https://www.pjsip.org/release/${SIP_VERSION}/${SIP_ARCHIVE}

SSL_VERSION_NUMBER=1.1.1
SSL_VERSION=${SSL_VERSION_NUMBER}c
SSL_ROOT=${WORKING_DIR}/openssl-${SSL_VERSION}
SSL_ARCHIVE=openssl-${SSL_VERSION}.tar.gz
SSL_DOWNLOAD_LINK=https://www.openssl.org/source/old/${SSL_VERSION_NUMBER}/${SSL_ARCHIVE}


NDK_VERSION=r16b
NDK_ROOT=${WORKING_DIR}/android-ndk-${NDK_VERSION}
NDK_ARCHIVE=android-ndk-${NDK_VERSION}-linux-x86_64.zip
NDK_DOWNLOAD_LINK=https://dl.google.com/android/repository/${NDK_ARCHIVE}

SITE_CONFIG=${SIP_ROOT}/pjlib/include/pj/config_site.h
SIP_ANDROID_CONFIG=configure-android

LIBS_DIR=${WORKING_DIR}/output
JNI_LIBS_DIR=${LIBS_DIR}/jniLibs
JNI_SRCS_DIR=${LIBS_DIR}/src
SIP_INCLUDE_DIR=${LIBS_DIR}/include

OUTPUT_TAR=gz.tar.output

X86=x86
X86_64=x86_64
ARM64_V8A=arm64-v8a
ARMEABI_V7A=armeabi-v7a

$(X86)-prefix=x86
$(X86)-strip=i686-linux-android-strip

$(X86_64)-prefix=x86_64
$(X86_64)-strip=x86_64-linux-android-strip

$(ARM64_V8A)-prefix=aarch64-linux-android
$(ARM64_V8A)-strip=aarch64-linux-android-strip

$(ARMEABI_V7A)-prefix=arm-linux-androideabi
$(ARMEABI_V7A)-strip=arm-linux-androideabi-strip

sync: syncOpenssl syncPjsip syncNdk

syncPjsip:
	rm -rf ${SIP_ROOT}
	@if [ ! -f ${SIP_ARCHIVE} ]; then \
	wget ${SIP_DOWNLOAD_LINK}; fi
	unzip ${SIP_ARCHIVE} 

syncOpenssl:
	rm -rf ${SSL_ROOT}
	@if [ ! -f ${SSL_ARCHIVE} ]; then \
	wget ${SSL_DOWNLOAD_LINK}; fi
	@tar -xvf ${SSL_ARCHIVE} 

syncNdk:
	rm -rf ${NDK_ROOT}
	@if [ ! -f ${NDK_ARCHIVE} ]; then \
	wget ${NDK_DOWNLOAD_LINK}; fi
	unzip ${NDK_ARCHIVE}

configSip: syncPjsip fixAndroidConfig
	cat ${WORKING_DIR}/config.h > ${SITE_CONFIG}

fixAndroidConfig:
	chmod +x ${SIP_ROOT}/${SIP_ANDROID_CONFIG} ${SIP_ROOT}/configure ${SIP_ROOT}/aconfigure
	@if [ -z `which dos2unix`  ]; then sudo apt-get install dos2unix; fi
	dos2unix ${SIP_ROOT}/${SIP_ANDROID_CONFIG}

$(X86):
	$(call generate_lib,$(X86))

$(X86_64):
	$(call generate_lib,$(X86_64))
	
$(ARM64_V8A):
	$(call generate_lib,$(ARM64_V8A))

$(ARMEABI_V7A):
	$(call generate_lib,$(ARMEABI_V7A))

$(X86) $(X86_64) $(ARM64_V8A) $(ARMEABI_V7A): syncOpenssl configSip

pjsua: syncPjsip
	chmod +x ${SIP_ROOT}/configure ${SIP_ROOT}/aconfigure; cd ${SIP_ROOT}; \
	./configure && make dep && make
	sudo rsync ${SIP_ROOT}/pjsip-apps/bin/pjsua-* /usr/local/bin/pjsua


collectSources:
	rsync -r ${SIP_ROOT}/pjsip-apps/src/swig/java/android/app/src/main/java/ ${JNI_SRCS_DIR}
	for dir in pjlib pjlib-util pjnath pjmedia pjsip; do \
	rsync -r ${SIP_ROOT}/"$${dir}"/include/* ${SIP_INCLUDE_DIR} ; done
	cp -rf ${SITE_CONFIG} ${LIBS_DIR}

archiveOutput: collectSources
	tar -czvf ${OUTPUT_TAR} -C ${LIBS_DIR} . 

push:
	@git add . && git commit -m "auto update" && git push || true

versions:
	@echo "ndk: ${NDK_VERSION}\npjsip: ${SIP_VERSION}\nopenssl: ${SSL_VERSION}"

clean:
	rm -rf ${NDK_ROOT} ${SIP_ROOT} ${SSL_ROOT} ${LIBS_DIR}

copyTo:
	rsync -r ${JNI_SRCS_DIR}/* ${TARGET_SRC_DIR}; rsync -r ${JNI_LIBS_DIR} ${TARGET_LIB_DIR}
	rm -rf ${TARGET_SRC_DIR}/org/pjsip/pjsua2/app
	rm -rf ${TARGET_SRC_DIR}/org/pjsip/PjCamera.java
	rm -rf ${TARGET_SRC_DIR}/org/pjsip/PjCameraInfo.java

reloadOutput:
	rm -rf ${LIBS_DIR} && mkdir ${LIBS_DIR}
	tar -xzf ${OUTPUT_TAR} -C ${LIBS_DIR}

define generate_lib
	${WORKING_DIR}/build-openssl.sh ${NDK_ROOT} $(1) $($(1)-prefix) ${SSL_ROOT}
	${WORKING_DIR}/build-sip.sh $(1) ${NDK_ROOT} ${SIP_ROOT} ${SIP_ROOT}/${SIP_ANDROID_CONFIG} ${SSL_ROOT}
	${WORKING_DIR}/build-arch-lib.sh ${SIP_ROOT} $(1) $($(1)-prefix) ${JNI_LIBS_DIR} ${NDK_ROOT} $($(1)-strip)
endef
