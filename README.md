# streamRIP

streamRIP is a simple set of bash scripts for use with the NGINX RTMP module.

It provides a "fallback" stream for when a main stream disconnects, so the stream never truly goes offline on the client side.


## Requirements
* NGINX compiled with the [NGINX RTMP module](https://github.com/arut/nginx-rtmp-module)
* FFmpeg

## Configuration
Configuration is done in `config.sh`, there are a few things you must change in this file:

* `offfi`

   The file to loop when the main stream is offline. This should be the full path to the file, and it must be in a location that is readable by nginx.

   The file should have as close as possible to the same encoding parameters as your actual stream, including resolution and bitrate.

* `secret`

   The "stream key" for streamRIP, should be a random, unguessable string. Note that this does *not* need to be the stream key for the service you're streaming on, it is only used by streamRIP.

* `rtmpe`

   The RTMP endpoint to stream to, this would be the server of whatever service you're streaming on, for Twitch it would look something like ` rtmp://live-abc.twitch.tv/app/{stream_key}
 `

* `rtmpi`

   The RTMP ingest server, this is the stream streamRIP will pull from as the "main" stream. You usually won't have to change this if you're using the provided streamRIP NGINX config.

## Installation
Copy the script into a location nginx will be able to read.
The suggested and default location is `/usr/share/nginx/streamRIP/`

If you install the script somewhere besides the default location, you will have to update the `streamrip.conf` file with the proper script location.

After the scripts are copied and updated if needed, copy the streamrip.conf to the location where your NGINX config file is located, you can either replace it entirely with the streamRIP config file, or transfer the rtmp section into an existing config file.

## Usage
After NGINX is started, you can set your live streaming program to stream to `rtmp://{ip}/live`, with your stream key set to the secret value you included in `config.sh`. `{ip}` should be the IP of the server NGINX is being hosted on.

Once you start streaming, your stream should being on whatever streaming service you are on.

If you go offline during the stream, the video you specific in `config.sh` will begin to loop until you go back online or NGINX is shut down.