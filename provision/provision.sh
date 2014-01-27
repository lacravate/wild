#!/bin/sh

[ -e "/media/provision" ] && [ -e "/media/provision/provision.cfg" ] &&
  . /media/provision/provision.cfg

# default for root filesystem device
[ -z "$ROOT_DEVICE" ] &&
  ROOT_DEVICE=/dev/sda1

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
[ -z "`grep 'auto eth0' /etc/network/interfaces`" ] &&
  echo "auto eth0" >> /etc/network/interfaces

/etc/init.d/networking restart
/etc/init.d/ssh restart

# live system will be found here
# (to further the newly-founded tradition of vision-broadening comments)
mkdir /live
mount -t tmpfs -omode=0755,size=4096M tmpfs /live

# live filesystem deployed
echo "[ WILD ] Copying files to RAM. Get a coffee, this may take a while... Or not"

# look for cpio or tar archive, or plain filesystem
mount $ROOT_DEVICE /mnt
if [ -e "/mnt/wild.cgz" ]; then
  cd /live
  gunzip -c /mnt/wild.cgz | cpio -i
elif [ -e "/mnt/wild.tar.gz" ]; then
  cd /live
  tar xzf /mnt/wild.tar.gz
else
  for subdir in $(ls /mnt); do
    echo "[ WILD ] copying $subdir to RAM" 
    cp -a /mnt/$subdir /live
  done
fi

echo "[ WILD ] Files are copied. Done."

# finalising chrooted system to-be
mount -o bind /dev /live/dev
mount -t proc none /live/proc
mount -t devpts none /live/dev/pts
mount -t sysfs sysfs /live/sys

# finally mount home directory if we have a directive for this
[ ! -z "$HOME_DEVICE" ] &&
  mount $HOME_DEVICE /live/home

chroot /live $BOOTUP

exit 0

