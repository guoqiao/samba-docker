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
    --number-of-users={{num_users|int}} \
    --number-of-groups={{num_groups|int}} \
    --average-groups-per-user={{num_groups_per_user|int}} \
    --max-members={{num_max_members|int}} \
    /usr/local/samba/private/sam.ldb
