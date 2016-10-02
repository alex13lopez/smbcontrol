#!/bin/bash

if [[ $EUID -ne 0 ]];
then
	echo " "
	echo "Error: This program must be run with root privileges"
	echo " "
	exit 0

else
	if [[ $1 = "-e" ]]; then
		smbpasswd -e shared
		service smbd restart
		echo "Samba connections enabled successfully"
		

	elif [[ $1 = "-d" ]]; then
		smbpasswd -d shared
		service smbd restart
		echo "Samba connections disabled successfully"

	elif [[ $1 = "-a" ]]; then
		ufw limit in proto tcp from $2 to any port 135,139,445
		ufw limit in proto udp from $2 to any port 137,138
		echo "$2" >> /mnt/Data/IT/programming/myrepo/bash_scripts/smbcontrol/trusted_ips

	elif [[ $1 = "-D" ]]; then
		ufw delete limit in proto tcp from $2 to any port 135,139,445
		ufw delete limit in proto udp from $2 to any port 137,138
		sed -i "s|$2||;/^$/d" /mnt/Data/IT/programming/myrepo/bash_scripts/smbcontrol/trusted_ips

	elif [[ $1 = "-l" ]]; then
		echo """The trusted networks are:
		- $(cat /mnt/Data/IT/programming/myrepo/bash_scripts/smbcontrol/trusted_ips)"""


	else
		echo """Usage: smb [OPTIONS] 	

		OPTIONS:	
			-e      --> enables shared user
			-d      --> disables shared user
			-a <IP> --> Adds <IP> to trusted networks
			-D <IP> --> Removes <IP> from trusted networks
			-l      --> Shows the list of the trusted networks"""
	fi
fi
exit 0
						
					
