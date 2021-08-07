#!/bin/bash
#---------------------------------------------------------
#
# @param	inputdir
# 
#----------------------------------------------------------


# #########################################################################
# the following definitions are necessary for running these scripts
# e.g.
# folders, ...
# #########################################################################

rootnode=$3
working_base=$2
vcsfault=$working_base/vcsfault

# '1', files are move; '0', origin files are preserved
switch_move=1


if [ $# -ne 3 ]
then
        echo "we need the path to the runtime rpm as a parameter - we haven't go it, hence quit!"
        exit 0
fi


#we need to be administrator in order to let it run, hence check it
#if [ "$EUID" != "0" ]
#then
#        echo "we need to be administratro - we aren't, hence quit!"
#        exit 0
#fi


# #########################################################################
#
# #########################################################################
function delete_unnecessary_files() {
}


# #########################################################################
#
# #########################################################################
function create_folders() {

	if [ -d $vcsfault ]
	then
		echo "out already exists"
	else
		sudo mkdir $vcsfault
		sudo chgrp users $vcsfault
		sudo chmod 777 $vcsfault
	fi
}

IFS=$'\n'

case $1 in
	batch)
		create_folders
		;;
	*)
		echo " [batch] basedir inputdir"
		;;
esac
unset IFS
