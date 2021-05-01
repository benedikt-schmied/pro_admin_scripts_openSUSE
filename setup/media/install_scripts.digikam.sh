#!/bin/bash
echo "installing the digikam and the corresponding database"
helpstr="param 1: command\n param2: password"

if [ $# -ne 2 ]
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

if [ -f $2 != 0  ]
then
        echo "this is not a valid file, we will quit!"
        exit 0
fi


# #############################################################################
# 
# #############################################################################
function do_() {
        echo "enabling and starting data"


}

# #############################################################################
# check, what we have to install either a simple runtime environment 
# or a development kit
# #############################################################################
function do_check_and_run() {
	

}


case $1 in
        install)
		do_check_and_run $2
		do_ $2
                ;;
        *)
		echo $helpstr
                ;;
esac

