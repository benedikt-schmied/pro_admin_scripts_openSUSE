#!/bin/bash

# #############################################################################
# \brief scripts which installs all features in order to run, compile and debug 
# 	java applications
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
# \brief installing the git package
#
# \param void 
# #############################################################################
function do_install_git() {
	do_print_debug "installing git"
	
	# install the new java package
	zypper in git

	zypper addrepo "https://download.opensuse.org/repositories/devel:tools:scm/openSUSE_Leap_15.0/devel:tools:scm.repo"
	zypper refresh
	zypper install git-flow
	
}

# #############################################################################
# \brief compress the manual
#
# \param void
# #############################################################################
function do_compress_manual() {
	do_print_debug "compressing manual"

	# first, try to uninstall the previously installed manuals
	
	targetdir=/usr/java/latest/man/man1

	# grap all files that end with '1'
	a=$(find $targetdir -iname "*.1")
	
	#now, take each file and compress it
	for i in ${a[@]};
	do
		if ! [ -f $i.gz ];
		then
			gzip -k $i;
		fi
	done;
}

# #############################################################################
# check, what we have to install either a simple runtime environment 
# or a development kit
# 
# \param $1 rpm - package 
# #############################################################################
function do_check_and_run() {

	
	do_print_debug "do check and run"
	do_install_git
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
		do_check_arguments $1
		do_check_and_run 
		;;
	standard)
		do_check_and_run "path_to_server"
		;;
	-h)
		do_print_help
		;;
	-t)
		echo ">>>>> testing date routine"
		do_print_date
		echo ">>>>> testing alert"
		do_print_alert "test run"
		echo ">>>>> testing debug"
		do_print_debug "test run"
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
		do_print_help
                ;;
esac

