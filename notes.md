Some draft note

- Install a fedora 21. Upgrade. Reboot.

- Setup the swap :
  sudo dd if=/dev/zero of=/srv/swap count=4000 bs=1M
  sudo mkswap /srv/swap
  sudo chmod 0600 /srv/swap
  sudo swapon /srv/swap

- Configure the VM to run container with edeploy LXC. Install deps. Fedora 21 supports overlayfs

- Setup a local key pair

- Fetch a ubuntu 14.04 using edeploy-lxc/create-base.sh
  ./create_base.sh http://cloud-images.ubuntu.com/releases/14.04/release/ubuntu-14.04-server-cloudimg-amd64-disk1.img /var/lib/debootstrap/ubuntu14.04
- Make internet available to containers: sudo ../edeploy-lxc/firewall.sh

- Be sure null.cloudinit is fetchable by edeploylxc according to config.yaml

- Use config.yaml to spawn some containers
  sudo ./../edeploy-lxc/edeploy-lxc --config config.yaml start 

- ./prepare-hieradata.sh
- for i in 192.168.134.{45..47}; do ssh root@$i mkdir /var/lib/hiera; scp /tmp/defaults.yaml root@$i:/var/lib/hiera/; scp prepare.sh root@$i:.; done
- for i in 192.168.134.{45..47}; do ssh root@$i ./prepare.sh; bash -c "./system-config/install_modules.sh"; done

- inside each containers
- Fix /etc/puppet/modules/ssh/templates/sshd_config with PermetRootLogin to yes
- cd ../system-config
# The manifest is modified to install only mysqld/gerrit/jenkins master according to hostname
- /usr/bin/puppet apply --modulepath=/etc/puppet/modules:modules manifests/site.pp

- curl -k https://jenkins.test.localdomain

- On your container host:
  sudo socat TCP4-LISTEN:80,fork TCP4:192.168.134.45:80
  sudo socat TCP4-LISTEN:443,fork TCP4:192.168.134.45:443
Then you can access the jenkins instance from your laptop by accessing https://node1.test.locadomain
Do not miss to update /etc/hosts on your laptop.

In this example with use system-config and project-config forked in my github account.
So it is better to fork your own too.
