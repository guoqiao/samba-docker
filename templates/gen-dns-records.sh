#!/bin/bash
set -xue

SAMBA_TOOL="sudo python3 /usr/local/samba/bin/samba-tool"
SAMBA_REALM={{SAMBA_REALM}}
SAMBA_CRED="--username {{ SAMBA_USERNAME }} --password {{ SAMBA_PASSWORD }}"
# samba will create 2 default zones
SAMBA_ZONE_DEFAULT={{SAMBA_REALM}}
SAMBA_ZONE_MSDCS=_msdcs.{{SAMBA_REALM}}

IPV4_ADDR=10.10.10.255
IPV6_ADDR=2404:130:0:1000:d8c6:a0eb:ef0a:d6a7

# create extra zones zone[1-20]
for i in {1..20}
do
    $SAMBA_TOOL dns zonecreate localhost zone$i.$SAMBA_REALM $SAMBA_CRED
done

# samba-tool dns add <server> <zone> <name> <A|AAAA|PTR|CNAME|NS|MX|SRV|TXT> <data>
for i in {1..60}
do
    # add A/AAAA record for each DC to default zone
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_DEFAULT dc$i.$SAMBA_REALM  A    $IPV4_ADDR $SAMBA_CRED
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_DEFAULT dc$i.$SAMBA_REALM  AAAA $IPV6_ADDR $SAMBA_CRED

    # add A/AAAA record for each DC to msdcs zone
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_MSDCS   dc$i.$SAMBA_REALM  A    $IPV4_ADDR $SAMBA_CRED
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_MSDCS   dc$i.$SAMBA_REALM  AAAA $IPV6_ADDR $SAMBA_CRED

    # set each DC as nameserver for both zones
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_DEFAULT dc$i NS dc$i.$SAMBA_REALM $SAMBA_CRED
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_MSDCS   dc$i NS dc$i.$SAMBA_REALM $SAMBA_CRED

done

for name in $($SAMBA_TOOL user list)
do
    # add A/AAAA record for @/* for each user
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_DEFAULT   $name.$SAMBA_REALM  A    $IPV4_ADDR $SAMBA_CRED
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_DEFAULT *.$name.$SAMBA_REALM  A    $IPV4_ADDR $SAMBA_CRED
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_DEFAULT   $name.$SAMBA_REALM  AAAA $IPV6_ADDR $SAMBA_CRED
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_DEFAULT *.$name.$SAMBA_REALM  AAAA $IPV6_ADDR $SAMBA_CRED
done

for name in $($SAMBA_TOOL computer list)
do
    # add A/AAAA record for @/* for each machine
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_DEFAULT   $name.$SAMBA_REALM A    $IPV4_ADDR $SAMBA_CRED
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_DEFAULT *.$name.$SAMBA_REALM A    $IPV4_ADDR $SAMBA_CRED
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_DEFAULT   $name.$SAMBA_REALM AAAA $IPV6_ADDR $SAMBA_CRED
    $SAMBA_TOOL dns add localhost $SAMBA_ZONE_DEFAULT *.$name.$SAMBA_REALM AAAA $IPV6_ADDR $SAMBA_CRED
done
