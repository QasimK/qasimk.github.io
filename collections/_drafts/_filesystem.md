# A sensible file-system

/var
/etc
/home

/home//.config
/home//.local
/home//.cache


All right, let's face it: you're home directory was/is/will be defaced by militant applications like SSH and bash which refuse to follow the Free Desktop XDG home directory specification.

So you're real home is this:

~/me/
    /Apps/
    /AppConfig/
    /AppData/
    /AppCache/

    /projects/code
    /projects/games/tf2
    /code/oss
    /code/personal
    /work/fustra/[client]/
    /s
    /photos
    /media/apps/[arch]
    /media/computers/[computer]/
    /media/books
    /media/music
    /media/wallpapers/[size]/
    /games/[game]/...?

    /tmp/Downloads
    /incoming or /staging /outgoing

    /VirtualBox VMs

    /mnt/[mnt-name]/
    /cloud/dropbox/[symlinks]
    /cloud/resilio/[symlinks?]
    /cloud/gdrive/[symlinks?]


## With Disks

/boot   FAT32 UEFI - KERNEL Main, Main-fb, LTS, LTS-fb
/       BTRFS SSD [RAID1]
/media  BTRFS HDD [RAID1]
SUBVOLS:
    /
        (To Easily Restore System after Upgrade)
    /home
        /.local
            /config
            /bin
        /games
        /mount
        /s
        /me -> /me
    /home/Downloads (staging folder with auto-clean script?)
    /me
        /Apps/[arch]
        /Code
            /Personal
            /OSS
            /Fustra/[Client]
        /Cloud
            /Dropbox
            /Resilio
            /GDrive
        /Music -> /media/
        /Photos -> /media/
        /VMs
        /Wallpapers/[size] -> /Cloud/X

/media
    /Devices/[device]/
    /Music
    /Photos

/media is necessary because SSDs are expensive, but you cannot span Btrfs effectively across disks.
