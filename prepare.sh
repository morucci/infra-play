#!/bin/bash

set -x

repo=https://github.com/morucci/system-config.git
branche=c1

# Maybe to migrate in edeploy-lxc
sudo umount /sys/fs/selinux
sudo chmod og+w /dev/null

# Normal preparation
echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
sudo aptitude update && sudo aptitude -y safe-upgrade
sudo aptitude install -y git vim

# Clone system config and install puppet
git clone $repo
cd system-config
git checkout $branche
./install_puppet.sh
cd ..

# Prepare hieradata
ln -s /etc/hiera.yaml /etc/puppet/hiera.yaml
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=FR/O=Somewhere/CN=test" -keyout /tmp/fakekey.key -out /tmp/fakecert.pem
rm /tmp/fakesshkey
ssh-keygen -P "" -f /tmp/fakesshkey

# Will create /var/lib/hiera/defaults.yaml
./sub.py
