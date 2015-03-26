#!/usr/bin/env python

from string import Template

dest="/tmp/defaults.yaml"

fakecert = "".join([" %s" % l for l in file('/tmp/fakecert.pem').readlines()]).strip()
fakekey = "".join([" %s" % l for l in file('/tmp/fakekey.key').readlines()]).strip()
fakersasshkey = "".join([" %s" % l for l in file('/tmp/fakersasshkey').readlines()]).strip()
fakersasshkeypub = "".join([" %s" % l for l in file('/tmp/fakersasshkey.pub').readlines()]).strip()
fakedsasshkey = "".join([" %s" % l for l in file('/tmp/fakedsasshkey').readlines()]).strip()
fakedsasshkeypub = "".join([" %s" % l for l in file('/tmp/fakedsasshkey.pub').readlines()]).strip()
fakepass = "wxcvbn"

a = {'fakecert': fakecert,
     'fakekey': fakekey,
     'fakersasshkey': fakersasshkey,
     'fakersasshkeypub': fakersasshkeypub,
     'fakedsasshkey': fakedsasshkey,
     'fakedsasshkeypub': fakedsasshkeypub,
     'fakepass': fakepass}

s = Template(file('defaults.yaml.tmpl').read())
content = s.substitute(a)

file(dest, 'w').write(content)
