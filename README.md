JFDI
====
Just Fucking Do It.

This is the organized mess of technical debt we use to run our infrastructure.
It consists of devops code as well as some general system administration stuff.
You should find just about anything you need for setting up servers and running
our applications here.

The idea is that this repository will be added as a Git Submodule to our
application code repositories; like corkboard.git/, for example.

The main use case is to provide a place for utility scripts used to set up and
tear down virtual machines, both for local development and production
deployment. We do this using Vagrant and VirtualBox for local development,
and the Amazon Web Services API for production.

VirtualBox is a virtual machine hosting tool, and Vagrant is a virtual machine
automation tool which makes working with VirtualBox a breeze.

## Installation
First you'll need to install [VirtualBox](https://www.virtualbox.org/)
by following their
[download instructions](https://www.virtualbox.org/wiki/Downloads).

Then [install Vagrant](http://docs.vagrantup.com/v1/docs/getting-started/index.html)
from their [downloads page](http://downloads.vagrantup.com/).

__GOTCHA (Ubuntu):__ Vagrant installs itself in `/opt/vagrant/`, which is probably
not on your PATH. This is a problem, because you'll need to run
`/opt/vagrant/bin/vagrant` instead of `vagrant` whenever you want to use it.
You can fix this pretty simply by creating a sym link to a directory which is
on your path like this:

	sudo ln -s /opt/vagrant/bin/vagrant /usr/local/bin/vagrant

Copyright and License
---------------------
Copyright: (c) 2013 by The Fireworks Project (http://www.fireworksproject.com)

Unless otherwise indicated, all source code is licensed under the MIT license. See LICENSE for details.
