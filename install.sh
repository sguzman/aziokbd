#!/bin/bash

read -n 1 -p "Backslash fix (y/N)?" choice
echo

case "$choice" in 
  y|Y ) BKSL='BKSLFIX=y';;
  * ) BKSL='BKSLFIX=n';;
esac

if [[ $1 != 'dkms' ]]; then
    echo '## Making package ##'
    make ${BKSL}

    echo '## Installing package ##'
    make install
else
    echo '## Installing package with DKMS ##'
    sed -ie '/MAKE\[0\]/d' dkms.conf
    sed -ie "$ a\\MAKE\[0\]=\"make ${BKSL}\"" dkms.conf
    make ${BKSL} dkms
fi

quirk='0x0c45:0x7603:0x4'
grubquirk="usbhid.quirks=$quirk"

# Making sure the quirk does not get added multiple times
if ! (cat /etc/default/grub.d/aziokbd.conf | grep "$grubquirk"); then
    echo '## Writing to /etc/default/grub.d/aziokbd.conf ##'
    echo $grubquirk >> /etc/default/grub.d/aziokbd.conf
    distro = $(lsb_release -si)
    if ($distro | grep 'Ubuntu'); then
        update-grub
    fi
    if ($distro | grep 'Debian'); then
        update-grub
    fi
    if [ -f "/etc/arch-release" ]; then
        update-grub
    fi
    if [ -f "/etc/fedora-release" ]; then
        grub2-mkconfig -o /boot/grub2/grub.cfg
    fi
else
    echo 'NOTICE - grub config file has already been updated'
fi

echo '## You must reboot to load the module ##'


