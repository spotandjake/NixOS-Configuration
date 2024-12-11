{ inputs, self }: inputs.darwin.lib.darwinSystem {
  modules = [
    # Darwin Configuration
    {
      nixpkgs.system = "aarch64-darwin";
      system = {
        configurationRevision = self.rev or self.dirtyRev or null;
        stateVersion = 5;
      };
    }
    # TODO: Secrets
    # inputs.opnix.nixosModules.default
    # ./secrets.nix
    inputs.home-manager.darwinModules.home-manager
    ./home.nix
  ];
}