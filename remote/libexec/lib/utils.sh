homedir="/home/vagrant"

fail () {
	echo "$@" >&2
	exit 1
}

if [ "$HOSTNAME" == "massive-dev" ]; then
    IS_DEVBOX=0
elif [ "$HOSTNAME" == "massive" ]; then
    IS_DEVBOX=1
else
    fail "This script is only meant to be run on remote 'massive-dev' or 'massive' hosts."
fi
