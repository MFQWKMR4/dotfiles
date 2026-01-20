{ config, lib, pkgs, profile ? "minimal", ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/dotfiles";
  link = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${path}";
in
{
  imports = if profile == "full" then [ ./profiles/full.nix ] else [ ./profiles/minimal.nix ];

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.file.".bashrc".source = link "bash/.bashrc";
  home.file.".bash_profile".source = link "bash/.bash_profile";
  home.file.".bash_aliases".source = link "bash/.bash_aliases";

  home.file.".gitconfig".source = link "git/.gitconfig";
  home.file.".gitconfig-work".source = link "git/.gitconfig-work";
  home.file.".gitconfig-personal".source = link "git/.gitconfig-personal";
  home.file.".gitignore_global".source = link "git/.gitignore_global";

  home.file.".tmux.conf".source = link "tmux/.tmux.conf";

  home.file.".local/bin/git-profile".source = link "bin/git-profile";

  xdg.configFile."nvim".source = link "nvim";
}
