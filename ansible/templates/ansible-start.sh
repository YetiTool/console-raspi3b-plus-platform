#!/bin/bash

# CPU Serial == PI Serial
export PI_SERIAL=`cat /proc/cpuinfo | grep Serial | awk ' {print $3}' | sed 's/^0*//'`

export ANSIBLE_CONFIG="/home/pi/console-raspi3b-plus-platform/ansible/ansible.cfg"
export ANSIBLE_INVENTORY="/home/pi/console-raspi3b-plus-platform/ansible/hosts"
export ANSIBLE_LIBRARY="/home/pi/console-raspi3b-plus-platform/ansible/"

/usr/bin/ansible-playbook \
	    /home/pi/console-raspi3b-plus-platform/ansible/init.yaml \
	    -e "serial=$PI_SERIAL" \
	    -v
