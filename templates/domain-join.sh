#!/bin/bash -x

ROLE=${1-DC}

/usr/local/samba/bin/samba-tool \
    domain join {{SAMBA_DOMAIN}} $ROLE \
    --server={{SAMBA_PDC_NAME}} \
    --backend-store={{SAMBA_BACKEND_STORE}} \
    --realm={{SAMBA_REALM}} \
    --adminpass={{SAMBA_PASSWORD}} \
    --username={{SAMBA_USERNAME}} \
    --password={{SAMBA_PASSWORD}}
