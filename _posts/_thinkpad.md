# Setting up Arch Linux on a Lenovo X1 Carbon (6th Gen 2018)

* https://kozikow.com/2016/06/03/installing-and-configuring-arch-linux-on-thinkpad-x1-carbon/
https://www.notebookcheck.net/Lenovo-ThinkPad-X1-Carbon-2018-WQHD-HDR-i7-Laptop-Review.284682.0.html
https://medium.com/@shazow/my-computer-is-my-home-5a587dcc1d76
* eGPU: http://pocketnix.org/posts/eGPUs%20under%20Linux%3A%20an%20advanced%20guide
* Arch Wiki this stuff !! https://mensfeld.pl/2018/05/lenovo-thinkpad-x1-carbon-6th-gen-2018-ubuntu-18-04-tweaks/
    Covers Touchpad/Trackpoint, Throttling, Battery thresholds,

Warning: Lenovo superfish incident (https://en.wikipedia.org/wiki/Superfish). But did not affect business laptops

Note: 20KG - touchpad and trackpoint do not work together. (NFC edition). Works fine with new kernel 4.17.
Note: Don't bother with mobile modem, it doesn't work. Tether to phone.

## Dealing with Windows

* Create a copy of Windows for re-sale.
* Shrink Windows Partition
* Disable Fast start-up (because?), Secure Boot
* Use UEFI because it may have slightly faster boot time.
* DD
* Create recovery image using Windows tool.
* Get serial key for use in Virtualbox.
* Upgrade BIOS.

## Power

* Suspend Issues?
* Disable... xyz
* Undervolt CPU - stress test performance.
* Which tool to set battery limits to preserve battery life. How-to automatically turn this on and off?
* Disable card reader due to bug?
* Thunderbolt BIOS assist mode save power?
* Power management throttling issues?
* Throttling issues?

## Security / BIOS

* Switch Ctrl/Fn
* Sleep vs Hibernate?
* BIOS HDD Password should set the encryption password on the SED SSD.
* DEK > AEK > Password chain https://us.community.samsung.com/t5/Memory-Storage/HOW-TO-MANAGE-ENCRYPTION-OF-960-PRO/m-p/152440/highlight/true#M644
* Confirmed by staff member https://forums.lenovo.com/t5/ThinkPad-P-and-W-Series-Mobile/Self-Encrypting-PCIe-NVMe-M-2-SSD-Password-in-the-BIOS-of-a-P70/m-p/3335879/highlight/true#M59930
* This should work across machines - need to test?!
https://support.lenovo.com/gb/en/solutions/migr-69621
* We use the SED/Opal password on the drive for performance.
* BIOS Supervisor vs user vs start-up password
* Disable thunderbolt as it allows for DMA (direct memory access). Can we keep the USB?
* Disable Intel Management Engine (remote access).
* Disable alternative boot media (change BIOS for when you want to use it). This prevents some attacks on SED SSD. https://www.blackhat.com/docs/eu-15/materials/eu-15-Boteanu-Bypassing-Self-Encrypting-Drives-SED-In-Enterprise-Environments.pdf
https://www1.cs.fau.de/filepool/projects/sed/seds-at-risks.pdf

## Desktop / Install

* Not Btrfs because I like my sanity
* SwayWM. 1.25x scaling turns 2560x1440 into 2048x1152, slightly more than 1080p.
* Flux with Sway/Wayland?
* WiFi. Use iwd (iwctl, iwd, iwmon). It's new.
* Input software for touchpad/trackpoint?
* Be sure to conform to XDG Base Directory Spec (2003), annoying.

## Ultimate Hacker's Keyboard

## Backup

* Full-disk backup.
* Partial, incremental disk backup

## Future

* The Dolby Vision (88% Adobe RGB) display. Video players. Videos that make use of it. What apps support it?
* IR eye-tracker?
* Fingerprint reader? What can we use it for? How do we integrate it? Not currently supported.

## Other hardware

* RJ-45 to proprietary port adaptor.
* HDMI <-> HDMI.
* USB(?)/Thunderbolt Type-C (!) <-> DisplayPort
* OS/Arch Linux Backup USB - essential.
* 2.5" backup hard drive?
* Ultimate Hacking Keyboard.
