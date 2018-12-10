#!/bin/bash -x

SERVER=${1-dc0}  # join to this server
ROLE=${2-DC}  # join as this role

sudo python3 /usr/local/samba/bin/samba-tool \
    domain join {{SAMBA_DOMAIN}} $ROLE \
    --server=$SERVER \
    --backend-store={{SAMBA_BACKEND_STORE}} \
    --realm={{SAMBA_REALM}} \
    --adminpass={{SAMBA_PASSWORD}} \
    --username={{SAMBA_USERNAME}} \
    --password={{SAMBA_PASSWORD}}
