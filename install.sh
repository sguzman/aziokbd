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
GRUBCONF=/etc/default/grub.d/aziokbd.cfg
if ! (cat $GRUBCONF | grep "$grubquirk"); then
    echo '## Writing to $GRUBCONF'
    echo "GRUB_CMDLINE_LINUX_DEFAULT=\"\$GRUB_CMDLINE_LINUX_DEFAULT $grubquirk\"" >> $GRUBCONF
    distro=$(lsb_release -si)
    case $distro in 
        'Ubuntu'|'Debian'):
            update-grub
            ;;
        *):
            if [ -f "/etc/arch-release" ]; then
                update-grub
            elif [ -f "/etc/fedora-release" ]; then
                grub2-mkconfig -o /boot/grub2/grub.cfg
            fi
	    ;;
    esac
else
    echo 'NOTICE - grub config file has already been updated'
fi

echo '## You must reboot to load the module ##'


