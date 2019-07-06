#!/bin/bash

# Define the user
BENCH=`cat /proc/cpuinfo | grep Serial | awk ' {print $3}' | sed 's/^0*//'`

# Create temporary place to store logs before sending the SCP'ing
mkdir /tmp/log

# Copy last Ansible logs to a file
sudo journalctl \
    -u ansible.service \
    > /tmp/log/ansible.log

sudo journalctl \
    -u easycut.service \
    > /tmp/log/easycut.log

# Create the archive of the log directory
tar -czvf /tmp/$HOSTNAME-log.tar.gz /tmp/log

# SCP logs to support
scp /tmp/$HOSTNAME-log.tar.gz $BENCH@support.yetitool.com:~/

# Cleanup
rm /tmp/$HOSTNAME-log.tar.gz
rm -rf /tmp/log
