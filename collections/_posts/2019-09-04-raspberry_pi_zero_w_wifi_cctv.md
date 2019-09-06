---
layout: default-post
title:  "Using a Raspberry Pi to Show a CCTV Stream"
tags:   guide linux arch cctv raspberry-pi
githubCommentIssueID: 17
---

I wanted to be able to watch the live footage from security cameras at home on a TV. I learnt that the DVR the cameras connect to can stream the video feeds over the local network with a password-protected RTSP connection. I was able to set this up, eventually figure out the URLs, and view the streams on my PC using VLC media player.

Further research showed that this could be played using `omxplayer` on a Raspberry Pi, and that even the *Raspberry Pi Zero* should be handle the video with its hardware video-decoding. I thought this was perfect because this model is very small, very low-powered, and very cheap. Most TVs now have USB ports which can be used to power the Raspberry Pi.

Considering the *Raspberry Pi Zero* does not have any networking capability built-in, I decided to get the *Raspberry Pi Zero W* which has built-in Wi-Fi and Bluetooth, one micro-USB port to charge, one micro-USB OTG port, and one mini-HDMI port.

With this plan in mind, I purchased it with a mini HDMI adapter and HDMI cable. Originally, I intended to set up the RPi entirely on my PC, meaning I would not need to buy an adapter to plug a keyboard into it. This didn't quite work out for me... over many attempts... which lasted weeks on end...

However, I did manage to work out the issues eventually! This guide does the installation without connecting a keyboard or display to the RPi.

Be aware, the micro-USB ports are *very* close together. I was not able to fit a cheap micro-USB-to-USB adapter alongside the micro-USB charging cable. I literally had to file away the plastic on one side of the adapter.

In addition, my normal keyboard did not work with the *Raspberry Pi Zero W*. The LED lights lit up, but I could not type anything. A different wireless battery-powered keyboard worked fine, so the issue may have been related to powering the keyboard.

{% include blog-inline-image.html
    img="2019-09-04-tools.JPG"
    width=1600
    height=1600
    caption="The tools for the job including the mutilated microUSB adapter."
%}

## Installing Arch Linux ARM

In order to do a remote install of the *Raspberry Pi Zero W*, we will need:

* The RPi itself with USB power accessories, and
* A microSD Card for the RPi with a microSD Card Reader for your PC.

Once installed, we should be able to SSH in to the RPi without ever having to connect a keyboard or monitor to it. (Of course, for this project we will connect the RPi to a display later anyway to show the video stream.)

The basic installation is the same: <https://archlinuxarm.org/platforms/armv6/raspberry-pi>.

On top of this, we will set up the Wi-Fi so that when we turn the RPi on for the first time it will automatically connect.

### Configure the Wi-Fi network

Generate the configuration file with `wpa_passphrase <YOUR SSID> >> /etc/wpa_supplicant/wpa_supplicant-wlan0.conf`. The command will request the Wireless Password PSK.

```conf
network={
    ssid="SSID"
    #psk="PLAIN PASSWORD"
    psk="PSK"
}
```

The commented out plain password line, `#PSK`, can be removed.

### Automate the Wi-Fi connection

Enable the wireless service:

```console
$ ln -s /usr/lib/systemd/system/wpa_supplicant@.service /etc/systemd/system/multi-user.target.wants/wpa_supplicant@wlan0.service
```

We also need to enable a DHCP client to obtain an IP address for the RPi. We will use systemd's built-in DHCP client to avoid needing to install another client.

Create `/etc/systemd/network/25-wireless.network` with

```ini
[Match]
Name=wlan0

[Network]
DHCP=ipv4
```

### Fix the Raspberry Pi Zero W booting issue

In addition, the *Raspberry Pi Zero W* may not boot properly [without an HDMI display plugged in][hdmi-boot]. This caught me out for a very long time.

Edit `/boot/config.txt` with the following additional line

```ini
hdmi_force_hotplug=1
```

### We are now done and can now turn on the RPi

Now, we can move the microSD card to the RPi, connect the power, give it a minute to boot up, and SSH in from our PC.

[My PiServer book][piserver-book] has a plethora of additional notes on how to connect to, configure, secure and increase the lifespan of an RPi and its microSD card.

## Playing the Video Stream over the Network

For this part, we will need:

* A mini-HDMI cable connected to a monitor

