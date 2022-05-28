#!/bin/bash

	# if user is not running the command as root
	if [ "$UID" -ne 0 ]; then

		# output message
		echo "Please run the installer with sudo!"

		# stop script
		exit
	fi

	# output message
	echo -e "\nbluetooth-autoconnect Installer ...\n"


	# define required packages
    requiredPackages=(python3 python3-prctl python3-dbus bluez)

	# loop through packages
    for package in "${requiredPackages[@]}"; do

		# set package
		p="$package"

		# output message
		echo -n "Check if \"$package\" package is already installed ... "
		
		# check if package is installed and get exit code
        responseCode=$(apt list 2>&1 | grep ^"$p"/ | grep install > /dev/null 2>&1; echo "$?")

		# if package is installed
        if [ "$responseCode" == "0" ]; then

			# output message
			echo "Yes"

        else
			# output message
            echo -n "No, installing ... "

			# install package
            responseCode=$(apt install "$package" -y > /dev/null 2>&1)
            
            if [ "$responseCode" == "100" ]; then
                echo "Error while installing \"$package\" package"
                exit
            fi
            
			# output message
            echo "Done."
        fi
    done

	# output message
	echo "Installing bluetooth-autoconnect script ..."

	# copy script to local directory
	cp bluetooth-autoconnect /usr/local/bin/

	# change directory permissions
	chmod -R 755 /usr/local/bin/bluetooth-autoconnect

	echo "Check if systemd is running ..."
	responseCode=$(which systemctl > /dev/null 2>&1; echo "$?")
	# if systemd is running
    if [ "$responseCode" == "0" ]; then

		# output message
		echo "Yes, installing and enabling bluetooth-autoconnect service ..."
        # copy certificates to local directory
        cp bluetooth-autoconnect.service /etc/systemd/system/
        # enable the service
        systemctl enable bluetooth-autoconnect
        
	    echo "Check if pulseaudio is running ..."
	    responseCode=$(which pulseaudio > /dev/null 2>&1; echo "$?")
	    # if pulseaudio is running
        if [ "$responseCode" == "0" ]; then

		    # output message
		    echo "Yes, installing and enabling pulseaudio-bluetooth-autoconnect service ..."
            # copy certificates to local directory
            cp pulseaudio-bluetooth-autoconnect.service /etc/systemd/user/
            # enable the service
            echo "PLEASE RUN THIS COMMAND NOW: \"systemctl --user enable pulseaudio-bluetooth-autoconnect\""  

        else        
	        # output message
            echo -n "No, nothing to do"
        fi               

    else        
		# output message
        echo -n "No, please set up your system to launch the bluetooth-autoconnect script"
    fi

    echo "End of installation"

