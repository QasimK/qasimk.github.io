Note: 20KG - touchpad and trackpoint do not work together. (NFC edition). Works fine with new kernel 4.17 though.
Note: Don't bother with mobile modem, it doesn't work. Tether to phone.

My Model: 20KHCTO1WW

## Dealing with Windows

* Create a copy of Windows for re-sale.
* Setup Windows with a simple account (no network connection needed)
* Settings > Update & Security > Backup > Backup and Restore (Windows 7)
* Create a system image backup ("WindowsImageBackup").
* This backups up all drives on the image and allows you to do a full restore.

* Create Recovery Drive
* Settings > Recovery (Advanced Recovery Tools) > Create Recovery Drive

* Get the product key: `wmic path SoftwareLicensingService get OA3xOriginalProductKey`

* Note that Windows can "start fresh".

* Disable Fast start-up (because?), Secure Boot
* Use UEFI because it may have slightly faster boot time.
* DD


### Upgrade BIOS

* Get your BIOS Version: `wmic bios get smbiosbiosversion`
    (N23ET47W; 1.22)
* Note that Lenovo has a bootable CD.
* 1.25: https://pcsupport.lenovo.com/gb/en/products/laptops-and-netbooks/thinkpad-x-series-laptops/thinkpad-x1-carbon-6th-gen-type-20kh-20kg/downloads/ds502281
* Might want to skip 1.25 due to thermal throttling issues


## Security / BIOS

* Config
    * Network
        * Wake On LAN: AC Only (default - does not work when HDD Password set?)
        * Consider "Wireless Auto Disconnection" (battery life)
        * UEFI IPv4/IPv6 Network Stack: Disabled (security)
    * Keyboard / Mouse
        * Fn and Ctrl Key Swap: Enabled (retain muscle memory between keyboards)
        * Fn keys default: Enabled (retain muscle memory between keyboards)
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
TEST: S0i3 disable; S3 enable.
TEST: Undervolt CPU.

* TODO: Disable card reader due to bug?
* TODO: Thunderbolt BIOS assist mode save power (while in sleep)?
* Lenovo implemented S0i3 sleep instead of the normal S3 sleep (suspend to RAM): https://news.ycombinator.com/item?id=17551286
    * This is for "Windows Modern Standby", which allows the device to wake-up to perform background activities.
* Suspend Issues?
* Disable... xyz
* Undervolt CPU - stress test performance.
* Which tool to set battery limits to preserve battery life. How-to automatically turn this on and off?
* Power management throttling issues?
* Throttling issues?
* TLP to tweak, and `powertop` to monitor
    * https://linrunner.de/en/tlp/docs/tlp-linux-advanced-power-management.html
    * tlp-stat
    * tpacpi-bat (optional dependency of tlp)
    * 50-60% thresholds
        * 65-75% is optimum (https://www.youtube.com/watch?v=AF2O4l1JprI)
        * thinkpad says 40-50 https://support.lenovo.com/us/en/solutions/ht078208
    * tlp fullcharge for one-off max-charge
    * https://linrunner.de/en/tlp/docs/
* https://github.com/teleshoes/tpacpi-bat

## Desktop / Install

Getting key combos: evtest, xev, showkey

* Do a UEFI install because it is faster.
* https://gist.github.com/artizirk/c5cd29b56c713257754c
* Grub faster & boot menu: https://wiki.archlinux.org/index.php/GRUB#Dual-booting
* SwayWM:
    * 2x Scaling
    * i3blocks (cp /etc/i3blocks.conf -> ~/.config/i3blocks/config)

    * font pango: DejaVu sans Mono, 8
      output e-DP-1 scale 2
      set $term termite -e /usr/bin/fish
      set $menu dmenu_run
      bindsym XF86AudioLowerVolume exec pactl -- set-sink-volume @DEFAULT_SINK@ -5%
      bindsym XF86AudioRaiseVolume exec pactl -- set-sink-volume @DEFAULT_SINK@ +5%
      bindsym XF86AudioMute exec pactl -- set-sink-mute @DEFAULT_SINK@ toggle

      bindsym XF86MonBrightnessDown exec ...
      bindsym XF86MonBrightnessUp exec ...

      (pactl list short sinks/sources)

    * Note alacritty should be released with scrolling soon.
    * urxvt -fn "xft:Deja Vu Sans Mono:pixelsize=24"
    * ~/.config/termite/config (copy default file first.)
        [options]
        font =  Deja Vu Sans Mono 16
        scrollback_lines = 100000

* Redshift should work with Sway/Wayland.
* WiFi. iwd (iwctl, iwd, iwmon) works fine (now).
    * Note that iwd solves persistence problem with wpa_supplicant (i.e. without additional software `wpa_supplicant` forgets your network), and is simpler to use.
    * sudo iwctl
    * Do not use at the same time as NetworkManager service as they conflict.
    * Use dhcpcd
    * rfkill
* TODO: Trackpoint - change sensitivity.
* Be sure to conform to XDG Base Directory Spec (2003), annoying.
* Intel GPU Usage: https://medium.com/@niklaszantner/check-your-intel-gpu-usage-via-commandline-11196a7ee827
* Suspend & Resume processes (Unix)
    * SIGSTOP & SIGCONT
* Time Sync
    * Use Chrony

### Custom Repository

https://disconnected.systems/blog/archlinux-repo-in-aws-bucket/

    mkdir -p ./chroots
    mkarchroot -C /etc/pacman.conf ./chroots/root base-devel
    makechrootpkg -cur ./chroots


### Keyboard + Touchpad

https://faq.i3wm.org/question/3747/enabling-multimedia-keys.1.html
(xorg-xbacklight will not work on Wayland. Try acpilight https://wiki.archlinux.org/index.php/Backlight#Backlight_utilities)

The backlight (Fn + space bar) works fine. Bluetooth and WiFi (F10, F8) are fine.

* Manual: F1,2,3 (Audio volume)
* Manual: F4 (Microphone) - Light does not work.
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


### Misc

* mpv + youtube-dl

## Ultimate Hacker's Keyboard

## Backup

* Full-disk backup (dd requires encryption. Is backup consistent?)
    * BTRFS Backup?
* Partial, incremental disk backup (borg).

## Future

* The Dolby Vision (88% Adobe RGB) display. Video players. Videos that make use of it. What apps support it?
* IR eye-tracker? Does not come with IR.
* Fingerprint reader? What can we use it for? How do we integrate it? Not currently supported.

## Other hardware

* RJ-45 to proprietary port adaptor.
* HDMI <-> HDMI. (Works fine.)
* USB(?)/Thunderbolt Type-C (!) <-> DisplayPort
* OS/Arch Linux Backup USB - essential.
* 2.5" backup hard drive?
* Ultimate Hacking Keyboard.
