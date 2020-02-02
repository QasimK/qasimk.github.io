---
layout: default-post
title:  "Playing my old Wii Games Again on the PC"
tags:   wii gaming emulator dolphin
githubCommentIssueID: 18
---

The Nintendo Wii is my favourite game console because of its innovative controllers. While *Breath of the Wild* is absolutely stunning on the Nintendo Switch, I miss *Skyward Sword*'s use of the motion controller. It's *the* reason I'm looking forward to VR games: the ability to actually use your entire body to play instead of just tapping buttons.

It's possible to play pretty much all of your Wii games on a PC now. It can be a little bit inconvenient to keep the 2006 Wii plugged-in ready to go all the way here in 2020, especially with the its use of older video cables[^speakers]. The [Dolphin Emulator][dolphin-site] is a great solution to reducing the number of components you have to manage. Perhaps more significantly, it allows you to play the games at 1080p @ 60fps (and better) rather than ~480p @ 30fps! That resolution and frame rate can be disconcerting.

{% include blog-inline-video.html
    title="Mario Kart Wii playing on a PC"
    video="2020-02-02-wii-mario-kart.mov"
    poster="2020-02-02-wii-mario-kart.jpg"
    caption="Playing Mario Kart Wii on my projector, with the Dolphin Bar at the top."
    width=1080
    height=720
%}

## Dolphin

It's a cross-platform emulator[^android], and *almost* straightforward to set up. The [Dolphin Wiki][dolphin-wiki] contains most of the information you need, but the [Dolphin Forums][dolphin-forums] contain additional user guides and resources.

Assuming you don't know what a DVD drive is any more, you'll want to obtain ISOs or the losslessly-compressed alternatives file formats: WBFS, GCZ or cISO/CSO. The Dolphin Wiki has a page on getting ISOs from your game discs using the Wii.

Once you have the game files, you just can drop them all into a single folder then point Dolphin to that folder, and it will pick them all up! The setting for this is in Config > Paths.

Here are some resources if you are interested in the differences between `.iso`, `.wbfs`, `.gcz`, `.ciso`, `.gcm` (all supported), and `.wia` (not supported by Dolphin in 2020): [1a][formats-1a], [1b][formats-1b], [2a][formats-2a], [2b][formats-2b], [2c][formats-2c], [2d][formats-2d], [3][formats-3]. Ultimately, it doesn't really make a difference!

The Game ID and PAL/NTSC variants of the same game can be significant when it comes to game modifications. Once added to Dolphin, the Game ID can be found by: Right-Click the Game > Properties > Info.

## The Game Controllers

Dolphin supports a variety of inputs including the original Wiimotes (Plus) + Nunchuks, the Balance Board, GameCube controllers, keyboard and mouse, and other standard controllers.

It's possible to play even Super Mario Galaxy with a standard controller by additionally using the mouse as the Wiimote pointer. In addition, Dolphin has MotionPlus emulation making it possible to use the pointer to emulate the motion sensor. While, I started with *Logitech's F710 Game Controllers*, I never got very far because manually configuring the key maps was driving me crazy.

To save my sanity, I decided to get the WiiMotes that I already had working.

The original sensor bar is merely a passive infrared-light emitter (IR emitter), which is powered via a proprietary cable. It is possible to [adapt the proprietary connector][convert-sensor] into a USB connector. In addition to this, the Wiimotes are connected via Bluetooth. Therefore, you don't need much more than just your original equipment, but I had two issues with this.

Firstly, adapting the connector sounded just a tiny bit dangerous. An alternative is a cheap passive IR emitter, either battery-powered or USB-powered. Battery-powered may be particularly convenient for certain set-ups where your PC is not near your display (e.g. projectors).

Secondly, my computer didn't even have Bluetooth. It's possible to purchase a simple Bluetooth adaptor, but there could be compatibility issues (people have encountered these due to problems with their Bluetooth hardware or software).

I decided to get the *MayFlash W010 Dolphin Bar - Wireless Wii Remote Sensor for USB*, a combined IR emitter + Bluetooth adapter. It worked out of the box immediately. It's been out many years so a [firmware update][mayflash-firmware] is unlikely to be necessary. I went through the effort anyway, but the firmware was up-to-date. I combined this with a high-quality five meter USB extension to reach the front position.

The Dolphin Bar has a few additional features, so this [cheat-sheet and instructions booklet][dolphinbar-cheatsheet] may be handy.

## Further Game Improvements

### HD Textures

It's possible to increase the texture resolution with [**custom textures**][forum-custom-textures]. These should be placed in Dolphin's user directory under `Load/Textures/[Game ID]/`.

For example, there is a [Mario Kart Wii HD Remaster][mario-kart-wii-hd] project. This is mentioned in the game's Wiki page. However, the front-page doesn't always have the latest download because sometimes other people make further improvements while the thread owner is MIA. For Mario Kart Wii, there are additional improvements on [Page 5][mario-kart-hd-pg-5].