The CCTV system outputs an RTSP video stream over the network. Most applications like VLC, MPV, and ffplay can play these streams.

We will use `omxplayer` on the RPi because it just works. Unfortunately, I ran into issues with MPV and ffplay and trying to output the video directly on to the framebuffer without the X11 window server running.

```terminal
# pacman -S --needed omxplayer
$ omxplayer "rstp://user:pass@host:port/path/subpath" --avdict rtsp_transport:tcp --no-osd --live --with-info --stats
```

Description of parameters:

* `--avdict rtsp_transport:tcp` was used because I experienced significant packet loss with the default UDP transport, which periodically caused the video to blur out.
* `--no-osd` removes some annoying logging output on the terminal.
* `--live` because this is a live stream - but I notice no difference...
* `--with-info` outputs some stream information before the video starts playing.
* `--stats` outputs ongoing information.

In addition, there is a  `--refresh` parameter which will change the output resolution and frame rate to match the video (apparently, but I notice no change). However, it is dangerous because if `omxplayer` does not exit gracefully (i.e. press `q` not `<CTRL>-c`), then the screen will just be black!

## Having Everything Just Work Out-of-the-Box

We can [configure systemd to automatically log a user in][systemd-autologin] on boot.

First, create a restricted user:

```console
$ useradd --create-home cctv
$ passwd --lock cctv
```

This will help protect the device despite automatically logging a user in.

Then, edit its `.bashrc` to immediately play the stream when the user logs in:

```sh
while true; do
    omxplayer "rstp://user:pass@host:port/path/subpath" --avdict rtsp_transport:tcp --no-osd --live --with-info --stats;
    sleep 1
done
```

This will also restart the video if there are any errors, such as any "network down" error.

Finally, override the [initial virtual console][arch-wiki-getty] configuration to log the user in automatically when the device starts; `systemctl edit getty@tty1`:

```ini
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin cctv --noclear %I $TERM
```

With this trio of changes, when power is connected to the RPi, the device will boot into Linux TTY1. This will immediately log the `cctv` user in without prompting for a password. Then, the user's bash initialisation will automatically start the video stream which will output via HDMI.

We note that we can always switch to another TTY to login if we need to do maintenance using `<CTRL> + <ALT> + <F2>`.

## Some Rough Edges

There are a few rough edges:

* It feels like the device takes an eternity (nearly a minute) from power-on to the stream playing, which comes down to how *slow* the *Raspberry Pi Zero W* is. This might be annoying or problematic if the USB port on the TV disables the power output when the TV is off.
* We will need to SSH in periodically to upgrade the system. Perhaps this could be automated?
* Automatically logging a user in and use `.bashrc` to play the stream *may* not be the most secure method. There are [alternatives using systemd][systemd-alternative].
* Connecting to a new Wi-Fi network is a little painful, but it can be done by plugging in a keyboard, or pulling out the SD card to edit it on your PC.
* The SD Card is not encrypted, leaving the Wi-Fi and RTSP stream credentials expose, and the device vulnerable to attack. In addition, considering how small the device is, it could easily be stolen. However, I think this is not an issue considering the usage of the device.

## Conclusion

Now we have a portable device requiring minimal maintenance that can be plugged in anywhere at home simply with an HDMI and a USB cable in order to view CCTV footage.

A bonus idea: create a keyboard shortcut to a script that pulls the stream up on your PC! This is mine:

```
#!/usr/bin/sh

(cvlc --no-osd --fullscreen --key-quit q "rtsp://user:password@host:port/path/subpath" 2>/dev/null) &
```

## Bonus: Connecting to Multiple Wi-Fi Networks

The above configuration will connect to *one* specific Wi-Fi network automatically. We can list further networks in the same file, and even assign the order to connect, e.g. `priority=100`.

We can auto-connect to any unsecure Wi-Fi network as a fallback with:

```conf
network={
   key_mgmt=NONE
   priority=-999
}
```


[hdmi-boot]: https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=11259
[piserver-book]: https://qasimk.gitbooks.io/piserver-book/content/
[systemd-autologin]: https://askubuntu.com/a/175410/799125
[arch-wiki-getty]: https://wiki.archlinux.org/index.php/Getty
[systemd-alternative]: https://yingtongli.me/blog/2016/12/21/splash.html

*[DVR]: Digital Video Recorder
*[RTSP]: Real Time Streaming Protocol
