#!/bin/bash
set -xue

NUM_USERS=${1-1000}
NUM_MAX_MEMBERS=${2-1000}

# backup, export and rename
export TARGETDIR=/tmp/sambabackup
sudo python3 /usr/local/samba/bin/samba-tool domain backup offline --targetdir=${TARGETDIR}
sudo mv ${TARGETDIR}/*.tar.bz2 {{SAMBA_VOLUME}}/samba-backup-docker-{{SAMBA_BACKEND_STORE}}-${NUM_USERS}-max-${NUM_MAX_MEMBERS}.tar.bz2
