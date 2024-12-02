<div align="center"><img src="assets/nixos-logo.png" width="300px"></div>
<h1 align="center">MaxMur ❄️ NixOS Public Configuration</h1>

<div align="center">

![stars](https://img.shields.io/github/stars/TheMaxMur/NixOS-Configuration?label=Stars&color=F5A97F&labelColor=303446&style=flat&logo=starship&logoColor=F5A97F)
![nixos](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A&colorB=8aadf4)
![flake check](https://img.shields.io/static/v1?label=Nix%20Flake&message=Check&style=flat&logo=nixos&colorA=24273A&colorB=9173ff&logoColor=CAD3F5)
![license](https://img.shields.io/static/v1.svg?style=flat&label=License&message=Unlicense&colorA=24273A&colorB=91d7e3&logo=unlicense&logoColor=91d7e3&)

</div>

## Table of contents

- [Table of contents](#table-of-contents)
- [✨ Features](#-features)
- [📁 File structure](#-file-structure)
- [📘 Software](#-software)
- [👀 Network topology](#-network-topology)
- [🖥️ Hosts description](#️-hosts-description)
- [⌨️ Keyboard](#️-keyboard)
- [❤️ Special thanks](#️-special-thanks)
- [⭐ Star History](#-star-history)

## ✨ Features

- ❄️ Flakes -- for precise dependency management of the entire system.
- 🏡 Home Manager -- to configure all used software for the user.
- 💽 Disko -- for declarative disk management: luks + lvm + btrfs.
- ⚠️ Impermanence -- to remove junk files and directories that are not specified in the config.
- 💈 Stylix -- to customize the theme for the entire system and the software you use.
- 🍎 NixDarwin -- to declaratively customize MacOS.
- 🔐 Lanzaboot -- to securely boot the system.
- 📁 Config file structure and modules with options.

## 📁 File structure

- [❄️ flake.nix](flake.nix) configuration entry point
- [🏡 home](home/default.nix) entry point for creating a home manager user
  - [🧩 modules](home/modules/) home manager modules
  - [♻️ overlays](home/overlays) home manager overlays
  - [👤 users](home/users) users configurations for home manager
    - [🧩 modules](home/users/maxmur/modules/) home manager user modules
- [📃 lib](lib/default.nix) helper functions for creating configurations
- [🧩 modules](modules/default.nix) common modules for nixos/nixDarwin/home-manager
- [♻️ overlays](overlays/) common overlays
- [❄️parts](parts/) flake parts modules
- [💀pkgs](pkgs/) self-sealed packages
- [🖥️ system](system/default.nix) entry point for creating a machine
  - [🏎️ machine](system/machine) machines configurations
    - [🚀 hostname](system/machine/pcbox/) starting the configuration of a specific machine
      - [🧩 modules](system/machine/pcbox/modules) machine modules
        - [💾 hardware](system/machine/pcbox/modules/hardware) machine hardware modules
  - [🧩 modules](system/modules) common modules for machines
  - [♻️ overlays](system/overlays) common overlays for machines
- [📄 templates](templates/default.nix) templates for creating configuration parts

## 📘 Software

- OS - [**`NixOS`**](https://nixos.org/)
- Theme - [**`Nord`**](https://github.com/nordtheme/nord)
- Wallpapers - [**`Grey wave`**](assets/grey_gradient.png)
- Editor - [**`Neovim`**](https://neovim.io/)
- Bar - [**`Waybar`**](https://github.com/Alexays/Waybar)
- Terminal - [**`Foot`**](https://codeberg.org/dnkl/foot)
- Shell - [**`Fish`**](https://fishshell.com/)
- Promt - [**`Starship`**](https://starship.rs/)
- Filemanager - [**`Yazi`**](https://github.com/sxyazi/yazi)

## 👀 Network topology

These diagrams show the network topology of my home network.

![main.svg](assets/network/main.svg)

![network.svg](assets/network/network.svg)

## 🖥️ Hosts description

| Hostname | Board                          | CPU              | RAM  | GPU                                  | OS    | State |
| -------- | ------------------------------ | ---------------- | ---- | ------------------------------------ | ----- | ----- |
| pcbox    | X299 AORUS Ultra Gaming Pro-CF | i7-7800X         | 64GB | Sapphire AMD Radeon RX 7600 XT PULSE | NixOS | OK    |
| nbox     | Asus ZenBook 2024 Oled         | Ultra7 155h      | 32GB | Integrated Intel Arc (?)             | NixOS | OK    |
| rasp     | Raspberry Pi 4                 | Broadcom BCM2711 | 4GB  | Broadcom VideoCore VI                | NixOS | OK    |
| macbox   | Mac Mini M1                    | Apple Silicon M1 | 8GB  | Apple M1 8-Core GPU                  | MacOS | ?     |

## ⌨️ Keyboard

I use corne split with a modified [miryoku](https://github.com/manna-harbour/miryoku) layout. This is one of the most affordable and easy options for an ergonomic keyboard.

- WS Heavy Tactile switches
- Blank white PBT Cherry keycaps
- KBDFANS switch pads
- Tape mod
- O-rings
- Jincomso wrist rest

<details><summary>Layer 0 Main</summary>

![layer-0.png](assets/keyboard/layer-0.png)

</details>

<details><summary>Layer 1 Media</summary>

![layer-1.png](assets/keyboard/layer-1.png)

</details>

<details><summary>Layer 2 Nav</summary>

![layer-2.png](assets/keyboard/layer-2.png)

</details>

<details><summary>Layer 3 Mouse</summary>

![layer-3.png](assets/keyboard/layer-3.png)

</details>

<details><summary>Layer 4 Sym</summary>

![layer-4.png](assets/keyboard/layer-4.png)

</details>

<details><summary>Layer 5 Num</summary>

![layer-5.png](assets/keyboard/layer-5.png)

</details>

<details><summary>Layer 6 Fun</summary>

![layer-6.png](assets/keyboard/layer-6.png)

</details>

## ❤️ Special thanks

[Hand7s](https://github.com/s0me1newithhand7s)

[Kamillaova](https://github.com/Kamillaova)

[SHTRAMPANTUNC](https://github.com/SHTRAMPANTUNC)

[lazycaat](https://github.com/lazycaat)

[voronind-com](https://github.com/voronind-com)

## ⭐ Star History

<a href="https://star-history.com/#TheMaxMur/NixOS-Configuration&Date">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=TheMaxMur/NixOS-Configuration&type=Date&theme=dark" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=TheMaxMur/NixOS-Configuration&type=Date" />
   <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=TheMaxMur/NixOS-Configuration&type=Date" />
 </picture>
</a>
