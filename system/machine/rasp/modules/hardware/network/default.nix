{ config
, ...
}:

{
  systemd.network = {
    enable = true;

    networks.eth0 = {
      matchConfig.Name = "eth0";
      address = [ "192.168.1.8/24" ];
    };
  };

  networking = {
    nameservers = [
      "192.168.1.8"
    ];

    firewall = {
      enable = true;

      allowedTCPPorts = [
        22
        53
        80
        443
        3000
        4224
        5335
        8053
        8384
      ];

      allowedUDPPorts = [
        53
        5335
      ];
    };
  };
}

