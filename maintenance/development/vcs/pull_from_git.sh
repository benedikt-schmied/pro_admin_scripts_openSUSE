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

