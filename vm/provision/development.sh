#!/usr/bin/env bash
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
echo "Installing Node.js"
echo "************************************************************"
curl --silent -o- https://raw.githubusercontent.com/creationix/nvm/v0.27.1/install.sh | bash
source "$HOME/.bashrc"
nvm install "0.12.7"

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
