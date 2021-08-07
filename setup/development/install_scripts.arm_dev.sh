#!/bin/bash

# #############################################################################
# \brief scripts which installs all features in order to run arm_none_eabi_gcc 
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
# \brief checks the scripts arguments
# #############################################################################
function do_treat_arm_gcc() {
	srv="https://developer.arm.com/-/media/Files/downloads/gnu-rm/7-2018q2/"
	file="gcc-arm-none-eabi-7-2018-q2-update-linux.tar.bz2"
	wget $srv$file

	tar -xjvf $file
}

# #############################################################################
# \brief checks the scripts arguments
# #############################################################################
function do_treat_openocd() {

	srv="https://sourceforge.net/projects/openocd/files/openocd/0.10.0/"
	file="openocd-0.10.0.tar.bz2"
	wget $srv$file
	tar -xjvf $file

	sudo zypper in libusb-1_0-devel
	
	cd ${file%%.*}
	./configure
	make
	make install


}



# #############################################################################
# first, install arm_none_eabi_gcc, then install various libs 
# 
# \param  void
# #############################################################################
function do_check_and_run() {
	
	#do_treat_arm_gcc
	do_treat_openocd
	
	return
}


# #############################################################################
# check, what we have to install either a simple runtime environment 
# or a development kit
# #############################################################################
function do_print_help() {
	echo $(do_print_date) "install		custom path to the rpm - package"
	echo $(do_print_date) "standard		standard installation routine"
	echo $(do_print_date) "-h		help"
	echo $(do_print_date) "-t		test subfunctions, no install"
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
	-h)
		do_print_help
		;;
	-t)
		echo ">>>>> checking arguments routine"
		do_check_arguments $1 $2 $3
		;;
	man_uninstall)	
		do_uninstall_manual
		;;
	man_install)
		do_install_manual
		;;
	man_compress)
		do_compress_manual
		;;
        *)
                ;;
esac

