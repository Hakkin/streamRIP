#!/bin/bash

# The file to play when the stream is offline, should be full path, and must be readable by nginx
# The file should have the same resolution and bitrate as your actual stream
offfi="CHANGE ME"

# Should be some random unguessable string, this will be your stream key for streamRIP
secret="CHANGE ME"

# The RTMP endpoint, ie: your Twitch RTMP link
rtmpe="CHANGE ME"

# The RTMP ingest stream, you probaly don't need to change this if you're using streamRIP nginx config
rtmpi="rtmp://127.0.0.1/live/$secret"

###############
# Don't touch #
###############
wd=/tmp/streamrip
pfi=$wd/streamrip
offpidfi=$wd/offline_pid
onpidfi=$wd/online_pid
offlo=$wd/offline_lock
onlo=$wd/online_lock