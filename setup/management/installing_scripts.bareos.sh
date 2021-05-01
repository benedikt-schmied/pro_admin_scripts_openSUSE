#!/bin/bash
echo "installing the jave runtime"

if [ $# -ne 1 ]
then
        echo "we need the path to the runtime rpm as a parameter - we haven't go it, hence quit!"
        exit 0
fi

#we need to be administrator in order to let it run, hence check it
if [ "$EUID" != "0" ]
then
        echo "we need to be administratro - we aren't, hence quit!"
        exit 0
fi



# #############################################################################
# 
# #############################################################################
function do_update_alternatives_java() {
	echo "-- update alternatives java"
}


# #############################################################################
# 
# #############################################################################
function do_install_jdk() {
	echo "-- installing JDK"

	# 
}



# #############################################################################
# 
# #############################################################################
function do_install_jre() {
        echo "-- installing JRE"

        # install the new java package
        rpm -ivh $1

        # remove the opensource package
        zypper rm icedtea-web

        # declate the alternatives
        update-alternatives --install "/usr/bin/java" "java" "/usr/java/latest/bin/java" 1
        update-alternatives --set java /usr/java/latest/bin/java

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
	
	# 1. add the repository and intall bareos
	zypper ar -cgf http://download.bareos.org/bareos/release/latest/openSUSE_Leap_42.2/ bareos	
	zypper in bareos
	
	# 2. run the scripts that create the database, tables, ...
	bscripts=/usr/lib/bareos/scripts
	$bscripts/create_bareos_database mysql -p

	
}


case $1 in
        install)i
		do_check_and_run $2
                ;;
        *)
                ;;
esac

