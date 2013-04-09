#!/bin/bash
# Summary: Install dependencies and build the development virtual machine.
# Help: This script is only meant to be run on a virtual machine, never your
# local workstation or laptop.

fail () {
    echo "$@" >&2
    exit 1
}

if [ "$(id -u)" == "0" ]; then
    fail "This script must NOT be run by root, or by sudo."
fi

###
# Update Ubuntu
###

sudo apt-get update || fail "Unable to update package repository."
sudo apt-get dist-upgrade --assume-yes || fail "Unable to upgrade the system."

# curl - Utiility
# vim - Utiility
# tree - Utiility
# python-software-properties - Required for latest NGINX.
# build-essential - Required for VirtualBox
# dkms - Required for VirtualBox

sudo apt-get --assume-yes install \
    curl \
    vim \
    tree \
    python-software-properties \
    build-essential \
    dkms \
    || fail "Unable to install system dependencies."

sudo apt-get autoremove --assume-yes

    echo "System dependencies are have been installed.
To install the application dependencies, restart the machine and run

	/vagrant/application_dependencies.sh
"
