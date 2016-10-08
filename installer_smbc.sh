#!/bin/bash
# This is a installation script for smbc.sh

if [[ $EUID -ne 0 ]];
then
	echo ""
	echo "Error: This program must be run with root privileges"
	echo ""
else
	mkdir -p /opt/smbcontrol
	cp `pwd`/smbc.sh /opt/smbcontrol/smbc
	chmod 755 /opt/smbcontrol/smbc
	chmod 755 /opt/smbcontrol
	ln -sf /opt/smbcontrol/smbc /bin/smbc
	ln -sf /opt/smbcontrol/smbc /sbin/smbc
	if [ -d /usr/share/smbcontrol ] && [ -e /opt/smbcontrol/smbc ]; then echo "Installation Succeed!"; else "Installation error!" && exit 1; fi
fi
exit 0
