# TODO

- Cleanup
  - Move more logic into the templating engine
  - Perform All Validation While Parsing
  - Cleanup Repo
  - Update Readme
  - Make a nix Derivation for the builder
    - rename the builder to system-config
    - make the main command build
- features
  - impermanance
    - set this up as a home manager module
  - opnix
    - this will run as a darwin or nix os mos module
  - darwin
    - add the ability to set options
  - nixos
    - setup nixos configuration mirroring darwin
  - home manager
    - improve the program configuration to be managed

1. Add home-manager configurations
2. Add darwin configuration options
3. Homebrew integration
4. Cleanup repo
5. Add impermanace
6. Add opnix
7. Configure nixos
8. How do i correctly package the deno app for nix?
9. Refactor application
   1. move more logic into templating
   2. use more of the nix module system (It would be nice if the builder was just managing json files at the end)
   3. system-config build ./repo -o ./out
10. Update Readme
