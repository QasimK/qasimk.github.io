Wayland replaces X11/X.Org


## Advantages

* HiDPI?
* Security
* Performance? No screen-tearing

## Disadvantages

* No Network Transparency

I don't think this is very important, as applications mostly bitmapped rather
than using X11's drawing primitives. So over the wire, images were being sent.

A proper remote desktop protocol should be implemented which should be have
the capability to share specific applications.

* Screen Sharing

Pipewire (Video + Audio) exists for whole-screen sharing, application sharing
and region sharing. There should be something implemented to handle permissions.

* Global Hotkeys

Since applications cannot globally access the keyboard. Perhaps there should
be a permissions-based protocol for applications to register/remove hot keys.
Otherwise, it must be manually configured by users for each Wayland implementation,
i.e. desktop environment.

* Window Manipulation

No global utility possible - again, protocol with permissions?

* Mouse Manipulation

Same.

* Night light

No global way to implement a night light (red-shift) feature. Currently
implementation specific.

* Configuring libinput

Does not exist under Wayland - but it does under X11!

* Display management, i.e. xrandr
* xdotool
* xkill

## Security

Does Wayland improve security? It removes one avenue of attack.

* No access to global input events (keyboard, mouse)
    * i.e. cannot just read sudo password
* No access to global screen (observe, manipulate)

But, there remain other avenues of attack:

* Manipulation of ~/ to install malicious binaries, or replace good binaries
with malicious ones.
* Use LD_PRELOAD to inject things into processes when they start without
explicitly changing PATH.
* Ptrace
    * Prevent with https://linux-audit.com/protect-ptrace-processes-kernel-yama-ptrace_scope/
* Read access to all of ~/, and the ability to exfiltrate data easily.
* Manipulate all running applications under your user.

[1]: https://www.reddit.com/r/linux/comments/6d8r0y/can_we_talk_for_a_short_moment_about_the/
