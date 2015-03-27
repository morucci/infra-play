#!/bin/bash

set -x

repo=https://github.com/morucci/system-config.git
branche=c1

# Maybe to migrate in edeploy-lxc
umount /sys/fs/selinux
chmod og+w /dev/null

# Normal preparation
echo "nameserver 8.8.8.8" | tee /etc/resolv.conf
aptitude update && DEBIAN_FRONTEND=noninteractive aptitude -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" safe-upgrade
aptitude install -y git vim

# Clone system config and install puppet
git clone $repo
cd system-config
git checkout $branche
./install_puppet.sh
cd ..

# Prepare hieradata
ln -s /etc/hiera.yaml /etc/puppet/hiera.yaml
