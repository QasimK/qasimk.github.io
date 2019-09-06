---
layout: default-post
title:  "Running a Single Application Through a VPN"
tags:   guide linux arch vpn privacy raspberry-pi
githubCommentIssueID: 11
---

(This needs tidying up!)

In it's simplest and most common usage, VPNs route all internet traffic from your device. It's also possible to route only traffic that is to particular IP addresses with OS or VPN-app level features. It's more difficult, but still possible to route all traffic but only for a particular application.

Linux has the concept of namespaces for processes, users, storage devices and other concepts. It also has network namespaces which can isolate applications within a new networking stack of devices and routing tables.

In this article we will create simple way to run only particular applications through a VPN. It is based on [VPN in a Nutshell][vpn-nutshell] by Thomas Gläßle which was the best resource I was able to find (it goes into much more detail than I will).

## Installing OpenVPN

First, let's install and make sure OpenVPN is working. We will have to obtain the client config files from our VPN provider (these can vary but they are generally one of each `.crt`, `.pem`, and `.ovpn`/`.conf` files).

```sh
$ sudo pacman -S --needed openvpn
# Copy the client config files
$ sudo cp ca.rsa.4096.crt /etc/openvpn/client
$ sudo cp crl.rsa.4096.pem /etc/openvpn/client
$ sudo cp CONFIG.ovpn /etc/openvpn/client
```

Start OpenVPN for debugging with `sudo openvpn --cd /etc/openvpn/client/ --config CONFIG.ovpn`.

Test OpenVPN with `curl ifconfig.co`. The IP address should be different!

(Note, I had to restart my system due to errors possible related to previous system upgrades.)

### Aisde: Automatically Entering Credentials

If a username and password is requested by OpenVPN this will stop any chance of automation. Thus, we want to save the credentials and allow OpenVPN to automatically read them. We can simply save them to the filesystem secured under the `root` user.

We can create a second config file to merge with the main config file. This allows us to modify or add settings separately.

Create `/etc/openvpn/client/override.conf` with:

```
auth-user-pass auth.txt
```

Create `/etc/openvpn/client/auth.txt` as root with two plain-text lines: your username followed by your password.

Now test OpenVPN with `sudo openvpn --cd /etc/openvpn/client/ --config CONFIG.ovpn --config override.conf`.

## Creating a Network Namespace

Thomas Gläßle provides the necessary scripts which more-or-less work out of the box!

Modify `override.conf`:

```
auth-user-pass auth.txt

# Configure interface later:
ifconfig-noexec

# Don't route all traffic on this machine through VPN:
route-noexec

# Enable up-script
script-security 2
up   move-to-netns.sh
down move-to-netns.sh
```

Add the `/etc/openvpn/client/move-to-netns.sh` script:
(I have modified the script to support systemd.)

```sh
#!/bin/bash

up() {
    # create network namespace
    ip netns add vpn || true

    # bring up loop device
    ip netns exec vpn ip link set dev lo up

    # move VPN tunnel to netns
    ip link set dev "$1" up netns vpn mtu "$2"

    # configure tunnel in netns
    ip netns exec vpn ip addr add dev "$1" \
            "$4/${ifconfig_netmask:-30}" \
            ${ifconfig_broadcast:+broadcast "$ifconfig_broadcast"}
    if [ -n "$ifconfig_ipv6_local" ]; then
            ip netns exec vpn ip addr add dev "$1" \
                    "$ifconfig_ipv6_local"/112
    fi

    # set route in netns
    ip netns exec vpn ip route add default via "$route_vpn_gateway"
}

down() { true; }

"$script_type" "$@"

# update DNS servers in netns
if [ -x /etc/openvpn/update-resolv-conf ]; then
    ip netns exec vpn /etc/openvpn/update-resolv-conf "$@"
fi
if [ -x /etc/openvpn/update-systemd-resolved ]; then
    ip netns exec vpn /etc/openvpn/update-systemd-resolved "$@"
fi
```

Test this with `sudo ip netns exec vpn sudo -u $(whoami) -- curl ifconfig.co`. When OpenVPN is not running you should not be able to obtain a connection.

## Running Applications Through the VPN

Now we can simplify running the application.

Create an executable script `/usr/local/bin/vpnbox` with:

```sh
#!/usr/bin/bash

# check if there is a default route in the netns going over tun0:
# NOTE: 'tun0' may not be the correct interface name
vpn_online() {
    sudo ip netns exec vpn sudo -u $(whoami) -- ip route \
        | grep default | grep tun0
}

if ! vpn_online; then
    # Execute openvpn in daemon mode:
    sudo /bin/openvpn --cd /etc/openvpn/client/ --config CONFIG.ovpn --config override.conf --daemon

    # Wait for completion. Otherwise routes/DNS information may not be
    # setup when the main program starts:
    echo "Waiting for route."
    while ! vpn_online; do
        sleep 0.1
    done
fi

# Execute the actual command as before:
sudo ip netns exec vpn sudo -u $(whoami) -- "$@"
```

Test this with the much simpler command `vpnbox curl ifconfig.co`.

### Aside: DNS & IPv6

Check the DNS servers being used with `vpnbox dig +short whoami.akamai.net`.
It should match `vpnbox curl ifconfig.co`.

Most likely you will want to fix DNS leaks with Systemd using
[update-systemd-resolved][update-systemd-resolved].
(Don't forget to `root:root +x`.)

Check for IPv6 with `vpnbox curl https://v6.ifconfig.co/`.

### Aside: Sudo Privileges

If your user cannot `sudo`, then you will want to modify sudoers file to allow them to run the `vpnbox` command.


### Aside: Local listening Apps

If the app is a server listening on `localhost`, then you can forward some ports
with `socat` on the host machine (i.e. not inside the network namespace):

```sh
$ sudo socat tcp-listen:8080,fork,reuseaddr exec:'ip netns exec vpn socat STDIO tcp-connect\:127.0.0.1\:8080',nofork
```

You'll probably just want to use a proper proxy though <somehow>.


[vpn-nutshell]: https://coldfix.eu/2017/01/29/vpn-box/
[update-systemd-resolved]: https://github.com/jonathanio/update-systemd-resolved


<div style="display: none">
**This section is incomplete. It is supposed to go through a more manual process.**

```sh
$ sudo ip netns add vpn
$ sudo ip netns exec vpn curl ifconfig.co
curl: (7) Couldn't connect to server
$ sudo ip netns exec vpn ip link list
1: lo: <LOOPBACK>[...]
# Loopback doesn't actually work (TODO: do we need it?)
$ sudo ip netns exec vpn ip link set lo up
```

(kernel test alias kernel-test='[ -d "/usr/lib/modules/$(uname -r)" ] || echo "Kernel has been updated. Please reboot."'

if RTNETLINK answers: Operation not supported)

```sh
$ sudo ip link add vpn0 type veth peer name vpn1
```

Virtual ethernet (veth) devices always come in pairs and work as a bidirectional pipe, whatever comes into one of them, comes out of another.
* http://baturin.org/docs/iproute2/
</div>

