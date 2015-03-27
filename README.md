# infra-play

## Purpose

Some draft notes to setup a CI based on openstack-infra puppet manifests
This process use https://github.com/morucci/system-config/tree/c1. This branch
only add changes to manifests/site.pp for now.

## How to use

### Prepare the host

Install a fedora 21. Upgrade. Reboot.

#### Setup the swap:
```
$ sudo dd if=/dev/zero of=/srv/swap count=4000 bs=1M
$ sudo mkswap /srv/swap
$ sudo chmod 0600 /srv/swap
$ sudo swapon /srv/swap
```

#### Configure the VM to run containers with edeploy LXC. Install deps. (Fedora 21 supports overlayfs).
```
$ git clone https://github.com/enovance/edeploy-lxc.git
```

#### Setup a local key pair:
```
$ ssh-keygen -P ""
```

#### Fetch a ubuntu 14.04 using edeploy-lxc/create-base.sh
```
$ cd edeploy-lxc
$ ./create_base.sh http://cloud-images.ubuntu.com/releases/14.04/release/ubuntu-14.04-server-cloudimg-amd64-disk1.img /var/lib/debootstrap/ubuntu14.04
```

##### Make internet available to containers:
```
$ sudo firewall.sh
```

##### Be sure null.cloudinit is fetchable by edeploylxc according to config.yaml
```
$ cp null.cloudinit /home/fedora/
```

### Start containers

#### Use config.yaml to spawn some containers:
```
$ sudo ./edeploy-lxc --config config.yaml start
$ ps axf # Will show some LXC containers up
```

#### Prepare fake data in hiera for the deployment:
```
$ cd infra-play
$ ./prepare-hieradata.sh
$ for i in 192.168.134.{45..47}; do ssh root@$i mkdir /var/lib/hiera; scp /tmp/defaults.yaml root@$i:/var/lib/hiera/; scp prepare.sh root@$i:.; done
$ for i in 192.168.134.{45..47}; do ssh root@$i ./prepare.sh; bash -c "~/system-config/install_modules.sh"; done
```

#### Allow login as root on all containers:
```
$ for i in 192.168.134.{45..47}; do ssh root@$i "sed -i 's#.*PermitRootLogin.*#PermitRootLogin yes#g' /etc/puppet/modules/ssh/templates/sshd_config.erb"
; done
```

### Inside each containers:
- The manifest is modified to install only mysqld/gerrit/jenkins master according to hostname
```
$ cd ../system-config
$ sudo /usr/bin/puppet apply --modulepath=/etc/puppet/modules:modules manifests/site.pp
```

### Tips

On your host:
```
$ sudo socat TCP4-LISTEN:80,fork TCP4:192.168.134.45:80
$ sudo socat TCP4-LISTEN:443,fork TCP4:192.168.134.45:443
```

Then you can access the jenkins instance from your laptop by accessing https://jenkins.test.locadomain
Do not miss to update /etc/hosts on your laptop.

In this example with use system-config and project-config forked in my github account.
So it is better to fork your own too.
