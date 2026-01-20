# Nix Setup Notes

This repo now includes a Nix flake scaffold inspired by ryoppippi/dotfiles.
It uses:
- `home-manager` for dotfiles + user packages
- `nix-darwin` for macOS system integration

## What to Edit First

1. `flake.nix`
   - `username` (your macOS/Linux user, e.g. `kentarowaki`)
   - `darwinConfigurations."mac"` `system` (aarch64-darwin or x86_64-darwin)
   - `homeConfigurations."linux"` `pkgs` system (x86_64-linux or aarch64-linux)

2. Clone path
   - `nix/home.nix` links dotfiles from `~/dotfiles`
   - If you keep the repo elsewhere, change `dotfilesDir` in `nix/home.nix`
3. Package profile
   - Minimal packages: `nix/profiles/minimal.nix`
   - Full packages: `nix/profiles/full.nix`
   - Switch by changing the import in `nix/home.nix`

## Install Nix

macOS:
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Linux:
```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Apply Configuration

macOS:
```
sudo nix run nix-darwin -- switch --flake .#mac
```

Linux:
```
nix run home-manager -- switch --flake .#linux
```

For convenience, this flake also exposes:
```
nix run .#switch
nix run .#build
```

## How It Works

- `nix/home.nix` installs packages (git, neovim, tmux, etc.)
- Dotfiles are linked using `home.file` and `xdg.configFile`
- `nix/darwin.nix` enables nix-daemon and sets your default shell

## macOS: Determinate Nix and nix-darwin

If you installed Nix using Determinate, it manages the Nix daemon itself.
In that case, nix-darwin must **not** manage Nix, or activation will fail.

This repo sets:
```
nix.enable = false;
```
in `nix/darwin.nix` to avoid the conflict.

### /etc/zshenv conflict

Determinate writes a Nix snippet to `/etc/zshenv`.
nix-darwin also wants to manage `/etc/zshenv`, so it aborts to avoid
overwriting something important.

Fix:
```
sudo mv /etc/zshenv /etc/zshenv.before-nix-darwin
sudo nix run nix-darwin -- switch --flake .#mac
```

If you want to keep the Determinate snippet, you can copy it into your own
shell setup after nix-darwin is applied.

### sudo HOME warning

When you run `sudo nix run ...`, macOS may warn that `$HOME` is not owned by you.
This is a warning only. If it bothers you, run:
```
sudo -E nix run nix-darwin -- switch --flake .#mac
```

## Relationship to install.sh

`install.sh` still works and can be used without Nix.
If you use Nix, you can skip `install.sh` and rely on `nix run ...` to link dotfiles.
