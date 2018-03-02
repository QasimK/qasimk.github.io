---
layout: post
title:  "Setting up Radicale on a Raspberry Pi"
tags:   linux guides arch raspberry-pi radicale
githubCommentIssueID: 3
---

{:toc}

I find it to be a little bit silly that I cannot sync my contacts and calendars directly across all of my devices. I don't really want to be reliant on Google or another central service to sync these. Unfortunately, I haven't come across something that will let you do this. The next best thing is actually significantly worse: setting up your own central service.

There are a number of different "apps" that can do this, ranging from monolithic OwnCloud/NextCloud set ups, to the simple Radicale app. I opted for Radicale on my puny little Raspberry Pi.

(It is useful that, previously, I set up [local service discovery][local-service-discovery] so I can access the Raspberry Pi at `piserver.local`. Otherwise I would have to assign a static IP... which I have anyway...).

There are a number of stages to setting up Radicale properly:

1. Accessible over the LAN, so that your devices and Radicale can talk to each other
2. As a service, so that you can survive reboots and manage it less
3. With user authentication, so Radicale can securely talk to you*
4. With encrypted transport, so that you can securely talk to Radicale*
5. With backups (TODO)
6. Accessible over the internet (TODO)

(* 3 and 4 could/**should** really be the same... but that would be a TLS digression.)

# Simple install

Let's install Radicale and simply test that it works.

We'll create an entirely distinct user as a cheap way to containerise the process:

```console
> sudo useradd -m radicale
> sudo su - radicale
> pip install --upgrade --user radicale
> touch ~/.config/radicale/config
```

Now configure radicale at `~/.config/radicale/config`:

```ini
[server]
# Bind to local machine only
hosts = localhost:5232

[storage]
filesystem_folder = ~/.var/lib/radicale/collections
```

And test that it works:

```console
> python -m radicale
```

Simply port-forward with SSH and try out the web interface at <http://localhost:5232>:

```console
> ssh -L localhost:5232:localhost:5232 piserver.local
```

(On my `localhost:5232` show me the remote's `localhost:5232`.)

# Accessible over the LAN

Now let's make it accessible over LAN and get rid of this port-forwarding nonsense.

Configure `/etc/hosts` with your static IP `192.168.1.<xyz> lanip`, and update the config:

```ini
[server]
# Bind to LAN interface only
hosts = lanip:5232

[storage]
filesystem_folder = ~/.var/lib/radicale/collections
```

Let's test it works:

```console
> python -m radicale
```

It should be now be accessible at <http://piserver.local:5232> (assuming you have also configured local service discovery with the hostname `piserver`).

# As a Service

Now let's create a service so that we don't have to run `python -m radicale` in a tmux session (or something), and so that we don't have to manage it after rebooting the machine.

We'll create simple systemd user service at `~/.config/systemd/user/radicale.service`:

```ini
[Unit]
Description=A simple CalDAV (calendar) and CardDAV (contact) server

[Service]
ExecStart=/usr/bin/env python -m radicale
Restart=on-failure

[Install]
WantedBy=default.target
```

We can manage this with the following commands:

```console
> systemctl --user enable radicale
> systemctl --user start radicale
> systemctl --user status radicale
> journalctl --user --unit radicale.service
> systemctl --user restart radicale
```

It should still be accessible at <http://piserver.local:5232>.

## Side Note: Problems using systemctl --user

I encountered an annoying issue with environment variables and using systemctl --user, which I managed to resolve by explicitly defining the following variables.

```sh
export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
```

# With user authentication

Now let's configure Radicale's user authentication so that Radicale doesn't leak our data to just anyone! (Note: there is no encryption so it's subject to MITM at this stage.)

We will use plain encryption for now because I couldn't figure out TODO: bcrypt. It isn't completely terrible so long as you use a unique password.

Create and edit `~/.config/radicale/users` with a simple username and password:

```
user:password
```

Configure the permissions, especially as the password is stored in plain-text:

```console
> chmod 0600 ~/.config/radicale/users
```

Configure `~/.config/radicale/config`:

```ini
[server]
# Bind to LAN interface only
hosts = lanip:5232

[auth]
type = htpasswd
htpasswd_filename = ~/.config/radicale/users
htpasswd_encryption = plain

[storage]
filesystem_folder = ~/.var/lib/radicale/collections
```

And let's test that logging in at <http://piserver.local:5232> requires the right username and password.

# Aside: Set up your clients

See the [client instructions][radicale-clients] and give it a test on a device to ensure everything is working well. This is useful to diagnose potential problems with the next step of adding HTTPS. The client devices will need to be set up again to use HTTPS later.

Delete the `~/.var/lib/radicale/collections` folder to clear the test data.

# With encrypted transport

Now let's configure HTTPS so that we cannot be subject to MITM over our local network by insecure IoT devices.

## Set up Nginx

Radicale supports HTTPS itself, but we will set up an Nginx server because it can be used for other local network services as well.

Install Nginx:

```console
> pacman -S --needed nginx-mainline
> sudo systemctl enable nginx.service
> sudo systemctl start nginx.service
```

Configure Nginx to support different websites for easier future maintenance:

```console
> sudo mkdir /etc/nginx/sites-available
> sudo mkdir /etc/nginx/sites-enabled
# Add "include sites-enabled/*;" to the end of the http block in /etc/nginx/nginx.conf
> sudo touch /etc/nginx/sites-available/radicale
> sudo ln -s /etc/nginx/sites-available/radicale  /etc/nginx/sites-enabled/radicale
```

We will configure Nginx to bind to all network interfaces, but deny connections from non-LAN IPs (this is a little round-about, but this way you don't have to know about the potentially dynamic LAN IP). Configure the radicale site at `/etc/nginx/sites-available/radicale`:

```nginx
server {
    listen 8001;
    server_name piserver.local;

    location / {
        allow 192.168.1.0/24;
        deny all;
        proxy_pass http://localhost:7001;
    }
}
```

We will configure Radicale to bind to localhost only (communicating over HTTP), leaving all actual communication with clients via Nginx (which will, later, use only HTTPS). Configure Radicale at `~/.config/radicale/config`:

```ini
[server]
# Bind to local machine only
hosts = localhost:7001

[auth]
type = htpasswd
htpasswd_filename = ~/.config/radicale/users
htpasswd_encryption = plain

[storage]
filesystem_folder = ~/.var/lib/radicale/collections
```

Now Radicale should be accessible at <http://piserver.local:8001>.

## Set up TLS

Create a self-signed SSL certificate:

```
> sudo mkdir /etc/nginx/ssl
> cd /etc/nginx/ssl
# Fill out what you want with the next command - ensure Common Name matches piserver.local
> sudo openssl req -new -x509 -nodes -newkey rsa:4096 -keyout server.key -out server.crt -days 3652
> sudo chmod 400 server.key
> sudo chmod 444 server.crt
```

Configure the Radicale site to use SSL at `/etc/nginx/sites-available/radicale`:

```nginx
server {
    listen 8001 ssl http2;
    server_name piserver.local;

    ssl_certificate ssl/server.crt;
    ssl_certificate_key ssl/server.key;

    location / {
        allow 192.168.1.0/24;
        deny all;
        proxy_pass http://localhost:7001;
    }
}
```

(TODO: The SSL options could be hardened for super-security.)

Add the certificate to your devices (take a look at the bonus sections below), and confirm that Radicale is only accessible at <https://piserver.local:8001>.


# Bonus: Importing Your Google Calender

I used Evolution to do this.

1. Download the calender file (basics.ics) from your Google account.
2. Add it to Evolution (`New Calender >> On this Computer >> Use existing file`)
3. Copy these events to your Radicale calender using Evolution's copy functionality.
4. Delete your old calendar if everything looks good.

# Bonus: Adding your certificate to Linux devices

Add the server.crt file to your current Linux machine (and similarly for your other devices!).

```console
> cd /usr/share/ca-certificates/trust-source/anchors
# Copy the certificate from the server
# scp ...
> sudo chmod 644 myserver/server.crt piserver.crt
# Equivalent to sudo update-ca-certificates on Ubuntu
> sudo trust extract-compat
```

(Note: Firefox does not use Operating System certificates, so manually add an exception for that in the browser.)

# Bonus: Adding your certificate to iOS devices

There are two ways to import a certificate on iOS. Open it in the mail app (i.e. email it to yourself), or download it in Safari (e.g. put it in Dropbox, and create a shared link to manually type into Safari's private browsing mode).

Add the certificate as a configuration profile, which is enough for CardDav and CalDav setups on iOS. Radicale's web interface requires an additional activation step for Safari at `General >> About >> Trusted Certificates`. This is useful to verify that you can access `https://piserver.local:8001`.


[local-service-discovery]: <{{ site.baseurl }}{% post_url 2017-05-26-local-service-discovery %}>
[radicale-clients]: http://radicale.org/clients/
