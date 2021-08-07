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

