#!/bin/bash

	# if user is not running the command as root
	if [ "$UID" -ne 0 ]; then

		# output message
		echo "Please run the uninstaller with SUDO!"

		# stop script
		exit
	fi

	# output message
	echo -e "\nbluetooth-autoconnect uninstaller ...\n"


	# define required packages
    # requiredPackages=(python3 python3-prctl python3-dbus bluez)

	
	# rm script from local directory
	if [ -f "/usr/local/bin/bluetooth-autoconnect" ]; then
	    echo "Deleting bluetooth-autoconnect script ..."
	    rm  /usr/local/bin/bluetooth-autoconnect > /dev/null 2>&1
    fi
    
	# rm bluetooth-autoconnect service
	if [ -f "/etc/systemd/system/bluetooth-autoconnect.service" ]; then
	    echo "Deleting bluetooth-autoconnect script ..."
	    sudo systemctl disable bluetooth-autoconnect > /dev/null 2>&1
	    rm  /etc/systemd/system/bluetooth-autoconnect.service > /dev/null 2>&1
    fi

	# rm pulseaudio-bluetooth-autoconnect service
	if [ -f "/etc/systemd/user/pulseaudio-bluetooth-autoconnect.service" ]; then
	    echo "Deleting pulseaudio-bluetooth-autoconnect script ..."
	    sudo systemctl --user disable pulseaudio-bluetooth-autoconnect > /dev/null 2>&1
	    rm  /etc/systemd/user/pulseaudio-bluetooth-autoconnect.service > /dev/null 2>&1
    fi
 
    echo "End of uninstallation"

