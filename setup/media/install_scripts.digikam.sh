#!/bin/bash
echo "installing the digikam and the corresponding database"
helpstr="param 1: command param2: password"

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



# #############################################################################
# 
# #############################################################################
function do_() {
        echo "enabling and starting data"
	echo $1
	#return
	
	systemctl enable mysql
	systemctl start mysql
	dbstr="CREATE USER IF NOT EXISTS 'digikamuser'@'%' IDENTIFIED BY '$1'; CREATE USER IF NOT EXISTS 'digikamuser'@'localhost' IDENTIFIED BY '$1'; CREATE DATABASE digikam; GRANT ALL PRIVILEGES ON digikam.* TO 'digikamuser'@'%'; GRANT ALL PRIVILEGES ON digikam.* TO 'digikamuser'@'localhost'; FLUSH PRIVILEGES;"
	echo $dbstr
	mysql -u root -p --execute="$dbstr"
	
	
	firewall-cmd --runtime-to-permanent
	firewall-cmd --add-service mysql
	systemctl restart mysql

	echo "check binding of mysql - server!"
}

# #############################################################################
# check, what we have to install either a simple runtime environment 
# or a development kit
# #############################################################################
function do_check_and_run() {
	echo "check"	

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

