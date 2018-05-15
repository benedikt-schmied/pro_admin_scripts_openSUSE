#!/bin/bash

# #############################################################################
# \brief scripts which installs all features in order to run "apache allura" 
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
	
	packages=(python python-pip python-pysvn)

	for package in ${packages[@]};
	do
		zypper install $package
	done;
	
	# first, try to update pip, just in case "apache allura" has already been installed
	python -m pip install --upgrade pip

	# now, take the pip installer, to install various modules
	pmodules=(virtualenv)
	for pmodule in ${pmodules[@]};
	do
		python -m pip install $pmodule
	done;
	# create a virtual environment
	virtualenv env-allura

	# now, we use the virtual environment
	. env-allura/bin/activate

	# create the log directory
	mkdir -p /var/log/allura
	chown wwwrun:www /var/log/allura
	
	# installing the allura code and dependencies
	mkdir src
	cd src
	git clone https://git-wip-us.apache.org/repos/asf/allura.git allura
	# collect the correct requirements.txt file
	cd allura
	pip install -r requirements.txt

	# run the allura tools
	./rebuild-all.bash

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

