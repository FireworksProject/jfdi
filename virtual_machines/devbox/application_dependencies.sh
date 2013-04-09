#!/bin/bash
# Summary: Install the application dependencies: Ruby and PostgreSQL.
# Help: This script is only meant to be run on a virtual machine, never your
# local work station or laptop.

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
