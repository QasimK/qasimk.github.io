# Running a single application through a VPN

A VPN usually seems to be an all or nothing affair. You can route all of your internet traffic through one, or none of it. In addition, one can route for particular IP addresses (OpenVPN? OS functionality). It isn't generally possible to only route one application, but it is.

Linux has network namespaces. Which can isolate applications with their its networking stack(?).

[Normal namespace]<-->[OpenVPN + Application]


https://unix.stackexchange.com/questions/149293/feed-all-traffic-through-openvpn-for-a-specific-network-namespace-only
http://www.naju.se/articles/openvpn-netns.html

## Best Article:

https://coldfix.eu/2017/01/29/vpn-box/#virtual-ethernet-tunnel-to-network-namespace


## Test OpenVPN

Install openvpn, install client config file (.ovpn, .crts, .pems in `/etc/openvpn/client`). Start OpenVPN for debugging with just `sudo openvpn /etc/openvpn/client/copied_file.opvn`.

Might need to set absolute path to .crt and .pem files. Ensure owned by root.


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

(kernel test alias kernel-test='[ -d "/usr/lib/modules/$(uname -r)" ] || echo "Kernel has been updated. Please reboot."'

if RTNETLINK answers: Operation not supported)

```sh
$ sudo ip link add vpn0 type veth peer name vpn1
```

Virtual ethernet (veth) devices always come in pairs and work as a bidirectional pipe, whatever comes into one of them, comes out of another.
* http://baturin.org/docs/iproute2/


```
sudo openvpn --ifconfig-noexec --route-noexec --script-security 2 --up /etc/openvpn/move-to-netns.sh --down /etc/openvpn/move-to-netns.sh --config /etc/openvpn/client/UK_London.ovpn
```
