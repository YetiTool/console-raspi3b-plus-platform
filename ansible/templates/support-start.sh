#!/bin/bash

# Collision prevention
RANDOM_PORT=$((1024 + RANDOM % 49151))
# CPU Serial
BENCH=`cat /proc/cpuinfo | grep Serial | awk ' {print $3}'`

/usr/bin/ssh \
    -R ${RANDOM_PORT}:localhost:22 ${BENCH}@support.yetitool.com \
    -i /home/pi/.ssh/id_rsa_${BENCH}\
    -o StrictHostKeyChecking=no \
    -T \
    -N
