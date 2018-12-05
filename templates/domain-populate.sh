#!/bin/bash -x

PYTHONPATH="${SAMBA_REPO_DIR}/bin/python"

# arg 1 with default
NUM_USERS=${1-100000}
NUM_MAX_MEMBERS=${2-100000}

{{SAMBA_REPO_DIR}}/script/traffic_replay \
    --debuglevel 3 \
    --username {{SAMBA_USERNAME}} \
    --password {{SAMBA_PASSWORD}}  \
    --realm {{SAMBA_REALM}} \
    --workgroup {{SAMBA_REALM}} \
    --fixed-password iegh1haevoofoo3looT9  \
    --random-seed=1 \
    --option='ldb:nosync=true' \
    --generate-users-only \
    --number-of-users=${NUM_USERS} \
    --number-of-groups=$(expr $NUM_USERS / 10) \
    --max-members=${NUM_MAX_MEMBERS} \
    --average-groups-per-user=10 \
    /usr/local/samba/private/sam.ldb

# backup, export and rename
export TARGETDIR=/tmp/sambabackup
/usr/local/samba/bin/samba-tool domain backup offline --targetdir=${TARGETDIR}
mv ${TARGETDIR}/*.tar.bz2 /volume/samba-backup-docker-{{SAMBA_BACKEND_STORE}}-${NUM_USERS}-max-${NUM_MAX_MEMBERS}.tar.bz2
