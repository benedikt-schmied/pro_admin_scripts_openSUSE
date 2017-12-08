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

	if [ $# -ne 2 ]
	then
        	do_print_alert "we need the path to the runtime rpm as a parameter - we haven't go it, hence quit!"
        	exit 0
	fi

	#we need to be administrator in order to let it run, hence check it
	if [ "$EUID" != "0" ]
	then
        	do_print_alert "we need to be administratro - we aren't, hence quit!"
	        exit 0
	fi

	if [ -f $2 != 0  ]
	then
        	do_print_alert "this is not a valid file, we will quit!"
	        exit 0
	fi
}

# #############################################################################
# \brief java application use 'update_alternatives' to find their VM, hence
# 	 we have to update the tables
# #############################################################################
function do_update_alternatives_java() {
	do_print_debug "update alternatives java"
}


# #############################################################################
# 
# #############################################################################
function do_update_alternatives_javac() {
	do_print_debug "update alternatives java"

        update-alternatives --install "/usr/bin/java" "java" "/usr/java/latest/bin/java" 1
        update-alternatives --set java /usr/java/latest/bin/java
}


# #############################################################################
# 
# #############################################################################
function do_install_jdk() {
	do_print_debug "installing JDK"

}

# #############################################################################
# 
# #############################################################################
function do_compress_manual() {
	do_print_debug "compressing manual"
}

# #############################################################################
# 
# #############################################################################
function do_install_jre() {
        do_print_debug "installing JRE"

        # install the new java package
        rpm -ivh $1

        # remove the opensource package
        zypper rm icedtea-web

	# zip all the manual files within the installation folder


        # check, whether we find the browser plugin
        rpm -ql $(rpm -qa | grep jre) | grep libnpjp2.so

        # 
        plugin=$(rpm -ql $(rpm -qa | grep jre) | grep libnpjp2.so) && ln -svf "$plugin" /usr/lib64/browser-plugins/
}

# #############################################################################
# check, what we have to install either a simple runtime environment 
# or a development kit
# #############################################################################
function do_check_and_run() {

	
	do_print_debug "do check and run"


	switch 
}


# #############################################################################
# check, what we have to install either a simple runtime environment 
# or a development kit
# #############################################################################
function do_print_help() {
	echo $(do_print_date) "install		test"
	echo $(do_print_date) "-h		help"
	echo $(do_print_date) "-t		test subfunctions, no install"
}

# #############################################################################
# check, what we have to install either a simple runtime environment 
# or a development kit
# #############################################################################
case $1 in
        install)
		do_check_and_run $2
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
        *)
                ;;
esac

