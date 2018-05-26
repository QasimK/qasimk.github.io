---
layout: post
title:  "Setting up Transmission as a service to use over the network"
tags:   guides linux
githubCommentIssueID: 4
---

I want to set [Transmission][transmission-website] up on device like a
Raspberry Pi so that it can be accessed over the network. As the Raspberry Pi
is quite a simple device, I want to use an external storage drive for the
downloaded files. Setting it up as a service wasn't as straightforward as it
could have been (hence this post). As usual the [Arch Wiki][arch-wiki] was
the best source

## Installation

Transmission has a service component (`transmission-daemon`) and various
interfaces including CLI, GUIs and a web interface. We will set up the web
interface.

The system daemon will run under the `transmission` user and we will stick to
that rather than running under your own user because "attack surfaces".

We need to start and stop the daemon to create the settings file. While it
is started, we can remotely access it by browsing to `server:9091`. Make sure
it is stopped before we start editing the settings file, otherwise our changes
will not stick.

```bash
$ sudo pacman -S --needed transmission-cli
$ sudo systemctl enable transmission
$ sudo systemctl start transmission
$ sudo systemctl status transmission
# Check you can access it with your browser.
$ sudo systemctl stop transmission
```

## Configuring network access

Some Transmission settings are available through the web interface. They are all
inside `/var/lib/transmission/.config/transmission-daemon/settings.json`, and
we will modify that file to get set up.

Transmission RPC binds to `0.0.0.0` by default, but restricts incoming
connections to `localhost`. I would prefer to just listen to the `localhost`
address in the first place.

We will edit the settings file to listen to only `localhost` and set up
credentials for the web portal.

Note that, Transmission will [hash the password][transmission-password] and
re-store it in the settings file (good stuff) when you start/stop the daemon
(a little less good).

The modifications:

```json
{
    "rpc-authentication-required": true,
    "rpc-host-whitelist": "localhost",
    "rpc-bind-address": "127.0.0.1"
    "rpc-password": <YOUR PASSWORD IN PLAIN-TEXT>,
    "rpc-username": <YOUR USERNAME>,
}
```

(I suggest keeping the passwords in [a password manager][post-using-keepass-effectively].)

The web interface only supports HTTP, but it doesn't matter much (unless you're
using pre-shared key based WiFi authentication, e.g. WPA2-PSK). It is possible
to use HTTPS if a [proxy server like Nginx is used][nginx-proxy].

```bash
$ sudo systemctl start transmission
```

Now start up Transmission, and at the web interface you should be prompted to
login.

### A Note on Remote Access

To access the web interface when it is listening on `localhost`, we can use
SSH port forwarding:

* In the `~/.ssh/config` file: `LocalForward 9091 127.0.0.1:9091`, or
* On the command-line: `-L 9091:127.0.0.1:9091`.

If you would rather trust your network then you can enable remote access
from only your local area network:

```json
{
    "rpc-bind-address": "0.0.0.0",
    "rpc-whitelist": "192.168.1.*",
}
```

However, if you are using Wi-Fi pre-shared key, i.e. WPA2-PSK, then your
username/password is effectively being shared with everyone nearby on your
wireless network.

A better solution would be to [use a TLS-capable reverse-proxy][nginx-proxy]
such as Nginx. I described how to set Nginx up as part of my article on
[Setting up Radicale on a Raspberry Pi][post-radicale-server], and the steps
are identical for Transmission.

## Configuring Storage

Skipping over creating the mount/folder that will be used to store all data...
Let's say it is `0771 root:root /mnt/storage`. (Note that `0771` will allow
sub-folders to be traversed by the right users without letting other users
list them out.)

Let's create some directories, groups and assign permissions to everyone:

```sh
$ sudo groupadd torrent
$ sudo gpasswd -a transmission torrent
$ sudo gpasswd -a <YOU> torrent
$ cd /mnt/storage
$ sudo mkdir torrent
$ sudo chown root:torrent torrent
$ sudo chmod u+rwx,g+rws,o-rwx torrent
# You can create other sub-folders if you want to split up downloading/completed etc.
```

* You can use the `sudo su - <YOU>` trick to get the group permission to apply
to yourself until you reboot.)
* We use the `setgid` permission (`g+s`) on the directories so that all files
and sub-folders within them are accessible to all users inside the `torrent`
group. This works by forcing the group of all files/folders to be `torrent`.
* We create the `torrent` group as we may not necessarily be using transmission.

The web interface has limited options, so you may want to edit the settings
file to set the right folder options.

### Modifying the Daemon

We note that the SystemD unit file is at `/usr/lib/systemd/system/transmission.service`,
and that `systemctl edit transmission` can be used to override options. The
[Arch Linux SystemD Wiki][arch-wiki-systemd] has more information.

(TBD: Add the configuration for `RequiresMountsFor` in the SystemD unit file to
support removable devices?)


[post-radicale-server]: <{% post_url 2017-10-22-radicale-server %}>
[post-using-keepass-effectively]: <{% post_url 2013-10-01-using-keepass-effectively %}> "Using KeePass Effectively"
[transmission-website]: https://transmissionbt.com/
[arch-wiki]: https://wiki.archlinux.org/index.php/Transmission
[transmission-password]: https://superuser.com/questions/113649/how-do-you-set-a-password-for-transmission-daemon-the-bittorrent-client-server
[nginx-proxy]: https://askubuntu.com/questions/199738 "How do I get a HTTPS web interface in Transmission?"
[arch-wiki-systemd]: https://wiki.archlinux.org/index.php/Systemd#Editing_provided_units
