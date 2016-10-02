#!/bin/bash

##########################################################################################
# Name: Smbcontrol                                                                 
# Author: Aren <alex13gamerz@gmail.com>                                                   
# Version: 2.0/stable                                                                           
# Description: This script will make your administration of samba easier.
#
# LICENSE: GNU GPL    
##########################################################################################

if [[ $EUID -ne 0 ]];
then
	echo " "
	echo "Error: This program must be run with root privileges"
	echo " "
	exit 0

else
	# This enables the user shared
	if [[ $1 = "-e" ]]; then
		smbpasswd -e shared
		service smbd restart
		echo "Samba user shared enabled succesfully"
		
	# This disables the user shared
	elif [[ $1 = "-d" ]]; then
		smbpasswd -d shared
		service smbd restart
		echo "Samba user shared disabled successfully"

	# This adds the IP from the second parameter "$2" and adds a rule to the firewall allowing the connection
	elif [[ $1 = "-a" ]]; then
		ufw limit in proto tcp from $2 to any port 135,139,445
		ufw limit in proto udp from $2 to any port 137,138
		echo "$2" >> /mnt/Data/IT/programming/myrepo/bash_scripts/smbcontrol/trusted_ips

	# This removes the rule of the firewall added with the "-a" option below
	elif [[ $1 = "-D" ]]; then
		ufw delete limit in proto tcp from $2 to any port 135,139,445
		ufw delete limit in proto udp from $2 to any port 137,138
		sed -i "s|$2||;/^$/d" /mnt/Data/IT/programming/myrepo/bash_scripts/smbcontrol/trusted_ips

	# This just shows a list of the trusted rules
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
						
					
