#!/bin/bash
echo "starting synchronization script"

if [ $# -eq 0 ]
then
	echo "-- do not know what to do, quit!"
	exit 0
fi

job_desc="none"

sync_flags="-uvr --progress --human-readable"

function do_sync() {
	echo "running sync"
	rsync $sync_flags $1/ root@linux-5k9k:/nfsexport/common/$2/
}

case $1 in
	documents)
		job_desc="documents"
		do_sync Documents Documents
		;;
	projects)
		job_desc="projects"		
		do_sync projects projects
		;;
	music)
		job_desc="music"
		do_sync music music
		;;
	worksapces)
		job_desc="workspaces"
		do_sync workspaces workspaces
		;;
	videos)
		job_desc="videos"
		do_sync video video
		;;
	downloads)
		job_desc="downloads"
		do_sync Downloads Downloads
		;;
	pictures)
		job_desc="pictures"
		do_sync Pictures Pictures
		;;
	all)
		job_desc="all"
		do_sync Downloads Downloads
		do_sync video video
		do_sync workspaces workspaces
		do_sync music music
		do_sync projects projects
		do_sync Documents Documents	
		;;
	*)
		echo "unknown command, quit!"
		exit 0
		;;	
esac

if [ $job_desc != "none" ]
then
	echo "-- job " $job_desc " was executed"
fi

