#!/bin/bash -x

./script/traffic_replay \
    --debuglevel 3 \
    --username {{SAMBA_USERNAME}} \
    --password {{SAMBA_PASSWORD}}  \
    --realm {{SAMBA_REALM}} \
    --workgroup {{SAMBA_REALM}} \
    --fixed-password iegh1haevoofoo3looT9  \
    --random-seed=1 \
    --option='ldb:nosync=true' \
    --generate-users-only \
    --number-of-users=100 \
    --number-of-groups=10 \
    --average-groups-per-user=5 \
    /usr/local/samba/private/sam.ldb
