#!/bin/bash

export ANSIBLE_CONFIG="/home/pi/console-raspi3b-plus-platform/ansible/ansible.cfg"
export ANSIBLE_INVENTORY="/home/pi/console-raspi3b-plus-platform/ansible/hosts"
export ANSIBLE_LIBRARY="/home/pi/console-raspi3b-plus-platform/ansible/"

# Ensure package lists are up to date
sudo apt-get update

sudo /usr/bin/ansible-galaxy \
	install \
	-r /home/pi/console-raspi3b-plus-platform/ansible/requirements.yml

/usr/bin/ansible-playbook \
	-v \
	-l localhost \
	/home/pi/console-raspi3b-plus-platform/ansible/init.yaml
