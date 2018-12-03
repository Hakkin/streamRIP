#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config.sh"
. "$DIR/util.sh"

me="`basename $0`"

exec 200>$onlo
if ! flock -xn 200; then
	errcho "[$me] Failed to aquire lock, exiting..." && exit 1
fi

cleanup(){
	if [[ -f $onpidfi ]]; then
		errcho "[$me] Removing Online pid file..."
		rm -f $onpidfi
	fi
	errcho "[$me] Removing Online lock file..."
	flock -u 200
	flock -xn 200 && rm -f $onlo
}

trap cleanup EXIT

if [[ -f $offpidfi ]]; then
	offpid=$(<$offpidfi)
	errcho "[$me] Stopping offline stream (pid $offpid)..."
	rm -f $offpidfi
	kill $offpid
fi

errcho "[$me] Starting online stream..."
ffmpeg -loglevel warning -i $rtmpi -c copy -f mpegts pipe:1 > $pfi &
onpid=$!
errcho "[$me] Online stream pid $onpid"
echo $onpid > $onpidfi
wait $onpid