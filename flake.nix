{
  description = "dotfiles with home-manager and nix-darwin";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      username = "kentarowaki";
      darwinHome = "/Users/${username}";
      linuxHome = "/home/${username}";

      mkPkgs = system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

      mkApp =
        system: name: text: {
          type = "app";
          program = "${(mkPkgs system).writeShellApplication {
            inherit name text;
          }}/bin/${name}";
        };
    in
    {
      darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        specialArgs = { inherit username darwinHome; };
        modules = [
          ./nix/darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "before-nix";
            home-manager.users.${username} = import ./nix/home.nix;
            users.users.${username}.home = darwinHome;
          }
        ];
      };

      homeConfigurations."linux" = home-manager.lib.homeManagerConfiguration {
        pkgs = mkPkgs "x86_64-linux";
        extraSpecialArgs = { inherit username linuxHome; };
        modules = [
          ./nix/home.nix
          {
            home.username = username;
            home.homeDirectory = linuxHome;
          }
        ];
      };

      apps."aarch64-darwin".switch = mkApp "aarch64-darwin" "dotfiles-switch" ''
        exec sudo nix run nix-darwin -- switch --flake .#mac
      '';

      apps."aarch64-darwin".build = mkApp "aarch64-darwin" "dotfiles-build" ''
        exec nix run nix-darwin -- build --flake .#mac
      '';

      apps."x86_64-linux".switch = mkApp "x86_64-linux" "dotfiles-switch" ''
        exec nix run home-manager -- switch --flake .#linux
      '';

      apps."x86_64-linux".build = mkApp "x86_64-linux" "dotfiles-build" ''
        exec nix run home-manager -- build --flake .#linux
      '';
    };
}
