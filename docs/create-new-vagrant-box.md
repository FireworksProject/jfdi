Create a New Vagrant Box
========================
Creating a new virtual machine box for Vagrant from a clean slate.


## 1) Download a box. There are a couple of lists of publicly available Vagrant base boxes on the interwebs:

* https://github.com/mitchellh/vagrant/wiki/Available-Vagrant-Boxes
* http://www.vagrantbox.es/

Download the box and add it to the local file system using `vagrant box add`. Example:

	vagrant box add precise64 http://files.vagrantup.com/precise64.box

For the rest of these steps, make sure your current working directory is the
root directory for the guest VM on your local host machine. When building a
base box this should always be `virtual_machines/base/`. There should be a
Vagrantfile already present in this base directory.

Edit the vagrant file to set `config.vm.box` to the box you just added. Example:

	config.vm.box = "precise64"

The last thing we'll need to build the box is the VirtualBox Gueset Additions. This was actually
already downloaded when you installed VirtualBox, but we need to copy the VBoxGuestAdditions.iso
to the VM root directory on your local machine so it is available in the `/vagrant/` shared folder
from within the VM.

This will allow us to mount the iso image and install VBoxGuestAdditions.

* On an Ubuntu host, you can find this file at `/usr/share/virtualbox/VBoxGuestAdditions.iso`.
* On Mac OS X hosts, you can find this file in the application bundle of
	VirtualBox. (Right click on the VirtualBox icon in Finder and choose Show
	Package Contents. There it is located in the Contents/MacOS folder.)
* On Solaris hosts, you can find this file in the additions folder under where
	you installed VirtualBox (normally /opt/VirtualBox).
* On a Windows host, you can find this file in the VirtualBox installation
	directory (usually under C:\Program files\Oracle\VirtualBox ).


## 2) Update the System
First you need to SSH into the VM:

	vagrant up
	vagrant ssh

Once you're in, copy the VBoxGuestAdditions.iso to a new location so we don't lose it:

	mkdir ~/vbox
	cp /vagrant/VBoxGuestAdditions.iso ~/vbox/

and then update the system:

	sudo apt-get update
	sudo apt-get dist-upgrade
	sudo apt-get autoremove

*Important note:* If prompted to choose which disk to install grub on, choose sda.

When that's done, then (re)install the VirtualBox dependencies:

	sudo apt-get install build-essential dkms

Lastly, stop the machine (after exiting the SSH session) with:

	vagrant halt


## 3) Install VBox Guest Additions
Start the VM back up with `vagrant up`. You'll notice that vagrant seems to
break at this point. That's because we've updated the Ubuntu system, but we
have not yet updated VBoxGuestAdditions. So, when the machine restarts you'll
see this:

	The following SSH command responded with a non-zero exit status.
	Vagrant assumes that this means the command failed!

	mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` v-root /vagrant

Not to worry, we're going to fix that right now. SSH back into the VM with
`vagrant ssh` and mount the iso image:

	cd ~
	mkdir vbg
	sudo mount -o loop vbox/VBoxGuestAdditions.iso vbg

And then install VBoxGuestAdditions:

	sudo vbox/VBoxLinuxAdditions.run

It will warn you that it could not find the Window System drivers, but that's
OK, because we don't use them.  Then, exit the VM, shut it down, and remove the
local VBoxGuestAdditions.iso.


## 4) Install RVM, Ruby, and Rails
If you're still logged into the VM, exit it and run `vagrant reload`. When it
has rebooted, SSH back into the machine with `vagrant ssh` and make the first
pass with the build script:

	/jfdi/bin/devbox build

This will install curl and RVM, then spit a list of requirements at you. You
might want to review the required packages and make sure they are included in
the ones that will be installed by `libexec/devbox-build`.

When you're done, you'll need to log out of the VM and restart it again. When
it boots back up, log in and run the build script again:

	/jfdi/bin/devbox build

This time it will install the required versions of MySQL, Ruby, and Rails in
all the appropriate places. For MySQL, just use the password "rudy" when
prompted.
