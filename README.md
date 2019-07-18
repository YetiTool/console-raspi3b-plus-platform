For the RasPi3B+ and 7" touchscreen, this build installs:
* Raspbian Stretch Lite OS,
* [Kivy](https://kivy.org/#home) (to provides UI framework) - note release version we're testing in the build step
* EasyCut (a [YetiTool](https://yetitool.com) app to run SmartBench's console)
* Also, autostart and silent boot steps.

# Resources

## HW resources
* RasPi 3B+ and power supply
* Official 7" RasPi touchscreen, connected (steps below are **not** for HDMI output)
* USB keyboard (for build only)
* microSD card (4Gb min)
* microSD card reader

## SW resources
* Raspbian Stretch Lite, [torrent here](https://downloads.raspberrypi.org/raspbian_lite_latest.torrent)
  * June 2018 image
  * Release date: 2018-06-27
  * SHA-256:3271b244734286d99aeba8fa043b6634cad488d211583814a2018fc14fdca313

# Build steps

## Burn Raspbian image onto microSD card
* Format microSD card
  * For MS Windows machine:
  * App: SDFormatter [for MS Windows](https://www.sdcard.org/downloads/formatter_4/)
    * Format: FAT
    * Settings: Quick format, Size adjustment ON
    * (Formatting notes [here](https://www.raspberrypi.org/documentation/installation/noobs.md))
* Burn Raspbain image to microSD card
  * App: Etcher [for MS Windows](https://etcher.io/)
  * Burn image on to SD card

## Bootstrapping
Initial bootstrapping for Ansible.
```
sudo apt update
sudo apt -y dist-upgrade
sudo apt -y install ansible python-apt screen
cd && git clone https://github.com/YetiTool/console-raspi3b-plus-platform.git
cd console-raspi3b-plus-platform/ansible
ansible-playbook -v -i hosts -l localhost init.yaml
```

Note: An Ansible service will be added to `systemctl`, so for future Ansible runs, or for integration into EasyCut:
```
sudo systemctl restart ansible.service
```

## Pi Config
You will need to connect a keyboard to the RasPi, and use the screen to follow these steps.
* Login:
  * user: pi
  * pass: raspberry
* Rotate touchscreen
  * `sudo nano /boot/config.txt`
    * ... add new line
    * `lcd_rotate=2`
  * `sudo reboot`
* Config Pi
  * `sudo raspi-config`
    * <1> ...change user password for pi user (recommended)
    * <2> ... set network
      * GB Britain (UK)
    * <3> boot options
      * B2 Wait for Network at Boot -> No
    * <3> boot options
      * B1 Desktop / CLI
      * B2 Console Autologin
    * <5> Interfacing options - assuming you want to SSH into Pi for further build steps (recommended)
      * P2 SSH -> Yes
      * P6 Serial (if using UART comms to communicate with Arduino chip)
        * Enable login shell accessible over serial -> No
        * Enable Serial port hardware -> Yes
    * <7> Advanced Options
      * A3 Memory Split -> 128MB
    * Exit, reboot
* Gather the Pi's IP address
  * Find your Pi's IP with `sudo ifconfig` (under "wlan0: ...", "inet ..." e.g. 192.168.0.27

## SSH connection
You can now securely connect to your RasPi via SSH.

We like to use the PuTTY SSH client, and FileZilla for SSH file transfer.

* PuTTY can be obtained [here](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html).

* FileZilla can be found [here](https://filezilla-project.org/download.php?type=client).


## Kivy Install
Kivy is the UI framework for SmartBench
It is installed via the main 'init.yaml' bootstrapping Ansible playbook and can be run individually using:
* `cd ~/console-raspi3b-plus-platform/ansible && ansible-playbook -v -i hosts -l localhost init.yaml -t kivy`
* Run time: ~7 hours

## EasyCut Install
EasyCut is YetiTool's UI for SmartBench
It is installed via the main 'init.yaml' bootstrapping Ansible playbook and can be run individually using:
* `cd ~/console-raspi3b-plus-platform/ansible && ansible-playbook -v -i hosts -l localhost init.yaml -t easycut`
* Run time: ~5 mins

## Autostart Config
Autostart configures the easycut and ansible services, splashscreen and silent boot options.
It is installed via the main 'init.yaml' bootstrapping Ansible playbook and can be run individually using:
* `cd ~/console-raspi3b-plus-platform/ansible && ansible-playbook -v -i hosts -l localhost init.yaml -t autostart`
* Run time: ~10 mins

# You're done!
Try a 'sudo reboot' - hope you didn't get any typo's :-)

# Make image of result
UNTESTED:
* [Shrink](https://github.com/qrti/shrink)
  * From another Linux machine (if using Windows, download Ubuntu from the store and [setup the terminal](https://stackoverflow.com/questions/38832230/copy-paste-in-bash-on-ubuntu-on-windows))
  * `git clone https://github.com/qrti/shrink.git`
  * `sudo apt-get install -y gparted`
  * `sudo apt-get install -y pv`

# Useful Links
* https://scribles.net/customizing-boot-up-screen-on-raspberry-pi/
* https://www.madebymany.com/stories/fun-with-systemd-running-a-splash-screen-shutting-down-screens-and-an-iot-product-service-with-python-on-raspberry-pi
