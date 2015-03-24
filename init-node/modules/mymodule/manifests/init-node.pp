class mymodule::init-node {
    file {'/dev/null':
        mode => '666',
    }
    exec {'disable-selinux':
        onlyif => ["grep '/sys/fs/selinux' /proc/mounts"],
        provider => "shell",
        command => "umount /sys/fs/selinux",
    }
    file {'hiera':
        path => "/etc/puppet/hiera.yaml",
        ensure => "link",
        target => "/etc/hiera.yaml",
    }
    file {'hieradata':
        path => "/var/lib/hiera/defaults.yaml",
        source => 'puppet:///modules/mymodule/defaults.yaml',
    }
}
