#!/usr/bin/env bash

# Node.js versions https://nodejs.org/dist/
node_version="0.12.7"

# Elastisearch versions https://www.elastic.co/downloads/elasticsearch
elasticsearch_version="1.7.2"

export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
locale-gen en_US.UTF-8
sudo dpkg-reconfigure locales

sudo apt-get update
# Prevent interactive menus during install
# http://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt
sudo DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade --assume-yes

sudo apt-get autoremove --assume-yes
sudo apt-get autoclean --assume-yes

sudo apt-get install --assume-yes \
  build-essential \
  libssl-dev \
  curl \
  wget \
  vim \
  tree \
  unzip \
  htop

sudo apt-get autoremove --assume-yes
sudo apt-get autoclean --assume-yes

echo "************************************************************"
echo "Adding PPA repositories"
echo "************************************************************"
sudo apt-get install python-software-properties

# MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | \
  sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

# PostgreSQL
echo "deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
wget -q -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Redis
sudo apt-add-repository -y ppa:chris-lea/redis-server

sudo apt-get update

echo "************************************************************"
echo "Installing Java"
echo "************************************************************"
sudo apt-get install --assume-yes default-jre

echo "************************************************************"
echo "Installing Redis"
echo "************************************************************"
sudo apt-get install --assume-yes redis-server

echo "************************************************************"
echo "Installing PostgreSQL"
echo "************************************************************"
sudo apt-get install --assume-yes \
  postgresql-9.3 \
  postgresql-client-9.3 \
  postgresql-contrib-9.3 \
  postgresql-common \
  postgresql-server-dev-9.3 \
  libpq-dev

echo "************************************************************"
echo "Installing Elastisearch"
echo "************************************************************"
wget -q "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$elasticsearch_version.deb"
sudo dpkg -i "elasticsearch-$elasticsearch_version.deb"
rm "elasticsearch-$elasticsearch_version.deb"
# To test it all worked:
# $ sudo /etc/init.d/elasticsearch start
# $ curl http://localhost:9200

echo "************************************************************"
echo "Installing MongoDB"
echo "************************************************************"
sudo apt-get install --assume-yes mongodb-org
# To test it all worked:
# $ service mongod status

echo "************************************************************"
echo "Cleaning up"
echo "************************************************************"
sudo apt-get autoremove --assume-yes
sudo apt-get autoclean --assume-yes

echo "************************************************************"
echo "Configure the PG User"
echo "************************************************************"
sudo -E -u postgres psql -c "alter user postgres with password 'postgres';"
sudo -E -u postgres psql -f /vagrant/vm/configs/development/create_pg_role.sql

# Change PG authentication to md5 instead of peer
echo "Postgres username: vagrant password: rootdev"
echo "local   all             postgres                                md5
local   all             all                                     md5
host    all             all             0.0.0.0/0               md5
host    all             all             ::1/128                 md5" \
 | sudo tee /etc/postgresql/9.3/main/pg_hba.conf

# Allow external connections to PG
echo "listen_addresses = '*'" | sudo tee -a /etc/postgresql/9.3/main/postgresql.conf

# Restart
sudo /etc/init.d/postgresql restart

echo "************************************************************"
echo "Installing .bashrc"
echo "************************************************************"
cp /vagrant/vm/configs/development/.bashrc /home/vagrant/.bashrc
sudo chown vagrant:vagrant /home/vagrant/.bashrc

echo "************************************************************"
echo "Install (Node Version Manager for Node.js)"
echo "************************************************************"
# We have to jump through some user management hoops to get this to work since
# this script is run as root.
# sudo su vagrant -c "wget -q -O - https://raw.githubusercontent.com/creationix/nvm/v0.27.1/install.sh | bash"
#
# Instead of doing that, install manually with:
# curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
