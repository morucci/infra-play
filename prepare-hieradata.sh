#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 -subj "/C=FR/O=Somewhere/CN=test" -keyout /tmp/fakekey.key -out /tmp/fakecert.pem
rm /tmp/fakesshkey
ssh-keygen -P "" -f /tmp/fakesshkey

# Will create /var/lib/hiera/defaults.yaml
./sub.py
