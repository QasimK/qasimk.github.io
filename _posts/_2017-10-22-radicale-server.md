

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
hosts = lanip:5232

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
hosts = lanip:5232

[auth]
type = htpasswd
htpasswd_filename = ~/.config/radicale/users
htpasswd_encryption = plain

[storage]
filesystem_folder = ~/.var/lib/radicale/collections
```

Let's test it works (verify login requires that username and password)

```console
python -m radicale
```

## Use it in Clients.

See the [client instructions][radicale-clients] and give it a go on a couple of your devices to ensure everything is working well.

## Set-up Encryption.

Radicale supports HTTPS itself, but we will set up an Nginx server because it can be used for other local network services as well. This means we can also bind Radicale to localhost.

```console
pacman -S --needed nginx-mainline
sudo systemctl enable nginx.service
sudo systemctl start nginx.service
```

Create a radicale site:

```console
sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled
# Add "include sites-enabled/*;" to the end of the http block in /etc/nginx/nginx.conf
sudo touch /etc/nginx/sites-available/radicale
sudo ln -s /etc/nginx/sites-available/radicale  /etc/nginx/sites-enabled/radicale
```

Edit `/etc/nginx/sites-available/radicale`:

```
server {
    listen 8001;
    server_name myserver.local;
    
    location / {
        proxy_pass http://localhost:7001;
    }
}
```

Edit `~/.config/radicale/config`: 

```ini
[server]
hosts = localhost:7001

[auth]
type = htpasswd
htpasswd_filename = ~/.config/radicale/users
htpasswd_encryption = plain

[storage]
filesystem_folder = ~/.var/lib/radicale/collections
```

Test it! It should work (assuming you've set up local service discovery for your myserver.local domain).

## SSL

```
sudo mkdir /etc/nginx/ssl
cd /etc/nginx/ssl
# Fill out what you want - Ensure Common Name matches myserver.local
sudo openssl req -new -x509 -nodes -newkey rsa:4096 -keyout server.key -out server.crt -days 3652
sudo chmod 400 server.key
sudo chmod 444 server.crt
```

Edit Nginx config:

```
server {
    listen 8001 ssl http2;
    server_name piserver.local;

    ssl_certificate ssl/server.crt;
    ssl_certificate_key ssl/server.key;
    
    location / {
        proxy_pass http://localhost:7001;
    }
}
```

Add the server.crt file to your linux machine (and similarly for your other devices!)

```
cd /usr/share/ca-certificates/
sudo mkdir myserver
scp ...
sudo chmod 755 myserver
sudo chmod 644 myserver/server.crt
# Equivalent to update-ca-certificates
trust extract-compat
```

[radicale-clients]: http://radicale.org/clients/
