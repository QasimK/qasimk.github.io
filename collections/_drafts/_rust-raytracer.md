---
layout: default-post
title:  "Writing a ray tracer with Rust on a Raspberry Pi"
tags:   linux raspberry-pi rust project
---

Why would you want to write a ray tracer on a Raspberry Pi on Arch Linux (AArch64)? There is no good reason.

## Basic setup

[Install Rust][install-rust]. I opted to do a manual install
`curl -f https://sh.rustup.rs > rust.sh; view rust.sh; ./rust.sh`.

Test that it installed correctly:

```console
> rustc -V
rustc 1.21.0 (3b72af97e 2017-10-09)
```

Create your project on GitHub and clone it down. (TODO: ssh-agent.)

Initialise the project directory with `cargo init --bin`.

Test that Rust is working with:

```console
> cargo run
error: could not exec the linker `cc`: No such file or directory (os error 2)
```

Install Arch's `build-essential` equivalent: `pacman -S --needed base-devel`.

Succesfully run the basic "Hello, world!" program:

```console
   Compiling rust-raytracer v0.1.0 (file:///home/qasimk/projects/rust-raytracer)
    Finished dev [unoptimized + debuginfo] target(s) in 3.39 secs
     Running `target/debug/rust-raytracer`
Hello, world!
```

[Install Rustfmt][install-rustfmt]: `cargo install rustfmt`

[Install vim-plug][install-vimplug].

Install various pluguns: rust.vim.

Test Rustfmt on hello world by incorrectly indenting a line.



[install-rust]: https://wiki.archlinux.org/index.php/Rust
[install-rustfmt]: https://github.com/rust-lang-nursery/rustfmt
[install-vimplug]: https://github.com/junegunn/vim-plug
