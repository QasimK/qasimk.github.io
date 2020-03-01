---
layout: default-post
title:  "Backing up a Computer with BorgBackup"
tags:   borg backup linux
githubCommentIssueID: 19
---

I want to backup my laptop because I have heard so many stories about friends and family losing documents and photos that were important to them.

Cloud storage, file sync, or photo-specific apps like Dropbox, Google Drive, and OneDrive are not substitutes for backups. They are slow, expensive, and have limited options for including/excluding files. They are not private and are subject to changing terms and conditions.

The simplest solution is to have a local backup on a hard drive. To reduce the chances of a catastrophic failure, we should also backup to an off-site location. In particular, we should expect the portable hard drive to fail when we least want it to.

In this article, I will describe how I backup my home folder to a 5␟TB portable hard drive, and then backup this up to an external network file share. I usually run this once a day and it usually takes a few minutes.

## External Hard Drive

Here is a quick list of commands to probe and test a hard drive to ensure it is healthy:

* Basic information: `hdparm -I /dev/sdx`
* Benchmark: `hdparm -t /dev/sdx`
* Benchmark: `dd bs=1M count=1024 if=/dev/zero of=test conv=fdatasync`
* Check for TRIM: `lsblk --discard` (supported if non-zero DISC-GRAN & DISC-MAX)
* SMART: `smartctl --all /dev/sdx`
* SMART test: `smartctl -t short /dev/sdx` (a long test could take a whole day)
* SMART quick health: `smartctl -H /dev/sdx`

Let's dump all SMART information for future reference: `smartctl --all /dev/sdx > smart.txt`

(It is possible to set up `smartd` to pause and continue a test to run it over several separate mounts, but the configuration is esoteric!)

Practically all portable hard drives are now SMR drives. These have terrible random read-write performance characteristics. More advanced drives incorporate sector remapping features like SSDs to improve performance. For backup purposes they should be "okay".

## Partitioning

The second step is to partition the hard drive. We will use GPT because MBR has a 2␟TiB limit. Using `fdisk /dev/sdx` we will actually configure "GPT with protective MBR".

When partitioning we want to clear the existing partition and create a new GPT partition with:

* Start sector: the default of 1␟MiB
* Number of sectors: `+9765622951` (which is five trillion bytes exactly)
* Partition Type: `CA7D7CCB-63ED-4C53-861C-1742536059CC` (Linux LUKS)
* Partition Label (Expert Mode; name): `partbackup`

The number of sectors is calculated to be exactly 5␟TB to maximise compatibility between hard drives in case we want to do a direct copy to another drive. Since `fdisk` always uses sector sizes of 512␟bytes, the calculation is `((5 × 10¹²) - (1024 × 1024) ÷ 512) - 1`. For some reason we must subtract one.

We should backup the partition table in case we screw something up: `sfdisk --dump /dev/sdb > fdisk.dump`.

To restore it we can run: `sfdisk /dev/sdb < fdisk.dump`.

## Integrity & Encryption

To ensure data integrity and protection from loss/theft, we can encrypt the drive with integrity protection. Normal encryption is done with `dm-crypt`, but integrity protection requires `dm-integrity` and gives actual protection against bit-rot and tampering.

There are a few downsides to enabling integrity protection. Firstly, it must do two writes for what was previously a single write, cutting speeds in half. Secondly, it does not support TRIM. Thirdly, it takes a long time to format the drive.

The default encryption parameters are reasonable (shown with `cryptsetup --help`).

Encrypt the drive partition:

```console
$ cryptsetup luksFormat --verbose --sector-size 4096 --integrity hmac-sha256 --label "cryptbackup" /dev/sdx1
```

* `--sector-size 4096` overrides the default 512␟byte sector size (in order to match the physical sector size of the hard drive as given by `hdparm` earlier)
* `--integrity hmac-sha256` enables `dm-integrity`

This will take many _many_ hours as `dm-integrity` must zero out the entire drive. I was getting speeds of 62-51␟MiB/s as it move from the inside to the outside of the disc platter (and it took a full day in total). In particular, the drive had **terrible** performance (even sequential performance) after this was completed, but it improved after a few days.

Backup the LUKS header as there is no way to decrypt the drive if this is corrupted—even if we remember the password.

```console
$ cryptsetup luksHeaderBackup --verbose /dev/sdx1 --header-backup-file luksheader.dump
```

