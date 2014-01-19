#!/bin/sh

[ -e "/media/provision" ] &&
  . /media/provision/provision.cfg

# default for root filesystem device
[ -z "$ROOT" ] &&
  ROOT=/dev/sda1

# Set host name if we have a directive for that
# (incredibly mind-opening comment)
[ ! -z "$HOSTNAME" ] &&
  hostname $HOSTNAME

# Set root password if we have a directive for that
# (incredibly horizon-widening comment)
[ ! -z "$ROOT_PASSWORD" ] &&
  echo root:$ROOT_PASSWORD | chpasswd

# provision filesystem
for dir in $(ls /media/provision/live/); do
  rsync -a /media/provision/live/$dir /
done

# network interfaces and basic connectivity
# grandpa's way
if (!grep -q 'auto eth0' /etc/network/interfaces); then
  echo "auto eth0" >> /etc/network/interfaces
fi
/etc/init.d/networking restart
/etc/init.d/ssh restart

# live system will be found here
# (to further the newly-founded tradition of vision-broadening comments)
mkdir /live
mount -t tmpfs -omode=0755,size=2048M tmpfs /live

# live filesystem deployed
echo "Copying files to RAM. Get a coffee, this may take a while... Or not"

# look for cpio or tar archive, or plain filesystem
mount $ROOT /mnt
if [ -e "/mnt/wild.cgz" ]; then
  cd /live
  gunzip -c /mnt/wild.cgz | cpio -i
elif [ -e "/mnt/wild.tar.gz" ]; then
  cd /live
  tar xzf /mnt/wild.tar.gz
else
  rsync -a /mnt/ /live
fi

echo "Files are copied. Done."

# finalising chrooted system to-be
mount -t proc none /live/proc
mount -t devpts none /live/dev/pts

# finally mount home directory if we have a directive for this
[ ! -z "$HOME" ] &&
  mount $HOME /live/home

chroot /live $BOOTUP

exit 0

