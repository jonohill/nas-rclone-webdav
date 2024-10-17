#!/usr/bin/env bash

docker build -t rclone-webdav .

docker run -ti --rm --name rclone-webdav \
    -v ./test:/config \
    -e CF_TUNNEL_TOKEN \
    -e RCLONE_REMOTE \
    rclone-webdav
