#!/bin/bash
# This is a installation script for smbc.sh

if [[ $EUID -ne 0 ]];
then
	echo ""
	echo "Error: This program must be run with root privileges"
	echo ""
else
	ln -sf `pwd`/smbc.sh /bin/smbc
	ln -sf `pwd`/smbc.sh /sbin/smbc
	echo "Installation succeed !"
	echo ""
fi
exit 0
