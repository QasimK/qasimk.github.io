I grew up with computers. To me that always meant a desk, a keyboard, a mouse, and a somewhat decent-sized monitor. This meant I always interacted with computers "optimally" for creating content. It was normal to write, to code, to edit pictures or whatever else.

For the longest time, I viewed mobiles primarily as communication devices, and mobiles and tablets as content consumption devices. I even viewed laptops poorly thinking they were not ergonomic and generally second-class compared to a proper workstation.

There has been a clear shift away from desktops and towards mobile, battery-powered computing devices, to the extent where many people _only_ have a phone. This is increasingly possible as computers are integrated into more everyday devices.

For content creation, tablets can be great for drawing. However if you want to write anything, you still need a keyboard. I think a mouse is pretty convenient too.

* I conflated a laptop with having an ergonomic and efficient working environment.
* I underestimated how far laptops had gone
* I overestimated by own use-cases
* I didn't match

It was not until recently that I realised a laptop can replace a desktop, almost entirely. They still have ~half the performance of a desktop, but they are capable of handling short, burst workloads quite well. They have very limited storage expansion options, but now SSD/M.2 NVMe sizes are reaching several TB. They have limited RAM slots, but this is the same as Mini-ITX motherboards. Their GPUs are pretty bad.

I realised something recently: a laptop can match a mini-ITX desktop.

* While for short, burst workloads you're fine on the CPU front, you'll get less than half the sustained performance (due to thermal throttling).
* You can connect an external GPU via thunderbolt (I hear).
* The same number of RAM slots.
* Significantly fewer storage slots.
* You can upgrade fewer components — but I personally never upgraded any desktop I've ever had.

It just costs twice as much (£500–1000 or 50–100%, and there is a much larger worry over the lifespan of the laptop due to battery degradation, wear and tear, and increased chances of theft.

In addition to this realisation, I've also come to accept that I play far fewer games. For me, this was always the biggest reason to have a decent desktop.

For storage, you can get an NVMe device that is 2TB, and SSDs that are larger.
These are sufficiently large

For redundancy (availability, e.g. with RAID), I have opted to not do anything.
Yes, something could happen, but it is unlikely, and I can cope with losing
24 hours of work. It is simpler to not need to manage multiple storage devices,
and you need backups anyway.

For the RAM, I don't really need anything beyond upper-normal levels. In 2019,
that would be 16GB. For 2020, I would like 32GB to just err on the safe side
as I do run VMs for work.

For the CPU. Yeah. I need something fast, but the burst performance of laptop
CPUs has improved. They are still TDP limited, and this makes me sad. I think
the performance is half

I have new demands that I didn't have before. I am more mobile now, I need my
computer with me in the different locations. Most obviously for work, which is
a big part of my life.

A huge part of the equation is the desktop. I conflated a laptop with having a
good working environment for some reason.

* Massive monitor
* Ergonomic desk and chair
* Keyboard + Mouse

A laptop can easily be added to this with just one wire.
That would be USB-C to the monitor. That is tricky to find.
A laptop dock would also work.

LXC/LXD containers start off at 2GB... Wow, compared to 10+GB for a VM.

Work
----
256GB V.Fast Storage
32GB RAM
Max CPU
iGPU
60Hz

Personal
--------
4TB V.Fast Storage
16GB RAM
Moderate CPU
iGPU
120Hz

Gaming
------
1TB Storage
16GB RAM
Max CPU
dGPU
120+Hz

The dGPU can be an eGPU over thunderbolt, if it really comes down to it.
But I'm not convinced this is great.

Storage wise, yeah just go for something bigger. and use external backups.

The big benefit that I haven't mentioned.

Having one machine. Seriously, one machine with everything on it. Seems dangerous,
but also oh-so-very convenient.

What improvements do I need?

* Nothing really... It has upgradeable storage.
* DP 1.4
* DP 2.0/HDMI 2.1

What improvements do I want?

* Support for upgradeable memory
* Support for Thunderbolt 4 (PCIe 4.0)
* Bigger NVMe storage than 2TB.

Software-wise what do I want?

* hi-DPI
* DCI-P3 Colour Gamut

How does my phone fit into this?

* A way to access my photos.


The other downside is lack of upgrades.

But if I think about it, I haven't ever upgraded partially. I usually did the
whole damn thing.


---

bigmessofwires.com/2019/05/19/explaining-4k-60hz-video-through-usb-c-hub/

What accessory do you need if the monitor does not support USB Type-C w/ DisplayPort
Alt Mode?

A 3-1 adapter like this: https://www.amazon.co.uk/dp/B07NL5FTTR/ (£22.99)

USB Type-C to DisplayPort 4-lane, USB 2.0, and Power Delivery.
The former two connect to your monitor, and the PD connects to the wall socket charger.

[VirtualLink](https://en.wikipedia.org/wiki/VirtualLink)
would improve this by converting USB 2.0 to USB 3.0, but I don't expect this
to be widely adopted.

Since the purpose is to power the laptop, VirtualLink's 15-27 W power support
is irrelevant.


---

What does this mean for the future?

In the medium-term, your phone (something pocket-sized) will replace the laptop.
The only thing blocking it is the lack of a keyboard and small screen.
However, I think optional accessories which a phone fits into will deal with this.
For the most part, you will plug it into your desk.

In the long-term, the device will be smaller than a phone, on you at all times.
You will use glasses as your screen.
