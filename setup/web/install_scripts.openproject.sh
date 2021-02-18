#!/bin/bash

# #############################################################################
# \brief scripts which installs all features in order to run "openproject" 
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
# first, install "apache allura", then install various libs 
# 
# \param  void
# #############################################################################
function do_check_and_run() {

	
	do_print_debug "do check and run"
	
	zypper addrepo https://download.opensuse.org/repositories/devel:/languages:/ruby/openSUSE_Leap_15.2/devel:languages:ruby.repo
	zypper addrepo https://download.opensuse.org/repositories/devel:/languages:/ruby:/extensions/openSUSE_Leap_15.2/devel:languages:ruby:extensions.repo
	zypper addrepo https://download.opensuse.org/repositories/home:/matthewtrescott:/openproject/openSUSE_Leap_15.2/home:matthewtrescott:openproject.repo	
	packages=(openproject)

	for package in ${packages[@]};
	do
		zypper install $package
	done;
	

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
        *)
                ;;
esac

