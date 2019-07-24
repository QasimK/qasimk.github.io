My Model: 20KHCTO1WW

# Setting up Arch Linux on a Lenovo X1 Carbon (6th Gen 2018)

Why? https://medium.com/@shazow/my-computer-is-my-home-5a587dcc1d76
* https://github.com/ejmg/an-idiots-guide-to-installing-arch-on-a-lenovo-carbon-x1-gen-6
* https://kozikow.com/2016/06/03/installing-and-configuring-arch-linux-on-thinkpad-x1-carbon/
* Not x1 carbon: https://ticki.github.io/blog/setting-up-archlinux-on-a-lenovo-yoga/

## List of Issues

* Resolved: With the 20KG (NFC edition), the touchpad and trackpoint do not work together - fixed with Linux kernel 4.17.
* Resolved: Si03 vs S3 Sleep power drain - fixed with BIOS v1.30.
* Thermal throttling issues with BIOS v1.25-v1.30(+?). (Workaround tool available.)
* With the 4G-WAN edition, the mobile modem does not work with Linux. This is unlikely to be resolved at all.


## Dealing with Windows

Firstly, setup Windows with a simple account (no network connection needed). When reselling, start Windows "Fresh" to remove this account.

Then, create a copy of windows for re-sale using one or more of the following methods:

1. Settings > Update & Security > Backup > Backup and Restore (Windows 7)
    * Create a system image backup ("WindowsImageBackup").
    * This backups up all drives on the image and allows you to do a full restore.

2. Create Recovery Drive
    * Settings > Recovery (Advanced Recovery Tools) > Create Recovery Drive

3. Perhaps `dd` after resizing the partitions.

Also, get the product key: `wmic path SoftwareLicensingService get OA3xOriginalProductKey`.


## Upgrade BIOS

On Windows, get your BIOS Version: `wmic bios get smbiosbiosversion`. Mine was: `N23ET47W`, v1.22.

Lenovo has a bootable CD for upgrading BIOS's if you have already removed Windows.

See Arch Linux Wiki on instructions on how to create a USB disk image. Note that this *created* disk image has a FLASH folder which can set a custom logo.

* Download page: https://pcsupport.lenovo.com/gb/en/products/laptops-and-netbooks/thinkpad-x-series-laptops/thinkpad-x1-carbon-6th-gen-type-20kh-20kg/downloads/ds502281
* Might want to skip 1.25 due to thermal throttling issues
* 1.30: Finally support Linux sleep via BIOS setting!
* STILL thermal throttling ISSUE with 1.30
* Lenovo implemented S0i3 sleep instead of the normal S3 sleep (suspend to RAM): https://news.ycombinator.com/item?id=17551286
    * This is for "Windows Modern Standby", which allows the device to wake-up to perform background activities.
* 1.30 finally fixes s3 sleep
* https://200ok.ch/posts/2018-09-26_X1_carbon_6th_gen_about_50_percent_slower_on_Linux.html
* `sudo dmidecode -t bios | grep Version` to get BIOS version


## BIOS Configuration / Security

* Config
    * Network
        * Wake On LAN: AC Only (default - does not work when HDD Password set?)
        * Consider "Wireless Auto Disconnection" (battery life)
        * UEFI IPv4/IPv6 Network Stack: Disabled (security)
    * Keyboard / Mouse
        * Fn and Ctrl Key Swap: Enabled (retain muscle memory between keyboards)
        * Fn keys default: Enabled (retain muscle memory between keyboards)
    * Power
        * Sleep State: Linux (fix sleep power drain)
    * Thunderbolt 3
        * Thunderbolt BIOS Assist Mode: Enabled (battery savings - not tested)
        * Wake by Thunderbolt 3: Disabled (battery savings)
        * Security Level: Display Port & USB (security; change if you ever get thunderbolt device.)
* Security
    * Password
        * Set Supervisor Password (security)
        * Lock UEFI BIOS Settings: Enabled (security)
        * Set Hard Disk1 Password (security - SSD encryption)
        * Password on restart/boot: Enabled (security)
    * Fingerprint
        * Predesktop Authentication (while possibly useful, you can only provision from Windows)
        * Security mode: High (why not?)
    * UEFI BIOS Update Option
        * Flash BIOS updating by end-users: Disabled (security)
        * Windows UEFI Firmware update: Disabled (security & useless)
    * I/O Port Access
        * Wireless WAN: Disabled (no hardware)
        * Fingerprint Reader: Disabled (useless)
    * Internal Device Access:
        * Bottom Cover Tamper Detection: Enabled (security)
        * Internal Storage Tamper Detection: Enabled (security)
    * Anti-theft:
        * TODO: What is computrace? Where can we get it from?
        * Computrace: Disabled
    * Intel SGX:
        * Intel SGX Control: Disabled (because FU DRM)

