#!/bin/bash

# https://kamailio.org/docs/tutorials/5.2.x/kamailio-install-guide-git/
# Config File: /usr/local/etc/kamailio/kamailio.cfg

KAMAILIO_ROOT=$1

cd ${KAMAILIO_ROOT}
make include_modules="db_mysql" cfg
sudo make all && sudo make install
sudo make install-systemd-debian