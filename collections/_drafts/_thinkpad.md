# Setting up Arch Linux on a Lenovo X1 Carbon (6th Gen 2018)

* https://github.com/ejmg/an-idiots-guide-to-installing-arch-on-a-lenovo-carbon-x1-gen-6
* https://kozikow.com/2016/06/03/installing-and-configuring-arch-linux-on-thinkpad-x1-carbon/
* Not x1 carbon: https://ticki.github.io/blog/setting-up-archlinux-on-a-lenovo-yoga/
* Laptop info: https://news.ycombinator.com/item?id=17551286
* Laptop info: https://www.notebookcheck.net/Lenovo-ThinkPad-X1-Carbon-2018-WQHD-HDR-i7-Laptop-Review.284682.0.html
* https://medium.com/@shazow/my-computer-is-my-home-5a587dcc1d76
* eGPU: http://pocketnix.org/posts/eGPUs%20under%20Linux%3A%20an%20advanced%20guide
* Arch Wiki this stuff !! https://mensfeld.pl/2018/05/lenovo-thinkpad-x1-carbon-6th-gen-2018-ubuntu-18-04-tweaks/
    Covers Touchpad/Trackpoint, Throttling, Battery thresholds,
* Drivers: https://pcsupport.lenovo.com/gb/en/products/laptops-and-netbooks/thinkpad-x-series-laptops/thinkpad-x1-carbon-6th-gen-type-20kh-20kg/downloads

Warning: Lenovo superfish incident (https://en.wikipedia.org/wiki/Superfish). But did not affect business laptops
https://www.makeuseof.com/tag/security-failings-demonstrate-avoid-lenovo/



# Review

Sound? HDMI hot-plug?

Product: https://www.lenovo.com/gb/en/laptops/thinkpad/x-series/ThinkPad-X1-Carbon-6th-Gen/p/22TP2TXX16G
Data Sheet: https://static.lenovo.com/shop/emea/content/pdf/ThinkPad/XSeries/Lenovo%20X1%20Carbon%20_DS_2018_EN_v1.pdf
Maintenance Manual: https://download.lenovo.com/pccbbs/mobiles_pdf/x1_carbon_6thgen_hmm_en.pdf
User Guide: https://download.lenovo.com/pccbbs/mobiles_pdf/x1_carbon_6th_ug_en.pdf?linkTrack=PSP:ProductInfo:UserGuide
Downloads: https://pcsupport.lenovo.com/gb/en/products/laptops-and-netbooks/thinkpad-x-series-laptops/thinkpad-x1-carbon-6th-gen-type-20kh-20kg/downloads

## Hardware

TODO: Get specification from Linux..:

* Intel i7-8550U (Kaby Lake Refresh 2017) with Intel UHD 620 on-board graphics.
    * Hardware-accelerated video:
    * Supports 8/10-bit and 4k HEVC/H.265 Main10 and VP9 Profile2 codecs (encode & decode, except VP9 Profile0 encode.)
    * MPEG-2/H.262 1080p & MPEG-4/H.264 4k encode/decode
    * JPEG encode/decode 16x16k
    * HDCP 2.2 :/
    * https://en.wikichip.org/wiki/intel/uhd_graphics/620
* 16GB LPDDR3 2133 Mhz
* 512GB Opal 2 (SED) TLC PCIe SSD (Samsung). SM981/PM981.
* 57 Wh (with "RapidCharge" - whatever that means)
* Dolby Premium Audio?!
* 360* Noise-cancelling Dual Array Far Field Microphones (??) - at top near camera
* Intel Dual-Band Wireless-AC 2 x 2, Bluetooth 4.2 [8265/8275 Rev 21]. (Wireless LAN is upgradeable)
    * Upgrade to 9260: https://www.reddit.com/r/thinkpad/comments/8813ub/x1_carbon_whitelist/dwrgyjc/
* 2 x USB 3.0
* 2 x Thunderbolt 3 - 1 used for charging
    * eGPU should be fine: https://egpu.io/forums/builds/thinkpad-x1-carbon-6th-gen-with-aorus-gaming-box-1080/
* SD Card Reader (SD, MMC, SDHC, SDXC)
    * Without CPRM (Content Protection for Recordable Media)
* 1 x HDMI port and proprietary docking station.
* Native Ethernet support via dongle. Intel I219-V (Rev 21)
* 14" 1440p HDR (500 nits) glossy IPS with Dolby Vision
* 323.5mm x 217.1mm x 15.95mm, 1.13 kg

Left View:
    * 2 x USB-C Thunderbolt + Power Connector
    * Ethernet extension connector
    * (Docking Station Connector)
    * USB 3.0
    * HDMI

Right:
    * Kensington Lock
    * USB 3.0 (always-on)
    * Headphones/Microphones combo (3.5 mm, 4-pole plug)

Back:
    * SD/Sim - pull out tray, no pin required

Bottom:
    * The holes are for positioning with the docking station
    * There is an emergency reset hole, e.g. cannot turn off with power button (remove power cable, insert paper clip)

Top: F1, F4 light ON indicates it is muted
    Light on Camera = in-use

External Displays (maximum: 2 external displays as UHD 620 supports a maximum of three independent displays):
    * 5120 x 2280 @ 60 Hz using ONE USB-C connector (not quite 5k resolution)
    * 4096 x 2304 @ 60 Hz using BOTH USB-C connectors (2 x 4k monitors)
    * 4096 x 2160 @ 30 Hz using HDMI 1.4a
    * Miracast on some models (...)

## The good

* 2xDPI screen is great (if only Linux supported it well.)
* WiFi / Bluetooth hardware keyboard keys work.
* Backlight keyboard key works.

## The bad

* The glossy screen doesn't do reflections particularly well.
* The fingerprint sensor does not work :/
* The card reader drains power?
* Thunderbolt drains power by default?
* Screen brightness keys do not work out of the box!
* Audio keys do not work solely by hardware. [They are software media keys.]

## The ugly

* Left-side USB-C port is unusable with the RJ-45 adaptor plugged in due to spacing issues.
* Sleep support is awful out-of-the box (Si03 issues).
* Wireless-WAN (4G) is not supported on Linux.