Notes:
* There is no way to disable Intel Management Engine.

* We use the SED/Opal password on the drive rather than LUKS FDE for performance.
* BIOS HDD Password should set the encryption password on the SED SSD.
* DEK > AEK > Password chain https://us.community.samsung.com/t5/Memory-Storage/HOW-TO-MANAGE-ENCRYPTION-OF-960-PRO/m-p/152440/highlight/true#M644
* Confirmed by staff member https://forums.lenovo.com/t5/ThinkPad-P-and-W-Series-Mobile/Self-Encrypting-PCIe-NVMe-M-2-SSD-Password-in-the-BIOS-of-a-P70/m-p/3335879/highlight/true#M59930
* Also confirmed in the manual: "Some models might contain the Disk Encryption solid-state. [...] For the efficient use of the encryption feature, set a hard disk password for the internal storage drive."
* This should work across machines - need to test?!
https://support.lenovo.com/gb/en/solutions/migr-69621

* Disable alternative boot media (change BIOS for when you want to use it). This prevents some attacks on SED SSD. https://www.blackhat.com/docs/eu-15/materials/eu-15-Boteanu-Bypassing-Self-Encrypting-Drives-SED-In-Enterprise-Environments.pdf
https://www1.cs.fau.de/filepool/projects/sed/seds-at-risks.pdf

## Power

TEST: Card Reader.
TEST: Thunderbolt BIOS assist mode.
TEST: Undervolt CPU - with thinkpad-power-fix(name?) (GitHub)

s-tui for cur power consumption?

* TODO: Disable card reader due to bug?
* TODO: Thunderbolt BIOS assist mode save power (while in sleep)?
* Suspend Issues?
* Undervolt CPU - stress test performance.
* Which tool to set battery limits to preserve battery life. How-to automatically turn this on and off?
* Power management throttling issues?
* Throttling issues?
* TLP to tweak, and `powertop` to monitor
    * https://github.com/linrunner/TLP/blob/master/default
    * https://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html
    * tlp-stat
    * tpacpi-bat (optional dependency of tlp)
    * Use 50-60% thresholds
        * 65-75% is optimum: https://www.youtube.com/watch?v=AF2O4l1JprI
        * thinkpad says 40-50: https://support.lenovo.com/us/en/solutions/ht078208
    * tlp fullcharge for one-off max-charge
    * https://linrunner.de/en/tlp/docs/
* https://github.com/teleshoes/tpacpi-bat

* TODO: Turn off Power LED:

echo "0" | sudo tee "/sys/class/leds/tpacpi::power/brightness"

* TODO: Systemd suspend-then-hibernate. Enable Swap only when hibernating.
* Alternative: Hibernate on low battery: /etc/udev/rules.d/
* Look through: https://wiki.archlinux.org/index.php/Power_management

* enabling panel self-refresh with i915 module option enable_psr=1, to save a bit of power. May be problematic on older hardware/kernels. Use 'sudo systool -vm i915' to check this option value in case your distro already has it enabled

* https://www.reddit.com/r/thinkpad/comments/alol03/tips_on_decreasing_power_consumption_under_linux/
    * 3W difference between lowest and highest brightness

## Arch Linux Install

* No disk encryption - using hardware disk encryption.
* UEFI - for faster boot.
* BTRFS - Snapshots.
* Swap partition (at end of disk) - BTRFS does not support swap files yet. End of Disk allows us to remove the partition one day.
* Grub - supports BTRFS.
    * Compressed BTRFS?
* Linux-LTS - fallback kernel.
    * Needs manual grub entry
* TODO: BTRFS snapshot root mount login quick-thingy.
* Install `terminus-fonts`.
  Set font /etc/vconsole.conf
    KEYMAP=uk
    FONT=ter-i32b
 (note: use latarcyrheb-sun32 as a fallback large font)
 (ter-i32b looks beautiful.)
* Hardware video acceleration: libva-intel-driver?

## Desktop / Install

Getting key combos: evtest, xev, showkey

