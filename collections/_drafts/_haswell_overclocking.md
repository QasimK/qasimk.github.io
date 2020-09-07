# Memory Overclocking

CPU: Haswell - 4670k
RAM:
Motherboard:

XMP: 1600 9-9-9-27 1.5V __. [Theoretical Score: 178]

Below @ 1.65V: (Prime95, MemTest, Prime95 Full)

2400 13-13-13-33 x

2200 13-13-13-33 ?
2200 12-12-12-33 ?
2200 11-12-12-33 ?
2200 11-11-12-32 x
2200 11-11-11-32 x  [score: 200]
2200 10-12-12-32 x

2133 11-12-12-31 .?? (MemTest86: 3h3m)
2133 11-11-12-31 .?? (MemTest86: ????)


2133 11-12-11-34 .?x

2133 11-11-11-34 x?? (1h two failures)
2133 11-11-11-33 .?x (6h one failure)
2133 11-11-11-32 .?x
2133 11-11-11-30 ..x
2133 11-11-11-29 x??
2133 11-11-11-27 1.650V ..x (MemTest86: 3h4m) [Theoretical Score: +33% BW; 194/+9%]
2133 11-11-11-27 1.625V x.?
2133 11-11-11-27 1.6V x.?
2133 11-11-11-27 1.575V x??
2133 11-11-11-27 1.55V ?x?
2133 11-11-11-27 1.5V ?x?

2133 10-12-12-31


1600 = 25.6 GB/s (365 MB/frame)
2133 = 34 GB/s (485 MB/frame)


## Method

1. Loosen timings, find max. frequency
2. Run Prime95 Large FETs (20 mins)
    a. Prime95 512-4096,in-place
3. Now tighten timings from left-to-right
4. Run a longer Prime95 test (Overnight - 8 hours)
5. Run MemTest86 (it's not as reliable at finding errors)

Secondary timings: https://www.overclock.net/forum/18051-memory/1630388-comprehensive-memory-overclocking-guide.html

Do not undervolt or overclock the CPU.

## DDR3 examples

1866 9-10-9-27 1.5V
2133 11-11-11-27 1.5V
2400 11-13-13-31 1.65V
2400 10-12-12-31 1.65V


# Core

1. Intel XTU (good at detecting stability)


Default voltage: ~1.213V


Pre:
    IET: 938
    3DMark: 3212


Target: 4.0 GHz all-core Core + Cache, -0.075V

Cache = Increase VCSSA 1.02V


## Methods

1. OCCT 8 hours - ultimate test


# Tools List

## Monitoring

CPU-Z
GPU-Z
HWMonitor
HWinfo - check hw errors row

## Stress Testing

(AIDA64 - Paid)
ocbase OCCT (CPU) [linpack]
Prime95 (CPU/RAM)
Realbench
IntelBurnTest
x264... (see /r/overclocking)
Furmark (GPU)
(MemTest86)

## Benchmarking

Userbenchmark
3DMark Time Spy
Cinebench 20 [Stress Test: File > Preferences > Minimum test duration]
SuperPi
Blender Benchmark
Unigine Supposition
Geekbench
CrystalDiskMark


CoreMax=1.30V
Cache/Vring/Uncore=1.45V/1.30V
InputVRIN/VCCIN=2.10V
(LLC minimal recommended**)

Core (V), Core, Cache (V), Cache, Input (V), Prime95 (30m), [Notes]
1.250, 44x, 1.20, 35x, 1.9, Fail
1.260, 44x, 1.20, 35x, 1.9, Fail
1.265, 44x, 1.20, 35x, 1.9, Fail
1.266, 44x, 1.20, 35x, 1.9, Fail
1.267, 44x, 1.20, 35x, 1.9, Fail
1.268, 44x, 1.20, 35x, 1.9, Fail
1.269, 44x, 1.20, 35x, 1.9, Fail
1.270, 44x, 1.20, 35x, 1.9, Fail 186/206/242[124]
1.275, 44x, 1.20, 35x, 1.9, Fail [x264 PASS]
1.280, 44x, 1.20, 35x, 1.9, Fail (lasted longer)
1.285, 44x, 1.20, 35x, 1.9, Fail  [188/215/245][LLC1; Various UEFI OC Settings]
1.285, 44x, 1.20, 35x, 1.9, Maybe [LLC2 1.904 VCCIN]
1.290, 44x, 1.20, 35x, 1.9, Maybe [191/] maybe [LLC2 1.888 VCCIN min]

1.285, 45x, 1.20, 35x, 2.0, Fail
1.295, 45x, 1.20, 35x, 2.0, Fail

==[Various UEFI OC Settings Enabled==

1.290, 44x, 1.20, 35x, 1.9, Fail    [?/216/247[127]]
1.295, 44x, 1.20, 35x, 1.9, PASS    [LLC1 190/216/248[128]]
1.295, 44x, 1.20, 35x, 1.9, PASS    [LLC3 1.840V VCCIN min]
1.295, 44x, 1.20, 35x, 1.9, PASS    [LLC5 1.776V VCCIN min]

==[LLC5]==

1.292, 44x, 1.20, 35x, 1.9, Fail-3H
1.295, 44x, 1.20, 35x, 1.9, Pass/Fail
1.295, 43x, 1.20, 35x, 1.9, _/Pass-1H
1.300, 44x, 1.20, 35x, 1.9, Pass/Pass
1.300, 44x, 1.20, 35x, 1.9, /Fail-1H40

1.250, 43x, 1.20, 35x, 1.9, /Pass-3H30 [77CAvg, 91CMax]
1.235, 43x, 1.20, 35x, 1.9, /Fail-2H
1.240, 43x, 1.20, 35x, 1.9, /Fail-1H
1.245, 43x, 1.20, 35x, 1.9, /Failed after a full day of testing
1.250, 43x, 1.20, 35x, 1.9 /?



~~~ Cache ~~~ [OCCT/Prime95]

1.300, 44x, 1.275, 44x, 1.9, Fail-1M
1.300, 44x, 1.275, 43x, 1.9, Maybe-5M
1.300, 44x, 1.200, 43x, 1.9, Fail-5M
1.300, 44x, 1.235, 43x, 1.9, Fail
1.300, 44x, 1.250, 43x, 1.9, Fail
1.300, 44x, 1.275, 43x, 1.9, Pass-1H/Fail-10M
1.300, 44x, 1.290, 43x, 1.9, /Fail-1H30
1.300, 44x, 1.235, 42x, 1.9, /Fail-15M
1.300, 44x, 1.250, 42x, 1.9, /Pass-1H30
1.300, 44x, 1.242, 42x, 1.9, /Fail-1H
1.300, 44x, 1.250, 42x, 1.9, /Fail-2H

[Need to repaste - uneven temps]



** LLC stops Vdroop (voltage drop under load, i.e. low -> high load).
** But it causes a voltage spike when high -> low which can damage CPU.
** https://www.masterslair.com/vdroop-and-load-line-calibration-is-vdroop-really-bad
