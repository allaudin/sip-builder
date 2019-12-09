#!/bin/bash

make clean sync
make x86
make x86_64
make arm64-v8a
make armeabi-v7a
make archiveOutput
if [ -z `which pjsua`  ]; then make pjsua; fi