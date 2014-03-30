Create a Remote Production Box
==============================

### 1) Create a Machine
Use the Digital Ocean management console to create a bare Ubuntu 12.04 machine.
* Make sure an SSH key has been uploaded.
* Use 'massive' as the hostname name.
* 512MB/20GB box
* In 'New York 2' region.
* Ubuntu 12.04 x64 image.

### 2) Update the Domain Name
Grab the IP address off the Digital Ocean control panel and plug it into the
'massive-b.fwp-dyn.com' subdomain on DynDNS.

Later, when this box is ready to go, we'll switch the IP address over to
'massive.fwp-dyn.com'.

### 3) Create A User
We need a named user that can sudo.  Generate or locate the password for the
'vagrant' user from your password bank on your local workstation.  Then ssh
into the remote machine:

	ssh -i ~/.ssh/fwp_digitalocean_rsa root@massive-b.fwp-dyn.com

Then add the user:

	adduser vagrant

Make sure you add the password, but skip all the other fields during the
adduser process by pressing enter at each prompt.  Then give the vagrant user
sudo privileges.

	adduser vagrant sudo

And then change the configs so the sudo users can sudo without a password:

	sudo visudo

and edit this line to be like this:

	# Allow members of group sudo to execute any command
	%sudo   ALL=(ALL:ALL) NOPASSWD: ALL


### 4) SSH Access
First, we need to copy the authorized_keys to the vagrant user, so it can login.

	mkdir /home/vagrant/.ssh
	chmod 700 /home/vagrant/.ssh
	cp /root/.ssh/authorized_keys /home/vagrant/.ssh/
	chown -R vagrant:vagrant /home/vagrant/.ssh/

Configure SHH access by editing `/etc/ssh/sshd_config` and add or change the
following lines:

	PermitRootLogin no
	AllowUsers vagrant

Then exit and restart the machine with:

	shutdown -r now

If you screwed something up (like forgetting to add sudo privilages to vagrant
user) then `PermitRootLogin no` is going to lock you out of the machine.

On your local machine, make sure you've

	ssh-add ~/.ssh/fwp_digitalocean_rsa


### 5) Install System Dependencies

First, deploy the toehold scripts to the remote box from this repository on
your local workstation.

	./jfd deploy toehold massive-b.fwp-dyn.com

Then ssh into the remote `ssh vagrant@massive-b.fwp-dyn.com` and run the
install-system script on the remote (you'll need the vagrant password so you can sudo).

	/tmp/usr/bin/jfd bootstrap-server

Once that is done installing, exit and reboot the machine `sudo shutdown -r now`.

### 6) Install Application Dependencies
Start by deploying the Chef build.

	./jfd deploy build massive-b.fwp-dyn.com

Log back in with `ssh vagrant@massive-b.fwp-dyn.com` and then build the server:

	sudo ~/usr/bin/jfd build-server

This will install Node.js, NGINX, and PHP. After these Chef scripts are
done running you'll need to restart the box to enjoy your handywork.

	sudo shutdown -r now

And then run some tests:

	curl -i http://massive-b.fwp-dyn.com
	curl -i http://massive-b.fwp-dyn.com/index.php

For index.php, you should see the output of `phpinfo()`.

If those requests don't work as expected, try a simple restart first.

### 7) Setup The Server
First, you need to deploy the secret configuration script:

	scp ~/.jfdi/server.json vagrant@massive-b.fwp-dyn.com:~/build/

!GOTCHA - It's important to not that whenever you run `./jfd deploy build
massive-b.fwp-dyn.com` or run `~/usr/bin/jfd setup-server` it will destroy
`server.json`.

Any SSL certificates should be copied to the sever and moved to
`/etc/ssl/`, which should include the `*.crt` and `*.key` files.

Then log into the machine with `ssh vagrant@massive-b.fwp-dyn.com` and run the
setup-server Chef script:

	sudo ~/usr/bin/jfd setup-server

And then restart it again with `sudo shutdown -r now`.

This time, the test results will be different (no more sites-enables/default).

	curl -i http://massive-b.fwp-dyn.com
	# Results in a 502 bad gateway
	curl -i http://massive-b.fwp-dyn.com/index.php
	# Results in a 502 bad gateway

### 8) Install The Applications
All the applications can be installed from your local workstation with the jfd
deploy script. See `docs/applications.md` for more info.

!GOTCHA - You have to make sure the packages have been fully built and tested
on your local workstation and are linked into the `webapps/` directory before
they can be deployed.

	/jfd deploy <package_name> massive-b.fwp-dyn.com

Then follow the instructions in `/docs/applications.md` to start each
application.

