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
#!/bin/bash
# this script works as follows
# it will take each folder it can find
# initialize a git repository
# add all files to this repository
# do a initial commit
# change directory and clone a bore repository which
# it will move to the server


echo "this it the move to git script"

main_dir=$PWD

a=$main_dir/$1

if [ -d $a ] 
then
# echo the current directory
echo $a

# go into the directory
cd $a

#extract the folders name -> project name from the current path
b=$(basename $a)
echo $b

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
git clone --bare $b $b.git

# push it to the linux server
scp -r $b.git linux-5k9k:/nfsexport/common/vcs/software/

rm -rf $b $b.git

#clone it again
git clone linux-5k9k:/nfsexport/common/vcs/software/$b

# return from this directory
cd $main_dir

fi
#!/bin/bash
b=$PWD
for a in ./*;
do
if [ -d $a ];
then
cd $a;
echo $a;
git pull;
cd $b;
fi
done

#!/bin/bash
b=$PWD
for a in ./*;
do
if [ -d $a ];
then
cd $a;
echo $a;
git push origin master;
cd $b;
fi
done

#!/bin/bash
b=$PWD
for a in ./*;
do
if [ -d $a ];
then
cd $a;
echo $a;
git status;
cd $b;
fi
done

#!/bin/bash
# this script works as follows
# it will take each folder it can find
# initialize a git repository
# add all files to this repository
# do a initial commit
# change directory and clone a bore repository which
# it will move to the server


echo "this it the move to git script"

main_dir=$PWD

a=$main_dir/$1

if [ -d $a ] 
then
# echo the current directory
echo $a

# go into the directory
cd $a

#extract the folders name -> project name from the current path
b=$(basename $a)
echo $b

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
git clone --bare $b $b.git

# push it to the linux server
scp -r $b.git linux-5k9k:/nfsexport/common/vcs/software/

rm -rf $b $b.git

#clone it again
git clone linux-5k9k:/nfsexport/common/vcs/software/$b

# return from this directory
cd $main_dir

fi
