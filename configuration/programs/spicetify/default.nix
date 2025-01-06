{ inputs, config, pkgs, lib, ... }:
with lib;
let
  name = "spicetify";
  cfg = config.program."${name}";
in {
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];
  options.program.${name} = {
    enable = mkEnableOption "Enables ${name}";
  };
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      spotify
    ];

    programs.spicetify =
      let
        spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
      in
      {
        enable = true;
        spotifyPackage = pkgs.spotify;

        # theme = spicePkgs.themes.lucid;
        # colorScheme = "dark-bloom";

        enabledExtensions = with spicePkgs.extensions; [
          fullScreen
          adblock
          autoVolume
          addToQueueTop
          betterGenres
          copyToClipboard
          fullAlbumDate
          goToSong
          groupSession
          hidePodcasts
          history
          keyboardShortcut
          listPlaylistsWithSong
          loopyLoop
          phraseToPlaylist
          playNext
          playlistIcons
          playlistIntersection
          popupLyrics
          savePlaylists
          showQueueDuration
          shuffle # shuffle+
          skipStats
          songStats
          volumePercentage
        ];
      };
  };
}