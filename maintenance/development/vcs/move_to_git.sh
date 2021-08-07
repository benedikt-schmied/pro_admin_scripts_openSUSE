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
