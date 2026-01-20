# dotfiles

Cross-platform dotfiles for macOS + Linux (EC2). Bash + Git profile split + LazyVim.

## Setup
1. Edit Git profiles:
   - `git/.gitconfig-work`
   - `git/.gitconfig-personal`
2. Install links:
   ```sh
   ./install.sh
   ```
3. Set the Git profile for this machine:
   ```sh
   git-profile personal
   git-profile work
   ```

## install.sh (what it does)
`install.sh` creates symlinks from this repo to your home directory.
Use it when you are **not** using Nix. It links:
- `bash/` -> `~/.bashrc` `~/.bash_profile` `~/.bash_aliases`
- `git/` -> `~/.gitconfig*` `~/.gitignore_global`
- `nvim/` -> `~/.config/nvim`
- `tmux/` -> `~/.tmux.conf`
- `bin/git-profile` -> `~/.local/bin/git-profile`

## Nix (optional)
This repo includes a Nix flake scaffold inspired by ryoppippi/dotfiles.
If you want to use Nix, install it first:
```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
Then:
1. macOS apply (nix-darwin + Home Manager)
   ```sh
   sudo nix run nix-darwin -- switch --flake .#mac
   ```
2. Linux apply (Home Manager, uses `$USER`)
   ```sh
   nix run home-manager -- switch -b before-nix --flake .#linux --impure
   ```

### Package profiles (minimal/full)
Packages are split into profiles. Use the flake target you want.

Linux:
```sh
# Minimal
nix run home-manager -- switch -b before-nix --flake .#linux-minimal --impure
# Full
nix run home-manager -- switch -b before-nix --flake .#linux-full --impure
```

macOS:
```sh
# Minimal
sudo nix run nix-darwin -- switch --flake .#mac-minimal
# Full
sudo nix run nix-darwin -- switch --flake .#mac-full
```

See `docs/NIX.md` for details and troubleshooting.

## QEMU (Apple Silicon quick Linux)
Script: `scripts/qemu-ubuntu-arm64.sh`

Example:
```sh
SSH_PUBKEY=~/.ssh/id_ed25519.pub ./scripts/qemu-ubuntu-arm64.sh
ssh -p 2222 ubuntu@127.0.0.1
```

## Neovim (LazyVim)
`nvim/init.lua` bootstraps LazyVim via `lazy.nvim`.

Requirements:
- `nvim` 0.9+
- `git`

First launch will clone plugins automatically.

## Notes
- Bash config lives in `bash/`
- Git config lives in `git/`
- Neovim config lives in `nvim/`
- tmux config lives in `tmux/`
- `~/.gitconfig-local` controls the active Git profile per machine
