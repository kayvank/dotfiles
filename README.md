What is this?
---
my collection of _dot_ files for building my nixos systems.

## Installation
The installation process is in 2 stages:
- installing minimal system
- installing system & user configuration

### Obtaining NixOs
This step requires the minimal NixOs image. Options are:
+ download the minimal image
+ build the minimal image

#### Downloading minimal image:
Simply follow the steps in [NixOs user-guide](https://nixos.org/download.html#nixos-iso)

#### Building the minimal image
First, write the following in to a file named custom-media.nix:

``` sh
{ pkgs, modulesPath, ... }: {
    imports = [
        "${modulesPath}/installer/cd-dvd/installation-cd-graphical-gnome.nix"
    ];

    boot.kernelPackages = pkgs.linuxPackages_latest;
}
```

Then enter a nix-shell with nixos-generators and build the media:

``` sh
nix-shell -p nixos-generators
nix-shell$ nixos-generate -I nixpkgs=channel:nixos-unstable --format iso --configuration ./custom-media.nix 
```

Finally copy the ISO to USB disk, on my system its `/dev/sda`.

Note: the sync at the end is critical.

``` sh
$ sudo cp /nix/store/gnnbjvd916yh1f4svbgrssq94550pbxl-nixos-21.11pre304626.8ecc61c91a5-x86_64-linux.iso/iso/nixos-21.11pre304626.8ecc61c91a5-x86_64-linux.iso /dev/sda
$ sudo sync
```

## Installing minimal NixOs system
Follow the [NixOs Chapter2 user-guide](https://nixos.org/manual/nixos/stable/index.html#sec-installation)

### Side Note
For my system, I used [swap file](https://linuxize.com/post/create-a-linux-swap-file/) in favor of swap partition.

## Configuring the system
To configure the system:

``` sh
git clone git@github.com:kayvank/dotfiles.git ~/.config/dotfiles
cd ~/.config/dotfiles
```
+ Installing system configurations:
``` sh
./apply-system ## installs system configs
./update
```

+ Installing user configurations:

``` sh
cd ~./dotfiles
./apply-user.sh  ## installs user configs
./update
```


