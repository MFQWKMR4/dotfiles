{ pkgs, username, ... }:
{
  nix.enable = false;

  programs.bash.enable = true;

  users.users.${username} = {
    home = "/Users/${username}";
    shell = pkgs.bashInteractive;
  };

  system.stateVersion = 4;
}