While it is not possible to recover from the hard drive when integrity is compromised, we will at least know about it. This is why it is also important to have a second backup destination. (It would be possible to recover if `dm-raid` was used.)

## Filesystem

We will format the partition with `ext4` for simplicity.

I say simplicity, but now I'm going to describe how to tweak the filesystem to increase the storage capacity.

```console
$ mkfs.ext4 -v -L fsbackup -T largefile4 -m 0 /dev/mapper/cryptbackup
```

* `-T largefile4` reduces the number of inodes to expect an average file size of 4␟MiB per file
* `-m 0` does not reserve the default 5% of disk space for the root user

Normally the inode ratio (as seen in `/etc/mke2fs.conf`) changes depending on the size of the partition and the default is fine. However, for my Borg backup I could see that the average file size was 250␟MB (nearly half of files were the maximum 500␟MB). I could only see this after doing this whole process.

Be warned that if we run out of inodes our disk will effectively be full, because each file/directory/link requires an inode. (This can be checked using `df -i`.)

There are other options that we can safely ignore. Metadata checksums are enabled by default. The inode size of 256␟bytes allows for extra attributes and inline data so we don't need to reduce it. The blocksize is automatically determined (and should be 4␟KiB).

We can check the filesystem parameters using `dumpe2fs`.

Mount the drive and reserve some disk space in case of an emergency:

```console
$ mkdir /mnt/fsbackup
$ mount -o noatime,lazytime /dev/mapper/cryptbackup /mnt/fsbackup
$ chmod -R 0750 /mnt/fsbackup
$ chown -R me:me /mnt/fsbackup
$ truncate -s 500M /mnt/fsbackup/freespace
```

## Auto-mount

It would be convenient to automatically mount the drive when we plug it in. In order to do this we can create an encryption key file and configure systemd to decrypt and mount the filesystem.

```console
$ cryptsetup -v open /dev/disk/by-partlabel/partbackup
$ dd if=/dev/random bs=32 count=1 of=/root/cryptbackup.key
$ cryptsetup luksAddKey /dev/disk/by-partlabel/partbackup cryptbackup.key
```

We need three systemd unit files.

The first to decrypt `/etc/systemd/system/cryptbackup-unlock.service`:

```ini
[Unit]
Description=Open CryptBackup
After=local-fs.target
StopWhenUnneeded=true

[Service]
Type=oneshot
ExecStart=/usr/bin/cryptsetup -v --key-file /root/cryptbackup.key open /dev/disk/by-partlabel/partbackup clearbackup
RemainAfterExit=true
ExecStop=/usr/bin/cryptsetup
```

The second for mount info: `/etc/systemd/system/cryptbackup-unlock.service`:

```ini
[Unit]
Description=FSBackup
Requires=cryptbackup-unlock.service
After=cryptbackup-unlock.service

[Mount]
What=/dev/mapper/clearbackup
Where=/mnt/fsbackup
Type=ext4
Options=noatime,lazytime
DirectoryMode=0750
TimeoutSec=10s

[Install]
WantedBy=multi-user.target
```

The third to auto (un)mount: `/etc/systemd/system/mnt-fsmount.mount`:

```ini
[Unit]
Description=FSBackup

[Automount]
Where=/mnt/fsbackup
DirectoryMode=0750
TimeoutIdleSec=1m

[Install]
WantedBy=multi-user.target
```

Finally, enable:

```console
$ systemctl daemon-reload
$ systemctl enable --now mnt-fsbackup.automount
```

## Borg(matic) Backup

Now we can configure [BorgBackup][borg]. We will use [borgmatic][borgmatic] because it incorporates many common features into a simple configuration file, such as variable retention, integrity checks, and alerting.

```console
$ pacman -S --needed borg borgmatic python-llfuse
```

Generate the configuration file:

```console
$ generate-borgmatic-config --destination ~/.config/borgmatic/config.yaml
$ validate-borgmatic-config
```

Edit the configuration file, taking note of:

* `source_directories` (just my home directory `/home/me`)
* `repositories` (the portable drive `/mnt/fsbackup/borgbackup`)
* `one_file_system` (to avoid any mounts in the home directory)
* `exclude_from` (see below)
* `borgmatic_source_directory` (not sure what this does to be honest)
* `checkpoint_interval` (use `300` seconds in case drive is unplugged)
* `compression` (`auto,lz4` to first check if file is compressible)
* `retention`
* `consistency` (only enable repository checks for quicker backup)

