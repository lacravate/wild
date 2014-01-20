# Wild

`Wild` is an attempt at giving tools and tips to run any `Linux` system entirely
in RAM (`tmpfs`).

Wild stands for "What if...? Linux Distribution". It's arguably a `Linux`
distribution, yet this is arguable, as here is delivered my own flavour of a
complete and usable `Linux` system.

But i won't argue, the aim being arguably to come by a fancy acronym, recalling
it all began with this lil' but utterly-time-consuming question.

## What does it do ?

Basically, a full-fledged, yet elementary, `Debian` system is launched from a
removeable medium, and charged in RAM (hence the removeable medium can be
removed). The system should have network capabilities set or easily set with
minor tweaks.
This system prepares the ground for another `Linux` system to be aptly
`chroot'ed'`, copies (or deflates through `cpio` or `tar` archive) the
chrooted-to-be system in RAM, and `chroot`s it.

As far as i know, it could be any system, only architecture limitations apply.

## Use

You'll need to be able to generate and burn an `.iso` image (`genisoimage`).
Also have a `Linux` system that could fit into your machine's RAM. Then :

```shell
git clone https://github.com/lacravate/wild.git`
wild/scripts/generate_wild.sh wild/
```

You'll have `wild.iso` ready in the current directory. Boot (see Tips below) on
this `ISO 9660` image, and if you have a system installed on `sda1` (first disk
drive), you should be able to check if all this was worth the time you took.

If your machine is on a network with DHCP service, eth0 link should be up and
elementary `Debian` should be accessible (aside from the console of course)
through `ssh` on port 2222.

## Tweaks

### Configuration

The existence of a `provision/provision.cfg` file will be checked and sourced as
as shell script to export variables.

```
export ROOT=/dev/sda5 # partition were chrooted-to-be system is if it is not on
                      # /dev/sda1
export HOSTNAME=host # if host name wild is not good for you
export HOME=/dev/sdf1 # the partition holding the /home directory, if any
export ROOT_PASSWORD=root #wanna set the root password of the elementary Debian ?
export BOOTUP=/home/startup.sh # when system is chrooted, launches this script to
                               # setup a few things on chrooted system
```

### Files

Any file found under the `provision/live` directory on installation/configuration
medium will be copied to "main" (elementary `Debian`) system.

For instance, a `provision/live/etc/network/interfaces` will be copied to
`/etc/network/interfaces` on the in-RAM main system. This could allow you to
setup a network interface suiting your needs (if DHCP is no good for you).

### Note on media

In search for this `provision` directory, media will be search starting from
floppy drive, to USB drives, and eventually CD-DVD drives. Hence, this
directory does not need to be on the installation medium, preventing you from
generating and burning the `iso` image again and again.

This can come particularly handy for virtual machines that could not be launched
from USB sticks : boot would be achieved from an unchanged `iso` image, while
configuration could be changed easily altered on a virtual floppy.

## Tips

Singular for the time being.

### Boot from USB stick

`Linux` makes it a childish game once you know it. You need to have the
`isohybrid` command available (found it in the `syslinux` package in `Debian`
and `Ubuntu`).

```
isohybrid wild.iso
dd if=wild.iso of=/dev/sdc # for a USB stick mapped on this device
```

I suppose you need to be root, at least for the `dd`.

And then, you can fill the `provision` subdirectory with anything you need.

## How and why so ?

The removeable medium boots with `isolinux` (because it's easy to use and
dead-simple to re-configure), the `Init RAM Disk` (`initrd`) is the classic
vestigial `Linux` system, with two differences. The first is that the archive
embarks the target elementary `Debian` system, the second being that there is no
`pivot_root` that's made to a "on disk" system. The Debian system is inflated in
RAM, and is given control afterwards.

"The main goal being the operation of another system, possibly a whole desktop
thingy, why not copying directly this system in RAM ?"

I prefer to have an almost immortal, "failutmostsafe" system (as the
elementary Debian should be), that will boot, and that i know i can rely on.
Also, the `initrd` system has really limited capabilites. So it's really a
hassle to setup once and for all, with that system, the procedure to `chroot` on
any target system.

## Credits

`debirf` project gave me a some inspiration, as well lots of elementary
material.

All the `Linux` people landing such an astonishingly versatile system, with
which limits to what you can do are those of your own daring or imagination.

## Copyright

I was tempted by the WTFPL, but i have to take time to read it.
So far see LICENSE.
