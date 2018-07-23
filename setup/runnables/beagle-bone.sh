#!/bin/bash

# #############################################################################
# \brief scripts which installs all features in order to run python 
# 	applications
#
# \author benedikt schmied
# #############################################################################


# #############################################################################
# \brief return the date
# #############################################################################
function do_print_date() {

	echo $(date '+%Y-%m-%d %H:%M:%S')
}

# #############################################################################
# \brief prints an alert message
#
# \param string
# #############################################################################
function do_print_alert() {
	echo $(do_print_date) " ALERT	" $1 
}


# #############################################################################
# \brief prints a debugging message
# #############################################################################
function do_print_debug() {
	echo $(do_print_date) " DEBUG	" $1
}

# #############################################################################
# \brief checks the scripts arguments
# #############################################################################
function do_check_arguments() {
	do_print_debug " checking the arguments "

	#we need to be administrator in order to let it run, hence check it
	if [ "$EUID" != "0" ]
	then
        	do_print_alert "we need to be administratro - we aren't, hence quit!"
	        exit 0
	fi
}

# #############################################################################
# check, what we have to install either a simple runtime environment 
# or a development kit
# #############################################################################
function do_print_help() {
	echo $(do_print_date) "install		custom path to the rpm - package"
	echo $(do_print_date) "-h		help"
	echo $(do_print_date) "-t		test subfunctions, no install"
}

# #############################################################################
# runs the installation
# #############################################################################
function do_check_and_run() {
	host="http://debian.beagleboard.org/images/"
	#a=(
	#	"bone-debian-9.3-iot-armhf-2018-03-05-4gb.img"
#		"bone-debian-9.3-lxqt-armhf-2018-01-28-4gb.img"
#	)
	a=(bone-debian-8.7-lxqt-4gb-armhf-2017-03-19-4gb.img)
	suffix=xz
	for i in ${a[@]};
	do
		echo "dowloading "$i
		wget $host$i"."$suffix
	done;

	for i in ${a[@]};
	do
		echo "extracting "$i
		xz -vd $i"."$suffix
	done;

	dd status=progress bs=4M if=${a[0]} of=/dev/mmcblk0
	sync
}

function do_copy_to_card()
{
	echo "copy to card"
	
	dd status=progress bs=4M if="bone-debian-9.3-iot-armhf-2018-03-05-4gb.img" of=/dev/mmcblk0
	sync
}

# #############################################################################
# check, what we have to install either a simple runtime environment 
# or a development kit
#
# \param  $1    command
# \param  $2    rpm - package
# #############################################################################
case $1 in
        install)
		do_check_arguments
		do_check_and_run 
                ;;
	copy)
		do_copy_to_card
		;;
	-h)
		do_print_help
		;;
	-t)
		echo ">>>>> checking arguments routine"
		;;
        *)
                ;;
esac
