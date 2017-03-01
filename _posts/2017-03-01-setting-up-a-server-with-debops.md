---
layout: post
title:  "Setting up a VPS using DebOps"
date:   2017-03-01 17:41:27 +0000
tags:   DevOps
---

One of the better ways to set up your own server in the cloud (for whatever
purpose) is to use [Ansible](https://docs.ansible.com/ansible/) - a declarative
command-line task automation platform. Write what you want your machine(s) to
look like and then run it.

I used Ansible to securely set up my Nginx-uWSGI-Postgres-Python web app.
The ansible playbooks created my admin user, secured the server
(secured SSH, set up UFW as a firewall, started unattended-upgrades,
established Fail2Ban), pulled the repository (with securely scanned
fingerprints), created a Python Virtualenv, installed all dependencies,
setup Postgres for my app, setup and started uWSGI, created the
[Let's Encrypt](https://letsencrypt.org/) certificate (with auto-renewal) and
finally setup Nginx with a [A+ SSL rating](https://www.ssllabs.com/ssltest/analyze.html).
All in a single 'Everything' playbook, with tags so that I could do very quick
deploys.

It was a great learning curve covering a huge variety of new Linux (and general)
topics. Most things mentioned (outside Python) were new to me and the whole
process probably took between 10-30 hours in total.

It doesn't have to be that hard. I didn't know about
[Ansible Galaxy](https://galaxy.ansible.com/). It pretty much has a role for
every component mentioned which does the hard work for you.

I'm not sure that I would have told myself about it though, the shear number
of things that I learnt made it worth doing the hard way.

Recently I discovered [DebOps](https://debops.org/) which I tried out recently
and I would recommend. I'm not sure about the pre-requisite knowledge required
and it even took me a bit longer than I would liked to understand it.
Essentially it does "everything". The most important aspects are that it covers
*bootstrapping* your machine and sets it up securely automatically.
Other roles are cherries on top.

Since it's difficult to get started, I'll write up a brief guide to just get
things to work.

## From DebOps to a working server

The [docs](https://docs.debops.org/en/latest/) are *almost* quite well
documented and you can use these to understand other configuration variables
available. After this little section is an appendix which has explanations
and covers the changes I made from the following steps:

1. Create your VPS server which may use a root password to login or a pre-set
SSH key.
2. Create or use an existing VCS repository with a Python Virtualenv that
installs `ansible` and `debops`.
3. Run `debops-init <your_project_name>` which will create a new folder which
even has a `.gitignore` within. This is an automatically created structure.
4. Run `debops-update` to retrieve/update modules.
5. Add your machine within the `hosts` file under `[debops_all_hosts]`, e.g.
`myserver asible_ssh_host=123.456.789.000`.
6. If you are connecting via a password, ensure you SSH in beforehand so
that your local `known_hosts` has your server and add `--ask-pass` as shown.
7. Now we can bootstrap the machine which creates your users and ensures
Ansible can run in the future:
`debops bootstrap --limit myserver --user root --ask-pass`
8. Now you can run the debops playbooks using `debops -l <host>` to limit it to
the specified host.

Now you can do whatever else you want by creating your own Ansible playbooks in
`ansible/playbooks`, creating your own roles in `ansible/roles` or installing
pre-made roles from Ansible Galaxy.

## Details

Debops is a wrapper over Ansible which runs a lot of its own modules. You do not
have to a create a playbook to run it, and many modules do not need
any configuration to be enabled and to run.

You can configure modules using variables which you can keep within
`ansible/inventory`. This is split up into host-specific variables, and
variables for groups of hosts. This is a standard Ansible structure and further
information can be found within the Ansible docs. Specifically create variable
files within `ansible/inventory/group_vars/all/` named after the debops module.

I created `bootstrap.yaml`

```YAML
---
bootstrap__admin_default_users: []
bootstrap__admin_sshkeys: []
bootstrap__admin_users:
  - name: me
    sshkeys: ["{{ lookup('file', inventory_dir + '/../playbooks/mysshkey.pub') }}"]
```

By default debops will bootstrap using your local user and any SSH keys it can
get its hands out. I didn't want it to be so promiscuous.

I created `apt_install.yaml` to install the packages I always want

```YAML
apt_install__packages:
  - vim
  - htop
  - mosh
```

I created `root_account.yaml` and `sshd.yaml` because I don't want to use the
root account.

```YAML
---
root_account__generate_ssh_key: no
sshd__permit_root_login: 'no'
```

I created `unattended_upgrades.yaml` so that it reboots to apply certain
upgrades. Debops is secure because unattended-upgrades is on by default (at
the very least for security upgrades).

```YAML
---
unattended_upgrades__auto_reboot: yes
```

I enabled Fail2Ban by adding *all* hosts to the Fail2Ban group in the `hosts`
file

```INI
[debops_fail2ban:children]
debops_all_hosts
```

There is a firewall enabled by default.

There are other modules you may be interested in regarding the host/domain name,
and the date-time settings.