Similarly with Super Mario Galaxy 1 & 2. As of early-2020, [BigHead's packs][smg-bighead] were the latest improvements ([direct link][smg-bighead-direct-link]). The release notes for these updates can be very hard to track down as they are not on the front-page.

At the end of 2018, Dolphin released [Resource Packs][resource-packs], which is an alternative method to install texture packs.

### 60+ FPS

Further, it's possible to increase the frame-rate, usually from **30 FPS to 60 FPS**. If instructions are not on the game's wiki page, then the [60 FPS master list][60-fps-master-list] is the place to go. This is done with "AR Codes" which can be enabled after adding them to the game: Right-Click the Game > Properties > AR Codes.

{% include blog-inline-image.html
    img="2020-02-02-wii-ar-codes.png"
    title="Dolphin GUI configuration for AR Codes"
    caption="Configuring Mario Kart Wii to run at 60 FPS."
    width=574
    height=618
%}

For example, with Mario Kart Wii it's possible to [lift the 30 FPS limit][mario-kart-wii-60-fps] for split-screen multiplayer to match the 60 FPS limit of the single-player mode.

Be aware that PAL and NTSC game versions may use different codes.

### Per-Game Overrides

Sometimes a particular game will not perform very well. In these cases, the settings for that particular game can be overridden. I found a [forum thread on gameini settings][forum-game-overrides] to be useful. To access the game overrides: Right-Click the Game > Properties > Game Config > Editor > User Config.

{% include blog-inline-image.html
    title="Dolphin GUI configuration to override game settings"
    img="2020-02-02-wii-game-override.png"
    caption="Overriding the video settings of Super Mario Galaxy 2 because my PC just cannot handle it!"
    width=563
    height=618
%}


### Save Packs

A save pack can be very useful to be able to unlock all aspects of a game without paying through it again. For example, it can be used to play all characters, vehicles, and maps in multiplayer Mario Kart Wii.

### Ishiiruka

Finally, there exists [Ishiiruka][ishiiruka]. A fork of Dolphin with significant new graphical capabilities, modifications for compatibility with older machines, and other additional features. Some of the new capabilities require special Texture Packs to make use of them. Since it's a fork, and seriously lacks a usage guide, I haven't touched it.

## Conclusion

Dolphin is wonderful.

---

[^speakers]: RCA/SCART/Component, what are these things!? In particular for me, my 5.1 speaker system is only connected to the PC, so by using the PC I can continue to avoid getting an AV receiver.
[^android]: Dolphin even works on Android.


*[WBFS]: Wii Backup File System
*[WIA]: Wiim's ISO Archive
*[cISO]: Compact ISO (AKA CSO)
*[CSO]: Compact ISO (AKA cISO)
*[GCZ]: GameCube Zip
*[GCM]: GameCube (ISO)
*[AR]: Action Replay


[dolphin-site]: https://dolphin-emu.org/ "The Dolphin Emulator's Official Website"
[dolphin-wiki]: https://wiki.dolphin-emu.org/
[dolphin-forums]: https://forums.dolphin-emu.org/
[formats-1a]: https://www.reddit.com/r/WiiHacks/comments/1xj63f/the_most_common_wii_disc_formats_in_a_glimpse/
[formats-1b]: https://i.imgur.com/fGn0BXA.png
[formats-2a]: https://wit.wiimm.de/info/iso-images.html
[formats-2b]: https://wit.wiimm.de/info/wia.html
[formats-2c]: https://wit.wiimm.de/info/
[formats-2d]: https://gbatemp.net/threads/wia-wii-iso-archive.250617/
[formats-3]: http://emulation.gametechwiki.com/index.php/Save_Disk_Space_for_ISOs#GameCube_.2F_Wii
[wiimote-plus-workarounds]: https://forums.dolphin-emu.org/Thread-emulated-motion-plus-unofficial
[convert-sensor]: https://forums.dolphin-emu.org/Thread-how-to-convert-nintendo-wii-sensor-bar-to-usb-sensor-bar "How to convert the Nintendo Wii Sensor Bar to a USB Sensor Bar"
[mayflash-firmware]: http://www.mayflash.com/Support/Download/ "The official firmware update page for the Dolphin Bar"
[dolphinbar-cheatsheet]: https://imgur.com/a/LBagg "A cheat-sheet for the Dolphin Bar created by Denilson Figueiredo de Sá"
[forum-custom-textures]: https://forums.dolphin-emu.org/Forum-custom-texture-projects
[mario-kart-wii-hd]: https://forums.dolphin-emu.org/Thread-mario-kart-wii-hd-remaster
[mario-kart-hd-pg-5]: https://forums.dolphin-emu.org/Thread-mario-kart-wii-hd-remaster?page=5
[smg-bighead]: https://forums.dolphin-emu.org/Thread-super-mario-galaxy-1-hd-texture-mod?pid=477262#pid477262
[smg-bighead-direct-link]: https://www.mediafire.com/folder/1t1kwxpt6leqe/Textures_Super_Mario_Galaxy
[60-fps-master-list]: https://forums.dolphin-emu.org/Thread-60-fps-master-list
[mario-kart-wii-60-fps]: https://forums.dolphin-emu.org/Thread-game-modification-60-fps-hacks-and-patches?pid=416618#pid416618
[ishiiruka]: https://forums.dolphin-emu.org/Thread-unofficial-ishiiruka-dolphin-custom-version
[forum-game-overrides]: https://forums.dolphin-emu.org/Thread-unofficial-howto-using-gameini-settings-per-game
[resource-packs]: https://dolphin-emu.org/blog/2019/02/01/dolphin-progress-report-dec-2018-and-jan-2019/#50-9217-implement-resource-packs-by-spycrab
