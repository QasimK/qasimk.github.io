

# HikConnect

HikVision's cloud platform to access the DVR streams.

# Network Hard Drive storage - NetHDD

It is NFS only (not Samba). Specify IP address and folder.

# RSTP

Must disable "encryption" under platform access on the DVR itself (cannot do it through web interface).
Otherwise, it is just a grey/black mess.

rtsp://username:password@ip:554/Streaming/Channels/201

OR

rtsp://ip:554/Streaming/Channels/201 (and enter username/password interactively with whatever)
Streaming/Channels/1 = Zero Channel (view of all cameras)
Streaming/Channels/101 = Camera 1 Main Stream (HD)
Streaming/Channels/102 = Camera 1 Sub Stream (SD)

VLC and MPV work. On Raspberry Pi there is OMXPlayer, VLC might also be HW-accelerated.
Note: *might* need https://www.raspberrypi.com/mpeg-2-license-key/

#!/bin/bash
screen -dmS camera1 sh -c 'omxplayer --win "0 37 960 577" "rstp://"; exec bash'
screen -dmS camera2 sh -c 'omxplayer --win "960 37 1920 577" "rstp://"; exec bash'
screen -dmS camera3 sh -c 'omxplayer --win "0 577 960 1080" "rstp://"; exec bash'
screen -dmS camera4 sh -c 'omxplayer --win "960 577 1920 1080" "rstp://"; exec bash'
https://github.com/alewir/playstreamation
omxplayer --lavfdopts probesize:25000 --no-keys --live --timeout 30 --aspect-mode stretch --nohdmiclocksync --avdict rtsp_transport:tcp --win "1440 0 1920 360" "rtsp://user:pass@192.168.0.39/cam/realmonitor?channel=1&subtype=1"

Might be possible to set up an Nginx reverse proxy.

# Cloud backup

Supports OneDrive, Google Drive, and Dropbox. Scan the QR code and follow the instructions. The "authorisation" code might be found in one of the final redirect URLs after authenticating the app.

The files are stored top-level in "snapshot" and "record".

To enable storing video recordings:

* Web interface: Enable Dual Stream under Schedule. (Not found in DVR interface).
* Change recording type to "Event" (not continuous).

# Email

This can be set up...

# Cool Features

Motion Detection, and Intrusion Detection.

The latter works off defining lines and boxes (up to 4 definitions in total on my model); it probably detects motion.

Other Advanced features not available.
