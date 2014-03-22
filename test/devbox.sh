#!/usr/bin/env bash

addr="$1"

if [ -z "$addr" ]; then
	echo "The <addr> argument is required (the ip address of the vbox)."
	exit
fi

echo ""
echo "Test www.htmlandcsstutorial.com"
echo "---------------------"
curl -I "http://$addr:8007"
echo "* The status should be 200."
echo "* The server should be nginx."
echo "---"

echo ""
echo "Test www.pinfinity.co"
echo "---------------------"
curl -I "http://$addr:8003"
echo "* The status should be 200."
echo "* The server should be nginx."
echo "* Should be powered by PHP."
echo "---"
