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

