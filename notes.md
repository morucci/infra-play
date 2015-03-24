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

- scp init-node into the container. This is to fix some minor stuff on the container.
- scp -r init-node root@192.168.134.45:. 

- inside the container
- echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf
- sudo umount /sys/fs/selinux
- sudo aptitude update && sudo aptitude -y safe-upgrade
- sudo aptitude install git vim
- git clone https://github.com/morucci/system-config.git
- cd system-config && git checkout c1
- ./install-puppet.sh

- cd ../init-node
- apply the manifest with
- puppet apply --debug --modulepath=modules manifests/site.pp

- cd ../system-config
- ./install-modules.sh
- Fix /etc/puppet/modules/ssh/templates/sshd_config with PermetRootLogin to yes
# The manifest is modified to install only jenkins master
- /usr/bin/puppet apply --modulepath=/etc/puppet/modules:modules manifests/site.pp
- curl -k https://node1.test.localdomain

- On your container host:
  sudo socat TCP4-LISTEN:80,fork TCP4:192.168.134.45:80
  sudo socat TCP4-LISTEN:443,fork TCP4:192.168.134.45:443
Then you can access the jenkins instance from your laptop by accessing https://node1.test.locadomain
Do not miss to update /etc/hosts on your laptop.

In this example with use system-config and project-config forked in my github account.
So it is better to fork your own too.
