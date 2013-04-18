JFDI
====
Just Fffing Do It.


Getting Started
---------------
This is the organized mess of devops code used by the [Fireworks
Project](http://www.fireworksproject.com).  Most of the scripts in this
repository are used for building virtual machines locally for development, and
remotely for staging and production. Application deployment scripts, log
analysis, and database tools are also available here.


Technology Stack
----------------
The tech stack for the web development VM is designed for a Digital Ocean VPS.

* Ubuntu Precise 12.04 64bit
* Nginx 1.2.7
* PHP 5 and FPM
* Node.js 0.10.4


Installing the Development Environment
--------------------------------------
We're using Vagrant to manage virtual machines running on VirtualBox. We have a
base box (VM image) that is preconfigured with all dependencies and will
automatically be downloaded and installed the first time you spin up the
machine.

### VirtualBox
Find the latest VirtualBox package at
[www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads).
Download and install the correct package for your platform.

### Vagrant
_!important_: If you have previously installed Vagrant using the gem, that is
now deprecated.  You'll need to remove it before installing the 1.1.* series.

You can find the installation instructions for Vagrant at
[docs.vagrantup.com/v2/installation/](http://docs.vagrantup.com/v2/installation/index.html).

__GOTCHA (Ubuntu):__ Vagrant installs itself in `/opt/vagrant/`, which is probably
not on your PATH. This is a problem, because you'll need to run
`/opt/vagrant/bin/vagrant` instead of `vagrant` whenever you want to use it.
You can fix this pretty simply by creating a sym link to a directory which is
on your path like this:

	sudo ln -s /opt/vagrant/bin/vagrant /usr/local/bin/vagrant


Updating the Development Machine
--------------------------------
From time to time we need to rebuild our base boxes to reflect the latest
software and OS updates. To do that, check out the docs available in
`docs/create-devbox.md`.


Updating the Remote Machine
---------------------------
Of course, just updating the development machine is not enough, we need to keep
the production machines up to date as well. To do that, check out the docs available in
`docs/create-remotebox.md`.


Copyright and License
---------------------
Copyright: (c) 2013 by The Fireworks Project (http://www.fireworksproject.com)

Unless otherwise indicated, all source code is licensed under the MIT license. See LICENSE for details.
