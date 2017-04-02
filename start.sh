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
if [ ! -f "/home/container/pspnet_adhocctl_server" ]; then
	# Grab the aemu repository from github
	echo "Grabbing the aemu repository from github..."
	echo ":/home/container$ curl -Lo v1.0.tar.gz https://github.com/belldandu/aemu/archive/v1.0.tar.gz"
	curl -Lo v1.0.tar.gz https://github.com/belldandu/aemu/archive/v1.0.tar.gz

	# Extract the aemu repo
	echo "Extracting the aemu repository..."
	echo ":/home/container$ tar -xzvf v1.0.tar.gz"
	tar -xzvf v1.0.tar.gz

	# Move the necessary files out of the aemu repo
	echo "Moving PSPNET_ADHOCCTL_SERVER out of the aemu repository..."
	echo ":/home/container$ mv /home/container/aemu/pspnet_adhocctl_server/* /home/container"
	mv /home/container/aemu/pspnet_adhocctl_server/* /home/container

	# Clean up the remainder files we don't need
	echo "Cleaning up the remainder of the files we don't need..."
	echo ":/home/container$ rm -rf aemu"
	rm -rf aemu
	echo ":/home/container$ rm -rf v1.0.tar.gz"
	rm -rf v1.0.tar.gz

	# Compile the PSPNET_ADHOCCTL_SERVER
	echo "Compiling the PSPNET_ADHOCCTL_SERVER"
	echo ":/home/container/$ make"
	make
else
	echo "Dependencies in place, to re-download this PSP Adhoc server please delete the aemu directory"
fi

cd /home/container

# Replace Startup Variables
MODIFIED_STARTUP=`eval echo $(echo ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')`
echo ":/home/container/$ ${MODIFIED_STARTUP}"

# Run the Server
${MODIFIED_STARTUP}

if [ $? -ne 0 ]; then
    echo "PTDL_CONTAINER_ERR: There was an error while attempting to run the start command."
    exit 1
fi
