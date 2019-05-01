#!/bin/bash
set -xue

./render-templates.yml
docker build -f build/Dockerfile-samba-common -t samba-common:latest build
docker build -f build/Dockerfile-samba-dc -t samba-dc:latest build
