# Digital Self-Defense

* Strip EXIF data from images

[source](https://askubuntu.com/questions/260810/how-can-i-read-and-remove-meta-exif-data-from-my-photos-using-the-command-line)

```bash
$ sudo pacman -S --needed perl-image-exiftool
$ exiftool image.jpg
...
$ exiftool -all= image.jpg
```

* Contain identities

[Firefox Multi-Account Containers](<{{ site.baseurl }}{% post_url 2017-11-21-firefox-containers %}>)

Firefox in a clean, empty session (https://news.ycombinator.com/item?id=16500301)

```bash
Run   #!/bin/sh
#
export DISPLAY=:0
# Set up clean copy
cd ~
rm -fr .mozilla
cp -a .mozilla_base .mozilla
cd - > /dev/null
#
/usr/local/bin/firefox $@
#
echo "Holding...."
sleep 2
echo "Cleaning...."
# Clean out junk (so we start clean next time)
cd ~
rm -fr .mozilla .cache/mozilla*
rm -fr .adobe
rm -fr .macromedia
cd - > /dev/null
```
