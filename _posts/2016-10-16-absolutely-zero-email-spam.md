---
layout: post
title:  "Getting to Absolutely Zero Email Spam"
date:   2016-10-16 17:41:27 +0100
tags:   "Life Hack"
---
Somewhere along the line I made a mistake with who I gave my email address to (and I have no idea who).
Thus started the spam.

While Gmail pretty much catches all of it and shoves it into the spam folder, you still have to glance through the spam folder to catch false positives. This can be quite a horrible experience.

## Possible strategies

There are different strategies, each one has their own downsides.

- Let the spam filter catch it. I'm writing this blog post because I believe this these aren't good enough (false positives, false negatives and having to actually look at spam once in a while).
- Use Gmail and its aliases and filters to do something like `me+thingy@gmail.com`, or use equivalent aliases in your other email provider. The alias can easily be stripped off in Gmail's case, and other email providers may have very small limits on the number of aliases you can hold.
- Whitelist `From:` email addresses (and block all others). The largest downside is that it can cause difficulties in receiving emails. For example, sub-domains may be used or you may not even know the email of someone you are expecting an email from. Maintaining such a list is difficult as you must whitelist before you can give your email.
- Use a custom domain and create `emails@domain.com`. You will need to use a paid-for email provider (even if you have already purchased the domain), and I wasn't able to find one that was a fixed fee for unlimited (or large enough finite number of) email addresses. Further, you may need to direct emails into a single inbox, somehow.

## The compromised solution

The compromise is to allow anyone to send you an email, but only to pre-defined email addresses. Essentially you are whitelisting a `To:` email address.

This can be done for free with Gmail with its aliasing system and by using a large number of filters. The core filter is to bin all emails to your unaliased address (`me@gmail.com`). Then you whitelist email addresses for each purpose, sending it to a specific label. For example, you can filter `me+amazon.j83x@gm.com`, sending it to the `Amazon` label. The alias has two parts, the first is the group who you are giving the email to (Amazon), and the second is a few random characters (j83x) that will prevent anyone from guessing the whitelisted email.

An important implementation note with Gmail is that the bin filter must be the last filter applied, and it should bin all emails that *do not have a label*. Re-ordering labels is possible with Gmail but it is tricky (export, edit, and re-import, or edit the label to move it to the top/bottom).

On the upside, anyone can email you given an email that you've setup and they can share this email with whoever. If they leak it, you will know who did it (and you don't care if they strip the alias off because they're all going to the bin). You can easily stop spam by deleting the filter.

On the downside, you must create an alias beforehand. This can be mitigated slightly by having a generic emails for groups of people like `me+friends.v5a4@gm.com`.

The system is easier to manage if you use a password manager that will keep track of your login details (email/username + password) for each service. I really hope you are using one.

## Things to consider

- Emailing can be trickier since you must email from the appropriate aliased email (or have a generic one for certain purposes which is ephemeral and changed every few months, e.g. `me+support.12@gm.com`)
- Emailing can be even trickier - on an iPhone (iOS 9) in order to change the `From:` email, you must set up Gmail manually as IMAP and maintain a list of valid `From:` emails for that account (setting each one up through settings).
- Some services do not allow the use of a plus sign in the email. Sigh.

## I lament the fact this is necessary

It's a terrible shame that emails **are** leaked by third-parties that you trusted. Their systems can be hacked (and really, truly this happens far more often than you may think) where they will find email addresses in plaintext, or worse, they'll just sell them. You have situations all the way in between these two. They may just have accidentally shared your email when mass-emailing, or given your email to a third-party that they themselves trusted.

Spam is a very difficult problem to solve simply judging by the fact that I'm writing this post in 2016. It has been around for a long time in emails, forums, and real-life post. This solution mitigates the spam in just one aspect of our lives.

Can I put up an email address for this blog? Possibly. I certainly have the capability to change it easily if the spam becomes too much.
