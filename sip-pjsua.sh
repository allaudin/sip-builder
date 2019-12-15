#!/bin/bash

SERVER_ADDRESS=192.168.179.27
PORT=9000
SCHEME=sip
WAV_FILE=`pwd`/output.wav

USERNAME=allaudin1
PASSWORD=allaudin1

pjsua \
--username=${USERNAME} \
--password=${PASSWORD} \
--registrar=${SCHEME}:${SERVER_ADDRESS} \
--realm=* \
--id=${SCHEME}:allaudin1@${SERVER_ADDRESS} \
--local-port=${PORT} \
--play-file=${WAV_FILE} \
--auto-play

