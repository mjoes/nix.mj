{ config, pkgs, modulesPath, ... }:

{
  imports =
    [
      # Include the default lxd configuration.
      "${modulesPath}/virtualisation/lxc-container.nix"
      ./orbstack.nix
    ];

  users.users.mortenslingsby = {
    uid = 501;
    extraGroups = [ "wheel" ];

    # simulate isNormalUser, but with an arbitrary UID
    isSystemUser = true;
    group = "users";
    createHome = true;
    home = "/home/mortenslingsby";
    homeMode = "700";
    useDefaultShell = true;
  };

  security.sudo.wheelNeedsPassword = false;

  # This being `true` leads to a few nasty bugs, change at your own risk!
  users.mutableUsers = false;

  time.timeZone = "Europe/Oslo";

  networking = {
    dhcpcd.enable = false;
    useDHCP = false;
    useHostResolvConf = false;
  };

  systemd.network = {
    enable = true;
    networks."50-eth0" = {
      matchConfig.Name = "eth0";
      networkConfig = {
        DHCP = "ipv4";
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  # Extra certificates from OrbStack.
  security.pki.certificates = [
    ''
      -----BEGIN CERTIFICATE-----
MIICDDCCAbOgAwIBAgIRALBMCJG3hMkovmV+fOtahbcwCgYIKoZIzj0EAwIwZjEd
MBsGA1UEChMUT3JiU3RhY2sgRGV2ZWxvcG1lbnQxHjAcBgNVBAsMFUNvbnRhaW5l
cnMgJiBTZXJ2aWNlczElMCMGA1UEAxMcT3JiU3RhY2sgRGV2ZWxvcG1lbnQgUm9v
dCBDQTAeFw0yNDA5MjAxODAxMzNaFw0zNDA5MjAxODAxMzNaMGYxHTAbBgNVBAoT
FE9yYlN0YWNrIERldmVsb3BtZW50MR4wHAYDVQQLDBVDb250YWluZXJzICYgU2Vy
dmljZXMxJTAjBgNVBAMTHE9yYlN0YWNrIERldmVsb3BtZW50IFJvb3QgQ0EwWTAT
BgcqhkjOPQIBBggqhkjOPQMBBwNCAATSY4nO20eIINIZO8eMjOQL/LfSFwDPxfag
PqC1V4f/Mk/5ovvN5BDPum24xKsPD+xBwM7xA4LudtGrWc52Zlwho0IwQDAOBgNV
HQ8BAf8EBAMCAQYwDwYDVR0TAQH/BAUwAwEB/zAdBgNVHQ4EFgQUmsMCZLtQEUQR
GDo/7B0smyx7/+EwCgYIKoZIzj0EAwIDRwAwRAIgLXQM4X/UDIMn2dfsFRfKzl33
CwDemhpSOAWlAbM2oBYCIAbiUkkpcjyuTOrPOebDwsnJuLrzSLatHaoMlBW/u3qy
-----END CERTIFICATE-----

    ''
  ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
