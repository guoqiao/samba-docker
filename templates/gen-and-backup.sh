#!/bin/bash
set -xue

sudo bash gen-users.sh
sudo bash gen-dns-records.sh
sudo bash domain-backup.sh

