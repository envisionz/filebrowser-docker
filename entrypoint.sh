#!/bin/sh

user_id=${FILEBROWSER_UID:-0}
group_id=${FILEBROWSER_GID:-0}

if [ "$(id -u)" != "0" ] || [ "$(id -g)" != "0" ]; then
    echo "Container must be started as root."
    exit 1
fi

if [ "$user_id" == "0" ] || [ "$group_id" == "0" ]; then
    echo "FILEBROWSER_UID and FILEBROWSER_GID must be set and not root."
    exit 1
fi

fb_user=fbuser

addgroup -g $group_id $fb_user
adduser -D -G $fb_user -u $user_id $fb_user 

chown -R "${fb_user}:${fb_user}" /data

su -m -l $fb_user

exec /opt/filebrowser/filebrowser "$@"
