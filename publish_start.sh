#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config.sh"
. "$DIR/util.sh"

cleanup(){
	if [[ -f $onpidfi ]]; then
		rm -f $onpidfi
	fi
}

trap cleanup EXIT

if [[ -f $offpidfi ]]; then
	errcho Stopping offline stream...
	offpid=$(<$offpidfi)
	rm -f $offpidfi
	kill $offpid
fi

errcho Starting online stream...
ffmpeg -loglevel fatal -i $rtmpi -c copy -f mpegts pipe:1 > $pfi &
onpid=$!
echo $onpid > $onpidfi
wait $onpid