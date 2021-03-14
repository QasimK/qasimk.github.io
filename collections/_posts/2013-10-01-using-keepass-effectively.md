---
layout: default-post
title:  "Using KeePass Effectively"
tags:   apps workflow
githubDiscussionID: 21
---

I managed to put together a system that allows me to access all of my online
accounts from wherever I am. I only need to remember a single password and use
different passwords for each website.

I use [Dropbox][dropbox-refer] (referral link) to store my [KeePass][keepass]
`.kbdx` file, keeping it up-to-date everywhere (and providing me with an
offline version).

# PC (Windows/Linux/Other)

Using [KeePass][keepass] is quite effortless on the PC.

I alter the default settings to allow for an easy work flow.

* Enable lock workspace when minimising, locking PC or switching accounts or when suspending/sleeping under Security. In this way you don't have to worry about locking the database file, just lock your PC when you move away (or close the laptop lid, or put your PC to sleep).
* Enable automatic saves when closing/locking database under Advanced. This makes sure that the database locks when you do the above. You can use Dropbox to go to a previous version if you find that you have made a mistake.
* You can manually lock the workspace with global hotkey `Ctrl-Alt-K` (to show the KeePass window) and then `Ctrl-L` (to lock it).

Here is how I typically use KeePas:

1. When I have to enter a username and password I press `Ctrl-Alt-A` with the username box selected (this is a global hot-key which will work since KeePass loads at start-up).
2. (I may be prompted to enter the master password if this is the first time.)
3. KeePass will automatically fill in the username and password form and login (note that this auto-type can be configured per account, by default it is set to `username {tab} password {enter}`).

This works because KeePass will automatically match the window title with what the account Title is. You can configure this in more detail if it doesn't work (or even use regex if you wanted). The simple automatic matching just checks if a subset of the title is in the active window title.

It is important to note that if you have an entry in the database open (say you were editing it) and then you lock the computer, the database will **not** lock.

# On Android

To make sure you have an offline version of your KeePass file, you either have to favourite it or use a 3rd party Dropbox app to manage offline files.

I have to say that using [KeePass on Android][keepassdroid] is a pain for many reasons including how annoying it is to enter a long password. The exact process is:

0. Switch from your browser/app that needs your username & password
1. Go to Dropbox
2. Navigate to and load your database
3. Enter your password (I usually tick the 'show password' box to make it easier)
4. Use the search bar to find your account (since I have so many accounts)
5. Switch back over to your original app
6. Pull down notification bar to copy username
7. Paste username into box
8. Pull down notification bar to copy password
9. Paste password into box and login
10. (Optional: Go back to KeePassDroid and lock database - usually I just let it automatically lock which takes one minute depending on your settings)

This is an extraordinarily long process which means I only actually login to something if I *really* have to.


[keepass]: http://keepass.info/
[dropbox-refer]: https://db.tt/WLuCPAW6
[keepassdroid]: https://play.google.com/store/apps/details?id=com.android.keepass&
