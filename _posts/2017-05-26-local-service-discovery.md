---
layout: post
title:  "Discovering your Raspberry PI on the local network"
tags:   Linux
---

I wanted to be able to SSH into my Raspberry PI without configuring my SSH
config with the IP address. Although I have statically assigned it, I think it
would be nice to not worry about this detail. All that I really want to be able
to do is SSH into the device by its hostname, but we'll go further and
broadcast the SSH service itself.

We may have remembered we had a Raspberry PI after a few months in which case
we need to discover where it is in the network:

1. Search the local network for devices: `nmap -sn`.
2. List the hosts and their IP addresses: `arp -a`.

With the IP address we can manually SSH in using some credentials (that we
surely stored within a password-manager).

Services can be broadcast and discovered on the local network using
[Avahi][wiki-avahi] which implements a number of different protocols around
local networks.

We want:

1. A link-local IP address for a "direct" connection to the device. This would
   simply be an address that does not rely on the DHCP service (and is not
   strictly necessary).
2. Hostname resolution via mDNS so that we can SSH into the hostname.
3. Descriptive service discovery via DNS-SD (DNS service discovery) as a bonus.

# Broadcast SSH on your local network

1. Install the service broadcaster `avahi`.
2. Install `nss-mdns` which provides providing host name resolution.
3. Start `avahi-daemon.service` - you may need to restart `dbus.service`.
4. Edit `/etc/nsswitch.conf` which usually controls the sources from which to
   obtain name-service information. From Arch:
   "Insert `mdns\_minimal [NOTFOUND=return]` before `resolve` and `dns`".
5. Broadcast the SSH service (you can construct these service files yourself):
   `cp /usr/share/doc/avahi/ssh.service /etc/avahi/services`.
6. Observe service works with `avahi-browse -alrt` from another local machine.

And we are done - we can simply SSH into the displayed domain name/port!

Arch has [fantastic documentation][arch-avahi] around Avahi with further
information and examples.


[wiki-avahi]: <https://en.wikipedia.org/wiki/Avahi_%28software%29>
[arch-avahi]: <https://wiki.archlinux.org/index.php/Avahi>
    "Avahi documentation on the Arch Wiki"
