{
  inputs = {
    flakelight.url = "github:nix-community/flakelight";
    flakelight-darwin.url = "github:cmacrae/flakelight-darwin";
  };
  outputs = {
    flakelight,
    flakelight-darwin,
    ...
  }:
    flakelight ./. {
      imports = [flakelight-darwin.flakelightModules.default];
      # TODO: Collect The Programs
      # TODO: Collect the Systems
      # TODO: Process with snow-system
      # TODO: Write to our outputs 
    };
}