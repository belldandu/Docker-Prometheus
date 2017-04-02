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
	echo ":/home/container$ curl -Lo aemu.tar.gz https://github.com/belldandu/aemu/archive/v1.0.tar.gz"
	curl -Lo aemu.tar.gz https://github.com/belldandu/aemu/archive/v1.0.tar.gz

	# Extract the aemu repo
	echo "Extracting the aemu repository..."
	echo ":/home/container$ tar -xzvf aemu.tar.gz"
	tar -xzvf aemu.tar.gz

	# Change Directory to the PSPNET_ADHOCCTL_SERVER directory temporarily after making a few directories
	echo "Temporarily changing to the PSPNET_ADHOCCTL_SERVER directory after making a few directories..."
	echo ":/home/container$ cd aemu-1.0"
	cd aemu-1.0
	echo ":/home/container/aemu-1.0$ mkdir dist"
	mkdir dist
	echo ":/home/container/aemu-1.0$ cd dist"
	cd  dist
	echo ":/home/container/aemu-1.0/dist$ mkdir server"
	mkdir server
	echo ":/home/container/aemu-1.0/dist$ cd ../pspnet_adhocctl_server"
	cd  ../pspnet_adhocctl_server

	# Compile the PSPNET_ADHOCCTL_SERVER
	echo "Compiling the PSPNET_ADHOCCTL_SERVER..."
	echo ":/home/container/aemu-1.0/pspnet_adhocctl_server$ make"
	make

	# Change Directory back to /home/container
	echo "Changing directory back to /home/container..."
	echo ":/home/container/aemu-1.0/pspnet_adhocctl_server$ cd ../.."
	cd ../..

	# Move the necessary files out of the aemu repo
	echo "Moving PSPNET_ADHOCCTL_SERVER out of the aemu repository..."
	echo ":/home/container$ mv aemu-1.0/dist/server/* /home/container"
	mv aemu-1.0/dist/server/* /home/container

	# Clean up the remainder files we don't need
	echo "Cleaning up the remainder of the files we don't need..."
	echo ":/home/container$ rm -rf aemu-1.0"
	rm -rf aemu-1.0
	echo ":/home/container$ rm -rf aemu.tar.gz"
	rm -rf aemu.tar.gz

else
	echo "Dependencies in place, to re-download this PSP Adhoc server please delete all files in this directory"
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
