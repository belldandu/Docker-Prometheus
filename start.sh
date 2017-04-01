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
		echo ":/home/container$ rm -rf aemu"
		rm -rf aemu
	fi

	# clone the aemu repository on github
	echo "Cloning the aemu repository on github..."
	echo ":/home/container$ git clone https://github.com/MrColdbird/aemu.git"
	git clone https://github.com/MrColdbird/aemu.git

	# Compile the PSPNET_ADHOCCTL_SERVER
	echo "Compiling the PSPNET_ADHOCCTL_SERVER in the cloned repository"
	echo ":/home/container$ cd aemu/pspnet_adhocctl_server"
	cd aemu/pspnetadhocctl_server
	echo ":/home/container$ make"
	make
else
    echo "Dependencies in place, to re-download this PSP Adhoc server please delete the aemu directory"
fi

cd /home/container

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}

if [ $? -ne 0 ]; then
    echo "PTDL_CONTAINER_ERR: There was an error while attempting to run the start command."
    exit 1
fi
