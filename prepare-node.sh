#!/bin/bash

set -x

puppetmaster=puppetmaster.test.localdomain
fqdn=$(hostname -f)

# Maybe to migrate in edeploy-lxc
umount /sys/fs/selinux
chmod og+w /dev/null

# Normal preparation
echo "nameserver 8.8.8.8" | tee /etc/resolv.conf
aptitude update
#DEBIAN_FRONTEND=noninteractive aptitude -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" safe-upgrade
aptitude install -y git vim puppet

curl -o get-pip.py https://bootstrap.pypa.io/get-pip.py
python get-pip.py
pip install -U setuptools

cat << EOF > /etc/puppet/puppet.conf
[main]
logdir=/var/log/puppet
vardir=/var/lib/puppet
ssldir=/var/lib/puppet/ssl
rundir=/var/run/puppet
factpath=\$vardir/lib/facter
templatedir=\$confdir/templates
server=$puppetmaster
certname=$fqdn
EOF

puppet agent --test || true
