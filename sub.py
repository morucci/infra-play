#!/usr/bin/env python

from string import Template

dest="/tmp/defaults.yaml"

fakecert = "".join([" %s" % l for l in file('/tmp/fakecert.pem').readlines()]).strip()
fakekey = "".join([" %s" % l for l in file('/tmp/fakekey.key').readlines()]).strip()
fakesshkey = "".join([" %s" % l for l in file('/tmp/fakesshkey').readlines()]).strip()
fakepass = "wxcvbn"

a = {'fakecert': fakecert,
     'fakekey': fakekey,
     'fakesshkey': fakesshkey,
     'fakepass': fakepass}

s = Template(file('defaults.yaml.tmpl').read())
content = s.substitute(a)

file(dest, 'w').write(content)
