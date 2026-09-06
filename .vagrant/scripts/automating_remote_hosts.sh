#!/bin/bash

# Declaring Variables
URL="https://www.tooplate.com/zip-templates/2098_health.zip"
ART_NAME="2098_health"
TEMPDIR="/tmp/webfiles"

if [ -f /etc/redhat-release ]; then
	echo "Running Setup on Ubuntu"
	# Declaring Variable
	PACKAGES="httpd wget unzip"
	SVC="httpd"
	# Installing Dependencies
	sudo yum install $PACKAGES -y > /dev/null

	# Start and Enable service
	sudo systemctl start $SVC
	sudo systemctl enable $SVC

	# Creating temporary directory
	mkdir -p $TEMPDIR
	cd $TEMPDIR

	# Getting the template
	wget $URL > /dev/null

	# Unzipping
	unzip $ART_NAME.zip > /dev/null

	# Copying the file
	sudo cp -r $ART_NAME/* /var/www/html/

	# Restarting the service
	sudo systemctl restart $SVC

	# Cleaning the webfiles
	rm -rf $TEMPDIR > /dev/null
else
	echo "Running Setup on CentOS"
	# Declaring Variable
	PACKAGES="apache2 wget unzip"
	SVC="apache2"
	# Installing Dependencies
	sudo apt update > /dev/null
	sudo apt install $PACKAGES -y > /dev/null

	# Start and Enable service
	sudo systemctl start $SVC
	sudo systemctl enable $SVC

	# Creating temporary directory
	mkdir -p $TEMPDIR
	cd $TEMPDIR

	# Getting the template
	wget $URL > /dev/null

	# Unzipping
	unzip $ART_NAME.zip > /dev/null

	# Copying the file
	sudo cp -r $ART_NAME/* /var/www/html/

	# Restarting the service
	sudo systemctl restart $SVC

	# Cleaning the webfiles
	rm -rf $TEMPDIR > /dev/null
fi
