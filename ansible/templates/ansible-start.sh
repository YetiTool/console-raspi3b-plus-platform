#!/bin/bash

# CPU Serial
PI_SERIAL=`cat /proc/cpuinfo | grep Serial | awk ' {print $3}' | sed 's/^0*//'"`

ANSIBLE_CONFIG="/home/pi/console-raspi3b-plus-platform/ansible/ansible.cfg"
ANSIBLE_INVENTORY="/home/pi/console-raspi3b-plus-platform/ansible/hosts"
ANSIBLE_LIBRARY="/home/pi/console-raspi3b-plus-platform/ansible/"

/usr/bin/ansible-playbook \
	    -e "serial=$PI_SERIAL" \
	    -v \
	    -l localhost \
	    /home/pi/console-raspi3b-plus-platform/ansible/init.yaml

