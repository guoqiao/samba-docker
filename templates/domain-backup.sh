#!/bin/bash
set -xue

# backup, export and rename
export TARGETDIR=/tmp/sambabackup
sudo python3 /usr/local/samba/bin/samba-tool domain backup offline --targetdir=${TARGETDIR}
sudo mv ${TARGETDIR}/*.tar.bz2 /volume/samba-backup-docker-{{SAMBA_BACKEND_STORE}}-${NUM_USERS}-max-${NUM_MAX_MEMBERS}.tar.bz2
