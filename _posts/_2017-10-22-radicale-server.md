

1. Contacts and Calendar sync
2. On a Raspberry Pi
3. Under Arch Linux
4. With user authentication (plain, todo: bcrypt)
5. With encrypted transport (https)
6. With service (systemd auto-restart)
7. With backups (???)
8. Accessible over the internet

Install manually:

sudo useradd -m radicale
sudo su - radicale
pip install --upgrade --user radicale
vim ~/.config/radicale/config

Configure /etc/hosts with `192.168.1.x lanip`

```ini
[server]
# Bind all addresses
hosts = lanip:5555

[storage]
filesystem_folder = ~/.var/lib/radicale/collections
```

Let's test it works:

```console
python -m radicale
```

Delete the collections you created under the `filsystem_folder`

## Configure users and password authentication

We use plain encryption for now. TODO: bcrypt.

vim ~/.config/radicale/users
```
user:password
```
chmod 0600 ~/.config/radicale/users

```ini
[server]
# Bind all addresses
hosts = lanip:5555

[auth]
type = htpasswd
htpasswd_filename = /path/to/users
htpasswd_encryption = plain

[storage]
filesystem_folder = ~/.var/lib/radicale/collections
```


Let's test it works (verify login requires that username and password)

```console
python -m radicale
```