For the excludes, we can use an external exclude file which is super simple to maximise clarity and minimise bugs. An excerpt is:

```
/home/me/tmp
*.py[cod]
*.tmp
```

(By default it uses Python's [fnmatch][fnmatch] module to check for matches.)

Now we can create the backup repository. We will use an encryption key so that we can simply copy the entire repository to somewhere which may not have any encryption.

```console
$ borgmatic init --encryption <repokey>
```

**Finally we can actually do a backup:**

```console
$ borgmatic --stats --progress --verbosity 1
```

Some useful commands to browse previous backups:

```console
$ borgmatic info
$ borgmatic list
$ borgmatic mount --mount-point ~/mnt/borgarchives
$ borgmatic umount --mount-point ~/mnt/borgarchives
```

In particular, it is recommended to double-check which files have actually been backed up.

## External Backup

We should backup the backup to an external location as well. There are a number of ways to do this including [third-party Borg servers][borg-cloud] (using client-side encryption) and mounting cloud storage using [rclone][rclone].

I already have a mounted samba share in another city, so it is convenient for me to just rsync the backup files across:

```console
$ rsync \
    --verbose -hh --stats --progress \
    --recursive --one-file-system \
    --times \
    --bwlimit=2MiB --no-compress --whole-file \
    --delete \
    /mnt/fsbackup/borgbackup/ \
    /mnt/homeserver/borgbackup
```

* `-hh --stats --progress` outputs detailed progress information
* `--one-file-system` is just paranoia
* `--times` copies file modification times to avoid copying unmodified files
* `--bwlimit=2Mib` caps the upload speed, smooths it out (fixes samba's bursty writes and the progress indicator for individual files), improves the responsive of the SMB share, and finally stops others from complaining about the internet connection.
* `--no-compress --whole-file` because compressed and part-file transfers are useless without an rsync daemon on a remote server (we use SMB, so we don't have one)
* `--delete` to delete pruned Borg files

It is important to note that this is *not atomic*, unfortunately samba does not supported hard links. Otherwise we could use `--link-dest=borgbackup /mnt/fsbackup/borgbackup/ /mnt/homeserver/borgbackup-draft`. Nor does samba support serve-side copy, so we can't use `--copy-dest` in-place of `--link-dest` either. That sucks.

When copying files back, we can use the options `--no-perms --chmod=ugo=rwX`.

## Script

A final script placed in `~/.local/bin/backup-home` makes this easy:

```bash
#!/usr/bin/bash
# Backup the home folder
set -Eeuo pipefail

DATE_CMD="date +%l:%M%p"

echo -e "**Please wait to enter TWO passwords before leaving this to run!**"
echo -e "Borg backup to external drive and rsync to homeserver..."
echo -e "Started at: $($DATE_CMD)\n"

borgmatic --stats --progress --verbosity 1

echo -e "Borg finished at: $($DATE_CMD)\n"

rsync \
    --verbose -hh --stats --progress \
    --recursive --one-file-system \
    --times \
    --bwlimit=2MiB --no-compress --whole-file \
    --delete \
    /mnt/fsbackup/borgbackup/ \
    /mnt/homeserver/borgbackup

echo -e "rsync finished at: $($DATE_CMD)\n"

systemd-umount /mnt/fsbackup
```

## Conclusion

It was a long road to set this up, but I enjoyed learning about how the hardware and the various software layers all play together. The final solution is fast, simple, and reliable, but if there is a large change then the rsync portion can take an entire night. I cannot think of a good way to improve this as it is limited by my internet connection.

There was one downside that I didn't foresee. I didn't think I would be bothered by needing the hard drive to remain connected to my laptop, but if it is a particularly long backup I am weary of damaging the drive by using and moving my laptop around. In the future, I might use a NAS.


*[SMR]: Shingled Magnetic Recording
*[GPT]: GUID Partition Table
*[MBR]: Master Boot Record

[borg]: https://www.borgbackup.org/
[borgmatic]: https://torsion.org/borgmatic/
[fnmatch]: https://docs.python.org/3/library/fnmatch.html
[borg-cloud]: https://www.borgbackup.org/support/commercial.html
[rclone]: https://rclone.org/
