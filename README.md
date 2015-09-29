JFDI
====
Just Effing Do It.

Purpose
-------
The goal of the JFDI project is to provide a repository of tools to make server and remote application administration as easy as possible. We run a lot of different applications on very different architectures (PHP, PHP-FPM, Nginx, Node.js, MySQL, WordPress) so we need good tools *and documentation* to keep it all straight.

Most of the scripts in this repository are used for building virtual machines
locally for development, and remotely for staging and production. Application
deployment scripts, log analysis, and database tools are also available here.

Approach
--------
### Production Server
We have a single machine that we intend to scale vertically as long as
possible, nicknamed 'massive' server. Our main host for that machine is
currently DigitalOcean. Although, we'd like to be able to spin up the machine
on other hosts as well, for redundency.

After spinning up the 'droplet' on Digital Ocean, we bootstrap the machine with some shell scripts. After that, a Chef run takes care of the rest.

Chef is also used to setup the applications the server is responsible for.
After setup, application specific scripts are used to deploy and maintain the
applications running on the massive server.

### Development Server
We also have a development server configuration used for development and
testing.  Vagrant and VirtualBox make it easy to build a maintain virtual
machines that can easily be hosted on any workstation or laptop.

Technology Stack
----------------
The tech stack for the web development VM is designed for a Digital Ocean VPS.

* Ubuntu Trusty 14.04 64bit
* Nginx 1.4.1
* PHP 5 and FPM
* Node.js 0.12.x

Where to Find Everything
------------------------
### Locally
A good place to get started is to check out the jfd script itself by running

	./jfd help

### Remote Server
* All web applications are served from the root `/webapps/` directory.
* Nginx configs for each app can be found in `/etc/nginx/sites-available/`.
* Application logs can generally be found in `/var/log/`.

### Chef
* Chef cookbooks get deployed to `/home/vagrant/build/`.

Installing the Development Environment
--------------------------------------
You'll need to install Node.js, VirtualBox, and Vagrant (make sure you also get
the vagrant-vbguest plugin -- instructions below):

### VirtualBox
Find the latest VirtualBox package at
[www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads).
Download and install the correct package for your platform.

### Vagrant
You can find the installation instructions for Vagrant at
[docs.vagrantup.com/v2/installation/](http://docs.vagrantup.com/v2/installation/index.html).

__GOTCHA (Ubuntu users):__ Vagrant installs itself in `/opt/vagrant/`, which is probably
not on your PATH. This is a problem, because you'll need to run
`/opt/vagrant/bin/vagrant` instead of `vagrant` whenever you want to use it.
You can fix this pretty simply by creating a sym link to a directory which is
on your path like this:

	sudo ln -s /opt/vagrant/bin/vagrant /usr/local/bin/vagrant

#### Vagrant VBGuest Plugin
Make sure you install the [vagrant-vbguest
plugin](https://github.com/dotless-de/vagrant-vbguest) for vagrant, which
manages the hassle of VirtualBox Guest Additions for you:

	vagrant plugin install vagrant-vbguest

### Download and install JFDI
Clone this repository with git (if you haven't already) and initialize it with
npm (assuming you've installed Node.js on your local workstation).

	git clone git@github.com:FireworksProject/jfdi.git
	cd jfdi
	npm install


Copyright and License
---------------------
Copyright: (c) 2013 by The Fireworks Project (http://www.fireworksproject.com)

Unless otherwise indicated, all source code is licensed under the MIT license. See LICENSE for details.
