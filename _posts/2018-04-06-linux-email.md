---
layout: post
title:  "Simple Emailing Sending on Linux"
tags:   linux raspberry-pi arch
githubCommentIssueID: 12
---

You have a script and you want to send an email, or worse, someone *else*
has a program and they *are* sending an email. Many programs expect something
that is `sendmail` compatible to available on your system, e.g. cron scripts.

Rather than install a mail transfer agent and/or mail delivery agent and/or
and/or mail user agent, and god knows what other pieces make up a proper mailbox,
we can install something that *just* sends emails.

```sh
$ sudo pacman -S msmtp msmtp-mta
```

`msmtp` is the small program that does the sending and `msmtp-mta` provides
`sendmail` compatibility at `/usr/bin/sendmail`. The program requires a working
internet connection as it cannot queue emails. That's how simple it is.

We can use a 3rd party SMTP server such as SendGrid or Gmail with the
configuration at `/etc/msmtprc` (`0640 root:mail`):

```
defaults
aliases /etc/aliases
port 587
tls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
syslog on

account sendgrid
host smtp.sendgrid.net
auth on
user apikey
password ACTUALAPIKEYHERE
auto_from on
maildomain em.example.com

account default : sendgrid
```

There are a few tweaks to including enabling logging, automatically setting
a FROM email that is `user@maildomain.tld`, using the SendGrid account to send
emails by default if one is not otherwise specified, and finally setting up some
aliases.

We'll set up a default alias in `/etc/aliases` (`0640 root:mail`):

```
default: receiver@example.com
```

Add yourself to mail: `gpasswd -a <YOU> mail` (check with `id`).

We can test it with (the `default` alias will be mapped to the real recipient
email address defined earlier):

```sh
$ printf "Subject: Hello World\n\Or rather just me.\n" | msmtp default
```

Also, `mail default` works as an alternative.

## Notes

* We are using the `mail` group to avoid leaking our plaintext password from
  the configuration file. We can also use `~/.msmtprc` if we need to isolate
  sending accounts from other users/applications.
* We just `printf` because `echo` doesn't seem to new-line properly.
* We set the subject, but we should also set `To:` properly.
* Not sure how to get it to work with SendGrid's domain white-listing, but
  it doesn't really matter if you're just emailing yourself.
* `mail` has a terrible UX as I cannot do anything more than set a subject, when
  really it should be immediately obvious how to write the body of the email
  rather than just the subject.

The [Arch Linux Wiki][arch-wiki-msmtp] has more details!

[arch-wiki-msmtp]: <https://wiki.archlinux.org/index.php/Msmtp> 'The Wiki Rocks'
