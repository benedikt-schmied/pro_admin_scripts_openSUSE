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

if [ $# -lt 2 ]
then
        echo "we need at least the command as well as the base directory!"
        exit 0
fi


#we need to be administrator in order to let it run, hence check it
#if [ "$EUID" != "0" ]
#then
#        echo "we need to be administratro - we aren't, hence quit!"
#        exit 0
#fi


# #########################################################################
# it will take each folder it can find
# initialize a git repository
# add all files to this repository
# do a initial commit
# change directory and clone a bore repository which
# it will move to the server
# 
# \param	$1	base directory 
# \param 	$2	name of future repository (of directory)
# \param	$3	remote git server (that can be accessed via ssh)
# #########################################################################
function create_and_populate_and_clone() {

	echo "this it the move to git script"

	main_dir=$1

	# target's full path
	tfpath=$main_dir/$2

	if [ -d $a ] 
	then
		# echo the current directory
		echo $tfpath

		# go into the directory
		cd $tfpath

		#extract the folders name -> project name from the current path
		echo $2
		target=$2

		# make a ignore file
		echo "*.[ao]" >> .gitignore

		# initialialize the repository
		git init

		# add all files
		git add *

		# do an intial commit 
		git commit -m "initial check in"

		# return from this directory
		cd $main_dir

		# do a bare clone operation
		git clone --bare $target $main_dir/$target.git

		# push it to the linux server
		echo "let's move the stuff"
		scp -r $target.git $3

		echo "erfolgreich? y"
		read $ui
		if [ "$ui" == "y" ];
		then
			rm -rf $target $target.git
		fi

		#clone it again
		git clone $3/$target.git

	fi
}


# #########################################################################
# it take the given directory in order to pull from each remote 
# repository. Note, that it will not switch the branch
# 
# \param 	$1	base directory	
# #########################################################################
function pull_all_projects() {
	b=$1
	for a in $b/*;
	do
		if [ -d $a ];
		then
			if [ -d $a/.git ]
			then
				cd $a;
				echo $a;
				git pull;
				cd $b;
			else
				echo "$a is not a git repository (a working copy)"
			fi
		fi
	done
}

# #########################################################################
# it take the given directory in order to pull from each remote 
# repository. Note, that it will not switch the branch
# 
# \param 	$1	base directory	
# #########################################################################
function push_to_remote_all_projects() {
	b=$1
	for a in $b/*;
	do
		if [ -d $a ];
		then
			if [ -d $a/.git ];
			then
				cd $a;
				echo $a;
				git push origin;
				cd $b;
			else
				echo "$a is not a git repository (a working copy)"
			fi
		fi
	done
}

# #########################################################################
# it take the given directory in order to pull from each remote 
# repository. Note, that it will not switch the branch
# 
# \param 	$1	base directory	
# #########################################################################
function show_status_all_projects() {
	b=$1
	for a in $b/*;
	do
		if [ -d $a ];
		then
			if [ -d $a/.git ];
			then
				cd $a;
				echo $a;
				git status;
				cd $b;
			else
				echo "$a is not a git repository (a working copy)"
			fi
		fi
	done
}

# #########################################################################
# loops throughougt all directories within the given base directory and
# tries to push the local changes (in the local branches) to the remote
# repositories (upstream)
# 
# \param 	$1	base directory	
# #########################################################################
function synchronize_branches_all_projects() {
	b=$1
	echo $b
	for a in $b/*;
	do
		if [ -d $a ];
		then
			if [ -f "$a/.git" -o -d "$a/.git/" ];
			then
				detached=false
				echo $detached
				cd $a;
				echo $a;
				git fetch;
				branches=$(git branch --list)
				branches=${branches/\*/}
				for branch in ${branches[@]};
				do
					if [ $branch == "detached" -o $branch == "losgelöst" ]
					then
						detached=true
					fi
					
				done
				if [ $detached == true ];
				then
					echo "we are detached"
					git checkout master;
					git add *;
					#read $msg
					git commit -im "just a snapshot"
				else
					echo "we are not detached"
					git add *;
					#read $msg
					git commit -im "just a snapshot"
				fi				
				echo "now, we're ready to go"
				branches=$(git branch --list)
				branches=${branches/\*/}
				for branch in ${branches[@]};
				do 
					echo "working on branch: $branch"
					git checkout $branch
					git pull origin;
					git add *;
					git commit -m "just another snapshot";
					git push origin;
				done;
				cd $b;
			else
				echo "$a is not a git repository (a working copy)"
			fi
		else
			pwd
			echo "exmaining directory $a"
		fi
	done
}

# #########################################################################
#
# #########################################################################
function create_folders() {

	if [ -d $vcsfault ]
	then
		echo "vcsfault already exists"
	else
		sudo mkdir $vcsfault
		sudo chgrp users $vcsfault
		sudo chmod 777 $vcsfault
	fi
}

IFS=$'\n'
unset IFS

case $1 in
	create)
		create_and_populate_and_clone $2 $3 $4
		;;
	pull)
		pull_from_remote_all_projects $2
		;;
	push)
		push_to_remote_all_projects $2
		;;
	synchronize)
		synchronize_branches_all_projects $2
		;;
	status)
		show_status_all_projects $2
		;;
	*)
		echo "create, pull, push, status basedir directory name server"
		;;
esac

