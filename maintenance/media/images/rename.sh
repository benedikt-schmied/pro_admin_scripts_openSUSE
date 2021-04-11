#!/bin/bash
#---------------------------------------------------------
#
# we want  to achieve:
# 1. get rid of files that have been created by an viewer (e.g. Synology, ...)
# 2. preserve original files 
# 3. give us the files that couldn't be read due to an unfixalbe error
# 4.
#
# It should provide parameters for
# input path
# output path
# 
#----------------------------------------------------------


outdir=../out

find . -iname "*SYNO*" -exec rm -rf {} \;
find . -iname "*eadir*" -exec rm -rf {} \;

if [ -d ../out ]
then
	echo "out already exists"
else
	sudo mkdir $outdir
	sudo chgrp users $outdir
	sudo chmod 777 $outdir
fi

a=$(find . -iname "*.[jJ][pP]*[gG]")

for i in ${a[@]};
do
	filename=${i##*/}
        cp $i $outdir/$filename
        exiftool '-Filename<DateTimeOriginal' -d %Y-%m-%d_%H-%M-%S%%-c.%%e $outdir/$filename
        
done

