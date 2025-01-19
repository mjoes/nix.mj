{
  description = "My nix config, running on orbstack";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.11-beta";
  };

  outputs = { self, nixpkgs }@inputs:
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
        ./orb/configuration.nix
        {
          environment.systemPackages = with pkgs; [
            neovim
            gh
            git
            ruff
            fzf
          ];
        }
      ];
    };
  };
}
