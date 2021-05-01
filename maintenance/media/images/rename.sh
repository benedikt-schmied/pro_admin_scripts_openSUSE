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


# #########################################################################
# the following definitions are necessary for running these scripts
# e.g.
# folders, ...
# #########################################################################
rootnode=$2
rootnode=$2
working_base=$1
tmpdir=$working_base/tmp
outdir=$working_base/out
faultdir=$working_base/fault
nonjpg=$working_base/njpg
rootnode=$2

# #########################################################################
#
# #########################################################################
function delete_unnecessary_files() {
	echo "starting to delete unknown files"
	find $rootnode -iname "*SYNO*" -exec rm -rf {} \;
	find $rootnode -iname "*eadir*" -exec rm -rf {} \;
}


# #########################################################################
#
# #########################################################################
function create_folders() {

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

	if [ -d $faultdir ]
	then
		echo "faultdir already exists"
	else
		sudo mkdir $faultdir
		sudo chgrp users $faultdir
		sudo chmod 777 $faultdir
	fi

	if [ -d $nonpjg ]
	then
		echo "faultdir already exists"
	else
		sudo mkdir $nonjpg
		sudo chgrp users $nonjpg
		sudo chmod 777 $nonjpg
	fi
}

# find all images (at least all jpegs)
IFS=$'\n'
a=$(find $rootnode -iname "*.[jJ][pP]*[gG]")

echo "--- fetched all pictures"

# start processing one after the other
for i in ${a[@]};
do
	filename=${i##*/}
	extension=${filename##*.}	
	echo "working on "$i
	
	# what will be the filename afterwards?
	# the formatter is given with the '-d' parameter
	# we're asking for the DateTimeOriginal
	# 's3' strips down the information to the pure data (without field identifier such as "Date Time ...")
    	
	final_name=$(exiftool -s3 -d "%Y-%m-%d_%H-%M-%S" -DateTimeOriginal $i)

	# let's introduce a check for the return value here and simply
	# continue processing in case the return value is zero 
	# and the given string is unequal ""
        
        if [ "$final_name" == "" ];
	then
		echo "not able to exif - meta - info from file"	
		cp $i $faultdir
	else

		#final_name=$(exiftool '-DataTimeOriginal $tmpdir/$filename')
		echo $final_name.$extension
		if [ ! -f $tmpdir/$final_name.$extension ];
		then
			echo "starting copy operation"
			# we're using a similar command as above for the copy operation
			# as 'exiftool' will rectify any problem during the copy operation
			exiftool '-Filename<DateTimeOriginal' -d %Y-%m-%d_%H-%M-%S.%%e $i -o $tmpdir
		else
			echo "already existing, checking for size"
			file_sz_existing=$(du -k $i | cut -f1)
			file_sz_new=$(du -k $tmpdir/$final_name.$extension | cut -f1)
			echo "new file "$file_sz_new " existing "$file_sz_existing
			if [ $file_sz_existing -ne $file_sz_new ];
			then
				echo "this is a different file, thus, creating a clone"
				exiftool '-Filename<DateTimeOriginal' -d %Y-%m-%d_%H-%M-%S%%-c.%%e $i -o $tmpdir
			fi
		fi
	fi;

	# so seems, that we've either could read and copy the file or we've put it into a fault - folder
	# let's delete it!
	# rm $i
done


# #########################################################################
#
# #########################################################################
function move_from_tmp_to_out() {
	
	# all files are in a plain structure, let's create a structure in the out - folder
	a=$(find $tmpdir -iname "*.*")
	
	# ... and start to create a new structure
	for i in ${a[@]};
	do
		exiftool '-Directory<DateTimeOriginal' -d %Y/%Y%-m/Y%-%m-%d $outdir 	
	done
}

# now, look for all files that are non-hidden and non-jpg
a=$(find $rootnode -type f -iname "*.*")

for i in ${a[@]};
do 
	mv $i $nonjpg
done

unset IFS
