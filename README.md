# Linux Microdia Keyboard Chipset Driver #

For Chipset `0x0c45`:`0x7603`
The kernel reports the chipset as `SONiX USB Keyboard`

> Fixed for Spanish and Portuguese keybords
> NOTE: Makefile and instructions are only tested on Debian and Arch, however they are known to work on Ubuntu, Arch, Fedora, and Manjaro.

Reports suggest it supports the following keyboards as well:

 * SL-6432-BK - Speedlink LUCIDIS Comfort Illuminated Keyboard
 * COUGAR 200K Scissor Gaming Keyboard
 * GAMDIAS USB Keyboard (unspecified model but will report as Microdia chipset)
 * Avazz USB Keyboard (unspecified model but will report as Microdia chipset)
 * Perixx P1800
 * Modecom MC800-Volcano 
 * Serioux Radiant KBL-003
 * SEISA DN-V370 multimedia keyboard
 * Coolbox Quasar

# Installation ##
## DKMS ##

    # debian-based:
    sudo apt install git build-essential linux-headers-$(uname -r) dkms
    
    # fedora:
    sudo dnf install kernel-devel kernel-headers
    sudo dnf groupinstall "Development Tools" "Development Libraries"
    
    git clone https://github.com/danielchc/aziokbd.git
    cd aziokbd
    sudo ./install.sh dkms
    
## Manual Install ##

    sudo apt install git build-essential linux-headers-$(uname -r) dkms
    git clone https://github.com/danielchc/aziokbd.git
    cd aziokbd
    sudo ./install.sh

# Blacklisting #

**NOTE: install.sh attempts to blacklist the driver for you. You shouldn't need to do anything manually. These instructions are to explain the process, in the event something goes wrong.**

You need to blacklist the device from the generic USB hid driver in order for the aziokbd driver to control it.


## Compiled into Kernel ##
If the generic USB hid driver is compiled into the kernel, then the driver is not loaded as a module and setting the option via `modprobe` will not work. In this case you must pass the option to the driver via the grub boot loader.

Create a new file in `/etc/default/grub.d/`. For example, you might call it `aziokbd.conf`. (If your grub package doesn't have this directory, just modify the generic `/etc/default/grub` configuration file):

    GRUB_CMDLINE_LINUX_DEFAULT='usbhid.quirks=0x0c45:0x7603:0x4'

Then run `sudo update-grub` and reboot.

Again, if you find that `0x4` doesn't work, try `0x7`.

Based on Colin Svingen [aziokbd](https://bitbucket.org/Swoogan/aziokbd/src)
