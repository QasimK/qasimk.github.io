Set up Screeps securely with LXC:

(Pihole?)

https://help.ubuntu.com/lts/serverguide/lxc.html

http://docs.screeps.com/contributed/ps_ubuntu.html


# Setting up unprivileged containers (for security)

(Currently the Arch linux kernel ships with user namespaces disabled for normal users.)

https://blog.benoitblanchon.fr/jeedom-lxc-container/
https://yeupou.wordpress.com/2017/06/23/setting-up-lxc-containers-with-mapped-giduid/
maybe https://myles.sh/configuring-lxc-unprivileged-containers-in-debian-jessie/

1. Create `/etc/sysctl.d/kernel.conf` as root:

    kernel.unprivileged_userns_clone=1

And reload so this takes effect as root:

    $ sysctl --system

2. Allow your user account YOURUSERNAME to run containers as root:

    $ usermod --add-subuids 100000-165535 YOURUSERNAME
    $ usermod --add-subgids 100000-165535 YOURUSERNAME

3. Edit `$(lxc-config lxc.default_config)` to set up uid/gid mapping that match the above ranges:

    lxc.idmap = u 0 100000 65536
    lxc.idmap = g 0 100000 65536

4. Configure a networking bridge that the containers can use to access the internet.

    $ sudoedit /etc/lxc/lxc-usernet

    YOURUSERNAME  veth         lxcbr0     10

5. Configure host-side of network bridge

    $ pacman -S --needed dnsmasq
    $ sudoedit /etc/default/lxc-net

    USE_LXC_BRIDGE="true"
    LXC_BRIDGE="lxcbr0"
    LXC_ADDR="10.0.3.1"
    LXC_NETMASK="255.255.255.0"
    LXC_NETWORK="10.0.3.0/24"
    LXC_DHCP_RANGE="10.0.3.2,10.0.3.254"
    LXC_DHCP_MAX="253"

6. Grant access (you may want to be wary)

    chmod +x ~/.local/share

5. Test that it works

    lxc-create -n testcontainer -t download -- --dist archlinux --release current --arch amd64
    lxc-destroy testcontainer

Edit container:

    # Network configuration
    lxc.net.0.flags = up
    lxc.net.0.type = veth
    lxc.net.0.name = veth0
    lxc.net.0.link = lxcbr0

    # Fix?
    lxc.apparmor.allow_incomplete = 1


7. Vagrant: install cgroup
install bridge-util?
cgfs pam module?

Maybe /etc/pam.d/system-login

session optional pam_cgfs.so -c freezer,memory,name=systemd,unified
