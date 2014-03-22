Create a Remote Production Box
==============================

### 1) Create a Machine
Use the Digital Ocean management console to create a bare Ubuntu 12.04 machine.
* Make sure an SSH key has been uploaded.
* Use 'massive' as the hostname name.
* 512MB/20GB box
* In 'New York 2' region.
* Ubuntu 12.04 x64 image.

### 2) Create Some Users
We need a named user that can sudo, and the git user (without sudo privileges).
Generate or locate the passwords for the 'vagrant' and 'git' users from your
password bank on the local workstation.  Then ssh into the remote machine:

	ssh root@massive-b.fwp-dyn.com

Then add the users:

	adduser vagrant
	adduser git

Make sure you add the passwords, but skip all the other fields during the
adduser process by pressing enter at each prompt.  Then give the vagrant user
sudo privileges.

	adduser vagrant sudo


### 3) SSH Access
Configure SHH access by editing `/etc/ssh/sshd_config` and add or change the
following lines:

	PermitRootLogin no
	AllowUsers vagrant git

Then exit and restart the machine with:

	shutdown -r now

If you screwed something up (like forgetting to add sudo privilages to vagrant
user) then `PermitRootLogin no` is going to lock you out of the machine.

Back on your workstation, you can upload your key like this:

	ssh-copy-id -i ~/.ssh/id_rsa vagrant@massive-b.fwp-dyn.com
	ssh-copy-id -i ~/.ssh/id_rsa git@@massive-b.fwp-dyn.com

NOTE: ssh-copy-id is not available on Mac OS X.


### 4) Install System Dependencies

First, deploy the toehold scripts to the remote box from this repository on
your local workstation.

	./jfd deploy toehold massive-b.fwp-dyn.com

Then ssh into the remote `ssh vagrant@massive-b.fwp-dyn.com` and run the
install-system script on the remote (you'll need the vagrant password so you can sudo).

	/tmp/usr/bin/jfd bootstrap-server

Once that is done installing, exit and reboot the machine `sudo shutdown -r now`.

### 5) Install Application Dependencies
Starty by deploying the Chef build.

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

### 6) Setup The Server
First, you need to deploy the secret configuration script:

	scp ~/.jfdi/server.json vagrant@massive-b.fwp-dyn.com:~/build/

Then log into the machine with `ssh vagrant@massive-b.fwp-dyn.com` and run the
setup-server Chef script:

	sudo ~/usr/bin/jfd setup-server

And then restart it again with `sudo shutdown -r now`.

This time, the test results will be different (no more sites-enables/default).

	curl -i http://massive-b.fwp-dyn.com
	# Results in a 404
	curl -i http://massive-b.fwp-dyn.com/index.php
	# Results in a 404
	curl -i http://massive-b.fwp-dyn.com:5985
	# Results in a 401

### 7) Install The Applications
All the applications can be installed from your local workstation with:

	/jfd deploy <package_name> massive-b.fwp-dyn.com

You just have to make sure the package is linked into the `webapps/` directory.
