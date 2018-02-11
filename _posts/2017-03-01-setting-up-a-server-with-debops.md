---
layout: post
title:  "Setting up a VPS using DebOps"
date:   2017-03-01 17:41:27 +0000
tags:   DevOps
githubCommentIssueId: 6
---

One of the better ways to set up your own server in the cloud (for whatever
purpose) is to use [Ansible](https://docs.ansible.com/ansible/) - a declarative,
idempotent, command-line task automation platform. Write what you want
your machine(s) to look like and then run it.

I used Ansible to securely set up my Nginx-uWSGI-Postgres-Python web app.
The 'Everything' Ansible playbook created my admin and web app users,
secured the server (ie. secured SSH, set up UFW as a firewall,
started unattended-upgrades, established Fail2Ban), pulled the repository
(with securely scanned fingerprints), created a Python Virtualenv, installed all
dependencies, setup Postgres for my app, set up and started uWSGI, created the
[Let's Encrypt](https://letsencrypt.org/) certificate (with auto-renewal), and
finally setup Nginx with a [A+ SSL rating](https://www.ssllabs.com/ssltest/analyze.html).
All in a single 'Everything' playbook, with tags so that I could do very quick
deploys.

It was a great learning experience covering a huge variety of new topics from
Linux server security and management to web application deployment.
Most things mentioned (outside Python) were new to me and the whole process
probably took between 10-20 hours in total.

It doesn't have to be that hard though. I didn't know about
[Ansible Galaxy](https://galaxy.ansible.com/) which is a collection of
open-source roles for every component mentioned and many more saving you
the time of having to write them yourself.

I'm not sure that I would have told myself about it though, the sheer number
of things that I learnt made it worth doing this the hard way.

Recently I discovered and tried [DebOps](https://debops.org/) and I would
recommend using it because it essentially does "everything" for you. The most
important aspects are that it covers *bootstrapping your machine* (you don't
have to SSH in to it at all) and sets it up to be *secure by default*.
The other roles that it covers are like a cherry on top.
I'm not sure about the pre-requisite knowledge required and it took me
a bit longer than I would liked to get started with it and to understand the
general idea of how it works.

Since it's difficult to get started, I'll write up a brief guide to just get
things to work.

## From DebOps to a Working Server

The [docs](https://docs.debops.org/en/latest/) are *almost* well-documented
and you can use these to understand other configuration variables and modules
available. At the end of this post is an appendix which has further
explanations and covers the changes I made from the following steps:

1. Create our VPS server with our favourite provider, specifying either a root
   password or an SSH key to access it.
2. Create or use an existing VCS repository with a Python 2 Virtualenv that
   installs `ansible` and `debops`.
3. Run `debops-init <your_project_name>`. This creates a best-practices folder
   structure that even includes a `.gitignore`.
4. Run `debops-update` to retrieve/update DebOps modules on our machine.
5. Add our VPS server within the `hosts` file under, e.g.
```
[debops_all_hosts]
myserver asible_ssh_host=123.456.789.000
```
6. If we are connecting via a password, ensure we SSH in beforehand so that our
   local `known_hosts` has the server fingerprint, and add `--ask-pass` when
   bootstrapping in the next step.
7. Bootstrap the machine (which creates our users and ensures Ansible can run)
   with:
```
debops bootstrap --limit myserver --user root --ask-pass
```
8. Run the DebOps playbooks for all hosts running with just: `debops`.

Now, we can do whatever else we would normally do with Ansible by creating
our own Ansible playbooks in `ansible/playbooks`, creating our own roles in
`ansible/roles`, installing pre-made roles from Ansible Galaxy, or using the
additionally roles from DebOps.

## Conclusion

You may recall **DRY** "Don't Repeat Yourself". Ansible is designed to follow this
principle allowing you to set up your servers *again and again* without having
to do the work *again and again*.

The creators and contributors to Ansible Galaxy and DebOps have created
something that goes further and allow you to abide by the enhanced principle,
**DRYER** "Don't Replicate Your Earthlings Relentlessly".

## Appendix: Details

Debops is a wrapper over Ansible which runs a lot of its own modules. You do not
have to a create a playbook to run it, and many modules do not need
any configuration to be enabled and to run.

Instead of using `ansible.cfg` for Ansible settings you should use
`.debops.cfg`. It may be useful to enable SSH pipelining to speed things up
(the Debops playbook takes a few too many minutes to run as it is).

```ini
[defaults]
nocows = True

[ssh_connection]
pipelining = True
```

You can configure modules using variables which you can keep within
`ansible/inventory`. This is split up into host-specific variables, and
variables for groups of hosts. This is a standard Ansible structure and further
information can be found within the Ansible docs. Specifically create variable
files within `ansible/inventory/group_vars/all/` named after the corresponding
DebOps module.

The default configuration of modules does many different things including:

* Establishing a firewall
* Creating new DH parameters (both locally within `ansible/secrets` for a quick
initial pre-seeding, and then the server is configured to auto-regenerate them
periodically.)
* Many, many... Other things

### Bootstrap

I created `bootstrap.yaml` because default DebOps will bootstrap using your
local user and any SSH keys it can get its hands on.  I didn't want it to be so
promiscuous. Additionally, I wanted admin accounts to be non-system (i.e.
UID>1000 and using the `/home/` folder rather than the `/var/local/`).


```yaml
{% raw %}
---
bootstrap__admin_system: no
bootstrap__admin_default_users: []
bootstrap__admin_sshkeys: []
bootstrap__admin_users:
  - name: my_username
    sshkeys: ["{{ lookup('file', inventory_dir + '/../playbooks/qasimk_id_rsa.pub') }}"]
{% endraw %}
```

### APT

I created `apt_install.yaml` to install the packages I always want.

```yaml
---
apt_install__packages:
  - vim
  - htop
  - mosh
```

### Root Account

I created `root_account.yaml` and `sshd.yaml` because I wanted to generally
disable the usage of the root account. I'm not sure I have a good reason in this
case.

```yaml
---
root_account__generate_ssh_key: no
sshd__permit_root_login: 'no'
```

### Unattended Upgrades

I created `unattended_upgrades.yaml` so that it reboots to apply certain
upgrades automatically. Debops is secure because unattended-upgrades
is on by default (at the very least for security upgrades).

```yaml
---
unattended_upgrades__remove_unused: yes
unattended_upgrades__auto_reboot: yes
unattended_upgrades__auto_reboot_time: '02:30'
```

### Fail2Ban

I enabled Fail2Ban by adding *all* hosts to the Fail2Ban group in the `hosts`
file. This is not enabled by default.

```yaml
[debops_fail2ban:children]
debops_all_hosts
```

### Other

There are other modules you may be interested in regarding the host/domain name,
and the date-time settings.

You may want to allow mosh through, or set the console locale.

```yaml
----
ferm__rules: type=accept name=mosh protocol=udp dport=['60000:61000']
console_locales: ['en_GB.UTF-8']
```
