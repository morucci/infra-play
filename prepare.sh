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
