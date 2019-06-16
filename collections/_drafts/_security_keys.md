# Security Keys in 2019 - Physical Second Factor Authentication

Security Keys are designed to allow remote parties (websites, banks, servers, and other people who manage a part of your life) to authenticate you, help confirm that this "action" **is** being done by you.

They are less helpful locally - for full-disk encryption or to login to your user account. However, they can be a bit more convenient at the cost of reducing security.

## Threat Modelling

Remote attackers
Phishing
Malware (keylogger, SSH key exfiltrator)
Opportunistic theft of device
Targeted theft of device
Opportunistic compromise of device
Targeted compromise of device

### Models

PC/laptop: Physical access past login screen impossible*
Mobile: Physical access past login screen unlikely*

* Except against Targeted attackers

Use U2F as a second-factor:
    Websites: Password on device/cloud + separate U2F security key


### Locally

PC:
    FDE: long passphrase OR TPM/Portable Security Key/Pin
    Login: short password OR Portable Security Key/Pin (TPM not needed as cannot get to login without FDE)
        Locked: 30m Time-limit before auto-sleep
        Sleep: 1h Time-limit before auto-hibernate
        Hibernate: see FDE
    Permanent Security Key:
        Why not built-in to PC? TPM? To reduce Zero-Touch attack.
laptop: FDE long passphrase
    Theft: More likely.
    Permanent Security Key: Bad idea?
mobile: FDE long passphrase + FaceID (short-term allowed)
    FaceID: Used recently
    Theft: Very likely.
        Theft while locked: minimal risk
        Theft while unlocked:
            Password Manager: Time-limit before auto-lock
            Krypton: ...

Security Key:
    This would be stronger if it used biometrics - e.g. Fingerprint, or FaceID

### SMS

Don't use SMS

## Categories

(T)OTP ((Time-based) One-Time Password)
U2F (Universal 2nd Factor)
WebAuthn
FIDO2 - no username, passwordless; just the security key
    * Note this is WebAuthn and CTAP
    * Server sends authentication challenge (with origin); it is signed by user's private key; then verified by server's public key of user
    * Successor to U2F.

Zero touch is not secure if your device is compromised. It is secure against remote attackers.

## Devices

Nitrokey
Yubikey
    * Portable NFC on keyring for mobile.
    * + permanently attached device for each PC/laptop.
Krypt - https://krypt.co/ - use your phone (U2F, SSH, Git/PGP)
    * https://krypt.co/docs/security/threat-model.html
Fireproof safe for paper keys and maybe a easy-access backup security device

[Permanent/Portable/Backup-FireSafe/Paper-FireSafe]

## Use-cases

* Website login - Use WebAuthn/U2F permanently plugged in, plus a portable backup that you carry, plus physical backup codes.
* Alternative - Use OTP (Google Authenticator), plus physical backup codes.
* SSH - Set up an authority? https://developers.yubico.com/PIV/Guides/SSH_user_certificates.html
    * Storing SSH key in device means it cannot be extracted from PC.
* Git tag/commit signing
* PGP signing
* Smartcard RSA key with LUKS?
* Desktop: TPM + *Portable NFC* Yubikey + Pin alternative fast-unlock of FDE [NOT 2FA]
* Desktop: *Portable NFC* Yubikey + short password for alternative fast-login to user [Consider auto-login if after FDE-login] .[NOT 2FA]
* Keepass?

> For LUKS, write a custom initramfs hook (shell script, in my case) to prompt the user for a "passphrase", use that as the challenge sent to the Yubikey, read the response from the Yubikey, write that to /crypto_keyfile.bin (in the initramfs, so not on disk), and the "encrypt" hook should use that file as the key to unlock the disk. You'll have to do it by hand once so that you can add the key (response) to a slot in LUKS. There's examples on Github of this but of course I didn't find them until I had already figured it out myself.
https://github.com/agherzan/yubikey-full-disk-encryption
