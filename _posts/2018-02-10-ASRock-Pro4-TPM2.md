---
layout: post
title: TPM2 on ASRock H97M Pro4 Motherboard
tags: security shorts bitlocker
githubCommentIssueID: 1
---

Using BitLocker to encrypt your PC without a [TPM][tpm-wiki] chip means having to enter the Full Disk Encryption password on booting up your PC (shutdown/hibernate/restart). This can cause problems with Windows 10's automated updates which can forcefully restart your PC. I personally encountered my PC entering a boot-loop, and the supposed-to-be-remotely-accessible PC is not remotely accessible until you enter the BitLocker password. While it's possible to use a number of different group policies and "pause updates" to reduce the incidence of this, it is still not hassle-free.

Window's [BitLocker documentation][windows-bitlocker] describes the various different security aspects involved in using a TPM chip. Essentially you can avoid entering a password on boot up, but you still have full-disk encryption. It is not reasonably possible to attack the PC while it is off. When it is turned on, you rely on Window's account login passwords (with possibly configured account lock-outs) to prevent access to data.

Most motherboards these days have TPM headers where you can add a TPM chip, usually sold-separately. AMD Ryzen processors actually come with TPM built-in. Linux doesn't really have any support for TPM.

It can be difficult to get the actual TPM chip itself. I wasn't able to get [ASRock's TPM-S][asrock-tpms] chip for the [ASRock H97M Pro4][asrock-motherboard] motherboard, but I was able to get ASRock's TPM2-S chip. The connector is the same, but the software-side does not seem to be backward's compatible. Fortunately, I found a [forum thread][asrock-forum] where it seemed that ASRock had a non-public BIOS available that supported the TPM2-S chip. I emailed ASRock directly and they provided the same [BIOS 2.10c file][asrock-new-bios].

It worked like a charm. They warned me that boot times might be longer, and I found they were *significantly* longer. I'm not sure if that is down to using TPM, or whether it is down to the new BIOS.

Note that the SHA256 of `H97MP42.10C` is `05c40914d9a6f419104c5d909d9994bc3fea7eee7d62fd80f33537a235a082eb`.

TODO: UEFI screen caps showing support.

[tpm-wiki]: https://en.wikipedia.org/wiki/Trusted_Platform_Module
[windows-bitlocker]: https://docs.microsoft.com/en-gb/windows/security/information-protection/bitlocker/bitlocker-overview
[asrock-motherboard]: http://www.asrock.com/mb/Intel/H97M%20Pro4/
[asrock-tpms]: http://www.asrock.com/mb/spec/card.asp?Model=TPM-S%20Module
[asrock-forum]: http://forum.asrock.com/forum_posts.asp?TID=5746
[asrock-new-bios]: /content/2018-02-10-H97MP42.10C.zip
