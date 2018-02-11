---
layout: post
title:  "Setting up Transmission as a service to use over the network"
tags:   guides linux
githubCommentIssueId: 4
---

I want to set [Transmission][transmission-website] up on device like a
Raspberry Pi so that it can be accessed over the network. As the Raspberry Pi
is quite a simple device, I want to use an external storage drive for the
downloaded files. Setting it up as a service wasn't as straightforward as it
could have been (hence this post). As usual the [Arch Wiki][arch-wiki] has good
documentation.

(NB: I have deemed this article to be half-complete, and expect to update it soon :)

## Basic Overview

Transmission has a service component (transmission-daemon) and various
interfaces including CLI, GUI and a web interface.

## Configuring network access

Transmission binds to `0.0.0.0` by default, but restricts incoming connections
to localhost. So we will want to edit the settings file to whitelist
connections, e.g. from your LAN: `192.168.*.*`.

The primary issue to overcome is that Transmission [will override the settings
file][transmission-password] because it (quite rightly) hashes your password
when you start/stop the daemon.

Therefore enable `rpc-authentication-required`, set the `rpc-username`, and set
the `rpc-password` in plaintext (Transmission will hash this).

The web interface only supports HTTP, but it doesn't matter much (unless you're
using pre-shared key based WiFi authentication, e.g. WPA2-PSK). It is possible
to use HTTPS if a [proxy server like Nginx is used][nginx-proxy].

## Configuring storage

Add the configuration for `RequiresMountsFor` in the SystemD unit file to
support removable devices.

Allow your user account to access Transmission files by adding yourself to the
`transmission` group.


[transmission-website]: https://transmissionbt.com/
[arch-wiki]: https://wiki.archlinux.org/index.php/Transmission
[transmission-password]: https://superuser.com/questions/113649/how-do-you-set-a-password-for-transmission-daemon-the-bittorrent-client-server
[nginx-proxy]: https://askubuntu.com/questions/199738/how-do-i-get-https-web-interface-in-transmission
