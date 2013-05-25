#!/usr/bin/env bash

ip=$1

if [ -z $ip ]; then
	echo "The <ip> argument is required."
	echo "Use the ip address listed when you started the VM with 'vagrant up'."
	exit
fi

../../usr/bin/jfd deploy toehold "$ip"
