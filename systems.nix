{ users }: [
  {
    name  = "JakesMacBook";
    user  = users.spotandjake; 
    linux-builder = false;
    specs = {
      platform = "aarch64-darwin";
      cpu      = "Apple M1";
      memory   = 8192; # MB
      storage  = 256; # GB
    };
  }
]