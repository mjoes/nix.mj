{
  description = "My nix config, running on orbstack";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.11-beta";
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }@inputs:
  let 
    system = "aarch64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    nixosConfigurations.mj = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = inputs;
      modules = [
        home-manager.nixosModules.home-manager
        ./hardware/configuration.nix
        {
          programs.starship.enable = true;
          users.users.mj.isNormalUser = true;
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mj = {
            home.stateVersion = "24.11";
            programs.fzf.enable = true;
          };
        }
        {
          nix.extraOptions = ''
            experimental-features = nix-command flakes
          '';
          environment.systemPackages = with pkgs; [
            neovim
            gh
            git
            ruff
            lazygit
            go
            gopls
            python3Packages.jedi-language-server
            lua-language-server
            nixd
            ripgrep
          ];
          fonts.packages = with pkgs; [
            (nerdfonts.override { fonts = [ "Hack" ];})
            fira-code
          ];
        }
      ];
    };
  };
}
