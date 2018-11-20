

Let's clarify some terminology I might use:

* Active attack: manipulation of your device, you use it, they win
* Passive attach: they take/copy your device in some way. i.e. no action required on your part.

Possible attacks:

* Malicious software running under your user. This is probably the most likely. Unfortunately Linux is awful here.
* Your computer is stolen & turned off.
* Your computer is actively running.

# Hardware

Physical access is the end.

* Disable DMA (Direct Memory Access). This means Thunderbolt and PCIe.
* USB-based attached vectors (BadUSB)
* SED-based encryption may not actually be secure.
* UEFI password may not actually be secure.
* Intel Management Engine (IME) and AMD's equivalent (PSP) have, in my opinion, beyond reasonable doubt, at least one critical security vulnerability.
* CPU flaws (Spectre/Meltdown/other side-channel attacks). Hyper-threading.

# UEFI

* Booting into another OS and reading your disk.
* [Strong UEFI password]

# Bootloader

* Altering the bootloader to run init=/bin/sh and gaining full access - need password.
* [Either SecureBoot or encrypt /boot with strong Password.]

# FDE

* [Strong LUKS password, can be same as bootloader (?).]

# Linux

* Switching virtual terminals (TTYs) Ctrl-Alt-Fn may not actually switch the terminal.
* SELinux and AppArmor (a little insane to use I think).
* [Strong Root password] (same as bootloader???)
* [Firewall]
* [Forward Root Mail?]
* [Auto-lock/Suspend-lock. Avoid suspending anyway.]
* [Logwatch?]
* [rkhunter - root kit hunter? IDS - tripwire?]

# User

* Xorg key-logger is trivial - can read off sudo password.
* Xorg - full access to copy-and-paste buffer.
* Xorg - full access to screen.
* Wayland has a key-logger too (possibly limited to user processes) - $LD_PRELOAD.
* Replacing sudo command with malicious program. (Alias, Home $PATH, Shell infection waiting on sudo access)
* Running GDB/debugger and reading memory of other programs.
* [Strong User Password]

# Applications

* [Firejail: Firefox]
* [Firefox: Not covered. Important because browser is used a lot.]
* [PGP, 2FA (TOTP/U2F) device: Not covered. Git.]
* [Password Manager, avoid browser integration?]

# Summary

* Admin-level password for UEFI, Bootloader, Disk Encryption, and root
* User-level password for user account, sudo and password manager(?).
* But I would distinguish UEFI, SED passwords (unverified hardware) from Bootloader, LUKS and root passwords (OSS).


[1]: https://github.com/lfit/itpol/blob/master/linux-workstation-security.md
