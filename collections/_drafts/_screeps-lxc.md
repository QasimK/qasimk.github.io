Set up Screeps securely with LXC:

(Pihole?)

https://help.ubuntu.com/lts/serverguide/lxc.html

http://docs.screeps.com/contributed/ps_ubuntu.html


# Setting up unprivileged containers (for security)

(Currently the Arch linux kernel ships with user namespaces disabled for normal users.)

https://blog.benoitblanchon.fr/jeedom-lxc-container/
https://yeupou.wordpress.com/2017/06/23/setting-up-lxc-containers-with-mapped-giduid/
maybe https://myles.sh/configuring-lxc-unprivileged-containers-in-debian-jessie/

UNPRIV:
1. Create `/etc/sysctl.d/99-lxc-userns.conf` as root:

    kernel.unprivileged_userns_clone=1

Normally you would reload & check, but we will be restarting later:

    $ sysctl --system
    $ sysctl kernel.unprivileged_userns_clone

2. Enable Control Groups (CGroups) Control Module, `sudoedit /etc/pam.d/system-login`

    session    optional   pam_cgfs.so          -c freezer,memory,name=systemd,unified

2. Allow your user account YOURUSERNAME to run containers as root:

    $ usermod --add-subuids 100000-165535 YOURUSERNAME
    $ usermod --add-subgids 100000-165535 YOURUSERNAME

Confirm with

    cat /etc/sub{u,g}id

3. Edit user LXC configuration file `$VISUAL $(lxc-config lxc.default_config)` to set up uid/gid mapping that match the above ranges:

    lxc.include = /etc/lxc/default.conf
    lxc.idmap = u 0 100000 65536
    lxc.idmap = g 0 100000 65536
    # Secure mounting
    lxc.mount.auto = proc:mixed sys:ro cgroup:mixed

4. Configure a networking bridge that the containers can use to access the internet.

    $ sudoedit /etc/lxc/lxc-usernet

    # <user>      <link_type>  <bridge>   <#links>
    YOURUSERNAME  veth         lxcbr0     10

OR "echo "$USER veth lxcbr0 10"| sudo tee -i /etc/lxc/lxc-usernet"

5. Configure host-side of network bridge (you do not need to start/run dnsmasq.service)

    $ pacman -S --needed dnsmasq
    $ sudoedit /etc/default/lxc-net

    USE_LXC_BRIDGE="true"

    # The following lines are not necessary, but they will ensure the IP is deterministic
    LXC_BRIDGE="lxcbr0"
    LXC_ADDR="10.0.3.1"
    LXC_NETMASK="255.255.255.0"
    LXC_NETWORK="10.0.3.0/24"
    LXC_DHCP_RANGE="10.0.3.2,10.0.3.254"
    LXC_DHCP_MAX="253"

6. Allow all containers access to the bridge by default: `sudoedit /etc/lxc/default.conf`

    lxc.net.0.type = veth
    lxc.net.0.link = lxcbr0
    lxc.net.0.flags = up
    lxc.net.0.hwaddr = 00:16:32:xx:xx:xx

6. Enable it

    sudo systemctl enable lxc-net

(NOTE: I was forced to do a PC restart before I was able to run lxc-net.service)

7. Grant the container access to its rootfs

    sudo setfacl -m "u:100000:x" . .local .local/share

Check with `getfacl`.

An alternative that I do **not** recommend is:

    chmod o+rx ~/
    chmod o+rx ~/.local
    chmod o+rx ~/.local/share

8. Reboot. Seriously.

9. Test that it works

    lxc-create -n testcontainer -t download -- --dist archlinux --release current --arch amd64
    lxc-attach --clear-env testcontainer
    lxc-destroy testcontainer

(Ubuntu: lxc-create -n pcgamingdb -t download -- --dist ubuntu --release bionic  --arch amd64)

## Usage Notes

* If you only want the container to have access to the the bridge, then put it into `~/.local/share/lxc/<CONTAINER>/config` and remove it from the default.

    # Network configuration
    lxc.net.0.flags = up
    lxc.net.0.type = veth
    lxc.net.0.name = veth0
    lxc.net.0.link = lxcbr0

* Exit lxc-console with `<ctrl-a> q`, note this does not work for foreground start `lxc-start -F` (there is no way to exit)
* `lxc-console` attaches like in foreground mode.
* Destroy with `lxc-destroy --snapshots CONTAINER_NAME`.
* `lxc-attach --clear-env` to go into container.
* Have container mount on boot: `lxc.start.auto = 1`.
* You can create container in non-default path with `-P`.
* chattr +C FOLDER for btrfs passes through just fine.

## ACL for Shared Folders

Sharing a folder with the container is simple:

    lxc.mount.entry = /home/test/projects/bla mnt/bla none bind,create=dir 0 0

Sharing it so that the container's root user can read and write to it is more complicated,
but we can do it with Access Control List (ACL), which you may need to install.

We note that you cannot create a shared group because the container does not know
what the group id is.

All you need is:

    chmod g+rwxs,o-rwx ~/projects/PROJECT
    setfacl -m "default:g::rwX" ~/projects/PROJECT
    setfacl -m "default::u:100000:rwX" ~/projects/PROJECT

* Set the group sticky bit on the folder to ensure all child folders/files have group USER.
* Set the default group permissions to ensure group USER can rw on all new files, and rwx on all new folders.
* Set the default user permissions for `containerroot` to ensure it can rw all new files, and rwx on all new folders.

Note: This does not work for cp or mv files/folders. So manually fix them:
This can also be used if you turn an existing folder into a shared folder.

    sudo chown -R USER:USER ~/projects/PROJECT
    chmod -R o-rwx ~/projects/PROJECT
    find ~/projects/PROJECT -type d -exec chmod g+rwxs {} +
    find ~/projects/PROJECT -type d -exec setfacl -m "default:g::rwX" {} +
    find ~/projects/PROJECT -type d -exec setfacl -m "default:u:100000:rwX" {} +
    find ~/projects/PROJECT -type d -exec setfacl -m "u:100000:rwX" {} +
    find ~/projects/PROJECT -type f -executable -exec setfacl -m "u:100000:rwx" {} +
    find ~/projects/PROJECT -type f ! -executable -exec setfacl -m "u:100000:rw" {} +

* Own everything by USER to ensure we can chmod and setfacl
* Remove other permissions for neatness

You can view which folders/files have ACLs using `ls -l` which will add a `+`
next to the permissions.

Finally, if you messed up, you can clear all permissions recursively:

    setfacl -Rb ~/projects/PROJECT

## Enhancing Security

Despite this being an unprivileged container, there are problems if you use
more than one:

* DOS - No Resource Limits (cgroups) - cpu, memory, disk
* Network communication - Shared Network bridge between containers, MAC/IP spoofing
* Shared UIDs between containers - mitigate with `security.idmap.isolated true`.
