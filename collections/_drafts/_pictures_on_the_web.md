<picture> element
    * Landscape/Portrait
    * JPEG/WebP.
    * JPEG 80% Quality should be fine.
    * WebP 70%? Or was it the other way around
    * Use MozJPEG - smaller file size at same quality: https://imageoptim.com/online
        * Medium
    * Use WebP at and above 2560x1440 (and JPEG at and below this)
    * Put WebP first. Use it exclusively for "good" machines => good displays. Inc. HiDPI.
    * Consider ultra-wide 32:9 image.
    * Use object-fit: cover (or "contain" if this isn't working out)

Only options are:
WebP
JPEG (via MozJPEG)


Target different resolutions:
    * Portrait: 320w, 640w, 1080w. Could be more accurate here
    * Landscape: 720p, 1080p, 1440p, 2160p, 5120x2880

Portrait is overwhelming more likely to be mobile.

Script

convert YellowFlower.jpg -resize 1280\> -quality 70 YellowFlower--WebP.webp

TODO: color-spaces??
https://www.imagemagick.org/Usage/resize/


<video> element
    * autoplay
    * playsinline
    *

* Ogg/Theora (Free; not Apple; worse than H.264)
* WebM (VP8 or VP9 - varying support)
* MP4 (H.264 - basically everywhere)
* H.265 is not supported anywhere (2019)
* Looking forward to AV1

[AV1]
WebM VP9
MP4 H.264
WebM VP8
Ogg/Theora
