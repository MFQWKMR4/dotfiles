{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bashInteractive
    git
    neovim
    tmux
    ripgrep
    fd
    fzf
    less
  ];
}
