---
layout: default-post
title:  "Running Firefox with a Temporary Profile"
tags:   firefox privacy
githubCommentIssueID: 14
---

I was trying to book a hotel, but the somewhat-awful website wouldn't let me
complete the online purchase. I know the website is awful because it wouldn't
accept [my plus-addressed email][plus-addressed-email] either.

Suspecting it was one of my tweaks to the privacy settings or a privacy-protecting
add-on, I wanted a quick way to use the website without any of these alterations.

So, I found this very short shell script (which I've slightly modified) to do
exactly that. It will start a fresh instance of Firefox and delete it when you
are done.

```
#!/bin/sh
# Start Firefox with a temporary profile

set -eu

PROFILEDIR=$(mktemp -p /tmp -d tmp-ff-profile.XXXXXX.d)
firefox -profile "$PROFILEDIR" -no-remote -new-instance
rm -rf "$PROFILEDIR"
```

It isn't perfect because it does allow websites to use browser fingerprinting
to identify you. However, this is a compromise I'm willing to make for the rare
occasion that I will want to use it.

An idea that I had was to use firejail (or a similar application-sandboxer) to
provide additional security. However, I suspect this blog post wouldn't be posted
*this* year if I went off exploring this!

This could also be useful when you *do* want to let websites track you across
the internet. For example, when you use a cashback website that needs to track
you across the shopping site.


[plus-addressed-email]: <{{ site.baseurl }}{% post_url 2016-10-16-absolutely-zero-email-spam %}>