* TODO: sudo systemctl restart iwd - on unplug Ethernet adapter
* TODO: Shutdown on failed login: https://cowboyprogrammer.org/2016/09/reboot_machine_on_wrong_password/
* https://gist.github.com/artizirk/c5cd29b56c713257754c
* Fonts:
    * TODO: Look at presets
        * 70-no-bitmaps.conf
        * 10-sub-pixel-rgb
        * 11-lcdfilter-default.conf
    * Look at reddit "Make your Arch fonts beautiful easily!"
    * dejavu
    * Firacode
    * ttf-ubuntu-font-family?
    * noto-fonts, noto-fonts-extra, noto-fonts-cjk, noto-fonts-emoji
    * ttf-liberation (some Windows fonts)
* Grub faster & boot menu: https://wiki.archlinux.org/index.php/GRUB#Dual-booting
    * Press <Esc> to bring up Grub menu
    * /etc/default/grub
        * GRUB_DEFAULT=saved  (default entry number 0-index)
        * GRUB_TIMEOUT=0  (time to boot default, try 5.)
        * GRUB_HIDDEN_TIMEOUT=1
        * GRUB_HIDDEN_TIMEOUT_QUIET=true
        * GRUB_DISABLE_SUBMENU=y
    * /etc/grub.d/40_custom
        ```
        menuentry "Shutdown Laptop" {
             echo "Shutting down..."
             halt
        }

        menuentry "Restart Laptop" {
             echo "Restarting..."
             reboot
        }

        menuentry "Reboot into UEFI" {
            echo "Rebooting into UEFI..."
            fwsetup
        }
        ```
    * sudo grub-mkconfig -o /boot/grub/grub.cfg
    * Clean/Smooth boot: https://wiki.archlinux.org/index.php/silent_boot
        * https://www.reddit.com/r/thinkpad/comments/aoh4s3/some_clean_booting_action_with_t470_and_archlinux/
    * TODO: Extra boot options (Shutdown/Restart/UEFI)
    * TODO: LTS kernel option.
* SwayWM:
    * TODO: Use Kanshi for portable output https://github.com/emersion/kanshi
    * Supports 2x Scaling... but extremely application-specific.
        * e.g. Firefox is just blurry.
    * Instead: Recommend 1x, and scale individual applications
        * Sublime Text 3, KeePass, Firefox, Terminals all support individual scaling
    * i3blocks (cp /etc/i3blocks.conf -> ~/.config/i3blocks/config)
    * libinput config: https://wayland.freedesktop.org/libinput/doc/latest/index.html
    * **sway config**:
    # cwd.bash
    ```
    #!/usr/bin/env bash

    terminal=${1:xterm}
    pid=$(swaymsg -t get_tree | jq '.. | select(.type?) | select(.type=="con") | select(.focused==true).pid')
    pname=$(ps -p ${pid} -o comm= | sed 's/-$//')

    if [[ $pname == $terminal ]]
    then
        ppid=$(pgrep --newest --parent ${pid})
        readlink /proc/${ppid}/cwd || echo $HOME
    else
        echo $HOME
    fi
    ```
    # github.com/gumieri/dotfiles/.../sway/focused-cwd
      set $Alt Mod1
      set $Super Mod4
      font pango: DejaVu sans Mono, 8
      # output e-DP-1 scale 2
      set $term termite -e /usr/bin/fish
      set $term-cwd $term -d "$(~/.local/bin/cwd.bash $term)"
      # start a terminal
      bindsym $mod+Return exec $term-cwd
      bindsym $mod+$Alt+Return exec $term

    * Couple of features
      workspace_auto_back_and_forth yes
      force_display_urgency_hint 1000 ms


    * Menu Launcher
      # set $menu dmenu_run
      set $menu "rofi -combi-modi drun,run -show combi -modi combi,ssh,keys -show-icons -matching fuzzy -sort -sorting-method fzf -drun-show-actions"

    * # Media keys
      bindsym XF86AudioLowerVolume exec pactl -- set-sink-volume @DEFAULT_SINK@ -5%
      bindsym XF86AudioRaiseVolume exec pactl -- set-sink-volume @DEFAULT_SINK@ +5%
      bindsym Shift+XF86AudioLowerVolume exec pactl -- set-sink-volume @DEFAULT_SINK@ -25%
      bindsym Shift+XF86AudioRaiseVolume exec pactl -- set-sink-volume @DEFAULT_SINK@ +25%
      bindsym XF86AudioMute exec pactl -- set-sink-mute @DEFAULT_SINK@ toggle
      bindsym XF86AudioMicMute exec pactl -- set-source-mute @DEFAULT_SOURCE@ toggle
      bindsym $Alt+XF86AudioLowerVolume exec pactl -- set-source-volume @DEFAULT_SOURCE@ -5%
      bindsym $Alt+XF86AudioRaiseVolume exec pactl -- set-source-volume @DEFAULT_SOURCE@ +5%
      # Super-Alt-L because Super is used
      bindsym $Super+$Alt+l exec swaylock
    * Install acpilight and usermod -a -G video <user>
        bindsym XF86MonBrightnessUp exec xbacklight +5
        bindsym XF86MonBrightnessDown exec xbacklight -5
        # These don't work
        bindsym Shift+XF86MonBrightnessUp exec xbacklight +20
        bindsym Shift+XF86MonBrightnessDown exec xbacklight -20
    * Screenshots
        # https://gitlab.com/gamma-neodots/neodots.guibin/blob/master/grim-wrapper.sh
        # Screenshot (Selection, Window, Display, Everything)
        # Note grim supports scaled screenshots
        bindsym Print exec grim -g "$(slurp -d)" - | wl-copy
        bindsym Ctrl+Print exec "/home/test/.local/bin/grim-wrapper.bash -w"
        bindsym $Alt+Print exec grim -o "$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')" - | wl-copy
        bindsym Shift+Print exec grim - | wl-copy
        # bindsym print exec slurp | grim -g - $(xdg-user-dir PICTURES)/$(date +'screenshot_%Y-%m-%d-%H%M%S.png')
    * Lock Screen
        # Notification service
        exec mako
        bindsym $Super+n exec makoctl dismiss

        # Lock Screen
        set $swaylock_command swaylock --daemonize --ignore-empty-password --show-failed-attempts
        exec swayidle -w \
            timeout 300 "$swaylock_command" \
            timeout 315 'swaymsg "output * dpms off"' \
            resume 'swaymsg "output * dpms on"' \
            before-sleep "$swaylock_command"
        # Wait for next Sway release
        # Note: Waybar has a toggle (e.g. for presentations)
        #inhibit_idle fullscreen
    * TODO: Warbar config and style, and helper scripts?

    * Screen recording
        # wf-recorder
    * NOTE:
      (pactl list short sinks/sources)
    * Note alacritty should be released with scrolling soon, but termite is pretty great.
    * urxvt -fn "xft:Deja Vu Sans Mono:pixelsize=24"
    * ~/.config/termite/config (copy default file first.)
        [options]
        font =  Deja Vu Sans Mono 16
        scrollback_lines = 100000
    * `sudo pacmatic -S --needed waybar otf-font-awesome`
