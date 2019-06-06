#!/bin/bash

# CPU Serial
BENCH=`cat /proc/cpuinfo | grep Serial | awk ' {print $3}' | sed 's/^0*//'`

/usr/bin/pkill -f ${BENCH}
