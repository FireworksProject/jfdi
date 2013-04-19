Create a Remote Production Box
==============================

### 1) Create Some Users
We need a named user that can sudo, and the git user (without sudo privileges).
Generate or locate the passwords for the 'vagrant' and 'git' users on the local
workstation.  Then ssh into the remote machine:

	ssh root@massive-b.fwp-dyn.com

Then add the users:

	adduser vagrant
	adduser git

Skip all the other fields during the adduser process by pressing enter at each
prompt.  Then give the vagrant user sudo privileges.

	adduser vagrant sudo


### 2) SSH Access
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


### 3) Install System Dependencies

First, deploy the toehold scripts to the remote box from this repository on
your local workstation.

	bin/jfd deploy-toehold massive-b.fwp-dyn.com

Then ssh into the remote `ssh vagrant@massive-b.fwp-dyn.com` and run the
install-system script on the remote (you'll need the vagrant password so you can sudo).

	/home/users/vagrant/remote/bin/remote install-system

Once that is done installing, reboot the machine `sudo shutdown -r now`, and
then ssh back in and run the setup script.

	sudo /home/users/vagrant/remote/bin/remote setup
