# Digital Self-Defense

* Strip EXIF data from images

[source](https://askubuntu.com/questions/260810/how-can-i-read-and-remove-meta-exif-data-from-my-photos-using-the-command-line)

```bash
$ sudo pacman -S --needed perl-image-exiftool
$ exiftool image.jpg
...
$ exiftool -all= image.jpg
```
