#!/usr/bin/env bash

addr="$1"

if [ -z "$addr" ]; then
	echo "The <addr> argument is required (the ip address of the vbox)."
	exit
fi

echo ""
echo "Test CouchDB:"
echo "-------------"
curl -i "http://$addr:5985"
echo ""
echo "* The status should be 200."
echo "* The response body should be from CouchDB."
echo "---"

echo ""
echo "Test www.pinfinity.co"
echo "---------------------"
curl -I "http://$addr:8003"
echo "* The status should be 200."
echo "* The server should be Nginx."
echo "* Should be powered by PHP."
echo "---"
