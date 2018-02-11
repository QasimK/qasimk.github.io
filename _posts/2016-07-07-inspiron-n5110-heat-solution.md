---
layout: post
title:  "Fixing an overheating Dell N5110 Inspiron laptop"
tags:   diy tech
githubCommentIssueId: 8
---

I own an Dell Inspiron N5110 and its fan has become increasingly louder and
more aggressive. I opened up the laptop and managed to reduce the peak
temperature by 20°C under load.

I followed in the [footsteps of someone else][amanek-guide] who had a similar
problem, and used [an iFixit guide][ifixit-guide] to open up my laptop. I used
a simple set of screwdrivers, isopropyl alcohol, and new thermal compound.

# During the operation

- I noticed that the dust build up in fan grill was not visible externally. The
  fan itself had to be unscrewed from the grill to see any sign of it. While
  there was a significant amount of dust within the grill, there was none
  elsewhere.
- The thermal *compound* on the CPU and GPU was not particularly dry and so it
  may not have been necessary to replace it, but I had to replace it once I had
  removed the heatsink from the chips (I believed). I carefully removed the old
  compound using isopropyl alcohol.
- The thermal *pads* became dusty easily, and unfortunately I did not have any
  replacement.
- Following the guide, I filled up some holes to prevent air from reaching the
  keyboard. The heat on the palm rest and left-side of the keyboard was
  something I particularly wanted to deal with.
- The chipset is on the top side of the motherboard, underneath the left palm
  rest area below the keyboard. *The chipset, and thus the palm rest, heats up
  significantly because there is no cooling for the chipset, nor the general
  area.*

# Conclusions

The heat issues are mostly solved except for the chipset which really irritates
my left hand. Overall,

- I had a peak temperature drop of 10-20°C (this was measured by two
  consecutive runs of Unigine Heaven and Cinebench before and after).
- There was no significant drop in idle temperatures, but the fan no longer
  spins up when under very light load.
- The biggest disappointment was the insignificant change in the heat on the
  surface of the keyboard.

I also tried to use HwInfo64 (IIRC) to control the fan speed to see if I could
have any improvements in the palm rest area.  There were only two settings
available: ~3000 and ~5000:

- Idle tempeatures hit about 40-45°C, and I did not achieve a significant drop
  by using a custom aggressive fan profile.
- The chipset did not cool down at all (grr).

Over the past few years, I have opened up my Dell laptop several times, whether
to clean it or to replace the HDD. It's possible that the problems I'm
experiencing now are a result of that. The mount and screws securing the
monitor on the left side are broken and the screen now has display problems as
it blacks out randomly. In addition, sometimes it refuses to turn on.

So some care should be taken when opening it up :)

A final and interesting side note: The battery is on 60% capacity after five
years which is in line [with what you might expect][battery-degradation].

[amanek-guide]: <http://amanek.com/how-ive-fixed-my-dell-inspiron-overheating-issues/>
[ifixit-guide]: <https://www.ifixit.com/Guide/Dell+Inspiron+n5110+heat+sink+and+thermal+paste+replacement/28204>
[battery-degradation]: <{{ site.baseurl }}{% post_url 2013-10-20-smartphone-replaceable-batteries %}>
