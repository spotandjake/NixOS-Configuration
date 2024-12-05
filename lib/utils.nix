let
  getPlatform = platform:
    if platform == "aarch64-darwin" || platform == "x86_64-darwin" then
      "darwin"
    else
      platform;
in
{
  inherit getPlatform;
  isPlatform = systemPlatform: targetPlatform: getPlatform systemPlatform == targetPlatform;
}