---
layout: default-post
title:  "Error loading KeePassXC on Arch Linux"
tags:   linux arch bug shorts outdated
---

I was hit by these errors after upgrading Arch:

```
keepassxc: error while loading shared libraries: libjson-c.so.2: cannot open shared object file: No such file or directory
keepassxc-cli: error while loading shared libraries: libjson-c.so.2: cannot open shared object file: No such file or directory
```

I found [this old bug report][bug-report], which had a solution which worked:

    pacman -S json-c

Not sure what the long-term solution is.


[bug-report]: https://bugs.archlinux.org/task/48037
