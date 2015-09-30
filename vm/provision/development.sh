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
  htop

sudo apt-get autoremove --assume-yes
sudo apt-get autoclean --assume-yes

echo "************************************************************"
echo "Adding PPA repositories"
echo "************************************************************"
sudo apt-get install python-software-properties

# Oracle Java is required for Elastisearch
sudo add-apt-repository --yes ppa:webupd8team/java

# MongoDB
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo "deb http://repo.mongodb.org/apt/ubuntu "$(lsb_release -sc)"/mongodb-org/3.0 multiverse" | \
  sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

sudo apt-get update

echo "************************************************************"
echo "Installing Java"
echo "************************************************************"
debconf shared/accepted-oracle-license-v1-1 select true | \
  sudo debconf-set-selections
debconf shared/accepted-oracle-license-v1-1 seen true | \
  sudo debconf-set-selections
sudo apt-get install --assume-yes oracle-java8-installer

echo "************************************************************"
echo "Installing Node.js"
echo "************************************************************"
wget -q -O - https://raw.githubusercontent.com/creationix/nvm/v0.27.1/install.sh | bash
. /home/vagrant/.nvm/nvm.sh
nvm install "$node_version"

echo "************************************************************"
echo "Installing Elastisearch"
echo "************************************************************"
wget "https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$elasticsearch_version.deb"
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
echo "Installing .bashrc"
echo "************************************************************"
cp /vagrant/vm/configs/development/.bashrc /home/vagrant/.bashrc
sudo chown vagrant:vagrant /home/vagrant/.bashrc
