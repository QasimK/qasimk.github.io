# Smarter Laptop

A few features to make your laptop just a tiny bit smarter.

* Battery Thresholds - lower in evening and at night to preserve battery life,
                       but higher during the day to account for likely travel
* Lid Close - do not sleep when AC power plugged in
* External Display - disable laptop screen when particular external display is plugged in,
                     OR automatically move workspaces to external display
* App Power Saving - on battery, enable power save settings on mpv, waybar
                                 maybe automatically use SIGSTOP SIGCONT (rslsync)
* Hibernate Swap - enable large swap only when hibernating
* Suspend then Hibernate - hibernate after 2 hours of sleep, OR at midnight

A few features to make any computer a tiny bit smarter:

* Night Light - adjust based on time and location, but disable gradually when watching a video fullscreen
* Screen Brightness - adjust based on ambient light (triggers: lid open; screen dpms on; 5-secondly on AC)
* Dark Mode - enable dark mode between sunset and sunrise
* Backup - backup when external drive plugged in OR turn on computer at 4am and cloud backup
           (ensure it is after any automatic hibernate time!)

A few features specifically for Sway:

* Super Ultra Wide Display & Sway - resize windows to 16:9 when they are the only one on the screen (except in fullscreen mode)