* pacman auto-download:
    * pacman -Suw (no y!)
    * Subscribe to https://www.archlinux.org/feeds/news/
    * The correct way to check for updates is `checkupdates` from pacman-contrib, otherwise pacman -Sy == Pacman -Syu + cancel which breaks due to partial upgrading!point

* firefox:
    * Smooth touchpad scrolling (x-org): env MOZ_USE_XINPUT2=1 firefox
* fish:
    * function keepassxc
        env QT_SCALE_FACTOR=2 keepassxc
      end
      funcsave keepassxc
      # Note dmenu does not support shell aliases!
* Redshift should work with Sway/Wayland.
* WiFi. iwd (iwctl, iwd, iwmon) works fine (now).
    * Note that iwd solves persistence problem with wpa_supplicant (i.e. without additional software `wpa_supplicant` forgets your network), and is simpler to use.
    * sudo iwctl
    * Do not use at the same time as NetworkManager service as they conflict.
    * Use dhcpcd
    * rfkill
    * iwctl is amazing to use.
* TODO: Trackpoint - change sensitivity.
* Be sure to conform to XDG Base Directory Spec (2003), annoying.
* Intel GPU Usage: https://medium.com/@niklaszantner/check-your-intel-gpu-usage-via-commandline-11196a7ee827
* Suspend & Resume processes (Unix)
    * SIGSTOP & SIGCONT
* Time Sync
    * Use Chrony
    /etc/chrony.conf
    server 0.pool.ntp.org iburst
    server 1.pool.ntp.org iburst
    server 2.pool.ntp.org iburst
    server 3.pool.ntp.org iburst
    Note that: uk.pool.ntp.org is not used because ntp.org will try to redirect you to the closest servers,
    and you may not be in the UK all the time. Not sure if the trade-off is worth it.
    They also suggest that the country-specific pools may not have enough servers, but UK does.
* Avahi-browser Windows NetBIOS names: insert wins before mdns_minimal.
    * => hostname.local
