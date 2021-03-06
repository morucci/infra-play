#!/bin/bash

set -x

repo=https://github.com/openstack-infra/system-config.git

# Maybe to migrate in edeploy-lxc
umount /sys/fs/selinux
chmod og+w /dev/null

# Normal preparation
echo "nameserver 8.8.8.8" | tee /etc/resolv.conf
aptitude update || exit -1
#DEBIAN_FRONTEND=noninteractive aptitude -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" safe-upgrade
aptitude install -y git vim

# Clone system config and install puppet
git clone $repo /opt/system-config/production
cd /opt/system-config/production/
./install_puppet.sh
./install_modules.sh
cd -

# Fix puppet-ssh template
sed -i 's#.*PermitRootLogin.*#PermitRootLogin yes#g' /etc/puppet/modules/ssh/templates/sshd_config.erb
sed -i '/^Match host/d' /etc/puppet/modules/ssh/templates/sshd_config.erb
aptitude install -y puppetmaster-passenger hiera hiera-puppet

cat << 'EOF' > /root/install-puppetmaster.pp
class { 'openstack_project::puppetmaster':
    # We overwrite the key after the run of that manifest
    root_rsa_key => 'XXX',
    puppetdb => false,
    puppetmaster_server => 'puppetmaster.test.localdomain',
}
EOF

puppet apply --modulepath='/opt/system-config/production/modules:/etc/puppet/modules' /root/install-puppetmaster.pp

mkdir -p /etc/puppet/hieradata/production
