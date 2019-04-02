#!/bin/bash

set -xue

# so we can run this script from any where
export PYTHONPATH="{{SAMBA_REPO_DIR}}/bin/python"

cd {{ SAMBA_REPO_DIR }}

sudo python3 script/traffic_replay \
    --debuglevel 3 \
    --username {{SAMBA_USERNAME}} \
    --password {{SAMBA_PASSWORD}}  \
    --realm {{SAMBA_REALM}} \
    --workgroup {{SAMBA_REALM}} \
    --fixed-password iegh1haevoofoo3looT9  \
    --random-seed=1 \
    --option='ldb:nosync=true' \
    --generate-users-only \
    --number-of-users={{ NUM_USERS }} \
    --number-of-groups={{ NUM_GROUPS }} \
    --max-members={{ NUM_MAX_MEMBERS }} \
    --average-groups-per-user={{ NUM_AVERAGE_GEOUPS_PER_USER }} \
    /usr/local/samba/private/sam.ldb
