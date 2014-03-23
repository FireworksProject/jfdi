# Applications
The JFDI "massive" server is a multi-tenant host serving many different
applications.


## Configuring an App for Development
First, you'll need to setup a softlink from your app to the `webapps/` directory
in the jfdi repository. So, from the `webapps/` directory, run something like this:

	ln -s ../../myapp_com myapp_com

Next, the app will need to be added to the `Vagrantfile` in several places. The
first is an entry to share the folder for your app on the devbox VM:

	config.vm.synced_folder "./webapps/myapp_com", "/webapps/myapp_com"

The next entry in the Vagrant file is to add your app to the Chef run list:

	chef.add_recipe "myapp_com"

The next thing you'll need to do is create a Chef cookbook in the `cookbooks/`
directory of this repository and make sure the name matches the name you just
used in `chef.add_recipe`.

Lastly, you need to add the Chef recipe and any authentication keys to
`~/.jfdi/server.json`.


## Application Specific Instructions

### HTMLandCSSTutorial.com
The SSL certificate htmlandcsstutorial.crt and htmlandcsstutorial.key need to
be copied to the server in `/etc/ssl/`.

To deploy the app:

	./jfd deploy tutorial_com <hostname>

where `<hostname>` is massive-b.fwp-dyn.com or massive.fwp-dyn.com

To start the app:

	cd /webapps/htmlandcsstutorial_com/
	bin/start

* Logs will go to /var/log/htmlandcsstutorial_com/out.log and err.log.
* Data is stored in /var/htmlandcsstutorial_com/.

### Pinfinity.co
The Pinfinity app consists of 2 apps 1) a Statmic PHP app, and 2) a Node.js app
for interactivity.

The Statamic app should already be running on the development machine via Nginx
and FPM-PHP.

Deploy the Statamic app with

	./jfd deploy pinfinity_co <hostname>

and the Node.js app with

	./jfd deploy pinfinity_hub <hostname>

where `<hostname>` is massive-b.fwp-dyn.com or massive.fwp-dyn.com

To start the Node.js app:

	cd /webapps/pinfinity_hub/
	bin/restart

* Pinfinity Node.js logs will go to /var/log/pinfinity_hub/out.log and err.log.
* Data is sent straight to Google Docs.

