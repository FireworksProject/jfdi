Create a Development Vagrant Box
================================
From time to time, we'll neet to update, rebuild, and publish the JFDI Vagrant
box (virtual machine image) used for development.  Here is how that can be done:

### 1) Download a Base Box
We're using an Ubuntu 12.04 Precise box on Digital Ocean, so that's what we'll
try to approximate for our base boxes. You can list your local base boxes with
`vagrant box list`. If the 'precise64' box is not present download it and add
it to the local file system using `vagrant box add`. Example:

	vagrant box add precise64 http://files.vagrantup.com/precise64.box

When building for Vagrant, for the rest of these steps, make sure your current
working directory is the root directory for the guest VM on your local host
machine. When building a base box this should always be
`virtual_machines/devbox/`. There should be a Vagrantfile already present in
this base directory.

### 2) Prep the System
Make sure you have the [vagrant-vbguest
plugin](https://github.com/dotless-de/vagrant-vbguest) for vagrant before
upping the machine for the first time.

	vagrant up

Make a note of the local IP address that it reports on the terminal. You'll
need that for the next step. The IP address is simply echoed out by our very simple
provisioning script triggered in the Vagrantfile, and should show up in green.
You can force this to happen any time by add the `--provision` flag:

	vagrant up --provision

Once the VM is up, you need to deploy some scripts to it. Assuming you're still
in the base directory for this box (along side the 'Vagrantfile'), you can do
this by running

	./toehold.sh 192.168.1.128

where '192.168.1.128' should be substitued by the IP address the VM reported to
you when it booted up. You'll need to put in the vagrant user password at this
stage, which happens to be 'vagrant'. After that, log into the box with

	vagrant ssh

and then update the system by running the toehold script you just uploaded:

	/tmp/usr/bin/jfd bootstrap-server

This will install the Ubuntu system dependencies, including Ruby, RubyGems, and
Chef. This script will take several minutes to run, and while it does, you
might be prompted to answer a question or two about the install. Just use the
default choices and continue on. Once it's done, exit the ssh session.


### 3) Install Application Dependencies
After you've exited the VM and are back on your local terminal, restart the VM
from the local machine again using `vagrant reload`. Then deploy the build
scripts with

	./deploy-build.sh 192.168.128

where, again, '192.168.1.128' is substitued by the IP address the VM reported
to you when it booted up last time. You'll need to put in the vagrant user
password again, which happens to be 'vagrant', and you'll be prompted for it 3
times.

Log back in with `vagrant ssh` and then build the server:

	sudo ~/usr/bin/jfd build-server

!GOTCHA - Make sure you're running the above command as sudo.

This will invoke Chef to install Node.js, NGINX, and PHP. You can see the
recipes listed in `chef/solo.json`. After these Chef scripts are done running
you'll need to restart the box to enjoy your handywork. So, exit the VM and run

	vagrant reload

Vagrant will spew a bunch of stuff on your terminal, but one bit is important:
the local IP address of the VM. Use that IP to test the new box with this:

	curl -i http://192.168.1.128
	curl -i http://192.168.1.128/index.php

where '192.168.1.128' is the IP address of the VM. For index.php, you should
see the output of `phpinfo()`.


### 5) Package the Box
Packaging the box is pretty simple:

	vagrant package -o ~/jfdi-YYYY-MM-DD.box

Run that command from within the `virtual_machines/devbox/` directory.
When it's done packaging the box, upload it to Amazon S3.

!Make sure to update the box URL in the main jfdi Vagrantfile and destroy and remove
the deprecated box.

	vagrant box list
	vagrant box remove

