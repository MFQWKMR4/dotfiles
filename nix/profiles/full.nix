{ pkgs, ... }:
{
  imports = [
    ./minimal.nix
  ];

  home.packages = with pkgs; [
    bat
    rustup
    pkg-config
    openssl
    eza
    qemu
    cloud-utils # For cloud-localds in scripts/qemu-ubuntu-arm64.sh
  ];
}
