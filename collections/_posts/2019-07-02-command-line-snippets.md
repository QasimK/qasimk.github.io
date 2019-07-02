---
layout: default-post
title:  "Managing your Command-line Snippets"
tags:   linux shell
githubCommentIssueID: 15
---

<div markdown="1" style="text-align: center">
[My Command-line Snippets][my-snippets]
</div>

I found a tool called [Pet][pet] to help remember useful terminal commands.
My current method is split between [The Programmer's Compendium][programmer's-compendium],
this blog (but via the GitHub repo itself since there is no public page), and my
shell history. The latter is very useful but it suffers from not being
cross-device (or even cross-container on the same machine).

It is essential for me to be able to share these commands across my devices
because I use both a desktop and a laptop. In addition, I think it is important
to be able to share these commands with other people. I have found sharing
things to be very beneficial to myself as this blog and The Programmer's Compendium
both attest to. *It is somewhere you can go to look things up yourself.*

While it may be possible to sync my raw shell history across my devices, and
I think this is something that I should look into anyway, it is not suitable
for sharing with others. It's too easy to accidentally leak something sensitive,
whether passwords, API tokens, or details of private projects. In addition,
the signal-to-noise ratio will be abysmal.

Pet allows me to curate commands for myself and for others at the same time.
It provides a way to share them, and to search through them. It gives you
somewhere to go to look up commands, on both the command-line and, importantly,
the web.

Using Pet is not as seamless as using a shell alias/function. For example,
I have an alias called `rmpycache` which will delete all Python cache files within
the folder. I can simply type `rmpy`, auto-complete the command, and I'm done.

With Pet, on the other hand, I would have to execute `pet exec`, type `rmpy`,
check it is the command I'm after, and then finally execute it.

I think Pet is most useful for seldom used commands which you easily forget.
I would still use shell functions and aliases for day-to-day activities.

An example of a command that I have put into Pet is using `ffmpeg` to crop
a video between two timestamps. I use it maybe a few times a year and I always
have to look it up. I usually end up on [StackOverflow's question][so-ffmpeg]
where I will read through most of the thread before ending up on the *same*
answer.


## Public and Semi-Private Snippets

It is possible to configure public and private instances of Pet.

```
pet-private = pet --config $HOME/.config/pet/config-private.toml
```

It is important to edit the config so that  `snippetfile` and `gist_id`
are different between the public and private instances.

If you choose to sync with GitHub, then it is important to note that the resulting
gist is not encrypted end-to-end. Also while it is not discoverable, you can
share the link to the gist with others.

For this reason, I'm not sure that it is particularly useful. I had the idea to
use Pet in this way, but I don't actually use it like this.

An alternative might be to simply sync the private Pet snippets file itself using
your existing sync tool (e.g. Syncthing, Dropbox).


## Searching for other people's snippets

GitHub can function as a [searchable repository of public snippets][search-gists].
It is not great, but not terrible either. It is functional if you are looking
for ideas.

In particular, you can search for snippets that use a particular tool or by the
user's description of the command, for example if you are looking for
[one-liners involving exiftool][search-exiftool].


[my-snippets]: https://gist.github.com/QasimK/0fe6ebc15559965b10d6cf2cab1e1e8f
[programmer's-compendium]: https://qasimk.gitbooks.io/programmers-compendium/content/
[pet]: https://github.com/knqyf263/pet/
[so-ffmpeg]: https://stackoverflow.com/questions/18444194/cutting-the-videos-based-on-start-and-end-time-using-ffmpeg
[search-gists]: https://gist.github.com/search?l=TOML&=filename%3Apet-snippet.toml
[search-exiftool]: https://gist.github.com/search?l=TOML&q=filename%3Apet-snippet.toml+exiftool
