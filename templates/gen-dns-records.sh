#!/bin/bash
set -xue

SAMBA_TOOL="sudo python3 /usr/local/samba/bin/samba-tool"
SAMBA_REALM={{SAMBA_REALM}}
SAMBA_CRED="--username {{ SAMBA_USERNAME }} --password {{ SAMBA_PASSWORD }}"
# samba will create 2 default zones
SAMBA_ZONE_DEFAULT={{SAMBA_REALM}}
SAMBA_ZONE_MSDCS=_msdcs.{{SAMBA_REALM}}

IPV4_ADDR=10.10.10.10

# create zones
for zone in user computer srv
do
    $SAMBA_TOOL dns zonecreate localhost $SAMBA_CRED $zone.$SAMBA_REALM
done
$SAMBA_TOOL dns zonecreate localhost $SAMBA_CRED 10.10.10.in-addr.arpa

# samba-tool dns add <server> <zone> <name> <A|AAAA|PTR|CNAME|NS|MX|SRV|TXT> <data>
for i in {1..60}
do
    $SAMBA_TOOL dns add localhost $SAMBA_CRED $SAMBA_ZONE_MSDCS   dc$i.$SAMBA_REALM  A  $IPV4_ADDR
    $SAMBA_TOOL dns add localhost $SAMBA_CRED $SAMBA_ZONE_DEFAULT $SAMBA_REALM NS dc$i.$SAMBA_REALM
done

echo add A/PTR record for each user into user zone
for name in $($SAMBA_TOOL user list)
do
    $SAMBA_TOOL dns add localhost $SAMBA_CRED user.$SAMBA_REALM   $name.$SAMBA_REALM A     $IPV4_ADDR
    $SAMBA_TOOL dns add localhost $SAMBA_CRED user.$SAMBA_REALM *.$name.$SAMBA_REALM A     $IPV4_ADDR
    $SAMBA_TOOL dns add localhost $SAMBA_CRED 10.10.10.in-addr.arpa 10 PTR   $name.$SAMBA_REALM
    $SAMBA_TOOL dns add localhost $SAMBA_CRED 10.10.10.in-addr.arpa 10 PTR *.$name.$SAMBA_REALM
done

echo add A/PTR record for each computer into computer zone
for name in $($SAMBA_TOOL computer list)
do
    $SAMBA_TOOL dns add localhost $SAMBA_CRED computer.$SAMBA_REALM   $name.$SAMBA_REALM A     $IPV4_ADDR
    $SAMBA_TOOL dns add localhost $SAMBA_CRED computer.$SAMBA_REALM *.$name.$SAMBA_REALM A     $IPV4_ADDR
    $SAMBA_TOOL dns add localhost $SAMBA_CRED 10.10.10.in-addr.arpa 10 PTR   $name.$SAMBA_REALM
    $SAMBA_TOOL dns add localhost $SAMBA_CRED 10.10.10.in-addr.arpa 10 PTR *.$name.$SAMBA_REALM
    # add SRV record for each computer to srv zone
    $SAMBA_TOOL dns add localhost $SAMBA_CRED srv.$SAMBA_REALM srv.$name SRV '$name.$SAMBA_REALM 8080 0 100'
done
