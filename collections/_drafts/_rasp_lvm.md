https://wiki.archlinux.org/index.php/RAID
https://wiki.archlinux.org/index.php/LUKS
https://wiki.archlinux.org/index.php/LVM
https://wiki.archlinux.org/index.php/Software_RAID_and_LVM
Reading: https://storageapis.wordpress.com/2015/12/04/foundations-of-lvm-for-mere-mortals/
Reading: https://storageapis.wordpress.com/2016/06/24/lvm-thin-provisioning/
Guide: https://www.raspberrypi.org/forums/viewtopic.php?p=709645
Guide: https://hackmd.io/FP-7sHiPTJGaJvzSa3nw8A (btrfs on pi)
Guide: https://narcisocerezo.wordpress.com/2014/06/25/create-a-robust-raspberry-pi-setup-for-24x7-operation/
Guide: https://blog.alexellis.io/hardened-raspberry-pi-nas/
Guide: http://whitehorseplanet.org/gate/topics/documentation/public/howto_ext4_to_f2fs_root_partition_raspi.html

* We won't create a SWAP partition because things are slow enough as it is.
* Performance overhead on Raspberry Pi (RAID, LUKS, LVM)?
* Watch out for lack of power "kernel: Under-voltage detected! (0x00050005)"
* mdadm vs lvmraid

What do you want to accomplish?
* If a disk dies, I want don't want to lose anything -> mdadm (not lvmraid)
* If a disk dies, I want to re-build -> Backups + Ansible provisioning
* If my system/house burns down... -> External disk image backups (http://taobackup.com/)
* I want to span a single directory across multiple disks -> LVM on those partitions only
* I want to span my entire file system across multiple disks -> LVM on / (except /boot)
* I don't want to necessarily physically destroy a disk when it fails -> LUKS password on un-encrypted /boot
* I want to enter a password when rebooting my Raspberry Pi -> Manual LUKS password on every boot
* I don't care about anything -> BtrFS (https://github.com/NicoHood/NicoHood.github.io/wiki/Raspberry-Pi-Encrypted-Btrfs-Root)

f2fs root: https://discussions.flightaware.com/t/raspberrypi-sd-cards-wear-and-f2fs-filesytem-experience/29508

Just do this: sudo mkfs.f2fs -l pistorage -c /dev/sda1 -O encrypt /dev/mmcblk0p3

Notes:
* /boot is 100MB but only about a quarter is used
* / is about 2GB in total

Devices -> RAID -> LUKS -> LVM -> FS

Physical disks (/dev/sdc and /dev/sdd are the same size):
    /dev/sda
    /dev/sdb
    /dev/sdc [X GB]
    /dev/sdd [X GB]

Partitions (Partition /dev/sda into two, e.g. a separate boot partition):
    /dev/sda1 -> partition -> format (boot partition)
    /dev/sda2
    /dev/sdb
    /dev/sdc
    /dev/sdd

RAID (RAID1 of /dev/sdc and /dev/sdd):
    /dev/sda1
    /dev/sda2
    /dev/sdb
    /dev/md0

LUKS (Encrypt non-boot partitions):
    /dev/sda1
    /dev/mapper/crypt1
    /dev/mapper/crypt2
    /dev/mapper/crypt3

LVM-PV:
[Create headers to identify LVM Physical Volumes]
    /dev/mapper/crypt1
    /dev/mapper/crypt2
    /dev/mapper/crypt3

LVM-VG (Create ):
    /dev/lvm-vg-rpi1

LVM-LV (Create three thin-provisioned Logical Volumes):
[We can restrict logical volume to physical volumes]
    /dev/mapper/lvm-vg-rp1-root
    /dev/mapper/lvm-vg-rp1-home
    /dev/mapper/lvm-vg-rp1-storage

FS (mkfs.f2fs on all):
    /
    /home
    /mnt/storage


STEPS:

mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sd[cd]2

/etc/mkinitcpio.conf
    MODULES=(dm-raid raid0 raid1 raid10 raid456)
    HOOKS=(base _udev_ ... block _lvm2_ filesystems)

/boot/cmdline.txt
    root=/dev/mapper/lvm-vg-rp1-root


RANDOM:

/boot/config.txt
    gpu_mem=16
    dtoverlay=pi3-disable-wifi
    dtoverlay=pi3-disable-bt
    hdmi_blanking=2
    arm_freq_min=300
    ...



# Disable/check HDMI status
/opt/vc/bin/tvservice


# Power
https://www.raspberrypi.org/help/faqs/#powerReqs
https://www.pidramble.com/wiki/benchmarks/power-consumption
https://www.raspberrypi.org/forums/viewtopic.php?t=152692

sudo vim /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
    conservative


# BTRFS features

Still seems a bit risky.

* Copy-on-write
* Compression
* Snapshots (backups), inc. incremental

- no badblocks support (https://unix.stackexchange.com/questions/364105/)
- no swap files
