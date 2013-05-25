#!/bin/bash

DATE_TODAY="$(date +%Y-%m-%d)"

fail () {
	echo "$@" >&2
	exit 1
}

super_user () {
    [ "$(id -u)" == "0" ] || return 1
}

super_or_fail () {
    local msg="$1"
    super_user || fail "Super user priv required $msg"
}

not_local () {
    local msg="$1"
    if ! [ $( hostname | grep massive ) ]; then
        fail $msg
    fi
}

ensure_dir () {
    if ! [ -d "$1" ]; then
        mkdir -p -- "$1" || fail "couldn't create $1"
    fi
}

remote_sync () {
    local src=$1
    local dest=$2

    local rsync_opts="\
    --recursive \
    --delete \
    --compress \
    --links \
    --perms \
    --times \
    --omit-dir-times \
    --progress \
    --human-readable \
    --exclude-from=$_JFD_ROOT/configs/rsync-exclude.list
    "

    rsync $rsync_opts "$src" "$dest"
}
