# infra-play

## Purpose

Some draft notes to setup a CI based on openstack-infra puppet manifests.

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
$ sudo yum install git debootstrap python-yaml lxc openssl ansible socat
```

#### Setup a local key pair:
```
$ ssh-keygen -P "" -f ~/.ssh/id_rsa
```

#### Fetch a ubuntu 14.04 using edeploy-lxc/create-base.sh
```
$ cd edeploy-lxc
$ ./create_base.sh http://cloud-images.ubuntu.com/releases/14.04/release/ubuntu-14.04-server-cloudimg-amd64-disk1.img /var/lib/debootstrap/ubuntu14.04
```

##### Make internet available to containers:
```
$ sudo ./firewall.sh
```

##### Be sure null.cloudinit is fetchable by edeploylxc according to config.yaml
```
$ touch /home/fedora/null.cloudinit
```

### Start containers

#### Use config.yaml to spawn some containers:
```
$ cd infra-play
$ sudo ../edeploy-lxc/edeploy-lxc --config config.yaml start
$ ps axf # Will show some LXC containers up
```

#### Prepare fake data in hiera for the deployment:
```
$ ./prepare-hieradata.sh # A /tmp/defaults.yaml will be created and consume by Ansible below
```


#### Configure the puppetmaster node:
Running puppetmaster.yaml playbook will setup the puppetmaster node by installing puppet
server, system-config/openstack_project puppet module, setup hiera with the key/values
created above. 

```
$ export ANSIBLE_HOST_KEY_CHECKING=False
$ ansible-playbook -i inventory.yaml puppetmaster.yaml
```

#### Configure other nodes:

Will prepare each other nodes. Then you will be able to use puppet agent to deploy the
relevant components on those nodes.
```
$ export ANSIBLE_HOST_KEY_CHECKING=False
$ ansible-playbook -i inventory.yaml nodes.yaml
```

### Apply some patches before:

Before running the agent on nodes be sure the system-config clone is as you want. Currently I have a some patches upstream
waiting for validation I apply. Also I deactivate the cron that run run_all.sh every 15 minutes (it wipe the clone and reset it
to master).

To do that, just connect as root on the puppetmaster node and run apply-in-review-patches.sh.
You may have some manual merges to do ... :/

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
