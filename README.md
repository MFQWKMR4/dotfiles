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

## Nix (optional)
This repo includes a Nix flake scaffold inspired by ryoppippi/dotfiles.
See `docs/NIX.md` for setup and customization.

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
