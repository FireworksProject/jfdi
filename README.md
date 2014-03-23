JFDI
====
Just Effing Do It.

Purpose
-------
This is the organized mess of devops code used by the [Fireworks
Project](http://www.fireworksproject.com).  The goal of the JFDI project is to
provide a repository of tools to make server and remote application
administration as easy as possible. We run a lot of different applications on
very different architectures (PHP, PHP-FPM, Nginx, Node.js, MySQL, WordPress)
so we need good tools *and documentation* to keep it all straight.

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

After spinning up the 'droplet' on Digital Ocean (using a public key we've
uploaded), we bootstrap the machine with some shell scripts. After that, a Chef
run takes care of the rest.

Chef is also used to setup the applications the server is responsible for.
After setup, application specific scripts are used to deploy and maintain the
applications running on the massive server.

### Development Server
We also have a development server configuration used for, well, development and
testing.  Vagrant and VirtualBox make it easy to build a maintain vertual
machines that can easily be hosted on any workstation or laptop.

Using Vagrant we create a base box, which is hosted remotely. By periodically
rebuilding this base box to keep it up to date, we can cheaply build and
destroy our local copies during development and testing without having to worry
about taking the time to build another one locally.


Technology Stack
----------------
The tech stack for the web development VM is designed for a Digital Ocean VPS.

* Ubuntu Precise 12.04 64bit
* Nginx 1.4.1
* PHP 5 and FPM
* Node.js 0.10.26


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
We're using Vagrant to manage virtual machines running on VirtualBox. We have a
base box (VM image) that is preconfigured with all dependencies and will
automatically be downloaded and installed the first time you spin up the
machine.

All you need to do is install VirtualBox and Vagrant (make sure you also get
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
	cd jfdi & npm install

### Keys (application keys and Chef)
Development on the local VM, as well as deployment on the main server requires
authentication keys, of course. You should create a `~/.jfdi/` directory in
your home folder, and in it, you should put a `server.json` file, which
contains all the application and remote service keys you need. You can use the
`server.example.json` file to get started.


Applications
------------
See `docs/applications.md` for more info.


Logging Into the Remote Server
------------------------------
We use an SSH key to log into the remote server, and a domain name pointing to
the IP address.

	ssh -i ~/.ssh/fwp_digitalocean_rsa vagrant@massive-b.fwp-dyn.com


Testing
-------
Run the jfd command help to see what can be tested

	./jfd help test


Updating Configurations
-----------------------
Any time there is a change made to the system or application configurations in
`cookbooks/` the changes will need to be deployed to the local development VM
as well as the remote servers. To do this on the local VM, simply restart it
with `vagrant reload`. On the remote machines, you'll need to deploy the Chef
scripts:

	./jfd deploy build massive-b.fwp-dyn.com
	scp ~/.jfdi/server.json vagrant@massive-b.fwp-dyn.com:~/build/

Then login and then run:

	sudo /home/vagrant/usr/bin/jfd setup-server


Updating the Development Base Box
---------------------------------
From time to time we need to rebuild our base boxes to reflect the latest
software and OS updates. To do that, check out the docs available in
`docs/create-devbox.md`.


Updating the Remote System
--------------------------
Of course, just updating the development machine is not enough, we need to keep
the production machines up to date as well. To do that, check out the docs available in
`docs/create-remotebox.md`.


Copyright and License
---------------------
Copyright: (c) 2013 by The Fireworks Project (http://www.fireworksproject.com)

Unless otherwise indicated, all source code is licensed under the MIT license. See LICENSE for details.
