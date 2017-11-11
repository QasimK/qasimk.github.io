# Digital Self-Defense

* Strip EXIF data from images

```bash
$ sudo pacman -S --needed perl-image-exiftool
$ exiftool image.jpg
...
$ exiftool -all= image.jpg
```
