#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config.sh"
. "$DIR/util.sh"

cleanup(){
	if [[ -f $offpidfi ]]; then
		rm -f $offpidfi
	fi
}

trap cleanup EXIT

if [[ -f $onpidfi ]]; then
	errcho Stopping online stream...
	onpid=$(<$onpidfi)
	rm -f $onpidfi
	kill $onpid
fi

errcho Starting offline stream...
ffmpeg -loglevel fatal -stream_loop -1 -re -i $offfi -c copy -f mpegts pipe:1 > $pfi &
offpid=$!
echo $offpid > $offpidfi
wait $offpid