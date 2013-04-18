#!/bin/bash
# Summary: Install the application dependencies: Ruby and PostgreSQL.
# Help: This script is only meant to be run on a virtual machine, never your
# local work station or laptop.

NODE_VERSION="v0.10.4"

fail () {
	echo "$@" >&2
	exit 1
}

if [ "$(id -u)" == "0" ]; then
	fail "This script must NOT be run by root, or by sudo."
fi

# Get the latest NGINX.
sudo add-apt-repository ppa:nginx/stable --yes
sudo apt-get update

sudo apt-get --assume-yes install \
    nginx \
    php5 \
    php5-fpm \
    php5-common \
    php5-dev \
    php5-gd \
    php5-xcache \
    php5-mcrypt \
    php5-pspell \
    php5-snmp \
    php5-xsl \
    php5-imap \
    php5-geoip \
    php5-curl \
    php5-cli \
    || fail "Unable to install application packages."

# Install Node.js
echo "Checking for Node.js ..."
if [ "$( node --version )" != "$NODE_VERSION" ]; then
	echo "Installing Node.js $NODE_VERSION"

	nodeurl="http://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION.tar.gz"
	echo "Fetching Node.js from $nodeurl"

	mkdir "/tmp/node_install"

	curl -# -L "$nodeurl" \
			| tar xzf - -C "/tmp/node_install" --strip-components=1 \
			|| fail "Could not download Node.js $NODE_VERSION"

	cd "/tmp/node_install"
	"./configure" || fail "Unable to configure Node.js"
	make || fail "Unable to make Node.js"
	sudo make install || fail "Unable to install Node.js"

	cd "$HOME"
	rm -rf "/tmp/node_install"
	echo "Node.js $NODE_VERSION installed."
else
	echo "Node.js $( node --version ) already installed."
fi

# Create the socket directory for PHP-FPM.
if ! [ -d /var/run/php5-fpm ]; then
    sudo mkdir /var/run/php5-fpm
fi

# Config files for the default WWW site.
sudo cp /vagrant/pool-d-default_nginx.conf /etc/php5/fpm/pool.d/default_nginx.conf
sudo cp /vagrant/sites-available-default.conf /etc/nginx/sites-available/default

# Restart the web servers.
sudo service php5-fpm restart
sudo service nginx restart

echo
echo "Application dependencies installed."
