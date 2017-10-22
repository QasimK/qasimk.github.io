

Install manually:

sudo useradd -m radicale
python3 -m pip install --upgrade --user radicale
vim .config/radicale/config

```ini
[server]
# Bind all addresses
hosts = lanip:5555

#[auth]
#type = htpasswd
#htpasswd_filename = /path/to/users
#htpasswd_encryption = bcrypt

[storage]
filesystem_folder = ~/.var/lib/radicale/collections
```

Configure /etc/hosts with `192.168.1.x lanip`


python3 -m pip install --upgrade --user bcrypt
