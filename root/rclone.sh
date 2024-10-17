#!/usr/bin/env bash

exec rclone serve webdav \
    --config /config/rclone/rclone.conf \
    --vfs-cache-mode full \
    --cache-dir /cache/rclone \
    --addr unix:///var/run/rclone.sock \
    "${RCLONE_REMOTE}"
