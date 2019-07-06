#!/bin/bash

# Create temporary place to store state before sending the e-mail
mkdir /tmp/state

# Copy last Ansible logs to a file
sudo journalctl \
    -u ansible.service \
    > /tmp/state/ansible.service

# Copy the __public__ key for Support
cp ~/.ssh/id_rsa.pub /tmp/state/

# Create the archive of the state directory
tar -czf /tmp/$HOSTNAME-state.tar.gz /tmp/state

# E-mail the state to support
echo "Smart bench state" \
    | mail \
    -s "State from: $HOSTNAME" \
    platform.build@yetitool.com \
    -A /tmp/$HOSTNAME-state.tar.gz

# Cleanup
rm /tmp/$HOSTNAME-state.tar.gz
rm -rf /tmp/state
