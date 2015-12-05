#!/bin/bash

source $DIR/globals.sh

PATH=$PATH:$LOCAL_ROOT/metameta

# to be sourced

fatal_error() {
	# send text to standard error 
	echo $1 > /dev/stderr  #$1 is first argument
	exit 1  # exit and return status 1 to shell (could be 1 to 255)
}

is_file_readable() {
	file=$1
	# check for read access (-r) 
	if [ ! -r $file ]
	then
		# $0 is the name of the script itself
		fatal_error "$0: unable to read file: $file"
		# e.g. "upload_fastq: unable to read file: monkeytails"
	fi
}

is_file_writable() {
	file=$1
	# check for write access (-w) 
	if [ ! -w $file ]
	then
		fatal_error "$0: unable to write to file: $file"
	fi
}

ssh_cmd() {
	# send a command to the ssh socket. 
	cmd=$1
	# -S specifies the location of a control socket for connection sharing
	ssh -S $SSH_SOCKET $REMOTE_USER@$REMOTE_HOST $cmd
}

remote_file_exists() {
	remote_file=$1
	dirpre=`dirname $remote_file`
	filen=`basename $remote_file`
	# REMOTE_ROOT defined in globals.sh: REMOTE_ROOT=/gscratch/lidstrom/meta4
	ssh_cmd "(cd $REMOTE_ROOT; test -d $dirpre && find $dirpre -name '$filen')"
}

remote_file_exists_10mins_old() {
	remote_file=$1
	dirpre=`dirname $remote_file`
	filen=`basename $remote_file`
	# REMOTE_ROOT defined in globals.sh: REMOTE_ROOT=/gscratch/lidstrom/meta4
	# `find ./ -name 'filename' -cmin +10` finds the file filename if made more than 10 min ago 
	# change to /meta4, and ssh the file off if it is old enough. 
	ssh_cmd "(cd $REMOTE_ROOT; test -d $dirpre && find $dirpre -name '$filen' -cmin +10)"
}

send_path_to_remote() {
	path=$1
	tar -cf - $path | ssh_cmd "(cd $REMOTE_ROOT; tar -xf -)"
}

remove_path_on_remote() {
	path=$1
	tar -cf - $path | ssh_cmd "(cd $REMOTE_ROOT; \\rm -rf $path )"
}

gnucp() {
    if hash gcp 2>/dev/null; then
        gcp "$@"
    else
        cp "$@"
    fi
}

is_file_readable $SSH_SOCKET
is_file_writable $SSH_SOCKET

cd $LOCAL_ROOT