* Virtualbox
    * chattr +C "~/Virtualbox VMs"
    * lsattr
    * Do it before creating any files in there.
* Utils:
    * deepin-screenshot - NOT wayland-compatible. Flameshot does not work either.
    * albert - Does not work with wayland properly
    * fd (find); rg (grep); fzf (fzf fish bindings)
    * Dbeaver - SQL database browser
    * convert - file type converter
    * Pdftk - terminal pdf slicer and dice
    * lsix - terminal image viewer (TODO)
    * ranger - terminal file browser
    * nnn - super simple, efficient file browser (note: fish shell integration)
        * mediainfo
        * atool
    * atool - terminal archive files

### TODO

* SSH temporary access:
    * https://linux-audit.com/granting-temporary-access-to-servers-using-signed-ssh-keys/
    * authorized_keys owned by root
    * Storage quota
    * Allow only file copy with rssh shell: https://serverfault.com/a/83857
        * Prefer Scponly?
    * Use chroot to stop them from leaving home folder
    * https://nurdletech.com/linux-notes/ssh/hidden-service.html


NOTE NOTE NOTE
PavuControl set "Analog Stereo Duplex."
How to do this with pactl

### Custom Repository

https://disconnected.systems/blog/archlinux-repo-in-aws-bucket/

    mkdir -p ./chroots
    mkarchroot -C /etc/pacman.conf ./chroots/root base-devel
    makechrootpkg -cur ./chroots


## Configure Keyboard + Touchpad + Trackpoint

