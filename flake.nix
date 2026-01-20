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
      linuxUsername =
        let
          envUser = builtins.getEnv "USER";
        in
        if envUser != "" then envUser else "ubuntu";
      linuxHome = "/home/${linuxUsername}";

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

      mkDarwin =
        profile:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit username darwinHome; };
          modules = [
            ./nix/darwin.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "before-nix";
              home-manager.extraSpecialArgs = { inherit profile; };
              home-manager.users.${username} = import ./nix/home.nix;
              users.users.${username}.home = darwinHome;
            }
          ];
        };

      mkLinux =
        profile:
        home-manager.lib.homeManagerConfiguration {
          pkgs = mkPkgs "x86_64-linux";
          extraSpecialArgs = { inherit linuxUsername linuxHome profile; };
          modules = [
            ./nix/home.nix
            {
              home.username = linuxUsername;
              home.homeDirectory = linuxHome;
            }
          ];
        };
    in
    {
      darwinConfigurations."mac" = mkDarwin "full";
      darwinConfigurations."mac-full" = mkDarwin "full";
      darwinConfigurations."mac-minimal" = mkDarwin "minimal";

      homeConfigurations."linux" = mkLinux "minimal";
      homeConfigurations."linux-minimal" = mkLinux "minimal";
      homeConfigurations."linux-full" = mkLinux "full";

      apps."aarch64-darwin".switch = mkApp "aarch64-darwin" "dotfiles-switch" ''
        exec sudo nix run nix-darwin -- switch --flake .#mac
      '';

      apps."aarch64-darwin".switch-minimal = mkApp "aarch64-darwin" "dotfiles-switch-minimal" ''
        exec sudo nix run nix-darwin -- switch --flake .#mac-minimal
      '';

      apps."aarch64-darwin".switch-full = mkApp "aarch64-darwin" "dotfiles-switch-full" ''
        exec sudo nix run nix-darwin -- switch --flake .#mac-full
      '';

      apps."aarch64-darwin".build = mkApp "aarch64-darwin" "dotfiles-build" ''
        exec nix run nix-darwin -- build --flake .#mac
      '';

      apps."aarch64-darwin".build-minimal = mkApp "aarch64-darwin" "dotfiles-build-minimal" ''
        exec nix run nix-darwin -- build --flake .#mac-minimal
      '';

      apps."aarch64-darwin".build-full = mkApp "aarch64-darwin" "dotfiles-build-full" ''
        exec nix run nix-darwin -- build --flake .#mac-full
      '';

      apps."x86_64-linux".switch = mkApp "x86_64-linux" "dotfiles-switch" ''
        exec nix run home-manager -- switch --flake .#linux --impure
      '';

      apps."x86_64-linux".switch-minimal = mkApp "x86_64-linux" "dotfiles-switch-minimal" ''
        exec nix run home-manager -- switch --flake .#linux-minimal --impure
      '';

      apps."x86_64-linux".switch-full = mkApp "x86_64-linux" "dotfiles-switch-full" ''
        exec nix run home-manager -- switch --flake .#linux-full --impure
      '';

      apps."x86_64-linux".build = mkApp "x86_64-linux" "dotfiles-build" ''
        exec nix run home-manager -- build --flake .#linux --impure
      '';

      apps."x86_64-linux".build-minimal = mkApp "x86_64-linux" "dotfiles-build-minimal" ''
        exec nix run home-manager -- build --flake .#linux-minimal --impure
      '';

      apps."x86_64-linux".build-full = mkApp "x86_64-linux" "dotfiles-build-full" ''
        exec nix run home-manager -- build --flake .#linux-full --impure
      '';
    };
}
