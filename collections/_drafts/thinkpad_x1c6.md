---
layout: default-post
title:  "The ThinkPad X1 Carbon 6th Gen (2018)"
tags:   linux laptop
githubCommentIssueID:
---

I settled on a ThinkPad because of their generally good Linux support, and on the
X1 Carbon line because of the slight weight and size improvements more than anything else.

This is an incredibly small and lightweight 14" laptop.

I'm generally happy with the laptop. I'm going to outline and review the hardware
in this article, and, in a separate article, how I set it up with Arch Linux.

Firstly, a collection of useful links:

* [The Fountain of Knowledge That Keeps Giving, The Arch Wiki Page])(https://wiki.archlinux.org/index.php/Lenovo_ThinkPad_X1_Carbon_(Gen_6))
* [Notebookcheck's review](https://www.notebookcheck.net/Lenovo-ThinkPad-X1-Carbon-2018-WQHD-HDR-i7-Laptop-Review.284682.0.html).
* [Throttling Fix & Undervolting](https://github.com/erpalma/throttled); consider -100mV
* [UEFI Drivers](https://pcsupport.lenovo.com/gb/en/products/laptops-and-netbooks/thinkpad-x-series-laptops/thinkpad-x1-carbon-6th-gen-type-20kh-20kg/downloads)
* [Data Sheet](https://static.lenovo.com/shop/emea/content/pdf/ThinkPad/XSeries/Lenovo%20X1%20Carbon%20_DS_2018_EN_v1.pdf)
* [Maintenance Manual](https://download.lenovo.com/pccbbs/mobiles_pdf/x1_carbon_6thgen_hmm_en.pdf)
* [User Guide](https://download.lenovo.com/pccbbs/mobiles_pdf/x1_carbon_6th_ug_en.pdf?linkTrack=PSP:ProductInfo:UserGuide)
* [Product Page](https://www.lenovo.com/gb/en/laptops/thinkpad/x-series/ThinkPad-X1-Carbon-6th-Gen/p/22TP2TXX16G)

We may want to be aware of the [Lenovo Superfish incident][superfish], and a [few
other incidents][lenovo-incidents] that may cause us to mistrust Lenovo. However,
I believe these did not affect the business line of laptops (certainly Superfish
did not).


## Hardware

Let's take a detailed look at the hardware:

* Intel i7-8550U CPU (Kaby Lake Refresh, 14nm late-2017).
    * 4-core, 8 threads.
    * 1.8 Ghz - 3.7 Ghz (4-core turbo) - 4.0 Ghz (two-core turbo).
    * VT-x, VT-d (both for virtualisation), and AVX2.
    * 23 W continuous TDP, and 29 W turbo TDP. Possibly 15 W on Linux.
    * No IPC improvements over 7th Gen processors.
* [Intel UHD 620 integrated GPU][uhd620].
    * Hardware-accelerated video:
        * Supports 8/10-bit and 4k HEVC/H.265 Main10 and VP9 Profile2 codecs (encode & decode, except only VP9 Profile0 encode.)
            * VP9 is useful for YouTube.
        * MPEG-2/H.262 1080p & MPEG-4/H.264 4k encode/decode
        * JPEG encode/decode 16x16k
        * HDCP 2.2 :/
    * Very bad for gaming, especially at 1440p... Even though half the chip's area is devoted to the GPU!
* 16GB Single DIMM LPDDR3 2133 Mhz RAM
* 512GB Opal 2 (SED) TLC PCIe SSD (Samsung SM981/PM981).
* 57 Wh battery.
    * With "RapidCharge": 0-80% in one hour.
* "Dolby Premium Audio" speakers.
    * Downward firing at the front-bottom of the laptop
* 360° Noise-cancelling Dual Array Far Field Microphones.
    * At the top of the screen, near the camera.
* Intel Dual-Band Wireless-AC 2 x 2, Bluetooth 4.2 [8265/8275 Rev 21]. (Wireless LAN is upgradeable).
    * [Upgradable to 9260][upgrade-wireless-9260]:
        * 9260 Wi-Fi supports 160Mhz channels (~1.73 Gb/s vs 867 Mb/s), in practise this makes no difference.
        * 9260 offers Bluetooth 5.0.
            * (Longer range OR speed).
            * Play on two devices simultaneously.
            * Audio may be better with aptX (but this may not be supported?!).
* 2 x USB 3.0.
* 2 x Thunderbolt 3 (USB Type-C).
    * Either one can be used for charging.
    * [An eGPU should work fine.][egpu-example]
* SD Card Reader (SD, MMC, SDHC, SDXC).
    * Without CPRM (Content Protection for Recordable Media).
* 1 x HDMI port and proprietary docking station.
* Native Ethernet support via dongle. Intel I219-V (Rev 21).
* 720p camera with manual shutter.
* The [WWAN slot can used as a second, smaller M.2-2242 Drive][wwan-storage-drive].
    * M.2 Port information: https://www.laptopmain.com/laptop-m-2-ngff-ssd-compatibility-list/
    * It is Socket 2 (PCIe 2 lane.)
* 14" 1440p HDR (500 nits) glossy IPS with Dolby Vision.
* 323.5mm x 217.1mm x 15.95mm, 1.13 kg.

### Connectivity and Ports

Left Side:
    * 2 x USB-C Thunderbolt + Power Connector
    * Ethernet extension connector (for dongle)
    * (Docking Station Connector)
    * USB 3.0
    * HDMI

Right Side:
    * Kensington Lock
    * USB 3.0 (always-on charging)
    * Headphones/Microphones combo (3.5 mm, 4-pole plug)

Back Edge:
    * SD/Sim - pull out tray, no pin required

Underside:
    * The holes are for positioning with the docking station.
    * There is an emergency reset hole, if you cannot turn the laptop off using the power button.
        * To use it: first remove the power cable, then insert a paper clip.

Top of Display:
    * The camera. Note that a white light will indicate that it is "in-use"
    (On the other hand, red lights on the F1 & F4 keys indicate that the speaker/microphones are muted.)

Up to two external displays may be connected as the UHD 620 iGPU supports a
maximum of three independent displays. The maximum external display resolutions are:
    * 5120 x 2280 @ 60 Hz using ONE USB-C connector (not quite 5k!)
    * 4096 x 2304 @ 60 Hz using BOTH USB-C connectors (2 x 4k monitors)
    * 4096 x 2160 @ 30 Hz using HDMI 1.4a
    * Miracast is not supported.

## Upgradeability

* The M.2 slot NVME PCIe SSD can be upgraded.
* The WLAN (WiFi/Bluetooth) card can be upgraded.
* The WWAN card can be replaced with one that works under Linux.
* The WWAN card slot can be used for a second M.2 storage drive.
* The battery can be replaced.

The single-DIMM RAM module cannot be replaced because it is soldered on.

## Keyboard

Some of the keyboard keys work out-of-the-box on Linux:

* Keyboard backlight adjustment.
* WiFi/Bluetooth software on/off.

Others do not:

* Speaker and Microphone volume adjustment and mute.
* Display backlight brightness adjustment.
* Second display extend/mirror (You cannot blame Lenovo for this).
* "Cog"
* "Keyboard"
* "Star"
* "Print Screen Snip"

## My Thoughts

### The Good

* 2xDPI screen is fantastic.
* The microphone picks up your voice from a considerable distance.
* Almost all of the hardware works great on Linux.

### The Bad

* The glossy screen handles reflections poorly compared to a matte screen, *and*
the 1440p HDR screen is only available as a glossy option.
* The fingerprint sensor does not work on Linux (this would be ugly if Linux
had any kind of support for this feature.)
* The micro SD card reader drains power?
* The screen brightness adjustment keys do not work out-of-the-box.
* The speaker/microphone audio keys do not work out-of-the-box.
* The speaker audio quality is not "good".

### The Ugly

* The left side USB Type-C port is unusable with the RJ-45 Ethernet adaptor
plugged in at the same time because they physically do not fit alongside each other.
* The WWAN module is not supported by Lenovo on Linux - do not bother with
this hardware model.
    * However, there *is* a workaround if you get a particular, compatible WWAN chip.
    * In general, I would suggest tethering to your phone.

## The Future

In general, while, naturally, I would like improvements to all aspects of the laptop
such as the CPU, GPU, RAM, weight, and size, there are some particular improvements
that I think are *feasible*.

I believe the following hardware changes should be implemented on the next the X1 Carbon:

* The heat vents should be on the left side of the laptop, rather than on the right
which blows got air straight on to your mouse hand. Though, I also understand that
you don't want all the ports on the right side because the cables will conflict with the mouse.
* USB Type-C and Type-A ports each on *both* sides would make it easier to charge the laptop
in all situations.
* The audio quality of the speakers should be improved with deeper bass, and by moving
them to a forward-firing position at the top of the keyboard.
* A 3:2 aspect ratio screen would remove the large bezel at the bottom, and improve productivity.
* Improving the display's refresh rate to at least 120 Hz would improve the general experience.
* The entire surface of the trackpad should be depressible (to click) as it is currently painful
to use the trackpad in this way.
* A side-facing SD Card reader would be more usable than the current rear placement.
* A better iGPU such as Intel's Iris Pro line would be wonderful, particularly as
browsers become GPU accelerated.
* It would be nice if the RAM was dual-slot, user-replaceable, and up to at least 32GB.
* The arrow keys should be slightly larger and better separated from the rest of
the keyboard to distinguish them.
* An ambient light sensor to automatically adjust the brightness of the screen.

It seems that Intel will not be making significant improvements to their 9th Gen
processors (they will have the same IPC and power consumption), so it will be
interesting to see what the 7th Gen X1 Carbon is like. At the moment, I do not
think it will offer any reason to upgrade.

[superfish]: https://en.wikipedia.org/wiki/Superfish
[lenovo-incidents]: https://www.makeuseof.com/tag/security-failings-demonstrate-avoid-lenovo/
[wwan-storage-drive]: https://www.reddit.com/r/thinkpad/comments/9s9rnj/secondary_m2_ssd_in_x1_carbon_6th_gen/
[uhd620]: https://en.wikichip.org/wiki/intel/uhd_graphics/620
[upgrade-wireless-9260]: https://www.reddit.com/r/thinkpad/comments/8813ub/x1_carbon_whitelist/dwrgyjc/
[egpu-example]: https://egpu.io/forums/builds/thinkpad-x1-carbon-6th-gen-with-aorus-gaming-box-1080/
*[IPC]: Instructions Per Clock
*[SED]: Self-Encrypting Drive
*[WWAN]: Wireless-WAN (4G Mobile Modem)
