#!/bin/bash -x
set -e
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -yq locales
locale-gen en_US.UTF-8
update-locale LANGUAGE=en_US:en LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

apt-get -yq install apt-utils sudo inetutils-ping ncdu vim
apt-get -yq install {% for item in packages %}{{item}} {% endfor %}

apt-get -y clean
apt-get -y autoremove

ln -sf /usr/bin/ld.gold /usr/bin/ld
