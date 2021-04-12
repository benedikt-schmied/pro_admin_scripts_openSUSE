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
# Duplicates shall be identified using two parameters
# EXIF - Tags are equal
# they are the same size
#
# 
#----------------------------------------------------------

working_base=$1
tmpdir=$working_base/tmp
outdir=$working_base/out

find . -iname "*SYNO*" -exec rm -rf {} \;
find . -iname "*eadir*" -exec rm -rf {} \;

if [ -d $tmpdir ]
then
	echo "out already exists"
else
	sudo mkdir $tmpdir
	sudo chgrp users $tmpdir
	sudo chmod 777 $tmpdir
fi

if [ -d $outdir ]
then
	echo "out already exists"
else
	sudo mkdir $outdir
	sudo chgrp users $outdir
	sudo chmod 777 $outdir
fi

# find all images (at least all jpegs)
a=$(find . -iname "*.[jJ][pP]*[gG]")

echo "--- fetched all pictures"

# start processing one after the other
for i in ${a[@]};
do
	filename=${i##*/}
	
	# what will be the filename afterwards
    	#final_name=$(exiftool '-DataTimeOriginal $tmpdir/$filename %Y-%m-%d_%H-%M-%S.%%e')
    	final_name=$(exiftool '-DataTimeOriginal $tmpdir/$filename')
	echo $file_name
	exit
	if [ -f $final_name ];
	then
		exiftool '-Filename<DateTimeOriginal' -d %Y-%m-%d_%H-%M-%S%%-c.%%e $tmpdir/$filane -o $tmpdir/$filename
	fi

done
