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

Then exit and restart the machine. If you screwed something up (like forgetting
to add sudo privilages to vagrant user) then `PermitRootLogin no` is going to
lock you out of the machine.

Back on your workstation, you can upload your key like this:

	ssh-copy-id -i ~/.ssh/id_rsa vagrant@massive-b.fwp-dyn.com
	ssh-copy-id -i ~/.ssh/id_rsa git@@massive-b.fwp-dyn.com

NOTE: ssh-copy-id is not available on Mac OS X.
