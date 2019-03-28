#!/bin/bash
set -xue

SAMBA_TOOL="sudo python3 /usr/local/samba/bin/samba-tool"
SAMBA_REALM=samdom.example.com
SAMBA_CRED="-U Administrator%Password01@"

# generate zone0, zone1...
for i in {0..19}
do
    $SAMBA_TOOL dns zonecreate localhost zone$i.$SAMBA_REALM $SAMBA_CRED
done

# add NS record for dc0, dc1..., dc59 to zone0
for i in {0..59}
do
    $SAMBA_TOOL dns add localhost zone0.$SAMBA_REALM dc$i NS dc$i.$SAMBA_REALM $SAMBA_CRED
done

# generate NS record for each user in zone1
for name in $($SAMBA_TOOL user list)
do
    $SAMBA_TOOL dns add localhost zone1.$SAMBA_REALM $name NS $name.$SAMBA_REALM $SAMBA_CRED
    $SAMBA_TOOL dns add localhost zone1.$SAMBA_REALM *.$name NS *.$name.$SAMBA_REALM $SAMBA_CRED
done

# generate NS record for each machine in zone2
for name in $($SAMBA_TOOL computer list)
do
    $SAMBA_TOOL dns add localhost zone2.$SAMBA_REALM $name NS $name.$SAMBA_REALM $SAMBA_CRED
    $SAMBA_TOOL dns add localhost zone2.$SAMBA_REALM *.$name NS *.$name.$SAMBA_REALM $SAMBA_CRED
done
