Some draft note

- Install a fedora 21.

- Setup the swap :
  dd if=/dev/zero of=/srv/swap count=4000 bs=1M
  swapon /srv/swap

- And configure the VM to run container with edeploy LXC
- Setup a local key pair
- Fetch a ubuntu 14.04 using create-base.sh
  ./create_base.sh http://cloud-images.ubuntu.com/releases/14.04/release/ubuntu-14.04-server-cloudimg-amd64-disk1.img /var/lib/debootstrap/ubuntu14.04
- Use config.yaml to spawn some containers

- Fork system-config and project-config on your own github

- scp init-node into the containers. This is to fix some minor stuff on the container.
- apply the manifest with : puppet apply --debug --modulepath=modules manifests/site.pp

- inside the container
- git clone https://github.com/morucci/system-config.git
- cd system-config
- ./install-puupet.sh
- ./install-modules.sh
- /usr/bin/puppet apply --modulepath=/etc/puppet/modules:modules manifests/site.pp
