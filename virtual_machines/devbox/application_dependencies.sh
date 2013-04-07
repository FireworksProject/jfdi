#!/bin/bash
# Summary: Install the application dependencies: Ruby and PostgreSQL.
# Help: This script is only meant to be run on a virtual machine, never your
# local work station or laptop.

NGINX_VERSION="1.2.8"

fail () {
	echo "$@" >&2
	exit 1
}

if [ "$(id -u)" == "0" ]; then
	fail "This script must NOT be run by root, or by sudo."
fi

# Install NGINX
echo "Checking for NGINX ..."
if ! [ -f "/usr/local/nginx/sbin/nginx" ]; then
	echo "Installing NGINX $NGINX_VERSION"

	install_dir="/tmp/nginx_install"
	mkdir $install_dir

	nginxurl="http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz"
	echo "Fetching NGINX from $nginxurl"

	curl -# -L "$nginxurl" \
			| tar xzf - -C $install_dir --strip-components=1 \
			|| fail "Could not download NGINX $NGINX_VERSION"

	cd $install_dir
	"./configure" || fail "Unable to configure NGINX"
	make || fail "Unable to make NGINX"
	sudo make install || fail "Unable to install NGINX"

	cd "$HOME"
	rm -rf $install_dir
else
	"/usr/local/nginx/sbin/nginx" "-v"
fi

echo
echo "Application dependencies installed."
