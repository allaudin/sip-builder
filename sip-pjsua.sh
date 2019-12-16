#!/bin/bash

SERVER_ADDRESS=`cat local-ip`
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
--id=${SCHEME}:${USERNAME}@${SERVER_ADDRESS} \
--local-port=${PORT} \
--play-file=${WAV_FILE} \
--auto-play

