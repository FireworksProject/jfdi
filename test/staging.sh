#!/usr/bin/env bash

addr="massive-b.fwp-dyn.com"

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
curl -I "http://$addr"
echo "* The status should be 200."
echo "* The server should be nginx."
echo "* Should be powered by PHP."
echo "---"

echo ""
echo "Test www.pinfinity.co/hub/gallery/"
echo "---------------------"
curl -I "http://$addr/hub/gallery/"
echo "* The status should be 200."
echo "* The server should be nginx."
echo "* Should be powered by Enginemill."
echo "---"
