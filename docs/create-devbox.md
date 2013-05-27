Create a Development Vagrant Box
================================
From time to time, we'll neet to update and rebuild the JFDI Vagrant box
(virtual machine image) used for development.  Here is how that can be done:

### 1) Download a Base Box
We're using an Ubuntu 12.04 Precise box on Digital Ocean, so that's what we'll
try to approximate for our base boxes.  Download the box and add it to the
local file system using `vagrant box add`. Example:

	vagrant box add precise64 http://files.vagrantup.com/precise64.box

When building for Vagrant, for the rest of these steps, make sure your current
working directory is the root directory for the guest VM on your local host
machine. When building a base box this should always be
`virtual_machines/devbox/`. There should be a Vagrantfile already present in
this base directory.

The last thing we'll need is the VirtualBox Guest Additions. This was actually
already downloaded when you installed VirtualBox, but we need to copy the
VBoxGuestAdditions.iso to the VM root directory `virtual_machines/devbox/` on
your local machine so it is available in the `/vagrant/` shared folder from
within the VM.  This will allow us to mount the iso image and install
VBoxGuestAdditions.  Copy the image from one of these locations:

* On Mac OS X hosts, you can find this file in the application bundle of VirtualBox `/Applications/VirtualBox.app/Contents/MacOS/VBoxGuestAdditions.iso`.
* On an Ubuntu host, you can find this file at `/usr/share/virtualbox/VBoxGuestAdditions.iso`.


### 2) Prep the System
First you need to start the VM.

	vagrant up

Make a note of the local IP address that it reports on the terminal. You'll
need that for the next step.

Once the VM is up, you need to deploy some scripts to it. Assuming you're still
in the base directory for this box (along side the 'Vagrantfile'), you can do
this by running

	./toehold.sh 192.168.1.128

where '192.168.1.128' should be substitued by the IP address the VM reported to
you when it booted up. You'll need to put in the vagrant user password at this
stage, which happens to be 'vagrant'. After that, log into the box with

	vagrant ssh

Once you're in, move the VBoxGuestAdditions.iso to a new location so we don't
lose it:

	mv /vagrant/VBoxGuestAdditions.iso ~/

and then update the system by running the toehold script you uploaded less than
a minute ago with `tohold.sh`:

	/tmp/usr/bin/jfd bootstrap-server

This will install the Ubuntu system dependencies, including Ruby, RubyGems, and
Chef. This script will take several minutes to run, and while it does, you
might be prompted to answer a question or two about the install. Just use the
default choices and continue on. Once it's done, exit the ssh session.


### 3) Install VBox Guest Additions
After exiting the VM, restart it with `vagrant reload`. You'll notice that
vagrant seems to break at this point. That's because we've updated the Ubuntu
system, but we have not yet updated VBoxGuestAdditions. So, when the machine
restarts you'll see this:

	The following SSH command responded with a non-zero exit status.
	Vagrant assumes that this means the command failed!

	mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` v-root /vagrant

Not to worry, we're going to fix that right now. SSH back into the VM with
`vagrant ssh` and mount the iso image:

	cd ~
	mkdir vbg
	sudo mount -o loop ~/VBoxGuestAdditions.iso ~/vbg

And then install VBoxGuestAdditions:

	sudo vbg/VBoxLinuxAdditions.run

It will warn you that it could not find the Window System drivers, but that's
OK, because we don't use them.  After it's done, let's remove the iso image:

	sudo umount ~/vbg
	rm ~/VBoxGuestAdditions.iso
	rmdir ~/vbg


### 4) Install Application Dependencies
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

This will install Node.js, CouchDB, NGINX and PHP. After these Chef scripts are
done running you'll need to restart the box to enjoy your handywork. So, exit
the VM and run

	vagrant reload

Vagrant will spew a bunch of stuff on your terminal, but one bit is important:
the local IP address of the VM. Use that IP to test the new box with this:

	curl -i http://192.168.1.128
	curl -i http://192.168.1.128/index.php
	curl -i http://192.168.1.128:5985

where '192.168.1.128' is the IP address of the VM. For index.php, you should
see the output of `phpinfo()`. The 5985 port should respond with the "hello
world" message from CouchDB.


### 5) Package the Box
First test the web servers with:

Then packaging the box is pretty simple:

	vagrant package -o /tmp/jfdi-YYYY-MM-DD.box

Run that command from within the `virtual_machines/devbox/` directory.
When it's done packaging the box, upload it to Amazon S3.
