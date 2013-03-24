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

sudo apt-get --no-install-recommends --assume-yes install \
    bash \
    curl \
    vim \
    tree \
    git-core \
    patch \
    bzip2 \
    build-essential \
    dkms \
		libpcre3-dev \
    || fail "Unable to install system dependencies."

sudo apt-get autoremove --assume-yes

    echo "System dependencies are have been installed.
To install the application dependencies

	/vagrant/application_dependencies
"
