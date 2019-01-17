#!/usr/bin/env bash

set -xue

chown samba:samba -R $SAMBA/bin
rm -f $SAMBA/.lock-wscript

exec "$@"
