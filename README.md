For the RasPi3B+ and 7" touchscreen, this build installs:
* Raspbian Stretch Lite OS, 
* [Kivy](https://kivy.org/#home) (to provides UI framework)
* EasyCut (a [YetiTool](https://yetitool.com) app to run SmartBench's console)
* Also, autostart and silent boot steps. 

# Resources

## HW resources
* RasPi 3B+ and power supply
* Official 7" RasPi touchscreen, connected
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

## Pi Config
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
    * Exit, reboot

## SSH connection
You can now securely connect via SSH.
Find your Pi's IP with `sudo ifconfig`.

## Kivy Install
Build steps mostly taken from Kivy [site](https://kivy.org/doc/stable/installation/installation-rpi.html), with added `pip` install step.
* Kivy dependencies
  * `sudo apt-get update`
  * ```
    sudo apt-get install -y libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libsdl2-ttf-dev \
       pkg-config libgl1-mesa-dev libgles2-mesa-dev \
       python-setuptools libgstreamer1.0-dev git-core \
       gstreamer1.0-plugins-{bad,base,good,ugly} \
       gstreamer1.0-{omx,alsa} python-dev libmtdev-dev \
       xclip xsel
    ```
* pip install
  * `sudo apt install -y python-pip`
* cython install (long time!)
  * `sudo pip install -U Cython==0.28.2`
* kivy (long install!)
  * `sudo pip install git+https://github.com/kivy/kivy.git@1.10.1`
* config touchscreen to accept input
  * `sudo nano ~/.kivy/config.ini`
  * ... under [input] add
  * ```
    mouse = mouse
    mtdev_%(name)s = probesysfs,provider=mtdev
    hid_%(name)s = probesysfs,provider=hidinput
    ```
* Test: the showcase program should now run.
  * `python /usr/local/share//kivy-examples/demo/showcase/main.py`

# EasyCut installation
EasyCut is YetiTool's UI for SmartBench
* Dependencies
  * ```
    sudo apt-get -y install python-serial
    sudo mkdir /media/usb
    sudo mkdir ~/router_ftp/
    ```
* Clone from GitHub, with EITHER:
  * Without SSH keys: 
    * `cd && git clone https://github.com/YetiTool/easycut-smartbench.git`
  * Or, with [SSH key setup:](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)
    * `cd && git clone git@github.com:Neex101/asmcnc_skava_ui.git` <git address found under 'Clone or download' button, selecting SSH option> (`cd &&` means go home, and if that works, then do next part)

# Autostart
To enable the pi to autostart EasyCut app on booting
* create bash script to run app
  * `touch /home/pi/starteasycut.sh`
  * `sudo nano /home/pi/starteasycut.sh`
    *  ... add
       ```
       #!/bin/bash
       echo "start easycut"
       cd /home/pi/easycut-smartbench/src/
       exec python main.py
       ```
  * make sure script is executable:
    * `sudo chmod +x /home/pi/starteasycut.sh`
  * test
    * `bash starteasycut.sh`
* create a file for the service, edit and enable.
  * `sudo touch /lib/systemd/system/easycut.service`
  * `sudo nano /lib/systemd/system/easycut.service`
  * ...add (note "Type" can be 'simple' to speed up, but 'idle' will wait to avoid interleaved shelloutput)
    ```
    [Unit]
    Description=run easycut service and redirect stderr and stdout to a log file
    After=multi-user.target

    [Service]
    Type=idle 
    ExecStart=/home/pi/starteasycut.sh > /home/pi/easycut.log 2>&1
    User=pi

    [Install]
    WantedBy=multi-user.target
    ```
  * ...to check file
    * `sudo systemctl cat easycut.service`

  * `sudo systemctl enable easycut.service`
  * `sudo systemctl start easycut.service`
  * `sudo reboot`
  * ...check status of service if not started
    * `sudo systemctl status easycut`
    * `sudo journalctl _SYSTEMD_UNIT=easycut.service`

# Splashscreen
```
sudo apt-get install plymouth plymouth-themes
sudo plymouth-set-default-theme -l
sudo plymouth-set-default-theme -R spinfinity  
```
...where spinfinity can be swapped to <details, fade-in, glow, script, solar, spinfinity, spinner, text, tribar>
Replace `/usr/share/plymouth/debian-logo.png` with new image

# Silent boot procedure
Note!! Last step, since after doing this, you'll loose the console on tty after boot. You can swap tty's (terminals) though (CTRL+ALT+F<1-6>) to see one.
* remove rainbow square
  * `sudo nano /boot/config.txt`
  * add `disable_splash=1`
* remove verbose logging at startup
  * `sudo nano /boot/cmdline.txt`
  * Then, replace `console=tty1` with `console=tty3`. This redirects boot messages to tty3.
  * add below at the end of the line
    * `splash quiet plymouth.ignore-serial-consoles logo.nologo vt.global_cursor_default=0`
* change the auto login in systemd (Hides the login message when auto-login happens)
  * `sudo nano /etc/systemd/system/autologin\@.service`
  * Change your auto login ExecStart from:
    * from `ExecStart=-/sbin/agetty --autologin pi --noclear %I $TERM`
    * to `ExecStart=-/sbin/agetty --skip-login --noclear --noissue --login-options "-f pi" %I $TERM`
    * Make sure to change 'pi' to the username you use!
* hush login
  * `touch ~/.hushlogin`
* Suppress Kernel Messages
  * `sudo nano /etc/rc.local`
    * ...add this before 'exit 0':
      * ```
        #Suppress Kernel Messages
        dmesg --console-off
        ```
* Suppress login prompt on console (tty1)
  * `sudo systemctl disable getty@tty1.service`


# Make image of result
* [Shrink](https://github.com/qrti/shrink)
  * From another Linux machine (if using Windows, download Ubuntu from the store and [setup the terminal](https://stackoverflow.com/questions/38832230/copy-paste-in-bash-on-ubuntu-on-windows))
  * `git clone https://github.com/qrti/shrink.git`
  * `sudo apt-get install -y gparted`
  * `sudo apt-get install -y pv`


# Useful Links
* https://scribles.net/customizing-boot-up-screen-on-raspberry-pi/
* https://www.madebymany.com/stories/fun-with-systemd-running-a-splash-screen-shutting-down-screens-and-an-iot-product-service-with-python-on-raspberry-pi
