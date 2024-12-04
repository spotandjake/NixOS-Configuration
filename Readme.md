- Setup nix parts

# Guides

https://nixcademy.com/posts/nix-on-macos/
https://github.com/spotandjake/NixOS-Configuration/blob/main/lib/default.nix

# Steps left

- [ ] Load my packages
  - [ ] devShell
    - [ ] iterm2
      - should i look at using a different terminal??
    - [ ] git
      - [ ] signing key
      - [ ] gpg - how does this all work
        - I want the pinetry prompt for sure
    - [ ] vscode
      - [x] Install
      - [ ] extensions
      - [ ] theme
      - [ ] login
      - [ ] cleanup config
    - [ ] nix your shell
    - [ ] direnv
    - [ ] nushell
      - [x] Install
      - [ ] auto configs
      - [ ] move environmental variable stuff to nix
  - [ ] workStation
    - [ ] whatsapp
    - [ ] arc browser
      - [ ] Install
      - [ ] where are the settings?
    - [ ] gitkraken
      - [x] Install
      - [ ] are there any settings?
    - [ ] office
  - [ ] darwin
    - [ ] lunar
    - [ ] raycast
      - [x] Install
      - [ ] how to handle configuration?
- [ ] passkeys?????
- [ ] setup github workflows
- [ ] make a nice readme
- [ ] programming languages configurations
  - I am yet to figure out how this will look
    - Do I want to install these globally or just have them under nix develop?
    - would templates for flakes be better and do them per process?
  - [ ] dotnet
  - [ ] grain
  - [ ] node
    - [ ] yarn
- [ ] system
  - [ ] dock
  - [ ] settings
    - [ ] keybinds
    - [ ] other settings??? (Is there anyway i can get a list of the changes)
  - [ ] set the commit reference
- [ ] Figure out homebrew management
- [ ] Fix templates
  - [ ] actually add the folder
  - [ ] TODO: learn how to use the templates
- [ ] Commands for adding new items to nix
  - Nix might have tools already or we could probably make a manager for our nix configs
  - add new app
  - enable (Maybe done through raycast and a cli)
- [ ] Use nix overlays from initial configuration
- [ ] Load darwin configurations
- [ ] Look into sops
  - [ ] Do I use 1password instead????
- [ ] Look into impersistance
- [ ] Validate configuration (start uninstalling stuff and see if it comes back with nix)
- [ ] figure out symlinking into launchpad...
- [ ] cleanup all my configurations
  - [ ] I should go through all my configurations and make sure they are how i like them
- [ ] Reset mac

https://github.com/oppiliappan/statix
