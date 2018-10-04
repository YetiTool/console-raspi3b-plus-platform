Build steps to install Kivy onto a PipaOS 6.0 img for RasPi 3B+

**FAILS!!!!!!!**
On loading a Kivy program, get this error: `[CRITICAL] [App ] Unable to get a Window, abort.`

# Kivy Install on PipaOS 6-0 release

Build steps mostly taken from Kivy [site](https://kivy.org/doc/stable/installation/installation-rpi.html), with tweaks
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
* filesystem expansion
  * 'sudo raspi-config'
  * Select Advanced > Expand filesystem
  * Finish
* pip install
  * `sudo apt install -y python-pip`
* Expand tmp folder to enable pip to function
  * `sudo nano /etc/fstab`
  * change `/tmp` line (last line) to:
    * `none            /tmp            tmpfs   size=512m,mode=777       0       0`
  * `sudo reboot`
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
