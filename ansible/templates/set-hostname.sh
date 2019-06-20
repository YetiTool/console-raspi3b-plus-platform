#!/bin/bash

BENCH=`cat /proc/cpuinfo | grep Serial | awk ' {print $3}' | sed 's/^0*//'`

hostname ${BENCH}.yetitool.com
echo ${BENCH}.yetitool.com > /etc/hostname
