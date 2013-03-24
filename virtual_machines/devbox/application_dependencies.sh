#!/bin/bash
# Summary: Install the application dependencies: Ruby and PostgreSQL.
# Help: This script is only meant to be run on a virtual machine, never your
# local work station or laptop.

NGINX_VERSION="1.2.6"

fail () {
	echo "$@" >&2
	exit 1
}

if [ "$(id -u)" == "0" ]; then
	fail "This script must NOT be run by root, or by sudo."
fi

# Install NGINX
echo "Checking for NGINX ..."
if ! [ "/usr/local/nginx/sbin/nginx -v" ]; then
	echo "Installing NGINX $NGINX_VERSION"

	mkdir "/tmp/nginx_install"

	nginxurl="http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz"
	echo "Fetching NGINX from $nginxurl"

	curl -# -L "$nginxurl" \
			| tar xzf - -C "/tmp/nginx_install" --strip-components=1 \
			|| fail "Could not download NGINX $NGINX_VERSION"

	cd "/tmp/nginx_install"
	"./configure" || fail "Unable to configure NGINX"
	make || fail "Unable to make NGINX"
	sudo make install || fail "Unable to install NGINX"

	cd "$HOME"
	rm -rf "/tmp/nginx_install"
else
	"/usr/local/nginx/sbin/nginx" "-v"
fi

echo
echo "Application dependencies installed."