https://faq.i3wm.org/question/3747/enabling-multimedia-keys.1.html
(xorg-xbacklight will not work on Wayland. Try acpilight https://wiki.archlinux.org/index.php/Backlight#Backlight_utilities)

The backlight (Fn + space bar) works fine. Bluetooth and WiFi (F10, F8) are fine.
Capslock+light works fine.

* Manual: F1,2,3 (Audio volume) - light works
* Manual: F4 (Microphone) - light works
* TODO: F7 (Screen Displays). [XF86Display]
* TODO: F9 (Settings). [XF86Tools]
* TODO: F11 (Keyboard settings??)
* TODO: F12 (Whatever function)
* TODO: PrtSc -> make it Super?

Note: Fn+B = Break key
    Fn+K = Scroll Lock
    Fn + P = Pause
    Fn + S = SysRq
    Fn + 4 = Sleep
    Fn + PrintSc = Snipping Tool Program (...) [KEY_SYSRQ]
    Fn + Left = Home key
    Fn + Right = End key

Bottom-right tiny corner area is right-click, the rest is left-click. Two-tap = right-click.

sudo sh -c "echo 1060 > /sys/class/backlight/intel_backlight/brightness"
/sys/class/drm/card0-HDMI-A-1/enabled
card0-e-DP-1 is the main display

Tip: Scrolling with the trackpoint is possible using the middle trackpad button.

## Applications

* ICC
    (X can specify system-wide ICC for applications that support it. Not currently possible with Wayland.)
    There is a *huge* difference using an ICC profile.
    I tested against BT.709 and BT.2020 Youtube Videos and iPhone 6S Plus (which does sRGB very accurately.)
    And also against my supposedly calibrated Dell 2713HM display.
    This is also a good website: https://chromachecker.com/info/en/page/webbrowser

    TODO: Arch Wiki Page Link.
    With MPV, use instructions below.
    With Gimp: Add it in preferences.
    With Firefox: See wiki page.
        gfx.color_management.mode;1
        gfx.color_management.display_profile;/etc/icc_profile.icm

* mpv + youtube-dl

    alias yy="mpv --really-quiet --volume=50 --autofit=30% --geometry=-10-15 --ytdl --ytdl-format='mp4[height<=?720]' -ytdl-raw-options=playlist-start=1"

    alias dl-a='youtube-dl -x -f bestaudio  --add-metadata --embed-thumbnail --download-archive --prefer-free-formats -i --output "%(title)s.%(ext)s"'

    # From reddit
    ```
        ;# SINGLE AUDIO
        alias yta='youtube-dl -4icvwxo "%(title)s.%(ext)s" --audio-format mp3 --audio-quality 0 --netrc "$(xclip -selection clipboard -o)"'

        ;# MULTIPLE AUDIOS (playlist)

        alias ytam='youtube-dl -4icvwxo "%(playlist_index)s.%(title)s.%(ext)s" --playlist-reverse --audio-format mp3 --audio-quality 0 --netrc "$(xclip -selection clipboard -o)"'

        ;# SINGLE AUDIO AND KEEP VIDEO

        alias ytak='youtube-dl -4ickvwxo "%(title)s.%(ext)s" --audio-format mp3 --audio-quality 0 --netrc "$(xclip -selection clipboard -o)"'

        ;# SINGLE VIDEO

        alias ytv='youtube-dl -4icvwo "%(title)s.%(ext)s" --netrc "$(xclip -selection clipboard -o)"'

        ;# MULTIPLE VIDEOS (channel or playlist)

        alias ytvm='youtube-dl -4icvwo "%(playlist_index)s.%(title)s.%(ext)s" --playlist-reverse --netrc "$(xclip -selection clipboard -o)"'

    If you only want audio (with meta tags and thumbnail embedded):

        youtube-dl.exe -i --extract-audio --audio-quality 256K --audio-format mp3 --embed-thumbnail --add-metadata <URL_HERE>

    For full video (best quality, with meta tags and thumbnail embedded):

        youtube-dl.exe -i --all-subs --embed-subs --embed-thumbnail --add-metadata --merge-output-format mp4 --format bestvideo[ext=mp4]+bestaudio[ext=m4a] <URL_HERE>

    Another:
        youtube-dl.exe -i --all-subs --embed-subs --embed-thumbnail --add-metadata --merge-output-format mp4 --format bestvideo[ext=mp4]+bestaudio[ext=m4a] <URL_HERE>
        youtube-dl.exe -i --all-subs --embed-subs --embed-thumbnail --add-metadata --merge-output-format mkv --format bestvideo+bestaudio [url]


    ```

    i3wm: for_window [class="(?i)mpv"] floating enable

    YT: pop-up mode: https://www.youtube.com/watch_popup?v=CDsNZJTWw0w

    # We want to force hardware video acceleration on Sway/Wayland
    ```
    hwdec=vaapi
    gpu-context=wayland
    ```

    Setup ICC Profile
    ```
    icc-profile=/etc/icc_profile.icm
    # Set below to correct value if MPV complains about contrast in ICC profile
    # icc-contrast=1500
    ```

    Possibly use --target-trc --target-prim if no ICC profile?

    YTDL Options example:
    ```
    ytdl-format='(bestvideo[height<=?1440][fps<=?60]/bestvideo)+bestaudio[acodec=opus]/bestaudio[acodec=vorbis]/bestaudi[acodec=aac]/bestaudio)'
    ytdl-raw-options=playlist-start=1
    ```

    Higher quality:
    ```
    profile=gpu-hq
    ```
    Consider looking into (scale=ewa_lanczossharp, dscale=ewa_lanczossharp, cscale=ewa_lanczossharp)
    And:
    interpolation=yes
    blend-subtitles=yes
    video-sync=display-resample
    tscale=oversample

    (Note we can copy over all the config files, but this is optional)
    $ cp -r /usr/share/doc/mpv ~/.config
    # rm useless files
    $ vim ~/.config/mpv/mpv.conf

    * https://github.com/TheAMM/mpv_thumbnail_script


* xdg-mime default org.gnome.Evince.desktop application/pdf
* xdg-mime query default application/pdf
> org.gnome.Evince.desktop

* More: https://terminalsare.sexy/

## Backup

* Full-disk backup (dd requires encryption (boot partition). Is backup consistent?)
* BTRFS Backups
    * Snapshots (can even mount and login into snapshot)
    * "Send" to external BTRFS-formatted drive.
* Partial, incremental disk backup (borg-backup).
    * vs DejaDup (GUI), duplicity (CLI)?
* TBD: Cloud backup. Spideroak?

This gives:

* Full disk image, but does it work? Stored where?
* Local BtrFS backups to restore single files, or revert an update.
* External BtrFS backups in case device fails.
* External Borg simple backup in case the others fail to restore.
* Cloud backup...?

## Future

* The Dolby Vision (88% Adobe RGB) display. Video players. Videos that make use of it. What apps support it?
* HDR???
* IR eye-tracker? Does not come with IR.
* Fingerprint reader? What can we use it for? How do we integrate it? Not currently supported.

## Other hardware

* Got: RJ-45 to proprietary port adapter works fine.
* HDMI <-> HDMI. (Works fine.)
* USB(?)/Thunderbolt Type-C (!) <-> DisplayPort - works fine.
* Need update: OS/Arch Linux Backup USB - essential.
* 2.5" backup hard drive?
* Waiting: Ultimate Hacking Keyboard.
