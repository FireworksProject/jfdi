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


### 2) Update the System
First you need to start the VM and SSH into it:

	vagrant up
	vagrant ssh

Once you're in, move the VBoxGuestAdditions.iso to a new location so we don't
lose it:

	mv /vagrant/VBoxGuestAdditions.iso ~/

and then update the system by running the provided script:

	/vagrant/system_dependencies.sh

This will install the Ubuntu system dependencies.


### 3) Install VBox Guest Additions
Exit the VM and restart it from the local machine with `vagrant reload`. You'll
notice that vagrant seems to break at this point. That's because we've updated
the Ubuntu system, but we have not yet updated VBoxGuestAdditions. So, when the
machine restarts you'll see this:

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

Then, exit the VM.

### 4) Install Application Dependencies
Exit the VM and restart it from the local machine again using `vagrant reload`.
Log back in with `vagrant ssh` and run the update the application dependencies
by running the provided script:

	/vagrant/application_dependencies.sh

This will install NGINX and PHP.


### 5) Package the Box
First test the web servers with:

	curl -i http://localhost
	curl -i http://localhost/info.php

Then packaging the box is pretty simple:

	vagrant package -o /tmp/jfdi-YYYY-MM-DD.box

Run that command from within the `virtual_machines/devbox/` directory.
When it's done packaging the box, upload it to Amazon S3.
