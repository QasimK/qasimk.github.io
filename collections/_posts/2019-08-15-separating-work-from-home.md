---
layout: default-post
title:  "Separating Work from Work from Home"
tags:   linux
githubCommentIssueID: 16
---

There are two questions that usually come up in the career of a Software Engineer:

* How do I separate my work life from my home life on a computer?
* How do I separate work for different clients on the same machine?

The best solution is to use a dedicated work machine. However, if you need to be able to work from your own device on occasion, or even regularly, then it is important to separate the two spheres of life. Both to ensure compliance to privacy and security requirements, and to protect your own work-life balance.

Naturally work accounts will stem from a work email address. Using personal accounts for both purposes will be rare, perhaps GitHub. Nevertheless, this separation should be enforced and carry over to the applications you run, and the files you store.

I tend to run applications in a VM, and store all explicit work files inside of one "work root" folder.

By isolating work content in this way, it is very easy to delete anything when the time comes. Just delete the Vagrant Machine, Firefox Profile, the "work root" folder which contain all of the work files, any installed applications, and log out of anything on your phone—et voilà.

There is an alternative as well. Create a second Linux user and use that exclusively for work. Downsides include potentially running a different OS from work systems increasing the chances of bugs, increased overlap in configuring the desktop including IDEs for all the created user accounts, and making it harder to share things that you do want to share like bookmarks.

## Firefox Profiles

I use a separate Firefox Profile, which allows me to completely isolate work logins and add-ons from my day-to-day logins, add-ons and preferences. A few tweaks make this "Work" profile easier to use.

I created a desktop shortcut to launch the profile at `~/.local/share/applications/firefox-work.desktop`:

```ini
#!/usr/bin/env xdg-open
[Desktop Entry]
Version=1.0
Name=Firefox Work
Type=Application
Exec=/usr/lib/firefox/firefox --class="FirefoxWork" -no-remote -p Work
Icon=firefox
Terminal=false
StartupNotify=true
StartupWMClass=FirefoxWork
```

Using a separate class will cause the desktop to treat this Firefox instance as a separate application, e.g. for alt-tabbing purposes.

(Alternatively, you can bookmark `about:profiles` which lets you switch and launch new profiles.)

A Firefox Sync account lets me work between machines more easily.

The [Firefox Colour Test Pilot][firefox-colour] add-on visually distinguishes the different profiles from each other. (This is the successor to Firefox Personas.)

[SmartProxy][SmartProxyAddOn] is a useful Firefox add-on that can redirect localhost URLs to development containers. For example, if you are running a web app on `http://localhost:8000` in the container, you might need to access this as `http://172.16.3.2:8000` on the host, but then the server might reject the request because it is listening only on localhost or because the HTTP Host header does not match. The add-on will redirect the `http://localhost:8000` in the web address bar to the right IP more smoothly.

## File Sync

If you need to sync files between devices—privately—then Resilio Sync is a good option because it does not store the files in the cloud. The encrypted device option improves the sync between devices which might not be online at the same time. In addition, it has a (very) basic file history.

## Password Manager

I use my favourite password manager—[KeePass][keepass-xc]—with the file kept in the File Sync folder.

This integrates with my normal password file by using [KeeShare][keeshare]. This integration means when I open my personal, primary KeePass file, it automatically opens the "work" KeePass file as a sub-folder and also keeps edits in-sync.

(Having been forced to use 1Password—I hate it. It does one thing though: sharing passwords amongst the team.)

## Coding & VMs

I isolate all work files to `~/projects/<company>/`, including the File Sync folder and code repositories. This allows me to use my editors including PyCharm and Sublime Text on the host system. This is the "work root".

(I would not use it as the File Sync root folder because *\<git\>*.)

I use Vagrant to completely isolate my development environment. I can use whichever OS is common on the team, move the VM between machines (with difficulty), create snapshots, and most importantly, isolate all executable code and other "junk".

All DevOps, using things like `vagrant`, `gcloud`, or `kubectl`, is done inside the VM. This may also leave credentials on the filesystem. Certainly you would provision a new SSH key for the VM. This VM can be encrypted.

I share the "work root" with the VM, allowing me to run project executables, and linters inside the VM, while editing the code on the host.

While configuring PyCharm (and presumable other JetBrains IDEs) with the remote environment is easy, it is more difficult to set up [Sublime Text][sublime-anaconda-remote].

I would have recommended LXC on Linux, but I have not yet been able to get Docker to work inside an unprivileged container and this tool is increasingly being used. It might be much easier in general to use LXD (including with Docker), but I have not tried that yet.

## Other Unfriendly Applications

God forbid you are forced to run *proprietary, privacy-invading, mind-share grabbing, or not-very-cross-platform* applications for some reason. I have gotten away with not doing so so far.

Some ideas spring to mind:

* Spin up a Windows VM if the application does not run on Linux, with shared folders if necessary.
* Create a new Linux user account. This is probably too much effort.
* Use SystemD containers (`systemd-nspawn`), or LXC/LXD to isolate the application. This is probably too much effort.

Luckily many applications work in the web browser these days. A few are still not very friendly though, for example:

* Zoom - not friendly for screen sharing on Wayland in 2019. Running it on Gnome or Xorg works, but I run Sway. Somehow I've gotten away with it, but I keep i3wm around.
* Slack - not friendly for phone and video calls, which require the electron app, or Chrome. I don't intend to do either, so I jump on Slack my phone for calls.
* Clockwise - requires a Chrome add-on? IMHO, this makes it utter trash.

## Mobile

On mobiles, it is much more tricky to isolate things. Ideally, you would just have a completely separate phone. However, once in a while you might want to check something while on-the-go.

I would keep things to the bare minimum:

* Login to your work email, but disable notifications for that account only.
* Login to your work chat, but disable notifications.
* Perhaps use a different browser for any necessary work logins.
* Avoid installing anything privileged. On iOS devices that includes "configuration profiles", "device management profiles", and root certificates.

(On iPhones, you can generally install any applications dedicated to your workplace or that allow multiple accounts to be logged in, e.g. Slack, without worrying *too much* about your device becoming compromised.)

[SmartProxyAddOn]: https://addons.mozilla.org/en/firefox/addon/smartproxy/
[firefox-colour]: https://color.firefox.com
[keepass-xc]: https://keepassxc.org/
[keeshare]: https://github.com/keepassxreboot/keepassxc/b4dab5d/develop/docs/QUICKSTART.md#using-sharing
[sublime-anaconda-remote]: https://github.com/QasimK/my-setup/blob/master/setup-sublime.md#python
