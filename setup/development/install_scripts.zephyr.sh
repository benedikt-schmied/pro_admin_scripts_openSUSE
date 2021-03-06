#!/bin/bash

# #############################################################################
# \brief scripts which installs all features in order to run, compile and debug 
# 	zephyr applications
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
# \brief zephyr application use 'update_alternatives' to find their VM, hence
# 	 we have to update the tables
#
# \param void
# #############################################################################
function do_update_alternatives_zephyr() {
	do_print_debug "update alternatives zephyr"

	# installing: 
	# link="/usr/bin/zephyr": symlink pointing
	# name="zephyr": is the master name of the link group
	# path="/usr/zephyr...": location of the target files
	# priority=1: higher priority number of higher priority in automatic mode
	update-alternatives --install "/usr/bin/zephyr/" "zephyr" "/usr/zephyr/latest/bin/zephyr" 1

	# set
	update-alternatives --set "zephyr" "/usr/zephyr/latest/bin/zephyr"
}


# #############################################################################
# \brief zephyrc toolchain shall made known to the update-alternatives sub - 
#        subsystem
#
# \param void 
# #############################################################################
function do_update_alternatives_zephyrc() {
	do_print_debug "update alternatives zephyrc"

        # installing
	update-alternatives --install "/usr/bin/zephyr" "zephyr" "/usr/zephyr/latest/bin/zephyr" 1

	# set: zephyr is an alternative to /usr/zephyr...
        update-alternatives --set zephyr /usr/zephyr/latest/bin/zephyr
}


# #############################################################################
# \brief installing the development kit
#
# \param $1 *.rpm - package 
# #############################################################################
function do_install_jdk() {
	do_print_debug "installing JDK"
	
	# install the new zephyr package
	rpm -ivh $1
	
	# update alternatives zephyrc
	do_update_alternatives_zephyrc

	# compress the manual files
	do_compress_manual	
	
	# create copy the zipped files
	

}

# #############################################################################
# \brief uninstall the manual
# 
# \param void 
# #############################################################################
function do_uninstall_manual() {
	do_print_debug "uninstall manual"

	# we will find the currently installed files, within the zephyr latest
	# folder
	targetdir=/usr/zephyr/latest/man/man1
	linkdir=/usr/share/man/man1

	# first, fetch all files in the current installation
	a=$(find $targetdir -iname "*.1")
	
	# now, we loop over those files and delete the links
	for i in ${a[@]}; 
	do
	
		# second, remove the link in the manual folder	
		tmpa=$(basename $i);
		if [ $linkdir/$tmpa.gz ];
		then
			rm $linkdir/$tmpa.gz 
		fi

		# first remove the zipped manual in the targetdr 
		if [ -f $i.gz ];
		then
			rm $i.gz;
		fi

	done;
}

# #############################################################################
# \brief install the manual
#
# \param void
# #############################################################################
function do_install_manual() {
	do_print_debug "install manual"

	# we will find the currently installed files, within the zephyr latest
	# folder
	targetdir=/usr/zephyr/latest/man/man1
	linkdir=/usr/share/man/man1

	# compress the target files
	do_compress_manual

	# first, fetch all files in the current installation
	a=$(find $targetdir -iname "*.1.gz")

	# now, we loop over those files and delete the links
	for i in ${a[@]}; 
	do
		# create links onto the latest directory	
		tmpa=$(basename $i);
		if ! [ -f $linkdir/$tmpa ];
		then
			ln -s $i $linkdir
		fi
	done;
}

# #############################################################################
# \brief compress the manual
#
# \param void
# #############################################################################
function do_compress_manual() {
	do_print_debug "compressing manual"

	# first, try to uninstall the previously installed manuals
	
	targetdir=/usr/zephyr/latest/man/man1

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
# \brief uninstall the opensource - package
# 
# \param void
# #############################################################################
function do_uninstall_icedtea-web() {

	do_print_debug "uninstalling icedtea"

	# remove the opensource package
	zypper rm icedtea-web
}

# #############################################################################
# \brief install the runtime environment
# 
# \param package
# #############################################################################
function do_install_jre() {
        do_print_debug "installing JRE"

        # install the new zephyr package
        rpm -ivh $1

	# check, whether we find the browser plugin
        rpm -ql $(rpm -qa | grep jre) | grep libnpjp2.so

        # create a link onto this shared object
        plugin=$(rpm -ql $(rpm -qa | grep jre) | grep libnpjp2.so) && ln -svf "$plugin" /usr/lib64/browser-plugins/

	# update alternatives
	do_update_alternatives_zephyr

	
}

# #############################################################################
# check, what we have to install either a simple runtime environment 
# or a development kit
# 
# \param $1 rpm - package 
# #############################################################################
function do_check_and_run() {

	
	do_print_debug "do check and run"


	zypper ar http://download.opensuse.org/distribution/leap/42.3/repo/oss oss-42.3
	zypper up cmake

	https://github.com/zephyrproject-rtos/meta-zephyr-sdk/releases/download/0.9.3/zephyr-sdk-0.9.3-setup.run
	chmod +x zephyr-sdk-0.9.3-setup.run
	./zephyr-sdk-0.9.3.setup.run
	
	
	export ZEPHYR_TOOLCHAIN_VARIANT=zephyr
	export ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk
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
                ;;
esac

