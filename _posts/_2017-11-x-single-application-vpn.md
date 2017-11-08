# Running a single application through a VPN

A VPN usually seems to be an all or nothing affair. You can route all of your internet traffic through one, or none of it. In addition, one can route for particular IP addresses (OpenVPN? OS functionality). It isn't generally possible to only route one application, but it is.

Linux has network namespaces. Which can isolate applications with their its networking stack(?).

[Normal namespace]<-->[OpenVPN + Application]


https://unix.stackexchange.com/questions/149293/feed-all-traffic-through-openvpn-for-a-specific-network-namespace-only
http://www.naju.se/articles/openvpn-netns.html


## Network Namespaces

```sh
$ sudo ip netns add vpn
$ sudo ip netns exec vpn curl ifconfig.co
curl: (7) Couldn't connect to server
$ sudo ip netns exec vpn ip link list
1: lo: <LOOPBACK>[...]
# Loopback doesn't actually work (TODO: do we need it?)
$ sudo ip netns exec vpn ip link set lo up
```

Install openvpn, install client config file (.ovpn, .crts, .pems in `/etc/openvpn/client`). Start OpenVPN for debugging with just `sudo openvpn /etc/openvpn/client/copied_file.opvn`.