#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config.sh"
. "$DIR/util.sh"

cleanup(){
	rm -rf $wd
}

trap cleanup EXIT

# If the working directory doesn't exist already, make it
if [[ ! -d $wd ]]; then
	errcho Creating working diretory...
	mkdir $wd
fi

# If the pipe doesn't exist already, make it
if [[ ! -p $pfi ]]; then
	errcho Creating pipe file...
	mkfifo $pfi
fi

# Hold pipe open
sleep infinity >$pfi &
epid=$!
trap "kill $epid" EXIT

errcho Waiting for stream...
ffmpeg -loglevel fatal -f mpegts -i $pfi -c copy -bsf:a aac_adtstoasc -f flv -rtmp_live live $rtmpe