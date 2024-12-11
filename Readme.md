<div align="center"><img src="assets/nixos-logo.png" width="300px"></div>
<h1 align="center">Spotandjake ❄️ NixOS Public Configuration</h1>

<div align="center">

![stars](https://img.shields.io/github/stars/Spotandjake/NixOS-Configuration?label=Stars&color=F5A97F&labelColor=303446&style=flat&logo=starship&logoColor=F5A97F)
![nixos](https://img.shields.io/badge/NixOS-unstable-blue.svg?style=flat&logo=nixos&logoColor=CAD3F5&colorA=24273A&colorB=8aadf4)
![flake check](https://img.shields.io/static/v1?label=Nix%20Flake&message=Check&style=flat&logo=nixos&colorA=24273A&colorB=9173ff&logoColor=CAD3F5)
![license](https://img.shields.io/static/v1.svg?style=flat&label=License&message=Unlicense&colorA=24273A&colorB=91d7e3&logo=unlicense&logoColor=91d7e3&)

</div>

## 🦊 Introduction

This repository houses my Nix Configurations for my entire system. `config.nix` acts as a highly configurable system definition and the rest of the project is used to build and deeply customize my applications in a highly repeatable manner across different operating systems.

## 📚 Table of contents

- [🦊 Introduction](#-introduction)
- [📚 Table of contents](#-table-of-contents)
- [✨ Features](#-features)
- [📁 File structure](#-file-structure)
- [🤖 Software](#-software)
- [🖥️ Hosts description](#️-hosts-description)
- [⚙️ TODO](#️-todo)
- [🦋 Inspiration](#-inspiration)
- [License](#license)

## ✨ Features

- ❄️ `Flakes`: I use Nix Flakes for precise dependency management and configuration of my entire system
- 🏡 `Home Manager`: Configures all user facing software.
<!-- - ⚠️ `Impermanence`: Keeps my system fresh by treating only the configured directories and files as persistent -->
- 🍎 `NixDarwin`: Allows me to configure my entire mac declaratively.
- 📁 Config file structure and modules with options.

## 📁 File structure

- [⚡ install.sh](install.sh) A primitive bash installer
- [🖥️ config.nix](config.nix) A Single Configuration File For My Machines
- [❄️ flake.nix](flake.nix) Nix Configuration Entry Point
- [🏡 home](home/default.nix) Home Manager App Configurations
  - [🧩 modules](home/modules/) Home Manager Programs
- [📃 lib](lib/default.nix) Helper functions for creating my configurations.
- [🧩 modules](modules/default.nix) Common modules for `nixos`/`nixDarwin`/`home-manager`
- [♻️ overlays](overlays/) Common Nix Overlays
- [❄️ parts](parts/) Flake parts modules
- [📄 templates](templates/default.nix) Templates for creating configuration parts

## 🤖 Software

- OS - [**`MacOs`**](https://www.apple.com/macos/)
- Editor - [**`Visual Studio Code`**](https://code.visualstudio.com/)
- Terminal - [**`Iterm2`**](https://iterm2.com/index.html)
- Shell - [**`Nushell`**](https://www.nushell.sh/)
- Terminal Filemanager - [**`Yazi`**](https://github.com/sxyazi/yazi)

## 🖥️ Hosts description

| Hostname        | Board               | CPU              | RAM | GPU                 | OS    | State |
| --------------- | ------------------- | ---------------- | --- | ------------------- | ----- | ----- |
| JakesMacBook 💻 | 2020 MacBook Air M1 | Apple Silicon M1 | 8GB | Apple M1 8-Core GPU | MacOS | OK    |

## ⚙️ TODO

This repository is not fully setup and the parts that are, are still a little new below is a list of what I have left todo before considering this configuration complete.

- Packages
  - Microsoft Office
  - A Password Manager
    - It would be nice if it had cli features
    - Raycast support
    - Integrated with Nix setup?
  - Lunar Client
- Settings
  - Darwin
    - The dock
    - Keybindings
    - Anything else I have changed
      - I don't know if there is a good way to see this
  - Visual Studio Code
    - Cleanup User Settings
    - Move User Settings into Nix
    - Audit Keybindings
    - Move Keybindings Into Nix
    - Handle Extensions
  - GitKraken
    - I think these settings exist in `spotandjake/.gitkraken`
    - Try to make a home manager module and upstream
  - Iterm2
    - I think these settings exist in `spotandjake/.iterm2`
    - Try to make a home manager module and upstream
- Research
  - Secrets
    - Do I just use a password manager?
    - Git Signing Keys
    - Gitkraken Authentication
    - Local passkeys
    - Nix sops
      - This is for secret handling, I am wondering if I should just let the password manager handle this?
  - Impersistance
    - This makes any file not in the config act as temporary until the system reboots.
    - I need to handle this last as I don't want to nuke my settings
- My files
  - I need to figure out how I will be backing up my files
    - documents
    - minecraft world
    - desktop?
- General
  - Reset my Mac to this
- Cleanup
  - This is my first real Nix setup and I did some things in a non favorite way below is a list of cleanup.
  - Simplify `home/default.nix`
  - Improve `lib/default.nix`
  - Make a custom module system based around `./config.nix`
  - Remove configured settings in `modules/darwin/default.nix`
    - This sets up `nix-darwin` but I want this stuff to be configurable from `./config.nix`
- look into adding all my custom packages to local home-manager packages
  - consider upstreaming

## 🦋 Inspiration

- [Initial Nix Setup On Mac](https://nixcademy.com/posts/nix-on-macos/)
  - This blog post is a great walkthrough on how to setup `nix-darwin` for Mac.
- [Dotfiles Configuration](https://github.com/nmasur/dotfiles)
  - This is a very popular repository for managing dotfiles with Nix.
  - It was helpful in figuring out the language and a repo structure.
- [Nixos-config](https://github.com/mitchellh/nixos-config)
  - This was a nix config I really liked and found helpful when setting up my configurations.
- [NixOS-Configuration](https://github.com/TheMaxMur/NixOS-Configuration)
  - This was the most helpful repository, my structure is closely based off of this.

## License

These are just my machine configurations, I have licensed them under a completely open license with no restrictions or attribution needed if you want to use any of this. Be mindful that the software installed by this configuration is subject to it's own licensing terms.
