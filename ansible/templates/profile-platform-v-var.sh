# shellcheck shell=sh

export SB_PLATFORM_VERSION=$(cd /home/pi/console-raspi3b-plus-platform && git describe --always && cd)
