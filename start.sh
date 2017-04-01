#!/bin/bash
# PSPNET_ADHOCCTL_SERVER Container Start Script
#
# Copyright (c) 2017 Belldandu <kami@ilp.moe>
# MIT Licensed
# ##
sleep 3
if [ "$(pwd)" -ne "/home/container" ]; then
    cd /home/container
fi

# Download and compile PSPNET_ADHOCCTL_SERVER, if it is missing
if [ ! -f "/home/container/aemu/pspnet_adhocctl_server/pspnet_adhocctl_server" ]; then
	if [ -d "/home/container/aemu/" ]; then
		# remove existing files to prevent git clashes
		echo "Removing Existing files to prevent git clashes..."
		echo "> rm -rf aemu"
		rm -rf aemu
	fi

	# clone the aemu repository on github
	echo "Cloning the aemu repository on github..."
	echo "> git clone https://github.com/MrColdbird/aemu.git"
	git clone https://github.com/MrColdbird/aemu.git

	# Compile the PSPNET_ADHOCCTL_SERVER
	echo "Compiling the PSPNET_ADHOCCTL_SERVER in the cloned repository"
	echo "> cd aemu/pspnet_adhocctl_server"
	cd aemu/pspnetadhocctl_server
	echo "> make"
	make
else
    echo "Dependencies in place, to re-download this PSP Adhoc server please delete the aemu directory"
fi

cd /home/container

MODIFIED_STARTUP=`echo ${STARTUP} | perl -pe 's@{{(.*?)}}@$ENV{$1}@g'`
echo "./aemu/pspnet_adhocctl_server/pspnet_adhocctl_server ${MODIFIED_STARTUP}"
./aemu/pspnet_adhocctl_server/pspnet_adhocctl_server $MODIFIED_STARTUP
