#!/bin/bash -x

/usr/local/samba/bin/samba-tool domain provision \
    --use-rfc2307 \
    --server-role=dc \
    --realm="{{SAMBA_REALM}}" \
    --domain="{{SAMBA_DOMAIN}}" \
    --backend-store='{{SAMBA_BACKEND_STORE}}' \
    --adminpass='{{SAMBA_PASSWORD}}' \
    --krbtgtpass='{{SAMBA_PASSWORD}}' \
    --machinepass='{{SAMBA_PASSWORD}}' \
    --dnspass='{{SAMBA_PASSWORD}}' \
    --option='dns forwarder=8.8.8.8' \
    --option='kccsrv:samba_kcc=true' \
    --option='ldapserverrequirestrongauth=no'
