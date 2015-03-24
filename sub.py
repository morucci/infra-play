#!/usr/bin/env python

from string import Template

dest="/var/lib/hiera/defaults.yaml"

fakecert = file('/tmp/fakecert.pem').read()
fakekey = file('/tmp/fakekey.key').read()
fakesshkey = file('/tmp/fakesshkey').read()
fakepass = "wxcvbn"

a = {'fakecert': fakecert,
     'fakekey': fakekey,
     'fakesshkey': fakesshkey,
     'fakepass': fakepass}

s = Template(file('defaults.yaml').read())
content = s.substitute(a)

file(dest, 'w').write(content)
