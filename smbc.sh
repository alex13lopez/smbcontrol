#!/bin/bash

##########################################################################################
# Name: smbcontrol                                                                 
# Author: ArenGamerZ <alex13gamerz@gmail.com>                                                   
# Version: 3.1.2-rc/stable                                                                           
# Description: This script will make your administration of samba easier.
# LICENSE: GNU GPL    
##########################################################################################

function usage {
	echo """Usage: smbc [OPTIONS] <OPTIONAL>    
       OPTIONS:        
		-e <user>	--> 	Enables given user
		-d <user>	--> 	Disables given user
		-a <IP>		--> 	Adds <IP> to trusted networks
		-D <IP>		--> 	Removes <IP> from trusted networks
		-l		--> 	Shows the list of the trusted networks"""
	exit 1
}

if [[ $EUID -ne 0 ]]; then
	echo " "
	echo "Error: This program must be run with root privileges"
	echo " "
	exit 0

else
	if [[ $# -eq 1 ]]; then
		# This just shows a list of the trusted networks
		if [[ $1 = "-l" ]]; then
			echo "The trusted networks are:" 
			cat /usr/share/smbcontrol/trusted_ips | while read i; do echo "			- $i"; done

		else
			echo "Parameter error"
			usage
		fi

	elif [[ $# -eq 2 ]]; then
		# This enables the user shared
		if [[ $1 = "-e" ]]; then
			if [[ $(smbpasswd -e $2) ]]; then 
				service smbd restart
				echo "Samba user $2 enabled succesfully"
			else
				exit 1
			fi
		
		# This disables the user shared
		elif [[ $1 = "-d" ]]; then
			if [[ $(smbpasswd -d $2) ]]; then
				service smbd restart
				echo "Samba user $2 disabled successfully"
			else
				exit 1
			fi

		# This adds the IP from the second parameter "$2" and adds a rule to the firewall allowing the connection
		elif [[ $1 = "-a" ]]; then
			if [[ $2 == 192.?*.?*.0/?? ]] || [[ $2 == 172.?*.?*.?*/?? ]] || [[ $2 == 10.?*.?*.?*/?? ]]; then
			      ufw limit in proto tcp from $2 to any port 135,139,445
			      ufw limit in proto udp from $2 to any port 137,138
			      echo "$2" >> /usr/share/smbcontrol/trusted_ips
			else
				echo "You're an idiot, aren't you? The string '$2' isn't a valid IP"
				usage
			fi

		# This removes the rule of the firewall added with the "-a" option below
		elif [[ $1 = "-D" ]]; then
			if [[ $2 == 192.?*.?*.0/?? ]] || [[ $2 == 172.?*.?*.?*/?? ]] || [[ $2 == 10.?*.?*.?*/?? ]]; then
				if [[ $(grep "$2" /usr/share/smbcontrol/trusted_ips) ]]; then
					ufw delete limit in proto tcp from $2 to any port 135,139,445
					ufw delete limit in proto udp from $2 to any port 137,138
					sed -i "s|$2||;/^$/d" /usr/share/smbcontrol/trusted_ips
				else
					echo "Given IP isn not on the list, use smbc -l to show the IP list."
					exit 1
				fi
			else
				echo "You're an idiot, aren't you? The string '$2' isn't a valid IP"
				usage
			fi
		else
			echo "Parameter error"
			usage
		fi
	else
		echo "Parameter error"
		usage
	fi
fi
exit 0
						
					
